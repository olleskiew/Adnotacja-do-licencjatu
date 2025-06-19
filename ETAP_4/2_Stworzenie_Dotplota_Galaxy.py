\begin{minted}[breaklines=true, fontsize=\footnotesize, linenos]{python}
import pandas as pd
import scanpy as sc
import numpy as np

def main():
    print("Rozpoczynam pracę")
    # Wczytanie danych
    genes = pd.read_csv("gcsf_neutrophil_genes.csv")["Gene"].tolist()
    print("Lista genów została wczytana")

    adata = sc.read_h5ad("Anndata_do_filtrowania.h5ad")
    print("Andata została wczytana")

    sc.settings.set_figure_params(format='svg')

    sc.pl.dotplot(
        adata,
        var_names=genes,
        groupby="louvain",
        use_raw=True,
        log=True,
        standard_scale="var",
        figsize=(10, 6),
        show=False,
        save="dotplot_gcsf_genes",
    )

    print("Stworzono dotplot")

if __name__ == "__main__":
    main()
