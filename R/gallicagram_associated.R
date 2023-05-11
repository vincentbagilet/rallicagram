#' Word the most often associated with a n-gram in a Gallicagram corpus
#'
#' @description
#' Returns the word the most frequently used right after a given ngram over the
#' period.
#' It can also include the word that just precedes the ngram
#' by setting \code{after = FALSE}.
#'
#' @details
#' It corresponds to the \code{Joker} route of the API,
#' accessed through the 'Joker' function on the Gallicagram app
#' and is analogous to the 'Joker' function on Ngram Viewer.
#'
#' For instance "camarade" is often followed by "staline" or "khrouchtchev" in
#' Le Monde. The function returns the most frequent ngrams of the form
#' "camarade *". Setting \code{after = FALSE} also includes the most frequent
#' ngrams of the form "* camarade".
#'
#' The keyword can be a 2-gram in the "books" and "press" corpora and a 3-gram
#' in the "lemonde" corpus. Searching the "press" corpus can require a long
#' running time.
#'
#' @param keyword A character string. Keyword to search associations for.
#' @param n_associated_words An integer. The number of most frequently
#' associated words to return.
#' @param after A boolean. Whether to consider only words following the keyword
#' and not those preceding. Set to \code{TRUE} by default.
#' @param stopwords A character vector of stopwords to remove.
#' Can for instance be \code{lsa::stopwords_fr}.
#' Removed after withdrawing apostrophes and letters preceding them.
#' If \code{NULL} does not remove any stopwords.
#' @inheritParams gallicagram
#'
#' @importFrom rlang .data
#'
#' @returns A tibble. With the most frequent ngrams containing the
#' \code{keyword} mentioned (\code{ngram}), the \code{associated_word},
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
                                   n_associated_words = 20,
                                   after = TRUE,
                                   length = NULL,
                                   stopwords = NULL) {

  param_clean <- prepare_param(keyword, corpus, from, to, resolution = "yearly")
  # param resolution not used

  output <- paste("https://shiny.ens-paris-saclay.fr/guni/joker?corpus=",
                  param_clean$corpus,
                  "&mot=",
                  param_clean$keyword,
                  "&from=",
                  from,
                  "&to=",
                  to,
                  "&n_joker=",
                  n_associated_words,
                  "&after=",
                  ifelse(after, "True", "False"),
                  sep = "") |>
    utils::read.csv() |>
    dplyr::as_tibble() |>
    dplyr::rename("n_occur" = "tot", "ngram" = "gram") |>
    dplyr::mutate(
      associated_word = sub( #extract the associated word
        pattern = unique(paste("\\s?(\\w')?", keyword, "\\s?", sep = "")),
        replacement = "",
        x = .data$ngram
      ),
      keyword = keyword,
      corpus = param_clean$corpus,
      from = from,
      to = to
    )

  #remove stopwords
  if (!is.null(stopwords)) {
    output <- output |>
      dplyr::mutate( #remove apostrophes
        associated_word = sub(
          pattern = "\\w'",
          replacement = "",
          x = .data$associated_word
        )
      ) |>
      dplyr::anti_join(
        dplyr::tibble(associated_word = stopwords),
        by = "associated_word"
      )
  }

  return(output)
}
