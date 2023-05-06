
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rallicagram

<!-- badges: start -->
<!-- badges: end -->

## Overview

`rallicaggram` calls the Gallicagram API directly from R.
[Gallicagram](https://shiny.ens-paris-saclay.fr/app/gallicagram) enables
to build time series of keywords used in a set of French corpora:

- **Historical newspapers** from [Gallica](https://gallica.bnf.fr/)
  (corpus=“press”). A corpus of 3 million issues, reliable from 1789
  to 1950. Yearly or monthly resolution.
- **Public domain books** available on
  [Gallica](https://gallica.bnf.fr/) (corpus=“books”). 300 000 books,
  more and more reliable through the 16th to 18th centuries and up
  to 1950. Yearly resolution.
- **Articles published in [*Le Monde*](https://www.lemonde.fr/)**
  (corpus=“lemonde”). Available and reliable from December 1944 to
  February 22, 2022. Yearly, monthly or daily resolution.

Additional information on a
[preprint](https://osf.io/preprints/socarxiv/84bf3/) by Gallicagram
developers [Benoît de Courson](https://regicid.github.io/) and [Benjamin
Azoulay](https://benjamin-azoulay.my.canva.site/) and on the “Notice”
tab of the [Gallicagram
website](https://shiny.ens-paris-saclay.fr/app/gallicagram).

## Installation

You can install the development version of rallicagram from
[GitHub](https://github.com/vincentbagilet/rallicagram) with:

``` r
# install.packages("devtools")
devtools::install_github("vincentbagilet/rallicagram")
```

## Usage

The main function, `rallicagram_search`, builds a data frame with the
yearly, monthly or daily proportion of mentions of a term in one of the
three corpora between two specified dates.

``` r
library(rallicagram)

gallicagram(
  keyword = "président", 
  corpus = "lemonde", 
  from = 1960, 
  to = 1970,
  resolution = "monthly"
)
#> # A tibble: 132 × 9
#>    date       keyword   nb_occur nb_grams prop_occur  year month source  resol…¹
#>    <date>     <chr>        <int>    <int>      <dbl> <int> <int> <chr>   <chr>  
#>  1 1960-01-01 président     1338   872943    0.00153  1960     1 lemonde monthly
#>  2 1960-02-01 président     1360   915672    0.00149  1960     2 lemonde monthly
#>  3 1960-03-01 président     1461   928764    0.00157  1960     3 lemonde monthly
#>  4 1960-04-01 président     1239   772707    0.00160  1960     4 lemonde monthly
#>  5 1960-05-01 président     1355   835612    0.00162  1960     5 lemonde monthly
#>  6 1960-06-01 président     1314   850245    0.00155  1960     6 lemonde monthly
#>  7 1960-07-01 président     1189   942062    0.00126  1960     7 lemonde monthly
#>  8 1960-08-01 président      979   739018    0.00132  1960     8 lemonde monthly
#>  9 1960-09-01 président     1506   904804    0.00166  1960     9 lemonde monthly
#> 10 1960-10-01 président     1107   826661    0.00134  1960    10 lemonde monthly
#> # … with 122 more rows, and abbreviated variable name ¹​resolution
```

Additional functions, to describe close co-occurrences for instance, are
also available in this package and described in the vignette.
