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
