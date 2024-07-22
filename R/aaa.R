.__settings__ <- list(
  sep = " ",
  bib = 1L,
  obj_first = TRUE,
  obj = "the ':obj' :type from",
  pkg = "the ':pkg' package version :ver [:ref]",
  pkg_list = "':pkg' v. :ver [:ref]",
  r = "R version :ver [:ref]"
)

.__pakret__ <- new.env(parent = emptyenv())

set <- function(...) {
  items <- eval(substitute(alist(...)))
  for (key in names(items)) {
    .__pakret__[[key]] <- eval(items[[key]], envir = parent.frame())
  }
}

get <- function(x) {
  .__pakret__[[x]]
}
