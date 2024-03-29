# Get spatial data into sf objects

source("1_fetch/src/maps_to_sf.R")
source("1_fetch/src/nhd_to_sf.R")

p1_targets <- list(
  
  tar_target(
    p1_conus_sf,
    generate_conus_sf(p0_proj_str)
  ),
  
  tar_target(
    p1_conus_states_sf,
    generate_conus_states_sf(p0_proj_str)
  ),
  
  # Get basins
  tar_target(
    p1_huc8s_sf,
    # do_union = TRUE will merge them based on each list 
    # element in `p0_huc8_list`
    download_huc8_sf(huc8s = p0_huc8_list[[1]], 
                     proj_str = p0_proj_str, 
                     do_union = TRUE),
    pattern = map(p0_huc8_list),
    # Leave the sf objects as separate list items so that they
    # can easily be branched over and converted to SVG.
    iteration = "list" 
  ),
  
  # Save basins as sf for sharing out
  tar_target(
    p1_huc8s_sf_Rdata,
    {
      basins_sf <- p1_huc8s_sf %>% setNames(names(p0_huc8_list))
      save(basins_sf , 
           file = "1_fetch/out/IWS_basins_sf.Rdata")
    }
  ),
  
  # Get rivers by basin. Limit stream order
  # to big streams only for now. 
  tar_target(
    p1_rivers_sf,
    download_rivers_sf(aoi_sf = p1_huc8s_sf, 
                       proj_str = p0_proj_str, 
                       streamorder = 6),
    pattern = map(p1_huc8s_sf),
    iteration = "list"
  )
  
)
