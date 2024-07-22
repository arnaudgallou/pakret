.onLoad <- function(...) {
  do.call(set, .__settings__)
  if (is_rendering_context()) {
    bib_init()
    terminate()
  }
}

terminate <- function() {
  withr::defer(bib_write(), envir = parent.frame(5L))
}
