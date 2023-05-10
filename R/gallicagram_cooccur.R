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
#' @param keywords A character vector of length 2
#' containing the two keyword to search.
#' @inheritParams gallicagram
#'
#' @inherit tidy_gallicagram return
#'
#' @export
#' @examples
#' gallicagram_cooccur(c("président", "mauvais"))
gallicagram_cooccur <- function(keywords,
                                corpus = "lemonde",
                                from = 1945,
                                to = 2022,
                                resolution = "monthly") {

  if (length(keywords) != 2) {
    stop(
      "'keywords' should be a length 2 character vector",
      call. = FALSE
    )
  }

  param_clean <- prepare_param(keywords, corpus, from, to, resolution)

  output <- paste("https://shiny.ens-paris-saclay.fr/guni/contain?corpus=",
                  param_clean$corpus,
                  "&mot1=",
                  param_clean$keyword[1],
                  "&mot2=",
                  param_clean$keyword[2],
                  "&from=",
                  from,
                  "&to=",
                  to,
                  "&resolution=",
                  param_clean$resolution,
                  sep = "") |>
    tidy_gallicagram(corpus, resolution) |>
    dplyr::rename("keywords" = "keyword") |>
    dplyr::rename(
      "n_cooccur" = "n",
      "n_ngrams" = "total",
      "prop_cooccur" = "prop"
    )

  return(output)
}
