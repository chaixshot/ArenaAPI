fx_version 'cerulean'
lua54 'yes'
game 'gta5'
-- use_fxv2_oal 'yes'

version '2.5.4'

client_scripts {
    "client/2way.lua",
    "client/system/*.lua",
    "client/exports/*.lua",
    "client/*.lua",
}

server_script {
    "server/2way.lua",
    "server/main.lua",
    "server/default_events.lua",
    "server/exports/*.lua",
    "server/module/*.lua",
    "server/system/*.lua",
}

shared_scripts {
    "config.lua",
}

files {
    "client/ui/*.html",
    "client/ui/*.css",
    "client/ui/*.js",
}

ui_page "client/ui/index.html"
