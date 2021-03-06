


#' Generate table of results with more than 2 columns, including sparkline bar graphs for percent data
#'
#' @param election_df data table of election results generated by wrangle_more_cols() function
#' @param graph_cols vector of character strings with names of columns containing original vote or percent results (not totals or margins)
#' @param show_pcts logical whether election_df data is showing percents as opposed to vote totals. Defaults to FALSE.
#' @param show_sparklines logical if you want table to include a column with mini bar charts. Defaults to TRUE.
#' @param pagination integer number of rows to display per page, defaults to 20
#' @param my_palette character string with colors to display in Winner and RunnerUp columns. Defaults to "none" for no color.
#'
#' @return
#' @export
#'
#' @examples
#' myfile <- system.file("extdata", "Fake3Columns.xlsx", package = "elections2")
#' mydata <- wrangle_more_cols(myfile, c("Red", "Blue", "Orange", "Green", "Purple"), show_pcts = TRUE)
#' quick_table_more_cols(mydata, c("Red", "Blue", "Orange", "Green", "Purple"), show_pcts = TRUE, my_palette = c("#DF536B", "#2297E6", "orange", "green", "purple"))

quick_table_more_cols <- function(election_df, graph_cols, show_pcts = FALSE, pagination = 20, show_sparklines = TRUE, use_regex_searching = TRUE, my_palette = c("none") ) {

  the_district_col <- names(election_df)[1]
  cols_to_format <- c(graph_cols, "Margin")
  if("MarginRunnerUp" %in% names(election_df)) {
    cols_to_format <- c(cols_to_format, "MarginRunnerUp")
  }
  if("Total" %in% names(election_df)) {
    cols_to_format <- c(cols_to_format, "Total")
  }

  my_format_function <- function(a_table, a_col_vector, a_num_format) {
    if(show_pcts) {
      a_table <- a_table %>%
        DT::formatPercentage(a_col_vector, digits = 1)
    } else {
      a_table <- a_table %>%
        DT::formatCurrency(a_col_vector, currency = '', digits = 0)
    }
    return(a_table)
  }


  if(show_sparklines) {
  election_df$Results <- NA
  election_df$Votes <- NA

  data.table::setDF(election_df)
  for(i in 1:nrow(election_df)){
    election_df$Votes[i] <- list(as.numeric(election_df[i, graph_cols]))
   election_df$Results[i] <- sparkline::spk_chr(unlist(election_df$Votes[i]), type = "bar", chartRangeMin = 0, chartRangeMax = max(unlist(election_df$Votes[i])) )
  }

  election_df$Votes <- NULL



  the_table <- DT::datatable(election_df, filter = 'top',
                             rownames = FALSE,
                             class = "stripe cell-border hover", escape = FALSE,
                             options = list(
                               pageLength = pagination,
                               search = list(regex = use_regex_searching),
                               fnDrawCallback = htmlwidgets::JS(
                                 '
function(){
  HTMLWidgets.staticRender();
}
'
                               )

                             )


)

  the_table <- my_format_function(the_table, cols_to_format, num_format) %>%
    sparkline::spk_add_deps()

  if("Total" %in% names(election_df)) {
    the_table <- the_table %>%
      DT::formatStyle(
        the_district_col,
        target = "row",
        fontWeight = DT::styleEqual("Total", "bold")
      )
  }

  } else {

    the_table <- DT::datatable(election_df, filter = 'top',
                               rownames = FALSE,
                               class = "stripe cell-border hover", escape = FALSE,
                               options = list(
                                 pageLength = pagination,
                                 search = list(regex = use_regex_searching)
                               )
    )

    the_table <- my_format_function(the_table, cols_to_format, num_format)

    if("Total" %in% names(election_df)) {
      the_table <- the_table %>%
          DT::formatStyle(
          the_district_col,
          target = "row",
          fontWeight = DT::styleEqual("Total", "bold")
        )
    }



  }

if(my_palette[1] != "none") {

  the_table <- the_table %>%
    DT::formatStyle(
      'Winner',
      backgroundColor = DT::styleEqual(graph_cols, my_palette)
    )

  if("RunnerUp" %in% names(election_df)) {

    the_table <- the_table %>%
      DT::formatStyle(
      'RunnerUp',
      backgroundColor = DT::styleEqual(graph_cols, my_palette)
    )
  }
}



return(the_table)

}


#
#   # PERCENT
#
#   if(num_format == "pct") {
#
#     election_df$Results <- NA
#
#     for(i in 1:nrow(election_df)){
#       election_df$Results[i] <- list(as.numeric(election_df[i, graph_cols]))
#     }
#
#     max_bar <- max(election_df[graph_cols], na.rm = TRUE)
#
#   reactable::reactable(election_df, bordered = TRUE, searchable = TRUE,
#                        showSortable = TRUE, showSortIcon = TRUE,
#                        defaultColDef = reactable::colDef(
#                          headerStyle = list(background = "#f7f7f8"),
#                          format = reactable::colFormat(percent = TRUE, digits = 1)
#                        ),
#                        columns = list(
#                          Results = reactable::colDef(cell = function(values) {
#                            sparkline::sparkline(values, type = "bar", chartRangeMin = 0, chartRangeMax = max_bar)
#                          })
#                        ),
#                        defaultPageSize = pagination
#   )
#
# } else {
#
#   # VOTES
#
#   election_df$Results <- NA
#
#   for(i in 1:nrow(election_df)){
#     election_df$Results[i] <- list(as.numeric(election_df[i, graph_cols]))
#   }
#
#   reactable::reactable(election_df, bordered = TRUE, searchable = TRUE,
#                        showSortable = TRUE, showSortIcon = TRUE,
#                        defaultColDef = reactable::colDef(
#                          headerStyle = list(background = "#f7f7f8"),
#                          format = reactable::colFormat(separators = TRUE)
#                        ),
#                        columns = list(
#                          Results = reactable::colDef(cell = function(values) {
#                            sparkline::sparkline(values, type = "bar", chartRangeMin = 0, chartRangeMax = max(values))
#                          })
#                        ),
#                        defaultPageSize = pagination
#   )
#
# }
#
# }
