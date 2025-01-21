ESX = nil

local showBankBlips = true
local atBank = false
local bankMenu = true
local inMenu = false
local atATM = false
local bankColor = "red"
local show = true
--local show = DrawTxtmaxez(0.910, 0.920, 1.0,1.55,0.4," กด [ ~r~E ~w~] เพื่อเปิดธนาคาร ", 255,255,255,255)

local bankLocations = {
    {i = 108, c = 77, x = 241.727, y = 220.706, z = 106.286, s = 0.8, n = '<font face="Thaifont"> ธนาคาร </font>'}, -- blip id, blip color, x, y, z, scale, name/label
	{i = 108, c = 77, x = 150.266, y = -1040.203, z = 29.374, s = 0.7, n = '<font face="Thaifont"> ธนาคาร </font>'},
	{i = 108, c = 77, x = -1212.980, y = -330.841, z = 37.787, s = 0.7, n = '<font face="Thaifont"> ธนาคาร </font>'},
	{i = 108, c = 77, x = -2962.582, y = 482.627, z = 15.703, s = 0.7, n = '<font face="Thaifont"> ธนาคาร </font>'},
	{i = 108, c = 77, x = -112.202, y = 6469.295, z = 31.626, s = 0.7, n = '<font face="Thaifont"> ธนาคาร </font>'},
	{i = 108, c = 77, x = 314.187, y = -278.621, z = 54.170, s = 0.7, n = '<font face="Thaifont"> ธนาคาร </font>'},
	{i = 108, c = 77, x = -351.534, y = -49.529, z = 49.042, s = 0.7, n = '<font face="Thaifont"> ธนาคาร </font>'},
	{i = 108, c = 77, x = 1175.0643310547, y = 2706.6435546875, z = 38.094036102295, s = 0.7, n = '<font face="Thaifont"> ธนาคาร </font>'}
}

-- ATM Object Models
local ATMs = {
    {o = -870868698, c = 'blue'}, 
    {o = -1126237515, c = 'blue'}, 
    {o = -1364697528, c = 'red'}, 
    {o = 506770882, c = 'green'}
}

Citizen.CreateThread(function()
	while ESX == nil or ORP == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(2000)
	end
	Citizen.Wait(2000)
end)


-- local show =  true
if bankMenu then
Citizen.CreateThread(function()
    while true do
        Wait(0)
        -- if show then
        --     show = true
        if playerNearBank() or playerNearATM() then
        --   if show then
        --      show = true

            --  DrawTxtmaxez(0.910, 0.920, 1.0,1.55,0.4," กด [ ~r~E ~w~] เพื่อเปิดธนาคาร ", 255,255,255,255) 
            --show = false
           -- DrawTxtmaxez(0.910, 0.920, 1.0,0.55,0.4,"กด [ ~r~E ~w~] เพื่อเปิดธนาคาร ", 255,255,255,255)
           --DrawTxtmaxez(0.910, 0.920, 1.0,1.55,0.4," กด [ ~r~E ~w~] เพื่อเปิดธนาคาร ", 255,255,255,255)
        --    if show then
        --    exports["NNaridZ_TextUI"]:ShowHelpNotification("กด ~INPUT_CONTEXT~ เพื่อเปิดธนาคาร")
        --     --DisplayHelpText( "Press ~INPUT_PICKUP~ To Enter ATM")
        --    end

            if IsControlJustPressed(0, 38) then
                openPlayersBank('bank')
                show = false
                local ped = GetPlayerPed(-1)
                
               
            end
         --end 
        --return true
        else
            show = true
            --bankMenu = true
            --DrawTxtmaxez(0.910, 0.920, 1.0,1.55,0.4," กด [ ~r~E ~w~] เพื่อเปิดธนาคาร ", 255,255,255,255)            
        end
        if IsControlJustPressed(0, 322) then
            inMenu = false
            SetNuiFocus(false, false)
            SendNUIMessage({type = 'close'})
            show = true
        end
    --end
    end
end )
end

RegisterCommand('atm', function(source, args) -- Command to access ATM when players are near instead of spam notifications when near an ATM
    if playerNearATM() then
        openPlayersBank('atm')
        local ped = GetPlayerPed(-1)
    else
        exports['zeskNotify']:Alert("ERROR", "<span style='color:#ff0000'>คุณไม่ได้อยู่ใกล้</span>", 5000, 'error')
        --xports['mythic_notify']:DoHudText('error', 'คุณไม่ได้อยู่ใกล้ ATM')
    end
end)

function openPlayersBank(type, color)
    local dict = 'anim@amb@prop_human_atm@interior@male@enter'
    local anim = 'enter'
    local ped = GetPlayerPed(-1)
    local time = 2500

    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(7)
    end

    TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 0, 0, 0, 0, 0)
   -- exports['progressBars']:startUI(time, "กำลังใส่การ์ด...")
   --exports["NNaridZ_TextUI"]:ShowHelpNotification("กด ~INPUT_CONTEXT~ เพื่อเปิดธนาคาร")
   TriggerEvent("mythic_progbar:client:progress", {
    name = "unique_action_name",
    duration = 2500,
    label = "กำลัง",
    useWhileDead = false,
    canCancel = false,
    controlDisables = {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    },
})
    Citizen.Wait(time)
    ClearPedTasks(ped)
    if type == 'bank' then 
        inMenu = true
        SetNuiFocus(true, true)
        bankColor = "blue"
        SendNUIMessage({type = 'openBank', color = bankColor})
        TriggerServerEvent('orp:bank:balance')
        TriggerServerEvent('orp:bank:moneyin')
        atATM = false    
    elseif type == 'atm' then
        inMenu = true
        SetNuiFocus(true, true)
        SendNUIMessage({type = 'openBank', color = bankColor})
        TriggerServerEvent('orp:bank:balance')
        TriggerServerEvent('orp:bank:moneyin')
        atATM = true
    end
end

-- local show = true

function playerNearATM() -- Check if a player is near ATM when they use command /atm
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    --local show = true

    for i = 1, #ATMs do
        local atm = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.0, ATMs[i].o, false, false, false)
        local atmPos = GetEntityCoords(atm)
        local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, atmPos.x, atmPos.y, atmPos.z, true)
        if dist < 1.5 then
            bankColor = ATMs[i].c
            if show then
                -- exports["NNaridZ_TextUI"]:ShowHelpNotification("กด ~INPUT_CONTEXT~ เพื่อเปิดธนาคาร")
                DrawTxtmaxez(0.910, 0.920, 1.0,1.55,0.4,"<h1 style='background-color:Orange;'> กด [ ~r~E ~w~] เพื่อเปิดธนาคาร </h1>", 255,255,255,255)
                
                
             
            end 
            return true
        end
    end
end

function playerNearBank() -- Checks if a player is near a bank
    local pos = GetEntityCoords(GetPlayerPed(-1))

    for _, search in pairs(bankLocations) do
        local dist = GetDistanceBetweenCoords(search.x, search.y, search.z, pos.x, pos.y, pos.z, true)

        if dist <= 1.0 then
            color = "blue"
            if show then
                --show = true
                DrawTxtmaxez(0.910, 0.920, 1.0,1.55,0.4," กด [ ~r~E ~w~] เพื่อเปิดธนาคาร ", 255,255,255,255)
             
            end
            --DrawTxtmaxez(0.910, 0.920, 1.0,1.55,0.4," กด [ ~r~E ~w~] เพื่อเปิดธนาคาร ", 255,255,255,255)
            -- if not dist <= 1.0 then
            --     DrawTxtmaxez(0.910, 0.920, 1.0,1.55,0.4," กด [ ~r~E ~w~] เพื่อเปิดธนาคาร ", 255,255,255,255) 
            -- end 

            return true
        end
    end
end

local blipsLoaded = false

Citizen.CreateThread(function() -- Add bank blips
    while true do
        Citizen.Wait(2000)
        if not blipsLoaded then
            for k, v in ipairs(bankLocations) do
                local blip = AddBlipForCoord(v.x, v.y, v.z)
		        SetBlipSprite(blip, v.i)
		        SetBlipScale(blip, v.s)
		        SetBlipAsShortRange(blip, true)
			    SetBlipColour(blip, v.c)
		        BeginTextCommandSetBlipName("STRING")
		        AddTextComponentString(tostring(v.n))
		        EndTextCommandSetBlipName(blip) 
            end
            blipsLoaded = true
        end
    end
end)

RegisterNetEvent('orp:bank:info')
AddEventHandler('orp:bank:info', function(balance)
    local id = PlayerId()
    local playerName = GetPlayerName(id)

    SendNUIMessage({
		type = "updateBalance",
		balance = balance,
        player = playerName,
		})
end)

RegisterNetEvent('orp:bank:infomoneyin')
AddEventHandler('orp:bank:infomoneyin', function(moneyin)
    local id = PlayerId()
    local playerName = GetPlayerName(id)

    SendNUIMessage({
		type = "updateMoneyin",
		moneyin = moneyin,
        player = playerName,
		})
end)

RegisterNUICallback('deposit', function(data)
    if not atATM then
        TriggerServerEvent('orp:bank:deposit', tonumber(data.amount))
        TriggerServerEvent('orp:bank:balance')
        TriggerServerEvent('orp:bank:moneyin')
    else
        exports['mythic_notify']:DoHudText('error', 'คุณไม่สามารถฝากเงินที่ ATM')
    end
end)

RegisterNUICallback('withdrawl', function(data)
    TriggerServerEvent('orp:bank:withdraw', tonumber(data.amountw))
    TriggerServerEvent('orp:bank:balance')
    TriggerServerEvent('orp:bank:moneyin')
end)

RegisterNUICallback('balance', function()
    TriggerServerEvent('orp:bank:balance')
    TriggerServerEvent('orp:bank:moneyin')
end)

RegisterNetEvent('orp:balance:back')
AddEventHandler('orp:balance:back', function(balance)
    SendNUIMessage({type = 'balanceReturn', bal = balance})
end)

RegisterNetEvent('orp:moneyin:back')
AddEventHandler('orp:moneyin:back', function(moneyin)
    SendNUIMessage({type = 'moneyinReturn', bal = moneyin})
end)

function closePlayersBank()
    local dict = 'anim@amb@prop_human_atm@interior@male@exit'
    local anim = 'exit'
    local ped = GetPlayerPed(-1)
    local time = 1800

    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(7)
    end

    SetNuiFocus(false, false)
    SendNUIMessage({type = 'closeAll'})
   -- show = true
    TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 0, 0, 0, 0, 0)
    --exports['progressBars']:startUI(time, "กำลังเรียกบัตร...")
    TriggerEvent("mythic_progbar:client:progress", {
        name = "unique_action_name",
        duration = 1800,
        label = "กำลัง",
        useWhileDead = false,
        canCancel = false,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
    })
    Citizen.Wait(time)
    ClearPedTasks(ped)
    inMenu = false
    show = true
end


RegisterNUICallback('transfer', function(data)
    TriggerServerEvent('orp:bank:transfer', data.to, data.amountt)
    TriggerServerEvent('orp:bank:balance')
end)

RegisterNetEvent('orp:bank:notify')
AddEventHandler('orp:bank:notify', function(type, message)
    exports['mythic_notify']:DoHudText(type, message)
end)

AddEventHandler('onResourceStop', function(resource)
    inMenu = false
    SetNuiFocus(false, false)
    SendNUIMessage({type = 'closeAll'})
    show = true
end)

RegisterNUICallback('NUIFocusOff', function()
    closePlayersBank()
end)

RegisterFontFile('ThaiFont')
fontId = RegisterFontId('ThaiFont')

function DisplayHelpText(str)
    SetTextFont(fontId)
    SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function DrawTxtmaxez(x,y ,width,height,scale, text, r,g,b,a)
	SetTextFont(fontId)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
    --DrawRect(0.7, 0.9, 0.15,0.10,66,134,244,245)
	DrawText(x - width/2, y - height/20.5 + 0.059)
end