### Prophet
install.packages("prophet")
library(prophet)



### Prophet del otro ejemplo 
# Crear dataframe con formato para Prophet (ds,y)
Chile_df=data.frame(ds=as.Date(1990:2019), y=dsubset$Chile)
Bulgaria_df=data.frame(ds=as.Date(1990:2019), y=dsubset$Bulgaria)

# Modelo
pm_Chile <- prophet(Chile_df)
pm_Bulgaria <- prophet(Bulgaria_df)

# Predicciones
future_Chile <- make_future_dataframe(pm_Chile, periods = 6)
forecast_Chile <- predict(pm_Chile, future_Chile)

future_Bulgaria <- make_future_dataframe(pm_Bulgaria, periods = 6)
forecast_Bulgaria <- predict(pm_Bulgaria, future_Bulgaria)

# Plot
plot(pm_Chile, forecast_Chile)
plot(pm_Bulgaria, forecast_Bulgaria)


### Otro Conjunto de Datos
df <- read.csv('https://raw.githubusercontent.com/facebook/prophet/main/examples/example_wp_log_peyton_manning.csv')

# Modelo
m <- prophet(df)

# Predicciones
future <- make_future_dataframe(m, periods = 365)
forecast <- predict(m, future)

# Plot
plot(m, forecast)

