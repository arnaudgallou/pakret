test_that("pakret initialisation gives meaningful error messages", {
  skip_on_os("windows")
  expect_snapshot(
    local_files(make_template(meta = "title: no bibs"), n_bib = NULL),
    error = TRUE
  )

  expect_snapshot(
    local_files(make_template(meta = "bibliography: foo.md"), n_bib = NULL),
    error = TRUE
  )
})
