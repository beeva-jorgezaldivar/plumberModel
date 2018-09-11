library(tidyverse)
library(caret)
library(plumberModel)

# -----------------------------------------------------------------------------
# -------------------------- TRAINING -----------------------------------------
# -----------------------------------------------------------------------------

titanic <- read.csv("inst/datasets/Titanic.csv")

titanic_clean <- titanic %>%
  select(-PassengerId, -Name, -Ticket, -Cabin) %>%
  na.omit()

titanic_clean <- titanic_clean %>% mutate(Pclass)

titanic_clean %>% head()

X <- titanic_clean %>% select(-Survived)
y <- ifelse(titanic_clean$Survived == 0, "No", "Yes") %>%
  factor(levels = c("No", "Yes"))

mdl <- train(X, y, method = "rf",
             trControl = trainControl(method = "cv", number = 5))

# Extra info needed for some endpoints
mdl$name <- "Titanic"
mdl$version <- "1.0.0"
mdl$lastTrained <- Sys.time()

# -----------------------------------------------------------------------------
# ------------------------------ DEPLOY ---------------------------------------
# -----------------------------------------------------------------------------

api <- PlumberModelWebApp$new(mdl)
api$run(port = 9999)
