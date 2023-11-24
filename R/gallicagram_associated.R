#' Words the most often associated with a keyword in a Gallicagram corpus
#'
#' @description
#' Returns the word the most frequently at a given number of words
#' (\code{distance}) from the keyword.
#'
#' @details
#' This functions calls the '\code{associated}' route of the API.
#'
#' Note that the API route does not allow to search for associated words
#' after a punctuation mark.
#' For instance, in "son camarade, le chasseur, a", the function will
#' not count "chasseur" as a word associated with "camarade". The ngram
#' "son camarade le chasseur" is not in the database.
#' Thus, there might be less associated words at a longer distance
#' as it increases the probability of ngrams to be excluded from the database.
#'
#' Apostrophes and letters preceding them are withdrawn from the dataset
#' (except for n' since they carry meaning)
#'
#' Searching the "press" corpus can require a long running time.
#'
#' @param distance An integer or "max". The maximum distance,
#' in number of words, at which to look for words associated with the keyword.
#' The max length for each corpus (distance + number of words in the keyword)
#' is described in the \code{max_length} column
#' of the \code{list_corpora} dataset.
#' @param stopwords A character vector of stopwords to remove.
#' The default is the vector of the 500 most frequent words in the Gallica
#' books dataset. We can change this number by passing
#' \code{stopwords_gallicca[1:300]} (for instance, for the 300 most frequent)
#' to the \code{stopwords} argument. Can also be \code{lsa::stopwords_fr}
#' If \code{NULL} does not remove any stopwords.
#'
#' @inheritParams gallicagram_with
#'
#' @importFrom rlang .data
#'
#' @returns A tibble. Containing the words the most frequently associated with
#' the \code{keyword} mentioned (\code{associated_word}),
#' the number of occurrences over the period (\code{n_occur}),
#' and the level at which the cooccurrences are computed (n-grams or articles,
#' reported in (\code{cooccur_level})).
#' It also returns the input parameters
#' \code{keyword}, \code{corpus}, \code{from} and \code{to}.
#'
#' @export
#' @examples
#' gallicagram_associated("camarade")
gallicagram_associated <- function(keyword,
                                   corpus = "lemonde",
                                   from = "earliest",
                                   to = "latest",
                                   n_results = 20,
                                   distance = "max",
                                   stopwords =
                                     rallicagram::stopwords_gallica[1:500]) {

  param_clean <- prepare_param(keyword, corpus, from, to, resolution = "yearly")
  # param resolution not used

  #errors handling 1
  if (!(is.numeric(distance) || distance == "max")) {
    stop("'distance' should be numeric or 'max'", call. = FALSE)
  }

  #compute length
  max_length_corpus <- rallicagram::list_corpora[
    rallicagram::list_corpora$corpus == param_clean$corpus, "max_length"][[1]]

  asked_length <- ifelse(
    distance == "max",
    max_length_corpus,
    length(strsplit(x = keyword, split = " ")[[1]]) + distance
  )

  length <- min(max_length_corpus, asked_length)

  n_joker <- ifelse(is.null(stopwords),
                    n_results + length(strsplit(x = keyword, split = " ")[[1]]),
                    "all")

  #errors handling2
  if (asked_length > max_length_corpus) {
    warning(
      paste("Distance set to 'max'. The sum of the number of words in 'keyword'
            and 'distance' cannot be more than",
            max_length_corpus, "for this corpus."),
      call. = FALSE
    )
  }

  if (distance <= 0 & distance != "max") {
    stop(
      "'distance' has to be larger than 0",
      call. = FALSE
    )
  }

  if (grepl("\\'", keyword)) {
    stop("'keyword' cannot contain an apostrophe.
         Specifying a keyword without the apostrophe will also return words
         associated with the apostrophe version of the keyword.", call. = FALSE)
  }

  output <- paste("https://shiny.ens-paris-saclay.fr/guni/associated?corpus=",
                  param_clean$corpus,
                  "&mot=",
                  param_clean$keyword,
                  "&from=",
                  param_clean$from,
                  "&to=",
                  param_clean$to,
                  "&n_joker=",
                  n_joker,
                  "&length=",
                  length,
                  sep = "") |>
    read_data_gallicagram() |>
    #remove apostrophes (except for n' since they carry meaning)
    dplyr::mutate(
      associated_word = sub(
        pattern = "[n'^\\w]'",
        replacement = "",
        x = .data$gram
      )
    ) |>
    dplyr::filter(
      !(.data$associated_word %in% strsplit(keyword, "\\s")[[1]])
    ) |>
    dplyr::group_by(.data$associated_word) |>
    dplyr::summarise(n_occur = sum(.data$tot), .groups = "drop") |>
    dplyr::arrange(dplyr::desc(.data$n_occur)) |>
    #add param
    dplyr::mutate(
      keyword = param_clean$keyword,
      corpus = param_clean$corpus,
      from = param_clean$from,
      to = param_clean$to,
      cooccur_level = ifelse(
        distance == "article",
        "articles",
        paste(length - 1, "grams", sep = "-"))
      # distance = length - 1
    )

  #remove stopwords
  if (!is.null(stopwords)) {
    output <- output |>
      dplyr::anti_join(
        dplyr::tibble(associated_word = stopwords),
        by = "associated_word"
      )
  }

  output <- output |>
    dplyr::filter(.data$associated_word != "") |>
    #these "" were created because some associated_word
    #returned are in the format \\w'
    dplyr::slice(1:n_results)

  return(output)
}
