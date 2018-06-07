# -----------------------------------------------------------------------------
# ------------------ PLUMBERMOCKER --------------------------------------------
# -----------------------------------------------------------------------------
pb <- PlumberMocker$new()
pb$handle("GET", "/foo", function(req, res) "bar")
response <- pb$get("/foo")
expect_equal(response$status, 200)
expect_equal(response$body, jsonlite::toJSON("bar"))

# -----------------------------------------------------------------------------
# ----------------------- PLUMBERMODEL ----------------------------------------
# -----------------------------------------------------------------------------
model.list <- loadSampleModels()
mdl <- model.list$iris_regression_standard_call_rf
pb <- PlumberModel$new(mdl)
pb$get("/features")$status %>% expect_equal(200)
pb$get("/modelInfo")$status %>% expect_equal(200)
pb$get("/trainResults")$status %>% expect_equal(200)

# -- Predict GET
# Faltan columnas
response <- pb$get("/predict")
response$body %>% grepl("validation error: Missing columns", .) %>% expect_true()

# Request correcta
response <- pb$get("/predict",
                   "Sepal.Length=5&&Sepal.Width=3&&Petal.Width=1.2&&Species=setosa")
response$status %>% expect_equal(200)

# No pasa porque foo no es numerico
response <- pb$get("/predict",
       "Sepal.Length=foo&&Sepal.Width=3&&Petal.Width=1.2&&Species=setosa")
response$body %>% grepl("validation error", .) %>% expect_true()


# No pasa porque foo no es un nivel de Species
response <- pb$get("/predict",
                   "Sepal.Length=5&&Sepal.Width=3&&Petal.Width=1.2&&Species=foo")
response$body %>% grepl("validation error", .) %>% expect_true()

# -- Predict POST
test.json <- iris %>% head(3) %>% jsonlite::toJSON()
pb$post("/predict", body = test.json)$status %>% expect_equal(200)


