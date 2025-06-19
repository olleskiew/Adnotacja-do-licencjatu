\begin{minted}[breaklines=true, fontsize=\footnotesize, linenos]{python}
def main():
    print("Rozpoczynam pracę")

    # Wczytanie danych - w pliku nature_genes.csv znajdują się geny wybrane na podstawie literatury
    genes = pd.read_csv("nature_genes.csv")["Gene"].tolist()
    print("Lista genów została wczytana")

    adata = sc.read_h5ad("Anndata_do_filtrowania.h5ad")
    print("Andata została wczytana")

#Ustawienie typu zapisu na svg
    sc.settings.set_figure_params(format='svg')

#Stworzenie dotplota
    sc.pl.dotplot(
        adata,
        var_names=genes,
        groupby="louvain",
        use_raw=True,
        log=True,
        standard_scale="var",
        figsize=(10, 6),
        show=False,
        save="dotplot_literatura",
    )

    print("Stworzono dotplot")

if __name__ == "__main__":
    main()
\end{minted}
