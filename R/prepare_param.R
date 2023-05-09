#' Internal function to prepare the parameters to use them in the API call.
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
                          resolution) {

  if (!is.numeric(from) || !is.numeric(to)) {
    stop("'from' and 'to' should be numeric", call. = FALSE)
  }

  if (!is.character(keyword)) {
    stop("'keyword' should be a character string", call. = FALSE)
  }

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

  resolution_french <- ifelse(resolution == "yearly", "annee",
                       ifelse(resolution == "monthly", "mois",
                       ifelse(resolution == "daily", "jour",
                          stop("Invalid resolution", call. = FALSE))))

  corpus_french <- ifelse(corpus == "press", "presse",
                          ifelse(corpus == "books", "livres",
                          ifelse(corpus == "lemonde", "lemonde",
                            stop("Invalid corpus name", call. = FALSE))))

  keyword_clean <- sub(" ", "%20", tolower(keyword))

  param_clean <- list(
    "keyword" = keyword_clean,
    "corpus" = corpus_french,
    "resolution" = resolution_french
  )

  return(param_clean)
}