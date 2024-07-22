test_that("pkrt() cites and references packages", {
  skip_on_os("windows")
  dir <- local_files(make_template(lines = "`r pkrt(foo)`"))
  res <- read_local_file(dir)
  expect_snapshot(cat(res))
})

test_that("bib entries are properly appended to bib files", {
  skip_on_os("windows")
  template <- make_template(lines = "`r pkrt(foo)` `r pkrt(bar)`")
  dir <- local_files(template)
  res <- read_local_file(dir, target = "bib")
  expect_snapshot(cat(res))

  load_bar()
  template <- make_template(lines = "`r pkrt(foo)`")
  dir <- local_files(template, bib_lines = get_citation("bar"))
  res <- read_local_file(dir, target = "bib")
  expect_snapshot(cat(res))
})

test_that("multi-bib entries are properly handled", {
  skip_on_os("windows")
  template <- dedent('
    ---
    bibliography: %s
    ---
    ```{r}
    library(pakret)
    pakret:::load_foo(bib_entries = c("Article", "Manual"))
    pakret:::load_bar(bib_entries = c("Book", "Article"))
    ```
    `r pkrt(foo)`
    `r pkrt(bar)`
  ')
  dir <- local_files(template)
  res <- read_local_file(dir, target = "bib")

  expect_match(res, "@Manual\\{foo,")
  expect_match(res, "@Book\\{bar,")
})

test_that("citing the same package again doesn't add a new bib entry", {
  skip_on_os("windows")
  dir <- local_files(make_template(lines = strrep("`r pkrt(foo)`", 2L)))
  res <- read_local_file(dir, target = "bib")
  expect_length(extract(res, "(?m)^@"), 1L)
})

test_that("citing no packages doesn't modify bib files", {
  skip_on_os("windows")
  load_foo()
  citation <- get_citation("foo")
  dir <- local_files(make_template(lines = ""), bib_lines = citation)
  res <- read_local_file(dir, target = "bib")
  expect_equal(res, paste0(citation, eol()))
})

test_that("objects are properly cited", {
  load_foo()
  expect_equal(
    pkrt(foo::bar),
    "the 'bar' function from the 'foo' package version 1.0.0 [@foo]"
  )
  expect_equal(
    pkrt(foo::bar, "data set"),
    "the 'bar' data set from the 'foo' package version 1.0.0 [@foo]"
  )
})

test_that("pkrt() cites R", {
  pattern <- "R version [\\d.]+ \\[@base\\]"
  expect_match(pkrt(R), regexp = pattern, perl = TRUE)
  expect_match(pkrt(base), regexp = pattern, perl = TRUE)
})

# errors

test_that("pkrt() gives meaningful error messages", {
  expect_snapshot({
    (expect_error(
      pkrt(a)
    ))
    (expect_error(
      pkrt(pakret, object_type = 1)
    ))
    (expect_error({
      withr::local_options(pakret.check_obj = TRUE)
      pkrt(pakret::foo)
    }))
  })
})
