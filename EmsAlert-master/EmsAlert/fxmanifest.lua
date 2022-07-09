fx_version 'bodacious'
game 'gta5'

ui_page {
    'html/ui.html',
}

files {
	'html/ui.html',
	'html/js/app.js', 
	'html/css/style.css',
	"html/fontawesome/webfonts/fa-solid-900.ttf",
	"html/fontawesome/css/all.css",
}

client_scripts {
	'client/main.lua'
}

server_scripts {
	"server/server.lua"
}
--client_script 'fyac.lua'