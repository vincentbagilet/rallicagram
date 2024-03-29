% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gallicagraph_associated.R
\name{gallicagraph_associated}
\alias{gallicagraph_associated}
\title{Graph describing the most common co-occurrences with a keyword or lexicon}
\usage{
gallicagraph_associated(data, labels_color = NA)
}
\arguments{
\item{data}{A data frame produced by the \code{gallicagram_associated} or
\code{gallicagram_associated_lexicon} functions}

\item{labels_color}{A character string. The color in which to print
the labels. Set to \code{NA} for no label.}
}
\value{
A graph describing the most common co-occurrences with a keyword
or lexicon.
}
\description{
Takes as input data produced by \code{gallicagram_associated} or
\code{gallicagram_associated_lexicon} and produces a graph
describing the words the most commonly co-occurring with the keyword
or lexicon of interest
}
\examples{
  gallicagram_associated("président", from = 2020) |>
    gallicagraph_associated(labels_color = "white")
}
