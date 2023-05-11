test_that("Error if keyword_1 not character string", {
  expect_error(
    gallicagram_cooccur(keyword_1 = c("avion", "patate"), keyword_2 = "test"),
    "'keyword' should be a character string and not a character vector"
  )
})

test_that("Error if keyword_2 not character string", {
  expect_error(
    gallicagram_cooccur(keyword_1 = "test", keyword_2 = c("avion", "patate")),
    "'keyword' should be a character string and not a character vector"
  )
})
