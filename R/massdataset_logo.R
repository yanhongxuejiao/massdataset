#' @title massdataset_logo
#' @description Get the detailed of massdataset package.
#' @author Xiaotao Shen
#' \email{shenxt1990@@outlook.com}
#' @importFrom stringr str_replace str_split str_replace_all str_trim
#' @importFrom ComplexHeatmap Heatmap columnAnnotation anno_barplot
#' @importFrom grid gpar
#' @importFrom ggplotify as.ggplot
#' @importFrom dplyr filter mutate select everything
#' @importFrom rstudioapi isAvailable hasFun getThemeInfo
#' @importFrom utils packageDescription write.csv
#' @importFrom cli rule symbol
#' @importFrom crayon green blue col_align red black white style make_style num_colors
#' @importFrom plotly ggplotly
#' @importFrom pbapply pblapply
#' @importFrom openxlsx write.xlsx
#' @importFrom purrr map map2
#' @importFrom readr write_csv read_csv
#' @importFrom methods slot slot<-
#' @import ggplot2
#' @importFrom methods .hasSlot new
#' @importFrom stats p.adjust rgamma sd median
#' @importFrom utils data str head
#' @importFrom magrittr %>%
#' @importFrom ggsci pal_lancet 
#' @export
#' @examples
#' massdataset_logo()

massdataset_logo <- function(){
  cat(crayon::green("Thank you for using massdataset!\n"))
  cat(crayon::green("Version", massdataset_version, "(", update_date, ')\n'))
  cat(crayon::green("More information can be found at https://tidymass.github.io/massdataset/\n"))
  cat(crayon::green(
    c("                          _____        _                 _   ", 
      "                         |  __ \\      | |               | |  ", 
      "  _ __ ___   __ _ ___ ___| |  | | __ _| |_ __ _ ___  ___| |_ ", 
      " | '_ ` _ \\ / _` / __/ __| |  | |/ _` | __/ _` / __|/ _ \\ __|", 
      " | | | | | | (_| \\__ \\__ \\ |__| | (_| | || (_| \\__ \\  __/ |_ ", 
      " |_| |_| |_|\\__,_|___/___/_____/ \\__,_|\\__\\__,_|___/\\___|\\__|", 
      "                                                             ", 
      "                                                             "
    )
    
  ), sep = "\n")
}

massdataset_version = "0.01"
update_date = "2021-12-15"


# library(cowsay)
# # https://onlineasciitools.com/convert-text-to-ascii-art
# # writeLines(capture.output(say("Hello"), type = "message"), con = "ascii_art.txt")
# art <- readLines("logo.txt")
# dput(art)
# metid_logo <-
#   c("                          _____        _                 _   ", 
#     "                         |  __ \\      | |               | |  ", 
#     "  _ __ ___   __ _ ___ ___| |  | | __ _| |_ __ _ ___  ___| |_ ", 
#     " | '_ ` _ \\ / _` / __/ __| |  | |/ _` | __/ _` / __|/ _ \\ __|", 
#     " | | | | | | (_| \\__ \\__ \\ |__| | (_| | || (_| \\__ \\  __/ |_ ", 
#     " |_| |_| |_|\\__,_|___/___/_____/ \\__,_|\\__\\__,_|___/\\___|\\__|", 
#     "                                                             ", 
#     "                                                             "
#   )
# cat(metid_logo, sep = "\n")
