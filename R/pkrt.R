#' @title Cite R or an R package
#' @description Creates a preformatted citation of R or an R package. This
#'   function should normally only be used in an R Markdown or Quarto document,
#'   in which case `pkrt()` automatically references the cited package in the
#'   first (by default) `.bib` file specified in the YAML header if no
#'   references of the package already exist.
#' @param pkg Name of the package to cite. You can use `"R"` as an alias for the
#'   base package to cite R.
#' @returns A character string.
#' @examples
#' pkrt("pakret")
#'
#' pkrt("R")
#' @export
pkrt <- function(pkg) {
  check_character(pkg)
  cite(as_pkg(pkg))
}
