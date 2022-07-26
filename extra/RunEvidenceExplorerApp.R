# OHDSI shinydb legendt2dm read-only credentials
appConnectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = "postgresql",
  server = paste(keyring::key_get("legendt2dmServer"),
                 keyring::key_get("legendt2dmDatabase"),
                 sep = "/"),
  user = keyring::key_get("legendt2dmUser"),
  password = keyring::key_get("legendt2dmPassword"))

# Run from db server (data download can take a long time)
LegendT2dmEvidenceExplorer::launchEvidenceExplorer(cohorts = "class",
                                                   connectionDetails = appConnectionDetails,
                                                   blind = TRUE)

# Run from local files
LegendT2dmEvidenceExplorer::launchEvidenceExplorer(dataFolder = keyring::key_get("legendT2dmShinyData"),
                                                   blind = TRUE)


### TEST CODE

getAnalyses <- function(connection) {
  sql <- "SELECT analysis_id, description FROM cohort_method_analysis"
  sql <- SqlRender::translate(sql, targetDialect = connection@dbms)
  analyses <- DatabaseConnector::querySql(connection, sql)
  colnames(analyses) <- SqlRender::snakeCaseToCamelCase(colnames(analyses))
  return(analyses)
}



connection <- DatabaseConnector::connect(appConnectionDetails)
DatabaseConnector::executeSql(connection = connection,
                              sql = "SET search_path TO legendt2dm_class_results;")
analyses <- getAnalyses(connection)
# control <- getControlResults(connection,
#                           targetId = 101100000,
#                           comparatorId = 201100000,
#                           analysisId = 5,
#                           databaseId = "MDCR")
DatabaseConnector::disconnect(connection)

