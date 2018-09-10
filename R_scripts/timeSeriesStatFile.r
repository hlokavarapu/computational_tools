# statFile contains the path prepended fileName
timeSeries <- function(outputFileName, statFile, columnNumber, nColumns) {
  y_label <- scan(statFile, '', skip=(columnNumber-1), nlines=1, sep='\n', quiet=TRUE)
  pdf(outputFileName)
  data <- read.table(statFile, skip=nColumns)
  plot(x <- data[,2], y <- data[,columnNumber], xlab = "Time (years)", ylab = y_label, main = "Time Series")
  dev.off()
}

