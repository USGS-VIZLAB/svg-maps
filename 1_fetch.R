# Get spatial data into sf objects

source("1_fetch/src/maps_to_sf.R")

p1_targets <- list(
  
  # Albers Equal Area
  tar_target(p1_proj_str, "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs"),
  
  tar_target(
    p1_conus_sf,
    generate_conus_sf(p1_proj_str)
  ),
  
  tar_target(
    p1_conus_states_sf,
    generate_conus_states_sf(p1_proj_str)
  ),
  
  # Get basins
  # TODO: add more than the one IWS basin and propogate these
  # labels through to the SVG additions.
  tar_target(
    p1_huc8s, c("07120001", "07120002", "07120003")
  ),
  tar_target(
    p1_huc8s_sf,
    get_huc8(id = p1_huc8s) %>% 
      st_buffer(0) %>% 
      st_union() %>%
      st_make_valid() %>% 
      st_transform(p1_proj_str)
  )
)
