# pakret (development version)

* Added `book` as a second BibTeX type that should be used in priority when getting the reference of a package (previously, the priority was given to the `manual` type only). This allows a slightly better handling of multi-reference packages by using a more general reference that should suit in most cases when there's no `manual` reference available (#15).

* `as.data.frame.pkrt_list()` now arranges packages in alphabetical order (#13).

# pakret 0.1.0

* Initial CRAN submission.
