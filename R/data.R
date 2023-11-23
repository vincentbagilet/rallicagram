#' A vector containing the most frequent words in the Gallica books corpus
#'
#' Sorted from most to less frequent word
#'
#' @format A length 1000 vector.
"stopwords_gallica"


#' A data frame containing a words, their lemma and stem of the lemma
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
#' It includes the years for which the data is reliable,
#' the number of words in each corpora, the code to use in the API,
#' the maximum length of the ngrams, and the resolution.
#'
#' @format A data frame with 17 rows and 7 variables:
#' \describe{
#'   \item{title}{The title of the corpus.}
#'   \item{start_reliable}{The year after which the corpus starts being reliable.}
#'   \item{end_reliable}{The year after which the corpus stops being reliable.}
#'   \item{nb_words}{The number of words in the corpus.}
#'   \item{code_api}{The code for to call the corpus in the API.}
#'   \item{max_length}{The maximum length of ngrams available.}
#'   \item{resolution}{The finest available resolution (e.g., daily, monthly, yearly).}
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
