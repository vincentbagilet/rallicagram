#' Retrieves the number of occurrences of a keyword in one of the corpora
#' (historical press, Gallica books, Le Monde newspaper) by year, month or day.
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
#' @importFrom rlang .data
#'
#' @returns A tibble. With the `keyword`, the number of occurrences (`n`),
#' the total number of ngrams over the period of a given observation (`total`),
#' the proportion of occurrences of the keyword over the period of
#' a given observation (`prop`),
#' the date at the beginning of the period of a given observation (`date`),
#' the `source`, the `resolution`,
#' the `year` and potentially the `month` and `day` of the observation.
#'
#' @export
#' @examples
#' gallicagram("président")
gallicagram <- function(keyword,
                        corpus="press",
                        from=1789,
                        to=1950,
                        resolution="monthly") {

  if (!is.numeric(as.numeric(from)) | !is.numeric(as.numeric(to))) {
    stop("'from' and 'to' should be numeric", call. = FALSE)
  }

  if (!is.character(keyword)) {
    stop("'keyword' should be a character string", call. = FALSE)
  }

  #translations
  resolution_french <- ifelse(resolution == "yearly", "annee",
                       ifelse(resolution == "monthly", "mois",
                       ifelse(resolution == "daily", "jour",
                          stop("Invalid resolution", call. = FALSE))))

  corpus_french <- ifelse(corpus == "press", "presse",
                          ifelse(corpus == "books", "livres",
                          ifelse(corpus == "lemonde", "lemonde",
                            stop("Invalid corpus name", call. = FALSE))))

  keyword_clean <- sub(" ","%20", tolower(keyword))

  output <- paste("https://shiny.ens-paris-saclay.fr/guni/query?corpus=",
                  corpus_french,
                  "&mot=",
                  keyword_clean,
                  "&from=",
                  from,
                  "&to=",
                  to,
                  "&resolution=",
                  resolution_french,
                  sep="") |>
    utils::read.csv() |>
    #tidy
    dplyr::as_tibble() |>
    dplyr::rename(keyword = "gram", year = "annee") |>
    dplyr::rename(
      tidyselect::any_of(c(month = "mois", day = "jour"))
    ) |>
    dplyr::mutate(
      prop = .data$n/.data$total,
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

  return(output)
}

