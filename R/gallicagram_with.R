#' ngrams that most frequently contain a keyword in a Gallicagram corpus over a
#' period
#'
#' @description
#' Returns the most frequent ngrams containing a keyword over a given period.
#'
#' @details
#' This function corresponds to the \code{Joker} route of the API,
#' accessed through the 'Joker' function on the Gallicagram app.
#' When length = 1, it is analogous to the 'Joker' function on Ngram Viewer.
#'
#' It is analogous to \code{gallicagram_with_month} but for a period instead of
#' a given month.
#'
#' For instance "camarade" is often followed by "staline" or "khrouchtchev" in
#' Le Monde. The function returns the most frequent ngrams of the form
#' "camarade *" when setting \code{after = TRUE}. \code{after = FALSE} also
#' includes the most frequent ngrams of the form "* camarade".
#'
#' Searching the "presse" corpus can require a long running time.
#'
#' @param n_results An integer. The number of most frequently
#' associated words to return. \code{n_results} can also be set to "all" to
#' return all the available results.
#' @param after A boolean. Whether to consider only words following the keyword
#' and not those preceding. Set to \code{FALSE} by default.
#' @param length An integer. The length of the ngrams considered.
#' Can be up to 3 in the "books" and "press" corpora and 4 in the
#' "lemonde" corpus.
#' @inheritParams gallicagram
#'
#' @returns A tibble. With the \code{n_results} most frequent ngrams containing
#' the \code{keyword} searched (\code{ngram})
#' and the number of occurrences over the period (\code{n_occur}).
#' It also returns the input parameters
#' \code{keyword}, \code{corpus}, \code{from} and \code{to}.
#'
#' @export
#' @examples
#' \dontrun{
#'   gallicagram_with("camarade", length = 2)
#' }
gallicagram_with <- function(keyword,
                             corpus = "lemonde",
                             from = 1945,
                             to = 2022,
                             n_results = 20,
                             after = FALSE,
                             length = 2) {

  param_clean <- prepare_param(keyword, corpus, from, to, resolution = "yearly")
  # param resolution not used

  #errors handling
  if (!is.numeric(length)) {
    stop("'length' should be numeric", call. = FALSE)
  }

  max_length_corpus <- rallicagram::list_corpora[
    rallicagram::list_corpora$corpus == param_clean$corpus, "max_length"][[1]]

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

  if (grepl("\\'", keyword)) {
    stop("'keyword' cannot contain an apostrophe.
         Specifying a keyword without the apostrophe will also return words
         associated with the apostrophe version of the keyword.", call. = FALSE)
  }

  output <- paste("https://shiny.ens-paris-saclay.fr/guni/joker?corpus=",
                  param_clean$corpus,
                  "&mot=",
                  param_clean$keyword,
                  "&from=",
                  from,
                  "&to=",
                  to,
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
      from = from,
      to = to
    )

  return(output)
}
