library(tidyverse)

#Wczytanie pliku z genami wybranymi testem Wilcoxona (źródło: Galaxy)
geny_wilcoxon <- read.csv("geny_wilcoxon.csv")

#Stworzenie wektora z nazwami plików do zapisu
nazwy <- paste0("geny_wilcoxon_klaster_", 0:8, ".csv")

#Rozdzielamy plik csv na mniejsze pliki w zależności od tego do jakiego klastra przynależy dany gen
geny_klastry <- geny_wilcoxon %>% 
  group_by(group) %>% 
  group_split() 

#Zapisujemy listy naszych genów
walk2(geny_klastry, nazwy, write.csv, row.names = FALSE)
