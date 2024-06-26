% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{list_subcorpora}
\alias{list_subcorpora}
\title{A data frame containing information about the available subcorpora}
\format{
A data frame with 368 rows and 6 variables:
\describe{
  \item{corpus}{Code name of the corpus.}
  \item{subcorpus}{Code name of the subcorpus.}
  \item{subcorpus_name}{Plain language name of the subcorpus.}
  \item{reliable_from}{The year at which the subcorpus starts being reliable.}
  \item{reliable_to}{The year at which the subcorpus stops being reliable.}
  \item{disciplines}{The academic disciplines associated with this subcopus.}
}
}
\usage{
data("list_subcorpora")
}
\description{
It includes the code name of the corpus and subcorpus,
its plain language name,
the years for which the data is reliable,
and the academic disciplines it relates too.
}
\examples{
\dontrun{
  # Load the dataset
  data("list_corpora")
}

}
\keyword{datasets}
