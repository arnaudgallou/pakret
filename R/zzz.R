.onLoad <- function(...) {
  do.call(set, .__settings__)
  if (is_rendering_context()) {
    knitr::knit_hooks$set(after.knit = bib_write)
    bibs <- rmarkdown::metadata$bibliography
    set(render = TRUE, bibliography = bibs, eol = eol())
    bib_init()
  }
}

defer <- function(expr, frame = parent.frame()) {
  thunk <- as.call(list(function() expr))
  do.call(on.exit, list(thunk, TRUE, FALSE), envir = frame)
}
