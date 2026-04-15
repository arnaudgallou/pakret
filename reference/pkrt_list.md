# Cite a collection of R packages

Creates a list of package citations that can be converted into a
character string or data frame. This function is normally used within an
R Markdown or Quarto document, where `pkrt_list()` automatically
references the cited packages in the first (by default) `.bib` file
specified in the YAML header if no reference for the packages already
exists.

## Usage

``` r
pkrt_list(...)
```

## Arguments

- ...:

  Character vectors, separated by commas, of packages to cite.

## Value

A list of package citations with S3 class `pkrt_list`.

## Details

This function automatically discards duplicate and base packages. You
can use `pkrt_list()` in combination with `renv::dependencies()` to cite
all the packages used in a project or directory.

## Examples

``` r
# Create a list of citations
citations <- pkrt_list("pakret", "readr", "knitr")

# You can then turn the citations into a character string
# Note that this is done automatically in inline chunks
paste(citations, collapse = ", ")
#> [1] "'pakret' v. 0.3.1 [@pakret], 'readr' v. 2.2.0 [@readr], 'knitr' v. 1.51 [@knitr]"

# Or a data frame
as.data.frame(citations)
#>   Package Version Reference
#> 1   knitr    1.51    @knitr
#> 2  pakret   0.3.1   @pakret
#> 3   readr   2.2.0    @readr
```
