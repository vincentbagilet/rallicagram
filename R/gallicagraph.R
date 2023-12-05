#' Graph describing the evolution of the proportion of occurrences
#'
#' @description
#' Takes as input data produced by \code{gallicagram} and produces a graph
#' describing the evolution of the proportion of occurrences in this data set.
#'
#' @details
#' This function can also be combined with faceting by adding for instance
#' \code{+ facet_wrap(~ keyword)} after calling the function.
#'
#' @param data A data frame produced by the \code{gallicagram} function
#' (or several of such data frames bound by rows).
#' @param color A variable to set colors for the graph
#'
#' @returns A graph describing the evolution of the proportion of occurrences
#' of one or several keywords in one or several corpora.
#'
#' @export
#' @examples
#'   gallicagram("président") |>
#'     gallicagraph()
#'
#'   gallicagram("président") |>
#'     rbind(gallicagram("république")) |>
#'     gallicagraph(color = keyword)
#'
#'   gallicagram("président") |>
#'     rbind(gallicagram("république")) |>
#'     gallicagraph() +
#'     ggplot2::facet_wrap(~ keyword)
gallicagraph <- function(data, color = NULL) {
  corpus_data <- unique(data$corpus)

  corpus_name <- rallicagram::list_corpora[
    rallicagram::list_corpora$corpus == corpus_data, "corpus_name"]

  data |>
    ggplot2::ggplot(
      ggplot2::aes(x = date, y = .data$prop_occur, color = {{ color }})
    ) +
    ggplot2::geom_line() +
    ggplot2::labs(
      x = NULL,
      y = paste("Proportion (of", unique(data$n_of), "in the corpus)"),
      title = paste(
        'Evolution of the coverage of "',
        paste(unique(data$keyword), collapse = '", "'),
        '" in the ', paste(corpus_name, collapse = '", "'), " corpus" ,
        sep = ""
      ),
      color = NULL
    )
}
