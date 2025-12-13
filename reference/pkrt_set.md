# Configure pakret's settings

This function allows you to configure pakret's settings, e.g. to
customize citation templates or control which `.bib` file to save
references to.

## Usage

``` r
pkrt_set(...)
```

## Arguments

- ...:

  Key-value pairs, separated by commas, of parameters to set. See
  details.

## Value

This function is called for its side-effect. It returns no value.

## Details

Valid parameters are:

- **bib**  
  `<character|numeric> = 1L`  
  Name or index of the `.bib` file to save references to.

- **pkg**  
  `<character> = "the ':pkg' package version :ver [:ref]"`  
  Template used to cite a package.

- **pkg_list**  
  `<character> = "':pkg' v. :ver [:ref]"`  
  Template used in
  [`pkrt_list()`](https://arnaudgallou.github.io/pakret/reference/pkrt_list.md).

- **r**  
  `<character> = "R version :ver [:ref]"`  
  Template used to cite R.

New settings only apply to citations that come after `pkrt_set()`. This
means you can redefine the same settings multiple times in the same
document to alter pakret's behavior for a few specific citations only.

Use `NULL` to reset a parameter to its default value.

## Examples

``` r
pkrt_set(pkg = ":pkg (v. :ver) :ref")
pkrt("pakret")
#> [1] "pakret (v. 0.3.0) @pakret"

# `NULL` resets parameters to their default value
pkrt_set(pkg = NULL)
pkrt("pakret")
#> [1] "the 'pakret' package version 0.3.0 [@pakret]"
```
