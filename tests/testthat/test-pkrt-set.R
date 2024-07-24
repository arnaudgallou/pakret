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
  dir <- local_files(n_bib = 2L, make_template(lines = dedent("
    ```{r}
    pkrt_set(bib = 2L)
    pkrt('foo')
    ```
  ")))

  res <- read_local_file(dir, target = "file_1.bib")
  expect_match(res, "^\\R$", perl = TRUE)

  res <- read_local_file(dir, target = "file_2.bib")
  expect_match(res, "^@Manual\\{foo,")
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
