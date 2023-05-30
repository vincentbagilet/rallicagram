## The code to prepare the `word_lemma_stem` data set
library(SnowballC)
library(dplyr)

temp <- tempfile()
utils::download.file("http://www.lexique.org/databases/Lexique383/Lexique383.zip", temp)
lexique <- readRDS(gzcon(unz(temp, "Lexique383.rds")))
unlink(temp)

word_lemma_stem <- lexique |>
  dplyr::select(word = ortho, lemma = lemme) |>
  dplyr::mutate(stem = wordStem(lemma, language = "fr"))

usethis::use_data(word_lemma_stem, overwrite = TRUE)
