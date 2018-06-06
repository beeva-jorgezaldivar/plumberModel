CaretPlumber <- R6Class(
  classname = "CaretPlumber",
  inherit = plumber::plumber,
  #' Métodos públicos. Las clases hijas los deben implementar si el modelo es
  #' distinto para ser compatibles con la api.
  public = list(
    #' Constructor de la api.
    #' @param model Modelo base de la API.
    initialize = function(model){
      self$setModel(model)
      self$setErrorHandler(private$handleHttpErrors)
      private$buildEndPoints()
    },
    #' Obtiene una copia del modelo base.
    #' @return Copia del modelo base.
    getModel = function(){
      private$model
    },
    #' Fija el modelo base.
    #' @return Referencia a sí mismo.
    setModel = function(model){
      private$model <- model
      self
    },
    #' Obtiene información sobre el modelo.
    #' @return Lista con información básica sobre el modelo.
    modelInfo = function(){
      modelInfo(private$model)
    },
    #' Resultados del entrenamiento.
    #' @return data.frame con los resultados del entrenamiento en función de
    #' los hiperparámetros del modelo.
    trainResults = function(){
      trainResults(private$model)
    },
    #' Definición de las variables del modelo.
    #' @return Lista con las variables e información sobre las mismas.
    features = function(){
      features(private$model)
    },
    #' Importancia de cada variable en el entrenamiento.
    #' @return data.frame con la importancia de cada variable en el
    #' entrenamiento. Tiene que haber sido previamente calculada en la mayoría
    #' de los casos.
    featureImportance = function(){
        featureImportance(private$model)
    },
    #' Predice el modelo.
    #' @param X data.frame con las variables independientes.
    #' @return Vector con las predicciones de la variable objetivo.
    predict = function(X){
      predict(private$model, X)
    }
  ),
  # Métodos privados. Pueden ser sobreescritos por clases hijas.
  private = list(
    model = NULL,
    #' Define los endpoints de la API.
    buildEndPoints = function(){
      self$handle("GET", "/modelInfo", function(req, res){
        self$modelInfo()
      })
      self$handle("GET", "/trainResults", function(req, res){
        self$trainResults()
      })
      self$handle("GET", "/featureImportance", function(req, res){
        self$featureImportance()
      })
      self$handle("GET", "/predict", function(req, res){

      })
      self$handle("POST", "/predict", function(req, res){
        X <- jsonlite::fromJSON(req$postBody)
        if(!("data.frame" %in% class(X)))
          stop("parse error: Couldn't parse request as a valid data.frame.")
        X <- coerceData(X, self$features())
        self$predict(X)
      })
    },
    #' Maneja los errores que se producen en los endpoints.
    #' @param req Objeto de peticion.
    #' @param res Objeto de respuesta.
    #' @param err Objeto de error.
    handleHttpErrors = function(req, res, err){
      # Chequeamos si es un error conocido.
      known.errors <- c("parse", "validation")
      known.err.rgx <- paste0("^", known.errors, " error:")
      errorKnown <- FALSE
      # Si el error lo hemos generado nosotros durante la validación mandamos
      # un 400: Bad request, sino mandamos un 500: Internal server error.
      res$status <- if(errorKnown) 400 else 500
      # Además enviamos el mensaje de error en el cuerpo de la respuesta.
      list(error = jsonlite::unbox(err$message))
    }
  )
)
