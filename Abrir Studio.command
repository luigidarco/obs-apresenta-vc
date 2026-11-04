#!/bin/zsh
cd -- "$(dirname -- "$0")"
launchctl kickstart "gui/$(id -u)/br.diariofluminense.studio" 2>/dev/null || true
if command -v node >/dev/null 2>&1; then
  node local/open.mjs
elif [[ -x /opt/homebrew/bin/node ]]; then
  /opt/homebrew/bin/node local/open.mjs
elif [[ -x /usr/local/bin/node ]]; then
  /usr/local/bin/node local/open.mjs
else
  print "Instale Node.js 22.18 ou superior antes de abrir o ApresentaVC."
  read
fi
