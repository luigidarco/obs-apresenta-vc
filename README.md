# ApresentaVC

Estúdio local de produção e apresentação de notícias integrado ao OBS Studio. Painel em React, TypeScript e Mantine, serviço Node.js e persistência MySQL. Repositório: https://github.com/luigidarco/obs-apresenta-vc.

## Recursos

- Edições de programa com pautas expansíveis, ordem por arraste, biblioteca de imagens/vídeos e reprodução manual ou automática.
- Temas com imagem de fundo, cores da manchete/descrição e contraste automático. A primeira gravação fixa definitivamente uma cópia do tema na edição.
- Transições por edição: Swap (padrão, 250 ms para recolher e 250 ms para reabrir), Fade, Subir e Corte.
- Informativos manuais de nome e cargo vinculados à pauta, com cadastro geral compartilhado. Cinco segundos de leitura por padrão, ajustáveis entre 1 e 60; entrada e saída animadas de 250 ms. Somente o vínculo exibido fica protegido durante sua exibição.
- Apresentador, convidado e mídia ordenáveis; tela cheia com recorte para fonte única e HUD sobreposto. Incluir uma segunda fonte desativa a tela cheia.
- Gravação local, intervalos, despedida, bloqueio de cópias gerenciadas e recuperação de posição da mídia.
- Administrador e supervisores, permissões por seção, cadastro pendente, expiração e auditoria.

Esta versão grava no computador. O rótulo visual AO VIVO não inicia transmissão. A configuração de convidado, câmera, áudio e destino da gravação pertence ao OBS.

## Requisitos e preparação

- macOS, Node.js **22.18 ou superior** (24+ recomendado), MySQL e OBS Studio com WebSocket local habilitado e autenticado.
- FFmpeg instalado pelo Homebrew ou caminho definido em `DF_FFMPEG_PATH`.
- Cenas e fontes do OBS com os nomes e a geometria descritos em [obs-template/README.md](obs-template/README.md). O pacote contém elementos genéricos, não uma coleção pronta para importar. Os feeds de clima e cotações exigem configuração própria.

```sh
npm ci
npm run build:local
npm run start:local
```

Configure um banco MySQL vazio e uma conta exclusiva para o aplicativo. Crie `mysql-config.json` **na pasta privada de dados**, usando o formato de [config/mysql-config.example.json](config/mysql-config.example.json), preenchendo suas credenciais e restringindo o arquivo a permissão 0600. Nenhuma credencial real integra este repositório. O serviço cria suas tabelas quando encontra uma configuração válida.

Por padrão, dados ficam em `~/Library/Application Support/ApresentaVC`. Instalações anteriores preservam automaticamente a pasta `DiarioFluminenseStudio` quando ela já contém o banco/configuração. `DF_STUDIO_DATA` permite definir outro diretório. A biblioteca contém cópias dos arquivos; os originais são preservados.

O template de OBS incluído é usado quando a antiga pasta `~/Desktop/Diario-Fluminense-OBS` não existe. Para uma configuração própria, defina `DF_OBS_ROOT` apontando à pasta com `controle/config.json` e `elementos/`. Os nomes antigos das fontes são mantidos por compatibilidade; o nome do sistema é ApresentaVC.

## Primeiro acesso

1. Com o serviço rodando, abra **Abrir Studio.command**. Na primeira vez, o atalho privado abre a configuração do administrador.
2. Informe seu e-mail e uma senha própria com pelo menos 12 caracteres. Não existe senha administrativa compartilhada.
3. Entre em http://127.0.0.1:17862/login. Depois da configuração inicial, o atalho também abre o login comum.
4. Novos usuários podem solicitar cadastro em http://127.0.0.1:17862/cadastro e aguardam liberação do administrador.

O acesso de configuração usa a chave privada `launch.key`; ela não deve ser compartilhada nem versionada. O serviço escuta somente em loopback. A recuperação da conexão MySQL é acessível pelo atalho privado, sem depender de uma sessão de login válida.

## Operação

Escolha **Edição do programa** ou crie uma nova. Selecione seu tema e a transição antes de gravar; o tema fica permanentemente preservado na primeira gravação, inclusive quando iniciada diretamente no OBS. Alterar o cadastro do tema não altera a aparência de uma edição já gravada.

Em **Pautas**, prepare e salve os textos, vincule mídias e ordene as miniaturas. Avançar pauta prepara a mídia sem exibi-la; use **Exibir mídia** para colocá-la na composição. Ocultar e retomar preservam a posição. Para nomes/cargos, use **Pessoas e informativos**: vincule pessoas à pauta, ajuste a duração e clique **Exibir** manualmente. Não há disparo automático ao trocar a pauta.

Em **Enquadramento**, ordene e ligue as fontes. **Tela cheia com HUD** fica disponível com uma única fonte exibida e preenche o canvas sem deformação, com recorte central. A tarja, logo, rótulo e cotações permanecem sobrepostos conforme as opções de visibilidade. Fotos mantêm zoom in/out e fundo de cor ou imagem.

**Gravar no PC** inicia a gravação do OBS. **Encerrar sessão** finaliza uma gravação ativa, limpa a pauta selecionada e libera as cópias. Parar diretamente no OBS também sincroniza o encerramento no painel. A proteção por permissões de arquivo impede substituições acidentais das cópias, mas um administrador do sistema pode modificar essas permissões.

## Banco, backup e restauração

O menu **Banco de dados** oferece teste de conexão, backup e configuração MySQL. A senha armazenada nunca é exibida. O backup `.json` contém contas, hashes, permissões, pautas, metadados e auditoria: mantenha-o privado. Arquivos de mídia exigem cópia separada da biblioteca. Sessões de login não são restauradas.

`local/restore-mysql.mjs` restaura um backup apenas em um banco vazio explicitamente informado por `DF_MYSQL_CONFIG`. O utilitário recusa sobrescrever dados existentes. A migração legada fica em `local/migrate-mysql.mjs`; ela verifica conteúdo, contagens e hashes de arquivos. Não use `--refresh-before-activation` depois de configurar o administrador da nova versão.

Se o MySQL falhar, o painel sinaliza a conexão e bloqueia alterações. Não há comando de parada automática da gravação por falha no banco. Credenciais, chaves, banco real, mídia pessoal, gravações e backups ficam fora do Git.

## Desenvolvimento e testes

```sh
npm run test:unit
npm test
npx tsc --noEmit
npm run build:local
```

Os testes de integração criam bancos temporários com prefixo `apresenta_test_` e removem somente esses bancos. Eles exigem MySQL local com acesso administrativo de teste pelo socket `/tmp/mysql.sock`; não são executados contra o banco de produção. Testes cobrem permissões, concorrência, edição independente, tema congelado, identificação protegida, backup/restauração, autenticação e composição dos dois formatos.

Variáveis úteis: `PORT` (padrão 17862), `DF_STUDIO_DATA`, `DF_OBS_ROOT`, `DF_FFMPEG_PATH`, `DF_ACTIVE_HOTKEYS=1` (atalhos/ativação do agente), `DF_STATIC_DIR` (distribuição de teste). `DF_MYSQL_CONFIG` é destinada a testes e restauração explícita; não exponha seu conteúdo em logs ou histórico de comandos.
