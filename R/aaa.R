.__settings__ <- list(
  bib = 1L,
  pkg = "the ':pkg' package version :ver [:ref]",
  pkg_list = "':pkg' v. :ver [:ref]",
  r = "R version :ver [:ref]"
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
