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
        
        possibleCPs <- 0:30 / 100 # 0:100 / 100
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
ModelParametersAndMetrics[ModelParametersAndMetrics$method == 'information',] %>% group_by(cp) %>% summarise(avg = mean(accuracy)) %>% arrange(-avg)

#gini
# cp   avg
# <dbl> <dbl>
# 1  0.05 0.686
# 2  0.04 0.680
# 3  0    0.679
# 4  0.01 0.679
# 5  0.02 0.673
# 6  0.03 0.668
# 7  0.06 0.634
# 8  0.07 0.601
# 9  0.08 0.597
# 10  0.09 0.597

#information
# cp   avg
# <dbl> <dbl>
#   0.02 0.691
# 2  0    0.685
# 3  0.01 0.685
# 4  0.03 0.681
# 5  0.05 0.670
# 6  0.04 0.653
# 7  0.06 0.619
# 8  0.07 0.612
# 9  0.08 0.584
# 10  0.09 0.584

# Definimos los parámetros del modelo en base al análisis sobre las métricas
cp = 0.05
method = 'gini'

# cp = 0.02
# method = 'information'

# Training with entire train dataset

trainIndexes <- unlist(indexData[kFoldsTrain], use.names = F)
glassTrain <- glass[trainIndexes, ]
glassTest <- glass[-trainIndexes, ]

fittedModel <- rpart(Type.of.glass ~ ., data = glassTrain, parms = list(split = method))

fittedPrunedModel <- prune(fittedModel, cp=cp)

#fancyRpartPlot(fittedPrunedModel, caption = NULL)
#summary(fittedPrunedModel)

# Testing final model
predictGlassPruned <- predict(fittedPrunedModel, glassTest[, -ncol(glassTest)], type = 'class')
cm <- confusionMatrix(predictGlassPruned, glassTest[, ncol(glassTest)])

print(cm$table) #matriz de confusion
print(cm$overall)   #accuracy en general
print(cm$byClass)   #metricas por clase

#Precision
precision <- cm$byClass[,5]
precision[is.na(precision)] <- 0 #removemos los Nan para que el promedio sea significativo

meanPrecision <- mean(precision)

#Recall
recall <- cm$byClass[,6]
recall[is.na(recall)] <- 0 #removemos los Nan para que el promedio sea significativo

meanRecall <- mean(recall)

#Specifity
specifity <- cm$byClass[,2]
specifity[is.na(specifity)] <- 0 #removemos los Nan para que el promedio sea significativo

meanSpecifity <- mean(specifity)
