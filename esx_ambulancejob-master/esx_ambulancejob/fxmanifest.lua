fx_version 'cerulean'
game 'gta5'

author 'ems rol pasi'


ui_page 'html/ui.html'

files {
	'html/**',
	"images/*"
}



server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/es.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'locales/cs.lua',
	'locales/nl.lua',
	'config.lua',
	'server/main.lua'
}


client_scripts {
	'@es_extended/locale.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/es.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'locales/cs.lua',
	'locales/nl.lua',
	'config.lua',
	'client/main.lua',
	'client/job.lua',
	'client/vehicle.lua',
}



exports {
	'GetDeath'
}
