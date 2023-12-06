#' Automatically produces the relevant graph
#'
#' @description
#' Takes as input data produced by one of the \code{gallicagram},
#' \code{gallicagram_coocur} or \code{gallicagram_associated}
#' functions or their lexicon counterparts and
#' produces the corresponding base graph.
#'
#' @details
#' This function can also be combined with faceting by adding for instance
#' \code{+ facet_wrap(~ keyword)} after calling the function.
#'
#' @param data A data frame produced by one of the \code{gallicagram},
#' \code{gallicagram_coocur} or \code{gallicagram_associated}
#'functions or their lexicon counterparts
#' (or several of such data frames bound by rows).
#'
#' @inheritParams gallicagraph_occur
#' @inheritParams gallicagraph_associated
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
#'
#'   gallicagram_associated("président", from = 2020) |>
#'     gallicagraph()
gallicagraph <- function(data, color = NULL, labels_color = NA) {
  if ("n_occur" %in% names(data)) {
    gallicagraph_occur(data, {{ color }})
  } else if ("associated_word" %in% names(data)) {
    gallicagraph_associated(data, labels_color)
  } else if ("n_cooccur" %in% names(data)) {
    gallicagraph_cooccur(data, {{ color }})
  } else {
    stop("Only works for data produced by rallicagram")
  }
}
