#' Occurrences of a list of keywords in a Gallicagram corpus
#'
#' @description
#' Retrieves the proportion of occurrences of a list of keywords
#' in one of the corpora (historical press, Gallica books, Le Monde newspaper)
#' by year, month or day.
#'
#' @details
#' This function sums the outputs of calls of \code{gallicagram} obtained for
#' each keyword in the vector.
#'
#' Can typically be used with the function \code{get_same_stem()}.
#'
#' @param lexicon A character vector. Keywords to search. Can contain up to
#' a 3-gram in the "books" and "press" corpora and
#' a 4-gram in the "lemonde" corpus.
#'
#' @inheritParams gallicagram
#'
#' @returns A tibble. With the first \code{keyword} in the vector,
#' typically the one, the entire \code{lexicon},
#' the number of occurrences (\code{n_occur}) or co-occurrences
#' (\code{n_cooccur}), the total number of ngrams over the period of a
#' given observation (\code{n_grams} or \code{n_ngrams}),
#' the proportion of occurrences or co-occurrences of the keyword(s) over the
#' period of a given observation (\code{prop_occcur} or \code{prop_coocccur}),
#' the date at the beginning of the period of a given observation (\code{date}),
#' the \code{corpus}, the \code{resolution},
#' the \code{year} and
#' potentially the \code{month} and \code{day} of the observation.
#'
#' @export
#' @examples
#' gallicagram_lexicon(c("président", "présidentiel"))
gallicagram_lexicon <- function(lexicon,
                                corpus = "lemonde",
                                from = 1945,
                                to = 2022,
                                resolution = "monthly") {

  output <- NULL

  for (keyword in lexicon) {
      output <- output |>
        rbind(gallicagram(keyword, corpus, from, to, resolution))
  }

  output <- output |>
    dplyr::mutate(keyword = lexicon[1]) |>
    dplyr::group_by(.data$date) |>
    dplyr::mutate(
      n_occur = sum(.data$n_occur),
      prop_occur = .data$n_occur / .data$n_grams
    ) |>
    dplyr::ungroup() |>
    dplyr::distinct() |>
    dplyr::mutate(
      lexicon = paste(lexicon, collapse = "+")
    )

  return(output)
}
