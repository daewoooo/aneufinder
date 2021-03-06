% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/deltaWCalculator.R
\name{deltaWCalculator}
\alias{deltaWCalculator}
\title{Calculate deltaWs}
\usage{
deltaWCalculator(frags, reads.per.window = 10)
}
\arguments{
\item{frags}{A \code{\link{GRanges}} with read fragments (see \code{\link{bam2GRanges}}).}

\item{reads.per.window}{Number of reads in each dynamic window.}
}
\value{
The input \code{frags} with additional meta-data columns.
}
\description{
This function will calculate deltaWs from a \code{\link{GRanges}} object with read fragments.
}
\author{
Aaron Taudt, David Porubsky, Ashley Sanders
}

