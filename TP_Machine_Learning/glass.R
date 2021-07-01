# Librerías
library (caret)
library (rpart)
library(rattle)
library(rpart.plot)
library(dplyr)

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

glass$Type.of.glass <- unlist(Map(function(number) glassTypeNumberToText[number], glass$Type.of.glass))

# Convertimos en Factores para el árbol de decisión
glass$Type.of.glass <- as.factor(glass$Type.of.glass) #para que ande el createFolds con las clases



# KFold Cross Validation
totalKFolds = 12
kFoldsTrain = 1:10
kFoldsTest = setdiff(1:totalKFolds, kFoldsTrain)
indexData <- createFolds(glass$Type.of.glass, k = totalKFolds)

ModelParametersAndMetrics <- data.frame(
    method = character(),
    cp = numeric(),
    accuracy = numeric()
)


for (kfold in kFoldsTrain) {
    methods <- c('gini', 'information')
    for (method in methods) {
        
        # Partimos los conjuntos en entrenamiento y test
        glassTest <- glass[indexData[[kfold]], ] 
        
        glassTrain <- glass[-indexData[[kfold]], ] 
        
        #--------------------Entrenamiento--------------------
        fittedModel <- rpart(Type.of.glass ~ ., data = glassTrain, parms = list(split = method))
        
        #--------------Predicciones--------------------------
        
        possibleCPs <- 0:10 / 10 # 0:100 / 100
        for (cp in possibleCPs) {
            fittedPrunedModel <- prune(fittedModel, cp=cp)
            
            predictGlassPruned <- predict(fittedPrunedModel, glassTest[, -ncol(glassTest)], type = 'class')
            cm <- confusionMatrix(predictGlassPruned, glassTest[, ncol(glassTest)])
            
            log <- data.frame(
                method = method,
                cp = cp,
                accuracy = cm$overall[['Accuracy']]
            )
            
            ModelParametersAndMetrics <- rbind(ModelParametersAndMetrics, log)
        }
    } 
}

# Análisis sobre las métricas
ModelParametersAndMetrics %>% group_by(method, cp) %>% summarise(avg = mean(accuracy)) %>% arrange(-avg)
ModelParametersAndMetrics %>% group_by(method) %>% summarise(avg = mean(accuracy)) %>% arrange(-avg)
ModelParametersAndMetrics %>% group_by(cp) %>% summarise(avg = mean(accuracy)) %>% arrange(-avg)
ModelParametersAndMetrics[ModelParametersAndMetrics$method == 'gini',] %>% group_by(cp) %>% summarise(avg = mean(accuracy)) %>% arrange(-avg)

# Definimos los parámetros del modelo en base al análisis sobre las métricas
cp = 0
method = 'gini'

# Training with entire train dataset

trainIndexes <- unlist(indexData[kFoldsTrain], use.names = F)
glassTrain <- glass[trainIndexes, ]
glassTest <- glass[-trainIndexes, ]

fittedModel <- rpart(Type.of.glass ~ ., data = glassTrain, parms = list(split = method))

fittedPrunedModel <- prune(fittedModel, cp=0)

# Testing final model
predictGlassPruned <- predict(fittedPrunedModel, glassTest[, -ncol(glassTest)], type = 'class')
cm <- confusionMatrix(predictGlassPruned, glassTest[, ncol(glassTest)])

print(cm$table)
print(cm$overall)
print(cm$byClass)



#Plot del modelo entero
#fancyRpartPlot(fittedModel, caption = "information method")
#Plot del modelo podado
#fancyRpartPlot(fittedPrunedModel, caption = "information method pruned")



# [1, 2, 3, 4, 5] [7, 8] 
# Train        Test   Params        Model       Metrica
# [2, 3, 4, 5] [1]    ->         -> 
# [1, 3, 4, 5] [2]    -> 
# [1, 2, 4, 5] [3]    -> 

# [1, 2, 3, 4, 5] -> Model

# method  |   cp  |   accuracy    | recesion   
# gini    |   0.1 |   0.5         | 0.4
