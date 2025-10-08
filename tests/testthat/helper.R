local_settings <- function(..., env = parent.frame()) {
  defer(reset(...names()), frame = env)
  pkrt_set(...)
}

make_template <- function(lines = "", meta = "bibliography: %s") {
  pkgs <- extract_pkgs(lines)
  to_load <- if (!is_empty(pkgs)) to_load(pkgs) else ""
  sprintf(dedent(template), meta, to_load, lines)
}

extract_pkgs <- function(x) {
  unique(extract(x, "pkrt\\([\"']\\K[a-z]+"))
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
