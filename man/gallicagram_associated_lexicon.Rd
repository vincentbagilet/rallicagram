% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gallicagram_associated_lexicon.R
\name{gallicagram_associated_lexicon}
\alias{gallicagram_associated_lexicon}
\title{Words the most often associated with a vector of keywords
in a Gallicagram corpus}
\usage{
gallicagram_associated_lexicon(
  lexicon,
  corpus = "lemonde",
  from = 1945,
  to = 2022,
  n_results = 20,
  distance = 3,
  stopwords = rallicagram::stopwords_gallica[1:500]
)
}
\arguments{
\item{lexicon}{A character vector. Keywords to search. Can contain up to
a 3-gram in the "books" and "press" corpora and
a 4-gram in the "lemonde" corpus.}

\item{corpus}{A character string. The corpus to search. Takes the following
values: "press" for historical press, "books" for Gallica books,
"lemonde" for Le Monde newspaper articles.}

\item{from}{An integer. Starting year.}

\item{to}{An integer. End year.}

\item{n_results}{An integer. The number of most frequently
associated words to return. \code{n_results} can also be set to "all" to
return all the available results.}

\item{distance}{An integer. The word distance to which look for words
associated with the keyword.}

\item{stopwords}{A character vector of stopwords to remove.
The default is the vector of the 500 most frequent words in the Gallica
books dataset. We can change this number by passing
\code{stopwords_gallicca[1:300]} (for instance, for the 300 most frequent)
to the \code{stopwords} argument. Can also be \code{lsa::stopwords_fr}
If \code{NULL} does not remove any stopwords.}
}
\value{
A tibble. With the words the most frequently associated with any of
the keywords in the \code{lexicon} mentioned (\code{associated_word}),
the first \code{keyword} in this lexicon, typically the main one
and the number of occurrences over the period (\code{n_occur}).
It also returns the input parameters
\code{keyword}, \code{corpus}, \code{from} and \code{to}.
}
\description{
Returns the word the most frequently at a given number of words
(\code{distance}) from any of the keywords in the vector.
}
\details{
This function sums the outputs of calls of \code{gallicagram_associated}
obtained for each keyword in the vector.

Can typically be used with the function \code{get_same_stem()}.
}
\examples{
gallicagram_associated_lexicon(c("président", "présidentiel"))
}
