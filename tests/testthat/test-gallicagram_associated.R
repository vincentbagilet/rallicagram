test_that("Error if keyword not character string", {
  expect_error(
    gallicagram_associated(keyword = c("avion", "patate")),
    "'keyword' should be a character string and not a character vector"
  )
})

test_that("Error if distance too large", {
  expect_warning(
    gallicagram_associated(keyword = "camarade", corpus = "lemonde",
                           distance = 5),
    "Distance set to 'max'. The sum of the number of words in 'keyword' and
      'distance' cannot be more than 4 for this corpus."
  )
  expect_warning(
    gallicagram_associated(
      keyword = "camarade", corpus = "books", distance = 4,
      from = 1860, to = 1890
    ),
  "Distance set to 'max'. The sum of the number of words in 'keyword' and
      'distance' cannot be more than 3 for this corpus."
  )
})

test_that("Error if distance negative", {
  expect_error(
    gallicagram_associated(keyword = "son camarade de", distance = 0),
    "'distance' has to be larger than 0"
  )
})
