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


serie<-get_historic_price('USD','2017-01-01',Sys.Date())

serie <- setDT(serie, keep.rownames = TRUE)[]

serie <- serie%>%
  rename(ds=rn,
         y=Price)

serie$ds = as.Date(serie$ds, "%Y-%m-%d")

#Forecasting using Prophet in R
#Justin Raymond S. Eloriaga
#Loading the Packages

#Loading the Dataset

head(serie)

#Calling the Prophet Function to Fit the Model

Model1 <- prophet(serie)

Future1 <- make_future_dataframe(Model1, periods = 180)

tail(Future1)

Forecast1 <- predict(Model1, Future1)

tail(Forecast1[c('ds','yhat','yhat_lower','yhat_upper')])


#Plotting the Model Estimates

dyplot.prophet(Model1, Forecast1)

prophet_plot_components(Model1, Forecast1)
