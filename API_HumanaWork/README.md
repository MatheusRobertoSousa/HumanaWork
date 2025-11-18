# HumanaWork API (Spring Boot)

Projeto Spring Boot que implementa a API para o aplicativo HumanaWork (integra com Oracle + PL/SQL).

## Como usar

1. Ajuste `src/main/resources/application.properties` com a senha correta do usuário `rm99657`.
2. Build:
   ```
   mvn clean package
   ```
3. Rodar:
   ```
   java -jar target/humana-work-api-1.0.0.jar
   ```

Endpoints principais:
- POST /api/auth/login
- POST /api/checkins
- GET /api/salas
- POST /api/sessoes/iniciar
- POST /api/sessoes/encerrar/{id}
- GET /api/metrics/relatorio/{idUsuario}?dataIni=<ms>&dataFim=<ms>

OBS: o projeto chama procedures do package `HUMANA_WORK_PKG` via `PlsqlService`. Ajuste nomes se necessário.
