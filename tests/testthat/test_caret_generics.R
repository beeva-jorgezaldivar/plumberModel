#' Testea las funciones genéricas para un modelo.
testGenerics <- function(mdl){
  #' Extracción de descripción de variables.
  fs <- inputFeatures(mdl)
  #' Chequeo que es una lista.
  expect_true("list" %in% class(fs))
  #' Chequeo que cada elemento de la lista esta nombrado
  expect_true(all(names(fs) != ""))
  #' Chequeo que todos los campos son de tipos soportados
  cls <- sapply(fs, function(f) f$class)
  expect_true(
    all(
      cls == "factor" ||
      cls == "numeric" ||
      cls == c("ordered", "factor")
    )
  )
  #' Chequeo que si un campo es factor, tiene unos niveles asociados
  for(f in fs) if("factor" %in% f$class) expect_true(!is.null(f$levels))

  #' Chequeo modelInfo
  info <- modelInfo(mdl)
  attrs <- c("name", "version", "method", "type", "hyperParameters")
  sapply(attrs, function(attr) !is.null(info[[attr]])) %>%
    all() %>% expect_true()

  #' Chequeo resultados
  results <- trainResults(mdl)
  expect_true("data.frame" %in% class(results))
  expect_true("Metric" %in% colnames(results) && "Value" %in% colnames(results))
}

#' Ejecuto la función para la bateria de modelos
for(mdl in loadSampleModels()) testGenerics(mdl)


