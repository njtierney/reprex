% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/reprex-undo.R
\name{un-reprex}
\alias{un-reprex}
\alias{reprex_invert}
\alias{reprex_clean}
\alias{reprex_rescue}
\title{Un-render a reprex}
\usage{
reprex_invert(input = NULL, venue = c("gh", "so"), comment = "^#>")

reprex_clean(input = NULL, comment = "^#>")

reprex_rescue(input = NULL, prompt = getOption("prompt"),
  continue = getOption("continue"))
}
\arguments{
\item{input}{character, holding a wild-caught reprex as a character vector
(length greater than one), string (length one with terminating newline), or
file path (length one with no terminating newline). If not provided, the
clipboard is consulted for input.}

\item{venue}{"gh" for GitHub (default), "so" for StackOverflow, "r" or "R"
for a runnable R script, with commented output interleaved.}

\item{comment}{regular expression that matches commented output lines}

\item{prompt}{character, the prompt at the start of R commands}

\item{continue}{character, the prompt for continuation lines}
}
\value{
Character vector holding just the clean R code, invisibly
}
\description{
Recover clean, runnable code from a reprex captured in the wild. The code is
printed, returned invisibly, and written to the clipboard, if possible. Pick
the function that deals with your problem:
\itemize{
\item \code{reprex_invert()} handles Markdown, with code blocks indicated
with backticks or indentation, e.g., the direct output of
\code{reprex(..., venue = "gh")} or \code{reprex(..., venue = "so")}.
\item \code{reprex_clean()} assumes R code is top-level, possibly
interleaved with commented output, e.g., a displayed reprex copied from
GitHub or the direct output of \code{reprex(..., venue = "R")}.
\item \code{reprex_rescue()} assumes R code lines start with a prompt and
printed output is top-level, e.g., what you'd get by copying from the R
Console.
}
}
\section{Functions}{
\itemize{
\item \code{reprex_invert}: Attempts to reverse the effect of
\code{\link[=reprex]{reprex()}}. The input should be Markdown, presumably the output
of \code{\link[=reprex]{reprex()}}. \code{venue} matters because, in GitHub-flavored
Markdown, code blocks are placed within triple backticks. In other Markdown
dialects, such as the one used on StackOverflow, code is indented by four
spaces.

\item \code{reprex_clean}: Removes lines of commented output from a displayed
reprex, such as code copied from a GitHub issue or \code{reprex}'ed with
\code{venue = "R"}.

\item \code{reprex_rescue}: Removes lines of output and strips prompts from lines
holding R commands. Typical input is copy/paste from R Console.
}}

\examples{
## a rendered reprex can be inverted, at least approximately
x <- reprex({
  #' Some text
  #+ chunk-label-and-options-cannot-be-recovered, message = TRUE
  (x <- 1:4)
  #' More text
  y <- 2:5
  x + y
}, show = FALSE)
writeLines(x)
reprex_invert(x)
## a displayed reprex can be cleaned of commented output
x <- c(
  "## a regular comment, which is retained",
  "(x <- 1:4)",
  "#> [1] 1 2 3 4",
  "median(x)",
  "#> [1] 2.5"
  )
reprex_clean(x)

\dontrun{
## round trip with reprex(..., venue = "R")
code_in <- c("x <- rnorm(2)", "min(x)")
res <- reprex(input = code_in, venue = "R")
res
(code_out <- reprex_clean(res))
identical(code_in, code_out)
}
## rescue a reprex that was copied from a live R session
x <- c(
  "> ## a regular comment, which is retained",
  "> (x <- 1:4)",
  "[1] 1 2 3 4",
  "> median(x)",
  "[1] 2.5"
)
reprex_rescue(x)
}
