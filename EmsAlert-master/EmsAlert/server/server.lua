ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('ems-alerts:serverFull')
AddEventHandler('ems-alerts:serverFull', function(suc, sokakadi, arac, plaka, renk, cinsiyet, x, y, date, minute)
local baris, bazq, codex, dichter, lahmacun, ruqen, lunny, adiss, as, kardsm = suc, sokakadi, arac, plaka, renk, cinsiyet, x, y, date, minute
TriggerClientEvent('ems-alerts:Full', -1, baris, bazq, codex, dichter, lahmacun, ruqen, lunny, adiss, as, kardsm)
end)

RegisterServerEvent('ems-alerts:serverNormal')
AddEventHandler('ems-alerts:serverNormal', function(suc, sokakadi, cinsiyet, x, y, date, minute)
local bus, turk, nitros, atsizinamcigi, atsiz, sa = suc, sokakadi, cinsiyet, x, y, date
TriggerClientEvent('ems-alerts:Normal', -1, bus, turk, nitros, atsizinamcigi, atsiz, sa, minute)
end)

ESX.RegisterServerCallback("adiss:itemkontrol5", function(source, cb, itemname)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem(itemname)["count"]

    if item >= 1 then
        cb(true)
    else
        cb(false) 
    end
end)

ESX.RegisterServerCallback('otuziki:erp:server:getCharnameFromId', function(source, cb)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer ~= nil then
		exports.ghmattimysql:execute('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier,
		}, function(result)
			if result[1] ~= nil then
				cb(result[1].firstname, result[1].lastname)
			else
				cb(nil)
			end
		end)
	end
end)

RegisterServerEvent('ab-ems-yardim:Server')
AddEventHandler('ab-ems-yardim:Server', function(KodSvy, x, y)
    local kodlahmacun, sovus, annen = KodSvy, x, y
    TriggerClientEvent('ab-ems-yardim:bildirim', -1, kodlahmacun, sovus, annen)
end)
