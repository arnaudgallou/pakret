regex <- list(
  placeholder = "\\B:[a-z]+\\b"
)

eol <- function() {
  if (.Platform$OS.type == "unix") "\n" else "\r\n"
}

bib_name <- function(x) {
  sub("\\.bib$", "", basename(x))
}

extract <- function(x, pattern) {
  locs <- gregexpr(pattern, x, perl = TRUE)
  regmatches(x, locs)[[1]]
}

extract_refs <- function() {
  bib <- bib_read()
  refs <- extract(bib, "(?mi)^@[a-z]+\\{\\K[^,]+")
  if (is_empty(refs)) {
    return()
  }
  refs
}

as_pkg <- function(x) {
  if (is_r(x)) {
    return(as_r())
  }
  class(x) <- "pkg"
  x
}

as_r <- function() {
  structure("base", class = "r")
}

bib_init <- function() {
  check_bibliography()
  set(
    items = list(),
    append = FALSE,
    file = bib_fetch(),
    refs = extract_refs()
  )
}

bib_fetch <- function() {
  bibs <- rmarkdown::metadata$bibliography
  names(bibs) <- bib_name(bibs)
  file <- bibs[[get("bib")]]
  check_bib(file, arg = file)
  get_path(file)
}

bib_read <- function() {
  out <- readr::read_file(get("file"))
  if (!is_blank(out)) {
    set(append = TRUE)
  }
  out
}

bib_write <- function() {
  if (is_empty(get("items"))) {
    return(invisible())
  }
  lines <- make_lines()
  readr::write_file(lines, get("file"), append = get("append"))
}

make_lines <- function() {
  eol <- eol()
  out <- paste(get("items"), collapse = strrep(eol, 2L))
  if (get("append")) {
    out <- paste0(eol, out)
  }
  paste0(out, eol)
}

cast <- function(x, items) {
  template <- get(x)
  do.call(sprintf, c(as_sprintf(template), items[vars(template)]))
}

as_sprintf <- function(x) {
  gsub(regex$placeholder, "%s", x, perl = TRUE)
}

vars <- function(x) {
  extract(x, "(?<=\\B:)[a-z]+\\b")
}

get_version <- function(x) {
  unname(getNamespaceVersion(x))
}

add_ref <- function(x) {
  if (is_referenced(x)) {
    return()
  }
  set(
    items = append(get_citation(x), to = "items"),
    refs = append(x, to = "refs")
  )
}

append <- function(x, to) {
  c(get(to), x)
}

get_citation <- function(x) {
  ref <- utils::citation(x)
  ref <- format(ref, style = "bibtex")
  if (length(ref) > 1L) {
    ref <- pick_citation(ref)
  }
  insert_pkg_key(ref, key = x)
}

pick_citation <- function(x) {
  if (has_manual(x)) {
    return(pick_manual(x))
  }
  x[[1]]
}

pick_manual <- function(x) {
  x[is_manual(x)]
}

insert_pkg_key <- function(x, key) {
  sub("^@[^{]+\\{\\K(?=,)", key, x, perl = TRUE)
}

get_path <- function(x) {
  if (!is_partial_path(x)) {
    return(x)
  }
  path_ls <- dir(pattern = basename(x), recursive = TRUE)
  x <- path_ls[grepl(x, path_ls, fixed = TRUE)]
  if (is_empty(x)) path_ls else x
}

cite <- function(x, template = class(x)) {
  if (is_rendering_context()) {
    add_ref(x)
  }
  make_citation(x, template = template)
}

make_citation <- function(x, ...) {
  UseMethod("make_citation")
}

make_citation.default <- function(x, ..., template) {
  cast(template, pkg_details(x))
}

make_citation.r <- function(x, ...) {
  cast("r", list(
    ver = get_version("base"),
    ref = "@base"
  ))
}

pkg_details <- function(pkg) {
  list(
    pkg = pkg,
    ver = get_version(pkg),
    ref = paste0("@", pkg)
  )
}
