# Push up the SVG to S3

source("4_disseminate/src/s3_upload.R")

p4_targets <- list(
  tar_target(
    upload_svg_log,
    s3_upload(filepath_s3 = "visualizations/maps/map.svg",
              filepath_local = map_svg)
  )
)
