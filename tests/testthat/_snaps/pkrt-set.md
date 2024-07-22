# pkrt_set() gives meaningful error messages

    Code
      (expect_error(pkrt_set("a")))
    Output
      <simpleError: All elements of `...` must be named.>
    Code
      (expect_error(pkrt_set(pkg = list("a"))))
    Output
      <simpleError: `pkg` must be an atomic vector.>
    Code
      (expect_error(pkrt_set(pkg = rep("a", 2L))))
    Output
      <simpleError: `pkg` must be a single element vector.>
    Code
      (expect_error(pkrt_set(foo = 1)))
    Output
      <simpleError: `foo` isn't a valid setting.>
    Code
      (expect_error(pkrt_set(sep = 1)))
    Output
      <simpleError: `sep` must be a string.>
    Code
      (expect_error(pkrt_set(obj_first = 1)))
    Output
      <simpleError: `obj_first` must be `TRUE` or `FALSE`.>
    Code
      (expect_error(pkrt_set(pkg = 1)))
    Output
      <simpleError: `pkg` must be a string.>
    Code
      (expect_error(pkrt_set(pkg = ":pkg :ver")))
    Output
      <simpleError: `pkg` requires the `:ref` placeholder.>
    Code
      (expect_error(pkrt_set(pkg = ":pkg :ver :ref :blah")))
    Output
      <simpleError: Invalid placeholder `:blah` found in `pkg`.>
    Code
      (expect_error(pkrt_set(pkg = ":pkg :ver :ver :ref")))
    Output
      <simpleError: Duplicate placeholder `:ver` found in `pkg`.>

---

    Code
      local_files(make_template(lines = "`r pkrt_set(bib = TRUE)`"))
    Condition
      Error:
      ! `bib` must be a numeric value or a string.

---

    Code
      local_files(make_template(lines = "`r pkrt_set(bib = 'test')`"))
    Condition
      Error:
      ! `test.bib` doesn't exist in the bibliography list.

---

    Code
      local_files(make_template(lines = "`r pkrt_set(bib = 2)`"))
    Condition
      Error:
      ! `bib` index out of bound.

