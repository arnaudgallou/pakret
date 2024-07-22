local_settings <- function(..., env = parent.frame()) {
  withr::defer(reset(...names()), envir = env)
  pkrt_set(...)
}

make_template <- function(lines = "", meta = "bibliography: %s") {
  pkgs <- extract_pkgs(lines)
  to_load <- if (!is_empty(pkgs)) to_load(pkgs) else ""
  sprintf(dedent(template), meta, to_load, lines)
}

extract_pkgs <- function(x) {
  unique(extract(x, "(?<=pkrt\\()[a-z]+"))
}

to_load <- function(x) {
  paste0("pakret:::load_", x, "()", collapse = "; ")
}

template <- "
  ---
  %s
  ---

  ```{r, include = FALSE}
  library(pakret)
  %s
  ```

  %s

  # References
"
