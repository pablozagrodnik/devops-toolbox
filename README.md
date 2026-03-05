# Biblioteka szablonów
Zawiera szablony i konfiguracje wykorzystywane do optymalizacji procesów wdrażania aplikacji w środowiskach chmurowych oraz budowania infrastruktury.

## Co jest w środku:
* **Szablony CI/CD**:
  * Gotowe workflow GitHub Actions dla aplikacji Java (Spring Boot)
  * Automatyzacja budowania i wersjonowania obrazów Docker (GHCR)
  * Bezpieczny deployment na zdalne instancje (GCP/DigitalOcean) przez SSH
* **Konteneryzacja**:
  * Zbiór zoptymalizowanych plików Dockerfile (multi-stage builds)
  * Konfiguracje Docker Compose dla kompletnych stosów.
* **Infrastruktura i Serwer**:
  * Skrypty konfiguracyjne Nginx pełniącego role Reverse Proxy z wymuszaniem SSL (Let's Encrypt).
  * Moduły IaC do szybkiego stawiania sieci VPC i instancji VM

## Wykorzystane technologie:
* **Cloud**:
  * Google CloudPlatform
  * DigitalOcean
* **Narzędzia**:
  * GitHub Actions
  * Docker
  * Terraform
  * Nginx
* **Systemy**:
  * Fedora Linux
  * Debian Linux
