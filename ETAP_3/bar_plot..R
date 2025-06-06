#Skrypt do stworzenia barplotu:
library(tidyverse)


dane <- read.csv("parsed_all_clusters.csv")
annotations <- read.csv("plik_z_anntocją.csv")

GO_data_processed <- dane %>% 
  filter(Enrichment_score >=1) %>% 
  select(Plik, Cluster, GO_term, Count) %>% 
  left_join(annotations %>% select(Plik, Cluster, Biological_process),
            by = c("Plik", "Cluster"))

summed <- GO_data_processed %>% 
  group_by(Biological_process, Plik) %>% 
  mutate(Condition = case_when(
    Plik %in% c(1, 4, 6) ~ "G-CSF",
    Plik %in% c(7, 8) ~ "Kontrola",
    TRUE ~ "klastry wspólne")
         )
  summarise(Suma = sum(Count)) %>% 
  ungroup()


#sessionInfo()