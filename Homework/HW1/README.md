
## Homework 1: Data Wrangling
### Due 9/28/2020 by 11:59pm EST


The 2009 H1N1 influenza pandemic, known more colloquially as the swine flu, swept much of the world between April 2009 and August 2010. First detected in the United States, the novel A(H1N1)pdm09 virus is most closely related to the North American swine-lineage H1N1 and Eurasian lineage swine-origin H1N1 influenza viruses. Unlike most seasonal influenza strains, it does not disproportionately infect adults older than 65. A vaccine was quickly developed and widely distributed by the late fall of 2009, but A(H1N1)pdm09 continues to circulate as a seasonal flu virus [[source]](https://www.cdc.gov/flu/pandemic-resources/2009-h1n1-pandemic.html). 

In this homework, we will be scraping and analyzing data from the Wikipedia article "2009 swine flu pandemic tables". The live link is available [here](https://en.wikipedia.org/wiki/2009_swine_flu_pandemic_tables), but for the purpose of this assignment, please use the permalink https://en.wikipedia.org/w/index.php?title=2009_swine_flu_pandemic_tables&oldid=950511922, which points to the most recent revision at the time of this writing. 

The web page summarizes country-level information in two tables, one for A(H1N1)pdm09 cases and one for A(H1N1)pdm09 deaths. From April until July 5, 2009, the data was taken from the *Influenza A(H1N1) updates* issued roughly once every other day by the World Health Organization (WHO) [[source]](https://www.who.int/csr/disease/swineflu/updates/en/). Thereafter, the data was taken from the European Centre for Disease Prevention and Control (ECDC)'s *situation reports on Influenza A(H1N1)v*, which were published roughly three times a week [[archived source]](https://web.archive.org/web/20090812212650/http://www.ecdc.europa.eu/en/Health_topics/novel_influenza_virus/2009_Outbreak/). The ECDC stopped publishing case counts after August 9, 2009.   

Variables in the **Swine flu cases to date** table: 

- **By date**: Used for sorting rows by date of first confirmed case
- **By cont.**: Used for sorting rows by date of first confirmed case by continent
- **Country or territory**: Country name
- **First case**: Date of first confirmed A(H1N1)pdm09 case in the country, YYYY-MM-DD format
- **April**, **May**, **June**, **July**, **August**: Total number of confirmed A(H1N1)pdm09 cases on the first reported day of that month in 2009
- **Latest (9 August)**: Total number of confirmed cases on August 9, 2009, the last day that the ECDC published A(H1N1)pdm09 case totals

Variables in the **Swine flu deaths** table: 

- **By date**: Used for sorting rows by date of first confirmed death
- **By cont.**: Used for sorting rows by date of first confirmed death by continent
- **Country**: Country name
- **First death**: Date of first A(H1N1)pdm09 death in the country, YYYY-MM-DD format
- **May**, **Jun**, **Jul**, **Aug**, **Sep**, **Oct**, **Nov**, **Dec**:  Total number of A(H1N1)pdm09 deaths on the first reported day of that month in 2009


1. Use the `rvest` package to extract the table of case counts from the Wikipedia page, save it as a data frame called `cases_df`, and set the column names to the names supplied in the `case_names` vector. Then, extract the table of death counts, save it as a data frame called `deaths_df`, and set the column names to the names in `death_names`. As a sanity check, `cases_df` should have 177 rows and 10 columns, and `deaths_df` should have 125 rows and 13 columns. Hint: The `tab` variable contains all of the table elements in the Wikipedia article. Print it out and try to assess which index corresponds to the cases table and which index corresponds to the deaths table. 

```{r, message=FALSE, warning=FALSE}
library(tidyverse)
library(rvest)
library(lubridate)
```

```{r}
# Wikipedia article to scrape
url = "https://en.wikipedia.org/w/index.php?title=2009_swine_flu_pandemic_tables&oldid=950511922"

# Extract all tables in the page
tab = read_html(url) %>% html_nodes("table")

# Variable names to use for the table of case counts
case_names = c("by_date", "by_continent", "country", "first_case",
                "April", "May", "June", "July", "August", "latest")

# Variable names to use for the table of death counts
death_names = c("by_date", "by_continent", "country", "first_death",
                 "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
```

```{r}
# Your code here
```


2. The first three rows of `cases_df` and the first two rows of `deaths_df` do not contain country-level information. (You can see this in the tables on the Wikipedia page, or you can check by running the `head` function on `cases_df` and `deaths_df`.) Drop these rows from your data frames. 

```{r}
# Your code here
```


3. The `first_case` column in the `cases_df` data frame contains the date of the first confirmed case in YYYY-MM-DD format, but it is stored as a character variable. Convert `first_case` to a date type variable. 

```{r}
# Your code here
```


4. Make a scatterplot of the number of cases reported by August 9, 2009 (the `later` variable in `cases_df`) plotted against the date of the first confirmed case (the `first_case` variable, which you converted to a date type in Question 3). Based on this figure, would you say that the date of the first case is a good predictor for the number of cases on August 9?

```{r}
# Your code here
```


5. Reshape `cases_df` into a new data frame called `long_cases_df` by gathering the month columns `c("April", "May", "June", "July", "August")`. Set the month column names to a new variable in the data called `month`, and set the column cells (the cases for each month) to a new variable called `cases`. When you are done, `long_cases_df` should have two new columns (`month` and `cases`) and no columns that are named after months. 

   Similarly, reshape `deaths_df` into a new data frame called `long_deaths_df` by gathering the month columns `c("Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")`. Set the month column names to a new variable called `month`, and set the column cells (the deaths for each month) to a new variable called `deaths`. 

```{r}
# Your code here
```


6. In Question 7, we will combine `long_cases_df` with `long_deaths_df` to make a new data frame. But before we do that, we want to make the variables in the two data frames more consistent with each other. 

   Extract the first three letters of the month names in the `month` variable in `long_cases_df`. Replace the `month` variable with these three-letter abbreviations. Hint: Use the `str_sub` function. 

   In `long_deaths_df`, recode "USA" in the `country` variable as "United States of America". 

```{r}
# Your code here
```


7. Use the `inner_join` function to combine `long_cases_df` and `long_deaths_df` by country and month. Save the result as a new data frame called `combined_df`. 

   Optional: Clean up `combined_df` by keeping only the relevant columns: `country`, `month`, `cases`, and `deaths`. 

```{r}
# Your code here
```


8. Subset `combined_df` so that it only contains observations from the month of August, and drop all rows that contain missing values. Assign the result to a new data frame and report the number of rows it has. Hint: If you are working in the tidyverse, you can use the `drop_na` function to drop all rows that contain NAs.

```{r}
# Your code here
```


9. Using your subsetted data frame from Question 8, plot the number of deaths against the number of cases reported by August 2009. Describe the relationship between the two variables. 

   Optional: Can you comment on a few specific countries and whether or not they seem to be following the general trend (perhaps by labeling some of the points in your plot or by making a table)?

```{r}
# Your code here
```


10. Discuss the reliability of the A(H1N1)pdm09 data used in this assignment. This is an open-ended question, but if you are unsure of how to start, here are some points that you could consider: 

- Do you trust the data sources? 
- Is it problematic that the tables pull numbers from two different reporting sources?
- How difficult is it to confirm an A(H1N1)pdm09 case or death? 
- Do you expect the same level of reporting accuracy in all countries? 
- Do you expect the reported counts to be overestimates or underestimates of the true values?
- What other information (on data collection/reporting, or additional variables) would be useful to help you assess data reliability? 

Please limit your response to no more than 1-2 paragraphs. You do not need to use outside sources, but if you do, be sure to cite them. 

*Your answer here (no code required)*
