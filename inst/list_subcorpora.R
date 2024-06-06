## The (super simple) code to prepare the `list_subcorpora` data set
## Retrieve the data directly from regicid's Github

list_subcorpora_raw <-
  "https://raw.githubusercontent.com/regicid/regicid.github.io/master/revues_persee_full.csv" |>
  readr::read_csv() |>
  janitor::clean_names()

list_subcorpora <- list_subcorpora_raw |>
  dplyr::select(
    subcorpus_name = nom_de_la_revue,
    subcorpus = codes,
    reliable_from = debut,
    reliable_to = fin,
    disciplines
  ) |>
  dplyr::mutate(
    corpus = "persee",
    disciplines = str_split(disciplines, ";")
  )

usethis::use_data(list_subcorpora, overwrite = TRUE)
