## The (super simple) code to prepare the `list_corpora` data set
## Retrieve the data directly from the API doc

url <- "https://regicid.github.io/api"

list_corpora_raw <- url |>
  rvest::read_html() |>
  rvest::html_node("table") |>
  rvest::html_table() |>
  janitor::clean_names() |>
  dplyr::select(
    corpus = code_api,
    corpus_name = titre,
    period = periode_conseillee,
    nb_words = volume_en_mots,
    max_length = longueur_max,
    resolution,
    seuils
  ) |>
  dplyr::mutate(
    period = stringr::str_remove_all(period, "[^\\d-]"),
    resolution = stringr::str_extract(resolution, "\\w+(?=\\s?)")
  )

# list_corpora_raw <-
#   readr::read_delim(
#     "inst/data-raw/list_corpora_raw.csv",
#     delim = ";",
#     escape_double = FALSE,
#     trim_ws = TRUE
#   )

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
    into = c("reliable_from", "reliable_to"),
    sep = "-",
    convert = TRUE
  ) |>
  dplyr::select(-seuils) |>
  dplyr::filter(corpus_name != "Persée")

usethis::use_data(list_corpora, overwrite = TRUE)
