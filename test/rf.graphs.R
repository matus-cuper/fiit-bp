mape.rf.abc <- read.csv(file = "r/fiit-bp/test/windowing/results/mape_rf_abc.csv")
mape.rf.pso <- read.csv(file = "r/fiit-bp/test/windowing/results/mape_rf_pso.csv")
mape.rf.tune <- read.csv(file = "r/fiit-bp/test/windowing/results/mape_rf_tune.csv")
mape.rf.loop <- read.csv(file = "r/fiit-bp/test/windowing/results/mape_rf_loop.csv")
mape.rf.abc.computed <- read.csv(file = "r/fiit-bp/test/windowing/results/mape_rf_abc_computed.csv")
mape.rf.pso.computed <- read.csv(file = "r/fiit-bp/test/windowing/results/mape_rf_pso_computed.csv")
mape.rf.tune.computed <- read.csv(file = "r/fiit-bp/test/windowing/results/mape_rf_tune_computed.csv")
mape.rf.loop.computed <- read.csv(file = "r/fiit-bp/test/windowing/results/mape_rf_loop_computed.csv")

rf.abc <- data.frame()
rf.pso <- data.frame()
rf.tune <- data.frame()
rf.loop <- data.frame()
rf.abc.computed <- data.frame()
rf.pso.computed <- data.frame()
rf.tune.computed <- data.frame()
rf.loop.computed <- data.frame()

for (i in 1:31) {
  s <- seq(i, nrow(mape.rf.abc.computed), 31)
  
  rf.abc.computed <- rbind(rf.abc.computed, list(aerr = mean(mape.rf.abc.computed[s,]$err),
                                                 serr = sd(mape.rf.abc.computed[s,]$err),
                                                 atime = mean(mape.rf.abc.computed[s,]$etime - mape.rf.abc.computed[s,]$stime),
                                                 stime = sd(mape.rf.abc.computed[s,]$etime - mape.rf.abc.computed[s,]$stime),
                                                 asol1 = mean(mape.rf.abc.computed[s,]$sol1),
                                                 ssol1 = sd(mape.rf.abc.computed[s,]$sol1),
                                                 asol2 = mean(mape.rf.abc.computed[s,]$sol2),
                                                 ssol2 = sd(mape.rf.abc.computed[s,]$sol2)))
  
  rf.pso.computed <- rbind(rf.pso.computed, list(aerr = mean(mape.rf.pso.computed[s,]$err),
                                                 serr = sd(mape.rf.pso.computed[s,]$err),
                                                 atime = mean(mape.rf.pso.computed[s,]$etime - mape.rf.pso.computed[s,]$stime),
                                                 stime = sd(mape.rf.pso.computed[s,]$etime - mape.rf.pso.computed[s,]$stime),
                                                 asol1 = mean(mape.rf.pso.computed[s,]$sol1),
                                                 ssol1 = sd(mape.rf.pso.computed[s,]$sol1),
                                                 asol2 = mean(mape.rf.pso.computed[s,]$sol2),
                                                 ssol2 = sd(mape.rf.pso.computed[s,]$sol2)))

  rf.loop.computed <- rbind(rf.loop.computed, list(aerr = mean(mape.rf.loop.computed[s,]$err),
                                                   serr = sd(mape.rf.loop.computed[s,]$err),
                                                   atime = mean(mape.rf.loop.computed[s,]$etime - mape.rf.loop.computed[s,]$stime),
                                                   stime = sd(mape.rf.loop.computed[s,]$etime - mape.rf.loop.computed[s,]$stime),
                                                   asol1 = mean(mape.rf.loop.computed[s,]$sol1),
                                                   ssol1 = sd(mape.rf.loop.computed[s,]$sol1),
                                                   asol2 = mean(mape.rf.loop.computed[s,]$sol2),
                                                   ssol2 = sd(mape.rf.loop.computed[s,]$sol2)))
}
for (i in 1:31) {
  s <- seq(i, nrow(mape.rf.tune.computed), 31)  
  rf.tune.computed <- rbind(rf.tune.computed, list(aerr = mean(mape.rf.tune.computed[s,]$err),
                                                   serr = sd(mape.rf.tune.computed[s,]$err),
                                                   atime = mean(mape.rf.tune.computed[s,]$etime - mape.rf.tune.computed[s,]$stime),
                                                   stime = sd(mape.rf.tune.computed[s,]$etime - mape.rf.tune.computed[s,]$stime),
                                                   asol1 = mean(mape.rf.tune.computed[s,]$sol1),
                                                   ssol1 = sd(mape.rf.tune.computed[s,]$sol1),
                                                   asol2 = mean(mape.rf.tune.computed[s,]$sol2),
                                                   ssol2 = sd(mape.rf.tune.computed[s,]$sol2)))
}


for (i in 2:32) {
  s <- seq(i, nrow(mape.rf.abc), 32)
  
  rf.abc <- rbind(rf.abc, list(aerr = mean(mape.rf.abc[s,]$err),
                               serr = sd(mape.rf.abc[s,]$err),
                               atime = mean(mape.rf.abc[s,]$etime - mape.rf.abc[s,]$stime),
                               stime = sd(mape.rf.abc[s,]$etime - mape.rf.abc[s,]$stime),
                               asol1 = mean(mape.rf.abc[s,]$sol1),
                               ssol1 = sd(mape.rf.abc[s,]$sol1),
                               asol2 = mean(mape.rf.abc[s,]$sol2),
                               ssol2 = sd(mape.rf.abc[s,]$sol2)))
  
  rf.pso <- rbind(rf.pso, list(aerr = mean(mape.rf.pso[s,]$err),
                               serr = sd(mape.rf.pso[s,]$err),
                               atime = mean(mape.rf.pso[s,]$etime - mape.rf.pso[s,]$stime),
                               stime = sd(mape.rf.pso[s,]$etime - mape.rf.pso[s,]$stime),
                               asol1 = mean(mape.rf.pso[s,]$sol1),
                               ssol1 = sd(mape.rf.pso[s,]$sol1),
                               asol2 = mean(mape.rf.pso[s,]$sol2),
                               ssol2 = sd(mape.rf.pso[s,]$sol2)))
  
  rf.tune <- rbind(rf.tune, list(aerr = mean(mape.rf.tune[s,]$err),
                                 serr = sd(mape.rf.tune[s,]$err),
                                 atime = mean(mape.rf.tune[s,]$etime - mape.rf.tune[s,]$stime),
                                 stime = sd(mape.rf.tune[s,]$etime - mape.rf.tune[s,]$stime),
                                 asol1 = mean(mape.rf.tune[s,]$sol1),
                                 ssol1 = sd(mape.rf.tune[s,]$sol1),
                                 asol2 = mean(mape.rf.tune[s,]$sol2),
                                 ssol2 = sd(mape.rf.tune[s,]$sol2)))
  
  rf.loop <- rbind(rf.loop, list(aerr = mean(mape.rf.loop[s,]$err),
                                 serr = sd(mape.rf.loop[s,]$err),
                                 atime = mean(mape.rf.loop[s,]$etime - mape.rf.loop[s,]$stime),
                                 stime = sd(mape.rf.loop[s,]$etime - mape.rf.loop[s,]$stime),
                                 asol1 = mean(mape.rf.loop[s,]$sol1),
                                 ssol1 = sd(mape.rf.loop[s,]$sol1),
                                 asol2 = mean(mape.rf.loop[s,]$sol2),
                                 ssol2 = sd(mape.rf.loop[s,]$sol2)))
}



library(ggplot2)
library(Cairo)

xlabel <- "Poradové číslo dňa"
ylabel <- "Veľkosť chyby MAPE v %"
tlabel <- "Priemerná denná chyba MAPE náhodných lesov získaná metódou PSO"
rf1 <- data.frame(x = 1:31, val = rf.pso.computed$aerr, Optimalizácia = "pred každým oknom")
rf2 <- data.frame(x = 1:31, val = rf.pso$aerr, Optimalizácia = "pred prvým oknom")
g <- ggplot(data = rbind(rf1, rf2), aes(x = x, y = val)) + geom_line(aes(colour = Optimalizácia), size = 1) + ggtitle(tlabel) + labs(x = xlabel, y = ylabel) + theme(plot.title = element_text(size = 20, hjust = 0.5), axis.title = element_text(size = 16), axis.text = element_text(size = 11), legend.title = element_text(size = 15), legend.text = element_text(size = 12))
ggsave(filename = "r/fiit-bp/test/experiments/avg_mape_rf_pso.pdf", device = cairo_pdf, plot = g, width = 13)

xlabel <- "Poradové číslo dňa"
ylabel <- "Veľkosť chyby MAPE v %"
tlabel <- "Priemerná denná chyba MAPE náhodných lesov získaná metódou ABC"
rf1 <- data.frame(x = 1:31, val = rf.abc.computed$aerr, Optimalizácia = "pred každým oknom")
rf2 <- data.frame(x = 1:31, val = rf.abc$aerr, Optimalizácia = "pred prvým oknom")
g <- ggplot(data = rbind(rf1, rf2), aes(x = x, y = val)) + geom_line(aes(colour = Optimalizácia), size = 1) + ggtitle(tlabel) + labs(x = xlabel, y = ylabel) + theme(plot.title = element_text(size = 20, hjust = 0.5), axis.title = element_text(size = 16), axis.text = element_text(size = 11), legend.title = element_text(size = 15), legend.text = element_text(size = 12))
ggsave(filename = "r/fiit-bp/test/experiments/avg_mape_rf_abc.pdf", device = cairo_pdf, plot = g, width = 12)

xlabel <- "Poradové číslo dňa"
ylabel <- "Veľkosť chyby MAPE v %"
tlabel <- "Priemerná denná chyba MAPE náhodných lesov získaná metódou tune.randomForest"
rf1 <- data.frame(x = 1:31, val = rf.tune.computed$aerr, Optimalizácia = "pred každým oknom")
rf2 <- data.frame(x = 1:31, val = rf.tune$aerr, Optimalizácia = "pred prvým oknom")
g <- ggplot(data = rbind(rf1, rf2), aes(x = x, y = val)) + geom_line(aes(colour = Optimalizácia), size = 1) + ggtitle(tlabel) + labs(x = xlabel, y = ylabel) + theme(plot.title = element_text(size = 20, hjust = 0.5), axis.title = element_text(size = 16), axis.text = element_text(size = 11), legend.title = element_text(size = 15), legend.text = element_text(size = 12))
ggsave(filename = "r/fiit-bp/test/experiments/avg_mape_rf_tune.pdf", device = cairo_pdf, plot = g, width = 13)

xlabel <- "Poradové číslo dňa"
ylabel <- "Veľkosť chyby MAPE v %"
tlabel <- "Priemerná denná chyba MAPE náhodných lesov získaná prehľadávaním priestoru"
rf1 <- data.frame(x = 1:31, val = rf.loop.computed$aerr, Optimalizácia = "pred každým oknom")
rf2 <- data.frame(x = 1:31, val = rf.loop$aerr, Optimalizácia = "pred prvým oknom")
g <- ggplot(data = rbind(rf1, rf2), aes(x = x, y = val)) + geom_line(aes(colour = Optimalizácia), size = 1) + ggtitle(tlabel) + labs(x = xlabel, y = ylabel) + theme(plot.title = element_text(size = 20, hjust = 0.5), axis.title = element_text(size = 16), axis.text = element_text(size = 11), legend.title = element_text(size = 15), legend.text = element_text(size = 12))
ggsave(filename = "r/fiit-bp/test/experiments/avg_mape_rf_loop.pdf", device = cairo_pdf, plot = g, width = 15)


xlabel <- "Poradové číslo dňa"
ylabel <- "Čas optimalizácie v sekundách"
tlabel <- "Priemerná dĺžka času optimalizácie náhodných lesov"
rf1 <- data.frame(x = 1:31, val = rf.abc.computed$atime, Optimalizácia = "ABC")
rf2 <- data.frame(x = 1:31, val = rf.pso.computed$atime, Optimalizácia = "PSO")
rf3 <- data.frame(x = 1:31, val = rf.tune.computed$atime, Optimalizácia = "tune.randomForest")
rf4 <- data.frame(x = 1:31, val = rf.loop.computed$atime, Optimalizácia = "cyklus")
g <- ggplot(data = rbind(rf1, rf2, rf3, rf4), aes(x = x, y = val)) + geom_line(aes(colour = Optimalizácia), size = 1) + ggtitle(tlabel) + labs(x = xlabel, y = ylabel) + theme(plot.title = element_text(size = 20, hjust = 0.5), axis.title = element_text(size = 16), axis.text = element_text(size = 11), legend.title = element_text(size = 15), legend.text = element_text(size = 12))
ggsave(filename = "r/fiit-bp/test/experiments/avg_time_rf_1.pdf", device = cairo_pdf, plot = g, width = 10)
g <- ggplot(data = rbind(rf1, rf2, rf4), aes(x = x, y = val)) + geom_line(aes(colour = Optimalizácia), size = 1) + ggtitle(tlabel) + labs(x = xlabel, y = ylabel) + theme(plot.title = element_text(size = 20, hjust = 0.5), axis.title = element_text(size = 16), axis.text = element_text(size = 11), legend.title = element_text(size = 15), legend.text = element_text(size = 12))
ggsave(filename = "r/fiit-bp/test/experiments/avg_time_rf_2.pdf", device = cairo_pdf, plot = g, width = 10)

xlabel <- "Poradové číslo dňa"
ylabel <- "Čas optimalizácie v sekundách"
tlabel <- "Štandardná odchýlka času optimalizácie náhodných lesov"
rf1 <- data.frame(x = 1:31, val = rf.abc.computed$stime, Optimalizácia = "ABC")
rf2 <- data.frame(x = 1:31, val = rf.pso.computed$stime, Optimalizácia = "PSO")
rf3 <- data.frame(x = 1:31, val = rf.tune.computed$stime, Optimalizácia = "tune.randomForest")
rf4 <- data.frame(x = 1:31, val = rf.loop.computed$stime, Optimalizácia = "cyklus")
g <- ggplot(data = rbind(rf1, rf2, rf3, rf4), aes(x = x, y = val)) + geom_line(aes(colour = Optimalizácia), size = 1) + ggtitle(tlabel) + labs(x = xlabel, y = ylabel) + theme(plot.title = element_text(size = 20, hjust = 0.5), axis.title = element_text(size = 16), axis.text = element_text(size = 11), legend.title = element_text(size = 15), legend.text = element_text(size = 12))
ggsave(filename = "r/fiit-bp/test/experiments/sd_time_rf_1.pdf", device = cairo_pdf, plot = g, width = 10)
