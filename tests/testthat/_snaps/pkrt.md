# pkrt() cites and references packages

    Code
      cat(res)
    Output
      the ‘foo’ package version 1.0.0 (Fastandfurius, Clausus, and Lastopus
      2020)
      
      # References
      
      Fastandfurius, Caius, Numerius Clausus, and Marcus Lastopus. 2020. *Foo:
      Alea Jacta Est*.

# bib entries are properly appended to bib files

    Code
      cat(res)
    Output
      @Manual{foo,
        title = {foo: Alea Jacta Est},
        author = {Caius Fastandfurius and Numerius Clausus and Marcus Lastopus},
        year = {2020},
        note = {R package version 1.0.0},
      }
      
      @Manual{bar,
        title = {bar: Tempus Edax Rerum},
        author = {Julius Itisalapsus},
        year = {2024},
        note = {R package version 0.2.0},
      }

---

    Code
      cat(res)
    Output
      @Manual{bar,
        title = {bar: Tempus Edax Rerum},
        author = {Julius Itisalapsus},
        year = {2024},
        note = {R package version 0.2.0},
      }
      
      @Manual{foo,
        title = {foo: Alea Jacta Est},
        author = {Caius Fastandfurius and Numerius Clausus and Marcus Lastopus},
        year = {2020},
        note = {R package version 1.0.0},
      }

# pkrt() gives meaningful error messages

    Code
      (expect_error(pkrt(1)))
    Output
      <simpleError: `x` must be a character vector.>
    Code
      (expect_error(pkrt("a")))
    Output
      <simpleError: Package `a` doesn't exist or isn't installed.>

