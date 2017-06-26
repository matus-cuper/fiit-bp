t1_94 <- data.frame(time.pso = 73.64, err.pso = 13.95, time.abc = 214.58, err.abc = 13.95, time.loop = 45.76, err.loop = 13.95, time.auto = 7.95, err.auto = 5.61)
t1_95 <- data.frame(time.pso = 72.76, err.pso = 16.93, time.abc = 189.69, err.abc = 16.93, time.loop = 42.15, err.loop = 16.93, time.auto = 11.22, err.auto = 8.72)
t1_96 <- data.frame(time.pso = 80.88, err.pso = 16.82, time.abc = 252.23, err.abc = 16.79, time.loop = 44.87, err.loop = 16.79, time.auto = 7.58, err.auto = 3.74)



library(ggplot2)
library(Cairo)



xlabel <- "Použitý dataset"
ylabel <- "Čas optimalizácie v sekundách"
tlabel <- "Priemerná dĺžka času optimalizácie modelu ARIMA"
svr1 <- data.frame(Optimalizácia = rep(c("PSO", "ABC", "cyklus", "auto.arima"), 3), dataset = rep(c("94_nitra", "95_partizanske", "96_zvolen"), 4), x = 1:3, 
                   val <- c(t1_94$time.pso, t1_94$time.abc, t1_94$time.loop, t1_94$time.auto, t1_95$time.pso, t1_95$time.abc, t1_95$time.loop, t1_95$time.auto, t1_96$time.pso, t1_96$time.abc, t1_96$time.loop, t1_96$time.auto))
g <- ggplot(data = svr1, aes(x = dataset, y = val, fill = Optimalizácia)) + geom_bar(stat = "identity", position = position_dodge()) + ggtitle(tlabel) + labs(x = xlabel, y = ylabel) + theme(plot.title = element_text(size = 20, hjust = 0.5), axis.title = element_text(size = 16), axis.text = element_text(size = 11), legend.title = element_text(size = 15), legend.text = element_text(size = 12))
ggsave(filename = "r/fiit-bp/test/experiments/avg_time_arima_1.pdf", device = cairo_pdf, plot = g, width = 10)

xlabel <- "Použitý dataset"
ylabel <- "Veľkosť chyby MAPE v %"
tlabel <- "Priemerná chyba MAPE modelu ARIMA"
svr1 <- data.frame(Optimalizácia = rep(c("PSO", "ABC", "cyklus", "auto.arima"), 3), dataset = rep(c("94_nitra", "95_partizanske", "96_zvolen"), 4), x = 1:3, 
                   val <- c(t1_94$err.pso, t1_94$err.abc, t1_94$err.loop, t1_94$err.auto, t1_95$err.pso, t1_95$err.abc, t1_95$err.loop, t1_95$err.auto, t1_96$err.pso, t1_96$err.abc, t1_96$err.loop, t1_96$err.auto))
g <- ggplot(data = svr1, aes(x = dataset, y = val, fill = Optimalizácia)) + geom_bar(stat = "identity", position = position_dodge()) + ggtitle(tlabel) + labs(x = xlabel, y = ylabel) + theme(plot.title = element_text(size = 20, hjust = 0.5), axis.title = element_text(size = 16), axis.text = element_text(size = 11), legend.title = element_text(size = 15), legend.text = element_text(size = 12))
ggsave(filename = "r/fiit-bp/test/experiments/avg_mape_arima_1.pdf", device = cairo_pdf, plot = g, width = 10)
