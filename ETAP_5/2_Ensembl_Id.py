#Przygotowanie ścieżek plików i zmiennych, służących do kontroli
file_list <- paste0("input/geny_wilcoxon_klaster_", 0:8, ".csv")
number_of_genes <- c()
number_of_filtered_genes <- c()

#kontrola czy ściezki są poprawne
print(file_list)

#Plik cut_var.csv zawiera wycięte variables z pliku Anndata, wśród których znajduje się ensembl_id. Plik uzyskano przy użyciu serwera Galaxy
map_genes <-read.csv("cut_var.csv")

for (file_path in file_list){
  #Wczytanie pliku na podstawie ścieżek i sprawdzenie nazw kolumn
  file <- read_csv(file_path)
  headers <- colnames(file)
  
  number_of_genes <- c(number_of_genes, nrow(file))
 #Odfiltowywujemy tylko 3000 genów, ponieważ taką maksymalną liczbę przyjmuję DAVID 
  filtered_file <- file %>% 
    filter(abs(logfoldchanges) >0.65, pvals_adj <0.05) %>% 
    slice_head(n = 3000)
  
  number_of_filtered_genes <- c(number_of_filtered_genes, nrow(filtered_file))
  
  if( tail(number_of_filtered_genes,1) < 3000){
    df <- file %>% 
      filter(!(names %in% filtered_file$names)) %>% 
      arrange(desc(abs(logfoldchanges))) %>% 
      slice_head(n = 3000 - tail(number_of_filtered_genes, 1))
      
    filtered_file <- bind_rows(filtered_file, df)
  }
    filtered_file <- (select(filtered_file, names))
    
    filtered_file <- filtered_file %>%
      left_join(map_genes, by = c("names" = "gene_symbols"))
    
    filtered_file <- select(filtered_file, ensemble_id)
    View(filtered_file)
  
    basename <- tools::file_path_sans_ext(basename(file_path))
    out_path <- paste0(basename, "_mapped.txt")
    write_lines(filtered_file$ensemble_id, out_path)
}

print(number_of_genes)
print(number_of_filtered_genes)
