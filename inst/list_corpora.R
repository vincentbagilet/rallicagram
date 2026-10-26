## The (super simple) code to prepare the `list_corpora` data set
## Retrieve the data directly from Gallicagram GitHub

url <- "https://raw.githubusercontent.com/regicid/gallicagram_react/main/public/corpus.tsv"

list_corpora_raw <- readr::read_tsv(url)

list_corpora <- list_corpora_raw |>
  janitor::clean_names() |>
  dplyr::select(
    corpus = code_api,
    corpus_name = titre,
    period = periode_conseillee,
    nb_words = volume_en_mots,
    max_length = longueur_max,
    resolution,
    seuils,
    available_func = available_modes,
    alt_base = elias
  ) |>
  dplyr::mutate(
    period = stringr::str_remove_all(period, "[^\\d-]"),
    resolution = stringr::str_extract(resolution, "\\w+(?=\\s?)"),
    max_length = stringr::str_sub(max_length, 1, 1) |> as.integer(),
    nb_words = nb_words |>
      stringr::str_replace(",", ".") |>
      stringr::str_replace("\\smilliards?", "e+9") |>
      stringr::str_replace("\\smillions?", "e+6") |>
      stringr::str_replace("\\?", "") |>
      as.numeric(),
    resolution = dplyr::case_when(
      resolution == "Journalière" ~ "daily",
      resolution == "Mensuelle" ~ "monthly",
      resolution == "Annuelle" ~ "yearly"
    ),
    available_func = stringr::str_replace(available_func, "joker", "with"),
    available_func = stringr::str_replace(available_func, "cooccurrence", "cooccurr"),
    available_func = stringr::str_replace(available_func, "nearby", "associated"),
    available_func = stringr::str_remove(available_func, "\\|?document\\|?"),
    alt_base = !is.na(alt_base)
  ) |>
  tidyr::separate(
    period,
    into = c("reliable_from", "reliable_to"),
    sep = "-",
    convert = TRUE
  ) |>
  dplyr::select(-seuils) |>
  dplyr::mutate(
    corpus = ifelse(corpus_name == "Persée", "persee",
                    ifelse(corpus == "lemonde_rubriques", "lemonde", corpus)),
    max_length = ifelse(corpus == "lemonde", 3, max_length) #to fix an issue in the API
  )

usethis::use_data(list_corpora, overwrite = TRUE)
