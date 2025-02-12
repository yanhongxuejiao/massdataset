% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_extracting.R
\name{extract_sample_info}
\alias{extract_sample_info}
\title{extract_sample_info}
\usage{
extract_sample_info(object)
}
\arguments{
\item{object}{mass_dataset class object.}
}
\value{
A data frame.
}
\description{
Extract sample information.
}
\examples{
data("expression_data")
data("sample_info")
data("variable_info")
object =
  create_mass_dataset(
    expression_data = expression_data,
    sample_info = sample_info,
    variable_info = variable_info,
  )
 sample_info2 =
 extract_sample_info(object = object)
 head(sample_info2)
}
\author{
Xiaotao Shen
\email{shenxt1990@outlook.com}
}
