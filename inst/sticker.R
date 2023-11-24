## The code to make the hexSticker

library(ggplot2)
library(hexSticker)
library(rallicagram)

p <- gallicagram("climatique") |>
  gallicagraph() +
  theme_void() +
  labs(title = NULL)


sticker(
  p,
  package = "MEDIOCRETHEMES",
  p_size = 12,
  p_color = "#FB9637",
  p_family = "Lato",
  spotlight = TRUE,
  s_x = 1,
  s_y = .75,
  s_width = 1.3,
  s_height = 1,
  filename = "inst/hex_sticker.png",
  h_fill = "#00313C",
  h_color = "#FB9637"
)

