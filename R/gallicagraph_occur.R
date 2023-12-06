#' Graph describing the evolution of the proportion of occurrences
#'
#' @description
#' Takes as input data produced by \code{gallicagram} or
#' \code{gallicagram_lexicon} and produces a graph
#' describing the evolution of the proportion of occurrences in this data set.
#'
#' @details
#' This function can also be combined with faceting by adding for instance
#' \code{+ facet_wrap(~ keyword)} after calling the function.
#'
#' @param data A data frame produced by the \code{gallicagram} or
#' \code{gallicagram_lexicon} functions
#' (or several of such data frames bound by rows).
#' @param color A variable to set colors for the graph
#'
#' @returns A graph describing the evolution of the proportion of occurrences
#' of one or several keywords in one or several corpora.
#'
#' @export
#' @examples
#'   gallicagram("président") |>
#'     gallicagraph_occur()
#'
#'   gallicagram("président") |>
#'     rbind(gallicagram("république")) |>
#'     gallicagraph_occur(color = keyword)
#'
#'   gallicagram("président") |>
#'     rbind(gallicagram("république")) |>
#'     gallicagraph_occur() +
#'     ggplot2::facet_wrap(~ keyword)
#'
#'   gallicagram("président") |>
#'     rbind(gallicagram("président", corpus = "huma")) |>
#'     gallicagraph_occur(color = corpus)
gallicagraph_occur <- function(data, color = NULL) {

  corpus_name <- rallicagram::list_corpora |>
    dplyr::filter(.data$corpus %in% unique(data$corpus)) |>
    dplyr::pull("corpus_name")

  data |>
    ggplot2::ggplot(
      ggplot2::aes(x = date, y = .data$prop_occur, color = {{ color }})
    ) +
    ggplot2::geom_line() +
    ggplot2::labs(
      x = NULL,
      y = paste("Proportion (of", unique(data$n_of), "in the corpus)"),
      title = paste(
        'Evolution of the coverage of',
        ifelse(("lexicon" %in% names(data)), ' the "', ' "'),
        paste(unique(data$keyword), collapse = '", "'),
        ifelse(("lexicon" %in% names(data)), '" lexicon ', '" '),
        sep = ""
      ),
      subtitle = paste(
        'In the', paste(corpus_name, collapse = ', '),
        ifelse(length(corpus_name) == 1,"corpus", "corpora")
      )
    ) +
    ggplot2::theme(panel.background = ggplot2::element_blank())
}
