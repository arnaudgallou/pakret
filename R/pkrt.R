#' @title Cite R or an R package
#' @description Creates a preformatted citation of R or an R package. This
#'   function should normally only be used in an R Markdown or Quarto document,
#'   in which case `pkrt()` automatically references the cited package in the
#'   first (by default) `.bib` file specified in the YAML header if no
#'   references of the package already exist.
#' @param x A string of the package to cite. Use `pkrt("R")` to cite R.
#' @returns A character string.
#' @examples
#' pkrt("pakret")
#' @export
pkrt <- function(x) {
  check_character(x)
  cite(as_pkg(x))
}
