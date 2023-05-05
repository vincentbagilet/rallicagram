#' Retrieves the number of occurrences of a keyword in one of the corpora
#' (historical press, Gallica books, Le Monde newspaper)
#'
#' @param keyword A character string. Keyword to search.
#' @param corpus A character string. The corpus to search. Takes the following
#' values: "presse" or "press" for historical press, "livres" or "books" for
#' Gallica books, "lemonde" for Le Monde newspaper articles.
#' @param begin A number. Starting year.
#' @param end A number. End year.
#'
#' @returns A numeric vector.
#'
#' @export
#' @examples
#' rallicagram_search("président")
rallicagram_search <- function(keyword,
                               corpus="presse",
                               begin=1789,
                               end=1950) {

  keyword_clean <- str_replace(tolower(keyword)," ","%20")

  # clean corpus name
  if (corpus %in% c("presse", "press")) {
    corpus_clean <- "presse"
  } else if (corpus %in% c("books", "livres")) {
    corpus_clean <- "livres"
  } else if (corpus == "lemonde") {
    corpus_clean <- "lemonde"
  } else {
    stop("Invalid corpus name")
  }

  if (!is.numeric(as.numeric(begin)) | !is.numeric(as.numeric(end))) {
    stop("'begin' and 'end' should be numeric")
  }

  api_call <- paste(
    "https://shiny.ens-paris-saclay.fr/guni/query?corpus=",
    corpus,
    "&mot=",
    keyword_clean,
    "&from=",
    begin,
    "&to=",
    end,
    sep="")

  api_call |>
    read_csv()

  # return(read.csv(api_call))
}
