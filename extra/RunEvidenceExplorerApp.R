# OHDSI shinydb legendt2dm read-only credentials
# appConnectionDetails <- DatabaseConnector::createConnectionDetails(
#   dbms = "postgresql",
#   server = paste(keyring::key_get("legendt2dmServer"),
#                  keyring::key_get("legendt2dmDatabase"),
#                  sep = "/"),
#   user = keyring::key_get("legendt2dmUser"),
#   password = keyring::key_get("legendt2dmPassword"))
#
# # Run from db server
# LegendT2dmEvidenceExplorer::launchEvidenceExplorer(connectionDetails = appConnectionDetails,
#                                                    resultsDatabaseSchema = "legendt2dm_class_results")
# TODO Does not work yet

# Run from local files
dataFolder <- keyring::key_get("legendT2dmShinyData")
LegendT2dmEvidenceExplorer::launchEvidenceExplorer(dataFolder = dataFolder, blind = TRUE)
