mape.rf.abc.foodNumber <- read.csv(file = "r/fiit-bp/test/windowing/results/mape_rf_abc_foodNumber.csv")
mape.rf.abc.maxIterations <- read.csv(file = "r/fiit-bp/test/windowing/results/mape_rf_abc_maxIterations.csv")

rf.abc.foodNumber <- data.frame()
rf.abc.maxIterations <- data.frame()
abc.foodNumber <- data.frame()
abc.maxIterations <- data.frame()


for (i in seq(0, nrow(mape.rf.abc.foodNumber) - 1, 310)) {
  s <-  seq(i, i + 309, 31)
  for (j in 1:31) {
    rf.abc.foodNumber <- rbind(rf.abc.foodNumber, list(aerr = mean(mape.rf.abc.foodNumber[s + j,]$err),
                                                       serr = sd(mape.rf.abc.foodNumber[s + j,]$err),
                                                       atime = mean(mape.rf.abc.foodNumber[s + j,]$etime - mape.rf.abc.foodNumber[s + j,]$stime),
                                                       stime = sd(mape.rf.abc.foodNumber[s + j,]$etime - mape.rf.abc.foodNumber[s + j,]$stime),
                                                       asol1 = mean(mape.rf.abc.foodNumber[s + j,]$sol1),
                                                       ssol1 = sd(mape.rf.abc.foodNumber[s + j,]$sol1),
                                                       asol2 = mean(mape.rf.abc.foodNumber[s + j,]$sol2),
                                                       ssol2 = sd(mape.rf.abc.foodNumber[s + j,]$sol2)))
  }
}
for (i in seq(0, nrow(mape.rf.abc.maxIterations) - 1, 310)) {
  s <-  seq(i, i + 309, 31)
  for (j in 1:31) {
     rf.abc.maxIterations <- rbind(rf.abc.maxIterations, list(aerr = mean(mape.rf.abc.maxIterations[s + j,]$err),
                                                             serr = sd(mape.rf.abc.maxIterations[s + j,]$err),
                                                             atime = mean(mape.rf.abc.maxIterations[s + j,]$etime - mape.rf.abc.maxIterations[s + j,]$stime),
                                                             stime = sd(mape.rf.abc.maxIterations[s + j,]$etime - mape.rf.abc.maxIterations[s + j,]$stime),
                                                             asol1 = mean(mape.rf.abc.maxIterations[s + j,]$sol1),
                                                             ssol1 = sd(mape.rf.abc.maxIterations[s + j,]$sol1),
                                                             asol2 = mean(mape.rf.abc.maxIterations[s + j,]$sol2),
                                                             ssol2 = sd(mape.rf.abc.maxIterations[s + j,]$sol2)))
  }
}

for (i in seq(0, nrow(rf.abc.foodNumber) - 1, 31)) {
  s <- seq(i + 1, i + 31)
  abc.foodNumber <- rbind(abc.foodNumber, list(aerr = mean(rf.abc.foodNumber[s,]$aerr),
                                               atime = mean(rf.abc.foodNumber[s,]$atime)))
}
for (i in seq(0, nrow(rf.abc.maxIterations) - 1, 31)) {
  s <- seq(i + 1, i + 31)
  abc.maxIterations <- rbind(abc.maxIterations, list(aerr = mean(rf.abc.maxIterations[s,]$aerr),
                                                  atime = mean(rf.abc.maxIterations[s,]$atime)))
}



library(ggplot2)
library(Cairo)



xlabel <- "Počet zdrojov jedla"
ylabel <- "Veľkosť chyby MAPE v %"
tlabel <- "Priemerná chyba MAPE náhodných lesov ABC optimalizáciou"
abc1 <- data.frame(x = seq(15, 180, 15), val = abc.foodNumber$aerr, Optimalizácia = "pred každým oknom")
g <- ggplot(data = abc1, aes(x = x, y = val)) + geom_line(aes(colour = Optimalizácia), size = 1) + ggtitle(tlabel) + labs(x = xlabel, y = ylabel) + theme(plot.title = element_text(size = 20, hjust = 0.5), axis.title = element_text(size = 16), axis.text = element_text(size = 11), legend.title = element_text(size = 15), legend.text = element_text(size = 12))
ggsave(filename = "r/fiit-bp/test/experiments/avg_mape_rf_abc_foodNumber.pdf", device = cairo_pdf, plot = g, width = 12)

xlabel <- "Počet zdrojov jedla"
ylabel <- "Čas optimalizácie v sekundách"
tlabel <- "Priemerný čas výpočtu náhodných lesov s ABC optimalizáciou"
abc1 <- data.frame(x = seq(15, 180, 15), val = abc.foodNumber$atime, Optimalizácia = "pred každým oknom")
g <- ggplot(data = abc1, aes(x = x, y = val)) + geom_line(aes(colour = Optimalizácia), size = 1) + ggtitle(tlabel) + labs(x = xlabel, y = ylabel) + theme(plot.title = element_text(size = 20, hjust = 0.5), axis.title = element_text(size = 16), axis.text = element_text(size = 11), legend.title = element_text(size = 15), legend.text = element_text(size = 12))
ggsave(filename = "r/fiit-bp/test/experiments/avg_time_rf_abc_foodNumber.pdf", device = cairo_pdf, plot = g, width = 12)


xlabel <- "Maximum iterácií"
ylabel <- "Veľkosť chyby MAPE v %"
tlabel <- "Priemerná chyba MAPE náhodných lesov ABC optimalizáciou"
abc1 <- data.frame(x = seq(20, 230, 20), val = abc.maxIterations$aerr, Optimalizácia = "pred každým oknom")
g <- ggplot(data = abc1, aes(x = x, y = val)) + geom_line(aes(colour = Optimalizácia), size = 1) + ggtitle(tlabel) + labs(x = xlabel, y = ylabel) + theme(plot.title = element_text(size = 20, hjust = 0.5), axis.title = element_text(size = 16), axis.text = element_text(size = 11), legend.title = element_text(size = 15), legend.text = element_text(size = 12))
ggsave(filename = "r/fiit-bp/test/experiments/avg_mape_rf_abc_maxIterations.pdf", device = cairo_pdf, plot = g, width = 12)

xlabel <- "Maximum iterácií"
ylabel <- "Čas optimalizácie v sekundách"
tlabel <- "Priemerný čas výpočtu náhodných lesov s ABC optimalizáciou"
abc1 <- data.frame(x = seq(20, 230, 20), val = abc.maxIterations$atime, Optimalizácia = "pred každým oknom")
g <- ggplot(data = abc1, aes(x = x, y = val)) + geom_line(aes(colour = Optimalizácia), size = 1) + ggtitle(tlabel) + labs(x = xlabel, y = ylabel) + theme(plot.title = element_text(size = 20, hjust = 0.5), axis.title = element_text(size = 16), axis.text = element_text(size = 11), legend.title = element_text(size = 15), legend.text = element_text(size = 12))
ggsave(filename = "r/fiit-bp/test/experiments/avg_time_rf_abc_maxIterations.pdf", device = cairo_pdf, plot = g, width = 12)
