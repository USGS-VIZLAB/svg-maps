library(targets)

tar_option_set(packages = c(
  "aws.s3",
  "aws.signature",
  "dssecrets",
  "maps",
  "nhdplusTools",
  "rmapshaper",
  "sf",
  "tidyverse",
  "xml2"
))

source("1_fetch.R")
source("2_process.R")
source("3_build.R")
source("4_disseminate.R")

c(p1_targets, p2_targets, p3_targets, p4_targets)
