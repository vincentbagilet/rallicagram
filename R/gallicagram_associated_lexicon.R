#' Words the most often associated with a vector of keywords
#' in a Gallicagram corpus
#'
#' @description
#' Returns the word the most frequently at a given number of words
#' (\code{distance}) from any of the keywords in the vector.
#'
#' @details
#' This function sums the outputs of calls of \code{gallicagram_associated}
#' obtained for each keyword in the vector.
#'
#' Can typically be used with the function \code{get_same_stem()}.
#'
#' This function is only available for the three main corpora
#' (historical press, Gallica books, Le Monde newspaper).
#'
#' @param lexicon A character vector. Keywords to search.
#'
#' @inheritParams gallicagram_associated
#'
#' @importFrom rlang .data
#'
#' @returns A tibble. With the words the most frequently associated with any of
#' the keywords in the \code{lexicon} mentioned (\code{associated_word}),
#' the first \code{keyword} in this lexicon, typically the main one
#' and the number of co-occurrences between the keyword and the associated
#' word over the period (\code{n_co-occur}).
#' It also returns the input parameters
#' \code{keyword}, \code{corpus}, \code{from} and \code{to}.
#'
#' @export
#' @examples
#' \dontrun{
#'   gallicagram_associated_lexicon(c("président", "présidentiel"))
#' }
gallicagram_associated_lexicon <- function(lexicon,
                                           corpus = "lemonde",
                                           from = "earliest",
                                           to = "latest",
                                           n_results = 20,
                                           distance = "max",
                        stopwords = rallicagram::stopwords_gallica[1:500]) {

  output <- NULL

  #to check for errors
  param_clean <- prepare_param("a", corpus, from, to, "yearly")

  if(!is.character(lexicon) | !is.vector(lexicon)) {
    stop("'lexicon' must be a character vector.")
  }

  for (keyword in lexicon) {
      output <- output |>
        rbind(gallicagram_associated(
          keyword, corpus, from, to, n_results = 10000001, distance, stopwords
        ))
  }

  output <- output |>
    dplyr::mutate(keyword = lexicon[1]) |>
    dplyr::group_by(.data$associated_word) |>
    dplyr::mutate(n_cooccur = sum(.data$n_cooccur)) |>
    dplyr::ungroup() |>
    dplyr::distinct() |>
    dplyr::arrange(dplyr::desc(.data$n_cooccur)) |>
    dplyr::mutate(
      lexicon = paste(lexicon, collapse = "+")
    ) |>
    dplyr::slice(1:n_results)

  return(output)
}
