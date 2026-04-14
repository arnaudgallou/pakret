#' @title Cite R or an R package
#' @description Creates a preformatted citation for R or an R package. This
#'   function is normally used within an R Markdown or Quarto document, where
#'   `pkrt()` automatically references the cited package to the first (by
#'   default) `.bib` file specified in the YAML header if no reference for the
#'   package already exists.
#' @param pkg Name of the package to cite. You can use `"R"` as an alias for the
#'   base package to cite R.
#' @returns A character string with S3 class `AsIs`.
#' @examples
#' pkrt("pakret")
#'
#' pkrt("R")
#' @export
pkrt <- function(pkg) {
  check_string(pkg)
  cite(as_pkg(pkg))
}
