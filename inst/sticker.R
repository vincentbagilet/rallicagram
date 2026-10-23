## The code to make the hexSticker

library(tidyverse)
library(mediocrethemes)
library(hexSticker)

set_mediocre_all(pal = "portal")

N <- 20
alpha <- 2
beta <- 1.3

dat <- tibble(
  x = rnorm(N),
  u = rnorm(N, 0, 0.5),
  y = alpha + beta*x + u)

p <- dat |>
  ggplot(aes(x = x, y = y)) +
  geom_point() +
  # geom_smooth(method = "lm", se = FALSE) +
  # labs(x = NULL, y = NULL) +
  theme_void()

sticker(
  p,
  package = "Metrics",
  # p_size = 12,
  # p_color = "#FB9637",
  # p_family = "Lato",
  # spotlight = TRUE,
  # s_x = 1,
  # s_y = .75,
  # s_width = 1.3,
  # s_height = 1,
  filename = "images/hex_sticker.png"
  # h_fill = "#00313C",
  # h_color = "#FB9637"
)

