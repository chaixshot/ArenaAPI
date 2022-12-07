fx_version 'cerulean'
lua54 'yes'
game 'gta5'
-- use_fxv2_oal 'yes'

version '2.4.4'

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
    "html/*.html",
    "html/css/*.css",
    "html/scripts/*.js",
}

ui_page "html/index.html"
