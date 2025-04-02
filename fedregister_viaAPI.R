# Source site:
# https://www.federalregister.gov/presidential-documents/executive-orders
# API docs:
# https://www.federalregister.gov/developers/documentation/api/v1

library(tidyverse)
library(lubridate)
library(janitor)
library(here)
library(fs)
library(httr2)
library(jsonlite)


# IRS rules and proposed rules since Jan 20:

# Web site:
# https://www.federalregister.gov/documents/search?conditions%5Bagencies%5D%5B%5D=treasury-department&conditions%5Bpublication_date%5D%5Bgte%5D=01%2F20%2F2025&conditions%5Btype%5D%5B%5D=PRORULE&conditions%5Btype%5D%5B%5D=RULE
# API:
# https://www.federalregister.gov/api/v1/documents.json?conditions%5Bagencies%5D%5B%5D=treasury-department&conditions%5Bpublication_date%5D%5Bgte%5D=01%2F20%2F2025&conditions%5Btype%5D%5B%5D=PRORULE&conditions%5Btype%5D%5B%5D=RULE


# define the api endpoint
api_url <- "https://www.federalregister.gov/api/v1/documents.json?conditions%5Bagencies%5D%5B%5D=treasury-department&conditions%5Bpublication_date%5D%5Bgte%5D=01%2F20%2F2025&conditions%5Btype%5D%5B%5D=PRORULE&conditions%5Btype%5D%5B%5D=RULE"


# create the request object
req <- request(api_url)

# perform the request
resp <- req_perform(req)

# parse the response into a string
resp_text <- resp_body_string(resp)

# parse the text as json, flattening nested structures
parsed_json <- fromJSON(resp_text, flatten = TRUE)

# check how many results are returned
cat("Number of results:", parsed_json$count, "\n")

# extract dataframe
fedregister_df <- as_tibble(parsed_json$results)

head(fedregister_df)
glimpse(fedregister_df)



# HANDLING FOR FILE SAVING & ARCHIVING ######

# save current version as csv and rds
saveRDS(fedregister_df, "data/source/fedregister/fedreg.rds")
write_csv(fedregister_df, "data/source/fedregister/fedreg.csv", na = "")
