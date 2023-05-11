#' Close co-occurrences of two keywords in a Gallicagram copus
#'
#' @description
#' Retrieves the proportion of close co-occurrences of two keywords in one of
#' the corpora (historical press, Gallica books, Le Monde newspaper)
#' by year, month or day.
#'
#' @details
#' Close co-occurrences correspond to the number of 3-grams
#' (4-grams in the Le Monde corpus) that contain the two keywords.
#'
#' This function corresponds to the \code{Contain} route of the API.
#'
#' @param keyword_1 A character string. One of the two keywords to search.
#' @param keyword_2 A character string. The other keyword to search.
#' @param resolution A character string.
#' For press and lemonde can be either "yearly" or "monthly".
#' For books can only be "yearly".
#' @inheritParams gallicagram
#'
#' @inherit tidy_gallicagram return
#'
#' @importFrom rlang .data
#'
#' @export
#' @examples
#' gallicagram_cooccur("président", "mauvais")
gallicagram_cooccur <- function(keyword_1,
                                keyword_2,
                                corpus = "lemonde",
                                from = 1945,
                                to = 2022,
                                resolution = "monthly") {

  param_clean <- prepare_param(keyword_1, corpus, from, to, resolution)
  param_clean_2 <- prepare_param(keyword_2, corpus, from, to, resolution)

  output <- paste("https://shiny.ens-paris-saclay.fr/guni/contain?corpus=",
                  param_clean$corpus,
                  "&mot1=",
                  param_clean$keyword,
                  "&mot2=",
                  param_clean_2$keyword,
                  "&from=",
                  from,
                  "&to=",
                  to,
                  sep = "") |>
    tidy_gallicagram(corpus, resolution) |>
    dplyr::select(-"keyword") |>
    dplyr::mutate(
      keyword_1 = keyword_1,
      keyword_2 = keyword_2,
    ) |>
    dplyr::rename(
      "n_cooccur" = "n",
      "n_ngrams" = "total",
      "prop_cooccur" = "prop"
    ) |>
    dplyr::select("date", "keyword_1", "keyword_2", tidyselect::everything())

  #can't specify the resolution in the API. Always monthly for press and lemonde
  #thus, average by hand
  if (resolution == "yearly" && corpus %in% c("press", "lemonde")) {
    output <- output |>
      dplyr::group_by(.data$year) |>
      dplyr::mutate(
        n_cooccur = sum(.data$n_cooccur),
        n_ngrams = sum(.data$n_ngrams),
        prop_cooccur = .data$n_cooccur / .data$n_ngrams
      ) |>
      dplyr::ungroup() |>
      dplyr::select(-"month") |>
      dplyr::distinct()
  }

  return(output)
}
