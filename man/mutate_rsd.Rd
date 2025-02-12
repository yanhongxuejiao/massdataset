% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mutate_rsd.R
\name{mutate_rsd}
\alias{mutate_rsd}
\title{Calculate RSD for features}
\usage{
mutate_rsd(object, according_to_samples = "all")
}
\arguments{
\item{object}{(required) mass_dataset class object.}

\item{according_to_samples}{(required) What samples used to filter variables.
Default is "all". If you
want to use only several samples, provide they names as a vector.}
}
\value{
A logical vector equal to the number of variables in mass_dataset-class.
Alternatively, if \code{prune==TRUE}, the pruned mass_dataset-class
object is returned instead.
}
\description{
Calculate RSD for features
}
\examples{
data("expression_data")
data("sample_info")
data("variable_info")
library(massdataset)

object =
  create_mass_dataset(
    expression_data = expression_data,
    sample_info = sample_info,
    variable_info = variable_info,
  )

object

##calculate RSDs according to all the samples
object =
  mutate_rsd(object = object)

object

head(extract_variable_info(object))

##calculate RSDs according to only QC samples
object =
  mutate_rsd(object = object,
                according_to_samples =
              get_sample_id(object)[extract_sample_info(object)$class == "QC"])

object

head(extract_variable_info(object))
}
\author{
Xiaotao Shen
\email{shenxt1990@outlook.com}
}
