# Each of the steps has to read and write a file or you will get an
# error about an invalid external pointer (this is because of how xml2
# edits the global var, see more at https://github.com/tidyverse/rvest/issues/181)

init_svg <- function(out_svg, viewbox_dims) {
  # Create the main "parent" svg node. This is the top-level part of the svg
  xml_new_root('svg', 
               viewBox = paste(viewbox_dims, collapse=" "), 
               preserveAspectRatio="xMidYMid meet", 
               version="1.1") %>% 
    write_xml(out_svg)
  return(out_svg)
}

add_grp <- function(out_svg, in_svg, grp_nm, trans_x, trans_y) {
  
  read_xml(in_svg) %>% 
    xml_add_child('g', id = grp_nm, 
                  transform = sprintf("translate(%s %s) scale(0.35, 0.35)", trans_x, trans_y)) %>% 
    write_xml(out_svg)
  
  return(out_svg)
}

add_child_paths <- function(out_svg, in_svg, paths) {
  svg_state <- read_xml(in_svg)
  for(path_i in paths) {
    xml_add_child(svg_state, 'path', d = path_i, 
                  class='conus-state', 
                  style="stroke:#9fabb7;stroke-width:0.5;fill:none")
  }
  write_xml(svg_state, out_svg)
  return(out_svg)
}

build_final_svg <- function(out_svg, in_svg) {
  read_xml(in_svg) %>% write_xml(file = out_svg)
  return(out_svg)
}
