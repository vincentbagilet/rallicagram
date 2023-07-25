test_that("Error if lexicon not character a character vector", {
  expect_error(
    gallicagram_associated_lexicon(lexicon = 3),
    "'lexicon' must be a character vector."
  )
})

test_that("Error if distance too large", {
  expect_warning(
    gallicagram_associated_lexicon(lexicon = "camarade", corpus = "lemonde",
                           distance = 5),
    "Distance set to 'max'. The sum of the number of words in 'keyword' and
      'distance' cannot be more than 4 for this corpus."
  )
  expect_warning(
    gallicagram_associated_lexicon(
      lexicon = "camarade", corpus = "books", distance = 4,
      from = 1860, to = 1890
    ),
    "Distance set to 'max'. The sum of the number of words in 'keyword' and
      'distance' cannot be more than 3 for this corpus."
  )
})

test_that("Error if distance negative", {
  expect_error(
    gallicagram_associated_lexicon(lexicon = "son camarade de", distance = 0),
    "'distance' has to be larger than 0"
  )
})
