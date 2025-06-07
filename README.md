# Adnotacja do licencjatu
To repozytorium zawiera kod wykorzystany do analizy różnic w transkryptomie neutrofili pochodzących od zdrowych dawców i od dawców podanych terapii G-CSF. Praca licencjacka została wykonana pod opieką Pani Profesor Joanny Cichy i Pani Doktor Kamili Kwiecień


# Spis terści:
- [Opis projektu](#Opis_projektu)
- [Zawartość repozytroium](#Pliki)

# Opis_projektu 

### Cele pracy:
Celem pracy było porównanie transkryptomu neutrofili pobranych z krwi obwodowej dwóch grup pacjentów: 
- pacjentów zdrowych
- pacjentów, którze zostali poddani terapi czynnikiem stymulującycm tworzenie kolonii granulocytów (z ang. Granulocyte colony-stimulating factor, G-CSF)

Szaczegółowe informacje dotyczące pobrania danych znajdują się w pliku [_Załącznik_1.pdf_]()

### Aspekty bioinformatyczne pracy:
1. Przeprowadzenie części analizy za pośrenictwem bioinformatycznej platformy [GALAXY](https://usegalaxy.eu)
2. Przeprowadzenie pozostałej części analizy za pośrednictwem skryptów w języku Python
3. Praca z wykorzystaniem bioinformatycznego narzędzia [DAVID](https://davidbioinformatics.nih.gov/) do analizy funkcjonalnej genów
4. Wizualizacja wyników za pośrednictwem skryptów w Pythonie i R


# Pliki
  To repozytorium składa się z następujących folderów:
  - ETAP_0:
    - Plik [_Załącznik_1.pdf_]() - załącznik do licencjatu, w którym znajdują się informacje dotyczące próbek i szczegółowe parametry wykorzystane przy analizie danych za pośrednictwem platformy [GALAXY](https://usegalaxy.eu)

  - ETAP_1:
    - Plik [_Kod1.1_filtrowanie.py_]()
    - Plik [_Kod1.2_lista_genow.R_]()
    - Plik [_Kod1.3_dotplot.py_]()

  - ETAP_2:
    - Plik [_Kod2.1_DAVID_to_csv.R_]()
    - Plik [_Kod2.2_Annotacja_klastrów.R_]()
    - Plik [_Kod2.3_wykresy.R_]()
