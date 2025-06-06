library(tidyverse)

data <- read.csv("parsed_all_clusters.csv")
annotacje <- list()

#Filtrowanie ramki danych
headers <- colnames(data)
print(headers)
filtered_data <- data %>% 
  filter(Enrichment_score >= 1) %>% 
  select(Plik, Cluster, Enrichment_score, GO_term, Count) 

klastry <- filtered_data %>% 
  group_by(Plik, Cluster) %>% 
  summarise(
   fingerprint = paste(sort(unique(GO_term)), collapse =";"),
    Enrichment_score = first(Enrichment_score)) %>% 
    mutate(Biological_process = NA_character_) %>% 
    ungroup() 

for(i in seq_len(nrow(klastry))){
  fp <-klastry$fingerprint[i]
  
  if(!fp %in% names(annotacje)){
    cat("\nPlik:", klastry$Plik[i], "| Cluster:", klastry$Cluster[i],"\n")
    cat("GO-terms:\n", gsub(";","\n", fp), "\n")
   
    odp <- readline(prompt = "Podaj nazwę procesu biologicznego: ")
    annotacje[[fp]] <- odp
    
  }
  
  klastry$Biological_process[i] <- annotacje [[fp]]
  
}

write.csv(klastry, "plik_z_anntocją.csv")