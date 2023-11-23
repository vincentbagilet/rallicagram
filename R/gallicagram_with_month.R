#' ngrams that most frequently contain a keyword in a Gallicagram corpus for a
#' specific month
#'
#' @description
#' Returns the most frequent ngrams containing a keyword for a given month
#'
#' @details
#' This function corresponds to the \code{joker_month} route of the API.
#'
#' It is analogous to \code{gallicagram_with} but for a precise month instead
#' of a given period.
#'
#' For instance "camarade" is often followed by "staline" or "khrouchtchev" in
#' Le Monde. The function returns the most frequent ngrams of the form
#' "camarade *" when setting \code{after = TRUE}. \code{after = FALSE} also
#' includes the most frequent ngrams of the form "* camarade".
#'
#' Searching the "press" corpus can require a long running time.
#'
#' @param year An integer. The year of interest.
#' @param month An integer. The month of the \code{year} of interest.
#' @inheritParams gallicagram_with
#'
#' @returns A tibble. With the \code{n_results} most frequent ngrams containing
#' the \code{keyword} searched (\code{ngram})
#' and the number of occurrences over the period (\code{n_occur}).
#' It also returns the input parameters
#' \code{keyword}, \code{corpus}, \code{year} and \code{month}.
#'
#' @export
#' @examples
#' gallicagram_with_month("camarade", length = 2)
gallicagram_with_month <- function(keyword,
                                   corpus = "lemonde",
                                   year = 2022,
                                   month = 1,
                                   n_results = 20,
                                   after = FALSE,
                                   length = 2) {

  #errors handling
  if (!is.numeric(length)) {
    stop("'length' should be numeric", call. = FALSE)
  }

  max_length_corpus <- rallicagram::list_corpora |>
    dplyr::filter(corpus == param_clean$corpus) |>
    dplyr::pull(max_length)

  if (length > max_length_corpus) {
    stop(
      paste(
        "'length' cannot be more than", max_length_corpus, "for this corpus"
      ),
      call. = FALSE)
  }

  if (length < length(strsplit(x = keyword, split = " ")[[1]])) {
    stop(
      "'length' has to be larger than the number of words in 'keyword'",
      call. = FALSE
    )
  }

  if (!is.numeric(year) || !is.numeric(month)) {
    stop("'year' and 'month' should be numeric", call. = FALSE)
  }

  if (grepl("\\'", keyword)) {
    stop("'keyword' cannot contain an apostrophe.
         Specifying a keyword without the apostrophe will also return words
         associated with the apostrophe version of the keyword.", call. = FALSE)
  }

  param_clean <-
    prepare_param(keyword, corpus, year, year, resolution = "yearly")
  # param resolution not used

  output <- paste("https://shiny.ens-paris-saclay.fr/guni/joker_mois?corpus=",
                  param_clean$corpus,
                  "&mot=",
                  param_clean$keyword,
                  "&year=",
                  year,
                  "&month=",
                  month,
                  "&n_joker=",
                  n_results,
                  "&after=",
                  ifelse(after, "True", "False"),
                  "&length=",
                  length,
                  sep = "") |>
    read_data_gallicagram() |>
    dplyr::rename("n_occur" = "tot", "ngram" = "gram") |>
    dplyr::mutate(
      keyword = keyword,
      corpus = param_clean$corpus,
      year = year,
      month = month
    )

  return(output)
}
