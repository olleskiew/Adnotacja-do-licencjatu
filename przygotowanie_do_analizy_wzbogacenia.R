library(tidyverse)

file_list <- paste0("DAVID_wyniki/DAVID_klaster_", 0:8, ".txt")
print(file_list)

for(sciezka in file_list){
  file <- read_lines(sciezka)
  komunikat <- paste0("Wczytano plik: ", sciezka)
}