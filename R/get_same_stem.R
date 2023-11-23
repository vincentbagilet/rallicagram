#' Finds words with the same stem as a keyword
#'
#' @description
#' Searches such words in the \code{rallicagram::word_lemma_stem} dataframe.
#'
#' @param keyword A character string.
#'
#' @returns A character vector. Words with the same stem has the \code{keyword}
#'
#' @export
#' @examples
#' \dontrun{
#'   get_same_stem("président")
#' }
get_same_stem <- function(keyword) {
  wls <- rallicagram::word_lemma_stem
  if(length(which(wls$word == keyword)) == 0) {
    stop("Keyword not in the dataset", call. = FALSE)
  } else {
    stem <- wls[[which(wls$word == keyword)[1], "stem"]]
    vector <- wls[which(wls$stem == stem), ]$word
  }

  return(vector)
}
