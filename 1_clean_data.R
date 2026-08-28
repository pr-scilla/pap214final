library(tidyverse)
source("R/moving-average.R") # source moving_average() function for analysis

# Read data --------------------------------------------------------------

BQ1 <- read_csv("data/QuebradaCuenca1-Bisley.csv")
BQ2 <- read_csv("data/QuebradaCuenca2-Bisley.csv")
BQ3 <- read_csv("data/QuebradaCuenca3-Bisley.csv")
PRM <- read_csv("data/RioMameyesPuenteRoto.csv")
LTER <- read_csv("data/LUQ_LTER_MDLs.csv") # contains units for water chemistry measurements.

# Keep only relevant data columns for each site --------------------------

BQ1_Truncated <- BQ1 |>
  select(Sample_ID, Sample_Date, `NH4-N`, Ca, Mg, `NO3-N`, K) |>
  mutate(Sample_ID = "BQ1")

BQ2_Truncated <- BQ2 |>
  select(Sample_ID, Sample_Date, `NH4-N`, Ca, Mg, `NO3-N`, K) |>
  mutate(Sample_ID = "BQ2")

BQ3_Truncated <- BQ3 |>
  select(Sample_ID, Sample_Date, `NH4-N`, Ca, Mg, `NO3-N`, K) |>
  mutate(Sample_ID = "BQ3")

PRM_Truncated <- PRM |>
  select(Sample_ID, Sample_Date, `NH4-N`, Ca, Mg, `NO3-N`, K) |>
  mutate(Sample_ID = "PRM")

# Calculate moving averages for each site --------------------------------

BQ1_moving_averages <- moving_average(BQ1_Truncated)
BQ2_moving_averages <- moving_average(BQ2_Truncated)
BQ3_moving_averages <- moving_average(BQ3_Truncated)
PRM_moving_averages <- moving_average(PRM_Truncated)

# Join data for all sites into one data frame ----------------------------

# rbind () was suggested by Sophia Solano for combining sites into one data frame.
sites_joined_clean <- rbind(
  BQ1_moving_averages,
  BQ2_moving_averages,
  BQ3_moving_averages,
  PRM_moving_averages
)

# Create data frame for figure 3 reproduction data ----------------------

Figure_3_Reproduction_Data <- sites_joined_clean |>
  pivot_longer(
    cols = c(NH4N_ugL, Ca_mgL, Mg_mgL, NO3N_ugL, K_mgL),
    names_to = "ion",
    values_to = "concentration"
  )

# Write .csv for Figure_3_Reproduction_Data data frame ------------------------

write_csv(Figure_3_Reproduction_Data, "output/figure-3-reproduction-data.csv")
