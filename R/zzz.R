.onLoad <- function(...) {
  do.call(set, .__settings__)
  if (is_rendering_context()) {
    bibs <- rmarkdown::metadata$bibliography
    set(render = TRUE, bibliography = bibs, eol = eol())
    bib_init()
    defer_knitr(bib_write())
  }
}

defer <- function(expr, frame = parent.frame()) {
  thunk <- as.call(list(function() expr))
  do.call(on.exit, list(thunk, TRUE, FALSE), envir = frame)
}

defer_knitr <- function(expr) {
  defer(expr, knitr_exit_frame())
}

knitr_exit_frame <- function() {
  ns <- asNamespace("knitr")
  for (frame in as.list(sys.frames())) {
    if (identical(topenv(frame), ns)) {
      return(frame)
    }
  }
}
