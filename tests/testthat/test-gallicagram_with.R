test_that("Error if keyword not character string", {
  expect_error(
    gallicagram_with(keyword = c("avion", "patate")),
    "'keyword' should be a character string and not a character vector"
  )
})

test_that("Error if length too long", {
  expect_error(
    gallicagram_with(keyword = "camarade", corpus = "lemonde", length = 5),
    "'length' cannot be more than.+"
  )
  expect_error(
    gallicagram_with(
      keyword = "camarade", corpus = "books", length = 8,
      from = 1860, to = 1890
    ),
  "'length' cannot be more than.+"
  )
  expect_error(
    gallicagram_with(keyword = "son camarade de", length = 2),
    "'length' has to be larger than the number of words in 'keyword'"
  )
})
