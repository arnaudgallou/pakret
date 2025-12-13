# pakret (development version)

* pakret now creates the `.bib` files used to write package references if they
don't exist (#48).

* pakret now preserves the case of cited packages and single-letter names (such
as R and C) in reference titles (#43).

* pakret now works when called after the package
[conflicted](https://conflicted.r-lib.org) (#30).

* The `:ver` placeholder in citation templates is now optional, mainly for
pakret use in non-technical documents where package versions are unnecessary
(#40).

* Citing multiple packages is now significantly faster (#31).

# pakret 0.2.2

* pakret can now write references in multiple `.bib` files within the same
document (#26).

* Fixed an issue with `pkrt_set(bib =)` that may lead to the replication or
deletion of some bib entries in the newly defined `.bib` file in some edge cases
(#22).

# pakret 0.2.1

* pakret now can cite references that have a pre-written key (#18).

* Fixed alphabetical ordering of package names in `as.data.frame.pkrt_list()`
(#19).

# pakret 0.2.0

* Added `book` as a second BibTeX type that should be used in priority when
getting the reference of a package (previously, the priority was given to
`manual` entries only). This allows for a slightly better handling of multi-
reference packages by using a more general reference when there's a `book` but
no `manual` BibTeX entry available (#15).

* `as.data.frame.pkrt_list()` now arranges packages in alphabetical order (#13).

# pakret 0.1.0

* Initial CRAN submission.
