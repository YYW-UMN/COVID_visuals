join_dedup_meta_nextstrain <- function(save_rds = TRUE){
  
  dedup_primary <- tbl(impala, 'deduplication_primary_auto') %>% as.data.frame()
  analytics_metadata <- tbl(impala, 'analytics_metadata') %>% as.data.frame()
 # nextclade <- tbl(impala, 'nextclade') %>% as.data.frame() %>% select(nt_id, clade) # not using the nextclade table
  
  cat("======Two tables imported as data.frame======")
  
  if (save_rds == TRUE) {
    saveRDS(dedup_primary, paste0("dedup_primary_", Sys.Date(),".rds"))
    saveRDS(analytics_metadata, paste0("analytics_metadata_", Sys.Date(),".rds"))
    
    cat("======Two tables saved as RDS files======")
    
  }else{
    
  }
  
  meta <- analytics_metadata %>% 
    inner_join(dedup_primary, by = "primary_virus_name") 
  
 # meta <- meta %>% 
 #   left_join(nextclade, by = c("primary_nt_id.x" = "nt_id"))
  
  cat("======Final table produced======")
  
  return(meta)
}
