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
  summarise(Suma = sum(Count)) %>% 
  mutate(Condition = case_when(
    Plik %in% c("1", "4", "6") ~ "G-CSF",
    Plik %in% c("7", "8") ~ "Kontrola",
    TRUE ~ "klastry wspólne")
  ) %>% 
  ungroup()

View(GO_data_processed)

ggplot(summed, aes(x=Suma, y=Biological_process, fill=Condition))+
  geom_bar(stat = "identity")+
  labs(
    title = "Analiza wzbogacenia",
    x = "Suma zliczeń",
    y = "Proces biologiczny"
  )+
  theme_minimal()
#sessionInfo()