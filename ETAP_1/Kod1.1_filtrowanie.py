#!/usr/bin/env python
import time
from pathlib import Path
import scanpy as sc
import pandas as pd
from tqdm import tqdm

ADATA_PATH = "Anndata_for_enrichment_analysis_v2.h5ad"
OUT_DIR    = Path("filtered_markers")

MIN_IN_GROUP_FRAC  = 0.25
MAX_OUT_GROUP_FRAC = 0.50
MIN_LOG_FC         = 0.65  
COMPARE_ABS        = True  

def main():
    t0 = time.perf_counter()
    adata = sc.read_h5ad(ADATA_PATH, backed="r")

    groups = adata.uns["rank_genes_groups"]["names"].dtype.names
    dfs = []
    for g in groups:
        df = sc.get.rank_genes_groups_df(adata, group=g, key="rank_genes_groups")
        df["group"] = g
        dfs.append(df)

    rg_df = pd.concat(dfs, ignore_index=True)

    HAS_PCT = {"pct_nz_group", "pct_nz_reference"}.issubset(rg_df.columns)

    if HAS_PCT:
        if COMPARE_ABS:
            mask = (
                (rg_df["pct_nz_group"]     >= MIN_IN_GROUP_FRAC)  &
                (rg_df["pct_nz_reference"] <= MAX_OUT_GROUP_FRAC) &
                (rg_df["logfoldchanges"].abs() >= MIN_LOG_FC)
            )
        else:
            mask = (
                (rg_df["pct_nz_group"]     >= MIN_IN_GROUP_FRAC)  &
                (rg_df["pct_nz_reference"] <= MAX_OUT_GROUP_FRAC) &
                (rg_df["logfoldchanges"] >= MIN_LOG_FC)
            )
        print("✂︎ Filtr = in/out fractions + logFC (abs)" if COMPARE_ABS else "✂︎ Filtr = in/out fractions + logFC")
    else:
        mask = rg_df["logfoldchanges"].abs() >= MIN_LOG_FC if COMPARE_ABS else rg_df["logfoldchanges"] >= MIN_LOG_FC
        print("⚠︎ Kolumn pct_* brak – filtruję tylko na logFC")

    flt = rg_df.loc[mask].copy()
    print(f"   zachowano {flt.shape[0]:,} wierszy "
          f"({100*flt.shape[0]/rg_df.shape[0]:.1f} %)")

    OUT_DIR.mkdir(exist_ok=True)
    flt.to_csv(OUT_DIR / "all_filtered_markers.csv", index=False)

    for g in groups:
        dfg = flt[flt["group"] == g]
        dfg.to_csv(OUT_DIR / f"markers_cluster_{g}.csv", index=False)


if __name__ == "__main__":
    main()
