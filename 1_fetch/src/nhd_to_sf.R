# Utils for getting NHD+ (National Hydrography Dataset)
# spatial info into sf objects

#' @title Download HUC8 sf objects from the NHD+ using nhdplusTools
#' @param huc8s character vector of HUC 8 codes
#' @param aoi_sf sf object representing the area of interest to get HUC 8s
#' @param proj_str character string representing the projection. No default.
#' @param do_union logical stating whether to merge all the HUC8s in this
#' single query into one polygon.
download_huc8_sf <- function(huc8s = NULL, aoi_sf = NULL, proj_str, do_union = FALSE) {
  
  if(is.null(huc8s) & is.null(aoi_sf)) {
    stop("You need to pass in either a vector of HUC 8 codes or an `sf` object")
  }
  
  if(!is.null(huc8s)) {
    huc8_polys <- get_huc8(id = huc8s)
  } else if(!is.null(aoi_sf)) {
    huc8_polys <- get_huc8(id = aoi_sf)
  }
  
  huc8_sf <- huc8_polys %>% 
    st_buffer(0) %>% {
      # Combine HUC8s into one polygon
      if(do_union) st_union(.)
    } %>% 
    st_make_valid() %>% 
    st_transform(proj_str)
  
  return(huc8_sf)
}

#' @title Download rivers sf objects from the NHD+ using nhdplusTools
#' @param aoi_sf sf object representing the area of interest to get rivers
#' @param proj_str character string representing the projection. No default.
#' @param streamorder numeric value indicating the size of stream to include
#' in the query. Smaller streamorder = smaller stream in this data.
download_rivers_sf <- function(aoi_sf, proj_str, streamorder = 3) {
  browser()
  rivers_raw <- get_nhdplus(AOI = aoi_sf, streamorder = streamorder)
  
  if(!c("sf") %in% class(rivers_raw)) {
    rivers_out <- NULL
  } else {
    rivers_out <- rivers_raw %>% 
      select(id, comid, streamorde, lengthkm) %>% 
      st_make_valid() %>% 
      st_transform(proj_str)
  }
  
  return(rivers_out)
}
