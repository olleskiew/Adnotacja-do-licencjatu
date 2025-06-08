import scanpy as sc
import pandas as pd
import numpy as np

def main():
    print("Rozpoczynam pracę")
    # Wczytanie
    adata = sc.read_h5ad("E:/Filtrowanie/Anndata_do_filtrowania.h5ad")
    print("Andata została wczytana")
    genes = pd.read_csv("gene_list.csv")["names"].tolist()
    print("Lista genów została wczytana")

    sc.settings.set_figure_params(format='svg')

    sc.pl.dotplot(
        adata,
        var_names=genes,
        groupby="louvain",
        group_order=["4", "7", "8", "5","6", "0", "1", "2", "3"],
        use_raw=True,
        log=True,
        standard_scale="var",
        figsize=(10, 6),
        show=False,
        save="dotplot_new_3",
    )

    print("Stworzono dotplot")

if __name__ == "__main__":
    main()
