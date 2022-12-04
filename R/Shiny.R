# Copyright 2021 Observational Health Data Sciences and Informatics
#
# This file is part of LegendT2dmEvidenceExplorer
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#' Launch the Evidence Explorer Shiny app
#' @param cohort            A string denoting which results schema to explore.
#' @param connectionDetails An object of type \code{connectionDetails} as created using the
#'                          \code{\link[DatabaseConnector]{createConnectionDetails}} function in the
#'                          DatabaseConnector package, specifying how to connect to the server where
#'                          the study results results have been uploaded using the
#'                          \code{\link{uploadResults}} function.
#' @param dataFolder       A folder where the premerged file is stored. Use
#'                         the \code{\link{preMergeDiagnosticsFiles}} function to generate this file.
#' @param dataFile         (Optional) The name of the .RData file with results. It is commonly known as the
#'                         Premerged file.
#' @param blind            Should effect-estimates be hidden?
#' @param runOverNetwork   (optional) Do you want the app to run over your network?
#' @param port             (optional) Only used if \code{runOverNetwork} = TRUE.
#' @param launch.browser   Should the app be launched in your default browser, or in a Shiny window.
#'                         Note: copying to clipboard will not work in a Shiny window.
#' @param aboutText        Text (using HTML markup) that will be displayed in an About tab in the Shiny app.
#'                         If not provided, no About tab will be shown.
#'
#'
#' @details
#' Launches a Shiny app that allows the user to explore the evidence
#'
#' @examples
#' \dontrun{
#' # OHDSI shinydb legendt2dm read-only credentials
#' appConnectionDetails <- DatabaseConnector::createConnectionDetails(
#'   dbms = "postgresql",
#'   server = paste(keyring::key_get("legendt2dmServer"),
#'                  keyring::key_get("legendt2dmDatabase"),
#'                  sep = "/"),
#'   user = keyring::key_get("legendt2dmUser"),
#'   password = keyring::key_get("legendt2dmPassword"))
#'
#' # Run from db server (data download can take a long time)
#' LegendT2dmEvidenceExplorer::launchEvidenceExplorer(cohorts = "class",
#'                                                    connectionDetails = appConnectionDetails,
#'                                                    blind = TRUE)
#' }
#'
#' @export
launchEvidenceExplorer <- function(cohorts = "class",
                                   dataFolder = "data",
                                   dataFile = "PreMerged.RData",
                                   connectionDetails = NULL,
                                   blind = TRUE,
                                   aboutText = NULL,
                                   runOverNetwork = FALSE,
                                   port = 80,
                                   launch.browser = FALSE) {

  appDir = system.file("shiny", package = "LegendT2dmEvidenceExplorer")

  if (cohorts == "class") {
    headerText <- "LEGEND-T2DM Class Evidence"
    resultsDatabaseSchema <- "legendt2dm_class_results"
  } else {
    stop("Unknown cohorts")
  }

  if (!is.null(connectionDetails) &&
      connectionDetails$dbms != "postgresql") {
    stop("Shiny application can only run against a Postgres database")
  }
  if (!is.null(connectionDetails)) {
    dataFolder <- NULL
    dataFile <- NULL
    if (is.null(resultsDatabaseSchema)) {
      stop("resultsDatabaseSchema is required to connect to the database.")
    }
  }

  if (launch.browser) {
    options(shiny.launch.browser = TRUE)
  }

  if (runOverNetwork) {
    myIpAddress <- system("ipconfig", intern = TRUE)
    myIpAddress <- myIpAddress[grep("IPv4", myIpAddress)]
    myIpAddress <- gsub(".*? ([[:digit:]])", "\\1", myIpAddress)
    options(shiny.port = port)
    options(shiny.host = myIpAddress)
  }
  shinySettings <- list(
    connectionDetails = connectionDetails,
    resultsDatabaseSchema = resultsDatabaseSchema,
    dataFolder = dataFolder,
    dataFile = dataFile,
    aboutText = aboutText,
    headerText = headerText,
    blind = blind
  )
  .GlobalEnv$shinySettings <- shinySettings
  on.exit(rm("shinySettings", envir = .GlobalEnv))
  shiny::runApp(appDir = appDir)
}
