test_that("Error if keyword not character string", {
  expect_error(
    gallicagram(keyword = 23),
    "'keyword' should be a character string"
  )
  expect_error(
    gallicagram(keyword = FALSE),
    "'keyword' should be a character string"
  )
})

test_that("Error if from or to not numerical", {
  expect_error(
    gallicagram(keyword = "président", from = "err"),
    "'from' and 'to' should be numeric.+"
  )
  expect_error(
    gallicagram(keyword = "président", to = "err"),
    "'from' and 'to' should be numeric.+"
  )
})

test_that("Invalid corpus name", {
  expect_error(
    gallicagram(keyword = "président", corpus = "err"),
    "The corpus should be one of.+"
  )
  expect_error(
    gallicagram(keyword = "président", corpus = 3),
    "The corpus should be one of.+"
  )
})

test_that("Invalid resolution", {
  expect_error(
    gallicagram(keyword = "président", resolution = "err"),
    "Resolution can only.+"
  )
  expect_error(
    gallicagram(
      keyword = "président",
      corpus = "books",
      resolution = "daily",
      from = 1800,
      to = 1820
    ),
    ".+only available.+"
  )
  expect_error(
    gallicagram(
      keyword = "président",
      corpus = "press",
      from = 1800,
      to = 1820,
      resolution = "daily"
    ),
    ".+only available.+"
  )
})

test_that("Non reliable corpus", {
  expect_warning(
    gallicagram(keyword = "président", "press", from = 1700, to = 1740),
    ".+only reliable.+"
  )
  expect_warning(
    gallicagram(
      keyword = "président",
      corpus = "books",
      resolution = "yearly",
      from = 1960,
      to = 1970
    ),
    ".+only reliable.+"
  )
})
