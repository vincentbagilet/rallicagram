#' Occurrences of a keyword in all Gallicagram corpora
#'
#' @description
#' Retrieves the yearly proportion of occurrences of a keyword in each of the
#' corpora for the longest time range for which the data is available
#' and reliable.
#'
#' @inheritParams gallicagram
#'
#' @inherit tidy_gallicagram return
#'
#' @export
#' @examples
#' \dontrun{
#'   gallicagram_all("président")
#' }
gallicagram_all <- function(keyword) {

  keyword_clean <- sub(" ", "%20", tolower(keyword))

  output <-
    gallicagram(
      keyword_clean,
      corpus = "lemonde",
      from = 1944,
      to = 2023,
      resolution = "yearly"
    ) |>
    rbind(gallicagram(
      keyword_clean,
      corpus = "press",
      from = 1789,
      to = 1949,
      resolution = "yearly"
    )) |>
    rbind(gallicagram(
      keyword_clean,
      corpus = "books",
      from = 1000,
      to = 1939,
      resolution = "yearly"
    ))

  return(output)
}
