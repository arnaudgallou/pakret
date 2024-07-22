
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pakret

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/arnaudgallou/pakret/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/arnaudgallou/pakret/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

## Overview

pakret is a minimalist R package citation tool to reference and cite R
packages and objects on the fly in R Markdown and Quarto.

## Installation

You can install pakret from GitHub with:

``` r
# install.packages("pak")
pak::pak("arnaudgallou/pakret")
```

## Usage

Simply use `pkrt()` whenever you want to cite an R package or object in
your document:

    ---
    bibliography: references.bib
    ---

    ```{r}
    #| include: false

    library(pakret)
    ```

    Maps were created using `r pkrt(foo)`.

    We used `r pkrt(bar::blah)` to compute X.

    ## References

pakret handles everything for you.

Here’s the markdown output produced by the document above:

    Maps were created using the ‘foo’ package version 1.0.0 (Fastandfurius,
    Clausus, and Lastopus 2020).

    We used the ‘blah’ function from the ‘bar’ package version 0.2.0
    (Itisalapsus 2024) to compute X.

    ## References

    Fastandfurius, Caius, Numerius Clausus, and Marcus Lastopus. 2020. *Foo:
    Alea Jacta Est*.

    Itisalapsus, Julius. 2024. *Bar: Tempus Edax Rerum*.

Unhappy with the default templates? pakret lets you define your own:

    ---
    bibliography: references.bib
    ---

    ```{r}
    #| include: false

    library(pakret)
    pkrt_set(pkg = "the R package :pkg (v. :ver; :ref)")
    ```

    We used `r pkrt(foo)` to create the maps.

    ## References

Which gives:

    We used the R package foo (v. 1.0.0; Fastandfurius, Clausus, and
    Lastopus (2020)) to create the maps.

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

    We used the following packages: `r pkrt_list("foo", "bar")`.

    ## References

Here’s the result:

    We used the following packages: ‘foo’ v. 1.0.0 (Fastandfurius, Clausus,
    and Lastopus 2020), ‘bar’ v. 0.2.0 (Itisalapsus 2024).

    ## References

    Fastandfurius, Caius, Numerius Clausus, and Marcus Lastopus. 2020. *Foo:
    Alea Jacta Est*.

    Itisalapsus, Julius. 2024. *Bar: Tempus Edax Rerum*.
