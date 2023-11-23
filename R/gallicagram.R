#' Occurrences of a keyword in a Gallicagram copus
#'
#' @description
#' Retrieves the proportion of occurrences of a keyword in one of the corpora
#' by year, month or day.
#'
#' @details
#' This function corresponds to the \code{Query} route of the API.
#'
#' Information regarding available characteristics of the corpus can be found
#' in the \code{list_corpora} dataset.
#'
#' @param keyword A character string. Keyword to search.
#' The largest number of words the keyword can contain can be found
#' in the \code{resolution} column of the \code{list_corpora} dataset.
#' @param corpus A character string. The corpus to search. The list of
#' available corpora can be found in the \code{list_corpora} dataset.
#' @param from An integer. Starting year.
#' @param to An integer. End year.
#' The finest available resolution for the corpus selected can be found
#' in the \code{resolution} column of the \code{list_corpora} dataset.
#' @param resolution A character string. Can only be "daily", "monthly" or
#' "yearly".
#' The finest available resolution for the corpus selected can be found
#' in the \code{resolution} column of the \code{list_corpora} dataset.
#'
#' @inherit tidy_gallicagram return
#'
#' @examples
#' \dontrun{
#'   gallicagram("président")
#' }
#'
#' @export
gallicagram <- function(keyword,
                        corpus = "lemonde",
                        from = 1945,
                        to = 2022,
                        resolution = "monthly",
                        n_of = "grams") {

  param_clean <- prepare_param(keyword, corpus, from, to, resolution, n_of)

  spaces_keyword <-
    attr(gregexpr(" ", keyword, fixed = TRUE)[[1]], "match.length")
  nb_words_keyword <-
    ifelse(spaces_keyword == -1, 1, length(spaces_keyword) + 1)

  output <- paste("https://shiny.ens-paris-saclay.fr/guni/query",
                  ifelse(
                    n_of == "article" & corpus == "lemonde",
                    "_article",
                    ""
                  ),
                  "?corpus=",
                  param_clean$corpus,
                  "&mot=",
                  param_clean$keyword,
                  "&from=",
                  from,
                  "&to=",
                  to,
                  "&resolution=",
                  param_clean$resolution,
                  sep = "") |>
    tidy_gallicagram(corpus, resolution) |>
    dplyr::rename(
      "n_occur" = "n",
      "n_total" = "total",
      "prop_occur" = "prop"
    ) |>
    dplyr::mutate(
      n_of = ifelse(
        n_of == "grams",
        paste(nb_words_keyword, "grams", sep = "-"),
        "articles"
      )
    )

  return(output)
}
