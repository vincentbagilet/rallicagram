test_that("Error if keywords not a length 2 character vector", {
  expect_error(
    gallicagram_cooccur(keywords = c("avion")),
    "'keywords' should be a length 2 character vector"
  )
  expect_error(
    gallicagram_cooccur(keywords = c("avion", "crash", "accident")),
    "'keywords' should be a length 2 character vector"
  )
})
