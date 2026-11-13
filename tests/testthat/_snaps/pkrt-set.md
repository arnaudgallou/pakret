# pkrt_set() gives meaningful error messages

    Code
      (expect_error(pkrt_set("a")))
    Output
      <simpleError in pkrt_set(): All elements of `...` must be named.>
    Code
      (expect_error(pkrt_set(pkg = list("a"))))
    Output
      <simpleError in pkrt_set(): `pkg` must be an atomic vector.>
    Code
      (expect_error(pkrt_set(pkg = rep("a", 2L))))
    Output
      <simpleError in pkrt_set(): `pkg` must be a single element vector.>
    Code
      (expect_error(pkrt_set(foo = 1)))
    Output
      <simpleError in pkrt_set(): `foo` isn't a valid setting.>
    Code
      (expect_error(pkrt_set(pkg = 1)))
    Output
      <simpleError in pkrt_set(): `pkg` must be a string.>
    Code
      (expect_error(pkrt_set(pkg = ":pkg :ver")))
    Output
      <simpleError in pkrt_set(): `pkg` requires the `:ref` placeholder.>
    Code
      (expect_error(pkrt_set(pkg = ":pkg :ver :ref :blah")))
    Output
      <simpleError in pkrt_set(): Invalid placeholder `:blah` found in `pkg`.>
    Code
      (expect_error(pkrt_set(pkg = ":pkg :ver :ver :ref")))
    Output
      <simpleError in pkrt_set(): Duplicate placeholder `:ver` found in `pkg`.>

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

