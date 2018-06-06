# Funciones de validación de datos de un data.frame.

#' Convierte un data.frame a los tipos de datos soportados por el modelo. Si no
#' es posible lanza errores de validacion.
#' @param X data.frame con las variables independientes sin validar.
#' @param vars Lista con la descripcion de las variables que entran en el modelo.
#' @return data.frame validado y convertido a los datos de entrada al modelo.
coerceData <- function(X, vars){
  # Chequeamos que están todas las columnas necesarias.
  checkMissingColumns(X, vars)
  # Intentamos convertir cada columa a su tipo.
  X_1 <- convertData(X, vars)
  # Chequeamos si se han producido NAS con la conversion.
  checkIfNas(X_1, X, vars)
  X_1 # Devolvemos el data.frame transformado.
}

#' Chequea si existen todas las columnas en el data.frame de entrada. Sino
#' lanza un error de validacion.
#' @param X data.frame con las variables independientes sin validar.
#' @param vars Lista con la descripcion de las variables que entran en el modelo.
checkMissingColumns <- function(X, vars){
  missing.columns <- setdiff(names(vars), colnames(X))
  if(length(missing.columns) > 0){
    mc.str <- paste(missing.columns, collapse = ", ")
    stop(paste0("validation error: Missing columns: ", mc.str, "."))
  }
}

#' Convierte el data.frame de entrada al tipo de datos del modelo.
#' @param X data.frame con las variables independientes sin validar.
#' @param vars Lista con la descripcion de las variables que entran en el modelo.
#' @return data.frame con las columnas en el tipo de datos correcto, aunque
#' pueden producirse registros nulos.
convertData <- function(X, vars){
  sapply(names(vars), function(n){
    as(X[[n]], vars[[n]]$class)
  }, simplify = FALSE) %>% data.frame()
}

#' Chequea si existen nulos en el data.frame de entrada y da errores de validacion.
#' @param X_1 data.frame convertido al tipo de datos correcto sin validar.
#' @param X data.frame con las variables independientes sin validar.
#' @param vars Lista con la descripcion de las variables que entran en el modelo.
checkIfNas <- function(X_1, X, vars){
  errors <-
    sapply(names(vars), function(n){
      nulos <- X[[n]][is.na(X_1[[n]])]
      if(length(nulos) > 0){
        if(vars[[n]]$class == 'numeric'){
          paste0("Cannot convert (", paste(nulos, collapse = ", "),
                 ") to numeric.")
        } else if(vars[[n]]$class == 'factor'){
          paste0("Levels ", paste(unique(nulos), collapse = ", "),
                 " not present in train set.")
        }
      }
    }, simplify = FALSE) %>% as_vector()
  if(!is.null(errors)){
    stop(paste0("validation error: ", paste(errors, collapse = ", ")))
  }
}
