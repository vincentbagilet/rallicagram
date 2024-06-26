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
#' The string cannot contain more words than the \code{max_length}
#' for this corpus, as indicated in the \code{list_corpora} dataset.
#' @param corpus A character string. The corpus to search. The list of
#' available corpora can be found in the \code{list_corpora} dataset.
#' @param from An integer or "earliest". The starting year.
#' If set to "earliest", it uses the earliest date at which the data is reliable
#' for this corpus, as described in \code{list_corpora}.
#' @param to An integer or "latest". The end year.
#' If set to "latest", it uses the latest date at which the data is reliable
#' for this corpus, as described in \code{list_corpora}.
#' @param resolution A character string. Can only be "daily", "monthly" or
#' "yearly".
#' The finest available resolution for the corpus selected can be found
#' in the \code{resolution} column of the \code{list_corpora} dataset.
#' @param n_of A character string. The type of object to the compute number of
#' occurrences for. If set to "grams", the function will compute the number
#' of "grams" that correspond to the keyword for the given period.
#' If set to "articles"
#' (only available for lemonde and for unigrams, ie for keywords only made of
#' one word), will compute the number of articles that contain the
#' keyword for the given period.
#' @param subcorpora A character vector. The subcorpora to consider.
#' Only available for \code{corpus = persee}. The list of available Persee
#' subcorpora can be found in the \code{list_subcorpora} dataset.
#'
#' @inherit tidy_gallicagram return
#'
#' @examples
#'   gallicagram("président")
#'
#' @export
gallicagram <- function(keyword,
                        corpus = "lemonde",
                        from = "earliest",
                        to = "latest",
                        resolution = "monthly",
                        n_of = "grams",
                        subcorpora = NULL) {

  param_clean <-
    prepare_param(keyword, corpus, from, to, resolution, n_of, subcorpora)

  spaces_keyword <-
    attr(gregexpr(" ", keyword, fixed = TRUE)[[1]], "match.length")
  nb_words_keyword <-
    ifelse(spaces_keyword == -1, 1, length(spaces_keyword) + 1)

  output <- paste("https://shiny.ens-paris-saclay.fr/guni/query",
                  ifelse(
                    n_of == "articles" & corpus == "lemonde",
                    "_article",
                    ifelse(corpus == "persee",
                           "_persee",
                           "")
                  ),
                  "?corpus=",
                  param_clean$corpus,
                  "&mot=",
                  param_clean$keyword,
                  "&from=",
                  param_clean$from,
                  "&to=",
                  param_clean$to,
                  "&resolution=",
                  param_clean$resolution_fr,
                  ifelse(
                    param_clean$subcorpora != "",
                    paste("&revue=", param_clean$subcorpora, sep = ""),
                    ""
                  ),
                  sep = "") |>
    tidy_gallicagram(param_clean$corpus, param_clean$resolution_en) |>
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
