# COVID_visuals

### Please follow the steps in the R notebook [here](https://github.com/YYW-UMN/COVID_visuals/blob/main/lineage_prevalence.Rmd) to obtain the csv file for PowerBi visuals.
### Input files are:
* List of VOC/VOI like this
* Data tables from the flu server

### Functions:
**step 1**: join_dedup_meta_nextstrain.R       
**step 2**: reformat_meta_to_powerBI.R                
**step 3**: generate_props_csv.R                           

### Output files are:
* The **csv file** has the following columns:                   
![](https://github.com/YYW-UMN/COVID_visuals/blob/main/csv_preview_updated.PNG)

* The interactive **plotly** figure in [html format:](https://github.com/YYW-UMN/COVID_visuals/blob/main/Interactive_stacked_barplot_of_variant_proportion_2021-05-19.html)
![Static view](https://github.com/YYW-UMN/COVID_visuals/blob/main/plotly_variant_proportions.jpg)

* Import csv in **PowerBI** to generate the 100% stacked bar chart
![](https://github.com/YYW-UMN/COVID_visuals/blob/main/powerBI_variant_proportions_updated.jpg)
