

##S4 class for parameter
#' An S4 class that stores the parameters
#' @title tidymass_parameter
#' @name tidymass_parameter
#' @docType class
#' @slot pacakge_name pacakge_name
#' @slot function_name function_name
#' @slot parameter parameter
#' @slot time time
#' @exportClass tidymass_parameter
setClass(
  Class = "tidymass_parameter",
  representation(
    pacakge_name = "character",
    function_name = "character",
    parameter = "list",
    time = "POSIXct"
  )
)

#' show method for tidymass_parameter
#' @name show
#' @docType methods
#' @rdname show-methods
#' @title show method
#' @param object A \code{tidymass_parameter} instance.
#' @return message
#' @importFrom methods show
#' @export
#' @author Xiaotao Shen
setMethod(
  f = "show",
  signature(object = "tidymass_parameter"),
  definition = function(object) {
    cat(crayon::yellow(paste(rep("-", 20), collapse = ""), "\n"))
    cat(crayon::green("pacakge_name:", object@pacakge_name), "\n")
    cat(crayon::green("function_name:", object@function_name),
        "\n")
    cat(crayon::green("time:", object@time), "\n")
    cat(crayon::green("parameters:\n"))
    for (idx in 1:length(object@parameter)) {
      cat(crayon::green(names(object@parameter)[idx], ":" , object@parameter[idx]), "\n")
    }
  }
)
