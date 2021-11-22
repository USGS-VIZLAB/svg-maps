# Utils for using spatial data from `maps`
# to create state and county sf objects

generate_conus_sf <- function(proj_str) {
  
  usa_sf <- maps::map("usa", fill = TRUE, plot=FALSE) %>%
    st_as_sf() %>% 
    st_transform(proj_str) %>% 
    st_buffer(0) 
  
  return(usa_sf)
}

generate_conus_states_sf <- function(proj_str) {
  
  usa_sf <- maps::map("usa", fill = TRUE, plot=FALSE) %>%
    st_as_sf() %>% 
    st_transform(proj_str) %>% 
    st_buffer(0) 
  
  # Need to remove islands from state outlines and then add back in 
  # later so that they can be drawn as individual polygons. Otherwise,
  # drawn with the state since the original state maps data only has 1
  # ID per state.
  
  usa_islands_sf <- usa_sf %>% filter(ID != "main")
  usa_addl_islands_sf <- generate_addl_islands(proj_str)
  usa_mainland_sf <- usa_sf %>% 
    filter(ID == "main") %>% 
    st_erase(usa_addl_islands_sf) 
  
  # Have to manually add in CO because in `maps`, it is an incomplete
  # polygon and gets dropped somewhere along the way.
  co_sf <- maps::map("state", "colorado", fill = TRUE, plot=FALSE) %>%
    st_as_sf() %>%
    st_transform(proj_str)
  
  maps::map("state", fill = TRUE, plot=FALSE) %>%
    st_as_sf() %>%
    st_transform(proj_str) %>%
    st_buffer(0) %>% 
    # Get rid of islands from state outline data
    st_intersection(usa_mainland_sf) %>%
    select(-ID.1) %>% # st_intersection artifact that is unneeded
    # Add islands back in as separate polygons from states
    bind_rows(usa_islands_sf) %>%
    bind_rows(usa_addl_islands_sf) %>% 
    st_buffer(0) %>%
    st_cast("MULTIPOLYGON") %>% # Needed to bring back to correct type to use st_coordinates
    rmapshaper::ms_simplify(0.5) %>%
    bind_rows(co_sf) # bind CO after bc otherwise it gets dropped in st_buffer(0)
  
}

generate_addl_islands <- function(proj_str) {
  # These are not called out specifically as islands in the maps::map("usa") data
  # but cause lines to be drawn across the map if not treated separately. This creates those shapes.
  
  # Counties to be considered as separate polygons
  
  separate_polygons <- list(
    `upper penninsula` = list(
      state = "michigan",
      counties = c(
        "alger",
        "baraga",
        "chippewa",
        "delta",
        "dickinson",
        "gogebic",
        "houghton",
        "iron",
        "keweenaw",
        "luce",
        "mackinac",
        "marquette",
        "menominee",
        "ontonagon",
        "schoolcraft"
      )),
    `eastern shore` = list(
      state = "virginia",
      counties = c(
        "accomack",
        "northampton"
      )),
    # TODO: borders still slightly wonky bc it doesn't line up with counties perfectly. 
    `nags head` = list(
      state = "north carolina",
      counties = c(
        "currituck"
      )),
    # This + simplifying to 0.5 took care of the weird line across NY
    `staten island` = list(
      state = "new york",
      counties = c(
        "richmond"
      )))
  
  purrr::map(names(separate_polygons), function(nm) {
    maps::map("county", fill = TRUE, plot=FALSE) %>%
      sf::st_as_sf() %>%
      st_transform(proj_str) %>% 
      st_buffer(0) %>%
      filter(ID %in% sprintf("%s,%s", separate_polygons[[nm]][["state"]],
                             separate_polygons[[nm]][["counties"]])) %>% 
      mutate(ID = nm) 
  }) %>% 
    bind_rows() %>% 
    group_by(ID) %>% 
    summarize(geom = st_union(geom))
}

# List counties to use to query `maps()`
list_state_counties <- function(state_abbr) {
  tolower(gsub(" County", "", countyCd$COUNTY_NAME[which(countyCd$STUSAB == state_abbr)]))
}

# Function to remove a state
st_erase <- function(x, y) st_difference(x, st_union(st_combine(y)))
