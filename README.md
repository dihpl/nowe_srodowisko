## 1. Wprowadzenie

Dokumentacja ta zawiera szczegóły dotyczące środowisk pracy dla projektu oraz instrukcje dotyczące korzystania z systemu kontroli wersji Git, Docker oraz automatyzacji w GitHub Actions.

## 2. Środowiska pracy

Projekt składa się z trzech głównych środowisk:

- **Środowisko produkcyjne:** Środowisko przeznaczone dla użytkowników końcowych, wersja na gałęzi `master`.
- **Środowisko deweloperskie:** Środowisko do testowania zmian, wersja na gałęzi `develop`.
- **Środowisko lokalne:** Środowisko uruchamiane lokalnie na komputerze programisty do pracy nad kodem.

## 3. Struktura repozytorium

Repozytorium projektu powinno mieć następującą strukturę:
```
project/
├── docker-compose.yml
├── .github/
│ └── workflows/
│ └── deploy.yml
└── public_html/
├── index.html
├── css/
├── js/
├── app/
├── .gitignore
└── app/
└── config/
├── parameters_example.php
└── .htaccess_example
```

### Opis struktury:
- **`docker-compose.yml`:** Konfiguracja Docker Compose dla projektu.
- **`.github/workflows/deploy.yml`:** Konfiguracja GitHub Actions do automatycznego wdrażania zmian.
- **`public_html/`:** Katalog zawierający pliki publiczne aplikacji.
- **`public_html/app/config/parameters_example.php`:** Przykładowy plik konfiguracyjny parametrów.
- **`public_html/.gitignore`:** Plik `.gitignore` dla projektu.

## 4. Instrukcje użytkowania

### A. Uruchomienie środowiska lokalnego

1. **Instalacja Docker i Docker Compose:**
   - Upewnij się, że na Twoim komputerze zainstalowane są Docker oraz Docker Compose. Instrukcje instalacji można znaleźć na oficjalnych stronach Docker.

2. **Pobranie repozytorium:**
   ```bash
   git clone git@github.com:dihpl/nowe_srodowisko.git
   cd nowe_srodowisko

3. **Uruchomienie środowiska:**
  ```bash
    docker-compose up -d
  ```
Aplikacja będzie dostępna pod adresem http://localhost:8080.

### B. Praca z Git
Pobieranie najnowszych zmian:

  ```bash
  git pull origin develop
Wysyłanie zmian:

  ```bash

  git add .
  git commit -m "Opis zmian"
  git push origin develop
```
W przypadku wdrażania zmian do produkcji, użyj gałęzi master.
### C. Automatyczne wdrażanie z GitHub Actions
Każde zatwierdzenie zmian w gałęziach master lub develop spowoduje automatyczne wdrożenie na odpowiednie środowisko (produkcja lub deweloperskie) za pomocą GitHub Actions.
D. Synchronizacja bazy danych
Synchronizacja bazy danych z produkcji do deweloperskiego:

Skrypt sync_db.sh jest dostępny w repozytorium. Upewnij się, że odpowiednie dane dostępowe są skonfigurowane w skrypcie.
Uruchomienie synchronizacji:

bash
Skopiuj kod
./sync_db.sh
