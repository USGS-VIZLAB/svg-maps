library(targets)

tar_option_set(packages = c(
  "aws.s3",
  "aws.signature",
  "maps",
  "nhdplusTools",
  "rmapshaper",
  "sf",
  "tidyverse",
  "xml2",
  "yaml"
))

source("0_config.R")
source("1_fetch.R")
source("2_process.R")
source("3_build.R")
source("4_disseminate.R")

c(
  p0_targets, 
  p1_targets, 
  p2_targets, 
  p3_targets, 
  p4_targets
)
