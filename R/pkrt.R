#' @title Cite R, an R package or object
#' @description Creates a preformatted citation of an R package or object. This
#'   function should normally only be used in an R Markdown or Quarto document,
#'   in which case `pkrt()` automatically references the cited package in the
#'   first (by default) `.bib` file specified in the YAML header if no
#'   references of the package already exist.
#' @param expr A string or unquoted expression of the package or object to cite.
#'   When citing an object, the expression must be in the form `pkg::object`.
#'
#'   Use `pkrt(R)` to cite R.
#' @param object_type A string that describes the type of the object to cite.
#' @returns A character string.
#' @examples
#' pkrt(pakret)
#'
#' pkrt(pakret::pkrt)
#' @export
pkrt <- function(expr, object_type = "function") {
  items <- parse_expr(substitute(expr))
  check_items(items)
  check_string(object_type)
  cite(items, type = object_type)
}
