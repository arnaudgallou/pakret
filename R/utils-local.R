dedent <- function(x) {
  indentation <- sub("(?s)\\S*\\R(\\s*).+", "\\1", x, perl = TRUE)
  x <- gsub(paste0("(?m)^", indentation), "", x, perl = TRUE)
  trimws(x)
}

render <- function(...) {
  rmarkdown::render(..., output_format = "md_document", quiet = TRUE)
}

local_rmd <- function(lines = "", ...) {
  withr::local_tempfile(lines = lines, fileext = ".Rmd", ...)
}

local_bib <- function(lines, ...) {
  dir <- withr::local_tempfile(lines = lines, fileext = ".bib", ...)
  basename(dir)
}

local_bibs <- function(lines, n, ...) {
  if (n == 1L) {
    return(local_bib(lines, ...))
  }
  nms <- paste0("file_", seq_len(n))
  lapply(nms, function(nm) local_bib(lines, pattern = nm, ...))
}

insert_bibs <- function(lines, bibs) {
  if (length(bibs) > 1L) {
    bibs <- sprintf("[%s]", paste(bibs, collapse = ", "))
  }
  sprintf(lines, bibs)
}

local_files <- function(rmd_lines, bib_lines = "", n_bib = 1L, env = parent.frame()) {
  dir <- withr::local_tempdir(.local_envir = env)
  if (!is.null(n_bib)) {
    bibs <- local_bibs(bib_lines, n = n_bib, tmpdir = dir, .local_envir = env)
    rmd_lines <- insert_bibs(rmd_lines, bibs)
  }
  rmd <- local_rmd(rmd_lines, tmpdir = dir, .local_envir = env)
  with_pakret_error(callr::r(render, list(input = rmd)))
  invisible(dir)
}

with_pakret_error <- function(expr) {
  tryCatch(expr, error = function(e) stop(e$parent))
}

read_local_file <- function(dir, target = "md") {
  items <- strsplit(target, ".", fixed = TRUE)[[1]]
  if (length(items) == 1L) {
    items <- c("", items)
  }
  pattern <- do.call(sprintf, c("^%s.+\\.%s$", as.list(items)))
  file <- list.files(dir, pattern = pattern, full.names = TRUE)
  readr::read_file(file)
}

local_pkg <- function(Package, ..., bib_entries = NULL, env = parent.frame()) {
  dir <- withr::local_tempdir(.local_envir = env)
  withr::local_libpaths(dir, action = "prefix", .local_envir = env)
  pkg_path <- file.path(dir, Package)
  usethis::ui_silence(
    usethis::create_package(
      path = pkg_path,
      fields = list(Type = "Package", Package = Package, ...),
      rstudio = FALSE,
      open = FALSE
    )
  )
  if (!is.null(bib_entries)) {
    add_bib_entries(pkg_path, bib_entries)
  }
  load_pkg(pkg_path, env)
}

add_bib_entries <- function(dir, types) {
  path <- file.path(dir, "inst", "CITATION")
  dir.create(dirname(path))
  readr::write_file(
    make_bib_entries(types),
    path
  )
}

make_bib_entries <- function(types) {
  bib <- 'bibentry("%s", title = "title", author = "authors", year = "year",%s)'
  entries <- lapply(types, function(type) {
    sprintf(bib, type, switch_bib_field(type))
  })
  collapse(entries)
}

switch_bib_field <- function(x) {
  switch(x,
    Article = bib_field("journal"),
    Book = bib_field("publisher"),
    ""
  )
}

bib_field <- function(name) {
  sprintf('%s = "%s"', name, name)
}

load_pkg <- function(path, env) {
  withr::defer(pkgload::unload(basename(path), quiet = TRUE), envir = env)
  pkgload::load_all(path, export_all = FALSE, quiet = TRUE)
}

load_foo <- function(..., env = parent.frame()) {
  local_pkg(
    Package = "foo",
    Title = "Alea Jacta Est",
    `Authors@R` = c(
      utils::person("Caius", "Fastandfurius", role = "aut"),
      utils::person("Numerius", "Clausus", role = "aut"),
      utils::person("Marcus", "Lastopus", role = "aut")
    ),
    Version = "1.0.0",
    Date = "2020-01-01",
    ...,
    env = env
  )
}

load_bar <- function(..., env = parent.frame()) {
  local_pkg(
    Package = "bar",
    Title = "Tempus Edax Rerum",
    `Authors@R` = utils::person("Julius", "Itisalapsus", role = "aut"),
    Version = "0.2.0",
    Date = "2024-01-01",
    ...,
    env = env
  )
}
