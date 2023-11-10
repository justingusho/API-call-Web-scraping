

# API call

##### Research the WDI indicator ID of GDP per capita measured in current USD via the WDI R library or on the World Bank website

##### Write a HTTP request to find out how many rows of data are available for “GDP per capita measured in current USD” between 2000 and 2020 and to inspect the data types of the following variables: country code in ISO3, year, GDP value

##### Retrieve all of the data with a loop and store the results in a data frame using 100 rows per page. Store the data in a data frame - you only need to store the country code, year and GDP value
```{r}

library(WDI)


WDI_matrix <- WDIsearch("GDP per capita")
WDI_matrix

library(httr)
library(jsonlite)

WDI_request <- GET(url = "http://api.worldbank.org/v2/countries/all/indicators/NY.GDP.PCAP.CD?per_page=100&format=json&date=2000:2020")
WDI_content <- content(WDI_request, as = "text")
WDI_parsed <- fromJSON(WDI_content)

WDI_df <- WDI_parsed[[2]]
subset(WDI_df, select = c("countryiso3code", "date", "value"))

results <- data.frame()

pages <- 56
WDI_df <- data.frame(countryiso3code= character(),date= character(), value=double())
for (i in 1:pages) {
  url_page = paste("http://api.worldbank.org/v2/countries/all/indicators/NY.GDP.PCAP.CD?per_page=100&format=json&date=2000:2020&page=",i, sep = "")
  WDI_request <- GET(url = url_page)
  WDI_content <- content(WDI_request, as ="text")
  WDI_parsed <- fromJSON(WDI_content)
  WDI_df <-  subset(WDI_parsed[[2]], select = c("countryiso3code", "date", "value"))
  results <- rbind(results, WDI_df)
}
# Web scraping

##### Scrape the contact information (green box on the right) of our examination office (https://pruefungsamt.wiwi.uni-halle.de) and of the international office (https://www.international.uni-halle.de/international_office) off their websites. Store both results in a list. You do not need to clean or format the information

##### In a second step, store both URLs in a list and try to loop through it to collect the contact information of every URL on the list. Check if your loop works by adding another MLU webpage (with contact info in the green box) to your list


```{r}
library(rvest)
rvest_request <-  read_html("https://pruefungsamt.wiwi.uni-halle.de")
rvest_html <- html_element(rvest_request, css = "div.rechts")
rvest_html_p <- html_element(rvest_request, css = "p")
rvest_content <- html_text2(rvest_html_p)


print(rvest_content)

url_list <- list("https://pruefungsamt.wiwi.uni-halle.de", "https://www.international.uni-halle.de/international_office" )
url_number <- length(url_list)

contact_list <- list()

for (i in 1:url_number) {
  rvest_request <- read_html(url_list[[i]])
  rvest_content <- rvest_request %>% html_elements("div.rechts") %>% html_elements("p") %>% html_text2()
  contact_list[[i]] <- rvest_content
}
 
contact_list
