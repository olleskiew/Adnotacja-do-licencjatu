library(tidyverse)
#Test działania na jednym pliku, zastąp później 0 0:8
file_list <- paste0("DAVID_wyniki/DAVID_klaster_", 0, ".txt")
print(file_list)

for( sciezka in file_list ){
  file <- read_lines(sciezka)
  komunikat <- paste0("Wczytano plik: ", sciezka)
  print(komunikat)
  
  
  df_out <- tibble()
  
  cluster_start_lines <- which(str_detect(file, "^Annotation Cluster "))
  
  for(i in seq_along(cluster_start_lines)){
    #numer lini od której zaczyna się klaster
    idx_start <- cluster_start_lines[i]
    
    #ostatnia linia danego klastra
    idx_next <- if(i < length(cluster_start_lines)) cluster_start_lines[i+1]-1 else length(file)
    
    beginning_line <- file[idx_start]
    #Zapisujemy numer klastra za pomocą wyrażeń regularnych
    cluster_number <- str_extract(beginning_line, "(?<=Annotation Cluster\\s)\\d+")
    
    #Zapisujemy wartość enrichemnt score na podstawie wyrażeń regularnych
    enrichment_score <- str_extract(beginning_line, "(?<=Enrichment Score:\\s)[0-9\\.]+")
    
    #Sprawdzam czy wszystko śmiga
    komunikat <- paste0("Numer klastra: ", cluster_number, " Enrichment score: ", enrichment_score)
    print(komunikat)
    
    GO_lines <- file[(idx_start + 2):idx_next]
    GO_lines <- GO_lines[str_detect(GO_lines, "^GOTERM")]
    
    parsed<-str_split_fixed(GO_lines, "\\t", n=13)
    
    colnames(parsed) <- c(
      "Category", "Term", "Count", "Percent", "PValue", "Genes",
      "List_Total", "Pop_Hits", "Pop_Total", "Fold_Enrichment",
      "Bonferroni", "Benjamini", "FDR")
      
    df_tymczas <- as_tibble(parsed) %>% 
      mutate(
        Cluster = cluster_number,
        Enrichment_score = enrichment_score
      ) %>% 
      separate(col = "Term", into = c("GO_ID", "GO_term"), sep="~") %>% 
      select(Cluster, Enrichment_score, everything())
    
    df_out <-bind_rows(df_out, df_tymczas)
    headers <- colnames(df_out)
    print(headers)
    
  }
  glimpse(df_out)
  View(df_out)
}
