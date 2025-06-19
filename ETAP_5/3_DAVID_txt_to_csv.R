library(tidyverse)
#Przygotowanie listy sciezek do wczytywania plików
file_list <- paste0("DAVID_klaster_", 0:8, ".txt")
print(file_list)

#Ramka danych, w której będziemy przetrzymywać zbiorcze wyniki, z wszystkich plików
df_all <- tibble()


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
    TEST <- file[idx_next]
    
    print(TEST)
    
    beginning_line <- file[idx_start]
    #Zapisujemy numer klastra za pomocą wyrażeń regularnych
    cluster_number <- str_extract(beginning_line, "(?<=Annotation Cluster\\s)\\d+")
    
    #Zapisujemy wartość enrichemnt score na podstawie wyrażeń regularnych
    enrichment_score <- str_extract(beginning_line, "(?<=Enrichment Score:\\s)[0-9\\.]+")
    
    #Sprawdzam czy wszystko śmiga
    komunikat <- paste0("Numer klastra: ", cluster_number, " Enrichment score: ", enrichment_score)
    print(komunikat)
    
    GO_lines <- file[(idx_start + 2):idx_next]
    GO_lines <- GO_lines[str_count(GO_lines, "\t") == 12]
    
    if(length(GO_lines) == 0){
      warning(paste("Brak danych GO dla klastra", cluster_number, "w pliku", sciezka))
      next
    }
    
    parsed<-str_split_fixed(GO_lines, "\\t", n=13)
    
    #Nadajmy nazwę kolumnom
    colnames(parsed) <- c(
      "Category", "Term", "Count", "Percent", "PValue", "Genes",
      "List_Total", "Pop_Hits", "Pop_Total", "Fold_Enrichment",
      "Bonferroni", "Benjamini", "FDR")
      
    #df_tymczas przechowuje informacje o jednym klastrze z DAVIDowego pliku na raz
    df_tymczas <- as_tibble(parsed) %>% 
      mutate(
        Cluster = cluster_number,
        Enrichment_score = enrichment_score
      ) %>% 
      separate(col = "Term", into = c("GO_ID", "GO_term"), sep="~") %>% #Rozdzielnie Term na dwie kolumny
      select(Cluster, Enrichment_score, everything()) %>% #Ustawiam ramkę danych tak, by Cluster i Enrichment_score były na początku
      mutate(across(-c(Category, GO_ID, GO_term, Genes), as.numeric)) #Zmiana typu wszystkich kolumn na numeric poza Category, GO_ID, GO_term i Genes
             
    df_tymczas <- df_tymczas %>%
      mutate(
        GO_ID_full = GO_ID  # kopia zapasowa przed rozdzieleniem
      ) %>%
      mutate(
        GO_ID = if_else(is.na(GO_term) & str_detect(GO_ID, ":"), str_extract(GO_ID, "^[^:]+"), GO_ID),
        GO_term = if_else(is.na(GO_term) & str_detect(GO_ID_full, ":"), str_extract(GO_ID_full, "(?<=:).*"), GO_term)
      )
    
    
    #sklejenie wszystkich klastrow z danego pliku
    df_out <-bind_rows(df_out, df_tymczas)
    
  
    
  }
  #Wciąganie numeru pliku za ścieżki
  plik_id <- str_extract(sciezka, "\\d+")
  
  #Dopisanie kolumny plik z informacją o numerze pliku, z której pochodzi lista genów
  df_out<- df_out %>% 
    mutate(Plik=plik_id)
  
  #Zapis pliku csv dla każdej listy genów osobno
  #write_csv(df_out, paste0("DAVID_wyniki/parsed_klaster_", plik_id, ".csv"))
  
  #Dopisanie ramki danych dla listy do pliku zbiorczego
  df_all <- bind_rows(df_all, df_out)
  
  #df_tymczas przechowuje informacje o jednym klastrze z DAVIDowego pliku na raz
  df_tymczas <- as_tibble(parsed) %>% 
    mutate(
      Cluster = cluster_number,
      Enrichment_score = enrichment_score
    ) %>% 
    separate(col = "Term", into = c("GO_ID", "GO_term"), sep="~") %>% #Rozdzielnie Term na dwie kolumny
    select(Cluster, Enrichment_score, everything()) %>% #Ustawiam ramkę danych tak, by Cluster i Enrichment_score były na początku
    mutate(across(-c(Category, GO_ID, GO_term, Genes), as.numeric)) #Zmiana typu wszystkich kolumn na numeric poza Category, GO_ID, GO_term i Genes
  
  df_tymczas <- df_tymczas %>%
    mutate(
      GO_ID_full = GO_ID  # kopia zapasowa przed rozdzieleniem
    ) %>%
    mutate(
      GO_ID = if_else(is.na(GO_term) & str_detect(GO_ID, ":"), str_extract(GO_ID, "^[^:]+"), GO_ID),
      GO_term = if_else(is.na(GO_term) & str_detect(GO_ID_full, ":"), str_extract(GO_ID_full, "(?<=:).*"), GO_term)
    )
  
  
  df_all <- df_all %>%
    mutate(
      GO_ID = if_else(
        is.na(GO_term) & str_detect(GO_ID, "^\\d+\\."),  # przypadek z numerem + kropka
        str_extract(GO_ID, "^\\d+"),
        GO_ID
      ),
      GO_term = if_else(
        is.na(GO_term) & str_detect(GO_ID, "^\\d+\\."),  # przypadek z numerem + kropka
        str_extract(GO_ID, "(?<=\\.)\\s*.*"),
        GO_term
      ),
      GO_term = if_else(
        is.na(GO_term), GO_ID, GO_term  # powielamy GO_ID jako fallback
      )
    )
}
#Zapis pliku zbiorczego
write.csv(df_all, "parsed_all_clusters.csv")
komunikat<-"Zakończono działanie, wszystkie wyniki zostały zapisane"
print(komunikat)
View(df_all)

df_all %>%
  filter(is.na(GO_ID) | is.na(GO_term)) %>%
  View()
