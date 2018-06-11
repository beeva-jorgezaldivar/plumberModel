library(tidyverse)
library(caret)
library(caretPlumber)

# -----------------------------------------------------------------------------
# -------------- TRANSFORMACION DATOS ENTRENAMIENTO ---------------------------
# -----------------------------------------------------------------------------

#' Funcion que obtiene los datos de entrenamiento.
#' @return lista con atributos 'X' variables independientes 'y' variable
#' objetivo.
obtenerDatosEntrenamiento <- function(){
  # Leemos el mítico dataset Titanic
  titanic <- read_csv("inst/datasets/Titanic.csv")
  # Eliminamos los campos que no nos sirven para la clasificación
  titanic <- titanic %>% select(-PassengerId, -Name, -Cabin, -Ticket)
  #' Convertimos factores
  titanic <-
    titanic %>%
    mutate(
      Survived = factor(Survived, levels = c(0, 1)),
      Pclass = factor(Pclass, levels = c(1, 2, 3), ordered = TRUE),
      Sex = factor(Sex, levels = c("male", "female")),
      Embarked = factor(Embarked, levels = c("C", "Q", "S"))
    )
  # Eliminamos los registros que tienen datos faltantes
  titanic <- titanic %>% na.omit()
  # Dividimos entre variables independientes y dependientes
  X <- titanic %>% select(-Survived)
  y <- titanic$Survived
  # Añado la clase para que train entre por nuestro método.
  class(X) <- c("input", class(X))
  # Devolvemos lista con variable independientes y objetivo
  list(X = X, y = y)
}

# -----------------------------------------------------------------------------
# --------------------------- ENTRENAMIENTO -----------------------------------
# -----------------------------------------------------------------------------

#' Funcion de entrenamiento.
#' @param x Input para la clase titanic
#' @param ... Parametros de traind de caret.
#' @return Objeto modelo entrenado
train.input <- function(x, ...){
  input.features <- inputFeaturesFromDataFrame(X)
  X1 <- x %>% select(-Pclass, -Fare)
  X2 <- x %>% transmute(Pclass = as.numeric(Pclass), Fare = Fare)
  pca <- prcomp(X2, scale. = T, center = T)
  X3 <- data.frame(predict(pca, X2))
  x <- bind_cols(X1, X3)
  mdl <- NextMethod()
  mdl$input.features <- input.features
  mdl$pca <- pca
  class(mdl) <- c("customModel", class(mdl))
  mdl
}

# -----------------------------------------------------------------------------
# ------------------ SOBRECARGA FUNCIONES -------------------------------------
# -----------------------------------------------------------------------------

modelInfo.customModel <- function(mdl){
  list(
    name = "Titanic",
    version = "1.0.0",
    type = mdl$modelType,
    method = mdl$method
  )
}

inputFeatures.customModel <- function(mdl){
  mdl$input.features
}

trainResults.customModel <- function(mdl){
  NextMethod()
}

predict.customModel <- function(mdl, new.data){
  X1 <- new.data %>% select(-Pclass, -Fare)
  X2 <- new.data %>% transmute(Pclass = as.numeric(Pclass), Fare = Fare)
  X3 <- data.frame(predict(mdl$pca, X2))
  new.data <- bind_cols(X1, X3)
  NextMethod()
}

# -----------------------------------------------------------------------------
# ------------------------------ MAIN -----------------------------------------
# -----------------------------------------------------------------------------

if(FALSE){
  train.data <- obtenerDatosEntrenamiento()
  mdl <- train(x = train.data$X, y = train.data$y, method = "rf",
               trControl = trainControl(method = "cv", number = 5))
  api <- PlumberModelWebApp$new(mdl)
  api$run(port = 9999)
}


