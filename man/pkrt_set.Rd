% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pkrt-set.R
\name{pkrt_set}
\alias{pkrt_set}
\title{Configure pakret's settings}
\usage{
pkrt_set(...)
}
\arguments{
\item{...}{Key-value pairs, separated by commas, of parameters to set. See
details.}
}
\value{
This function is called for its side-effect. It returns no value.
}
\description{
This function allows you to configure pakret's settings, e.g. to
customize citation templates or control which \code{.bib} file to save
references to.
}
\details{
Valid parameters are:
\itemize{
\item \strong{bib}\if{html}{\out{<br>}}
\verb{<character|numeric> = 1L}\if{html}{\out{<br>}}
Name or index of the \code{.bib} file to save references to.
\item \strong{pkg}\if{html}{\out{<br>}}
\verb{<character> = "the ':pkg' package version :ver [:ref]"}\if{html}{\out{<br>}}
Template used to cite a package.
\item \strong{pkg_list}\if{html}{\out{<br>}}
\verb{<character> = "':pkg' v. :ver [:ref]"}\if{html}{\out{<br>}}
Template used in \code{pkrt_list()}.
\item \strong{r}\if{html}{\out{<br>}}
\verb{<character> = "R version :ver [:ref]"}\if{html}{\out{<br>}}
Template used to cite R.
}

New settings only apply to citations that come after \code{pkrt_set()}. This means
that you can redefine the same settings multiple times in the same document
to alter pakret's behavior for a few specific citations only.

Use \code{NULL} to reset a parameter to its default value.
}
\examples{
pkrt_set(pkg = ":pkg (v. :ver) :ref")
pkrt("pakret")

# `NULL` resets parameters to their default value
pkrt_set(pkg = NULL)
pkrt("pakret")
}
