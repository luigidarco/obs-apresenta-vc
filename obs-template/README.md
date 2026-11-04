# Template de canal para o ApresentaVC

Estes são os elementos visuais genéricos usados pelo canal de demonstração **Diário Fluminense**. A marca do sistema é **ApresentaVC**; a logo do canal pode ser trocada em **Identidade visual**, e suas cores e fundo em **Temas**.

O pacote contém oito fundos geométricos vetoriais, uma logo de demonstração e três imagens de reserva. Não contém pautas, fotos pessoais, vídeos, gravações, banco de dados, credenciais nem configuração privada do OBS.

## Preparação no OBS

A integração atual usa os nomes abaixo para reconhecer suas fontes. A pasta fornece elementos e geometria, **não uma coleção pronta para importar no OBS**. Faça a montagem em novas coleções, sem substituir coleções que você já utiliza.

1. No OBS, crie uma coleção **DF - Horizontal**, com uma cena **Jornal - Horizontal** e canvas/saída de **1920 × 1080**.
2. Crie uma coleção **DF - Vertical**, com uma cena **Jornal - Vertical** e canvas/saída de **1080 × 1920**. Confira a resolução ao alternar o perfil do OBS.
3. Em cada cena, adicione as fontes abaixo com os nomes exatos. Selecione sua câmera, seu microfone e a janela do convidado nas propriedades dessas fontes. Não copie IDs de dispositivos de outro computador.

| Nome da fonte | Tipo no OBS | Configuração inicial |
| --- | --- | --- |
| `Fundo e molduras` | Imagem | Um fundo PNG local; o agente substituirá pelo fundo gerado a partir dos SVGs deste pacote. |
| `Reserva da camera` | Imagem | `elementos/camera-reserva-H.png` ou `camera-reserva-V.png`. |
| `Camera - selecione seu dispositivo` | Dispositivo de captura de vídeo | Sua câmera. |
| `Video da noticia - trocar arquivo` | Fonte de mídia | Arquivo local vazio; o painel fornecerá o vídeo da pauta. Desative sua exibição inicialmente. |
| `Foto da noticia - opcional` | Imagem | Opcional; mantenha oculta. Fotos do painel usam uma fonte dinâmica própria. |
| `Manchete - editar texto` | Texto | Texto vazio. Mantida por compatibilidade; a tarja animada é gerada pelo agente. |
| `Descricao - editar texto` | Texto | Texto vazio. Mantida por compatibilidade. |
| `Logo Diario Fluminense` | Imagem | `elementos/logo-quadrada.png`, ou a imagem do seu canal. |
| `Microfone - conferir nivel` | Captura de entrada de áudio | Seu microfone. |
| `Reserva do convidado` | Imagem | `elementos/convidado-reserva.png`; inicialmente oculta. |
| `Convidado - janela da chamada` | Captura de janela/tela | Uma janela de chamada disponível; inicialmente oculta. |
| `Selo - Estados, horario e tempo` | Navegador | Fonte de reserva para seu serviço de estados/tempo; veja a observação abaixo. |
| `Selo - AO VIVO` | Texto | Texto vazio e fonte inicialmente oculta; compatibilidade com coleções antigas. |
| `Selo - URGENTE AO VIVO` | Texto | Texto vazio e fonte inicialmente oculta; compatibilidade com coleções antigas. |
| `Mercado financeiro - automatico` | Navegador | Opcional e apenas horizontal; configure seu provedor de cotações. |

O agente cria as fontes dinâmicas `Studio - tarja`, `Studio - identificacao`, `Studio - imagem`, `Studio - rotulo`, `Studio - fundo` e `Studio - audio`. Não é necessário criar páginas com caminhos do computador que desenvolveu o projeto.

### Posições e encaixe

A geometria dos enquadramentos e as posições de referência estão em [`controle/config.json`](controle/config.json). Os valores `positionX`/`positionY` são posições no canvas; `boundsWidth`/`boundsHeight` são as dimensões da caixa da fonte. O painel ajusta as áreas de câmera, convidado e mídia durante a operação. Posicione logo, selo e fonte financeira uma vez na montagem de cada cena, respeitando o espaço da tarja. Confira a composição no OBS antes de gravar.

Os modos vetoriais 1 e 3 são de fonte única, o modo 2 tem duas áreas e o modo 4 tem três. Os SVGs são modelos de geração; o aplicativo produz PNGs locais de trabalho a partir deles. Não é necessário convertê-los manualmente para usar o agente.

### Estados, tempo e cotações

Este pacote público de elementos não inclui integração pronta de previsão do tempo nem um provedor de cotações. Esses dados dependem das páginas/provedores de navegador configurados pelo operador. Enquanto não houver um serviço configurado, mantenha essas fontes sem conteúdo e escolha **Nenhum**, **URGENTE** ou **AO VIVO** em Rótulo da Sessão. O rótulo AO VIVO é apenas um elemento visual; ele não inicia transmissão.

## Conexão local e segurança

Habilite o servidor WebSocket do OBS com autenticação e mantenha sua porta limitada ao próprio computador. As credenciais são lidas da configuração privada local do OBS; não coloque senhas ou cópias dessa configuração no repositório. A integração fornecida foi preparada para o OBS no macOS.

Para carregar uma pasta personalizada de elementos, configure `DF_OBS_ROOT` com seu caminho local. Essa pasta precisa conter `controle/config.json` e `elementos/`. Não grave esse caminho na configuração pública versionada.

`controle/config.json` contém somente geometria e nomes de fontes. A propriedade `original_background` é relativa a esta pasta, para documentação; não aponta para diretórios pessoais.
