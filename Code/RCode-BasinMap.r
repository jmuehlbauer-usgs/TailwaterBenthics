##### Create map of Colorado River Basin tailwaters #####
	## Created 16 October 2019 by J.D. Muehlbauer
	
	
##### Set up workspace #####

## Load/install requisite packages
source('https://github.com/jmuehlbauer-usgs/R-packages/blob/master/packload.r?raw=TRUE')
packload(c('rgdal', 'maps', 'rgeos', 'plots'))

## Set working directory
setwd('C:/Users/jmuehlbauer/Documents/Projects/Drift/Longitudinal/Upper_Lower_Basin/Benthics-ErinAbernethy')


## Get map data
basin <- readOGR(dsn = 'Data/GIS', layer = 'CRBasin_PacificInstitute')
riversall <- readOGR(dsn = 'Data/GIS', layer = 'rs16my07')
dams <- read.csv('Data/DamLatLong.csv')

##### Prep map data for plotting #####

## Clip river shapefile to just rivers in CR Basin
rivers <- gIntersection(basin, riversall, byid=TRUE)

## Define states to plot (for inset map)
states <- c('California', 'Oregon', 'Washington', 'Idaho', 'Montana', 'Colorado', 'Wyoming', 
	'Nevada', 'Utah', 'Arizona', 'New Mexico')
	

##### Plot map #####

## Create plotting function
mapfx <- function(){

## Set dam name plotting adjusments
adjx <- c(-1.8, -1.15, -0.5, 0.25, 0.12, 0.25, 0.1)
adjy <- c(0.1, -0.34, -0.3, -0.25, -0.25, 0, -0.3)
damnames <- c('Fontenelle', 'Flaming\nGorge', 'Navajo', 'Glen\nCanyon', 'Hoover', 'Davis', 'Parker')
## Set overall map parameters
par(mar = c(0, 0, 0, 0), fig = c(0, 1, 0, 1), xpd = NA)
map(basin, lwd = 3, xlim = c(-116.2, -106.2), ylim = c(31.5, 43))
map(basin, add = TRUE, fill = TRUE, lty = 1, border = 'white', col = 'white')
plot(rivers, add = TRUE, col = 4)
points(dams$Longitude, dams$Latitude, pch = 17, cex = 2)
text(dams$Longitude + adjx, dams$Latitude + adjy, damnames, cex = 1.2, adj = 0)
map.scale(-108.5, 31.3, ratio = FALSE, cex = 1.2)

## Plot inset map with states
par(fig = c(0.15, 0.3, 0.75, 0.9), new = TRUE)
map('state', region = states, add = TRUE, lwd = 0, interior = FALSE)
map(basin, add = TRUE, fill = TRUE, border = 'lightgray', col = 'lightgray')
map('state', region = states, add = TRUE)

## Save plot
}
suppressWarnings(plotTypes(mapfx, 'BasinMap', 'Figures', c('pdf', 'png')))