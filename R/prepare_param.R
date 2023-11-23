#' Internal function to prepare the parameters to use them in the API call.
#'
#' @description
#' Checks potential errors, translates the parameters, set parameters for
#' the API call.
#'
#' @inheritParams gallicagram
#'
#' @returns A list.
#' Contains cleaned function parameters (`keyword`, `corpus` and `resolution`).
#'
prepare_param <- function(keyword,
                          corpus,
                          from,
                          to,
                          resolution,
                          n_of = "grams") {

  #errors in from/to
  if (!is.numeric(from) || !is.numeric(to)) {
    stop("'from' and 'to' should be numeric", call. = FALSE)
  }

  if (from > to) {
    stop("'from' cannot be larger than 'to'", call. = FALSE)
  }

  #errors in keyword
  if (!is.character(keyword)) {
    stop("'keyword' should be a character string", call. = FALSE)
  }

  if (length(keyword) != 1) {
    stop(
      "'keyword' should be a character string and not a character vector",
      call. = FALSE
    )
  }

  #reliability corpus
  if (corpus == "books" && to >= 1940) {
    warning(
      "The 'books' corpus is only reliable before 1940.",
      call. = FALSE
    )
  } else if (corpus == "press" && (from < 1789 || to > 1950)) {
    warning(
      "The 'press' corpus is only reliable between 1789 and 1950.",
      call. = FALSE
    )
  }

  #error in resolution
  if (corpus == "books" && resolution %in% c("monthly", "daily")) {
    stop(
      "The 'books' corpus is only available at a yearly resolution",
      call. = FALSE
    )
  } else if (corpus == "press" && resolution %in% c("daily")) {
    stop(
      "The 'press' corpus is only available at a monthly or yearly resolution",
      call. = FALSE
    )
  }

  #error in n_of
  if (!(corpus == "lemonde" && n_of == "article") & !(n_of =="grams")) {
    stop(
      "'n_of' can only be equal to 'grams' except for the Le Monde corpus,
      for which it can also be equal to 'article'",
      call. = FALSE
    )
  }

  #translations
  resolution_french <- ifelse(resolution == "yearly", "annee",
                       ifelse(resolution == "monthly", "mois",
                       ifelse(resolution == "daily", "jour",
                          stop("Invalid resolution", call. = FALSE))))

  corpus_french <- ifelse(corpus == "press", "presse",
                          ifelse(corpus == "books", "livres",
                          ifelse(corpus == "lemonde", "lemonde",
                            stop("Invalid corpus name", call. = FALSE))))

  keyword_clean <- gsub(" ", "%20", tolower(keyword))

  param_clean <- list(
    "keyword" = keyword_clean,
    "corpus" = corpus_french,
    "resolution" = resolution_french
  )

  return(param_clean)
}
