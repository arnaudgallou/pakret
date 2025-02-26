test_that("pakret initialisation gives meaningful error messages", {
  expect_snapshot(
    local_files(make_template(meta = "title: no bibs"), bib = NULL),
    error = TRUE
  )

  expect_snapshot(
    local_files(make_template(meta = "bibliography: foo.md"), bib = NULL),
    error = TRUE
  )
})
