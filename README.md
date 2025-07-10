# Diário de Estudos Bíblicos + IA

Este é um aplicativo Flutter que permite aos usuários navegar pela Bíblia, selecionar versículos e receber um estudo avançado gerado pela OpenAI.

## Configuração

1. **Configure o Firebase:**
   - Siga as instruções em [https://firebase.google.com/docs/flutter/setup](https://firebase.google.com/docs/flutter/setup) para criar um projeto Firebase e configurar o FlutterFire.
   - Baixe o arquivo `google-services.json` e coloque-o em `android/app/`.
   - Baixe o arquivo `GoogleService-Info.plist` e coloque-o em `ios/Runner/`.

2. **Configure a chave da API da OpenAI:**
   - Crie um arquivo `.env` na raiz do projeto.
   - Adicione sua chave da API da OpenAI ao arquivo `.env` da seguinte forma:
     ```
     OPENAI_API_KEY=SUA_CHAVE_DA_API
     ```

3. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

## Como Rodar

- **Android:**
  ```bash
  flutter run
  ```
  (Requer Android API >= 23)

- **iOS:**
  ```bash
  flutter run
  ```

## GIF do Fluxo Principal

(TODO: Adicionar um GIF curto mostrando o fluxo principal do aplicativo)

## Critérios de Avaliação

- **Autenticação (10 pts):** Cadastro e login com e-mail e senha usando Firebase Authentication.
- **Bible4U (10 pts):** Carregamento de livros, capítulos e versículos da API Bible4U.
- **OpenAI + formato (20 pts):** Geração de estudo avançado com a API da OpenAI, com formato específico.
- **Firestore CRUD + rules (10 pts):** Salvamento e leitura de estudos no Cloud Firestore, com regras de segurança.
- **WebView (5 pts):** Exibição de links externos em uma WebView.
- **Documentação (5 pts):** README claro e completo.
