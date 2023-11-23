#' Occurrences of a keyword in a Gallicagram copus
#'
#' @description
#' Retrieves the proportion of occurrences of a keyword in one of the corpora
#' (historical press, Gallica books, Le Monde newspaper) by year, month or day.
#'
#' @details
#' This function corresponds to the \code{Query} route of the API.
#'
#' @param keyword A character string. Keyword to search. Can be up to a 3-gram
#' in the "books" and "press" corpora and a 4-gram in the "lemonde" corpus.
#' @param corpus A character string. The corpus to search. Takes the following
#' values: "press" for historical press, "books" for Gallica books,
#' "lemonde" for Le Monde newspaper articles.
#' @param from An integer. Starting year.
#' @param to An integer. End year.
#' @param resolution A character string.
#' For lemonde can be either "yearly", "monthly" or "daily".
#' For press can be either "yearly" or "monthly".
#' For books can only be "yearly".
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
                        resolution = "monthly",
                        n_of = "grams") {

  param_clean <- prepare_param(keyword, corpus, from, to, resolution, n_of)

  spaces_keyword <-
    attr(gregexpr(" ", keyword, fixed = TRUE)[[1]], "match.length")
  nb_words_keyword <- ifelse(spaces_keyword == -1, 1, length(spaces_keyword)+1)

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
