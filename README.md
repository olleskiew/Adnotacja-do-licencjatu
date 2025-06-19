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

Szaczegółowe informacje dotyczące pobrania danych znajdują się w pliku ETAP1.pdf

### Aspekty bioinformatyczne pracy:
1. Przeprowadzenie części analizy za pośrenictwem bioinformatycznej platformy [GALAXY](https://usegalaxy.eu)
2. Przeprowadzenie pozostałej części analizy za pośrednictwem skryptów w języku Python
3. Praca z wykorzystaniem bioinformatycznego narzędzia [DAVID](https://davidbioinformatics.nih.gov/) do analizy funkcjonalnej genów
4. Wizualizacja wyników za pośrednictwem skryptów w Pythonie i R

# Pliki
To repozytorium składa się z 5 folderów
- ETAP_1 - zawierający pdf, z opisem skąd zostały pobrane próbki oraz parametry narzędzi użytych na serwerze Galaxy
- ETAP_2 - zawierajacy kod, służący do dodanie metadanych do pliku Anndata z etapu 1
- ETAP_3 - zawierajacy pdf, ze szczegółowymi parametrami narzędzi użytych na serwerze Galaxy
- ETAP_4 - zawierający kod w Pythonie i R służący do wizualizacji danych w postaci wykresu punktowego (dotplot)
- ETAP_5 - zawierajacy kod w R, który służył do wykonania i wizualizacji wyników analizy wzbogacenia przy użyciu narzędzia DAVID

