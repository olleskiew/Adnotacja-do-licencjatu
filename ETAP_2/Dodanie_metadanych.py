#Kod został napisany w środowisku Google Collab
\begin{minted}[breaklines=true, fontsize=\footnotesize, linenos]{python}
!pip install scanpy

#instalacja podstawowych bibliotek
from google.colab import files
import scanpy as sc
import pandas as pd

#wczytanie pliku z menu komputera:
uploaded = files.upload()

#Przypisanie pliku do zmiennej i obejrzenie jego podstawowych własności:

adata = sc.read_h5ad('Anndata_concatenate.h5ad')

print(adata)          # wypisanie ogólnej informacji o wymiarach i kolumnach
adata.obs.head()      # obserwacje
adata.var.head()      # zmienne

#zmiana nazwy kolumny z patient na batch
adata.obs.rename(columns={'patient':'batch'}, inplace=True)
print(adata.obs.columns)

#Sprawdzenie czy operacja się powiodła
print(adata.obs)

#Stworzenie słownika, który umożliwi zmapowanie wartości z kolumny 'batch' do kolumny 'patient'
batch_to_patient ={
    0:1,
    1:6,
    2:7,
    3:2
}

#Ustawenie typu 'batch' na int (liczbę całkowitą), ponieważ pierwotnie byl on categorical
adata.obs['batch'] = adata.obs['batch'].astype(int)

#Stworzenie kolumny 'patient' i przypianie do niej zmapowanych wartości z 'batch'
adata.obs['patient'] = adata.obs['batch'].map(batch_to_patient)

#Wyświetlenie pierwszych 10 lini obserwacji 'batch' i 'patient' w celu sprawdzenia poprawności
adata.obs[['batch', 'patient']].head(10)

#Utworzenie słownika, który zostanie wykorzystany do zmapowania wartości z kolumny 'patient' na kolumnę 'gcsf'
gcsf_map = {
    1: 'normal',
    2: 'normal',
    6: 'G-CSF treated donor',
    7: 'G-CSF treated donor'
}

# Utworzenie kolumny gcsf w obserwacjach i przypisanie do niej zmapowanych za pomocą słownika wartości
adata.obs['gcsf'] = adata.obs['patient'].map(gcsf_map)

#Zliczanie ilości próbek w zależności od wartości w kolumnie gcsf
print(adata.obs['gcsf'].value_counts())

#Wyświetlenie pierwszych 10 lini obserwacji 'batch', 'patient' i 'gcsf'
adata.obs[['batch','patient','gcsf']].head(10)

#utworzenie kolumny 'mito' w varach na podstawie wartości w kolumnach gene_symbols - prefix 'MT-'
adata.var['mito']=(
    adata.var['gene_symbols']
    .str.upper()
    .str.startswith('MT-')
)

#Wyświetlenie pierwszych dziesięciu lini. By wyświetlić ostatnie 10 należy użyć:
#adata.var[['gene_symbols', 'mito']].tail(10)

adata.var[['gene_symbols', 'mito']].head(10)


dups = adata.var['gene_symbols'][adata.var['gene_symbols'].duplicated(keep=False)]
unique_dup_symbols = dups.unique()
print(f"Znaleziono {len(unique_dup_symbols)} nazw genów występujących wielokrotnie:")
print(unique_dup_symbols[:20])

#Przypisanie wartości z kolumny 'gene_symbols' do names_str i zmiana typu danych z categorical na string
names_str = adata.var['gene_symbols'].astype(str)


counts = names_str.groupby(names_str, observed=False).cumcount()

#Dodawanie surfixów _number
unique_names = names_str.where(
    counts == 0,
    names_str + "_" + (counts + 1).astype(str)
)

#przypisanie unikalnych nazw genów do kolumny 'gene_names' w var
adata.var['gene_symbols'] = unique_names

#Sprawdzenie czy występują duplikaty (True/False)
print("Czy są duplikaty?", adata.var['gene_symbols'].duplicated().any())

# Zapis istniejących ENSG* jako ensemble_id
adata.var['ensemble_id'] = adata.var.index.astype(str)

# Przenosimy gene_symbols na indeks var
adata.var.index = adata.var['gene_symbols']

# Wybranie dwóch kolumn
adata.var = adata.var[['ensemble_id', 'mito']]

# Ile teraz mamy zmiennych i jak wyglądają kolumny?
print(adata.var.shape)
print(adata.var.columns)
adata.var.head(5)

adata.write('processed_data.h5ad')

#Zapis pliku na dysku lokalnym, w celu późniejszego przesłania go na server galaxy.eu
from google.colab import files
files.download('processed_data.h5ad')
