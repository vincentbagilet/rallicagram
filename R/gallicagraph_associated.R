#' Graph describing the most common co-occurrences with a keyword or lexicon
#'
#' @description
#' Takes as input data produced by \code{gallicagram_associated} or
#' \code{gallicagram_associated_lexicon} and produces a graph
#' describing the words the most commonly co-occurring with the keyword
#' or lexicon of interest
#'
#' @param data A data frame produced by the \code{gallicagram_associated} or
#' \code{gallicagram_associated_lexicon} functions
#' @param labels_color A character string. The color in which to print
#' the labels. Set to \code{NA} for no label.
#'
#' @returns A graph describing the most common co-occurrences with a keyword
#' or lexicon.
#'
#' @importFrom rlang .data
#' @importFrom stats reorder
#'
#' @export
#' @examples
#'   gallicagram_associated("président", from = 2020) |>
#'     gallicagraph_associated(labels_color = "white")
gallicagraph_associated <- function(data, labels_color = NA) {
  corpus_name <- rallicagram::list_corpora |>
    dplyr::filter(.data$corpus %in% unique(data$corpus)) |>
    dplyr::pull("corpus_name")

  data |>
    dplyr::mutate(
      associated_word = reorder(.data$associated_word, .data$n_cooccur)
    ) |>
    ggplot2::ggplot(
      ggplot2::aes(x = .data$associated_word, y = .data$n_cooccur)
    ) +
    ggplot2::geom_col() +
    ggplot2::geom_text(
      ggplot2::aes(label = .data$n_cooccur),
      colour = labels_color,
      size = 3,
      hjust = 1.2
    ) +
    ggplot2::labs(
      x = NULL,
      y = "Number of co-occurrences",
      title = paste(
        'Words most often co-occurring with',
        ifelse(("lexicon" %in% names(data)), ' the "', ' "'),
        paste(unique(data$keyword), collapse = '", "'),
        ifelse(("lexicon" %in% names(data)), '" lexicon ', '"'),
        sep = ""
      ),
      subtitle = paste(
        "In", unique(data$cooccur_level),
        "in the", corpus_name, "corpus, from", data$from, "to", data$to
      )
    ) +
    ggplot2::coord_flip() +
    ggplot2::theme(panel.background = ggplot2::element_blank()) +
    ggplot2::theme(axis.ticks.y = ggplot2::element_blank())
}
