#' @title Add NA number for each feature to variable_info
#' @description Add NA number for each feature to variable_info
#' @author Xiaotao Shen
#' \email{shenxt1990@@outlook.com}
#' @param object (required) mass_dataset class object.
#' @param show_row_names show_row_names. see?ComplexHeatmap::Heatmap
#' @param show_column_names show_column_names see?ComplexHeatmap::Heatmap
#' @param column_names_rot column_names_rot see?ComplexHeatmap::Heatmap
#' @param cell_color cell color
#' @param row_names_side row names side
#' @param percentage percentage or not
#' @param ... Other parameters for ComplexHeatmap::Heatmap
#' @return A ggplot2 object
#' @export
#' @examples
#' library(massdataset)
#' library(plyr)
#' data("expression_data")
#' data("sample_info")
#' data("variable_info")
#' 
#' object =
#'   create_mass_dataset(
#'     expression_data = expression_data,
#'     sample_info = sample_info,
#'     variable_info = variable_info,
#'   )
#' 
#' object
#' 
#' ##show missing values plot
#' show_missing_values(object)
#' 
#' show_missing_values(object[1:10,], cell_color = "white")
#' 
#' ###only show subject samples
#' object %>%
#'   activate_mass_dataset(what = "sample_info") %>%
#'   filter(class == "Subject") %>%
#'   show_missing_values()
#' 
#' ###only show QC samples
#' object %>%
#'   activate_mass_dataset(what = "expression_data") %>%
#'   dplyr::select(contains("QC")) %>%
#'   show_missing_values()
#' 
#' ###only show features with mz < 100
#' object %>%
#'   activate_mass_dataset(what = "variable_info") %>%
#'   dplyr::filter(mz < 100) %>%
#'   show_missing_values(cell_color = "white",
#'                       show_row_names = TRUE,
#'                       row_names_side = "left", 
#'                       percentage = TRUE)

show_missing_values =
  function(object,
           show_row_names = FALSE,
           show_column_names = TRUE,
           column_names_rot,
           cell_color = "transparent",
           row_names_side = "right",
           percentage = FALSE,
           ...) {
    check_object_class(object = object, class = "mass_dataset")
    if (missing(column_names_rot)) {
      column_names_rot = 45
    }
    
    expression_data = object@expression_data
    
    sample_na = apply(expression_data, 2, function(x) {
      sum(is.na(x))
    })
    
    variable_na = apply(expression_data, 1, function(x) {
      sum(is.na(x))
    })
    
    if(percentage){
      sample_na = sample_na * 100/ nrow(expression_data)
      variable_na = variable_na * 100 / ncol(expression_data)
    }
    
    expression_data[!is.na(expression_data)] = "2"
    expression_data[is.na(expression_data)] = "1"
    colors = structure(c("1", "2"), names = c("1", "2"))
    
    plot =
      suppressMessages(
        ComplexHeatmap::Heatmap(
          as.matrix(expression_data),
          name = "MV",
          cluster_columns = FALSE,
          cluster_rows = FALSE,
          show_row_names = show_row_names,
          show_column_names = show_column_names,
          column_names_rot = 45,
          col = colors,
          rect_gp = gpar(col = cell_color),
          show_heatmap_legend = FALSE,
          row_names_side = row_names_side,
          top_annotation =
            ComplexHeatmap::columnAnnotation("MV" = ComplexHeatmap::anno_barplot(
              x = sample_na,
              gp = gpar(col = "black",
                        fill = ggsci::pal_lancet()(n = 9)[4])
            ),
            name = ifelse(percentage, "MV(%)", "MV number")), 
          right_annotation = 
            ComplexHeatmap::rowAnnotation("MV" = ComplexHeatmap::anno_barplot(
              x = variable_na,
              gp = gpar(col = ggsci::pal_lancet()(n = 9)[2],
                        fill = ggsci::pal_lancet()(n = 9)[2])
            ), name = ifelse(percentage, "MV(%)", "MV number"))
        ) 
      )
    
    plot = ggplotify::as.ggplot(plot)
    
    return(plot)
  }








#' @title show_sample_missing_values
#' @description show_sample_missing_values
#' @author Xiaotao Shen
#' \email{shenxt1990@@outlook.com}
#' @param object (required) mass_dataset class object.
#' @param color_by which column (sample_info) is used to color samples
#' @param order_by which column (sample_info) is used to order samples
#' @param percentage show MV percentage?
#' @param desc desc
#' @return A ggplot2 object
#' @export
#' @examples
#' library(massdataset)
#' library(plyr)
#' data("expression_data")
#' data("sample_info")
#' data("variable_info")
#'
#' object =
#'   create_mass_dataset(
#'     expression_data = expression_data,
#'     sample_info = sample_info,
#'     variable_info = variable_info,
#'   )
#'
#' object
#'
#' ##show missing values plot
#' show_sample_missing_values(object)
#' show_sample_missing_values(object, color_by = "class")
#' show_sample_missing_values(object, color_by = "class", order_by = "na")
#' show_sample_missing_values(object, color_by = "class", order_by = "na",
#'                            desc = TRUE)


show_sample_missing_values =
  function(object,
           color_by,
           order_by,
           percentage = FALSE,
           desc = FALSE) {
    check_object_class(object = object, class = "mass_dataset")
    
    if (missing(color_by)) {
      color_by = "no"
    } else{
      if (all(colnames(object@sample_info) != color_by)) {
        stop("no ", color_by, " in sample_info, please check.\n")
      }
    }
    
    if (missing(order_by)) {
      order_by = "sample_id"
    } else{
      if (all(colnames(object@sample_info) != order_by) &
          order_by != "na") {
        stop("no ", order_by, " in sample_info, please check.\n")
      }
    }
    
    expression_data = object@expression_data
    sample_info = object@sample_info
    
    na =
      apply(expression_data, 2, function(x) {
        sum(is.na(x))
      })
    
    if (percentage) {
      na = na * 100 / nrow(expression_data)
    }
    
    if (desc) {
      temp_data =
        data.frame(sample_info, na = na) %>%
        dplyr::arrange(desc(get(order_by))) %>%
        dplyr::mutate(sample_id = factor(sample_id,
                                         levels = sample_id))
      
    } else{
      temp_data =
        data.frame(sample_info, na = na) %>%
        dplyr::arrange(get(order_by)) %>%
        dplyr::mutate(sample_id = factor(sample_id,
                                         levels = sample_id))
    }
    
    
    plot =
      temp_data %>%
      ggplot2::ggplot(aes(sample_id, na)) +
      guides(color = guide_legend(title = color_by),
             size = guide_legend(title = ifelse(
               percentage, "MV percentage (%)", "MV number"
             ))) +
      labs(x = "",
           y = ifelse(percentage, "MV percentage (%)", "MV number")) +
      theme_bw() +
      theme(
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(
          angle = 45,
          hjust = 1,
          vjust = 1
        )
      )
    
    if (color_by == "no") {
      plot =
        plot +
        ggplot2::geom_point(aes(size = na))
    } else{
      plot =
        plot +
        ggplot2::geom_point(aes(size = na, color = get(color_by)))
    }
    
    return(plot)
  }










#' @title show_variable_missing_values
#' @description show_variable_missing_values
#' @author Xiaotao Shen
#' \email{shenxt1990@@outlook.com}
#' @param object (required) mass_dataset class object.
#' @param color_by which column (variable_info) is used to color variables
#' @param order_by which column (variable_info) is used to order variables
#' @param percentage show MV percentage?
#' @param show_x_text show_x_text
#' @param show_x_ticks show_x_ticks
#' @param desc desc
#' @return A ggplot2 object
#' @export
#' @examples
#' library(massdataset)
#' library(plyr)
#' library(tidyverse)
#' data("expression_data")
#' data("variable_info")
#' data("variable_info")
#'
#' object =
#'   create_mass_dataset(
#'     expression_data = expression_data,
#'     sample_info = sample_info,
#'     variable_info = variable_info,
#'   )
#'
#' object
#'
#' ##show missing values plot
#' show_variable_missing_values(object)
#' show_variable_missing_values(object, color_by = "mz")
#'
#' show_variable_missing_values(object, color_by = "rt") +
#'   scale_color_gradient(low = "skyblue", high = "red")
#'
#' show_variable_missing_values(object, color_by = "mz",
#'                              order_by = "na")
#' show_variable_missing_values(object, color_by = "mz",
#'                              order_by = "na",
#'                            desc = TRUE, percentage = TRUE)



show_variable_missing_values =
  function(object,
           color_by,
           order_by,
           percentage = FALSE,
           show_x_text = FALSE,
           show_x_ticks = FALSE,
           desc = FALSE) {
    check_object_class(object = object, class = "mass_dataset")
    
    if (missing(color_by)) {
      color_by = "no"
    } else{
      if (all(colnames(object@variable_info) != color_by)) {
        stop("no ", color_by, " in variable_info, please check.\n")
      }
    }
    
    if (missing(order_by)) {
      order_by = "variable_id"
    } else{
      if (all(colnames(object@variable_info) != order_by) &
          order_by != "na") {
        stop("no ", order_by, " in variable_info, please check.\n")
      }
    }
    
    expression_data = object@expression_data
    variable_info = object@variable_info
    
    na =
      apply(expression_data, 1, function(x) {
        sum(is.na(x))
      })
    
    if (percentage) {
      na = na * 100 / ncol(expression_data)
    }
    
    if (desc) {
      temp_data =
        data.frame(variable_info, na = na) %>%
        dplyr::arrange(desc(get(order_by))) %>%
        dplyr::mutate(variable_id = factor(variable_id,
                                           levels = variable_id))
      
    } else{
      temp_data =
        data.frame(variable_info, na = na) %>%
        dplyr::arrange(get(order_by)) %>%
        dplyr::mutate(variable_id = factor(variable_id,
                                           levels = variable_id))
    }
    
    
    plot =
      temp_data %>%
      ggplot2::ggplot(aes(variable_id, na)) +
      guides(color = guide_legend(title = color_by),
             size = guide_legend(title = ifelse(
               percentage, "MV percentage (%)", "MV number"
             ))) +
      labs(x = "",
           y = ifelse(percentage, "MV percentage (%)", "MV number")) +
      theme_bw() +
      theme(panel.grid = element_blank(),
            axis.text.x = element_text(
              angle = 45,
              hjust = 1,
              vjust = 1
            ))
    
    if (!show_x_text) {
      plot =
        plot +
        theme(axis.text.x = element_blank()) +
        labs(x = "Variables")
    }
    
    if (!show_x_ticks) {
      plot =
        plot +
        theme(axis.ticks.x = element_blank())
    }
    
    if (color_by == "no") {
      plot =
        plot +
        ggplot2::geom_point(aes(size = na))
    } else{
      plot =
        plot +
        ggplot2::geom_point(aes(size = na, color = get(color_by))) +
        guides(color = guide_legend(title = color_by))
    }
    
    return(plot)
  }
