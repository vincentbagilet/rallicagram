test_that("Error if lexicon not character a character vector", {
  expect_error(
    gallicagram_lexicon(lexicon = 3),
    "'lexicon' must be a character vector."
  )
})
