% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prepare_param.R
\name{prepare_param}
\alias{prepare_param}
\title{Internal function to prepare the parameters to use them in the API call.}
\usage{
prepare_param(keyword, corpus, from, to, resolution)
}
\arguments{
\item{keyword}{A character string. Keyword to search. Can be up to a 3-gram
in the "books" and "press" corpora and a 4-gram in the "lemonde" corpus.}

\item{corpus}{A character string. The corpus to search. Takes the following
values: "press" for historical press, "books" for Gallica books,
"lemonde" for Le Monde newspaper articles.}

\item{from}{An integer. Starting year.}

\item{to}{An integer. End year.}

\item{resolution}{A character string.
For lemonde can be either "yearly", "monthly" or "daily".
For press can be either "yearly" or "monthly".
For books can only be "yearly".}
}
\value{
A list.
Contains cleaned function parameters (`keyword`, `corpus` and `resolution`).
}
\description{
Checks potential errors, translates the parameters, set parameters for
the API call.
}
