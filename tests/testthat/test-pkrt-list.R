test_that("pkrt_list() makes a list of citations", {
  load_foo()
  load_bar()
  citations <- pkrt_list("foo", "bar")

  expect_snapshot(citations)
  expect_snapshot(str(citations))
})

test_that("citation lists can be turned into data frames", {
  load_foo()
  load_bar()
  citations <- pkrt_list("foo", "bar")

  expect_equal(
    as.data.frame(citations),
    data.frame(
      Package = c("bar", "foo"),
      Version = c("0.2.0", "1.0.0"),
      Reference = c("@bar", "@foo")
    )
  )
})

test_that("pkrt_list() removes duplicate and base packages", {
  load_foo()
  citations <- pkrt_list("foo", "foo", "base")
  expect_equal(names(citations), "foo")
})

# errors

test_that("pkrt_list() gives meaningful error messages", {
  expect_snapshot(pkrt_list(1), error = TRUE)
})
