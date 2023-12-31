\name{param.gamma.mixed}
\alias{param.gamma.mixed}
\title{Extract Samples from a Distribution in Order to Pass Them to the `qi' Function...}
\usage{\method{param}{gamma.mixed}(obj, num=1000, ...)}
\description{Extract Samples from a Distribution in Order to Pass Them to the `qi' Function
(this is primarily a helper function for the gamma.mixed model)}
\value{a list specifying link, link-inverse, random samples, and ancillary 
parameters}
\arguments{\item{obj}{a zelig object}
\item{num}{an integer specifying the number of simulations to compute}
\item{...}{ignored parameters}}
