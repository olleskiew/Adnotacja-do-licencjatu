library(tidyverse)

# Wczytaj dane
data <- read.csv("ranked_genes_wilcoxon.csv")

# Sprawdź nagłówki, czy wszystko się zgadza
print(colnames(data))

# Wybierz top 5 genów na klaster wg score
lista <- data %>%
  group_by(group) %>%
  arrange(desc(scores)) %>%
  slice_head(n = 5) %>%
  ungroup() %>%
  select(names)

# Zapisz bez usuwania duplikatów!
write.csv(lista, "gene_list.csv", row.names = FALSE)
