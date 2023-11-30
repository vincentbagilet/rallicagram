#' Internal function to check for errors in the parameters
#'
#' This internal function checks for errors in the specified parameters,
#' including the validity of the time range, the keyword, and the resolution,
#' based on the provided information about the corpus.
#'
#' @param info_corpus A data frame containing information about the selected
#' corpus.
#' @param keyword A character string specifying the keyword for analysis.
#' @param corpus A character string specifying the code of the corpus.
#' @param from An integer or "earliest" representing the starting year
#' for the analysis.
#' @param to An integer or "latest" representing the ending year
#' for the analysis.
#' @param resolution A character string specifying the desired resolution for
#' the analysis (e.g., "daily", "monthly", "yearly").
#' @param n_of A character string specifying the type of object to compute the
#' number of occurrences for.
#'
#'
#' @return This function does not return a value but may issue warnings or
#' errors if any issues are found.
#'
#' @details
#' This function performs the following checks:
#'  \itemize{
#'   \item{Validity of Time Range:}{Ensures that the specified time range
#'   (\code{from} to \code{to}) is numeric and valid.}
#'   \item{Validity of Keyword:}{Checks whether the specified \code{keyword} is
#'   a character string and not a character vector.}
#'   \item{Reliability of Corpus:}{Verifies that the specified time range falls
#'   within the reliable range of the given corpus.}
#'   \item{Validity of Resolution:}{Ensures that the specified
#'   \code{resolution} is one of "daily", "monthly", or "yearly" and is
#'   compatible with the corpus's available resolutions.}
#' }
#'
#' @keywords internal, error
#'
#' @export
error_param <- function(info_corpus,
                        keyword,
                        corpus,
                        from,
                        to,
                        resolution,
                        n_of) {

  #errors in from/to
  if (!is.numeric(from) || !is.numeric(to)) {
    stop(
      "'from' and 'to' should be numeric or 'earliest' or 'latest' respectively.",
      call. = FALSE
    )
  }

  if (from > to) {
    stop("'from' cannot be larger than 'to'", call. = FALSE)
  }

  #errors in keyword
  if (!is.character(keyword)) {
    stop("'keyword' should be a character string", call. = FALSE)
  }

  if (length(keyword) != 1) {
    stop(
      "'keyword' should be a character string and not a character vector",
      call. = FALSE
    )
  }

  #cooccurr, associated and with only work with lemonde, livres, presse
  if (grepl("_(associated|with|cooccur)", deparse(sys.call(-2))[1]) &&
      !(corpus %in% c("lemonde", "livres", "presse"))) {
    stop(
      "This function is only available for the corpora lemonde, livres, and presse.",
      call. = FALSE
    )
  }

  #reliability corpus
  if (from < info_corpus$reliable_from) {
    warning(
      paste(
        "The", corpus,
        "corpus is only reliable after", info_corpus$reliable_from
      ),
      call. = FALSE
    )
  }
  if (to > info_corpus$reliable_to) {
    warning(
      paste("The", corpus,
            "corpus is only reliable before", info_corpus$reliable_to),
      call. = FALSE
    )
  }

  #error in resolution
  if (!(resolution %in% c("daily", "monthly", "yearly"))) {
    stop("Resolution can only be daily, monthly or yearly.")
  }

  #error in n_of
  if (!(corpus == "lemonde" && n_of == "articles") & !(n_of =="grams")) {
    stop(
      "'n_of' can only be equal to 'grams' except for the Le Monde corpus,
      for which it can also be equal to 'article'",
      call. = FALSE
    )
  }
}
