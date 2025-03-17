is_rendering <- function() {
  isTRUE(get("render"))
}

is_rendering_context <- function() {
  is_knitting() && has_metadata() && getOption("pakret.render_mode", TRUE)
}

is_knitting <- function() {
  isTRUE(getOption("knitr.in.progress"))
}

is_empty <- function(x) {
  length(x) == 0L || all(x == "")
}

is_referenced <- function(pkg) {
  pkg %in% get("keys")
}

is_bib <- function(x) {
  n <- nchar(x)
  tolower(substr(x, n - 3L, n)) == ".bib"
}

is_updating_bib <- function(x) {
  is_rendering() && names(x) == "bib" && x != get("bib")
}

is_unit_set <- function(x) {
  length(x) == 1L
}

is_string <- function(x) {
  is.character(x) && is_unit_set(x)
}

is_blank <- function(x) {
  grepl("^\\s*$", x)
}

is_template <- function(x) {
  x %in% .template_keys
}

is_named <- function(x) {
  nms <- names(x)
  if (is.null(nms) || any(nms == "")) {
    return(FALSE)
  }
  TRUE
}

is_r <- function(x) {
  x %in% c("R", "base")
}

bibtex_is <- function(x, type) {
  tolower(substr(x, 2L, nchar(type) + 1L)) == type
}

has_bibtex <- function(x, type) {
  any(vapply(x, function(.x) bibtex_is(.x, type), logical(1L)))
}

has_metadata <- function() {
  !is_empty(rmarkdown::metadata)
}

has_placeholder <- function(x) {
  grepl(.regex$placeholder, x, perl = TRUE)
}

abort <- function(msg, ...) {
  stop(error(msg, ...), call. = FALSE)
}

error <- function(msg, ...) {
  msg <- paste(msg, collapse = "\n")
  if (...length() == 0L) {
    return(msg)
  }
  sprintf(msg, ...)
}

caller_arg <- function() {
  deparse(substitute(x, env = parent.frame()))
}

check_type <- function(x, asserter, expected, arg) {
  if (asserter(x)) {
    return(invisible())
  }
  abort(paste0("`%s` must be ", expected, "."), arg)
}

check_string <- function(x, arg = caller_arg()) {
  check_type(x, is_string, "a string", arg)
}

check_bool <- function(x, arg = caller_arg()) {
  check_type(x, is.logical, "`TRUE` or `FALSE`", arg)
}

check_character <- function(x, arg = caller_arg()) {
  check_type(x, is.character, "a character vector", arg)
}

check_unit_set <- function(x, arg = caller_arg()) {
  check_atomic(x, arg)
  asserter <- function(x) is.null(x) || is_unit_set(x)
  check_type(x, asserter, "a single element vector", arg)
}

check_atomic <- function(x, arg = caller_arg()) {
  asserter <- function(x) is.null(x) || is.atomic(x)
  check_type(x, asserter, "an atomic vector", arg)
}

check_named <- function(x, arg = caller_arg()) {
  if (is_named(x)) {
    return(invisible())
  }
  abort("All elements of `%s` must be named.", arg)
}

check_template <- function(x, arg) {
  check_string(x, arg)
  vars_curr <- vars(x)
  check_duplicated_vars(vars_curr, arg)
  vars_default <- vars(.__settings__[[arg]])
  check_missing_vars(vars_curr, vars_default, arg)
  check_invalid_vars(vars_curr, vars_default, arg)
}

seek <- function(x, cnd) {
  if (all(!cnd)) {
    return()
  }
  x[[which(cnd)[[1]]]]
}

check_duplicated_vars <- function(x, arg) {
  duplicated <- seek(x, duplicated(x))
  if (is.null(duplicated)) {
    return(invisible())
  }
  abort("Duplicate placeholder `:%s` found in `%s`.", duplicated, arg)
}

check_missing_vars <- function(x, valid, arg) {
  missing <- seek(valid, !valid %in% x)
  if (is.null(missing)) {
    return(invisible())
  }
  abort("`%s` requires the `:%s` placeholder.", arg, missing)
}

check_invalid_vars <- function(x, allowed, arg) {
  not_allowed <- seek(x, !x %in% allowed)
  if (is.null(not_allowed)) {
    return(invisible())
  }
  abort("Invalid placeholder `:%s` found in `%s`.", not_allowed, arg)
}

check_settings <- function(x) {
  x <- names(x)
  invalid <- seek(x, !x %in% names(.__settings__))
  if (is.null(invalid)) {
    return(invisible())
  }
  abort("`%s` isn't a valid setting.", invalid)
}

check_option_bib <- function(x, arg = caller_arg()) {
  asserter <- function(x) is.numeric(x) || is_string(x)
  check_type(x, asserter, "a numeric value or a string", arg)
}

check_bibliography <- function() {
  if (!is.null(get("bibliography"))) {
    return(invisible())
  }
  abort(c(
    "No `.bib` files found.",
    "You must provide a `.bib` file to the `bibliography` YAML key."
  ))
}

check_bib_target <- function(x) {
  check_bib_target_(unclass(x), get("bibliography"))
}

check_bib_target_ <- function(x, bibs) {
  UseMethod("check_bib_target_")
}

check_bib_target_.character <- function(x, bibs) {
  if (x %in% bib_name(bibs)) {
    return(invisible())
  }
  abort("`%s.bib` doesn't exist in the bibliography list.", x)
}

check_bib_target_.numeric <- function(x, bibs) {
  if (x > 0L && x <= length(bibs)) {
    return(invisible())
  }
  abort("`bib` index out of bound.")
}

check_bib <- function(x, arg = caller_arg()) {
  check_type(x, is_bib, "a `.bib` file", arg)
}

check_pkg <- function(pkg) {
  path <- system.file(package = pkg)
  if (!is_empty(path)) {
    return(invisible())
  }
  abort("Package `%s` doesn't exist or isn't installed.", pkg)
}
