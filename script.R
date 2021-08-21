# vamos a explorar el uso de Prophet para la predicción 
# de series temporales univariantes.

# llamamos a las librerías necesarias.

library(ggplot2)
library(tidyverse)
library(tseries)
library(forecast)
library(coindeskr)
library(data.table)
library(prophet)

# Requerimos los datos desde 2017 a la fecha. 
# Este no es un tema menor!
# ya que el recorte temporal va a influir en los datos de nuestro modelo.
# Si bien bitcoin existe desde hace más de una década, nos enfocaremos en
# consultar los datos que se corresponden a su fase de maduración: 
# Desde 2017 destaca el posicionamiento que ha obtenido la moneda digital, 
# así como también la progresión hacia la legitimidad.


serie <- get_historic_price('USD','2017-01-01',Sys.Date())

serie <- setDT(serie, keep.rownames = TRUE)[]

serie <- serie%>%
  rename(ds=rn,
         y=Price)

serie$ds = as.Date(serie$ds, "%Y-%m-%d")

head(serie)


# llamamos a prophet y fiteamos el modelo

modelo1 <- prophet(serie)

futuro1 <- make_future_dataframe(modelo1, periods = 60) #requerimos una predicción por los próximos 2 meses

tail(futuro1)

forecast1 <- predict(modelo1, futuro1)

tail(forecast1[c('ds','yhat','yhat_lower','yhat_upper')])


# graficamos las estimaciones del modelo

dyplot.prophet(modelo1, forecast1)

prophet_plot_components(modelo1, forecast1)


#plot(modelo1, forecast1) + add_changepoints_to_plot(modelo1)