#' Retrieves the number of occurrences of a keyword in one of the corpora
#' (historical press, Gallica books, Le Monde newspaper)
#'
#' @param mot_cle A character string. Keyword to search.
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
#' rallicagram_search("president")
rallicagram_search <- function(keyword,
                               corpus="presse",
                               begin=1789,
                               end=1950) {

  keyword_clean <- str_replace(tolower(keyword)," ","%20")
  # if (corpus %in% c("presse", "press")) {
  #   corpus
  # }
  return(read.csv(paste("https://shiny.ens-paris-saclay.fr/guni/query?corpus=",corpus,"&mot=",keyword_clean,"&from=",debut,"&to=",fin,sep="")))
}
