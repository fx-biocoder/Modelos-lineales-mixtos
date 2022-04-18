# 1 - Librerías necesarias para el proyecto
library(nlme)
library(lme4)

# 2 - Funciones necesarias
boxplot_graph = function(dataframe, aes_x, aes_y){
  library(ggplot2)
  ggplot(dataframe,
         aes(x = aes_x,
             y = aes_y)) +
    geom_boxplot() +
    stat_boxplot(geom = "errorbar")
}

qq_plotting =  function(model){
  plot(model)
  qqnorm(resid(model))
  qqline(resid(model), col = "blue")
  shapiro.test(residuals(model))
}

"""
3 - Análisis del caso
    El dataframe Hueso.csv contiene información sobre la longitud del hueso
    ramus para 20 niños a lo largo de un período de 2 años y medio. Comenzamos por tomar como
    factor los individuos
"""
Hueso$fIndividuo <- factor(Hueso$individuo)
modelo <- lme(HuesoRamus ~ edad, random = ~edad | fIndividuo, data = Hueso) # Pendiente aleatoria
modelo2 <- lme(HuesoRamus ~ edad, random = ~1 | fIndividuo, data = Hueso) # Pendiente fija
summary(modelo)
summary(modelo2)

# ¿Cuál modelo es mejor? Para eso se utiliza el Akaike's Information Criterio
AIC(modelo, modelo2) # La pendiente aleatoria mejora el ajuste

# Ploteamos el modelo ajustado:
F0 <- fitted(modelo, level = 0)
I <- order(Hueso$edad)
edades <- sort(Hueso$edad)

plot(edades, 
     F0[I], 
     lwd  = 4, 
     type = "l", 
     ylim = c(44,57), 
     ylab = "HuesoRamus", 
     xlab = "edad")

F1 <- fitted(modelo, level = 1)

for (i in 1:20){
  x1 <- Hueso$edad[Hueso$fIndividuo == i]
  y1 <- F1[Hueso$fIndividuo == i]
  K  <- order(x1)
  lines(sort(x1), y1[K])
}

x = text(Hueso$edad, Hueso$HuesoRamus, Hueso$fIndividuo, cex=0.7)

"""
# 4 - Establecimiento del modelo
#     Se usarán dos métodos distintos para el cálculo del cociente de verosimilitud:
#     el criterio normal (ML) y el restringido (REML)
"""
Hueso$logHuesoRamus <- log(Hueso$HuesoRamus)
Hueso$fEdad <- factor(Hueso$edad)
modelo.ml <- lme(HuesoRamus ~ edad, data = Hueso, random = ~edad| fIndividuo, method = "ML")
modelo.reml <-lme(HuesoRamus ~ edad, data = Hueso, random = ~edad | fIndividuo, method = "REML")

# Uso del Akaike Information Criterion para determinar cuál es el mejor modelo
AIC(modelo.ml, modelo.reml)

# 5 - ¿Hay normalidad y homocedasticidad?
boxplot_modelo.ml <- boxplot_graph(Hueso, Hueso$fEdad, Hueso$HuesoRamus)
boxplot_modelo.ml
# El boxplot nos indica que no podemos afirmar ausencia de homocedasticidad con seguridad
# por lo que hacemos un qq-plot con la función creada previamente
qq_plotting(modelo.ml)
# No hay normalidad