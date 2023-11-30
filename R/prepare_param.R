#' Internal function to prepare the parameters to use them in the API call.
#'
#' @description
#' Checks potential errors, translates the parameters, set parameters for
#' the API call.
#'
#' @inheritParams gallicagram
#'
#' @returns A list.
#' Contains cleaned function parameters (`keyword`, `corpus`, `from`, `to`
#' and `resolution`).
#'
prepare_param <- function(keyword,
                          corpus,
                          from,
                          to,
                          resolution,
                          n_of = "grams") {

  #to handle code written with a previous version of the package
  corpus_french <-
    ifelse(corpus == "press", "presse",
           ifelse(corpus == "books", "livres",
                  ifelse(corpus == "lemonde", "lemonde", corpus)))

  if (!(corpus_french %in% rallicagram::list_corpora$corpus)) {
    stop(
      paste(
        "The corpus should be one of:",
        paste(rallicagram::list_corpora$corpus, collapse = ", ")
      )
    )
  }

  info_corpus <-
    rallicagram::list_corpora[
      rallicagram::list_corpora$corpus == corpus_french,]

  from_numeric <- ifelse(
    from == "earliest",
    info_corpus[["reliable_from"]],
    from
  )

  to_numeric <- ifelse(
    to == "latest",
    info_corpus[["reliable_to"]],
    to
  )

  #error in params
  rallicagram::error_param(
    info_corpus,
    keyword,
    corpus_french,
    from_numeric,
    to_numeric,
    resolution,
    n_of
  )

  #resolutions
  if ((resolution == "monthly" || resolution == "daily") &&
      info_corpus[["resolution"]] == "yearly") {
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
  resolution_fr <-
    ifelse(resol == "yearly", "annee",
           ifelse(resol == "monthly", "mois",
                  ifelse(resol == "daily", "jour",
                         stop("Invalid resolution", call. = FALSE))))

  keyword_clean <- gsub(" ", "%20", tolower(keyword))

  param_clean <- list(
    "keyword" = keyword_clean,
    "corpus" = corpus_french,
    "from" = from_numeric,
    "to" = to_numeric,
    "resolution_fr" = resolution_fr,
    "resolution_en" = resol
  )

  return(param_clean)
}
