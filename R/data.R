#' A vector containing the most frequent words in the Gallica books corpus
#'
#' Sorted from most to less frequent word
#'
#' @format A length 1000 vector.
"stopwords_gallica"


#' A data frame containing words, their lemmas and stem of the lemmas
#'
#' The lemmas come from the \href{http://www.lexique.org/}{Lexique} data base.
#' The stems are obtained by stemming these lemmas using the \code{SnowballC}
#' package.
#'
#' This data frame can be used to get a vector of words that are closely related
#' to a keyword of interest.
#'
#' @format A data frame with 3 columns and 142,694 rows.
"word_lemma_stem"

#' A data frame containing information about the available corpora
#'
#' It includes the code name of the corpus, its plain language name,
#' the years for which the data is reliable,
#' the number of words in each corpus,
#' the maximum length of the ngrams, and the resolution.
#'
#' @format A data frame with 17 rows and 7 variables:
#' \describe{
#'   \item{corpus}{Code name of the corpus.}
#'   \item{corpus_name}{Plain language name of the corpus.}
#'   \item{reliable_from}{The year at which the corpus starts being reliable.}
#'   \item{reliable_to}{The year at which the corpus stops being reliable.}
#'   \item{nb_words}{The number of words in the corpus.}
#'   \item{max_length}{The maximum length of ngrams available.}
#'   \item{resolution}{The finest available resolution (daily, monthly, yearly)}
#' }
#'
#' @examples
#' \dontrun{
#'   # Load the dataset
#'   data("list_corpora")
#' }
#'
#' @usage data("list_corpora")
"list_corpora"

#' A data frame containing information about the available subcorpora
#'
#' It includes the code name of the corpus and subcorpus,
#' its plain language name,
#' the years for which the data is reliable,
#' and the academic disciplines it relates too.
#'
#' @format A data frame with 368 rows and 6 variables:
#' \describe{
#'   \item{corpus}{Code name of the corpus.}
#'   \item{subcorpus}{Code name of the subcorpus.}
#'   \item{subcorpus_name}{Plain language name of the subcorpus.}
#'   \item{reliable_from}{The year at which the subcorpus starts being reliable.}
#'   \item{reliable_to}{The year at which the subcorpus stops being reliable.}
#'   \item{disciplines}{The academic disciplines associated with this subcopus.}
#' }
#'
#' @examples
#' \dontrun{
#'   # Load the dataset
#'   data("list_corpora")
#' }
#'
#' @usage data("list_subcorpora")
"list_subcorpora"

