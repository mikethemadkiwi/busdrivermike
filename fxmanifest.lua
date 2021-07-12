fx_version "cerulean"
games {"gta5"}
dependencies {
    'yarn',
    'PolyZone'
}
files {
    'nui/ui.html',
    'nui/ui.css',
    'nui/ui.js'
}
ui_page "nui/ui.html"
-- Common Scripts
client_scripts {
  '@PolyZone/client.lua',
  '@PolyZone/BoxZone.lua',
  '@PolyZone/EntityZone.lua',
  '@PolyZone/CircleZone.lua',
  '@PolyZone/ComboZone.lua'
}
client_script 'client.lua'
server_script 'server.lua'