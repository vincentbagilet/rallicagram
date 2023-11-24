#' Close co-occurrences of two keywords in a Gallicagram copus
#'
#' @description
#' Retrieves the proportion of close co-occurrences of two keywords in one of
#' the corpora by year, month or day.
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
#' @param count_period If FALSE, counts the co-occurrences of each phrase
#' containing both keywords.
#' If TRUE, returns the number of times both keywords co-occur
#' in each resolution period.
#' @inheritParams gallicagram
#'
#' @inherit tidy_gallicagram return
#'
#' @importFrom rlang .data
#'
#' @export
#' @examples
#' \dontrun{
#'   gallicagram_cooccur("président", "mauvais")
#' }
gallicagram_cooccur <- function(keyword_1,
                                keyword_2,
                                corpus = "lemonde",
                                from = "earliest",
                                to = "latest",
                                resolution = "monthly",
                                count_period = TRUE,
                                n_of = "grams") {

  param_clean <- prepare_param(keyword_1, corpus, from, to, resolution)
  param_clean_2 <- prepare_param(keyword_2, corpus, from, to, resolution)

  output <- paste("https://shiny.ens-paris-saclay.fr/guni/",
                  ifelse(
                    n_of == "article" & corpus == "lemonde",
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
                  "&count=",
                  ifelse(count_period, "True", "False"),
                  sep = "") |>
    tidy_gallicagram(corpus, resolution) |>
    dplyr::rename(
      "gram" = "keyword",
      "n_cooccur" = "n",
      "n_ngrams" = "total",
      "prop_cooccur" = "prop"
    ) |>
    dplyr::mutate(
      keyword_1 = keyword_1,
      keyword_2 = keyword_2,
      gram = ifelse(.data$gram == "", NA, .data$gram),
      n_of = ifelse(n_of == "grams",
                        ifelse(corpus == "lemonde", "4-grams", "3-grams"),
                        "article")
    ) |>
    dplyr::select("date", "keyword_1", "keyword_2", tidyselect::everything())

  #gram = keyword_1&keyword_2 when count_period = TRUE so redundant
  if (count_period) {
    output <- dplyr::select(output, -"gram")
  }

  #can't specify the resolution in the API. Always monthly for press and lemonde
  #thus, average by hand
  if (resolution == "yearly" && corpus %in% c("press", "lemonde")) {
    output <- output |>
      dplyr::group_by(.data$year) |>
      dplyr::mutate(
        n_cooccur = sum(.data$n_cooccur),
        n_total = sum(.data$n_ngrams),
        prop_cooccur = .data$n_cooccur / .data$n_ngrams
      ) |>
      dplyr::ungroup() |>
      dplyr::select(-"month") |>
      dplyr::distinct()
  }

  return(output)
}
