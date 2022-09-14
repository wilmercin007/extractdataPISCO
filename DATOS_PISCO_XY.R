#Scrip de descarga de datos grillados meteorológicos de SENAMHI - PISCOp

# Ruta de la carpeta que contiene los archivos
setwd("D:/TRABAJOS Y PROYECTOS/EVAR SEQUIA CURAHUASI/HIDROLOGIA")

#Limpiador de variables
rm(list=ls())

# Instalador de paquetes
install.packages("ncdf4")
install.packages("raster")
install.packages("rgdal")
install.packages("sp")

#Abrir paquetes
library(ncdf4)
library(raster)
library(rgdal)
library(sp)

#Coordenadas geográficas de los puntos de muestreo (Archivo Excel)
#Colocar XX -> longitud
#Colocar YY -> latitud
long_lat <- read.csv("SUBCUENCAS_XY.csv", sep = ";", header = T) #Ruta del archivo .csv (Excel)

#Cargar la data meteorológica (Ejm. Precipitación)
raster_pp <- raster::brick("data.nc")

#Asignar las coordenadas geográficas
sp::coordinates(long_lat) <- ~XX+YY

#Igualamos las proyecciones del raster a los puntos de muestreo
raster::projection(long_lat) <- raster::projection(raster_pp)

#Extraemos la data meteorológica
points_long_lat <- raster::extract(raster_pp[[1]],long_lat, cellnumbers=T)[,1]
data_long_lat <- t(raster_pp[points_long_lat])
colnames(data_long_lat) <- as.character(long_lat$NN)

#Guardamos la data como "data_long_lat.csv" (nombre editable)
#Las filas son la data meteorológica descargada de PISCOp, las columnas son los puntos de muestreo
#El orden asignado es de acuerdo al archivo de puntos de muestreo (Archivo Excel), columna NN
write.csv(data_long_lat, "data_long_lat.csv", quote=F)

#Revisar en la ruta de la carpeta la data meteorológica obtenida con el nombre asignado en el paso anterior
#La primera columna son las fechas, dependerá si son diarias o mensuales
#La fecha de inicio es 01/01/1981 al 31/12/2016 (puede variar de acuerdo a la actualización del SENAMHI,
#revisar: https://iridl.ldeo.columbia.edu/SOURCES/.SENAMHI/.HSR/.PISCO/.Prec/.v2p1/.stable/.daily/)