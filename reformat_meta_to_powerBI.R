reformat_meta_to_powerBI <- function(meta, vclist){
  reformat_meta <- meta %>% 
    mutate(host = primary_host.x) %>%
    filter(host == "Human") %>%
    rename(strain = primary_virus_name) %>%
    rename(nt_id = primary_nt_id.x) %>%
    mutate(gisaid_epi_isl = covv_accession_id) %>% 
    mutate(genbank_accession = accession) %>%
    mutate(date = as.Date(primary_collection_date.x)) %>%
    mutate(country = country_iso_name.x) %>%
    mutate(division = primary_state.x) %>%
    mutate(location = zip) %>%
    mutate(length = primary_sequence_length) %>%
    mutate(pango_lineage = lineage) %>%
    mutate(mutations = spike_mutations) %>%
    select(strain, 
           nt_id,
           gisaid_epi_isl, 
           genbank_accession,
           date,
           country,
           division,
           location,
           length,
           pango_lineage,
           mutations)
  reformat_meta <- reformat_meta %>% 
    mutate(country_code = if_else(
      country == "Kosovo","XKX", 
      if_else(country == "Eswatini", "SWZ", 
              countrycode(sourcevar = country, origin = "country.name", destination = "iso3c"))))
  
  # Get the WHO countries
  gitdata.dir <- "https://raw.githubusercontent.com/CDCgov/ITF_Power_BI/master/itf_dashboard/output/"
  who_countries <- read.csv(paste0(gitdata.dir,"country_data.csv"), encoding="UTF-8") %>%
    rename(country_code = iso3code) %>%
    select(country, country_code) 
  
  new_meta <-  reformat_meta %>% 
    inner_join(who_countries, by = c("country_code")) %>% # add the iso 3 letter code
    filter(!duplicated(strain)) %>%
    rename(country = country.x) %>%
    select(-c(country.y, nt_id, length)) %>%
    rows_update(tibble(strain = "SARS-CoV-2/Human/USA/AK-CDC-2-4242656/1988", date = "2021-04-01")) # fix the typo of 1988

  variant_label <- vclist %>% filter(label == "VOI" | label == "VOC") 
  
  new_meta <- new_meta %>%
    mutate(date = replace(date, date == "2051-04-05","2021-04-05")) %>%
    filter(pango_lineage != "NA" & pango_lineage != "none") %>%
    left_join(variant_label, by = "pango_lineage") %>%
    rename(type = label) %>% # rename label to type
    replace_na(list(type = "Other"))  # replace NA in type with "Other" for the figure
  
  return(new_meta)
}

