# Steps for converting spatial features (sf) objects into SVG land

source("2_process/src/sf_to_coords.R")
source("2_process/src/coords_to_svg_path.R")

p2_targets <- list(
  
  tar_target(svg_width, 1000),
  
  tar_target(
    p2_conus_states_names,
    p1_conus_states_sf %>% 
      st_drop_geometry() %>% 
      pull(ID)
  ),
  
  tar_target(
    p2_conus_states_coords,
    p1_conus_states_sf %>% 
      filter(ID %in% p2_conus_states_names) %>% 
      sf_to_coords(svg_width),
    pattern = map(p2_conus_states_names)
  ),
  
  tar_target(
    p2_conus_states_paths,
    coords_to_svg_path(p2_conus_states_coords, close_path = TRUE),
    pattern = map(p2_conus_states_coords)
  )
)
