# Changelog

## pakret (development version)

- pakret now creates the `.bib` files used to write package references
  if they don’t exist
  ([\#48](https://github.com/arnaudgallou/pakret/issues/48)).

- pakret now preserves the case of cited packages and single-letter
  names (such as R and C) in reference titles
  ([\#43](https://github.com/arnaudgallou/pakret/issues/43)).

- pakret now works when called after the package
  [conflicted](https://conflicted.r-lib.org)
  ([\#30](https://github.com/arnaudgallou/pakret/issues/30)).

- The `:ver` placeholder in citation templates is now optional, mainly
  for pakret use in non-technical documents where package versions are
  unnecessary
  ([\#40](https://github.com/arnaudgallou/pakret/issues/40)).

- Citing multiple packages is now significantly faster
  ([\#31](https://github.com/arnaudgallou/pakret/issues/31)).

## pakret 0.2.2

CRAN release: 2024-10-23

- pakret can now write references in multiple `.bib` files within the
  same document
  ([\#26](https://github.com/arnaudgallou/pakret/issues/26)).

- Fixed an issue with `pkrt_set(bib =)` that may lead to the replication
  or deletion of some bib entries in the newly defined `.bib` file in
  some edge cases
  ([\#22](https://github.com/arnaudgallou/pakret/issues/22)).

## pakret 0.2.1

CRAN release: 2024-10-10

- pakret now can cite references that have a pre-written key
  ([\#18](https://github.com/arnaudgallou/pakret/issues/18)).

- Fixed alphabetical ordering of package names in
  `as.data.frame.pkrt_list()`
  ([\#19](https://github.com/arnaudgallou/pakret/issues/19)).

## pakret 0.2.0

CRAN release: 2024-10-03

- Added `book` as a second BibTeX type that should be used in priority
  when getting the reference of a package (previously, the priority was
  given to `manual` entries only). This allows for a slightly better
  handling of multi- reference packages by using a more general
  reference when there’s a `book` but no `manual` BibTeX entry available
  ([\#15](https://github.com/arnaudgallou/pakret/issues/15)).

- `as.data.frame.pkrt_list()` now arranges packages in alphabetical
  order ([\#13](https://github.com/arnaudgallou/pakret/issues/13)).

## pakret 0.1.0

CRAN release: 2024-09-02

- Initial CRAN submission.
