
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pakret

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/arnaudgallou/pakret/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/arnaudgallou/pakret/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

## Overview

pakret is a minimalistic R package citation tool to reference and cite R
and R packages on the fly in R Markdown and Quarto.

## Installation

You can install pakret from GitHub with:

``` r
# install.packages("pak")
pak::pak("arnaudgallou/pakret")
```

## Usage

Simply use `pkrt()` whenever you want to cite R or an R package in your
document:

    ---
    bibliography: references.bib
    ---

    ```{r}
    #| include: false

    library(pakret)
    ```

    We used `r pkrt("foo")` to analyse the data.

    ## References

pakret handles everything for you.

Here’s the markdown output produced by the document above:

    We used the ‘foo’ package version 1.0.0 (Fastandfurius, Clausus, and
    Lastopus 2020) to analyse the data.

    ## References

    Fastandfurius, Caius, Numerius Clausus, and Marcus Lastopus. 2020. *Foo:
    Alea Jacta Est*.

Unhappy with the default templates? pakret lets you define your own:

    ---
    bibliography: references.bib
    ---

    ```{r}
    #| include: false

    library(pakret)
    pkrt_set(pkg = "the R package :pkg (v. :ver; :ref)")
    ```

    We used `r pkrt("foo")` to analyse the data.

    ## References

Which gives:

    We used the R package foo (v. 1.0.0; Fastandfurius, Clausus, and
    Lastopus (2020)) to analyse the data.

    ## References

    Fastandfurius, Caius, Numerius Clausus, and Marcus Lastopus. 2020. *Foo:
    Alea Jacta Est*.

It’s also possible to cite a collection of packages with `pkrt_list()`:

    ---
    bibliography: references.bib
    ---

    ```{r}
    #| include: false

    library(pakret)
    ```

    We analyse the data using the following packages: `r pkrt_list("foo", "bar")`.

    ## References

Here’s the result:

    We analyse the data using the following packages: ‘foo’ v. 1.0.0
    (Fastandfurius, Clausus, and Lastopus 2020), ‘bar’ v. 0.2.0 (Itisalapsus
    2024).

    ## References

    Fastandfurius, Caius, Numerius Clausus, and Marcus Lastopus. 2020. *Foo:
    Alea Jacta Est*.

    Itisalapsus, Julius. 2024. *Bar: Tempus Edax Rerum*.

Note that by default pakret writes new references into the first `.bib`
file specified in the bibliography list. You can change which `.bib`
file to save references to using `pkrt_set()`.
