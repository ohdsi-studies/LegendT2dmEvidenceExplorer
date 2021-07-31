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
