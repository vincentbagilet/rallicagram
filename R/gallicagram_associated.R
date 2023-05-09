#' Find the word the most often associated with a n-gram
#'
#' @description
#' Returns the word the most frequently following a given ngram over the period.
#' It can also include the words that precede by setting \code{after = FALSE}.
#'
#' @details
#' This function corresponds to the \code{Joker} route of the API,
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
#' @param nb_joker An integer. The number of most frequent occurrences to
#'  return.
#' @param after A boolean. Whether to consider only words following the keyword
#' and not those preceding. Set to \code{TRUE} by default.
#' @inheritParams gallicagram
#'
#' @returns A tibble. With the most frequent ngrams  containing the
#' \code{keyword} mentioned (\code{ngram}) and the number of occurrences
#' over the period (\code{nb_occur}). It also returns the input parameters
#' \code{keyword}, \code{corpus}, \code{from} and \code{to}.
#'
#' @export
#' @examples
#' gallicagram_associated("camarade")
gallicagram_associated <- function(keyword,
                                corpus = "lemonde",
                                from = 1945,
                                to = 2022,
                                nb_joker = 20,
                                after = TRUE) {

  if (length(keyword) != 1) {
    stop(
      "'keyword' should be a character string and not a character vector",
      call. = FALSE
    )
  }

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
                  nb_joker,
                  "&after=",
                  ifelse(after, "True", "False"),
                  sep = "") |>
    utils::read.csv() |>
    dplyr::as_tibble() |>
    dplyr::rename("nb_occur" = "tot", "ngram" = "gram") |>
    dplyr::mutate(
      keyword = keyword,
      corpus = param_clean$corpus,
      from = from,
      to = to
    )

  return(output)
}
