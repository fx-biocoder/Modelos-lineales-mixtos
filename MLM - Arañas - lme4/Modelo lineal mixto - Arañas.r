# 1 - Librerías
library(lme4)

# 2 - Función de qq-plot
qq_plotting =  function(model){
  plot(model)
  qqnorm(resid(model))
  qqline(resid(model), col = "blue")
  shapiro.test(residuals(model))
}

"""
3 - Análisis del caso
    Wolff et al. (2020) estudiaron la forma y adhesión de las telarañas
    en función del microambiente donde se encuentran las especies. En base a eso
    desarrollaron modelos lineales mixtos para mostrar la relación entre distintas
    variables ambientales. Este script utiliza los datos experimentales de los
    autores para desarrollar el mismo modelo de forma independiente.

Nota: los dataframes 114_2020_1687_MOESM1_ESM.csv y 114_2020_1687_MOESM2_ESM.csv
se han importado con los nombres M1 y M2 respectivamente, por una cuestión de simplicidad
"""

# Elaboración del modelo:
modelo1.araña <- lmer(force ~ spec + subs + (ind|spec), M1)
summary(modelo1.araña)
qq_plotting(modelo1.araña)
# El modelo no es normal. 

# Transformación logarítmica para obtener normalidad y homocedasticidad:
M1$logForce <- log(M1$force)
modelo2.araña <- lmer(logForce ~ spec + subs + (ind|spec), M1)
qq_plotting(modelo2.araña) # Ahora hay normalidad y homocedasticidad

# Se procede a visualizar si el ajuste mejora al remover la variable especie
modelo3.araña <- lmer(logForce ~ subs + (ind|spec), M1)
modelo4.araña <- lmer(logForce ~ subs + (1|ind), M1)
AIC(modelo2.araña, modelo3.araña, modelo4.araña)

# Se concluye que la variable especie no influye en la fuerza de adhesión

# ¿Hay influencia de la química del sustrato?
modelo5.araña <- lmer(logForce ~ 1 + (1|ind), M1)
AIC(modelo2.araña, modelo3.araña, modelo4.araña, modelo5.araña)

# El Akaike empeora, por ende hay influencia de la química del substrato

# Transformación logarítmica de la relación ancho-largo
M2$logRelwid <- log(M2$relwid)

# Modelo mixto para la relación ancho-largo utilizando todas las variables
modeloWL_m2 <- lmer(logRelwid ~ spec + subs + frontshift + centrality + (ind|spec), M2)
qq_ploting(modeloWL_m2)
# El modelo es normal y homocedástico

# Creación de modelos anidados
modeloWL_m2 <- lmer(logRelwid ~ spec + subs + frontshift + centrality + (ind|spec), M2)
modelo2WL_m2 <- lmer(logRelwid ~ subs + frontshift + centrality + (ind|spec), M2)
modelo3WL_m2 <- lmer(logRelwid ~ subs + frontshift + centrality + (1|ind), M2)
modelo4WL_m2 <- lmer(logRelwid ~ frontshift + centrality + (1|ind), M2)
modelo5WL_m2 <- lmer(logRelwid ~ frontshift + (1|ind), M2)

AIC(modeloWL_m2, modelo2WL_m2, modelo3WL_m2, modelo4WL_m2, modelo5WL_m2)

# Se concluye que el modelo 4 es el mejor con respecto a la relación ancho-largo

# Creación de un modelo para la variable área:
modeloA_m2 <- lmer(area ~ spec + subs + frontshift + centrality + (ind|spec), M2)
qq_plotting(modeloA_m2)

# El modelo no es normal. Se procede a realizar una transformación logarítmica:
M2$logArea <- log(M2$area)
modeloA_m2 <- lmer(logArea ~ spec + subs + frontshift + centrality + (ind|spec), M2)
qq_ploting(modeloA_m2)

# Ahora que se obtuvo normalidad, se procede a elaborar modelos anidados
modeloA2_m2 <- lmer(logArea ~ subs + frontshift + centrality + (ind|spec), M2)
modeloA3_m2 <- lmer(logArea ~ frontshift + centrality + (1|ind), M2)
modeloA4_m2 <- lmer(logArea ~ frontshift + (1|ind), M2)
AIC(modeloA_m2, modeloA2_m2, modeloA3_m2, modeloA4_m2)

# Vemos que el mejor modelo es el 3
# Tanto el área como la relación ancho.largo dependen de las mismas variables. No existen diferencias.
