
# Set up some customizable configs per map

p0_targets <- list(
  
  tar_target(p0_proj_strings_yml, "0_config/in/proj_strings.yml", format = "file"),
  tar_target(p0_proj_str, yaml.load_file(p0_proj_strings_yml)[["albers"]])
  
)
