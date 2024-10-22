test_that("custom templates work", {
  load_foo()
  local_settings(pkg = ":ref :ver :pkg")
  expect_equal(pkrt("foo"), "@foo 1.0.0 foo")
})

test_that("`NULL` resets settings to their default value", {
  load_foo()
  pkrt_set(pkg = ":ref :ver :pkg")
  pkrt_set(pkg = NULL)
  expect_equal(pkrt("foo"), "the 'foo' package version 1.0.0 [@foo]")
})

test_that("writing bib entries in the desired file works", {
  skip_on_os("windows")
  template <- make_template(lines = dedent("
    ```{r}
    pkrt_set(bib = 2L)
    pkrt('foo')
    ```
  "))
  load_bar()
  dir <- local_files(template, bib = local_set(
    # the pre-written ref is to ensure that pkrt_set() resets bib metadata (#22)
    lines = get_reference("bar"),
    n = 2L
  ))

  res <- read_local_file(dir, target = "file_1.bib")
  expect_match(res, "^\\R$", perl = TRUE)

  res <- read_local_file(dir, target = "file_2.bib")
  expect_match(res, "@Manual\\{bar,")
  expect_match(res, "@Manual\\{foo,")
  expect_length(extract(res, "(?m)^@"), 2L)
})

test_that("writing bib entries in multiple file works", {
  skip_on_os("windows")
  template <- make_template(lines = dedent("
    ```{r}
    pkrt_set(bib = 2L)
    pkrt('bar')

    pkrt_set(bib = NULL)
    pkrt('foo')
    ```
  "))
  dir <- local_files(template, bib = local_set(n = 2L))

  res <- read_local_file(dir, target = "file_1.bib")
  expect_match(res, "^@Manual\\{foo,")
  expect_length(extract(res, "(?m)^@"), 1L)

  res <- read_local_file(dir, target = "file_2.bib")
  expect_match(res, "^@Manual\\{bar,")
  expect_length(extract(res, "(?m)^@"), 1L)
})

# errors

test_that("pkrt_set() gives meaningful error messages", {
  expect_snapshot({
    (expect_error(
      pkrt_set("a")
    ))
    (expect_error(
      pkrt_set(pkg = list("a"))
    ))
    (expect_error(
      pkrt_set(pkg = rep("a", 2L))
    ))
    (expect_error(
      pkrt_set(foo = 1)
    ))
    (expect_error(
      pkrt_set(pkg = 1)
    ))
    (expect_error(
      pkrt_set(pkg = ":pkg :ver")
    ))
    (expect_error(
      pkrt_set(pkg = ":pkg :ver :ref :blah")
    ))
    (expect_error(
      pkrt_set(pkg = ":pkg :ver :ver :ref")
    ))
  })

  expect_snapshot(
    local_files(make_template(lines = "`r pkrt_set(bib = TRUE)`")),
    error = TRUE
  )

  expect_snapshot(
    local_files(make_template(lines = "`r pkrt_set(bib = 'test')`")),
    error = TRUE
  )

  expect_snapshot(
    local_files(make_template(lines = "`r pkrt_set(bib = 2)`")),
    error = TRUE
  )
})
