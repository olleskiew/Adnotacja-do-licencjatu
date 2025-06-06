library(tidyverse)

data <- read.csv("parsed_all_clusters.csv")


headers <- colnames(data)
print(headers)
filtered_data <- data %>% 
  filter(Enrichment_score >= 1) %>% 
  select(Plik, Cluster, Enrichment_score, GO_term, Count) %>% 
  mutate(Biological_process = NA) 

print(unique(filtered_data$Cluster))

GO_terms_vector <- c()