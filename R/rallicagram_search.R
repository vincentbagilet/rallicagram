#' Retrieves the number of occurrences of a keyword in one of the corpora
#' (historical press, Gallica books, Le Monde newspaper)
#'
#' @param keyword A character string. Keyword to search.
#' @param corpus A character string. The corpus to search. Takes the following
#' values: "press" for historical press, "books" for Gallica books,
#' "lemonde" for Le Monde newspaper articles.
#' @param begin A number. Starting year.
#' @param end A number. End year.
#' @param frequency A number. End year.
#'
#' @returns A tibble.
#'
#' @export
#' @examples
#' rallicagram_search("président")
rallicagram_search <- function(keyword,
                               corpus="press",
                               begin=1789,
                               end=1950,
                               frequency="monthly") {

  if (!is.numeric(as.numeric(begin)) | !is.numeric(as.numeric(end))) {
    stop("'begin' and 'end' should be numeric", call. = FALSE)
  }

  if (!is.character(keyword)) {
    stop("'keyword' should be a character string", call. = FALSE)
  }

  #translations
  resolution <- ifelse(frequency == "yearly", "annee",
                       ifelse(frequency == "monthly", "mois",
                       ifelse(frequency == "daily", "jour",
                          stop("Invalid frequency", call. = FALSE))))

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
                  begin,
                  "&to=",
                  end,
                  "&resolution=",
                  resolution,
                  sep="") |>
    utils::read.csv() |>
    #tidy
    dplyr::as_tibble() |>
    dplyr::rename(keyword = "gram", year = "annee") |>
    dplyr::rename(
      tidyselect::any_of(c(month = "mois", day = "jour"))
    ) |>
    dplyr::mutate(
      source = corpus,
      frequency = frequency,
      month = ifelse(frequency == "yearly", 01, month),
      day = ifelse(frequency != "daily", 01, day),
      date = as.Date(paste(year, month, day, sep = "-"))
    ) |>
    dplyr::select(date, keyword, "n", total, source, frequency)

  return(output)
}

