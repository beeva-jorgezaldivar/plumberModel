# -----------------------------------------------------------------------------
# ------------------- TEST MISSINGCOLUMNS -------------------------------------
# -----------------------------------------------------------------------------
X <- iris
vars <- list(
  FooColumn = list(class = 'numeric'),
  BarColumn = list(class = 'numeric')
)
expect_error(checkMissingColumns(X, vars), "validation error")

vars <- list(
  Species = list(class = 'factor',
                 levels = c('setosa', 'virginica', 'versicolor')),
  Petal.Length = list(class = 'numeric')
)
checkMissingColumns(X, vars)

# -----------------------------------------------------------------------------
# ----------------- TEST CONVERTDATA ------------------------------------------
# -----------------------------------------------------------------------------
X <- iris
vars <- list(
  Species = list(class = 'factor',
                 levels = c('setosa', 'virginica', 'versicolor')),
  Petal.Length = list(class = 'numeric')
)
result <- convertData(X, vars)
expect_equal(names(vars), colnames(result))
expect_equal(unname(sapply(result, class)) , c("factor", "numeric"))
expect_equal(sort(levels(result$Species)),
             sort(c('setosa', 'virginica', 'versicolor')))

# -----------------------------------------------------------------------------
# ---------------------- TEST CHECKIFNA ---------------------------------------
# -----------------------------------------------------------------------------
X <- iris
vars <- list(
  Species = list(class = 'factor',
                 levels = c('setosa', 'virginica', 'versicolor')),
  Petal.Length = list(class = 'numeric')
)
X_1 <- convertData(X, vars)
checkIfNas(X_1, X, vars)

X <- iris
vars <- list(
  Species = list(class = 'factor',
                 levels = c('setosa', 'virginica')),
  Petal.Length = list(class = 'numeric')
)
X_1 <- convertData(X, vars)
expect_error(checkIfNas(X_1, X, vars), "validation error")

X <- iris %>% mutate(FooColumn = "NotNumeric")
vars <- list(
  Species = list(class = 'factor',
                 levels = c('setosa', 'virginica', 'versicolor')),
  Petal.Length = list(class = 'numeric'),
  FooColumn = list(class = 'numeric')
)
X_1 <- convertData(X, vars)
expect_error(checkIfNas(X_1, X, vars), "validation error")
