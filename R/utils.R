loadSampleModels <- function(){
  #' Obtengo el directorio en el que estan los modelos
  if(is.null(packageName())) {
    test.data.folder <- "inst/sample-models/"
  } else {
    test.data.folder <- system.file("sample-models", package = packageName())
  }
  full.paths <- #' Obtencion de la ruta completa de cada archivo
    file.path(test.data.folder,
              list.files(path = test.data.folder, pattern = ".rds$"))
  model.list = list()
  for(path in full.paths){
    name <- str_extract(basename(path), "[^/.]+")
    model.list[[name]] <- readRDS(path)
  }
  model.list
}

#' Obtiene una descripción de las variables en función de un data.frame en
#' particular.
inputFeaturesFromDataFrame <- function(X){
  sapply(X, function(feature){
    if("numeric" %in% class(feature) || "integer" %in% class(feature)){
      list(class = "numeric", mean = mean(feature), std = var(feature))
    } else if ("factor" %in% class(feature)){
      list(class = class(feature), levels = levels(feature))
    } else {
      stop(paste0("Unknown feature class ", class(feature), "."))
    }
  }, simplify = FALSE)
}

#' Crea el esqueleto de una aplicación.
#' Crea un bootstrap de la aplicación con un Dockerfile y scripts para correrlo
#' y crearlo.
#' @param dir Directorio en el que crear el esqueleto.
plumberModelSkeleton <- function(dir = "."){
  if(is.null(packageName())){
    root <- "inst/infraestructure"
  } else {
    root <- system.file("infraestructure", package = packageName())
  }
  files <-
  list.files(path = root, recursive = TRUE, include.dirs = TRUE, 
    full.names =TRUE)
  file.copy(files, dir, recursive = TRUE)

  if(is.null(packageName())){
    root <- "inst/www"
  } else {
    root <- system.file("www", package = packageName())
  }
  dir.create(file.path(dir, "www"))
  file.copy(root, dir, recursive = TRUE)
}
