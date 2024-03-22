library(tidyverse)
#library(readxl)
library(janitor)

## geochemistry data
geo_data <- read_csv("../Data/Raw data/Geochemistry analysis - Copy 2.csv") %>%
  filter(sample_design == "Grid") %>%
  select(-...1, -sample_design) %>%
  pivot_longer(cols = Ag:Zr, names_to = "element", values_to = "value") %>%
  filter(element %in% c("Ag", "Al", "As","B","Ba","Be","Bi","Ca","Cd","Ce","Co", "Cr", "Cs", "Cu", "Fe", "Ga", "Hf", "Hg", "In", "K", "La", "Li", "Mg", "Mn", "Mo", "Nb", "Ni", "P", "Pb", "Rb", "S", "Sb", "Sc", "Se", "Sn", "Sr", "Te", "Th", "Tl", "U", "V", "Y", "Zn", "Zr")) %>%
  mutate(group = "geochem")

## colour data
colour_data <- read_csv("../Data/Raw data/final results revised.csv") %>%
  filter(sample_design == "Grid") %>%
  select(-...1, -sample_design) %>%
  pivot_longer(cols = X:B, names_to = "element", values_to = "value") %>%
  mutate(group = "colour",
         element = paste(element, "col", sep = "_")) # Differentiate between Boron (B) and Blue (B)

## organic matter data         
org_data <- read_csv("../Data/Raw data/OM_data.csv") %>%
  clean_names() %>%
  filter(sampling_design == "Grid") %>%
  select(sample_number, site, om) %>%
  mutate(element = "organic",
         site = fct_recode(site, "Agriculture" = "Agricultural")) %>%
  rename("value" = "om") %>%
  mutate(group = "organic")

## grain size data
psa_data <- read_csv("../Data/Raw data/PSA_data.csv") %>%
  clean_names() %>%
  filter(sampling_design == "Grid") %>%
  select(sample_number, site, dx_50, specific_surface_area) %>%
  rename("ssa" = specific_surface_area) %>%
  pivot_longer(cols = c(dx_50, ssa), names_to = "element", values_to = "value") %>%
  mutate(group = "psa")
  
all_data <- geo_data %>%
  bind_rows(colour_data, org_data, psa_data)

# write_csv(x = all_data, file = "./notebooks/soil_data.csv")

## Terrain data

attribute <- c("plan_curvature", "profile_curvature", "saga_wetness_index", "catchment_area", "relative_slope_position", "vertical_distance_channel_network", "vertical_distance_to_channel_network")

ag_data <- read_csv("../Data/Raw data/Terrain/terrain_geochem_particle_colour_ag.csv") %>%
  clean_names() %>%
  select("x", "y", 
         "elevation" = "maria_dtm_uav_ag_cl_no_sinks", 
         "ca" = "geochem_a_f_kriging_ca",
         "mo" = "geochem_m_r_kriging_mo",
         "u" = "geochem_s_z_kriging_u",
         "a_col" = "kriging_col_a",
         "h_col" = "kriging_col_h",
         "c_col" = "kriging_col_c", 
         "organic" = "particle_om_kriging_om",
         "ssa" = "particle_om_kriging_ps_specific_s",
         any_of(attribute))

# write_csv(x = ag_data, file = "./notebooks/ag_terrain_data.csv")

forest_data <- read_csv("../Data/Raw data/Terrain/terrain_geochem_particle_colour_forest.csv") %>%
  clean_names() %>%
  select("x", "y",
         "elevation" = "dem_forest_map_prj_no_sinks", 
         "li" = "geochem_g_l_kriging_li",
         "nb" = "geochem_m_r_kriging_nb",
         "zn" = "geochem_s_z_kriging_zn",
         "v_col" = "kriging_col_v",
         "l_col" = "kriging_col_l",
         "h_col" = "kriging_col_h", 
         "organic" = "particle_om_kriging_om",
         "ssa" = "particle_om_kriging_ps_specific_s",
         any_of(attribute)) %>%
  rename("vertical_distance_channel_network" = "vertical_distance_to_channel_network")

# write_csv(x = forest_data, file = "./notebooks/forest_terrain_data.csv")

## Sample coordinates

coords <- read_csv("../Data/Raw data/Sampling coordinates.csv") %>%
  clean_names() %>%
  filter(sampling_design == "Grid") %>%
  select(site, long, lat)

# write_csv(x = coords, file = "./notebooks/coords.csv")