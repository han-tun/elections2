# elections2
Wrangle and Visualize Election Data 
Easily analyze your election results data with the election2 package. One command calculates winners and percents for each election district row as well as overall totals.

Then, take those results and turn them into interactive tables, bar charts, and maps with functions like `bargraph_of_margins()`, `quick_table()`, and `map_election_results()`.

election2 is designed for journalists, hobbyists, analysts, and data geeks who want to quickly go from a spreadsheet or CSV file with raw vote totals to visualizations that help you see trends behind the data.

Note: This package is not on CRAN, so you need to install it from GitHub with the R package and function of your choice, such as

`devtools::install_github("smach/elections2", build_vignettes = TRUE)`

## Data wrangling

Start with a function to wrangle a spreadsheet or CSV file with basic results. You've got two options: `wrangle_results()` to generate detailed results from a file with only two candidates or choices; and `wrangle_more_cols()` for results with more than two choices.

### Data with only 2 choices

`wrangle_results()` assumes you want to compare the performance of only two candidates (which means ignoring third parties, write-ins, and blanks) or a yes-no ballot question. 

It returns information for each row and total on the winner, percents, and percent and vote margins when there are only two choices your election data. The function also includes a turnout_columns option if the data includes columns for vote totals and total registered voters in order to calculate turnout percentage.

After running wrangle_results() on your data, you can use the resulting data frame in this package's visualization functions to create tables, bar graphs, and maps.

#### Data format

If turnout_columns = FALSE, the election results file _must_ be in the following 3-column format:

<ul><li>Column 1 should be the election districts (such as precinct, city, county, etc.).</li><br />
<li>Columns 2 and 3 should be the candidates' names, "Yes" and "No" for ballot questions, etc. The values should be _raw vote totals_ and not percents.</li></br />

Do _not_ include any column or row totals in the file!

If you want to include turnout data, set turnout_columns = TRUE and include total number of votes in column 4 and total number of registered voters in column 5. _Don't_ include a column for turnout percent, as this will be calculated by wrangle_results().

```{r import_results}
library(elections2)
results_file <- system.file("extdata", "FakeElectionResults.xlsx", package = "elections2")

my_election_data <- wrangle_results(results_file)

```

The resulting data frame will include a Total row for use in generating tables. This package's dataviz functions will remove the Total row if it exists, as long as you keep the name as 'Total'.

It will be in a format such as

```{r viewdata }
head(my_election_data, n = 3)

```

### Data with 3 or more choices

To analyze and visualize election results with three or more choices -- a crowded primary or a multi-party election, for example -- use the `wrangle_more_cols()` function. 

The data spreadsheet or CSV should have the election district (precinct, city, etc.) in the first column. Vote totals (for candidates, parties, etc.) should be one column for each option. Don't include a total row or column, since those will be calculated.

`wrangle_more_cols()` has two required arguments: the file name and a vector of character strings with all the vote columns by candidate/party/option. the starting column with results, and the ending column with results. 

The function also has four optional logical arguments: show_pcts to return results as percents instead of total votes, show_runnerup to include a column with the 2nd-place finisher, show_margin to display a column with the difference between the 1st- and 2nd-place finishers, and show_margin_2vs3 to show the difference between the 2nd- and 3rd-place finishers.

## Visualizations

**Interactive tables** Use the `quick_table()` or `quick_table_more_cols()` functions. See the tables vignette with `vignette("tables", package = "elections2")` for more.

**Bar charts** Use the `bar_graph_of_winner_pct_margins()` function. See the barcharts vignette with `vignette("barcharts", package = "elections2")` for more info.

**Election results maps** See the maps vignette: `vignette("maps", package = "elections2")

**Turnout maps** See the turnout maps vignette: `vignette("map_turnout", package = "elections2")



