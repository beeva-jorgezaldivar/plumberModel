# caretPlumber
Paquete que facilita la productivización de modelos en R, permitiendo crear una
API con endpoints de predicción con minimo código.
```r
library(tidyverse)
library(caret)
library(caretPlumber)

modelo <- train(iris %>% select(-Species), iris$Species)
api <- CaretPlumber$new(modelo)
api$run(port = 9999)
```
Por el momento se disponibilizan los siguientes endpoints:
  * `GET` modelInfo/ 
  * `GET` trainResults/
  * `GET` features/
  * `GET` predict/
  * `POST` predict/

# Tipos de modelos soportados
# Crear nuevo endpoint
# Soporte para nuevo modelo
