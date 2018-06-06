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

result <- convertData(X, vars)
expect_equal(names(vars), colnames(result))
sapply(result, class)
