# Modelos lineales mixtos en R

Este repositorio contiene ejemplos de cómo crear modelos lineales mixtos, utilizando las librerías `nmle` y `lme4` de R.

## Contenidos
1. Modelo lineal mixto construido a partir de mediciones del hueso ramus a 20 niños, durante un período de 2 años y medio. 
2. Modelo lineal mixto construido a partir de datos obtenidos del paper [Limits of piriform silk adhesion—similar effects of substrate surface polarity on silk anchor performance in two spider species with disparate microhabitat use](https://link.springer.com/article/10.1007%2Fs00114-020-01687-w).
## Uso de los scripts
Para el análisis de los dataframes mediante los scripts, se requiere RStudio. Pueden instalar este software usando la guía localizada en mi repositorio de [tests estadísticos](https://github.com/fx-biocoder/Tests-estadisticos).
## Observaciones
Al usar la función boxplot_graph deberán suministrar los parámetros `aes_x` y `aes_y` según la nomenclatura `dataframe$variable`, si suministran `variable` como parámetro de forma directa la función fallará. Intenté resolver esto definiendo `aes(x = dataframe$variable_x, y = dataframe$variable_y)` pero `ggplot` lo prohíbe.  

## Contribuciones
¡Se aceptan pull requests!
