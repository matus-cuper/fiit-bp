t1_94 <- data.frame(time.pso = 198.18, err.pso = 8089.35, time.abc = 279.25, err.abc = 8089.35, time.tune = 231.89, err.tune = 8744.41)
t1_95 <- data.frame(time.pso = 195.77, err.pso = 6459.48, time.abc = 197.83, err.abc = 6459.46, time.tune = 224.6, err.tune = 7233.87)
t1_96 <- data.frame(time.pso = 202.36, err.pso = 3888.73, time.abc = 203.54, err.abc = 3888.73, time.tune = 248.2, err.tune = 4800.64)

t2_94 <- data.frame(time.pso = 654.81, err.pso = 6825.41, time.abc = 1115.34, err.abc = 6825.41, time.tune = 1134.74, err.tune = 8570.76)
t2_95 <- data.frame(time.pso = 637.71, err.pso = 4990.4, time.abc = 1132.44, err.abc = 4990.4, time.tune = 1111.89, err.tune = 7039.34)
t2_96 <- data.frame(time.pso = 688.56, err.pso = 2786.12, time.abc = 1165.4, err.abc = 2786.21, time.tune = 1164.47, err.tune = 4570.84)

t3_94 <- data.frame(time.pso = 270.28, err.pso = 6385.65, time.abc = 352.38, err.abc = 2579.57, time.tune = 790.36, err.tune = 8450.19)
t3_95 <- data.frame(time.pso = 265.5, err.pso = 4668.64, time.abc = 338.1, err.abc = 4668.64, time.tune = 782.46, err.tune = 6914.44)
t3_96 <- data.frame(time.pso = 261.56, err.pso = 2579.58, time.abc = 332.54, err.abc = 6385.65, time.tune = 832.34, err.tune = 4418.1)

t4_94 <- data.frame(time.pso = 259.45, err.pso = 5981.96, time.abc = 571.09, err.abc = 5981.96, time.tune = 788.23, err.tune = 8248.55)
t4_95 <- data.frame(time.pso = 259.86, err.pso = 4320.69, time.abc = 343.54, err.abc = 4320.69, time.tune = 796.42, err.tune = 6670.58)
t4_96 <- data.frame(time.pso = 269.62, err.pso = 2316.15, time.abc = 554.57, err.abc = 2316.15, time.tune = 864.64, err.tune = 4123.9)



library(ggplot2)
library(Cairo)



xlabel <- "Použitý dataset"
ylabel <- "Čas optimalizácie v sekundách"
tlabel <- "Priemerná dĺžka času optimalizácie metódy SVR získaná metódou PSO"
svr1 <- data.frame(Parametre = rep(c("C(20,50)\nEpsilon(0,10)", "C(50,200)\nEpsilon(0,5)", "C(200,300)\nEpsilon(10,15)", "C(400,500)\nEpsilon(10,30)"), each = 3), dataset = rep(c("94_nitra", "95_partizanske", "96_zvolen"), 4), x = 1:3, 
                   val <- c(t1_94$time.pso, t1_95$time.pso, t1_96$time.pso, t2_94$time.pso, t2_95$time.pso, t2_96$time.pso, t3_94$time.pso, t3_95$time.pso, t3_96$time.pso, t4_94$time.pso, t4_95$time.pso, t4_96$time.pso))
g <- ggplot(data = svr1, aes(x = dataset, y = val, fill = Parametre)) + geom_bar(stat = "identity", position = position_dodge()) + ggtitle(tlabel) + labs(x = xlabel, y = ylabel) + guides(fill = guide_legend(keyheight = 3)) + theme(plot.title = element_text(size = 20, hjust = 0.5), axis.title = element_text(size = 16), axis.text = element_text(size = 11), legend.title = element_text(size = 15), legend.text = element_text(size = 12))
ggsave(filename = "r/fiit-bp/test/experiments/avg_time_svr_pso.pdf", device = cairo_pdf, plot = g, width = 11)

xlabel <- "Použitý dataset"
ylabel <- "Čas optimalizácie v sekundách"
tlabel <- "Priemerná dĺžka času optimalizácie metódy SVR získaná metódou ABC"
svr1 <- data.frame(Parametre = rep(c("C(20,50)\nEpsilon(0,10)", "C(50,200)\nEpsilon(0,5)", "C(200,300)\nEpsilon(10,15)", "C(400,500)\nEpsilon(10,30)"), each = 3), dataset = rep(c("94_nitra", "95_partizanske", "96_zvolen"), 4), x = 1:3, 
                   val <- c(t1_94$time.abc, t1_95$time.abc, t1_96$time.abc, t2_94$time.abc, t2_95$time.abc, t2_96$time.abc, t3_94$time.abc, t3_95$time.abc, t3_96$time.abc, t4_94$time.abc, t4_95$time.abc, t4_96$time.abc))
g <- ggplot(data = svr1, aes(x = dataset, y = val, fill = Parametre)) + geom_bar(stat = "identity", position = position_dodge()) + ggtitle(tlabel) + labs(x = xlabel, y = ylabel) + guides(fill = guide_legend(keyheight = 3)) + theme(plot.title = element_text(size = 20, hjust = 0.5), axis.title = element_text(size = 16), axis.text = element_text(size = 11), legend.title = element_text(size = 15), legend.text = element_text(size = 12))
ggsave(filename = "r/fiit-bp/test/experiments/avg_time_svr_abc.pdf", device = cairo_pdf, plot = g, width = 11)

xlabel <- "Použitý dataset"
ylabel <- "Čas optimalizácie v sekundách"
tlabel <- "Priemerná dĺžka času optimalizácie metódy SVR získaná metódou tune.svm"
svr1 <- data.frame(Parametre = rep(c("C(20,50)\nEpsilon(0,10)", "C(50,200)\nEpsilon(0,5)", "C(200,300)\nEpsilon(10,15)", "C(400,500)\nEpsilon(10,30)"), each = 3), dataset = rep(c("94_nitra", "95_partizanske", "96_zvolen"), 4), x = 1:3, 
                   val <- c(t1_94$time.tune, t1_95$time.tune, t1_96$time.tune, t2_94$time.tune, t2_95$time.tune, t2_96$time.tune, t3_94$time.tune, t3_95$time.tune, t3_96$time.tune, t4_94$time.tune, t4_95$time.tune, t4_96$time.tune))
g <- ggplot(data = svr1, aes(x = dataset, y = val, fill = Parametre)) + geom_bar(stat = "identity", position = position_dodge()) + ggtitle(tlabel) + labs(x = xlabel, y = ylabel) + guides(fill = guide_legend(keyheight = 3)) + theme(plot.title = element_text(size = 20, hjust = 0.5), axis.title = element_text(size = 16), axis.text = element_text(size = 11), legend.title = element_text(size = 15), legend.text = element_text(size = 12))
ggsave(filename = "r/fiit-bp/test/experiments/avg_time_svr_tune.pdf", device = cairo_pdf, plot = g, width = 13)


xlabel <- "Použitý dataset"
ylabel <- "Veľkosť chyby MAE v kW"
tlabel <- "Priemerná chyba MAE metódy SVR s PSO optimalizáciou"
svr1 <- data.frame(Parametre = rep(c("C(20,50)\nEpsilon(0,10)", "C(50,200)\nEpsilon(0,5)", "C(200,300)\nEpsilon(10,15)", "C(400,500)\nEpsilon(10,30)"), each = 3), dataset = rep(c("94_nitra", "95_partizanske", "96_zvolen"), 4), x = 1:3, 
                   val <- c(t1_94$err.pso, t1_95$err.pso, t1_96$err.pso, t2_94$err.pso, t2_95$err.pso, t2_96$err.pso, t3_94$err.pso, t3_95$err.pso, t3_96$err.pso, t4_94$err.pso, t4_95$err.pso, t4_96$err.pso))
g <- ggplot(data = svr1, aes(x = dataset, y = val, fill = Parametre)) + geom_bar(stat = "identity", position = position_dodge()) + ggtitle(tlabel) + labs(x = xlabel, y = ylabel) + guides(fill = guide_legend(keyheight = 3)) + theme(plot.title = element_text(size = 20, hjust = 0.5), axis.title = element_text(size = 16), axis.text = element_text(size = 11), legend.title = element_text(size = 15), legend.text = element_text(size = 12))
ggsave(filename = "r/fiit-bp/test/experiments/avg_mae_svr_pso.pdf", device = cairo_pdf, plot = g, width = 10)

xlabel <- "Použitý dataset"
ylabel <- "Veľkosť chyby MAE v kW"
tlabel <- "Priemerná chyba MAE metódy SVR s ABC optimalizáciou"
svr1 <- data.frame(Parametre = rep(c("C(20,50)\nEpsilon(0,10)", "C(50,200)\nEpsilon(0,5)", "C(200,300)\nEpsilon(10,15)", "C(400,500)\nEpsilon(10,30)"), each = 3), dataset = rep(c("94_nitra", "95_partizanske", "96_zvolen"), 4), x = 1:3, 
                   val <- c(t1_94$err.abc, t1_95$err.abc, t1_96$err.abc, t2_94$err.abc, t2_95$err.abc, t2_96$err.abc, t3_94$err.abc, t3_95$err.abc, t3_96$err.abc, t4_94$err.abc, t4_95$err.abc, t4_96$err.abc))
g <- ggplot(data = svr1, aes(x = dataset, y = val, fill = Parametre)) + geom_bar(stat = "identity", position = position_dodge()) + ggtitle(tlabel) + labs(x = xlabel, y = ylabel) + guides(fill = guide_legend(keyheight = 3)) + theme(plot.title = element_text(size = 20, hjust = 0.5), axis.title = element_text(size = 16), axis.text = element_text(size = 11), legend.title = element_text(size = 15), legend.text = element_text(size = 12))
ggsave(filename = "r/fiit-bp/test/experiments/avg_mae_svr_abc.pdf", device = cairo_pdf, plot = g, width = 10)

xlabel <- "Použitý dataset"
ylabel <- "Veľkosť chyby MAE v kW"
tlabel <- "Priemerná chyba MAE metódy SVR s tune.svm optimalizáciou"
svr1 <- data.frame(Parametre = rep(c("C(20,50)\nEpsilon(0,10)", "C(50,200)\nEpsilon(0,5)", "C(200,300)\nEpsilon(10,15)", "C(400,500)\nEpsilon(10,30)"), each = 3), dataset = rep(c("94_nitra", "95_partizanske", "96_zvolen"), 4), x = 1:3, 
                   val <- c(t1_94$err.tune, t1_95$err.tune, t1_96$err.tune, t2_94$err.tune, t2_95$err.tune, t2_96$err.tune, t3_94$err.tune, t3_95$err.tune, t3_96$err.tune, t4_94$err.tune, t4_95$err.tune, t4_96$err.tune))
g <- ggplot(data = svr1, aes(x = dataset, y = val, fill = Parametre)) + geom_bar(stat = "identity", position = position_dodge()) + ggtitle(tlabel) + labs(x = xlabel, y = ylabel) + guides(fill = guide_legend(keyheight = 3)) + theme(plot.title = element_text(size = 20, hjust = 0.5), axis.title = element_text(size = 16), axis.text = element_text(size = 11), legend.title = element_text(size = 15), legend.text = element_text(size = 12))
ggsave(filename = "r/fiit-bp/test/experiments/avg_mae_svr_tune.pdf", device = cairo_pdf, plot = g, width = 10)
# sem pride loop
