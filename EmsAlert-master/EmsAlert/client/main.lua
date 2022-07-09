local bildirimgeldi = false
local bildirimnoktasix = nil
local bildirimnoktasiy = nil
local bildirimAktif = true
local PlayerData  = {}
local toggleOld = false
local closestAmbulance = 0
local active = false
local ACTIVE_EMERGENCY_PERSONNEL = {}

ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(200)
    end
    PlayerData = ESX.GetPlayerData()
end)

-- RegisterCommand("ELFATİHA-EMS", function()
-- 	TriggerEvent("ems-alerts:EmsLazım", "Adam Ölü Git Bi Bak", false)
-- end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    PlayerData = ESX.GetPlayerData()
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterCommand("kod", function(source, args)
    local KodSvy = args[1]

    if KodSvy == nil then
        KodSvy = 0
    end
    if PlayerData.job.name == "ambulance"  then
        ESX.TriggerServerCallback("adiss:itemkontrol5", function(output)
            if output then
                ESX.TriggerServerCallback('otuziki:erp:server:getCharnameFromId', function(charname)
                --table.insert(elements, { label = charname, value = GetPlayerServerId(players[i])})
               
                    local suc = "Polis " ..charname.. " Yardım İstiyor Kod / " .. KodSvy
                    if PlayerData.job.name == "ambulance" then
                        local suc = "Doktor " ..charname.. " Yardım İstiyor Kod / " .. KodSvy
                    end 
                    if not KodSvy then
                        ESX.ShowNotification('Lütfen kod levelini belirtin 1, 2, 3, 99')
                    else
                        TriggerEvent("ems-alerts:EmsLazım", suc, false, false, false)
                        TriggerServerEvent("ab-ems-yardim:Server", KodSvy, x, y)
                        ESX.ShowNotification('Kod' .. KodSvy ..' Gönderildi!', 10000)
                    end

                    if KodSvy == "99" then
                        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, '99', 0.3)
                    end
                end)
            else
                ESX.ShowNotification('Üzerinde GPS Olmadığı İçin Kod Gönderemiyorsun')
            end
        end, "gps")
    end
end)

function playCode99Sound()
    PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
    Wait(900)
    PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
    Wait(900)
    PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
end


RegisterNetEvent('ab-ems-yardim:bildirim')
AddEventHandler('ab-ems-yardim:bildirim', function(KodSvy, x, y)
    if KodSvy == "99" then
        playCode99Sound()
    end
end)

RegisterNetEvent("ems-alerts:Normal")
AddEventHandler("ems-alerts:Normal", function(suc, sokakadi, cinsiyet, x, y, date, minute)
    if PlayerData.job.name == "ambulance"  then
        mapblip(suc, x, y)
        normal(suc, sokakadi, cinsiyet, x, y, date, minute)  
    end
end)

RegisterNetEvent("ems-alerts:Full")
AddEventHandler("ems-alerts:Full", function(suc, sokakadi, arac, plaka, renk, cinsiyet, x, y, date, minute)
    if PlayerData.job.name == "ambulance"  then
        mapblip(suc, x, y)
        full(suc, sokakadi, arac, plaka, renk, cinsiyet, x, y, date, minute)  
    end
end)

local bigMap = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if PlayerData.job and PlayerData.job.name == "ambulance" then
            if IsControlJustPressed(0, 178) and not toggleOld then
                TriggerEvent("ab-closest-police", function(data)
                    closestAmbulance = data
                    toggleOld = true
                    TriggerEvent("ab-hud:big-map", true)
                    SendNUIMessage({
                        action = 'showOld',
                        closestAmbulance = data.closestAmbulance,
                        activeAmbulance = data.ambulanceCount
                    })
                    SetNuiFocus(true, true)
                    Citizen.Wait(1000)
                end)
            -- else
            --     if bigMap then
            --         bigMap = false
            --         TriggerEvent("ab-hud:big-map", bigMap)
            --     else
            --         bigMap = true
            --         TriggerEvent("ab-hud:big-map", bigMap)
            --     end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        local playerPed = PlayerPedId()
        local inVeh = IsPedInAnyVehicle(playerPed)
        if inVeh then
            local playerVehicle = GetVehiclePedIsIn(playerPed)
            if GetPedInVehicleSeat(playerVehicle, -1) == playerPed then
                if GetVehicleClass(playerVehicle) == 18 and not PlayerData.job.name == "police" and not PlayerData.job.name == "ambulance" then
                    TriggerEvent("ems-alerts:EmsLazım", "Çalıntı Devlet Aracı", false)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if bigMap then
            DisableControlAction(0, 22, true) -- Jump
            DisableControlAction(0, 44, true) -- Cover
            DisableControlAction(0, 288, true) --F1
            DisableControlAction(0, 289, true) -- F2
            DisableControlAction(0, 170, true) -- F3
            DisableControlAction(0, 167, true) -- F6
            DisableControlAction(0, 26, true) -- Disable looking behind
            DisableControlAction(2, 199, true) -- Disable pause screen
            DisableControlAction(0, 1, true)  -- Disable weapon
            DisableControlAction(0, 2, true) -- Disable melee
            DisableControlAction(0, 3, true) -- Disable melee
            DisableControlAction(0, 4, true) -- Disable melee
            DisableControlAction(0, 6, true) -- Disable melee
            DisableControlAction(0, 30, true) -- MoveLeftRight
			DisableControlAction(0, 31, true) -- MoveUpDown
            DisableControlAction(0, 32, true) -- move (w)
            DisableControlAction(0, 34, true) -- move (a)
            DisableControlAction(0, 33, true) -- move (s)
            DisableControlAction(0, 35, true) -- move (d)
        end
    end
end)

Citizen.CreateThread(function()
	while true do
        local time = 250
        if bildirimgeldi then
            time = 1
			if IsControlJustPressed(0, 38) then
				SetNewWaypoint(bildirimnoktasix, bildirimnoktasiy)
				bildirimgeldi = false
				bildirimnoktasix = nil
				bildirimnoktasiy = nil
            end
        end
        Citizen.Wait(time)
    end
end)

RegisterNUICallback('setCoords', function(coords, cb)
    ESX.ShowNotification("Konum GPS'de İşaretlendi") 
    SetNewWaypoint(coords.x, coords.y)
end)

RegisterNUICallback('closeui', function()
	toggleOld = false
    SetNuiFocus(false, false)
    TriggerEvent("ab-hud:big-map", false)
end)

function normal(suc, sokakadi, cinsiyet, x, y, date, minute)
    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
	SendNUIMessage({
		action = 'normal',
		suc = suc,
		sokakadi = sokakadi,
		arac = "yok",
		plaka = "yok",
		renk = "yok",
        cinsiyet = cinsiyet,
        coords = {x, y},
        date = GetClockHours(),
        minute = GetClockMinutes()
    })
    
	suresifirla(x, y)
end

function full(suc, sokakadi, arac, plaka, renk, cinsiyet, x, y, date, minute)
    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
	SendNUIMessage({
		action = 'normal',
		suc = suc,
		sokakadi = sokakadi,
		arac = arac,
		plaka = plaka,
		renk = renk,
        cinsiyet = cinsiyet,
        coords = {x, y},
        date = GetClockHours(),
        minute = GetClockMinutes()
    })
    
	suresifirla(x, y)
end

function suresifirla(x, y)
    PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
	bildirimgeldi = true
	bildirimnoktasix = x
	bildirimnoktasiy = y
	Citizen.Wait(10000)
	if bildirimgeldi then
		bildirimgeldi = false
	end
end

function mapblip(sucAdi, x, y)
    if sucAdi == "Ateş Edildi" then
        TriggerEvent("ems-alerts:gunshotInProgress", x, y, 433)
    elseif sucAdi == "Ev Soygunu" then
        TriggerEvent("ems-alerts:gunshotInProgress", x, y, 40)
    elseif sucAdi == "Yasadışı Araç Teslimatı" then
        TriggerEvent("ems-alerts:gunshotInProgress", 361, 6098, 30)
    elseif sucAdi == "Yasadışı Silah Teslimatı" then
        TriggerEvent("ems-alerts:gunshotInProgress", 1740, 3326, 41)
    elseif sucAdi == "Yaralı Vatandaş" or sucAdi == "Polis Yardım İstiyor Kod / 1" or sucAdi == "Polis Yardım İstiyor Kod / 2" or sucAdi == "Polis Yardım İstiyor Kod / 3" or sucAdi == "Polis Yardım İstiyor Kod / 99" then
        TriggerEvent("ems-alerts:gunshotInProgress", x, y, 489)
    elseif sucAdi == "Market Soygunu" then
        TriggerEvent("ems-alerts:gunshotInProgress", x, y, 487)
    elseif sucAdi == "Çalıntı Devlet Aracı" then
        TriggerEvent("ems-alerts:gunshotInProgress", x, y, 672)
    elseif sucAdi == "Araç Hırsızlığı" then
        TriggerEvent("ems-alerts:gunshotInProgress", x, y, 380)
    elseif sucAdi == "Fleeca Soygunu" then
        TriggerEvent("ems-alerts:gunshotInProgress", x, y, 618)
    elseif sucAdi == "Banka Aracı Soygunu" then
        TriggerEvent("ems-alerts:gunshotInProgress", x, y, 477)
    elseif sucAdi == "Kuyumcu Soygunu" then
        TriggerEvent("ems-alerts:gunshotInProgress", x, y, 617)
    elseif sucAdi == "Yasa Dışı Bağlantı" then
    --     TriggerEvent("ems-alerts:gunshotInProgress", x, y, 618)
    -- elseif sucAdi == "Market soygunu" then
        TriggerEvent("ems-alerts:gunshotInProgress", x, y, 140)
    elseif sucAdi == "Banka Soygunu" then
        TriggerEvent("ems-alerts:gunshotInProgress", x, y, 618)
    elseif sucAdi == "Araç Parçalama" then
        TriggerEvent("ems-alerts:gunshotInProgress", x, y, 620)
    end
-- Yasadışı Eşya Satış İhbarı
end

RegisterNetEvent('ems-alerts:gunshotInProgress')
AddEventHandler('ems-alerts:gunshotInProgress', function(x, y, icon, sucAdi)
    local alpha = 200
    local gunshotBlip = AddBlipForCoord(x, y, 5.0)
	SetBlipSprite(gunshotBlip, icon)
    SetBlipDisplay(gunshotBlip, 2)
    SetBlipScale(gunshotBlip, 1.60)
    SetBlipColour(gunshotBlip, 75)
    SetBlipAsShortRange(gunshotBlip, false)
    SetBlipAlpha(gunshotBlip, alpha)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(sucAdi)
    EndTextCommandSetBlipName(gunshotBlip)

    while alpha ~= 0 do
        Citizen.Wait(60 * 6)
        alpha = alpha - 1
        SetBlipAlpha(gunshotBlip, alpha)

        if alpha == 0 then
            RemoveBlip(gunshotBlip)
            return
        end
    end
end)

RegisterNetEvent('ems-alerts:EmsLazım')
AddEventHandler('ems-alerts:EmsLazım', function(ihbaradi, plakagizle, kordinat, _vehActive)
    if bildirimAktif then
        if not _vehActive then
            vehActive = _vehActive
        else
            vehActive = true
        end

        local playerPed = PlayerPedId()	
        local vehicle = GetVehiclePedIsIn(playerPed)
        local pedKordinat = GetEntityCoords(playerPed)

        if kordinat then
            konum = vector3(kordinat.x, kordinat.y, kordinat.z)
        else
            konum = vector3(pedKordinat.x, pedKordinat.y, pedKordinat.z	)
        end
        local var1, var2 = GetStreetNameAtCoord(konum.x, konum.y, konum.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
        local sokak1 = GetStreetNameFromHashKey(var1)
        local sokak2 = GetStreetNameFromHashKey(var2)
        local sokakadi = sokak1
        if sokak2 ~= nil and sokak2 ~= '' then
            sokakadi = sokakadi .. ', ' .. sokak2
        end

        if IsPedMale(playerPed) then
            cinsiyet = "Erkek"
        else
            cinsiyet = "Kadın"
        end

        if IsPedInAnyVehicle(playerPed, false) and vehActive then
            local plakasans = math.random(1, 100)
            local AracRenk1 = GetVehicleCustomPrimaryColour(vehicle)
            local AracRenk2 = GetVehicleCustomSecondaryColour(vehicle)
            local renk1 = Renkler[tostring(AracRenk1)]
            local renk2 = Renkler[tostring(AracRenk2)]
            local model = GetEntityModel(vehicle)
            local aracadi = GetDisplayNameFromVehicleModel(model)
            
            if plakasans < 5 and not plakagizle then
                plaka = GetVehicleNumberPlateText(vehicle)
            else
                plaka = "Bilinmiyor"
            end

            if renk2 == renk1 then
                fullrenk = renk1
            else
                fullrenk = renk1 ..', '.. renk2
            end
            TriggerServerEvent("ems-alerts:serverFull", ihbaradi, sokakadi, aracadi, plaka, fullrenk, cinsiyet, konum.x, konum.y)
        else
            TriggerServerEvent("ems-alerts:serverNormal", ihbaradi, sokakadi, cinsiyet, konum.x, konum.y)
        end	    
    end
    
end)

-- Ateş Edince Polise Bildirim
-- Citizen.CreateThread(function()
--     while true do
--         local time = 1000
--         local ped = PlayerPedId()
--         if IsPedArmed(ped, 7) then
--             time = 1
--             if IsPedShooting(ped) and math.random(1,3) == 1 then
--                 local weaponSlec = GetSelectedPedWeapon(ped)
--                 if weaponSlec ~= `WEAPON_STUNGUN` and weaponSlec ~= `WEAPON_SNOWBALL` then
--                     if not PlayerData.job.name == 'ambulance' then
--                         TriggerEvent("ems-alerts:EmsLazım", "Ateş Edildi", false)
--                         Citizen.Wait(60000)
--                     end 
--                 end
--             end
--         end
--         Citizen.Wait(time)
--     end
-- end)

RegisterNetEvent('ab-polisbidirim:bildirim-aktif')
AddEventHandler('ab-polisbidirim:bildirim-aktif', function(status)
    bildirimAktif = status
end)




local Renkler = {
    ['0'] = "Siyah",
    ['1'] = "Siyah",
    ['2'] = "Siyah",
    ['3'] = "Koyu Gümüş",
    ['4'] = "Metalik Gümüş",
    ['5'] = "Metalik Mavi Gümüş",
    ['6'] = "Metalik Çelik Gray",
    ['7'] = "Metalik Gümüş",
    ['8'] = "Metalik Gümüş",
    ['9'] = "Metalik Gece Gümüşü",
    ['10'] = "Metal",
    ['11'] = "Metalik Gri",
    ['12'] = "Mat Siyah",
    ['13'] = "Mat Gray",
    ['14'] = "Mat Açık Gri",
    ['15'] = "Siyah",
    ['16'] = "Siyah ",
    ['17'] = "Koyu Gümüş",
    ['18'] = "Gümüş",
    ['19'] = "Gun Metal",
    ['20'] = "Gümüş",
    ['21'] = "Siyah",
    ['22'] = "Graphite",
    ['23'] = "Gümüş Gri",
    ['24'] = "Gümüş",
    ['25'] = "Gümüş Mavi",
    ['26'] = "Gümüş",
    ['27'] = "Metalik Kırmızı",
    ['28'] = "Metalik Torino Kırmızısı",
    ['29'] = "Metalik Formula Kırmızısı",
    ['30'] = "Metalik Blaze Kırmızısı",
    ['31'] = "Metalik Graceful Kırmızısı",
    ['32'] = "Metalik Garnet Kırmızısı",
    ['33'] = "Metalik Çöl Kırmızısı",
    ['34'] = "Metalik Cabernet Kırmızısı",
    ['35'] = "Metalik Şeker Kırmızısı",
    ['36'] = "Metalik Sunrise Turuncu",
    ['37'] = "Metalik Klasik Gold",
    ['38'] = "Metalik Turuncu",
    ['39'] = "Mat Kırmızı",
    ['40'] = "Mat Koyu Kırmızı",
    ['41'] = "Mat Turuncu",
    ['42'] = "Mat Sarı",
    ['43'] = "Kırmızı",
    ['44'] = "Parlak Kırmızı",
    ['45'] = "Garnet Kırmızısı",
    ['46'] = "Kırmızı",
    ['47'] = "Altın Kırmızısı",
    ['48'] = "Koyu Kırmızı",
    ['49'] = "Metalik Koyu Yeşil",
    ['50'] = "Metalik Racing Yeşil",
    ['51'] = "Metalik Sea Yeşil",
    ['52'] = "Metalik Olive Yeşil",
    ['53'] = "Metalik Yeşil",
    ['54'] = "Metalik Gasoline Mavi Yeşil",
    ['55'] = "Mat Lime Yeşil",
    ['56'] = "Koyu Yeşil",
    ['57'] = "Yeşil",
    ['58'] = "Koyu Yeşil",
    ['59'] = "Yeşil",
    ['60'] = "Deniz Mavisi",
    ['61'] = "Metalik Gece Mavisi",
    ['62'] = "Metalik Koyu Mavi",
    ['63'] = "Metalik Saxony Mavi",
    ['64'] = "Metalik Mavi",
    ['65'] = "Metalik Mariner Mavisi",
    ['66'] = "Metalik Harbor Mavisi",
    ['67'] = "Metalik Elmas Mavisi",
    ['68'] = "Metalik Surf Mavisi",
    ['69'] = "Metalik Nautical Mavisi",
    ['70'] = "Metalik Parlak Mavisi",
    ['71'] = "Metalik Mor Mavisi",
    ['72'] = "Metalik Spinnaker Mavi",
    ['73'] = "Metalik Ultra Mavi",
    ['74'] = "Metalik Açık Mavi",
    ['75'] = "Koyu Mavi",
    ['76'] = "Gece Mavi",
    ['77'] = "Mavi",
    ['78'] = "Sea Foam Mavi",
    ['79'] = "Uil Açık Mavi",
    ['80'] = "Maui Mavisi",
    ['81'] = "Açık Mavi",
    ['82'] = "Mat Koyu Mavi",
    ['83'] = "Mat Mavi",
    ['84'] = "Mat Gece Mavisi",
    ['85'] = "Koyu Mavi",
    ['86'] = "Mavi",
    ['87'] = "Açık Mavi",
    ['88'] = "Metalik Sarıs",
    ['89'] = "Metalik Sarıs",
    ['90'] = "Metalik Bronz",
    ['91'] = "Metalik Sarı",
    ['92'] = "Metalik Lime",
    ['93'] = "Metalik Champagne",
    ['94'] = "Metalik Pueblo Bej",
    ['95'] = "Metalik Koyu Ivory",
    ['96'] = "Metalik Kahverengi",
    ['97'] = "Metalik Altın Kahverengi",
    ['98'] = "Metalik Açık Kahverengi",
    ['99'] = "Metalik Saman Beji",
    ['100'] = "Metalik Moss Kahverengi",
    ['101'] = "Metalik Biston Kahverengi",
    ['102'] = "Metalik Beechwood",
    ['103'] = "Metalik Koyu Beechwood",
    ['104'] = "Metalik Turuncu",
    ['105'] = "Metalik Kum",
    ['106'] = "Metalik Kum",
    ['107'] = "Metalik Cream",
    ['108'] = "Kahverengi",
    ['109'] = "Kahverengi",
    ['110'] = "Açık Kahverengi",
    ['111'] = "Metalik Beyaz",
    ['112'] = "Metalik Buz Beyazı",
    ['113'] = "Bal Beji",
    ['114'] = "Kahverengi",
    ['115'] = "Koyu Kahverengi",
    ['116'] = "Saman Beji",
    ['117'] = "Çelik",
    ['118'] = "Siyah Çelik",
    ['119'] = "Alüminyum",
    ['120'] = "Krom",
    ['121'] = "Kapalı Beyaz",
    ['122'] = "Kapalı Beyaz",
    ['123'] = "Turuncu",
    ['124'] = "Açık Turuncu",
    ['125'] = "Metalik Securicor Yeşil",
    ['126'] = "Taksi Sarı",
    ['127'] = "Polis Mavisi",
    ['128'] = "Mat Yeşil",
    ['129'] = "Mat Kahverengi",
    ['130'] = "Turuncu",
    ['131'] = "Mat Beyaz",
    ['132'] = "Beyaz",
    ['133'] = "Olive Asker Yeşil",
    ['134'] = "Pure Beyaz",
    ['135'] = "Sıcak Pembe",
    ['136'] = "Salmon Pembe",
    ['137'] = "Metalik Vermillion Pembe",
    ['138'] = "Turuncu",
    ['139'] = "Yeşil",
    ['140'] = "Mavi",
    ['141'] = "Mettalic Siyah Mavi",
    ['142'] = "Metalik Siyah Mor",
    ['143'] = "Metalik Siyah Kırmızı",
    ['144'] = "Avcı Yeşili",
    ['145'] = "Metalik Mor",
    ['146'] = "Metaillic Koyu Mavi",
    ['147'] = "MODSHOP Siyahı",
    ['148'] = "Mat Mor",
    ['149'] = "Mat Koyu Mor",
    ['150'] = "Metalik Lav Kırmızısı",
    ['151'] = "Mat Forest Yeşil",
    ['152'] = "Mat Olive Drab",
    ['153'] = "Mat Çöl Kahverengisi",
    ['154'] = "Mat Çöl Tan",
    ['155'] = "Mat Foilage Yeşil",
    ['156'] = "DEFAULT ALLOY COLOR",
    ['157'] = "Epsilon Mavi",
}

function isWhitelisted()
	while ESX == nil do
		Citizen.Wait(10)
	end

	while PlayerData.job == nil do
		Citizen.Wait(10)
	end

	if PlayerData.job.name == 'ambulance' then
		return true
	elseif PlayerData.job.name == 'sheriff' then
		return true
	elseif PlayerData.job.name == 'police' then
		return true
	else
		return false
	end
end

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(5)
-- 		local ped = PlayerPedId()
-- 		if IsPedShooting(ped) then
-- 			if not isWhitelisted() then
-- 				if not IsPedCurrentWeaponSilenced(ped) then
--                     TriggerEvent("ems-alerts:EmsLazım", "Ateş Edildi", false)
-- 					Citizen.Wait(20000)
-- 				end
-- 			end
-- 		end
-- 	end
-- end)
