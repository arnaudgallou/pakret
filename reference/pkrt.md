# Cite R or an R package

Creates a preformatted citation for R or an R package. This function is
normally used within an R Markdown or Quarto document, where `pkrt()`
automatically references the cited package to the first (by default)
`.bib` file specified in the YAML header if no reference for the package
already exists.

## Usage

``` r
pkrt(pkg)
```

## Arguments

- pkg:

  Name of the package to cite. You can use `"R"` as an alias for the
  base package to cite R.

## Value

A character string with S3 class `AsIs`.

## Examples

``` r
pkrt("pakret")
#> [1] "the 'pakret' package version 0.3.1 [@pakret]"

pkrt("R")
#> [1] "R version 4.5.3 [@base]"
```
