# Librerías
library (caret)
library (rpart)
library(rattle)
library(rpart.plot)

# Carga de datos
glass <- read.csv("glass.csv")

# Acomodado de nombres
glassTypeNumberToText <- c(
    "building_windows_float_processed",
    "building_windows_non_float_processed",
    "vehicle_windows_float_processed",
    "vehicle_windows_non_float_processed",
    "containers",
    "tableware",
    "headlamps"
)

glass$Id <- NULL

#glass$Type.of.glass <- unlist(Map(function(number) glassTypeNumberToText[number], glass$Type.of.glass))

# Convertimos en Factores para el árbol de decisión
glass$Type.of.glass <- as.factor(glass$Type.of.glass) #para que ande el createFolds con las clases


totalKFolds = 10
# trainPercentage = 80
# testPercentage = 20

indexData <- createFolds(glass$Type.of.glass, k = totalKFolds) #creamos los kfolds

method = 'gini'

kfold = 3 #elegimos el indice para testear

for (kfold in 1:totalKFolds) {

glassTest <- glass[indexData[[kfold]], ] #con esto testeamos

glassTrain <- glass[setdiff(seq(1:dim(glass)[1]),
indexData[[kfold]]), ]  #con esto entrenamos

#--------------------Entrenamiento--------------------
fit1 <- rpart(Type.of.glass ~ ., data = glassTrain, parms = list(split = method))
fit1Pruned <- prune(fit1, cp=0.1)

#Plot del modelo entero
fancyRpartPlot(fit1, caption = "information method")

#Plot del modelo podado
fancyRpartPlot(fit1Pruned, caption = "information method pruned")

#--------------Predicciones--------------------------

#Predicciones sin poda
predictGlass <- predict(fit1, glassTest[, -length(glassTest)], type = 'class')

table_mat <- table(t(glassTest[, length(glassTest)]), predictGlass)

accuracy_Test_not_pruned <- sum(diag(table_mat)) / sum(table_mat)

#Predicciones con poda

predictGlassPruned <- predict(fit1Pruned, glassTest[, -length(glassTest)], type = 'class')
table_mat_pruned <- table(t(glassTest[, length(glassTest)]), predictGlassPruned)
accuracy_Test_pruned <- sum(diag(table_mat_pruned)) / sum(table_mat_pruned)

}


# [1, 2, 3, 4, 5] [7, 8] 
# Train        Test   Params        Model       Metrica
# [2, 3, 4, 5] [1]    ->         -> 
# [1, 3, 4, 5] [2]    -> 
# [1, 2, 4, 5] [3]    -> 

# [1, 2, 3, 4, 5] -> Model

# method  |   cp  |   accuracy    | recesion   
# gini    |   0.1 |   0.5         | 0.4
