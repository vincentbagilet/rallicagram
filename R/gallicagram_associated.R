#' Words the most often associated with a keyword in a Gallicagram corpus
#'
#' @description
#' Returns the word the most frequently at a given number of words
#' (\code{distance}) from the keyword.
#'
#' @details
#' This functions calls the '\code{associated}' route of the API.
#'
#' Note that the API route does not allow to search for associated words
#' after a punctuation mark.
#' For instance, in "son camarade, le chasseur, a", the function will
#' not count "chasseur" as a word associated with "camarade". The ngram
#' "son camarade le chasseur" is not in the database.
#' Thus, there might be less associated words at a longer distance
#' as it increases the probability of ngrams to be excluded from the database.
#'
#' Apostrophes and letters preceding them are withdrawn from the dataset.
#'
#' Searching the "press" corpus can require a long running time.
#'
#' @param distance An integer. The word distance to which look for words
#' associated with the keyword.
#' @param stopwords A character vector of stopwords to remove.
#' The default is the vector of the 500 most frequent words in the Gallica
#' books dataset. Can also be \code{lsa::stopwords_fr}.
#' If \code{NULL} does not remove any stopwords.
#'
#' @inheritParams gallicagram_with
#'
#' @importFrom rlang .data
#'
#' @returns A tibble. With the words the most frequently associated with the
#' \code{keyword} mentioned (\code{associated_word}),
#' and the number of occurrences over the period (\code{n_occur}).
#' It also returns the input parameters
#' \code{keyword}, \code{corpus}, \code{from} and \code{to}.
#'
#' @export
#' @examples
#' gallicagram_associated("camarade")
gallicagram_associated <- function(keyword,
                                   corpus = "lemonde",
                                   from = 1945,
                                   to = 2022,
                                   n_results = 20,
                                   distance = 3,
                                   stopwords = rallicagram::stopwords_gallica) {

  param_clean <- prepare_param(keyword, corpus, from, to, resolution = "yearly")
  # param resolution not used

  length <- ifelse(
    corpus == "lemonde",
    max(4, length(strsplit(x = keyword, split = " ")[[1]]) + distance),
    max(3, length(strsplit(x = keyword, split = " ")[[1]]) + distance)
  )

  n_joker <- ifelse(is.null(stopwords), n_results, "all")

  #errors handling
  if (!is.numeric(distance)) {
    stop("'distance' should be numeric", call. = FALSE)
  }

  if (corpus %in% c("books", "press") && length > 3) {
    stop("The sum of the number of words in 'keyword' and 'distance'
         cannot be more than 3 for this corpus", call. = FALSE)
  } else if (corpus == "lemonde" && length > 4) {
    stop("The sum of the number of words in 'keyword' and 'distance'
         cannot be more than 4 for this corpus", call. = FALSE)
  }

  if (distance <= 0) {
    stop(
      "'distance' has to be larger than 0",
      call. = FALSE
    )
  }

  output <- paste("https://shiny.ens-paris-saclay.fr/guni/associated?corpus=",
                  param_clean$corpus,
                  "&mot=",
                  param_clean$keyword,
                  "&from=",
                  from,
                  "&to=",
                  to,
                  "&n_joker=",
                  n_joker,
                  "&length=",
                  length,
                  sep = "") |>
    utils::read.csv() |>
    dplyr::as_tibble() |>
    #remove apostrophes
    dplyr::mutate(
      associated_word = sub(
        pattern = "\\w'",
        replacement = "",
        x = .data$gram
      )
    ) |>
    dplyr::group_by(.data$associated_word) |>
    dplyr::summarise(n_occur = sum(.data$tot), .groups = "drop") |>
    dplyr::arrange(dplyr::desc(.data$n_occur)) |>
    #add param
    dplyr::mutate(
      keyword = keyword,
      corpus = param_clean$corpus,
      from = from,
      to = to,
      distance = distance
    )

  #remove stopwords
  if (!is.null(stopwords)) {
    output <- output |>
      dplyr::anti_join(
        dplyr::tibble(associated_word = stopwords),
        by = "associated_word"
      ) |>
      dplyr::slice(1:n_results)
  }

  return(output)
}
