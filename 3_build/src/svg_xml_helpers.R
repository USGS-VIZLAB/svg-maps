# Each of the steps has to read and write a file or you will get an
# error about an invalid external pointer (this is because of how xml2
# edits the global var, see more at https://github.com/tidyverse/rvest/issues/181)

init_svg <- function(out_svg, viewbox_dims) {
  # Create the main "parent" svg node. This is the top-level part of the svg
  svg_root <- xml_new_root('svg', 
               viewBox = paste(viewbox_dims, collapse=" "), 
               preserveAspectRatio="xMidYMid meet",
               xmlns="http://www.w3.org/2000/svg", 
               `xmlns:xlink`="http://www.w3.org/1999/xlink") 
  write_xml(svg_root, out_svg)
  return(out_svg)
}

add_poly_group_to_svg <- function(out_svg, in_svg, grp_nm, paths, path_nms) {
  current_svg <- read_xml(in_svg)
  
  current_svg %>% 
    add_grp(grp_nm) %>% 
    add_poly_paths(paths, path_nms)
  
  write_xml(current_svg, out_svg)
  return(out_svg)
}

add_grp <- function(current_svg, grp_nm, 
                    trans_x = 0, trans_y = 0,
                    scale_x = 1, scale_y = 1) {
  current_svg %>% 
    xml_add_child('g', id = grp_nm, 
                  transform = sprintf(
                    "translate(%s %s) scale(%s, %s)", 
                    trans_x, trans_y, scale_x, scale_y))
  return(current_svg)
}

add_poly_paths <- function(current_svg, paths, path_nms) {
  for(i in 1:length(paths)) {
    xml_add_child(current_svg, 'path', 
                  d = paths, 
                  class = path_nms, 
                  style = "stroke:#9fabb7;stroke-width:0.5;fill:none")
  }
  return(current_svg)
}

build_final_svg <- function(out_svg, in_svg) {
  read_xml(in_svg) %>% write_xml(file = out_svg)
  return(out_svg)
}
