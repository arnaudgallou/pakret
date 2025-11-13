# Cite R or an R package

Creates a preformatted citation of R or an R package. This function
should normally only be used in an R Markdown or Quarto document, in
which case `pkrt()` automatically references the cited package in the
first (by default) `.bib` file specified in the YAML header if no
references of the package already exist.

## Usage

``` r
pkrt(pkg)
```

## Arguments

- pkg:

  Name of the package to cite.

## Value

A character string.

## Examples

``` r
pkrt("pakret")
#> [1] "the 'pakret' package version 0.2.2.9000 [@pakret]"

pkrt("R")
#> [1] "R version 4.5.2 [@base]"
```
