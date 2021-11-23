
# Set up some customizable configs per map

p0_targets <- list(
  
  ##### PROJECTION STRINGS #####
  # Add more projection strings to the yml or change which to reference
  tar_target(p0_proj_strings_yml, "0_config/in/proj_strings.yml", format = "file"),
  tar_target(p0_proj_str, yaml.load_file(p0_proj_strings_yml)[["albers"]]),
  
  ##### HUC 8 codes #####
  # Edit the huc8_codes.yml file to change which HUC8s to use and
  # how they are grouped.
  tar_target(p0_huc8s_yml, "0_config/in/huc8_codes.yml", format = "file"),
  tar_target(p0_huc8_list, yaml.load_file(p0_huc8s_yml)),
  tar_target(p0_huc8_grps, names(p0_huc8_list)),
  
  ##### HUC 4 codes #####
  # Specific to the mapping we need in the IWS basin viz
  tar_target(p0_huc4_mapping_csv, "0_config/in/basin_mapping.csv", format = "file"),
  tar_target(p0_huc4_mapping, read_csv(p0_huc4_mapping_csv) %>% 
               select(iws_basin_id = basin_id,
                      huc4 = huc04))
  
  ##### List of ON/OFF #####
  # tar_target(p0_include_states, TRUE),
  # tar_target(p0_include_huc8s, TRUE),
  # tar_target(p0_include_rivers, TRUE),
)
