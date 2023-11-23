## The (super simple) code to prepare the `list_corpora` data set

list_corpora_raw <-
  readr::read_delim(
    "inst/data-raw/list_corpora_raw.csv",
    delim = ";",
    escape_double = FALSE,
    trim_ws = TRUE
  )

list_corpora <- list_corpora_raw |>
 dplyr::mutate(
    max_length = stringr::str_sub(max_length, 1, 1) |> as.integer(),
    nb_words = nb_words |>
      stringr::str_replace(",", ".") |>
      stringr::str_replace("\\smilliards?", "e+9") |>
      stringr::str_replace("\\smillions?", "e+6") |>
      as.numeric(),
    resolution = dplyr::case_when(
      resolution == "Journalière" ~ "daily",
      resolution == "Mensuelle" ~ "monthly",
      resolution == "Annuelle" ~ "yearly"
    )
  ) |>
  tidyr::separate(
    period,
    into = c("start_reliable", "end_reliable"),
    convert = TRUE
  ) |>
  dplyr::select(-seuils)

usethis::use_data(list_corpora, overwrite = TRUE)
