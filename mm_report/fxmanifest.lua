fx_version 'cerulean'
game 'gta5'

author 'Memauo'
description 'Basic oxlib report system'

client_script 'client.lua'
server_script 'server.lua'
shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'locales/*.lua'
}
lua54 'yes'