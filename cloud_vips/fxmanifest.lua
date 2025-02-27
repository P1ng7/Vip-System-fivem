fx_version 'adamant'
game 'gta5'
description 'P1ng vip-system'
lua54 'yes'
version 'BETA'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}

client_scripts {
    'client/*.lua'
}

escrow_ignore {
    "config.lua"
}