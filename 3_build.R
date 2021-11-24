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
      grp_id = "conus_states",
      paths = p2_conus_states_paths,
      path_ids = p2_conus_states_names,
      path_class = rep("state", length(p2_conus_states_paths))),
    format = "file"
  ),
  
  # Add in HUCs
  tar_target(
    huc8s_paths_svg,
    add_poly_group_to_svg(
      out_svg = "3_build/tmp/huc8s_paths.svg",
      in_svg = state_paths_svg,
      grp_id = 'hucs',
      paths = p2_huc8s_paths,
      path_ids = p0_huc8_grps,
      path_class = rep("huc8", length(p2_huc8s_paths))),
    format = "file"
  ),
  
  # Add in rivers
  tar_target(
    river_paths_svg,
    add_poly_group_to_svg(
      out_svg = "3_build/tmp/river_paths.svg",
      in_svg = huc8s_paths_svg,
      grp_id = 'rivers',
      paths = p2_river_paths,
      path_ids = needs_a_solution$comid,
      path_class = sprintf("%s order_%s", 
                           rep("river", length(p2_river_paths)),
                           needs_a_solution$streamorde)),
    format = "file"
  ),
  
  tar_target(
    map_svg,
    build_final_svg("3_build/out/map.svg", river_paths_svg),
    format = "file"
  )
  
)