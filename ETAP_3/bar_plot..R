#Skrypt do stworzenia barplotu:
library(tidyverse)

#Wczytanie danych - pliku DAVID.csv i pliku z annotacjami
dane <- read.csv("parsed_all_clusters.csv")
annotations <- read.csv("plik_z_anntocją.csv")

#Zdefiniowanie funkcji do ujednolicenia zapisu annotacji
capitalize_first_word <- function(x)
{
  str_replace(x, "^(\\w)(\\w*)", function(m) 
    {
    paste0(toupper(substr(m, 1, 1)), substr(m, 2, nchar(m)))
  })
}

GO_data_processed <- dane %>% 
  filter(Enrichment_score >=1) %>% 
  select(Plik, Cluster, GO_term, Count) %>% 
  left_join(annotations %>% select(Plik, Cluster, Biological_process),
            by = c("Plik", "Cluster"))


GO_data_processed <- GO_data_processed %>% 
  mutate(Biological_process = capitalize_first_word(Biological_process)) %>% 
  mutate(Biological_process = recode(Biological_process,
                                     "Biosynteza Hemu" = "Biosynteza hemu",
                                     "biosynteza hemu" = "Biosynteza hemu",
                                     "Biosytneza hemu" = "Biosynteza hemu"))


summed <- GO_data_processed %>% 
  group_by(Biological_process, Plik) %>% 
  summarise(Suma = sum(Count)) %>% 
  mutate(Condition = case_when(
    Plik %in% c("1", "4", "6") ~ "G-CSF",
    Plik %in% c("7", "8") ~ "Kontrola",
    TRUE ~ "klastry wspólne")
  ) %>% 
  ungroup()

colors <- c(
  "G-CSF" = "#CD5733",         # intensywny pomarańcz
  "klastry wspólne" = "#F4E7C5FF",  # granatowo-szary
  "Kontrola" = "#678096"       # głęboka czerwień
)


ggplot(summed, aes(x=Suma, y=Biological_process, fill=Condition))+
  geom_bar(stat = "identity")+
  scale_fill_manual(values = colors)+
  labs(
    title = "Analiza wzbogacenia",
    x = "Suma zliczeń",
    y = "Proces biologiczny",
    fill = "Rodzaj klastra"
  )+
  theme_minimal(base_size = 14)+
  theme(
    axis.text.y = element_text(size =10, margin = margin(r=10))
  )

ggsave("barplot_procesy_biologiczne.png", width =12, height = 10, dpi =300)
#sessionInfo()