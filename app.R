library(shiny)
library("DT")

dataFolder <- keyring::key_get("legendT2dmShinyData")
appDir <- getwd()
#  appDir <- system.file("shiny", "LegendT2dmEvidenceExplorer", package = "LegendT2dm")

.GlobalEnv$shinySettings <- list(dataFolder = dataFolder, blind = TRUE)
on.exit(rm(shinySettings, envir=.GlobalEnv))
shiny::runApp(appDir)
