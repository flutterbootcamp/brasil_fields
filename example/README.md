# Brasil Fields — exemplo interativo

Este aplicativo demonstra os formatadores, utilitários de data e coleções de
dados brasileiros disponibilizados pelo pacote `brasil_fields`.

## Executar localmente

O arquivo `web/index.html` não é uma página independente. Não o abra com uma
URL `file://`: ele depende dos arquivos gerados pelo Flutter e de um servidor
HTTP.

Na raiz deste diretório, instale as dependências uma vez:

```sh
flutter pub get
```

### Desenvolvimento

```sh
flutter run -d chrome --debug
```

### Profile

```sh
flutter run -d chrome --profile
```

No VS Code/Codex, as mesmas opções aparecem separadamente como
`Example • Development (Chrome)` e `Example • Profile (Chrome)`.

### Produção no GitHub Pages

Para gerar a versão publicada:

```sh
flutter build web --release --base-href /brasil_fields/
```

Os testes de interface ficam em `test/` e podem ser executados com
`flutter test`.
