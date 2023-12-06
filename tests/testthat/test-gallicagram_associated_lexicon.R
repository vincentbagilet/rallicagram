test_that("Error if lexicon not character a character vector", {
  expect_error(
    gallicagram_associated_lexicon(lexicon = 3),
    "'lexicon' must be a character vector."
  )
})

test_that("Error if distance too large", {
  expect_warning(
    gallicagram_associated_lexicon(
      lexicon = "camarade",
      corpus = "lemonde",
      distance = 5,
      from = 2020
    ),
    "Distance set to \\'max\\'.+"
  )
  expect_warning(
    gallicagram_associated_lexicon(
      lexicon = "camarade", corpus = "livres", distance = 8,
      from = 1860, to = 1890
    ),
    "Distance set to \\'max\\'.+"
  )
})

test_that("Error if distance negative", {
  expect_error(
    gallicagram_associated_lexicon(lexicon = "son camarade de", distance = 0),
    "'distance' has to be larger than 0"
  )
})
