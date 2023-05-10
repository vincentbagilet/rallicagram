#' Occurrences of a keyword in a Gallicagram copus
#'
#' @description
#' Retrieves the proportion of occurrences of a keyword in one of the corpora
#' (historical press, Gallica books, Le Monde newspaper) by year, month or day.
#'
#' @details
#' This function corresponds to the \code{Query} route of the API.
#'
#' @param keyword A character string. Keyword to search.
#' @param corpus A character string. The corpus to search. Takes the following
#' values: "press" for historical press, "books" for Gallica books,
#' "lemonde" for Le Monde newspaper articles.
#' @param from A number. Starting year.
#' @param to A number. End year.
#' @param resolution A character string.
#' For Le Monde can be either "yearly", "monthly" or "daily".
#' For historical press can be either "yearly", "monthly".
#' For books can only only be. "yearly".
#'
#' @inherit tidy_gallicagram return
#'
#' @export
#' @examples
#' gallicagram("président")
gallicagram <- function(keyword,
                        corpus = "lemonde",
                        from = 1945,
                        to = 2022,
                        resolution = "monthly") {

  if (length(keyword) != 1) {
    stop(
      "'keyword' should be a character string and not a character vector",
      call. = FALSE
    )
  }

  param_clean <- prepare_param(keyword, corpus, from, to, resolution)

  output <- paste("https://shiny.ens-paris-saclay.fr/guni/query?corpus=",
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
      "n_grams" = "total",
      "prop_occur" = "prop"
    )

  return(output)
}
