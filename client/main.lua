ESX = nil                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if ESX == nil then
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(200)
        end
    end
end)

local checkingbag = false
local IsUIActive = false
local cachedBins = {}

local ragdoll_chance = 0.42



local Bags = {
    'prop_beach_bag_01b'
}


Citizen.CreateThread(function()
    Citizen.Wait(100)
    while true do
        
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        for i = 1, #Bags do
            local x = GetClosestObjectOfType(playerCoords, 2.0, GetHashKey(Bags[i]), false, false, false)
            local entity = nil
            if DoesEntityExist(x) then
                sleep  = 5
                entity = x
                bag    = GetEntityCoords(entity)
				DrawText3D(bag.x , bag.y, bag.z + 1, " Press ~g~[E]~w~ To Search")  
                if IsControlJustReleased(0, 38) then
                    if not cachedBins[entity] then
                        openBin(entity)
                    else
						
                        --GBCore.Functions.Notify('Jūs jau ieškojote ši krepši',"error", 3500)
                        TriggerClientEvent('esx:showHelpNotification', src, "You already searched this bag..")
                    end
                end
                break
            else
                sleep = 1000
            end
        end
        Citizen.Wait(sleep)
    end
end)



openBin = function(entity)
	searching = true
    cachedBins[entity] = true
     Tasjesdief()
	--ClearPedTasks(PlayerPedId())
	searching = false
end

function GetBagObject(radius)
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    local retval = nil
    for k, v in pairs(Bags) do
        local object = GetClosestObjectOfType(pos, radius, GetHashKey(v), false, false, false)
        if object ~= nil and object ~= 0 then
            retval = object
        end
    end
    return retval
end

function Tasjesdief()
    PrepareAnim()
    TriggerEvent('gb-keyminigame:show')
    TriggerEvent('gb-keyminigame:start', FinishMinigame)
end

function PrepareAnim()
    local ped = GetPlayerPed(-1)
    LoadAnim('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
    TaskPlayAnim(ped, 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 6.0, -6.0, -1, 47, 0, 0, 0, 0)
    PreparingAnimCheck()
end

function PreparingAnimCheck()
    checkingbag = true
    Citizen.CreateThread(function()
        while true do
            local ped = GetPlayerPed(-1)

            if checkingbag then
                if not IsEntityPlayingAnim(ped, 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 3) then
    LoadAnim('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
    TaskPlayAnim(ped, 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 6.0, -6.0, -1, 47, 0, 0, 0, 0)
               end
            else
                ClearPedTasksImmediately(ped)
                break
            end

            Citizen.Wait(200)
        end
    end)
end

function FinishMinigame(faults)
    local Quality = "common"
    if faults == 0 then
        Quality = "best"
    elseif faults == 1 then
        Quality = "bijna"
    end
	
	if Quality ~= nil and Quality ~= 0 then
		if Quality == "bijna" then
		ESX.TriggerServerCallback('cpbea:server:Reward', function() end)
		elseif Quality == "best" then
		ESX.TriggerServerCallback('cpbea:server:Reward', function() end)
		else
		ESX.TriggerServerCallback('cpbea:server:Reward', function() end)
		end
	end
    checkingbag = false
end

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 41, 11, 41, 60)
    ClearDrawOrigin()
end


function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(1)
    end
end

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(1)
    end
end
