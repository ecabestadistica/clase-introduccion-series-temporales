######### Ejercicio 1: Crear un dataframe con información de fecha y tiempo

# Paquetes (instalar y cargar)
install.packages("lubridate")
install.packages("tseries")
install.packages("forecast")
install.packages("ggplot2")
install.packages("zoo")
library(lubridate)
library(tseries)
library(forecast)
library(ggplot2)
library(zoo)

# Paquete lubridate con funciones para manejar tiempos y fechas 
# Formas diferentes de introducir fechas

ymd(19931123) # Year / Month / Day
dmy(23111993) # Day / Month / Year
mdy(11231993) # Month / Day / Year

# Vamos a usar fechas y tiempo a la vez
ymd_hm(199311231224) # Year / Month / Day / Hour / Minutes
mytimepoint <- ymd_hm("1993-11-23 12:24", tz = "Europe/Madrid") #tz: time zone parameter

# Extrayendo los componentes
minute(mytimepoint)
day(mytimepoint)
hour(mytimepoint)
year(mytimepoint)
month(mytimepoint)

# Podemos modificar el valor de solo un componente (de 11 a 14)
hour(mytimepoint)
hour(mytimepoint) <- 14
mytimepoint

# Tambien se puede calcular el dia de la semana que corresponde a nuestra fecha
?wday
wday(mytimepoint) # Empieza en Domingo por defecto
wday(mytimepoint, label=TRUE)
wday(mytimepoint, label=TRUE, abbr=FALSE) # los niveles que considera sin abreviarlos

# Podemos ver en otra zona a qué fecha y hora corresponde
with_tz(mytimepoint, tz = "Europe/London") # una hora menos en Londres
mytimepoint


# Otra forma de convertir a formato fecha
c <- as.Date("2019-12-25") # Y M D
c
class(c)

# Creamos un vector de fechas con diferentes formatos
a <- c("1998,11,11", "1983/01/23", "1982:09:04", "1945-05-09", 19821224, "1974.12.03", 19871210)
a
a <- ymd(a, tz = "CET") # Lo convertimos usando la función ymd
a

# Creamos un vector de tiempos con diferentes formatos
b <- c("22 4 5", "04;09;45", "11:9:56", "23,15,12", "14 16 34", "8 8 23", "21 16 14")
b <- hms(b) # Lo convertimos usando la función hms
b

# Otra función
c <- "1983/01/23"
c <- as.Date(c) 
c <- "1983-01-23"
c <- as.Date(c)


# Creamos un vector de medidas o valores numéricos
f <- rnorm(7,10)
f <- round(f, digits = 2)
f

# Creando un dataframe
date_time_measurement1 <- cbind.data.frame(date = a, time = b, measurement = f)
date_time_measurement1


######### Ejercicio 2: Manejando fechas

# 1-Crea "x" con time zone CET y esta fecha "2014-04-12 23:12"
# 2-Cambia ahora el minuto de esa fecha al minuto 7
# 3-Mira a que tiempo corresponde en Londres 
# 4-Crea otro tiempo "y" que sea "2015-12-12 09:45" y mira la diferencia y-x



#Solución
#1
x <- ymd_hm("2014-04-12 23:12", tz = "CET")
#2
minute(x)
minute(x) <- 7
x
#3
with_tz(x, tz="Europe/London")
#4
y <- ymd_hm(tz = "CET", "2015-12-12 09:45")
y-x




######### Ejercicio 3: Objeto serie de tiempo en R y gráficos

# Creamos unos datos (50 valores aleatorios entre 10-45)
mydata <- runif(n = 50, min = 10, max = 45)

# ts es la clase "time series"
# Vamos a poner que empieza en el año 1956 
# con una freq de 4 obs por año (cuatrimestres)
mytimeseries <- ts(data = mydata,
                  start = 1956, frequency = 4)

class(mytimeseries)

# Veamos el grafico de la serie
plot(mytimeseries)

# Tiempos
time(mytimeseries)

# Redefiniendo el inicio "start" en el cuatrimestre 3
mytimeseries <- ts(data = mydata, 
                  start = c(1956,3), frequency = 4)
time(mytimeseries)
plot(mytimeseries)

# Y ahora con meses (frecuencia 12)
mytimeseries <- ts(data = mydata, 
                   start = c(1956,10), frequency = 12)
mytimeseries


######### Ejercicio 4: Gráficos

# Usaremos el dataset "Nottem" 
help(nottem) # Serie de tiempo que contiene el promedio de temperaturas 
             # en el castillo de Nottingham en grados Fahrenheit durante 20 años.

# Plot
plot(nottem) 

# ¿Qué se observa? ¿Estacionariedad? ¿Estacionalidad?

# Plot con función "autoplot" que usa ggplot2
autoplot((nottem))

# Le podemos agregar capas al autoplot
autoplot(nottem) + ggtitle("Autoplot of Nottingham temperature data")

# Gráfico de descomposición en efecto de tendencia, estacional y residual.
plot(decompose(nottem))

# Otra forma de hacer la descomposición
autoplot(decompose(nottem))

# Otra aleternativa Seasonal Decomposition of Time Series by Loess
plot(stl(nottem, s.window="periodic")) #s.window: seasonal window

# Extraer los componentes de una serie temporal (guardar el decompose)
mynottem <- decompose(nottem)
class(mynottem)

# Extraer y dibujar solo el componente de tendencia
autoplot(mynottem$trend)

# Extraer y dibujar solo el componente estacional
autoplot(mynottem$seasonal)




######### Ejercicio 5: Estacionariedad

# Dickey Fuller Test (Estacionariedad) 
adf.test(nottem) 
# Intepretación
# p-valor pequeño -> rechazar H0 y la serie sí es estacionaria ***
# p-valor > 0.05 -> No rechazar H0 y la serie No es estacionaria





######### Ejercicio 6: Datos Faltantes y Outliers 
## Importar los datos
mydata <- read.csv("Rmissing.csv")

# Convertir la segunda columna en una serie de tiempo sin especificar frecuencia
myts <- ts(mydata$mydata)
myts

# Comprobar si hay NAs y outliers
summary(myts)
sum(is.na(myts)) #numero de missing obs
plot(myts)

# Usando la librería zoo para localizar y rellenar valores faltantes

# Opción 1 na.locf: LOCF: last observation carried forward (copia la última observación antes del NA)
myts.NAlocf <- na.locf(myts) 
summary(myts.NAlocf)

# Opción 2 na.fill: rellena con el valor que le pongamos
myts.NAfill <- na.fill(myts, 33) 
summary(myts.NAfill)

#  Opción 3: con el paquete forecast
myts.NAinterp <- na.interp(myts) #rellena NA con interpolacion
summary(myts.NAinterp)

sum(is.na(myts.NAlocf)) #missing obs
sum(is.na(myts.NAfill)) #missing obs
sum(is.na(myts.NAinterp)) #missing obs

# Detección automática de outliers con la librería forecast, función tsoutliers (me dice cuáles):
myts1 <- tsoutliers(myts)
myts1
plot(myts) # para ver los picos


# Para limpiar los NAs y outliers usaremos tsclean del paquete forecast 
mytsclean <- tsclean(myts)
plot(mytsclean) # datos limpios sin picos ni valores faltantes
summary(mytsclean)

# Adicional: ¿Esta serie será estacionaria? 
# Dickey Fuller Test (Estacionariedad) 
adf.test(mytsclean) 
# Intepretación
# p-valor pequeño -> rechazar H0 y la serie sí es estacionaria ***
# p-valor > 0.05 -> No rechazar H0 y la serie No es estacionaria



######### Ejercicio 7: Analizando datos del COVID19 - Libreria zoo y dygraphs

# Más detalles sobre los datos en el artículo: Forecasting hospital-level COVID-19 admissions using real-time mobility data (Feb. 2023)
# https://doi.org/10.1038/s43856-023-00253-5

# Importar la librería zoo
#install.packages("zoo")
library(zoo) 

# Importar los datos
library(readr) 
admissions <- read.csv("admissions.csv")
View(admissions)

# Hay varios hospitales ---> Extraer solo los datos del Hospital==C
admissions_C <- admissions[admissions$HospitalID=="C",]
View(admissions_C)

# Hay fechas que se repiten, vamos a agruparlas for fecha para que sean únicas
data_C <- aggregate(admissions_C$NumberOfAdmissions, by=list(admissions_C$HospitalAdmitDate), sum)
View(data_C)

# Cambiar nombre de columnas
names(data_C) <- c("Dates", "Admissions")

# Extraer las fechas 
fechas_C <- as.Date(data_C$Dates, format="%Y-%m-%d") 
class(fechas_C) 
head(fechas_C) 

# Combinando los datos a objeto zoo
admissions_C.z <- zoo(x=data_C$Admissions, order.by=fechas_C) 
class(admissions_C.z) 
str(admissions_C.z) 
head(admissions_C.z) 

# Extrayendo el indice de tiempo y los datos
index(admissions_C.z) 
coredata(admissions_C.z) 

# Fechas de Inicio y Final 
start(admissions_C.z) 
end(admissions_C.z)

# Extraer subconjunto indexando con un vector de fechas
admissions_C.z[as.Date(c("2020/4/6", "2020/5/19", "2020/9/19"))]

# Otra opcion: usar window() para extraer valores entre 2 fechas
window(admissions_C.z, start=as.Date("2020/4/6"), end=as.Date("2020/5/19")) 

# Graficar los datos
plot(admissions_C.z, col="blue", lty=1, lwd=2, ylim=c(0,50), main="Daily Hospital Admissions COVID19",
     ylab="Number of Admissions")

# Liberia dygraphs para graficos más avanzados e interactivos
#install.packages("dygraphs")
library(dygraphs)
dygraph(admissions_C.z, "Daily Hospital Admissions COVID19")




######### Ejercicio 8: Cómo ver dos series temporales a la vez en el mismo gráfico

# Guardamos los datos de otro hospital ---> Extraer solo los datos del Hospital==E
admissions_E <- admissions[admissions$HospitalID=="E",]
View(admissions_E)

# Fechas repetidas
data_E <- aggregate(admissions_E$NumberOfAdmissions, by=list(admissions_E$HospitalAdmitDate), sum)
names(data_E) = c("Dates", "Admissions")

# Extraer fechas 
fechas_E <- as.Date(data_E$Dates, format="%Y-%m-%d") 

# Combinando los datos a objeto zoo
admissions_E.z <- zoo(x=data_E$Admissions, order.by=fechas_E) 

# Grafico solo para el Hospital E
dygraph(admissions_E.z, "Daily Hospital Admissions COVID19")

# Grafico para los dos hospitales (notar el problema de datos faltantes por fechas distintas)
dygraph(cbind(admissions_C.z,admissions_E.z), "Daily Hospital Admissions COVID19")





######### Ejercicio 9: Características de la serie de COVID: componente estacional, estacionaria o no, etc.
# Tomemos la serie admissions_C
head(data_C)

# Vamos a convertirla a objeto "ts" o mas bien "xts"
library(xts)

# Si vemos que "Dates" es de clase caracter la transformamos para tenga formato fecha
class(data_C$Dates)
data_C$Dates=as.Date(data_C$Dates)
class(data_C$Dates)

# Creamos el objeto xts (fecha en el indice)
df.ts <- xts(data_C[, -1], order.by=data_C$Dates)
View(df.ts)

# Cambiar nombre de la columna V1
names(df.ts) <- c("Admissions")

# Autoplot
library(forecast)
autoplot(df.ts) 


# Dickey Fuller Test (Estacionariedad) 
adf.test(data_C$Admissions) 
# Intepretacion
# p-valor pequeño -> rechazar H0 y la serie sí es estacionaria
# p-valor > 0.05 -> No rechazar H0 y la serie No es estacionaria ***



######### Ejercicio 10: Modelos Autoarima y NN para predecir la serie de COVID
auto.arima(df.ts)

# Order (AR + I + MA) # version basica (deberia dar que hay que diferenciar / integrar)
help(auto.arima)

# Mejor modelo (modificando los parámetros por defecto)
myarima <- auto.arima(df.ts, trace = T, 
                   stepwise = F, 
                   approximation = F, max.p = 10, max.q = 10, max.order = 20, max.d = 5)
#trace = T: the list of ARIMA models considered will be reported.
#stepwise = F: it searches over all models
#approximation = F: not considered, only for long ts or high seasonal period


# Modelo
myarima

# Forecast de 30 periodos (dias)
arimafore <- forecast(myarima, h = 30)
autoplot(arimafore)


#### Redes Neuronales
fit = nnetar(df.ts)
# Predicciones
nnetforecast <- forecast(fit, h = 30, PI = F)
autoplot(nnetforecast)


# Para el historial real, ¿como se comparan los datos reales vs los estimados?
# Autoarima
dygraph(cbind(arimafore$x,fitted(arimafore)), "Real vs Estimated Admissions")
# NN
dygraph(cbind(nnetforecast$x,fitted(nnetforecast)), "Real vs Estimated Admissions")



# Ver las predicciones  con dygraph (se puede hacer zoom seleccionando en el grafico)
# Autoarima
dygraph(cbind(arimafore$x,arimafore$mean), "Real vs Future Estimated")
# NN
dygraph(cbind(nnetforecast$x,nnetforecast$mean), "Real vs Future Estimated")


# Ver solo lo estimado
# Autoarima
dygraph(cbind(fitted(arimafore),arimafore$mean), "Historical Estimated vs Future Estimated")
# NN
dygraph(cbind(fitted(nnetforecast),nnetforecast$mean), "Historical Estimated vs Future Estimated")


# Comparar lo real + las dos predicciones Autoarima vs NN
dygraph(cbind(arimafore$x,arimafore$mean,nnetforecast$mean), "Historical Estimated vs Future Estimated")




