# plumberModel
Paquete que facilita la productivización de modelos en R, permitiendo crear una
API con endpoints de predicción con minimo código.
```r
library(tidyverse)
library(caret)
library(plumberModel)

modelo <- train(iris %>% select(-Species), iris$Species)
api <- PlumberModel$new(modelo)
api$run(port = 9999)
```
## 1. Endpoints disponibles

### `GET` /modelInfo 
Devuelve un json con información relativa al modelo.
```json
{
  "name":["Unnamed model"],
  "method":["rf"],
  "type":["Regression"],
  "version":["Unversioned model"],
  "hyperParameters":[{"mtry":2}]
}
```
### `GET` /trainResults
Devuelve una serie de métricas y sus valores.
```json
[
  {"Metric":"RMSE","Value":0.2799},
  {"Metric":"Rsquared","Value":0.9748},
  {"Metric":"MAE","Value":0.2154},
  {"Metric":"RMSESD","Value":0.0238},
  {"Metric":"RsquaredSD","Value":0.004},
  {"Metric":"MAESD","Value":0.0181}
]
```
### `GET` /inputFeatures
Devuelve las variables de entrada al modelo para su predicción.
```json
{
  "Sepal.Length":{"class":["numeric"],"mean":[5.8433],"std":[0.6857]},
  "Sepal.Width":{"class":["numeric"],"mean":[3.0573],"std":[0.19]},
  "Petal.Width":{"class":["numeric"],"mean":[1.1993],"std":[0.581]},
  "Species":{"class":["factor"],"levels":["setosa","versicolor","virginica"]}
}
```
### `GET` /predict
Predice con el modelo utilizando como input los parametros de la query. 

El nombre de cada parámetro tiene que coincidir con el nombre de una variable 
de entrada sin importar el orden.

Siguiendo con el ejemplo, una query valida seria:
```url
predict?Sepal.Length=5.0&&Sepal.Width=3.5&&Petal.Width=1.21&&Species=setosa
```
Devuelve las predicciones del modelo.
```json
  [2.5505]
```
### `POST` /predict
Análogo a `GET` /predict pero enviando los datos de entrada en un json en el
cuerpo del post.
```json
[
  {"Sepal.Length":5.1,"Sepal.Width":3.5,"Petal.Width":0.2,"Species":"setosa"},
  {"Sepal.Length":4.9,"Sepal.Width":3,"Petal.Width":0.2,"Species":"setosa"},
  {"Sepal.Length":4.7,"Sepal.Width":3.2,"Petal.Width":0.2,"Species":"setosa"}
] 
```
La respuesta sería
```json
  [1.4379,1.4549,1.4437]
```
## 2. Crear nuevo endpoint
## 3. Tipos de modelo soportados

## 4. Añadir soporte para un modelo personalizado
