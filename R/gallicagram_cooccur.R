#' Close co-occurrences of two keywords in a Gallicagram copus
#'
#' @description
#' Retrieves the proportion of close co-occurrences of two keywords in one of
#' the three main corpora (historical press, Gallica books, Le Monde newspaper)
#' by year or month.
#'
#' @details
#' Close co-occurrences correspond to the number of 3-grams
#' (4-grams in the Le Monde corpus) that contain the two keywords.
#'
#' This function is only available for the three main corpora
#' (historical press, Gallica books, Le Monde newspaper).
#'
#' This function corresponds to the \code{Contain} route of the API.
#'
#' @param keyword_1 A character string. One of the two keywords to search.
#' @param keyword_2 A character string. The other keyword to search.
#' @param resolution A character string.
#' For press and lemonde can be either "yearly" or "monthly".
#' For books can only be "yearly".
#' @param count_period If FALSE, counts the co-occurrences of each phrase
#' containing both keywords.
#' If TRUE, returns the number of times both keywords co-occur
#' in each resolution period.
#' @param cooccur_level character string. Either "grams" or "article".
#' The level at which to look for co-occurences of the two keywords:
#' in 3-grams for "livres" and "presse" and in 4-grams or article for "lemonde".
#' @inheritParams gallicagram
#'
#' @inherit tidy_gallicagram return
#'
#' @importFrom rlang .data
#'
#' @export
#' @examples
#'   gallicagram_cooccur("président", "mauvais")
gallicagram_cooccur <- function(keyword_1,
                                keyword_2,
                                corpus = "lemonde",
                                from = "earliest",
                                to = "latest",
                                resolution = "monthly",
                                count_period = TRUE,
                                cooccur_level = "grams") {

  param_clean <- prepare_param(keyword_1, corpus, from, to, resolution)
  param_clean_2 <- prepare_param(keyword_2, corpus, from, to, resolution)

  output <- paste("https://shiny.ens-paris-saclay.fr/guni/",
                  ifelse(
                    cooccur_level == "article" & corpus == "lemonde",
                    "cooccur",
                    "contain"
                  ),
                  "?corpus=",
                  param_clean$corpus,
                  "&mot1=",
                  param_clean$keyword,
                  "&mot2=",
                  param_clean_2$keyword,
                  "&from=",
                  param_clean$from,
                  "&to=",
                  param_clean$to,
                  "&resolution=",
                  param_clean$resolution_fr,
                  "&count=",
                  ifelse(count_period, "True", "False"),
                  sep = "") |>
    tidy_gallicagram(param_clean$corpus, param_clean$resolution_en) |>
    dplyr::rename(
      "gram" = "keyword",
      "n_cooccur" = "n",
      "n_ngrams" = "total",
      "prop_cooccur" = "prop"
    ) |>
    dplyr::mutate(
      keyword_1 = keyword_1,
      keyword_2 = keyword_2,
      cooccur_level = ifelse(
        cooccur_level == "article", cooccur_level,
        ifelse(corpus == "lemonde", "4-grams", "3-grams"))
    ) |>
    dplyr::mutate(
      dplyr::across(tidyselect::any_of("gram"), \(x) ifelse(x == "", NA, x))
    ) |>
    dplyr::select("date", "keyword_1", "keyword_2", tidyselect::everything())

  #gram = keyword_1&keyword_2 when count_period = TRUE so redundant
  if (count_period) {
    output <- dplyr::select(output, -"gram")
  }

  return(output)
}
