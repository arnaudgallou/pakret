.regex <- list(
  placeholder = "\\B:[a-z]+\\b"
)

eol <- function() {
  if (.Platform$OS.type == "unix") "\n" else "\r\n"
}

collapse <- function(x) {
  paste(x, collapse = strrep(eol(), 2L))
}

bib_name <- function(x) {
  sub("(?i)\\.bib$", "", basename(x))
}

extract <- function(x, pattern) {
  locs <- gregexpr(pattern, x, perl = TRUE)
  regmatches(x, locs)[[1]]
}

as_pkg <- function(x) {
  if (is_r(x)) {
    return(as_r())
  }
  add_class(x, "pkg")
}

as_r <- function() {
  add_class("base", cls = "r")
}

add_class <- function(x, cls) {
  class(x) <- cls
  x
}

bib_init <- function() {
  check_bibliography()
  bib_set()
}

bib_set <- function() {
  set(
    refs = list(),
    append = FALSE,
    file = bib_fetch(),
    keys = extract_keys()
  )
}

bib_fetch <- function() {
  bibs <- get("bibliography")
  names(bibs) <- bib_name(bibs)
  file <- bibs[[get("bib")]]
  check_bib(file, arg = file)
  get_path(file)
}

get_path <- function(x) {
  dir <- knitr::opts_knit$get("output.dir")
  file.path(dir, x)
}

extract_keys <- function() {
  bib <- bib_read()
  keys <- extract(bib, "(?mi)^@[a-z]+\\{\\K[^,]+")
  if (is_empty(keys)) {
    return()
  }
  keys
}

bib_read <- function() {
  out <- readr::read_file(get("file"))
  if (!is_blank(out)) {
    set(append = TRUE)
  }
  out
}

bib_write <- function() {
  if (is_empty(get("refs"))) {
    return(invisible())
  }
  lines <- make_lines()
  readr::write_file(lines, get("file"), append = get("append"))
}

make_lines <- function() {
  eol <- eol()
  out <- collapse(get("refs"))
  if (get("append")) {
    out <- paste0(eol, out)
  }
  paste0(out, eol)
}

add_ref <- function(x) {
  if (is_referenced(x)) {
    return()
  }
  set(
    refs = get_reference(x),
    keys = x,
    .add = TRUE
  )
}

get_reference <- function(x) {
  ref <- utils::citation(x)
  ref <- format(ref, style = "bibtex")
  if (length(ref) > 1L) {
    ref <- pick_reference(ref)
  }
  ref_normalize(ref, key = x)
}

pick_reference <- function(x) {
  for (type in c("manual", "book")) {
    if (has_bibtex(x, type)) {
      x <- pick_bibtex(x, type)
      break
    }
  }
  x[[1]]
}

pick_bibtex <- function(x, type) {
  x[bibtex_is(x, type)]
}

ref_normalize <- function(ref, key) {
  ref <- insert_key(ref, key)
  protect_case(ref, key)
}

insert_key <- function(x, key) {
  sub("^@[^{]+\\{\\K[^,]*", key, x, perl = TRUE)
}

protect_case <- function(x, key) {
  x <- strsplit(x, eol(), fixed = TRUE)[[1]]
  title <- grep("title =", x, fixed = TRUE)
  pattern <- sprintf("((?<!: |\\{)\\b[A-Z]\\b|%s(?!\\}))", key)
  x[title] <- gsub(pattern, "{\\1}", x[[title]], perl = TRUE)
  paste(x, collapse = eol())
}

cite <- function(x, template = class(x)) {
  check_pkg(x)
  if (is_rendering()) {
    add_ref(x)
  }
  cast(template, pkg_details(x))
}

cast <- function(x, items) {
  template <- get(x)
  do.call(sprintf, c(template$str, items[template$vars]))
}

as_sprintf <- function(x) {
  gsub(.regex$placeholder, "%s", x, perl = TRUE)
}

vars <- function(x) {
  extract(x, "(?<=\\B:)[a-z]+\\b")
}

pkg_details <- function(pkg) {
  list(
    pkg = pkg,
    ver = get_version(pkg),
    ref = paste0("@", pkg)
  )
}

get_version <- function(x) {
  as.character(utils::packageVersion(x))
}
