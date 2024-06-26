#' Close co-occurrences of two lexicons in a Gallicagram copus
#'
#' @description
#' Retrieves the proportion of close co-occurrences of two lexicons in one of
#' the three main corpora (historical press, Gallica books, Le Monde newspaper)
#' by year or month.
#'
#' @details
#' Close co-occurrences correspond to the number of 3-grams
#' (4-grams in the Le Monde corpus) that contain each pair of keywords in the
#' two lexicons.
#'
#' This function simply loops the function \code{gallicagram_cooccur} over each
#' word of each lexicon and sums the results. It can thus take some time to run.
#'
#' It is only available for the three main corpora
#' (historical press, Gallica books, Le Monde newspaper).
#'
#' @param lexicon_1 A character vector. One of the two lexicons to search.
#' @param lexicon_2 A character vector. The other lexicon to search.
#' @inheritParams gallicagram_cooccur
#'
#' @inherit tidy_gallicagram return
#'
#' @importFrom rlang .data
#'
#' @export
#' @examples
#' gallicagram_cooccur_lexicon(c("président", "présidente"), c("mauvais", "nul"))
gallicagram_cooccur_lexicon <- function(lexicon_1,
                                        lexicon_2,
                                        corpus = "lemonde",
                                        from = "earliest",
                                        to = "latest",
                                        resolution = "monthly",
                                        cooccur_level = "grams") {

  output <- NULL

  for (keyword_1 in lexicon_1) {
    for (keyword_2 in lexicon_2) {
      output <- output |>
        rbind(gallicagram_cooccur(
          keyword_1, keyword_2,
          corpus, from, to, resolution, count_phrase = FALSE, cooccur_level))
    }
  }

  output <- output |>
    dplyr::group_by(.data$date) |>
    dplyr::mutate(
      n_cooccur = sum(.data$n_cooccur),
      prop_cooccur = .data$n_cooccur / .data$n_total
    ) |>
    dplyr::ungroup() |>
    dplyr::select(-keyword_1, -keyword_2) |>
    dplyr::distinct() |>
    dplyr::mutate(
      keyword_1 = lexicon_1[1],
      keyword_2 = lexicon_2[1],
      lexicon_1 = paste(lexicon_1, collapse = "+"),
      lexicon_2 = paste(lexicon_2, collapse = "+")
    )

  return(output)
}
