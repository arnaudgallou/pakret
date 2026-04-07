add_class <- function(x, cls) {
  class(x) <- cls
  x
}

.__settings__ <- list(
  bib = add_class(1L, "bib"),
  pkg = add_class("the ':pkg' package version :ver [:ref]", "template"),
  pkg_list = add_class("':pkg' v. :ver [:ref]", "template"),
  r = add_class("R version :ver [:ref]", "template")
)

.__pakret__ <- new.env(parent = emptyenv())

set <- function(..., .add = FALSE) {
  items <- eval(substitute(alist(...)))
  for (key in names(items)) {
    .__pakret__[[key]] <- eval_set(items, key, .add)
  }
}

eval_set <- function(x, key, add, envir = parent.frame(2L)) {
  x <- eval(x[[key]], envir = envir)
  if (is_string(x) && has_placeholder(x)) {
    x <- list(str = as_sprintf(x), vars = vars(x))
  }
  if (add) {
    x <- c(get(key), x)
  }
  x
}

get <- function(x) {
  .__pakret__[[x]]
}
