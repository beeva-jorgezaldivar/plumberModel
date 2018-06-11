#' Implementación para un modelo de caret dónde se han guardado los datos de
#' entrenamiento del mismo.
#' @param mdl Modelo entrenado con caret. Tiene que contener el atributo
#' 'trainingData'.
#' @return Lista de variables con las características de la descripción de la
#' función genérica.
inputFeatures.train <- function(mdl){
  sapply(mdl$trainingData %>% select(-.outcome), function(feature){
    if("numeric" %in% class(feature) || "integer" %in% class(feature)){
      list(class = "numeric", mean = mean(feature), std = var(feature))
    } else if ("factor" %in% class(feature)){
      list(class = class(feature), levels = levels(feature))
    } else {
      stop(paste0("Unknown feature class ", class(feature), "."))
    }
  }, simplify = FALSE)
}
#' Implementación para un modelo de caret. Opcionalmente se le puede añadir
#' los atributos 'name' y 'version' para llevar un control de los modelos.
#' @param mdl Objeto que contiene el modelo.
#' @retun Lista de strings con información sobre el modelo.
modelInfo.train <- function(mdl){
  if(is.null(mdl$name)){
    mdl$name <- "Unnamed model"
    #warning("The model should be named.")
  }
  if(is.null(mdl$version)){
    mdl$version <- "Unversioned model"
    #warning("The model should have a version.")
  }
  list(name = mdl$name, method = mdl$method, type = mdl$modelType,
       version = mdl$version, hyperParameters = mdl$bestTune)
}
#' Implementación para un modelo de caret.
#' @inheritParams trainResults
#' @return data.frame con columnas 'Metric' con el nombre de la metrica y
#' columna 'Value' con el valor de la métrica.
trainResults.train <- function(mdl){
  if(nrow(mdl$results) > 0){ # Entrenamos con algún tipo de validación
      mdl$results %>%
        inner_join(mdl$bestTune, by = colnames(mdl$bestTune)) %>%
        select(-one_of(colnames(mdl$bestTune))) %>%
        gather(key = "Metric", value = "Value")
  } else { # Entrenamos el modelo tal cual
    data.frame(
      Metric = setdiff(colnames(mdl$results), colnames(mdl$bestTune)),
      Value = NA
    )
  }
}
