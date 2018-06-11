library(tidyverse)
library(caret)
library(caretPlumber)
library(doMC)


# Lectura del dataset. Leemos con la funcion base para que nos convierta a
# factores directamente los campos carácteres.
titanic <- read.csv("inst/datasets/Titanic.csv")

# Eliminamos la información que no nos sirve para el modelo.
titanic_clean <- titanic %>%
  select(-PassengerId, -Name, -Ticket, -Cabin) %>%
  na.omit()

titanic_clean <- titanic_clean %>% mutate(Pclass)

titanic_clean %>% head()

# Dividimos entre variables independientes y dependientes.
X <- titanic_clean %>% select(-Survived)
y <- ifelse(titanic_clean$Survived == 0, "No", "Yes") %>%
  factor(levels = c("No", "Yes"))

# Entrenamos el modelo con el grid por defecto de rf, y una validación cruzada
# con 5 folds.
mdl <- train(X, y, method = "rf",
             trControl = trainControl(method = "cv", number = 5))

# Añadimos alguna información extra al modelo.
mdl$name <- "Titanic"
mdl$version <- "1.0.0"
mdl$lastTrained <- Sys.time()

# Montamos y ejecutamos la api.

api <- PlumberModelWebApp$new(mdl)
api$run(port = 9999)

