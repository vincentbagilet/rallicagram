## The (super simple) code to prepare the `stopwords_gallica` data set

stopwords_gallica <-
  readr::read_csv("https://regicid.github.io/stopwords.csv") |>
  dplyr::slice(1:500) |>
  dplyr::select(stopword = monogram) %>%
  .$stopword

usethis::use_data(stopwords_gallica, overwrite = TRUE)
