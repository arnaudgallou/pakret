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

# pkrt_list() correctly enumerates packages in inline chunks

    Code
      cat(res)
    Output
      ‘foo’ v. 1.0.0 (Fastandfurius, Clausus, and Lastopus 2020), and ‘bar’ v.
      0.2.0 (Itisalapsus 2024)
      
      Fastandfurius, Caius, Numerius Clausus, and Marcus Lastopus. 2020.
      *<span class="nocase">foo</span>: Alea Jacta Est*.
      
      Itisalapsus, Julius. 2024. *<span class="nocase">bar</span>: Tempus Edax
      Rerum*.

# pkrt_list() gives meaningful error messages

    Code
      pkrt_list(1)
    Condition
      Error:
      ! `...` must be a character vector.

