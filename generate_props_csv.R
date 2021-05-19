generate_props_csv <- function(vclist, ROLL, bi){
  # Only VOI and VOC will show lineage names, other lineages will show as "Other"
  show_variant_name <- vclist %>% filter(label == "VOI" | label == "VOC") 
  show_variant_name <- show_variant_name$pango_lineage
  
  x <- bi %>% 
    mutate(pango_lineage_types = ifelse(pango_lineage %in% show_variant_name, pango_lineage, "Other")) %>%
    mutate(week = as.Date(cut(date, breaks = "2 weeks")), .after = date ) %>%
    mutate(week = factor(week)) %>%
    mutate(pango_lineage_types = factor(pango_lineage_types)) %>%
    group_by(week, pango_lineage_types) %>%
    count() 
  
  weeks <- levels(x$week)
  lineages <- levels(x$pango_lineage_types)
  
  X <- sparseMatrix(
    i = as.numeric(x$week), 
    j = as.numeric(x$pango_lineage_types),
    x = x$n,
    dims = c(length(weeks), length(lineages)),
    dimnames = list(weeks, lineages)
  )
  
  X <- apply(X + 1e-3, 2, rollmean, ROLL) %>% as('dgCMatrix')
  X <- Diagonal(x = 1 / rowSums(X)) %*% X
  
  variant_label <- vclist %>% filter(label == "VOI" | label == "VOC") 
  variant_label <- variant_label %>% rename(lineage = pango_lineage)
  
  x2 <- summary(X) %>%
    as.data.frame() %>%
    `colnames<-`(c('week', 'lineage', 'n')) %>%
    mutate(week = rownames(X)[week], lineage = factor(colnames(X)[lineage], colnames(X))) %>%
    mutate(proportion = n*100) %>%
    mutate(Proportion = round(proportion, 2)) %>%
    left_join(variant_label, by = "lineage") %>%
    rename(type = label) %>%
    replace_na(list(type = "Other")) %>%
    unite(lineage_type, c("type","lineage")) %>%
    mutate(lineage_type = replace(lineage_type, lineage_type == "Other_Other", "Other")) %>%
    select(week, lineage_type, proportion, Proportion)
  
  write.csv(x2, file = paste0("lineage_prevalence_by_2week_",Sys.Date(),".csv"), row.names = FALSE)
  return(x2)
}
