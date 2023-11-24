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

  #error corpus
  rallicagram::error_corpus(corpus, from, to, resolution)

  #error in n_of
  if (!(corpus == "lemonde" && n_of == "article") & !(n_of =="grams")) {
    stop(
      "'n_of' can only be equal to 'grams' except for the Le Monde corpus,
      for which it can also be equal to 'article'",
      call. = FALSE
    )
  }

  #to handle code written with a previous version of the package
  corpus_french <-
    ifelse(corpus == "press", "presse",
           ifelse(corpus == "books", "livres",
                  ifelse(corpus == "lemonde", "lemonde", corpus)))

  info_corpus <-
    rallicagram::list_corpora[
      rallicagram::list_corpora$corpus == corpus_french,]

  #resolutions
  if (resolution == "monthly" && info_corpus[["resolution"]] == "yearly") {
    resol <- "yearly"
    warning(
      "Resolution set to 'yearly', the finest resolution available",
      call. = FALSE
    )
  } else if (resolution == "daily" && info_corpus[["resolution"]] == "monthly") {
    resol <- "monthly"
    warning(
      "Resolution set to 'monthly', the finest resolution available",
      call. = FALSE
    )
  } else {resol <- resolution}

  #translations
  resolution_french <-
    ifelse(resol == "yearly", "annee",
           ifelse(resol == "monthly", "mois",
                  ifelse(resol == "daily", "jour",
                         stop("Invalid resolution", call. = FALSE))))

  keyword_clean <- gsub(" ", "%20", tolower(keyword))

  param_clean <- list(
    "keyword" = keyword_clean,
    "corpus" = corpus_french,
    "resolution" = resolution_french
  )

  return(param_clean)
}
