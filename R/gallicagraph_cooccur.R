#' Graph describing the evolution of the proportion of co-occurrences
#'
#' @description
#' Takes as input data produced by \code{gallicagram_cooccur} or
#' \code{gallicagram_cooccur_lexicon} and produces a graph
#' describing the evolution of the proportion of co-occurrences in this data set.
#'
#' @details
#' This function can also be combined with faceting by adding for instance
#' \code{+ facet_wrap(~ keyword)} after calling the function.
#'
#' @param data A data frame produced by the \code{gallicagram_cooccur} or
#' \code{gallicagram_cooccur_lexicon} functions
#' (or several of such data frames bound by rows).
#' @param color A variable to set colors for the graph
#'
#' @returns A graph describing the evolution of the proportion of co-occurrences
#' of two keywords in one or several corpora.
#'
#' @export
#' @examples
#'   gallicagram_cooccur("président", "ancien") |>
#'     gallicagraph_cooccur()
#'
#'   gallicagram_cooccur("président", "ancien") |>
#'     rbind(gallicagram_cooccur("président", "république")) |>
#'     gallicagraph_cooccur(color = keyword)
#'
#'   gallicagram_cooccur("président", "ancien") |>
#'     rbind(gallicagram_cooccur("président", "république")) |>
#'     gallicagraph_cooccur() +
#'     ggplot2::facet_wrap(~ keyword)
gallicagraph_cooccur <- function(data, color = NULL) {

  corpus_name <- rallicagram::list_corpora |>
    dplyr::filter(.data$corpus %in% unique(data$corpus)) |>
    dplyr::pull("corpus_name")

  data_clean <- data |>
    dplyr::mutate(
      keyword =
        paste('"', .data$keyword_1, '" and "', .data$keyword_2, '"', sep = '')
    )

  data_clean |>
    ggplot2::ggplot(
      ggplot2::aes(x = date, y = .data$prop_cooccur, color = {{ color }})
    ) +
    ggplot2::geom_line() +
    ggplot2::labs(
      x = NULL,
      y = paste("Proportion (of", unique(data$cooccur_level), "in the corpus)"),
      title = paste(
        "Evolution of co-occurences of",
        ifelse(("lexicon_1" %in% names(data_clean)), "the", ""),
        paste(unique(data_clean$keyword), collapse = ", "),
        ifelse(("lexicon_1" %in% names(data_clean)), "lexicons", "")
      ),
      subtitle = paste(
        'In', paste(unique(data_clean$cooccur_level)),
        "in the", paste(corpus_name, collapse = ", "),
        ifelse(length(corpus_name) == 1, "corpus", "corpora")
      )
    ) +
    ggplot2::theme(panel.background = ggplot2::element_blank())
}
