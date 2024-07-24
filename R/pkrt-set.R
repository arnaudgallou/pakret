#' @title Configure pakret's settings
#' @description This function allows you to configure pakret's settings, e.g. to
#'   customize citation templates or control which `.bib` file to save
#'   references to.
#' @param ... Key-value pairs, separated by commas, of parameters to set. See
#'   details.
#' @details
#' Valid parameters are:
#' `r make_pkrt_set_details()`
#'
#' New settings only apply to citations that come after `pkrt_set()`. This means
#' that you can redefine the same settings multiple times in the same document
#' to alter pakret's behavior for a few specific citations only.
#'
#' Use `NULL` to reset a parameter to its default value.
#' @examples
#' pkrt_set(pkg = ":pkg (v. :ver) :ref")
#' pkrt("pakret")
#'
#' # `NULL` resets parameters to their default value
#' pkrt_set(pkg = NULL)
#' pkrt("pakret")
#' @export
pkrt_set <- function(...) {
  items <- list(...)
  check_named(items, arg = "...")
  for (key in names(items)) {
    update_setting(key, items[[key]])
  }
}

update_setting <- function(key, value) {
  check_unit_set(value, arg = key)
  if (is.null(value)) {
    return(reset(key))
  }
  names(value) <- key
  class(value) <- if (is_template(key)) "template" else key
  set_option(value)
}

get_template_keys <- function() {
  x <- .__settings__
  names(x)[grepl(regex$placeholder, x, perl = TRUE)]
}

template_keys <- get_template_keys()

reset <- function(x) {
  update(.__settings__[x])
}

update <- function(x) {
  do.call(set, as.list(x))
}

set_option <- function(x) {
  UseMethod("set_option")
}

set_option.default <- function(x) {
  abort("`%s` isn't a valid setting.", names(x))
}

set_option.template <- function(x) {
  check_template(x, arg = names(x))
  update(x)
}

set_option.bib <- function(x) {
  if (!is_rendering_context()) {
    return(invisible())
  }
  check_option_bib(x, arg = names(x))
  if (is.character(x)) {
    x[] <- bib_name(x)
  }
  check_bib_target(x)
  set(bib = x, file = bib_fetch())
}

# doc ----

layout <- "
  * **%s**<br>
    `<%s> = %s`<br>
    %s
"

make_pkrt_set_details <- function() {
  out <- lapply(names(details), function(key, value = details[[key]]) {
    default <- .__settings__[[key]]
    if (!is.list(value)) {
      value <- as.list(value)
    }
    if (is.null(value$type)) {
      value$type <- typeof(default)
    }
    sprintf(dedent(layout), key, value$type, deparse(default), value[[1]])
  })
  paste(out, collapse = "\n\n")
}

details <- list(
  bib = list(
    "Name or index of the `.bib` file to save references to.",
    type = "character|numeric"
  ),
  pkg = "Template used to cite a package.",
  pkg_list = "Template used in `pkrt_list()`.",
  r = "Template used to cite R."
)
