#' @title Cite a collection of R packages
#' @description Creates a list of package citations that can be turned into a
#'   character string or data frame. This function should normally only be used
#'   in an R Markdown or Quarto document, in which case `pkrt_list()`
#'   automatically references the cited packages in the first (by default)
#'   `.bib` file specified in the YAML header if no references of the packages
#'   already exist.
#' @param ... Character vectors, separated by a comma, of packages to cite.
#' @details
#' This function automatically discards duplicate and base packages. I recommend
#' using `pkrt_list()` in combination with `renv::dependencies()` to cite all
#' the packages used in a project.
#' @return A list of package citations.
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
  check_character(pkgs)
  pkgs <- drop_base(pkgs)
  itemize_citations(pkgs)
}

drop_base <- function(x) {
  x[!x %in% get_base_pkgs()]
}

get_base_pkgs <- function() {
  rownames(utils::installed.packages(.Library, priority = "base"))
}

itemize_citations <- function(pkgs) {
  names(pkgs) <- pkgs
  citations <- lapply(pkgs, function(pkg) {
    citation <- cite(pkg, template = "pkg_list")
    attributes(citation) <- pkg_details(pkg)
    citation
  })
  as_pkrt_list(citations)
}

as_pkrt_list <- function(x) {
  structure(x, class = c("pkrt_list", "list"))
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
