# Funciones genéricas y especificas para caret para extraer datos importantes
# del objeto del modelo.

#' Función que devuelve la descripción de las variables de entrada como una
#' lista. El nombre para cada objeto de la lista debe ser el nombre de la
#' variable y debe tener un atributo 'class' que puede ser 'numeric' o 'factor'.
#' En el caso de ser 'factor' tiene que contener un atributo extra 'levels',
#' que contiene los niveles de cada atributo.
#' @param mdl Modelo de entrada.
#' @return Lista de variables con las características de la descripción de la
#' función genérica.
inputFeatures <- function(mdl){
  UseMethod("inputFeatures")
}
#' Función que devuelve información sobre el modelo a modo de una lista de
#' strings.
#' @param mdl Objeto que contiene el modelo.
#' @retun Lista de strings con información sobre el modelo.
modelInfo <- function(mdl){
  UseMethod("modelInfo")
}
#' Función que obtiene los resultados del entrenamiento de un modelo,
#' devolviendo una serie de métricas como un data.frame.
#' @param mdl Objeto que contiene el modelo.
#' @return data.frame con las métricas del modelo.
trainResults <- function(mdl){
  UseMethod("trainResults")
}
