# pakret initialisation gives meaningful error messages

    Code
      local_files(make_template(meta = "title: no bibs"), bib = NULL)
    Condition
      Error:
      ! package or namespace load failed for 'pakret':
       .onLoad failed in loadNamespace() for 'pakret', details:
        call: NULL
        error: No `.bib` files found.
      You must provide a `.bib` file to the `bibliography` YAML key.

---

    Code
      local_files(make_template(meta = "bibliography: foo.md"), bib = NULL)
    Condition
      Error:
      ! package or namespace load failed for 'pakret':
       .onLoad failed in loadNamespace() for 'pakret', details:
        call: NULL
        error: `foo.md` must be a `.bib` file.

