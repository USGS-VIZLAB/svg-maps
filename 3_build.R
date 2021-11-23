# Build an SVG using XML components

source("3_build/src/svg_xml_helpers.R")

p3_targets <- list(
  
  tar_target(
    root_svg,
    init_svg("3_build/tmp/root.svg", 
             viewbox_dims = c(0, 0, svg_width=svg_width, svg_height=700)),
    format = "file"
  ),
  
  # Add states
  # TODO: groups don't seem to actually be working
  tar_target(
    state_paths_svg, 
    add_poly_group_to_svg(
      out_svg = "3_build/tmp/state_paths.svg",
      in_svg = root_svg,
      grp_nm = 'conus-states',
      paths = p2_conus_states_paths,
      path_nms = sprintf('state-%s', p2_conus_states_names)),
    format = "file"
  ),
  
  # Add in HUCs
  tar_target(
    huc8s_paths_svg, 
    add_poly_group_to_svg(
      out_svg = "3_build/tmp/huc8s_paths.svg",
      in_svg = state_paths_svg,
      grp_nm = 'huc8s',
      paths = p2_huc8s_paths,
      path_nms = sprintf("basin-%s", p0_huc8_grps)),
    format = "file"
  ),
  
  tar_target(
    map_svg,
    build_final_svg("3_build/out/map.svg", huc8s_paths_svg),
    format = "file"
  )
  
)