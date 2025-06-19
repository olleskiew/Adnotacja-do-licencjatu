import scanpy as sc
import pandas as pd

def main():
    print("Rozpoczynam pracę")

    # Wczytanie danych:
    pbmc = sc.read_h5ad("Annotated data matrix.h5ad")
    print(pbmc.obs.columns)

    print("Filtrowanie wg częstości ekspresji (min_in=0.2, max_out=0.2)")
    sc.tl.filter_rank_genes_groups(
        pbmc,
        min_in_group_fraction=0.1,
        max_out_group_fraction=0.3
    )
    print("Zapisuję przefiltrowane geny do marker_genes_detailed.csv")
    result = pbmc.uns["rank_genes_groups_filtered"]
    groups = result["names"].dtype.names

    # Zapis top 5 genów z każdej grupy
    top_n = 5
    df_list = []
    for group in groups:
        df = pd.DataFrame({
            'gene': result["names"][group],
            'logfoldchange': result["logfoldchanges"][group],
            'pval_adj': result["pvals_adj"][group],
            'cluster': group
        })
        df_list.append(df.head(top_n))

#Stworzenie listy genów markerowych w postaci pliku csv
    markers_full = pd.concat(df_list)
    markers_full.to_csv("marker_genes_detailed.csv", index=False)

#Tworzenie dotplota
    print("Tworzenie dotplota (przefiltrowane markery)")
    sc.pl.rank_genes_groups_dotplot(pbmc, key="rank_genes_groups_filtered", n_genes=5)

if __name__ == "__main__":
    main()
