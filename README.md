# Ajustes necessários pra rodar:

Ajuste necessário no package de table: C:\flutter\packages\flutter\lib\src\material\data_table.dart

Na função \_buildDataCell e \_buildHeadingCell, comente as linhas dos atributos "padding" e "constraints", e adicione a linha

```bash
padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
```

Isso fará com que as linhas da tabela tenham altura dinâmica

## Commits

Siga os padrões de commit instituídos no tutorial: https://github.com/iuricode/padroes-de-commits

# Para rodar o aplicativo usando a api em localhost (rodando local), é necessário rodar esse comando como o simulador aberto ou dispositivo conectado:

Se rodar em dispositivo real:

```bash
adb -d reverse tcp:8000 tcp:8000
```

Se rodar em emulador, deve rodar isso antes de rodar um flutter run:

```bash
adb -e reverse tcp:8000 tcp:8000
```

Para aplicar isso em um emulador especifico:

```bash
adb devices -> pegar o serial
adb -s [emulator-5556] reverse tcp:8000 tcp:8000
```

## Inicialização

Necessário criar o arquivo .env e adicionar as chaves conforme exemplificado no arquivo .env.example.

Responsabilidades:

```bash
API_URL -> endpoint da API
SYSTEM_URL -> endpoint do frontend do sistema. utilizado para renderizar componentes webview
IMAGE_URL -> endpoint do bucket S3 para carregar as imagens
ANDROID_VERSION -> controle de versão do app, toda atualização é aumentada o valor na tabela do banco de dados app_version e aumentado no .env
IOS_VERSION -> controle de versão do app, toda atualização é aumentada o valor na tabela do banco de dados app_version e aumentado no .env
API_EMAIL -> email de autenticação na API
API_PASSWORD -> senha de autenticação na API
```
