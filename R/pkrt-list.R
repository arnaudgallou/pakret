#' @title Cite a collection of R packages
#' @description Creates a list of package citations that can be turned into a
#'   character string or data frame. This function should normally only be used
#'   in an R Markdown or Quarto document, in which case `pkrt_list()`
#'   automatically references the cited packages in the first (by default)
#'   `.bib` file specified in the YAML header if no references of the packages
#'   already exist.
#' @param ... Character vectors, separated by commas, of packages to cite.
#' @details
#' This function automatically discards duplicate and base packages. You can use
#' `pkrt_list()` in combination with `renv::dependencies()` to cite all the
#' packages used in a project or directory.
#' @returns A list of package citations with S3 class `pkrt_list`.
#' @examples
#' # Create a list of citations
#' citations <- pkrt_list("pakret", "readr", "withr")
#'
#' # You can then turn the citations into a character string
#' paste(citations, collapse = ", ")
#'
#' # Or a data frame
#' as.data.frame(citations)
#' @export
pkrt_list <- function(...) {
  pkgs <- unique(c(...))
  check_character(pkgs, arg = "...")
  pkgs <- drop_base(pkgs)
  itemize_citations(pkgs)
}

drop_base <- function(x) {
  x[!x %in% base_pkgs()]
}

base_pkgs <- function() {
  if (getRversion() >= "4.4.0") {
    return(asNamespace("tools")$standard_package_names()[["base"]])
  }
  c(
    "base", "compiler", "datasets", "graphics", "grDevices", "grid", "methods",
    "parallel", "splines", "stats", "stats4", "tcltk", "tools", "utils"
  )
}

itemize_citations <- function(pkgs) {
  names(pkgs) <- pkgs
  citations <- lapply(pkgs, function(pkg) {
    citation <- cite(pkg, template = "pkg_list")
    attributes(citation) <- pkg_details(pkg)
    citation
  })
  add_class(citations, "pkrt_list")
}

#' @export
as.data.frame.pkrt_list <- function(x, ...) {
  x <- do.call(rbind.data.frame, lapply(x, attributes))
  row.names(x) <- NULL
  names(x) <- c("Package", "Version", "Reference")
  x
}

#' @export
print.pkrt_list <- function(x, ...) {
  x <- lapply(x, unstructure)
  NextMethod()
}

unstructure <- function(x) {
  attributes(x) <- NULL
  x
}
