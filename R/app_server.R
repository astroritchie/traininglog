#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny DT dplyr
#' @noRd

app_server <- function(input, output, session) {

  blankrow <- data.frame(
    Exercise = character(),
    Sets = character(),
    Reps = character(),
    Load = character(),
    RPE = character(),
    Notes = character()
  )

  rv_table <- reactiveVal(blankrow)

  observeEvent(input$workoutTable_cell_edit, {
    rv_table(editData(rv_table(), input$workoutTable_cell_edit, 'workoutTable'))
  })

  observeEvent(input$addButton, {
    t <- rv_table() %>%
      add_row(
        Exercise = '',
        Sets = '',
        Reps = '',
        Load = '',
        RPE = '',
        Notes = '')

    rv_table(t)
  })

  observeEvent(input$delButton, {
    t <- rv_table()

    if (!is.null(input$workoutTable_rows_selected)) {

      t <- t[-as.numeric(input$workoutTable_rows_selected),]
    }
    rv_table(t)
  })

  output$workoutTable <- DT::renderDataTable({
    datatable(
      rv_table(),
      editable = TRUE,
      selection = 'multiple')
  })

}
