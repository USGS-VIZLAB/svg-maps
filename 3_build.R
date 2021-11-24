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
  
  tar_target(
    p3_huc4_classes,
    sprintf("huc%s", 
            if_else(p1_huc4s_simp_sf$huc4 %in% c("0204", "0712", "0713", "1401", "1402"), 
                    " iws", ""))
  ),
  tar_target(
    huc4s_paths_svg,
    add_poly_group_to_svg(
      out_svg = "3_build/tmp/huc4s_paths.svg",
      in_svg = state_paths_svg,
      grp_id = 'hucs',
      paths = p2_huc4s_paths,
      path_ids = p3_huc4_classes,
      path_class = "huc"),
  ),
  
  # Add in rivers
  tar_target(
    p3_river_classes,
    sprintf("%s order_%s iws_basin_%s", 
            rep("river", length(p2_river_paths)),
            needs_a_solution$streamorde,
            needs_a_solution$id_custom)
  ),
  tar_target(
    river_paths_svg,
    add_poly_group_to_svg(
      out_svg = "3_build/tmp/river_paths.svg",
      in_svg = huc8s_paths_svg,
      grp_id = 'rivers',
      paths = p2_river_paths,
      path_ids = sprintf("comid_%s", needs_a_solution$comid),
      path_class = p3_river_classes),
    format = "file"
  ),
  
  tar_target(
    map_svg,
    build_final_svg("3_build/out/map.svg", river_paths_svg),
    format = "file"
  )
  
)