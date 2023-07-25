#' Internal function to read the output of the API call.
#'
#' @description
#' Turns the output into a tibble
#' Only necessary to allow a longer timeout period.
#'
#' @param url The url to pass to the Gallicagram API
#'
#' @returns A tibble containing the raw data from the Gallicagram API.
#'
read_data_gallicagram <- function(url) {

  options(timeout = 500)

  output <- url |>
    utils::read.csv() |>
    dplyr::as_tibble()

  options(timeout = 60)

  return(output)
}
