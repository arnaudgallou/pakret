test_that("pkrt() cites and references packages", {
  dir <- local_files(make_template(lines = "`r pkrt('foo')`"))
  res <- read_local_file(dir)
  expect_snapshot(cat(res))
})

test_that("bib entries are properly appended to bib files", {
  template <- make_template(lines = "`r pkrt('foo')` `r pkrt('bar')`")
  dir <- local_files(template)
  res <- read_local_file(dir, target = "bib")
  expect_snapshot(cat(res))

  load_bar()
  template <- make_template(lines = "`r pkrt('foo')`")
  dir <- local_files(template, bib = local_set(lines = ref_get("bar")))
  res <- read_local_file(dir, target = "bib")
  expect_snapshot(cat(res))
})

test_that("multi-bib entries are properly handled", {
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
  dir <- local_files(make_template(lines = strrep("`r pkrt('foo')`", 2L)))
  res <- read_local_file(dir, target = "bib")
  expect_length(extract(res, "(?m)^@"), 1L)
})

test_that("citing no packages doesn't modify bib files", {
  load_foo()
  citation <- ref_get("foo")
  template <- make_template(lines = "")
  dir <- local_files(template, bib = local_set(lines = citation))
  res <- read_local_file(dir, target = "bib")
  expect_equal(res, paste0(citation, "\n"))
})

test_that("pkrt() cites R", {
  pattern <- "R version [\\d.]+ \\[@base\\]"
  expect_match(pkrt("R"), regexp = pattern, perl = TRUE)
  expect_match(pkrt("base"), regexp = pattern, perl = TRUE)
})

test_that("pakret handles references that have a premade key (#18)", {
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

test_that("pakret works with modified frame stacks (#30)", {
  template <- dedent("
    ---
    bibliography: %s
    ---
    ```{r}
    (function() library(pakret))()
    pakret:::load_foo()
    ```
    `r pkrt('foo')`
  ")
  dir <- local_files(template)
  res <- read_local_file(dir, target = "bib")

  expect_match(res, "@Manual\\{foo,")
})

test_that("pakret preserves the case of package and single-letter names", {
  template <- dedent("
    ---
    bibliography: %s
    ---
    ```{r}
    library(pakret)
    pakret:::local_pkg('baz', Title = 'A Simple R Test With a Protected {B}')
    ```
    `r pkrt('baz')`
  ")
  dir <- local_files(template)
  res <- read_local_file(dir, target = "bib")

  expect_snapshot(cat(res))
})

test_that("pakret creates bib files if needed", {
  template <- dedent("
    ---
    bibliography: pkrt.bib
    ---
    ```{r}
    library(pakret)
    pakret:::load_foo()
    ```
    `r pkrt('foo')`
  ")
  dir <- local_files(template, bib = NULL)
  res <- read_local_file(dir, target = "bib")

  expect_match(res, "@Manual\\{foo,")
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
