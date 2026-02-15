fx_version 'cerulean'
game 'common'

version '0.1.0-dev'
description 'Player identifier and data persistence for FXServer.'
author 'David Malchin <malchin459@gmail.com>'
repository 'https://github.com/D4isDAVID/d4_playerdata'

lua54 'yes'
use_experimental_fxv2_oal 'yes'

server_scripts {
    'server/init.lua',
    'server/convars.lua',
    'server/utils/*.lua',
    'server/storage/**.lua',
    'server/api/*.lua',
    'server/commands/*.lua',
    'server/autoAssign.lua',
    'server/connecting.lua',
    'server/players.lua',
}

client_scripts {
    'client/init.lua',
}

files {
    'ui/dist/**',
}

ui_page 'ui/dist/index.html'
