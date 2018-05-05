IMGW_aktualne <- function(){
  library("dplyr")
  library("RCurl")
  
  IMGW <- getURL("https://danepubliczne.imgw.pl/api/data/synop",.opts = list(ssl.verifypeer = FALSE))
  IMGW <- gsub(pattern = "\\[", '', IMGW)
  IMGW <- gsub(pattern = "\\]", '', IMGW)
  IMGW <- capture.output(cat(gsub("\\\"","",IMGW)))
  IMGW <- capture.output(cat(gsub("}","\n",IMGW)))
  IMGW <- gsub("\\{","",IMGW)
  IMGW <- gsub(",id_stacji","id_stacji",IMGW)
  IMGW <- gsub(":",",",IMGW)
  IMGW <- data.frame(do.call('rbind', strsplit(as.character(IMGW),',',fixed=TRUE)))
  
  IMGW <- IMGW[,seq(2,20,2)]
  colnames(IMGW) <- c("ID_stacji", "Nazwa_stacji", "Data", "Godzina", "Temp", "Predkosc_wiatru", "Kierunek_wiatru", "Wilg_wzgl", "Suma_opadu", "Cisnienie")
  IMGW[IMGW == "null"] <- NA
  
  for(i in c(1,4,5:10)){
    IMGW[,i] <- as.numeric(as.character(IMGW[,i]))
  }
  
  IMGW[,2] <- as.character(IMGW[,2])
  IMGW[,3] <- as.POSIXct(strptime(IMGW[,3], "%Y-%m-%d"), tz = "UTC")
  
  
  miasta <- read.csv("http://endemit.pl/wspolrzedne.txt", sep=";", header = T)
  colnames(miasta) <- c("Nazwa_stacji", "x", "y")
  
  IMGW <- merge(IMGW, miasta, "Nazwa_stacji")
  IMGW <- IMGW[,c(1:12)]
  
  IMGW$xx <- substr(IMGW$x, 4,5)
  IMGW$yy <- substr(IMGW$y, 4,5)
  
  IMGW$x <- substr(IMGW$x, 1,2)
  IMGW$y <- substr(IMGW$y, 1,2)
  
  IMGW$xx <- round(as.numeric(IMGW$xx)/60, 2)
  IMGW$yy <- round(as.numeric(IMGW$yy)/60, 2)
  
  IMGW$x <- as.numeric(IMGW$x)+IMGW$xx
  IMGW$y <- as.numeric(IMGW$y)+IMGW$yy
  
  IMGW <- IMGW[,c(1,2,11,12,3:10)]
  df = data.frame(t(c("UKR",999999,24.50,48.75,as.character(IMGW$Data[1]),IMGW$Godzina[1],c(round((IMGW$Temp[24]+IMGW$Temp[40])/2,1)),0,0,0,0,0)))
  colnames(df) <- colnames(IMGW)
  
  df1 <- t(c("DEU",0000000,14.00,55.00,as.character(IMGW$Data[1]),IMGW$Godzina[1],c(round((IMGW$Temp[5]+IMGW$Temp[52])/2,1)),0,0,0,0,0)) 
  colnames(df1) <- colnames(IMGW)
  
  IMGW <- rbind(IMGW,df, df1)
  IMGW$x <- as.numeric(IMGW$x)
  IMGW$y <- as.numeric(IMGW$y)
  IMGW$Temp <- as.numeric(IMGW$Temp)
  
  IMGW <- IMGW[order(IMGW$y),]
  IMGW <- IMGW[order(IMGW$x),]
  
  hour <- Sys.time()
  hour <- substr(hour, 12,13)%>%as.numeric()
  IMGW%>%
    filter(Godzina == hour)
}
