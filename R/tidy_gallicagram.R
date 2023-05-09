#' Internal function to prepare the parameters to use them in the API call.
#'
#' @param data A data frame produced by the Gallicagram API
#' @inheritParams gallicagram
#'
#' @importFrom rlang .data
#'
#' @returns A tibble. With the \code{keyword},
#' the number of occurrences (\code{nb_occur}) or co-occurrences
#' (\code{nb_cooccur}), the total number of ngrams over the period of a
#' given observation (\code{nb_grams} or \code{nb_ngrams}),
#' the proportion of occurrences or co-occurrences of the keyword(s) over the
#' period of a given observation (\code{prop_occcur} or \code{prop_coocccur}),
#' the date at the beginning of the period of a given observation (\code{date}),
#' the \code{source}, the \code{resolution},
#' the \code{year} and
#' potentially the \code{month} and \code{day} of the observation.
#'
tidy_gallicagram <- function(data, corpus, resolution) {

  data |>
    utils::read.csv() |>
    dplyr::as_tibble() |>
    dplyr::rename(keyword = "gram", year = "annee") |>
    dplyr::rename(
      tidyselect::any_of(c(month = "mois", day = "jour"))
    ) |>
    dplyr::mutate(
      prop = .data$n / .data$total,
      source = corpus,
      resolution = resolution,
      month_pad = ifelse(resolution == "yearly", 01, .data$month),
      day_pad = ifelse(resolution != "daily", 01, .data$day),
      date = as.Date(
        paste(.data$year, .data$month_pad, .data$day_pad, sep = "-")
      )
    ) |>
    dplyr::select("date", "keyword", "n", "total", "prop",
                  tidyselect::everything(), -"month_pad", -"day_pad")

}
