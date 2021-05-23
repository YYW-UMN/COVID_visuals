join_dedup_meta <- function(save_rds = TRUE){
  
  dedup_primary <- tbl(impala, 'deduplication_primary_auto') %>% as.data.frame()
  analytics_metadata <- tbl(impala, 'analytics_metadata') %>% as.data.frame()
  
  cat("======Two tables imported as data.frame======")
  
  if (save_rds == TRUE) {
    saveRDS(dedup_primary, paste0("dedup_primary_", Sys.Date(),".rds"))
    saveRDS(analytics_metadata, paste0("analytics_metadata_", Sys.Date(),".rds"))
    
    cat("======Two tables saved as RDS files======")
    
  }else{
    
  }
  
  meta <- analytics_metadata %>% 
    inner_join(dedup_primary, by = "primary_virus_name") 
  
  cat("======Final table produced======")
  
  return(meta)
}
