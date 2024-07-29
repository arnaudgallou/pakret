# pkrt_list() makes a list of citations

    Code
      citations
    Output
      $foo
      [1] "'foo' v. 1.0.0 [@foo]"
      
      $bar
      [1] "'bar' v. 0.2.0 [@bar]"
      

---

    Code
      str(citations)
    Output
      List of 2
       $ foo: chr "'foo' v. 1.0.0 [@foo]"
        ..- attr(*, "pkg")= chr "foo"
        ..- attr(*, "ver")= chr "1.0.0"
        ..- attr(*, "ref")= chr "@foo"
       $ bar: chr "'bar' v. 0.2.0 [@bar]"
        ..- attr(*, "pkg")= chr "bar"
        ..- attr(*, "ver")= chr "0.2.0"
        ..- attr(*, "ref")= chr "@bar"
       - attr(*, "class")= chr "pkrt_list"

# pkrt_list() gives meaningful error messages

    Code
      pkrt_list(1)
    Condition
      Error:
      ! `...` must be a character vector.

