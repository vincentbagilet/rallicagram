#' Internal function to tidy the output of the API call.
#'
#' @description
#' Turns the Gallicagram API data into a tibble, renames the variables and
#' add the input parameters to the output tibble.
#'
#' @param url A url to pass the Gallicagram API
#' @param resolution_en A character string. Can only be "daily", "monthly" or
#' "yearly".
#' @inheritParams gallicagram
#'
#' @importFrom rlang .data
#'
#' @returns A tibble. With the \code{keyword},
#' the number of occurrences (\code{n_occur}) or co-occurrences
#' (\code{n_cooccur}), the total number of ngrams over the period of a
#' given observation (\code{n_grams} or \code{n_ngrams}),
#' the proportion of occurrences or co-occurrences of the keyword(s) over the
#' period of a given observation (\code{prop_occcur} or \code{prop_coocccur}),
#' the date at the beginning of the period of a given observation (\code{date}),
#' the \code{corpus}, the \code{resolution},
#' the \code{year} and
#' potentially the \code{month} and \code{day} of the observation.
#'
tidy_gallicagram <- function(url, corpus, resolution_en) {

  url |>
    read_data_gallicagram() |>
    dplyr::rename(keyword = "gram", year = "annee") |>
    dplyr::rename(
      tidyselect::any_of(c(
        month = "mois",
        day = "jour",
        n = "nb_articles_occur",
        total = "nb_total_article",
        n = "nb_articles_cooccur",
        total = "nb_articles_cooccur"
      ))
    ) |>
    dplyr::mutate(
      prop = .data$n / .data$total,
      corpus = corpus,
      resolution = resolution_en,
      month_pad = ifelse(resolution_en == "yearly", 01, .data$month),
      day_pad = ifelse(resolution_en != "daily", 01, .data$day),
      date = as.Date(
        paste(.data$year, .data$month_pad, .data$day_pad, sep = "-")
      )
    ) |>
    dplyr::select("date", "keyword", "n", "total", "prop",
                  tidyselect::everything(), -"month_pad", -"day_pad")

}
