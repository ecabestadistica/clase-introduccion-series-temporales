# Vamos a ver otro conjunto de datos, en este caso los valores son:
# Número de muertes de mujeres por cáncer de mama (por año y por país)
library(readr)
df <- read_csv("breast_cancer_number_of_female_deaths.csv")
View(df)

# Primero vamos a invertir el conjunto de datos para tener en el indice de filas 
# las fechas y en las columnas a los paises
names <- df$country # guardamos la lista de los países que serán luego las columnas
df <- data.frame(t(df[-1])) # transponemos el dataframe
colnames(df) <- names # modificamos los nombres de las columnas

# Vamos a seleccionar algunos países
dsubset <- df[,c("Chile","Bulgaria")]
summary(dsubset) # vemos que las vbles son de clase chr
dsubset$Chile <- as.numeric(dsubset$Chile)
dsubset$Bulgaria <- as.numeric(dsubset$Bulgaria)

summary(dsubset) # ahora si vemos más detalles

# Estacionariedad
adf.test(dsubset$Chile)
adf.test(dsubset$Bulgaria)

# Objeto serie temporal
mytimeseries <- ts(data = dsubset)
library(dygraphs)
dygraph(mytimeseries)

# Series univariantes
Chile_timeseries <- ts(data = dsubset$Chile)
Bulgaria_timeseries <- ts(data = dsubset$Bulgaria)

# Modelos
myarima_Chile <- auto.arima(Chile_timeseries, max.p = 10, max.q = 10, max.order = 20, max.d = 5)
myarima_Bulgaria <- auto.arima(Bulgaria_timeseries, max.p = 10, max.q = 10, max.order = 20, max.d = 5)

# Predicciones
arimafore_Chile <- forecast(myarima_Chile, h = 6)
autoplot(arimafore_Chile)

arimafore_Bulgaria <- forecast(myarima_Bulgaria, h = 6)
autoplot(arimafore_Bulgaria)








