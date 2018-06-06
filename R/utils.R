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
