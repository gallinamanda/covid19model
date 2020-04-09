### pulling average monthly climate data for European countries
# temperature (min, median, max)
# humidity
# UV radiation

library(raster)
library(sp)

countries <- c(
  "Denmark",
  "Italy",
  "Germany",
  "Spain",
  "United_Kingdom",
  "France",
  "Norway",
  "Belgium",
  "Austria", 
  "Sweden",
  "Switzerland"
)
countries <- sort(countries)

# WorldClim only provides mean temperature, not median
clim_variables <- c(
  "t_min",
  "t_mean",
  "t_max",
  "humidity",
  "UV"
)

country_codes_all <- getData('ISO3')
countries_codes <- country_codes_all[which(country_codes_all$NAME %in% gsub("_"," ",countries)),]

#fra <- getData("GADM", country="FRA", level=0)
country_polies <- sapply(countries_codes$ISO3, function(x) getData("GADM", country = x, level=0))

tmean <- getData("worldclim",var="tmean",res=10)
tmin <- getData("worldclim",var="tmin",res=10)
tmax <- getData("worldclim",var="tmax",res=10)

#fra_tmean <- extract(tmean, fra, fun=mean)
#swe_tmean <- extract(tmean, getData("GADM", country="SWE", level=0), fun=mean, na.rm=TRUE)
country_tmean <- lapply(country_polies, function(x) extract(tmean, x, fun=mean, na.rm=TRUE))
country_tmin <- lapply(country_polies, function(x) extract(tmin, x, fun=mean, na.rm=TRUE))
country_tmax <- lapply(country_polies, function(x) extract(tmax, x, fun=mean, na.rm=TRUE))

climate_array <- array(NA, dim = c(length(countries),length(clim_variables),12),
                       dimnames = list(countries, clim_variables, month.name))

climate_array[,"t_mean",] <- matrix(unlist(country_tmean), nrow=length(countries), ncol=12, byrow=TRUE)
climate_array[,"t_min",] <- matrix(unlist(country_tmin), nrow=length(countries), ncol=12, byrow=TRUE)
climate_array[,"t_max",] <- matrix(unlist(country_tmax), nrow=length(countries), ncol=12, byrow=TRUE)

saveRDS(climate_array, "data/climate_array.RDS")














