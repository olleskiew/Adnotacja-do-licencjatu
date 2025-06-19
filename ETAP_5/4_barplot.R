library(tidyverse)
library(tidytext)

df_all <- read.csv("parsed_all_clusters.csv")

#Podglądamy ramkę danych
glimpse(df)

df_all <- df_all %>% 
  mutate(
    condition = case_when(
      Plik %in% c(5, 6) ~ "G-CSF",
      Plik %in% c(4, 7, 8) ~ "kontrolne" ,
      Plik %in% c(0, 1, 2, 3) ~ "mieszane"
    )
  )

condition_colors <- c(
  "kontrolne" = "#2eb8d2",  # niebieski
  "G-CSF" = "#d90e7b",      # róż
  "mieszane" = "#a256be"    # fiolet
)

df_top_terms <- df_all %>% 
  filter(Enrichment_score >= 1, str_detect(GO_ID, "^GO:"))%>% 
  group_by(condition) %>% 
  distinct(GO_term, .keep_all = TRUE) %>% 
  arrange(desc(Enrichment_score), .by_group = TRUE) %>% 
  slice_max(Enrichment_score, n=10, with_ties = FALSE)
 
df_kontrola <- df_top_terms %>% filter(condition == "kontrolne")
df_gcsf     <- df_top_terms %>% filter(condition == "G-CSF")
df_mieszany <- df_top_terms %>% filter(condition == "mieszane")

names(df_kontrola)

ggplot(df_kontrola, aes( x=Count, y= reorder(GO_term, Enrichment_score),
                         fill = Enrichment_score))+
  geom_col()+
  scale_fill_gradientn(colors = c("grey", condition_colors["kontrolne"]),
                       limits = c(1.05, 1.25),
                       name = "Enrichment score",
                       labels = scales::label_number(accuracy = 0.01))+
  labs(
    title = "Top 10 GO_terms — klastry kontrolne",
    x = "Liczba genów (Count)",
    y = NULL, 
    fill = "Enrichment"
  ) + 
  theme_minimal()
ggsave("top_GO_terms_kontrola.png", width = 8, height = 5, dpi = 300)

ggplot(df_gcsf, aes( x=Count, y= reorder(GO_term, Enrichment_score),
                         fill = Enrichment_score))+
  geom_col()+
  scale_fill_gradientn(colors = c("grey", condition_colors["G-CSF"]),
                       limits = c(6.95, 6.98),
                       name = "Enrichment score",
                       labels = scales::label_number(accuracy = 0.01))+
  labs(
    title = "Top 10 GO_terms — klastry G-CSF",
    x = "Liczba genów (Count)",
    y = NULL, 
    fill = "Enrichment"
  ) + 
  theme_minimal()
ggsave("top_GO_terms_G-CSF.png", width = 8, height = 5, dpi = 300)

ggplot(df_mieszany, aes( x=Count, y= reorder(GO_term, Enrichment_score),
                     fill = Enrichment_score))+
  geom_col()+
  scale_fill_gradientn(colors = c("grey", condition_colors["mieszane"]),
                       limits = c(1, 8),
                       name = "Enrichment score",
                       labels = scales::label_number(accuracy = 0.01))+
  labs(
    title = "Top 10 GO_terms — klastry mieszane",
    x = "Liczba genów (Count)",
    y = NULL, 
    fill = "Enrichment"
  ) + 
  theme_minimal()
ggsave("top_GO_terms_mieszane.png", width = 8, height = 5, dpi = 300)
