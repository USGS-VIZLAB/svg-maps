# Converting sf polygons into SVG coordinates
# This function will work if `sf_obj` is an individual polygon
sf_to_coords <- function(sf_obj, svg_width, view_bbox = NULL) {

  coords <- st_coordinates(sf_obj)
  x_dec <- coords[,1]
  y_dec <- coords[,2]

  # Using the whole view, figure out coordinates
  # If view_bbox isn't provided, assume sf_obj is the whole view
  if(is.null(view_bbox)) view_bbox <- st_bbox(sf_obj)

  x_extent <- c(view_bbox$xmin, view_bbox$xmax)
  y_extent <- c(view_bbox$ymin, view_bbox$ymax)

  # Calculate aspect ratio
  aspect_ratio <- diff(x_extent)/diff(y_extent)

  # Figure out what the svg_height is based on svg_width, maintaining the aspect ratio
  svg_height <- svg_width / aspect_ratio

  # Convert longitude and latitude to SVG horizontal and vertical positions
  # Remember that SVG vertical position has 0 on top
  x_extent_pixels <- x_extent - view_bbox$xmin
  y_extent_pixels <- y_extent - view_bbox$ymin
  x_pixels <- x_dec - view_bbox$xmin # Make it so that the minimum longitude = 0 pixels
  y_pixels <- y_dec - view_bbox$ymin # Make it so that the maximum latitude = 0

  data.frame(
    x = round(approx(x_extent_pixels, c(0, svg_width), x_pixels)$y, 3),
    y = round(approx(y_extent_pixels, c(svg_height, 0), y_pixels)$y, 3)
  )
}

#' @title apply sf_to_coords() for each entity (or group) within an sf object
#' @description This function is useful when applying the sf_to_coords() function
#' to each reach (or some other really small entity within a larger sf
#' object). In those instances, branching is not really needed because
#' the purrr::map() function runs really fast, but we need to treat them
#' separately when building the SVG paths so that they are not connected.
#' @param sf_obj sf object to extract coordinates from
#' @param id_col column from `sf_obj` used to group the output coordinates.
#' Values in this column will become the names of the list elements in the output.
#' @param svg_width width of the desired SVG
#' @param view_bbox bounding box of full view in which to convert the sf
#' object coordinates to SVG coordinates. Will use this view_bbox coordinates
#' as the edge of the SVG and fit the sf_obj appropriately.
sf_to_coords_by_id <- function(sf_obj, id_col, svg_width, view_bbox = NULL) {
  sf_obj %>%
    split(sf_obj[[id_col]]) %>%
    purrr::map(~sf_to_coords(., svg_width, view_bbox))
}
