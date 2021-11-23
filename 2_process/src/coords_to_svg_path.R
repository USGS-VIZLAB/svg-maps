coords_to_svg_path <- function(xy_df, close_path = FALSE) {
  
  x <- xy_df$x
  y <- xy_df$y
  
  # Build path
  first_pt_x <- head(x, 1)
  first_pt_y <- head(y, 1)
  
  all_other_pts_x <- tail(x, -1)
  all_other_pts_y <- tail(y, -1)
  path_ending <- ""
  if(close_path) {
    # Connect path to start to make polygon
    all_other_pts_x <- c(all_other_pts_x, first_pt_x)
    all_other_pts_y <- c(all_other_pts_y, first_pt_y)
    path_ending <- " Z"
  }
  
  d <- sprintf("M%s %s %s%s", first_pt_x, first_pt_y,
               paste0("L", all_other_pts_x, " ", 
                      all_other_pts_y, collapse = " "),
               path_ending)
  return(d)
}
