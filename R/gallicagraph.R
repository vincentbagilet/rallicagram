#' Automatically produces the relevant graph
#'
#' @description
#' Takes as input data produced by one of the \code{gallicagram} or
#' \code{gallicagram_coocur} functions or their lexicon counterparts and
#' produces the corresponding base graph.
#'
#' @details
#' This function can also be combined with faceting by adding for instance
#' \code{+ facet_wrap(~ keyword)} after calling the function.
#'
#' @param data A data frame produced by one of the \code{gallicagram} or
#' \code{gallicagram_coocur} functions or their lexicon counterparts
#' (or several of such data frames bound by rows).
#' @param color A variable to set colors for the graph
#'
#' @returns A graph describing the evolution of the proportion of
#' (co-)occurrences of one or several keywords in one or several corpora.
#'
#' @export
#' @examples
#'   gallicagram("président") |>
#'     gallicagraph()
#'
#'   gallicagram_cooccur("président", "ancien") |>
#'     gallicagraph()
gallicagraph <- function(data, color = NULL) {
  if ("n_occur" %in% names(data)) {
    gallicagraph_occur(data)
  } else if ("n_cooccur" %in% names(data)) {
    gallicagraph_cooccur(data)
  } else {
    stop("Only works for data produced by rallicagram")
  }
}
