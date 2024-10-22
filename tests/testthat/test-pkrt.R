test_that("pkrt() cites and references packages", {
  skip_on_os("windows")
  dir <- local_files(make_template(lines = "`r pkrt('foo')`"))
  res <- read_local_file(dir)
  expect_snapshot(cat(res))
})

test_that("bib entries are properly appended to bib files", {
  skip_on_os("windows")
  template <- make_template(lines = "`r pkrt('foo')` `r pkrt('bar')`")
  dir <- local_files(template)
  res <- read_local_file(dir, target = "bib")
  expect_snapshot(cat(res))

  load_bar()
  template <- make_template(lines = "`r pkrt('foo')`")
  dir <- local_files(template, bib = local_set(lines = get_reference("bar")))
  res <- read_local_file(dir, target = "bib")
  expect_snapshot(cat(res))
})

test_that("multi-bib entries are properly handled", {
  skip_on_os("windows")
  template <- dedent("
    ---
    bibliography: %s
    ---
    ```{r}
    library(pakret)
    pakret:::load_foo(bib_entries = c('Book', 'Manual'))
    pakret:::load_bar(bib_entries = c('article', 'book'))
    pakret:::local_pkg('baz', bib_entries = c('Misc', 'Article'))
    ```
    `r pkrt('foo')`
    `r pkrt('bar')`
    `r pkrt('baz')`
  ")
  dir <- local_files(template)
  res <- read_local_file(dir, target = "bib")

  expect_match(res, "@Manual\\{foo,")
  expect_match(res, "@Book\\{bar,")
  expect_match(res, "@Misc\\{baz,")
  expect_length(extract(res, "(?m)^@"), 3L)
})

test_that("citing the same package again doesn't add a new bib entry", {
  skip_on_os("windows")
  dir <- local_files(make_template(lines = strrep("`r pkrt('foo')`", 2L)))
  res <- read_local_file(dir, target = "bib")
  expect_length(extract(res, "(?m)^@"), 1L)
})

test_that("citing no packages doesn't modify bib files", {
  skip_on_os("windows")
  load_foo()
  citation <- get_reference("foo")
  template <- make_template(lines = "")
  dir <- local_files(template, bib = local_set(lines = citation))
  res <- read_local_file(dir, target = "bib")
  expect_equal(res, paste0(citation, eol()))
})

test_that("pkrt() cites R", {
  pattern <- "R version [\\d.]+ \\[@base\\]"
  expect_match(pkrt("R"), regexp = pattern, perl = TRUE)
  expect_match(pkrt("base"), regexp = pattern, perl = TRUE)
})

test_that("pakret handles references that have a premade key (#18)", {
  skip_on_os("windows")
  template <- dedent("
    ---
    bibliography: %s
    ---
    ```{r}
    library(pakret)
    path <- pakret:::local_pkg('baz')
    pakret:::add_bib_entries(
      path,
      \"bibentry('manual', key = 'abc', title = 'title')\"
    )
    ```
    `r pkrt('baz')`
  ")
  dir <- local_files(template)
  res <- read_local_file(dir, target = "bib")

  expect_match(res, "@Manual\\{baz,")
})

# errors

test_that("pkrt() gives meaningful error messages", {
  expect_snapshot({
    (expect_error(
      pkrt(1)
    ))
    (expect_error(
      pkrt("a")
    ))
  })
})
