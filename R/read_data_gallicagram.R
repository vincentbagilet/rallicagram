#' Internal function to read the output of the API call.
#'
#' @description
#' Turns the output into a tibble
#' Only necessary to allow a longer timeout period.
#'
#' @param url The url to pass to the Gallicagram API
#'
#' @details
#' The timeout is set to 5000s to handle queries that take Gallicagram
#' a long time to process.
#'
#' @returns A tibble containing the raw data from the Gallicagram API.
#'
read_data_gallicagram <- function(url) {

  options(timeout = 5000)

  output <- url |>
    utils::read.csv() |>
    dplyr::as_tibble()

  options(timeout = 60)

  return(output)
}
