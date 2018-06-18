# Esta imagen contiene tydiverse, R6 y devtools
FROM rocker/tidyverse

# Instalacion de paquetes
RUN R -e "install.packages('plumber')"
RUN R -e "install.packages('randomForest')"
RUN R -e "install.packages('e1071')"
# Si queremos instalar mas paquetes añadimos más lineas. Prefiero a la 
# alternativa de tener definido Packages.R ya que si queremos añadir una 
# libreria a posteriori no hace falta reinstalar todas
# RUN R -e "install.packages('xgboost')"
# Se instala desde github la libreria
RUN R -e "devtools::install_github('beeva-jorgezaldivar/plumberModel')"

# Fijamos el directorio de trabajo
WORKDIR /usr/local/workspace

# Copiamos el script de entrada, así como todos los archivos necesarios para
# el modelo si hiciera falta 
COPY api_entrypoint.R .

# Ejecutamos el 'main' del modelo donde se debe construir la api
ENTRYPOINT [ "Rscript", "api_entrypoint.R" ]
