library(tidyverse)
library(caret)
library(plumberModel)

#' Funcion que obtiene un modelo entrenado.
obtenerModeloEntrenado <- function(){
    X <- iris %>% select(-Species)
    y <- iris$Species
    mdl <- train(x = X, y = y, method = "rf", 
        trControl = trainControl(method = "cv", number = 5))
    mdl$name <- "Iris"
    mdl$version <- "1.0.0"
    mdl
}

#' Funcion que levanta la api a partir de un modelo entrenado
levantarApi <- function(mdl){
    api <- PlumberModelWebApp$new(mdl, static.dir = "www")
    api$run(port = 9999, host = "0.0.0.0")
}

#' Entrypoint
obtenerModeloEntrenado() %>%
    levantarApi()
