# Aktualne (rzeczywiste) dane ze stacji IMGW
Funkcja pobierająca aktualne dane z API IMGW.



## Funkcja

```r
IMGW_aktualne <- function(filtrowanie=T, strefa_czasowa=-2){
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
  
  
  
 #filtr danych jednej godziny 
  
  if(filtrowanie==T){
  hour <- Sys.time()
  hour <- substr(hour, 12,13)%>%as.numeric()
  IMGW%>%
    filter(Godzina == hour+strefa_czasowa)
  }else{
    IMGW
  }
  
}

```
## Użycie

``` r
IMGW <- IMGW_aktualne() #domyślne filtrowanie danych (tylko najnowsza godzina, IMGW czasami wysyła dane z przesunięciem czasu) i domyślna                                                                                                                             strefa czasowa
```

``` r
IMGW <- IMGW_aktualne(filtrowanie=F) #brak filtrowania dane - oryginalne dane z API IMGW
```

``` r
IMGW <- IMGW_aktualne(filtrowanie = T, strefa_czasowa=-1) #ustawiamy strefę czasową, IMGW podaje dane w czasie UTC
```
