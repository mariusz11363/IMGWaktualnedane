# Aktualne (rzeczywiste) dane ze stacji IMGW
Funkcja pobierająca aktualne dane z API IMGW.


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
