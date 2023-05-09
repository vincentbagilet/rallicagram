test_that("Error if keyword not character string", {
  expect_error(
    gallicagram_associated(keyword = c("avion", "patate")),
    "'keyword' should be a character string and not a character vector"
  )
})
