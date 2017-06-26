mape.arima.abc <- read.csv(file = "r/fiit-bp/test/windowing/results/mape_arima_abc.csv")
mape.arima.pso <- read.csv(file = "r/fiit-bp/test/windowing/results/mape_arima_pso.csv")
# mape.arima.auto <- read.csv(file = "r/fiit-bp/test/windowing/results/mape_arima_auto.csv")
mape.arima.loop <- read.csv(file = "r/fiit-bp/test/windowing/results/mape_arima_loop.csv")
mape.arima.abc.computed <- read.csv(file = "r/fiit-bp/test/windowing/results/mape_arima_abc_computed.csv")
mape.arima.pso.computed <- read.csv(file = "r/fiit-bp/test/windowing/results/mape_arima_pso_computed.csv")
# mape.arima.auto.computed <- read.csv(file = "r/fiit-bp/test/windowing/results/mape_arima_auto_computed.csv")
mape.arima.loop.computed <- read.csv(file = "r/fiit-bp/test/windowing/results/mape_arima_loop_computed.csv")

arima.abc <- data.frame()
arima.pso <- data.frame()
arima.auto <- data.frame()
arima.loop <- data.frame()
arima.abc.computed <- data.frame()
arima.pso.computed <- data.frame()
arima.auto.computed <- data.frame()
arima.loop.computed <- data.frame()

for (i in 1:31) {
  s <- seq(i, nrow(mape.arima.pso.computed), 31)
  
  arima.pso.computed <- rbind(arima.pso.computed, list(aerr = mean(mape.arima.pso.computed[s,]$err),
                                                       serr = sd(mape.arima.pso.computed[s,]$err),
                                                       atime = mean(mape.arima.pso.computed[s,]$etime - mape.arima.pso.computed[s,]$stime),
                                                       stime = sd(mape.arima.pso.computed[s,]$etime - mape.arima.pso.computed[s,]$stime),
                                                       asol1 = mean(mape.arima.pso.computed[s,]$sol1),
                                                       ssol1 = sd(mape.arima.pso.computed[s,]$sol1),
                                                       asol2 = mean(mape.arima.pso.computed[s,]$sol2),
                                                       ssol2 = sd(mape.arima.pso.computed[s,]$sol2),
                                                       asol3 = mean(mape.arima.pso.computed[s,]$sol3),
                                                       ssol3 = sd(mape.arima.pso.computed[s,]$sol3)))
  
  # arima.auto.computed <- rbind(arima.auto.computed, list(aerr = mean(mape.arima.auto.computed[s,]$err),
  #                                                        serr = sd(mape.arima.auto.computed[s,]$err),
  #                                                        atime = mean(mape.arima.auto.computed[s,]$etime - mape.arima.auto.computed[s,]$stime),
  #                                                        stime = sd(mape.arima.auto.computed[s,]$etime - mape.arima.auto.computed[s,]$stime),
  #                                                        asol1 = mean(mape.arima.auto.computed[s,]$sol1),
  #                                                        ssol1 = sd(mape.arima.auto.computed[s,]$sol1),
  #                                                        asol2 = mean(mape.arima.auto.computed[s,]$sol2),
  #                                                        ssol2 = sd(mape.arima.auto.computed[s,]$sol2),
  #                                                        asol3 = mean(mape.arima.auto.computed[s,]$sol3),
  #                                                        ssol3 = sd(mape.arima.auto.computed[s,]$sol3)))
}
for (i in 1:31) {
  s <- seq(i, nrow(mape.arima.abc.computed), 31)
  
  arima.abc.computed <- rbind(arima.abc.computed, list(aerr = mean(mape.arima.abc.computed[s,]$err),
                                                       serr = sd(mape.arima.abc.computed[s,]$err),
                                                       atime = mean(mape.arima.abc.computed[s,]$etime - mape.arima.abc.computed[s,]$stime),
                                                       stime = sd(mape.arima.abc.computed[s,]$etime - mape.arima.abc.computed[s,]$stime),
                                                       asol1 = mean(mape.arima.abc.computed[s,]$sol1),
                                                       ssol1 = sd(mape.arima.abc.computed[s,]$sol1),
                                                       asol2 = mean(mape.arima.abc.computed[s,]$sol2),
                                                       ssol2 = sd(mape.arima.abc.computed[s,]$sol2),
                                                       asol3 = mean(mape.arima.abc.computed[s,]$sol3),
                                                       ssol3 = sd(mape.arima.abc.computed[s,]$sol3)))
}
for (i in 1:31) {
  s <- seq(i, nrow(mape.arima.loop.computed), 31)
  
  arima.loop.computed <- rbind(arima.loop.computed, list(aerr = mean(mape.arima.loop.computed[s,]$err),
                                                         serr = sd(mape.arima.loop.computed[s,]$err),
                                                         atime = mean(mape.arima.loop.computed[s,]$etime - mape.arima.loop.computed[s,]$stime),
                                                         stime = sd(mape.arima.loop.computed[s,]$etime - mape.arima.loop.computed[s,]$stime),
                                                         asol1 = mean(mape.arima.loop.computed[s,]$sol1),
                                                         ssol1 = sd(mape.arima.loop.computed[s,]$sol1),
                                                         asol2 = mean(mape.arima.loop.computed[s,]$sol2),
                                                         ssol2 = sd(mape.arima.loop.computed[s,]$sol2),
                                                         asol3 = mean(mape.arima.loop.computed[s,]$sol3),
                                                         ssol3 = sd(mape.arima.loop.computed[s,]$sol3)))
}


for (i in 2:32) {
  s <- seq(i, nrow(mape.arima.abc), 32)
  
    arima.abc <- rbind(arima.abc, list(aerr = mean(mape.arima.abc[s,]$err),
                                       serr = sd(mape.arima.abc[s,]$err),
                                       atime = mean(mape.arima.abc[s,]$etime - mape.arima.abc[s,]$stime),
                                       stime = sd(mape.arima.abc[s,]$etime - mape.arima.abc[s,]$stime),
                                       asol1 = mean(mape.arima.abc[s,]$sol1),
                                       ssol1 = sd(mape.arima.abc[s,]$sol1),
                                       asol2 = mean(mape.arima.abc[s,]$sol2),
                                       ssol2 = sd(mape.arima.abc[s,]$sol2),
                                       asol3 = mean(mape.arima.abc[s,]$sol3),
                                       ssol3 = sd(mape.arima.abc[s,]$sol3)))
  
  arima.pso <- rbind(arima.pso, list(aerr = mean(mape.arima.pso[s,]$err),
                                     serr = sd(mape.arima.pso[s,]$err),
                                     atime = mean(mape.arima.pso[s,]$etime - mape.arima.pso[s,]$stime),
                                     stime = sd(mape.arima.pso[s,]$etime - mape.arima.pso[s,]$stime),
                                     asol1 = mean(mape.arima.pso[s,]$sol1),
                                     ssol1 = sd(mape.arima.pso[s,]$sol1),
                                     asol2 = mean(mape.arima.pso[s,]$sol2),
                                     ssol2 = sd(mape.arima.pso[s,]$sol2),
                                     asol3 = mean(mape.arima.pso[s,]$sol3),
                                     ssol3 = sd(mape.arima.pso[s,]$sol3)))
  
  # arima.auto <- rbind(arima.auto, list(aerr = mean(mape.arima.auto[s,]$err),
  #                                      serr = sd(mape.arima.auto[s,]$err),
  #                                      atime = mean(mape.arima.auto[s,]$etime - mape.arima.auto[s,]$stime),
  #                                      stime = sd(mape.arima.auto[s,]$etime - mape.arima.auto[s,]$stime),
  #                                      asol1 = mean(mape.arima.auto[s,]$sol1),
  #                                      ssol1 = sd(mape.arima.auto[s,]$sol1),
  #                                      asol2 = mean(mape.arima.auto[s,]$sol2),
  #                                      ssol2 = sd(mape.arima.auto[s,]$sol2),
  #                                      asol3 = mean(mape.arima.auto[s,]$sol3),
  #                                      ssol3 = sd(mape.arima.auto[s,]$sol3)))
}
for (i in 2:32) {
  s <- seq(i, nrow(mape.arima.loop), 32)
  
  arima.loop <- rbind(arima.loop, list(aerr = mean(mape.arima.loop[s,]$err),
                                       serr = sd(mape.arima.loop[s,]$err),
                                       atime = mean(mape.arima.loop[s,]$etime - mape.arima.loop[s,]$stime),
                                       stime = sd(mape.arima.loop[s,]$etime - mape.arima.loop[s,]$stime),
                                       asol1 = mean(mape.arima.loop[s,]$sol1),
                                       ssol1 = sd(mape.arima.loop[s,]$sol1),
                                       asol2 = mean(mape.arima.loop[s,]$sol2),
                                       ssol2 = sd(mape.arima.loop[s,]$sol2),
                                       asol3 = mean(mape.arima.loop[s,]$sol3),
                                       ssol3 = sd(mape.arima.loop[s,]$sol3)))
}



library(ggplot2)
library(Cairo)
# check user 2 for size comparison
# kill user 1 for cycle comparison
# make autoarima
# info about data, min, max, mean, sd, graph in numbers
# change pouziityy



xlabel <- "Poradové číslo dňa"
ylabel <- "Veľkosť chyby MAPE v %"
tlabel <- "Priemerná denná chyba MAPE modelu ARIMA získaná metódou PSO"
arima1 <- data.frame(x = 1:31, val = arima.pso.computed$aerr, Optimalizácia = "pred každým oknom")
arima2 <- data.frame(x = 1:31, val = arima.pso$aerr, Optimalizácia = "pred prvým oknom")
g <- ggplot(data = rbind(arima1, arima2), aes(x = x, y = val)) + geom_line(aes(colour = Optimalizácia), size = 1) + ggtitle(tlabel) + labs(x = xlabel, y = ylabel) + theme(plot.title = element_text(size = 20, hjust = 0.5), axis.title = element_text(size = 16), axis.text = element_text(size = 11), legend.title = element_text(size = 15), legend.text = element_text(size = 12))
ggsave(filename = "r/fiit-bp/test/experiments/avg_mape_arima_pso.pdf", device = cairo_pdf, plot = g, width = 12)

xlabel <- "Poradové číslo dňa"
ylabel <- "Veľkosť chyby MAPE v %"
tlabel <- "Priemerná denná chyba MAPE modelu ARIMA získaná metódou ABC"
arima1 <- data.frame(x = 1:31, val = arima.abc.computed$aerr, Optimalizácia = "pred každým oknom")
arima2 <- data.frame(x = 1:31, val = arima.abc$aerr, Optimalizácia = "pred prvým oknom")
g <- ggplot(data = rbind(arima1, arima2), aes(x = x, y = val)) + geom_line(aes(colour = Optimalizácia), size = 1) + ggtitle(tlabel) + labs(x = xlabel, y = ylabel) + theme(plot.title = element_text(size = 20, hjust = 0.5), axis.title = element_text(size = 16), axis.text = element_text(size = 11), legend.title = element_text(size = 15), legend.text = element_text(size = 12))
ggsave(filename = "r/fiit-bp/test/experiments/avg_mape_arima_abc.pdf", device = cairo_pdf, plot = g, width = 12)

# xlabel <- "Poradové číslo dňa"
# ylabel <- "Veľkosť chyby MAPE v %"
# tlabel <- "Priemerná denná chyba MAPE modelu ARIMA získaná metódou auto.arima"
# arima1 <- data.frame(x = 1:31, val = arima.auto.computed$aerr, Optimalizácia = "pred každým oknom")
# arima2 <- data.frame(x = 1:31, val = arima.auto$aerr, Optimalizácia = "pred prvým oknom")
# g <- ggplot(data = rbind(arima1, arima2), aes(x = x, y = val)) + geom_line(aes(colour = Optimalizácia), size = 1) + ggtitle(tlabel) + labs(x = xlabel, y = ylabel) + theme(plot.title = element_text(size = 20, hjust = 0.5), axis.title = element_text(size = 16), axis.text = element_text(size = 11), legend.title = element_text(size = 15), legend.text = element_text(size = 12))
# ggsave(filename = "r/fiit-bp/test/experiments/avg_mape_arima_auto.pdf", device = cairo_pdf, plot = g)

xlabel <- "Poradové číslo dňa"
ylabel <- "Veľkosť chyby MAPE v %"
tlabel <- "Priemerná denná chyba MAPE modelu ARIMA získaná prehľadávaním priestoru"
arima1 <- data.frame(x = 1:31, val = arima.loop.computed$aerr, Optimalizácia = "pred každým oknom")
arima2 <- data.frame(x = 1:31, val = arima.loop$aerr, Optimalizácia = "pred prvým oknom")
g <- ggplot(data = rbind(arima1, arima2), aes(x = x, y = val)) + geom_line(aes(colour = Optimalizácia), size = 1) + ggtitle(tlabel) + labs(x = xlabel, y = ylabel) + theme(plot.title = element_text(size = 20, hjust = 0.5), axis.title = element_text(size = 16), axis.text = element_text(size = 11), legend.title = element_text(size = 15), legend.text = element_text(size = 12))
ggsave(filename = "r/fiit-bp/test/experiments/avg_mape_arima_loop.pdf", device = cairo_pdf, plot = g, width = 13)

 
xlabel <- "Poradové číslo dňa"
ylabel <- "Čas optimalizácie v sekundách"
tlabel <- "Priemerná dĺžka času optimalizácie modelu ARIMA"
arima1 <- data.frame(x = 1:31, val = arima.abc.computed$atime, Optimalizácia = "ABC")
arima2 <- data.frame(x = 1:31, val = arima.pso.computed$atime, Optimalizácia = "PSO")
# arima3 <- data.frame(x = 1:31, val = arima.tune.computed$atime, Optimalizácia = "auto.arima")
arima4 <- data.frame(x = 1:31, val = arima.loop.computed$atime, Optimalizácia = "cyklus")
# g <- ggplot(data = rbind(arima1, arima2, arima3, arima4), aes(x = x, y = val)) + geom_line(aes(colour = Optimalizácia), size = 1) + ggtitle(tlabel) + labs(x = xlabel, y = ylabel) + theme(plot.title = element_text(size = 20, hjust = 0.5), axis.title = element_text(size = 16), axis.text = element_text(size = 11), legend.title = element_text(size = 15), legend.text = element_text(size = 12))
# ggsave(filename = "r/fiit-bp/test/experiments/avg_time_arima_1.pdf", device = cairo_pdf, plot = g)
g <- ggplot(data = rbind(arima1, arima2, arima4), aes(x = x, y = val)) + geom_line(aes(colour = Optimalizácia), size = 1) + ggtitle(tlabel) + labs(x = xlabel, y = ylabel) + theme(plot.title = element_text(size = 20, hjust = 0.5), axis.title = element_text(size = 16), axis.text = element_text(size = 11), legend.title = element_text(size = 15), legend.text = element_text(size = 12))
ggsave(filename = "r/fiit-bp/test/experiments/avg_time_arima_2.pdf", device = cairo_pdf, plot = g, width = 10)

xlabel <- "Poradové číslo dňa"
ylabel <- "Čas optimalizácie v sekundách"
tlabel <- "Štandardná odchýlka času optimalizácie náhodných lesov"
arima1 <- data.frame(x = 1:31, val = arima.abc.computed$stime, Optimalizácia = "ABC")
arima2 <- data.frame(x = 1:31, val = arima.pso.computed$stime, Optimalizácia = "PSO")
# arima3 <- data.frame(x = 1:31, val = arima.tune.computed$stime, Optimalizácia = "auto.arima")
arima4 <- data.frame(x = 1:31, val = arima.loop.computed$stime, Optimalizácia = "cyklus")
# g <- ggplot(data = rbind(arima1, arima2, arima3, arima4), aes(x = x, y = val)) + geom_line(aes(colour = Optimalizácia), size = 1) + ggtitle(tlabel) + labs(x = xlabel, y = ylabel) + theme(plot.title = element_text(size = 20, hjust = 0.5), axis.title = element_text(size = 16), axis.text = element_text(size = 11), legend.title = element_text(size = 15), legend.text = element_text(size = 12))
g <- ggplot(data = rbind(arima1, arima2, arima4), aes(x = x, y = val)) + geom_line(aes(colour = Optimalizácia), size = 1) + ggtitle(tlabel) + labs(x = xlabel, y = ylabel) + theme(plot.title = element_text(size = 20, hjust = 0.5), axis.title = element_text(size = 16), axis.text = element_text(size = 11), legend.title = element_text(size = 15), legend.text = element_text(size = 12))
ggsave(filename = "r/fiit-bp/test/experiments/sd_time_arima_1.pdf", device = cairo_pdf, plot = g, width = 10)
