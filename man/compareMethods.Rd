% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/compareMethods.R
\name{compareMethods}
\alias{compareMethods}
\title{Compare copy number calling methods}
\usage{
compareMethods(models1, models2)
}
\arguments{
\item{models1}{A list of \code{\link{aneuHMM}} objects or a vector of files that contain such objects.}

\item{models2}{A list of \code{\link{aneuHMM}} objects or a vector of files that contain such objects. IDs of the models must match the ones in \code{models1}.}
}
\value{
A data.frame with one column 'concordance' which gives the fraction of the genome that is called concordantly between both models.
}
\description{
Compare two sets of \code{\link{aneuHMM}} objects generated by different methods (see option \code{method} of \code{\link{findCNVs}}).
}
\examples{
## Get a list of HMMs
folder <- system.file("extdata", "primary-lung", "hmms", package="AneuFinderData")
files <- list.files(folder, full.names=TRUE)
## Compare the models with themselves (non-sensical)
df <- compareMethods(files, files)
head(df)
}
\author{
Aaron Taudt
}

