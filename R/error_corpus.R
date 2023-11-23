#' Check and Handle Errors Related to the Corpus
#'
#' This internal function checks for errors in the specified corpus,
#' including validity of the corpus required,
#' reliability of the specified time range,
#' and compatibility of the requested resolution
#' with the corpus's available resolutions.
#'
#' @param corpus A character string. The corpus specified by the user.
#' @inheritParams gallicagram
#'
#' @return This function does not return a value but may issue warnings or
#' errors if any issues are found.
#'
#' @details
#' This function performs the following checks:
#' \itemize{
#'   \item{Validity of Corpus Code:}{
#'    Ensures that the specified \code{corpus} is a valid corpus.
#'   }
#'   \item{Reliability of Time Range:}{
#'    Checks whether the specified time range (\code{from} to \code{to})
#'    falls within the reliable range of the specified corpus.
#'   }
#'   \item{Compatibility of Resolution:}{
#'    Verifies that the requested resolution (\code{resolution})
#'    is compatible with the available resolutions of the specified corpus.
#'  }
#' }
#'
#' @examples
#' \dontrun{
#'   error_corpus("lemonde", 1940, 2025, "monthly")
#' }
#'
#' @keywords internal, error
#'
#' @export
error_corpus <- function(corpus,
                         from,
                         to,
                         resolution) {
  if (!is.character(corpus)) {
    stop(
      paste(
        "The corpus should be one of:",
        paste(list_corpora$corpus, collapse = ", ")
      )
    )
  }

  #to handle code written with a previous version of the package
  corpus_french <-
    ifelse(corpus == "press", "presse",
           ifelse(corpus == "books", "livres",
                  ifelse(corpus == "lemonde", "lemonde", corpus)))

  #reliability corpus
  if (!(corpus_french %in% list_corpora$corpus)) {
    stop(
      paste(
        "The corpus should be one of:",
        paste(list_corpora$corpus, collapse = ", ")
      )
    )
  }

  info_corpus <- list_corpora |> dplyr::filter(corpus == corpus_french)

  #reliability corpus
  if (from < info_corpus$start_reliable) {
    warning(
      paste(
        "The", corpus_french,
        "corpus is only reliable after", info_corpus$start_reliable
      ),
      call. = FALSE
    )
  }
  if (to > info_corpus$end_reliable) {
    warning(
      paste("The", corpus_french,
            "corpus is only reliable before", info_corpus$end_reliable),
      call. = FALSE
    )
  }

  #error in resolution
  if (!(resolution %in% c("daily", "monthly", "yearly"))) {
    stop("Resolution can only be daily, monthly or yearly.")
  }

  if (
    (resolution == "monthly" && info_corpus$resolution == "yearly") ||
      (resolution == "daily" &&
       info_corpus$resolution %in% c("yearly", "monthly"))
  ) {
    stop(
      paste(
        "The", corpus_french,
        "corpus is only available at a", info_corpus$resolution,
        "resolution"
      ),
      call. = FALSE
    )
  }
}
