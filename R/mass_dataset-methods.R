#' @rdname mass_dataset-class
#' @return message
#' @export
#' @importFrom methods show
setMethod(
  f = "show",
  signature = "mass_dataset",
  definition = function(object) {
    ###check again
    check_result = check_mass_dataset(
      expression_data = object@expression_data,
      sample_info = object@sample_info,
      variable_info = object@variable_info
    )
    if (check_result != "all good.") {
      cat(crayon::red(check_result, "\n"))
      cat(crayon::red(
        "You may changed the slots, try to use update_mass_dataset().\n"
      ))
    }
    cat(crayon::yellow(paste(rep("-", 20), collapse = ""), "\n"))
    cat(crayon::green("massdataset version:", object@version, "\n"))
    cat(crayon::yellow(paste(rep("-", 20), collapse = ""), "\n"))
    cat(crayon::green("1.expression_data:"))
    cat(
      "[",
      nrow(object@expression_data),
      "x",
      ncol(object@expression_data),
      "data.frame]\n"
    )
    cat(crayon::green("2.sample_info:"))
    cat("[",
        nrow(object@sample_info),
        "x",
        ncol(object@sample_info),
        "data.frame]\n")
    cat(crayon::green("3.variable_info:"))
    cat(
      "[",
      nrow(object@variable_info),
      "x",
      ncol(object@variable_info),
      "data.frame]\n"
    )
    cat(crayon::green("4.sample_info_note:"))
    cat(
      "[",
      nrow(object@sample_info_note),
      "x",
      ncol(object@sample_info_note),
      "data.frame]\n"
    )
    cat(crayon::green("5.variable_info_note:"))
    cat(
      "[",
      nrow(object@variable_info_note),
      "x",
      ncol(object@variable_info_note),
      "data.frame]\n"
    )
    cat(crayon::green("6.ms2_data:"))
    cat("[",
        sum(unlist(lapply(object@ms2_data, function(x) {
          length(unique(x@variable_id))
        }))),
        "variables x",
        sum(unlist(lapply(object@ms2_data, function(x) {
          length(unique(x@ms2_spectra))
        }))),
        "MS2 spectra]\n")
    cat(crayon::yellow(paste(rep("-", 20), collapse = ""), "\n"))
    cat(crayon::green("Processing information (extract_process_info())\n"))
    if (.hasSlot(object = object, name = "process_info") &
        length(object@process_info) != 0) {
      process_info <- object@process_info
      
      for (idx in 1:length(process_info)) {
        cat(crayon::green(names(process_info)[idx], paste(rep("-", 10), collapse = ""), "\n"))
        if (length(process_info[[idx]]) == 1) {
          data.frame(
            "Package" = process_info[[idx]]@pacakge_name,
            "Function used" = process_info[[idx]]@function_name,
            "Time" = process_info[[idx]]@time
          ) %>%
            print()
        } else{
          data.frame(
            "Package" = process_info[[idx]] %>% lapply(function(x)
              x@pacakge_name) %>% unlist(),
            "Function used" = process_info[[idx]] %>% lapply(function(x)
              x@function_name) %>% unlist(),
            "Time" = process_info[[idx]] %>% lapply(function(x)
              as.character(x@time)) %>% unlist()
          ) %>%
            print()
        }
      }
    } else{
      cat(crayon::red("There are no processing for your data.\n"))
    }
  }
)


#' @method dim mass_dataset
#' @param x x
#' @export
#' @rdname mass_dataset-class
#' @return message
dim.mass_dataset <- function(x) {
  dim(x@expression_data)
}


#' @method nrow mass_dataset
#' @param x x
#' @export
#' @rdname mass_dataset-class
#' @return message
nrow.mass_dataset <- function(x) {
  nrow(x@expression_data)
}


#' @method ncol mass_dataset
#' @param x x
#' @export
#' @rdname mass_dataset-class
#' @return message
ncol.mass_dataset <- function(x) {
  ncol(x@expression_data)
}

#' @method colnames mass_dataset
#' @param x x
#' @export
#' @rdname mass_dataset-class
#' @return message

setMethod(
  f = "colnames",
  signature = "mass_dataset",
  definition = function(x) {
    colnames(x@expression_data)
  }
)



#' @method rownames mass_dataset
#' @param x x
#' @export
#' @rdname mass_dataset-class
#' @return message

setMethod(
  f = "rownames",
  signature = "mass_dataset",
  definition = function(x) {
    rownames(x@expression_data)
  }
)


#' @method [ mass_dataset
#' @param x x
#' @param i i
#' @param j j
#' @param drop drop
#' @param .. ..
#' @export
#' @rdname mass_dataset-class
#' @return mass_dataset
`[.mass_dataset` <-
  function(x, i, j, drop = FALSE, ...) {
    if (missing(i) & missing(j)) {
      return(x)
    }
    
    if (!missing(i)) {
      if (is.character(i)) {
        i <- match(i, rownames(x@expression_data))
      }
    } else{
      i = 1:nrow(x@expression_data)
    }
    
    if (!missing(j)) {
      if (is.character(j)) {
        j <- match(j, colnames(x@expression_data))
      }
    } else{
      j = 1:ncol(x@expression_data)
    }
    
    if (sum(is.na(j)) > 0) {
      j = j[!is.na(j)]
      if (length(j) == 0) {
        j = 1:ncol(x)
        warning("All sample index (j) are not in the object. Please check.")
      } else{
        warning("Some sample index (j) are not in the object. Please check.")
      }
    }
    
    if (any(!j %in% 1:ncol(x))) {
      warning("Some sample index (j) are not in the object. Please check.")
      j = j[j %in% 1:ncol(x)]
    }
    
    if (sum(is.na(i)) > 0) {
      i = i[!is.na(i)]
      if (length(i) == 0) {
        i = 1:nrow(x)
        warning("Some variable index (i) are not in the object. Please check.")
      } else{
        warning("Some variable index (i) are not in the object. Please check.")
      }
      
    }
    
    if (any(!i %in% 1:nrow(x))) {
      warning("Some variable index (i) are not in the object. Please check.")
      i = i[i %in% 1:nrow(x)]
    }
    
    ###add paramters
    ####add parameters
    process_info = x@process_info
    
    parameter <- new(
      Class = "tidymass_parameter",
      pacakge_name = "massdataset",
      function_name = "[",
      parameter = list("i" = i,
                       "j" = j),
      time = Sys.time()
    )
    
    if (all(names(process_info) != "Subset")) {
      process_info$Subset = parameter
    } else{
      process_info$Subset = c(process_info$Subset, parameter)
    }
    
    object@process_info = process_info
    
    x@expression_data = x@expression_data[i, j, drop = drop]
    x@sample_info = x@sample_info[j, , drop = FALSE]
    x@variable_info = x@variable_info[i, , drop = FALSE]
    return(x)
  }


#' @method apply mass_dataset
#' @param X X
#' @param MARGIN MARGIN
#' @param FUN FUN
#' @param ... ...
#' @param simplify simplify
#' @export
#' @rdname mass_dataset-class
#' @return result

setMethod(
  f = "apply",
  signature = "mass_dataset",
  definition = function(X, MARGIN, FUN, ..., simplify = TRUE) {
    apply(as.matrix(X@expression_data), MARGIN, FUN, ..., simplify = TRUE)
  }
)



#' @method log mass_dataset
#' @param x x
#' @param base base
#' @export
#' @rdname mass_dataset-class
#' @return mass_dataset object

setMethod(
  f = "log",
  signature = "mass_dataset",
  definition = function(x, base = exp(1)) {
    expression_data = x@expression_data
    
    expression_data = log(expression_data, base = base)
    
    x@expression_data = expression_data
    
    process_info = x@process_info
    
    parameter <- new(
      Class = "tidymass_parameter",
      pacakge_name = "base",
      function_name = "log()",
      parameter = list("base" = base),
      time = Sys.time()
    )
    
    if (all(names(process_info) != "log")) {
      process_info$log = parameter
    } else{
      process_info$log = c(process_info$log, parameter)
    }
    
    x@process_info = process_info
    
    return(x)
  }
)





#' @method scale mass_dataset
#' @param x x
#' @param base base
#' @export
#' @rdname mass_dataset-class
#' @return mass_dataset object

setMethod(
  f = "scale",
  signature = "mass_dataset",
  definition = function(x, center = TRUE, scale = TRUE) {
    expression_data = x@expression_data
    
    expression_data = scale(t(expression_data), center = center,
                            scale = scale) %>%
      t() %>%
      as.data.frame()
    
    x@expression_data = expression_data
    
    process_info = x@process_info
    
    parameter <- new(
      Class = "tidymass_parameter",
      pacakge_name = "base",
      function_name = "scale()",
      parameter = list("center" = center,
                       "scale" = scale),
      time = Sys.time()
    )
    
    if (all(names(process_info) != "scale")) {
      process_info$scale = parameter
    } else{
      process_info$scale = c(process_info$scale, parameter)
    }
    
    x@process_info = process_info
    
    return(x)
  }
)



#' @method intersect mass_dataset
#' @param x x
#' @param y y
#' @export
#' @rdname mass_dataset-class
#' @return mass_dataset object

setMethod(
  f = "intersect",
  signature = "mass_dataset",
  definition = function(x, y) {
    intersect(x@sample_info$sample_id,
              y@sample_info$sample_id)
  }
)

#' @method cbind mass_dataset
#' @param x x
#' @param y y
#' @param deparse.level deparse.level
#' @export
#' @rdname mass_dataset-class
#' @return mass_dataset

cbind.mass_dataset = function(x, y, deparse.level = 1) {
  if (nrow(x@variable_info) != nrow(y@variable_info)) {
    stop("rownames(x) should be same with rownames(y).\n")
  }
  
  if (any(rownames(x) != rownames(y))) {
    stop("rownames(x) should be same with rownames(y).\n")
  }
  
  expression_data_x = x@expression_data
  expression_data_y = y@expression_data
  
  sample_info_x = x@sample_info
  sample_info_y = y@sample_info
  
  sample_info_note_x = x@sample_info_note
  sample_info_note_y = y@sample_info_note
  
  variable_info_x = x@variable_info
  variable_info_y = y@variable_info
  
  variable_info_note_x = x@variable_info_note
  variable_info_note_y = y@variable_info_note
  
  colnames(expression_data_y) =
    purrr::map(colnames(expression_data_y), function(x) {
      if (any(x == colnames(expression_data_x))) {
        paste(x, 2, sep = "_")
      } else{
        x
      }
    }) %>%
    unlist()
  
  sample_info_y$sample_id = colnames(expression_data_y)
  
  expression_data = cbind(expression_data_x, expression_data_y)
  
  sample_info =
    sample_info_x %>%
    dplyr::full_join(sample_info_y,
                     by = intersect(colnames(sample_info_x), colnames(sample_info_y)))
  
  expression_data =
    expression_data[, sample_info$sample_id]
  
  #####sample_info_note
  if (nrow(sample_info_note_x) != 0 |
      nrow(sample_info_note_y) != 0) {
    sample_info_note =
      rbind(sample_info_note_x,
            sample_info_note_y) %>%
      dplyr::distinct(name, .keep_all = TRUE)
  } else{
    sample_info_note = sample_info_note_x
  }
  
  ####variable_info
  variable_info =
    variable_info_x %>%
    dplyr::left_join(variable_info_y, by = intersect(colnames(variable_info_x),
                                                     colnames(variable_info_y)))
  
  if (nrow(variable_info_note_x) != 0 |
      nrow(variable_info_note_y) != 0) {
    variable_info_note =
      rbind(variable_info_note_x,
            variable_info_note_y) %>%
      dplyr::distinct(name, .keep_all = TRUE)
  } else{
    variable_info_note = variable_info_note_x
  }
  
  object <- new(
    Class = "mass_dataset",
    expression_data = expression_data,
    ms2_data = data.frame(),
    sample_info = sample_info,
    variable_info = variable_info,
    sample_info_note = sample_info_note,
    variable_info_note = variable_info_note,
    process_info = c(x@process_info, y@process_info),
    version = massdataset_version
  )
  
  return(object)
}






#' @method rbind mass_dataset
#' @param x x
#' @param y y
#' @param deparse.level deparse.level
#' @export
#' @rdname mass_dataset-class
#' @return mass_dataset

rbind.mass_dataset = function(x, y, deparse.level = 1) {
  if (nrow(x@sample_info) != nrow(y@sample_info)) {
    stop("rownames(x) should be same with rownames(y).\n")
  }
  
  if (any(colnames(x) != colnames(y))) {
    stop("rownames(x) should be same with rownames(y).\n")
  }
  
  expression_data_x = x@expression_data
  expression_data_y = y@expression_data
  
  sample_info_x = x@sample_info
  sample_info_y = y@sample_info
  
  sample_info_note_x = x@sample_info_note
  sample_info_note_y = y@sample_info_note
  
  variable_info_x = x@variable_info
  variable_info_y = y@variable_info
  
  variable_info_note_x = x@variable_info_note
  variable_info_note_y = y@variable_info_note
  
  rownames(expression_data_y) =
    purrr::map(rownames(expression_data_y), function(x) {
      if (any(x == rownames(expression_data_x))) {
        paste(x, 2, sep = "_")
      } else{
        x
      }
    }) %>%
    unlist()
  
  variable_info_y$variable_id = rownames(expression_data_y)
  
  expression_data = rbind(expression_data_x, expression_data_y)
  
  sample_info_y = 
    sample_info_y %>% 
    dplyr::select(-sample_id)
  
  sample_info_note_y = 
    sample_info_note_y %>% 
    dplyr::filter(!name %in% "sample_id")
  
  colnames(sample_info_y) = 
  colnames(sample_info_y) %>% 
    purrr::map(function(x){
      if(x %in% colnames(sample_info_x)){
        x = paste(x, 2, sep = "_")
        x
      }else{
        x
      }
    }) %>% 
    unlist()
  
  sample_info_note_y$name = colnames(sample_info_y)
  
  sample_info =
    cbind(sample_info_x,
          sample_info_y)
  
  expression_data =
    expression_data[, sample_info$sample_id]
  
  #####sample_info_note
    sample_info_note =
      rbind(sample_info_note_x,
            sample_info_note_y) %>%
      dplyr::distinct(name, .keep_all = TRUE)
   
  ####variable_info
  variable_info =
    variable_info_x %>%
    dplyr::full_join(variable_info_y, by = intersect(colnames(variable_info_x),
                                                     colnames(variable_info_y)))

    variable_info_note =
      rbind(variable_info_note_x,
            variable_info_note_y) %>%
      dplyr::distinct(name, .keep_all = TRUE)

  
  object <- new(
    Class = "mass_dataset",
    expression_data = expression_data,
    ms2_data = data.frame(),
    sample_info = sample_info,
    variable_info = variable_info,
    sample_info_note = sample_info_note,
    variable_info_note = variable_info_note,
    process_info = c(x@process_info, y@process_info),
    version = massdataset_version
  )
  
  return(object)
}
