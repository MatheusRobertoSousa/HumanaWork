# HumanaWork 📱

Plataforma de **trabalho colaborativo e remoto inteligente**, focada em bem-estar, foco e desenvolvimento humano.  
Desenvolvida em **Flutter**, integrada a um back-end com **Oracle + PL/SQL** para automação de métricas e registros de uso.

---

IMPORTANTE, CASO O PROFESSOR DESEJE RODAR A APLICAÇÃO E FAZER O TESTE, DEVE UTILIZAR AS SEGUINTES CREDENCIAIS:
EMAIL:alice@example.com
senha:123456

EM CASO DE UTILIZAÇÃO EM PRODUÇÃO, AS CREDENCIAIS DE ACESSO SERIAM FORNECIDAS PELA EMPRESA AOS SEUS COLABORADORES, POR ISSO A AUSÊNCIA DA PÁGINA DE CRIAÇÃO DE CONTA.

## 1. Visão geral

O **HumanaWork** é um aplicativo mobile que apoia estudantes, profissionais e times remotos na organização do trabalho de forma mais **humana, significativa e sustentável**.  
A solução integra:

- Check-ins de bem-estar e propósito
- Salas de foco colaborativo
- Painel de métricas pessoais de foco e desenvolvimento

O objetivo é promover experiências de trabalho remoto que valorizem não só a produtividade, mas também o equilíbrio emocional, a clareza de objetivos e a evolução contínua do usuário.

---

## 2. Funcionalidades principais

> Login e cadastro **não** são contabilizados como funcionalidades, conforme requisitos da disciplina.

### 2.1. Check-in de bem-estar e propósito

- Registro diário de:
  - Humor (escala de 1 a 5)
  - Nível de energia (0 a 10)
  - Foco/objetivo do dia (texto livre)
- Os dados são enviados ao back-end e armazenados na tabela `CHECKINS`.
- A partir desses registros, o sistema pode gerar métricas como média de humor e evolução ao longo do tempo.

### 2.2. Salas de foco colaborativo

- Lista de **salas de foco** (ex.: “Estudos Flutter”, “Squad TechCity”).
- Cada sala pode ser usada por um grupo de pessoas que trabalham ou estudam remotamente.
- Em cada sala, o usuário pode:
  - Iniciar e encerrar uma **sessão de foco** (exemplo: 25 minutos).
  - Interagir via um **mural de apoio**, com mensagens curtas e motivacionais.
- As sessões de foco são registradas em `SESSOES_FOCO` e ações são logadas em `USAGE_LOG`.

### 2.3. Painel de métricas e desenvolvimento

- Tela de métricas pessoais, com informações como:
  - Total de sessões de foco em determinado período
  - Tempo total focado (em minutos)
  - Média de humor
  - Objetivos cumpridos (derivados de check-ins e sessões)
- As métricas podem ser consolidadas em `LEARNING_METRICS` e consultadas por meio de procedures PL/SQL.

---

## 3. Tecnologias adotadas

### 3.1. Front-end

- **Flutter (Dart)** – desenvolvimento mobile multiplataforma (Android/iOS)
- **Material Design 3** – construção de UI moderna e responsiva
- Gerenciamento de estado planejado com **Provider** ou **Riverpod**

**Benefícios:**

- Alta produtividade de desenvolvimento
- Código único para múltiplas plataformas
- UI reativa e performática
- Comunidade ativa e extensa base de pacotes

### 3.2. Back-end e Banco de Dados

- API REST (framework a definir: ex. Spring Boot, Node.js etc.)
- Banco de dados **Oracle**
- Rotinas em **PL/SQL** para:
  - Registro de uso
  - Cálculo de métricas
  - Automação de processos
  - Dynamic SQL para filtros flexíveis

**Benefícios:**

- Centralização de regras de negócio sensíveis no banco
- Melhor desempenho em agregações e relatórios
- Maior segurança e controle transacional
- Facilita auditoria e rastreabilidade de ações

---

## 4. Arquitetura do sistema

O sistema é dividido em três camadas principais:

1. **Aplicativo mobile (Flutter)**  
   - Responsável pela interface com o usuário, experiência visual e interação em tempo real.
2. **API REST**  
   - Intermediário entre o app e o banco de dados.  
   - Exponde endpoints para login, check-ins, sessões de foco, métricas etc.
3. **Banco de Dados Oracle + PL/SQL**  
   - Armazena todos os dados estruturados.  
   - Executa procedures, triggers e pacotes para automação e relatórios.

Essa arquitetura segue uma abordagem de **separação de responsabilidades**, facilitando manutenção, testes e evolução futura da solução.

---

## 5. Modelagem de Dados (resumo DER/MER)

Principais entidades:

- `USUARIOS` – dados dos usuários do app
- `SALAS_FOCO` – salas de estudo ou trabalho focado
- `MEMBROS_SALA` – relacionamento N:N entre usuários e salas
- `SESSOES_FOCO` – sessões de foco realizadas em cada sala
- `CHECKINS` – registro de humor, energia e foco do dia
- `LEARNING_METRICS` – consolidação de métricas de aprendizado/desenvolvimento
- `USAGE_LOG` – log de ações realizadas no sistema (auditoria e análise de uso)

Relacionamentos (em alto nível):

- Um **usuário** pode criar várias **salas de foco**.
- Usuários e salas se relacionam de forma N:N por meio de **MEMBROS_SALA**.
- Um **usuário** pode realizar várias **sessões de foco** em diferentes salas.
- Um **usuário** realiza vários **check-ins**.
- Um **usuário** possui vários registros em **LEARNING_METRICS** e **USAGE_LOG**.

---

## 6. PL/SQL e automação

Foi definido um pacote principal em PL/SQL, por exemplo `HUMANA_WORK_PKG`, com procedures como:

- `registrar_checkin`  
  Registra um novo check-in do usuário, atualizando a tabela `CHECKINS` e gerando log em `USAGE_LOG`.

- `iniciar_sessao_foco`  
  Cria um registro em `SESSOES_FOCO` com o horário de início e registra a ação em `USAGE_LOG`.

- `encerrar_sessao_foco`  
  Atualiza a sessão com horário de fim, calcula a duração em minutos e registra a conclusão em `USAGE_LOG`.

- `gerar_relatorio_metricas`  
  Gera, via cursor, um conjunto de métricas para um usuário em determinado período.

- `buscar_metricas_dinamico` (Dynamic SQL)  
  Permite aplicar filtros flexíveis sobre `LEARNING_METRICS` usando cláusulas dinâmicas na consulta.

Essas rotinas automatizam o tratamento de dados, delegando ao banco tarefas de cálculo, consolidação e auditoria de uso.

---

## 7. Estrutura do projeto Flutter

Estrutura de diretórios proposta:

```text
lib/
  main.dart
  core/
    app_routes.dart
    app_theme.dart
  data/
    services/
      api_service.dart
  presentation/
    pages/
      login_page.dart
      home_page.dart
      checkin_page.dart
      focus_rooms_page.dart
      focus_room_detail_page.dart
      metrics_page.dart
