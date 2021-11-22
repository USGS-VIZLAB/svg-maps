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
    g_conus_state_svg,
    add_grp(out_svg = "3_build/tmp/g_conus_state.svg", 
            in_svg = root_svg, 
            grp_nm = 'conus-states', trans_x = 0, trans_y = 0),
    format = "file"
  ),
  
  tar_target(
    state_paths_svg, 
    add_child_paths(out_svg = "3_build/tmp/state_paths.svg",
                    in_svg = g_conus_state_svg,
                    paths = p2_conus_states_paths,
                    path_nms = sprintf('state-%s', p2_conus_states_names)),
    format = "file"
  ),
  
  # Add in HUCs
  tar_target(
    g_huc8s_svg,
    add_grp(out_svg = "3_build/tmp/g_huc8s.svg", 
            in_svg = state_paths_svg, 
            grp_nm = 'huc8s', trans_x = 0, trans_y = 0),
    format = "file"
  ),
  
  tar_target(
    huc8s_paths_svg, 
    add_child_paths(out_svg = "3_build/tmp/huc8s_paths.svg",
                    in_svg = g_huc8s_svg,
                    paths = p2_huc8s_paths,
                    path_nms = rep('huc8s', length(p2_huc8s_paths))),
    format = "file"
  ),
  
  tar_target(
    map_svg,
    build_final_svg("3_build/out/map.svg", huc8s_paths_svg),
    format = "file"
  )
  
)