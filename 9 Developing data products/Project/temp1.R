library(sp)
#con <- url("http://gadm.org/data/rda/SWE_adm1.RData")
#print(load(con))
#close(con)

load("CHE_adm1.RData")

language <- c("german", "german", "german","german",
              "german","german","french", "french",
              "german","german","french", "french", 
              "german", "french","german","german",
              "german","german","german", "german",
              "german","italian","german","french",
              "french","german")
gadm$language <- as.factor(language)
col = rainbow(length(levels(gadm$language)))
spplot(gadm, "language", col.regions=col, main="Swiss Language Regions")




res1 <- c( '0.46','0.58','0.56','1.10','1.15',
                            '0.41','1.41','0.65','0.82','0.81',
                            '1.04','-1.19','1.25','0.86','1.52',
                            '1.12','2.50','1.06','0.77','0.83',
                            '0.92','-0.37','1.32','1.41','-0.40')


res1 <- c('gold','silver','gold','cupper','iron',
          'aluminium','cupper','silver','gold','gold',
          'gold','iron','silver','gold','gold',
          'iron','iron','gold','iron','silver','gold','gold',
          'aluminium','cupper','silver')

minerals <- c('Ag', 'Au', 'Cu', 'Fe', 'K', 'Mo', 'P', 'Pb', 'Zn')


load("PER_adm2.RData")

dataPE <- read.csv('dataPE2".csv', stringsAsFactors=FALSE )
res1 <- as.vector(dataPE[[1]])
res2 <- as.vector(dataPE[[2]])
res3 <- as.vector(dataPE[[3]])
res4 <- as.vector(dataPE[[4]])
res5 <- as.vector(dataPE[[5]])
res6 <- as.vector(dataPE[[6]])
res7 <- as.vector(dataPE[[7]])
res8 <- as.vector(dataPE[[8]])


gadm$res1 <- as.factor(res1)
col = rainbow(length(levels(gadm$res1)))
spplot(gadm, "res1", col.regions=col, main="Regions")

gadm$res1 <- as.factor(res2)
col = rainbow(length(levels(gadm$res1)))
spplot(gadm, "res1", col.regions=col, main="Regions")

gadm$res1 <- as.factor(res3)
col = rainbow(length(levels(gadm$res1)))
spplot(gadm, "res1", col.regions=col, main="Regions")

gadm$res1 <- as.factor(res4)
col = rainbow(length(levels(gadm$res1)))
spplot(gadm, "res1", col.regions=col, main="Regions")

gadm$res1 <- as.factor(res5)
col = rainbow(length(levels(gadm$res1)))
spplot(gadm, "res1", col.regions=col, main="Regions")

gadm$res1 <- as.factor(res6)
col = rainbow(length(levels(gadm$res1)))
spplot(gadm, "res1", col.regions=col, main="Regions")

gadm$res1 <- as.factor(res7)
col = rainbow(length(levels(gadm$res1)))
spplot(gadm, "res1", col.regions=col, main="Regions")

gadm$res1 <- as.factor(res8)
col = rainbow(length(levels(gadm$res1)))
spplot(gadm, "res1", col.regions=col, main="Regions")



load("PER_adm2.RData")

dataPE <- read.csv('dataPE6.csv', stringsAsFactors=FALSE, blank.lines.skip = FALSE, header=FALSE )
res1 <- as.vector(dataPE[[1]])

gadm$res1 <- as.factor(res1)
col = rainbow(length(levels(gadm$res1)))
spplot(gadm, "res1", col.regions=col, main="Regions")




