
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rallicagram

<!-- badges: start -->

<!-- badges: end -->

## Overview

`rallicagram` is a R wrapper for the [Gallicagram
API](https://regicid.github.io/api).

[Gallicagram](https://shiny.ens-paris-saclay.fr/app/gallicagram) is a
super nice tool and set of databases that enables to easily run simple
Natural Language Processing (**NLP**) analyses on a wide set of corpora.
In particular, it enables to build historical **time series of
occurrences of keywords** in various media in one line of code.

## Installation

You can install the development version of rallicagram from
[GitHub](https://github.com/vincentbagilet/rallicagram) with:

``` r
# install.packages("devtools")
devtools::install_github("vincentbagilet/rallicagram")
```

## Usage

The main function, `gallicagram`, builds a data frame with the yearly,
monthly or daily proportion of mentions of a term.

``` r
library(rallicagram)

gallicagram(keyword = "président", corpus = "lemonde", from = 1960)
#> # A tibble: 756 × 10
#>    date       keyword   n_occur n_total prop_occur  year month corpus resolution
#>    <date>     <chr>       <int>   <int>      <dbl> <int> <int> <chr>  <chr>     
#>  1 1960-01-01 président    1338  872943    0.00153  1960     1 lemon… monthly   
#>  2 1960-02-01 président    1360  915672    0.00149  1960     2 lemon… monthly   
#>  3 1960-03-01 président    1461  928764    0.00157  1960     3 lemon… monthly   
#>  4 1960-04-01 président    1239  772707    0.00160  1960     4 lemon… monthly   
#>  5 1960-05-01 président    1355  835612    0.00162  1960     5 lemon… monthly   
#>  6 1960-06-01 président    1314  850245    0.00155  1960     6 lemon… monthly   
#>  7 1960-07-01 président    1189  942062    0.00126  1960     7 lemon… monthly   
#>  8 1960-08-01 président     979  739018    0.00132  1960     8 lemon… monthly   
#>  9 1960-09-01 président    1506  904804    0.00166  1960     9 lemon… monthly   
#> 10 1960-10-01 président    1107  826661    0.00134  1960    10 lemon… monthly   
#> # ℹ 746 more rows
#> # ℹ 1 more variable: n_of <chr>
```

It enables to draw nice graphs representing the evolution of the use of
a term in time, in two lines of code.

<img src="man/figures/README-graph-1.png" width="70%" style="display: block; margin: auto;" />

The package also allows to describe co-occurrences or words associated
with a keyword. The corresponding functions are described in the
[vignette](articles/rallicagram.html).

## Corpora

The corpora available via Gallicagram are:

| Corpus | Corpus Name | Reliable From | Reliable To | Nb Words | Max Length | Resolution | Available Func |
|:---|:---|---:|---:|:---|---:|:---|:---|
| lemonde | Le Monde (rubriques) | 1945 | 2024 | 1.5e+09 | 4 | monthly | article\|cooccurr_article\|associated_article\|with\|associated |
| presse | Presse de Gallica | 1789 | 1950 | 5.7e+10 | 3 | monthly | cooccurr\|with\|associated |
| livres | Livres de Gallica | 1700 | 1940 | 1.6e+10 | 5 | yearly | cooccurr\|with\|associated |
| presse_livres | Presse + livres de Gallica | 1789 | 1940 | 7.3e+10 | 3 | yearly | NA |
| ddb | Deutsches Zeitungsportal (DDB) | 1780 | 1950 | 3.9e+10 | 2 | monthly | with\|associated |
| american_stories | American Stories | 1798 | 1963 | 2e+10 | 3 | yearly | with\|associated |
| guardian | The Guardian | 1999 | 2026 | 2e+09 | 2 | daily | with\|associated |
| paris | Journal de Paris | 1777 | 1827 | 8.6e+07 | 2 | daily | cooccurr\|with\|associated |
| moniteur | Moniteur Universel | 1789 | 1869 | 5.11e+08 | 2 | daily | cooccurr\|with\|associated |
| journal_des_debats | Journal des Débats | 1789 | 1944 | 1.2e+09 | 1 | daily | cooccurr |
| la_presse | La Presse | 1836 | 1869 | 2.53e+08 | 2 | daily | cooccurr |
| constitutionnel | Le Constitutionnel | 1821 | 1913 | 6.4e+07 | 2 | daily | cooccurr |
| figaro | Le Figaro | 1854 | 1952 | 8.7e+08 | 2 | daily | cooccurr\|with\|associated |
| temps | Le Temps | 1861 | 1942 | 1e+09 | 2 | daily | cooccurr\|with\|associated |
| petit_journal | Le Petit Journal | 1863 | 1942 | 7.45e+08 | 2 | daily | cooccurr\|with\|associated |
| journal_officiel | Journal officiel | 1869 | 1952 | 8.42e+08 | 1 | daily | cooccurr |
| petit_parisien | Le Petit Parisien | 1876 | 1944 | 6.31e+08 | 2 | daily | cooccurr\|with\|associated |
| huma | L’Humanité | 1904 | 1952 | 3.18e+08 | 2 | daily | cooccurr\|with\|associated |
| subtitles | Opensubtitles (français) | 1935 | 2020 | 1.7e+07 | 3 | yearly | with\|associated |
| subtitles_en | Opensubtitles (anglais) | 1930 | 2020 | 1.02e+08 | 3 | yearly | with\|associated |
| rap | Rap français (Genius) | 1995 | 2024 | 2e+07 | 5 | yearly | with\|associated |
| persee | Persée | 1930 | 2023 | 1e+09 | 2 | yearly | with\|associated |
| route à part (query_cairn) | Cairn | 2001 | 2025 | \- | 3 | yearly | with\|associated |
| route à part (persee+cairn) | Persée + Cairn | 1930 | 2025 | \- | 2 | yearly | NA |
| tv_bfmtv | BFM TV (transcriptions) | 2026 | 2026 | \- | 3 | daily | with\|associated |
| tv_cnews | CNews (transcriptions) | 2026 | 2026 | \- | 3 | daily | with\|associated |
| tv_franceinfo | France Info (transcriptions) | 2026 | 2026 | \- | 3 | daily | with\|associated |
| ouest | Ouest-France (Gallica) | 1899 | 2025 | \- | 2 | yearly | NA |
| prenoms | Prénoms INSEE | 1900 | 2024 | \- | 1 | yearly | NA |
| jorf | Journal officiel (JORF) | 1990 | 2026 | 5.9e+08 | 2 | monthly | with\|associated |
| libe | Libération | 1998 | 2025 | \- | 3 | daily | with\|associated |
| majinbook | \# Majinbook français | 1700 | 2023 | \- | 4 | yearly | with\|associated |
| spa_majinbook | \# Majinbook espagnol | 1700 | 2023 | \- | 4 | yearly | with\|associated |
| eng_majinbook | \# Majinbook anglais | 1700 | 2023 | \- | 2 | yearly | with\|associated |
| deu_majinbook | \# Majinbook allemand | 1700 | 2023 | \- | 4 | yearly | with\|associated |
| presse_moderne | Presse contemporaine (toutes) | 2008 | 2026 | \- | 2 | daily | NA |
| 20minutes | 20 Minutes | 2006 | 2026 | \- | 2 | daily | with\|associated |
| bfmtv | BFM TV | 2012 | 2026 | \- | 2 | daily | with\|associated |
| challenges | Challenges | 2006 | 2026 | \- | 2 | daily | with\|associated |
| cnews | CNews | 2012 | 2026 | \- | 2 | daily | with\|associated |
| francesoir | France Soir | 2015 | 2026 | \- | 2 | daily | with\|associated |
| gala | Gala | 2008 | 2026 | \- | 2 | daily | with\|associated |
| l_opinion | L’Opinion | 2013 | 2026 | \- | 2 | daily | with\|associated |
| lacroix | La Croix | 1995 | 2024 | \- | 3 | monthly | with\|associated |
| la_depeche | La Dépêche | 2012 | 2026 | \- | 2 | daily | with\|associated |
| laprovence | La Provence | 2014 | 2026 | \- | 2 | daily | with\|associated |
| latribune | La Tribune | 2015 | 2026 | \- | 2 | daily | with\|associated |
| le_capital | Le Capital | 2009 | 2026 | \- | 2 | daily | with\|associated |
| le_courrier_de_l_ouest | Le Courrier de l’Ouest | 2019 | 2026 | \- | 2 | daily | with\|associated |
| le_figaro | Le Figaro (web) | 2006 | 2026 | \- | 2 | daily | with\|associated |
| le_journal_du_dimanche | Le Journal du Dimanche | 2008 | 2026 | \- | 2 | daily | with\|associated |
| le_maine_libre | Le Maine Libre | 2019 | 2026 | \- | 2 | daily | with\|associated |
| le_marin | Le Marin | 2013 | 2026 | \- | 2 | daily | with\|associated |
| le_monde | Le Monde | 1945 | 2026 | \- | 2 | daily | with\|associated |
| le_nouvel_observateur | Le Nouvel Observateur | 2010 | 2026 | \- | 2 | daily | with\|associated |
| le_telegramme | Le Télégramme | 2009 | 2011 | \- | 2 | daily | with\|associated |
| leparisien | Le Parisien | 2001 | 2024 | \- | 2 | monthly | with\|associated |
| les_echos | Les Échos | 1991 | 2026 | \- | 2 | daily | with\|associated |
| marianne | Marianne | 2019 | 2026 | \- | 2 | daily | with\|associated |
| mediapart | Mediapart | 2008 | 2026 | \- | 2 | daily | with\|associated |
| midilibre | Midi Libre | 2011 | 2026 | \- | 2 | daily | with\|associated |
| nice_matin | Nice-Matin | 2015 | 2026 | \- | 2 | daily | with\|associated |
| ouest_france | Ouest-France | 2012 | 2026 | \- | 2 | daily | with\|associated |
| paris_match | Paris Match | 2009 | 2026 | \- | 2 | daily | with\|associated |
| paris_normandie | Paris Normandie | 2021 | 2026 | \- | 2 | daily | with\|associated |
| presse_ocean | Presse Océan | 2019 | 2026 | \- | 2 | daily | with\|associated |
| sud_ouest | Sud Ouest | 2010 | 2017 | \- | 2 | daily | with\|associated |
| telerama | Télérama | 2008 | 2026 | \- | 2 | daily | with\|associated |
| valeurs_actuelles | Valeurs Actuelles | 2008 | 2025 | \- | 2 | daily | with\|associated |
| voici | Voici | 2018 | 2026 | \- | 2 | daily | with\|associated |
| voiles_et_voiliers | Voiles et Voiliers | 2009 | 2026 | \- | 2 | daily | with\|associated |

Additional information on Gallicagram can be found on a
[preprint](https://osf.io/preprints/socarxiv/84bf3/) by Gallicagram
developers [Benoît de Courson](https://regicid.github.io/) and Benjamin
Azoulay and on the “Notice” tab of the [Gallicagram
website](https://shiny.ens-paris-saclay.fr/app/gallicagram).
