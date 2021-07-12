-- local Keys = {
-- 	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
-- 	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
-- 	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
-- 	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
-- 	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
-- 	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
-- 	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
-- 	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
-- 	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
-- } 
-- i'll usually delete this and hardcode the values in, but it's super handy for reference.
local isReady = false
local Depot = {}
local Driver = {}
local Blip = {}
local BusBlip = {}
local pZones = {}

local DepotPolyList = nil
local currentZone = nil
local currentRoutes = nil
local pedGroup = nil
activeDepot = nil
activeBus = nil
activeDriver = nil
activeState = nil
--
function draw2screen(text, r, g, b, a, x, y, scale)
    SetTextFont(4)
    SetTextProportional(true)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end
--
function addBusPZones(depot, radius, useZ, debug, options)    
    print('zone ['..depot.name..'] Initiating')  
    table.insert(pZones, CircleZone:Create(vector3(depot.zones.menu.x, depot.zones.menu.y, depot.zones.menu.z), radius, {
        name=depot.name,
        useZ=useZ,
        data=depot,
        debugPoly=debug
    }))    
end
--
function fetchRouteFromDepot(depot, routeId)
    for i=1, #depot do
        if depot.routes[i].routeId==routeId then
            return depot.routes[i]
        end
    end   
end
function spawnBusDriver(Depot, cb)
    Citizen.CreateThread(function()
        RequestModel(GetHashKey('u_m_m_promourn_01'))	
        while not HasModelLoaded(GetHashKey('u_m_m_promourn_01')) do
            Wait(1)
        end
        local npc = CreatePed(5, 'u_m_m_promourn_01', Depot.zones.departure.x, Depot.zones.departure.y, Depot.zones.departure.z, 0.0, true, false)
        SetEntityInvincible(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, false)
        SetPedCanPlayAmbientAnims(npc, true)
        SetPedRelationshipGroupDefaultHash(npc, pedGroup)
        SetPedRelationshipGroupHash(npc, pedGroup)
        SetCanAttackFriendly(npc, false, false)
        SetPedCombatMovement(npc, 0)
        if cb ~= nil then
			cb(npc)
		end
    end)
end
function spawnBusAtDepot(busmodel, x, y, z, heading, driverPed, route, cb)
    local model = (type(busmodel) == 'number' and busmodel or GetHashKey(busmodel))
    Citizen.CreateThread(function()
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end
		local vehicle = CreateVehicle(model, x, y, z, heading, true, false)
		local id      = NetworkGetNetworkIdFromEntity(vehicle)
		SetNetworkIdCanMigrate(id, true)
		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, false)
		SetVehicleNeedsToBeHotwired(vehicle, false)
        --
        -- SetVehicleExclusiveDriver(vehicle, driverPed)
        -- SetVehicleExclusiveDriver_2(vehicle, driverPed)
        --
		SetModelAsNoLongerNeeded(model)
		RequestCollisionAtCoord(x, y, z)
		while not HasCollisionLoadedAroundEntity(vehicle) do
			RequestCollisionAtCoord(x, y, z)
			Citizen.Wait(0)
		end
		SetVehRadioStation(vehicle, 'OFF')
        -- -- add bus blip
        -- BusBlip[vehicle] = AddBlipForEntity(vehicle)
        -- SetBlipSprite (BusBlip[vehicle], 513)
        -- SetBlipDisplay(BusBlip[vehicle], 4)
        -- SetBlipScale  (BusBlip[vehicle], 0.8)
        -- SetBlipColour (BusBlip[vehicle], 3)
        -- SetBlipAsShortRange(BusBlip[vehicle], true)
        -- BeginTextCommandSetBlipName("STRING")
        -- AddTextComponentString('Bus')
        -- EndTextCommandSetBlipName(BusBlip[vehicle])
		if cb ~= nil then
			cb(vehicle)
		end
	end)
end
function DeleteBusAndDriver(vehicle, driver)
	if DoesEntityExist(vehicle) then
		if IsPedInVehicle(PlayerPedId(), vehicle, false) then
			TaskLeaveVehicle(PlayerPedId(), vehicle, 0)
		end

		local blip = GetBlipFromEntity(vehicle)

		if DoesBlipExist(blip) then
			RemoveBlip(blip)
            BusBlip[vehicle] = nil
		end

		DeleteEntity(driver)
		DeleteEntity(vehicle)
        activeBus = nil
        activeDriver = nil
	end

	if not DoesEntityExist(vehicle) and DoesEntityExist(driver) then
		DeleteEntity(driver)
	end
    activeState = nil
end
-- NET HANDLERS
RegisterNetEvent('bdm:errormsg')
AddEventHandler('bdm:errormsg', function(errormsg)	
    print(errormsg)    
end)
--
RegisterNetEvent('bdm:updatedepot')
AddEventHandler('bdm:updatedepot', function(depot)
    Depot = depot
    for i=1, #depot do
        addBusPZones(depot[i], 1.0, false, true, {})
    end    
    DepotPolyList = ComboZone:Create(pZones, {name="DepotPolyList", debugPoly=true})
    DepotPolyList:onPlayerInOut(function(isPointInside, point, zone)
        if zone then
            if isPointInside then
                currentZone = zone.data
                currentRoutes = zone.data.routes       
                SendNUIMessage({
                    zone = zone.data,
                    depots = Depot
                })
              else
                currentZone = nil
                currentRoutes = nil
                SendNUIMessage({
                    close = true
                })
              end
        end
    end)
end)
--
RegisterNetEvent('bdm:updatedriver')
AddEventHandler('bdm:updatedriver', function(driver)
	Driver = driver
    print('Bus Driver List Updated')
end)
--
RegisterNetEvent('bdm:beginroute')
AddEventHandler('bdm:beginroute', function(busData) 
    local zData = busData[1]
    local dData = busData[2]
    if activeBus then DeleteBusAndDriver(activeBus, activeDriver) end
    Citizen.Wait(100)
    local busdriver = spawnBusDriver(zData, function(pData)
        local drivenbus = spawnBusAtDepot('coach', zData.zones.departure.x, zData.zones.departure.y, zData.zones.departure.z, zData.zones.departure.h, pData, 1, function(bData)
            activeBus = bData
            activeDriver = pData
            activeDepot = dData
            print('[Route] '..dData.uid..' [driver] '..pData..' [bus] '..bData)                        
            SetPedIntoVehicle(pData, bData, -1)
            SetVehicleIsConsideredByPlayer(bData, false)
            SetPedCanBeDraggedOut(pData, false)
            SetPedStayInVehicleWhenJacked(pData, true)
            local playerPed = PlayerPedId()
            SetPedIntoVehicle(playerPed, bData, 0)
            activeState = 1
            Citizen.Wait(100)
            TaskVehicleDriveToCoordLongrange(activeDriver, activeBus, dData.zones.recieving.x, dData.zones.recieving.y, dData.zones.recieving.z, 15.0, 411, 5.0)
            SetPedKeepTask(activeDriver, true)
        end)
    end)
end)
--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
        if isReady == true then
            for i=1, #Depot do
                if not DoesBlipExist(Blip[Depot[i].uid]) then                    
                    Blip[Depot[i].uid] = AddBlipForCoord(Depot[i].zones.menu.x, Depot[i].zones.menu.y, Depot[i].zones.menu.z)
                    SetBlipSprite(Blip[Depot[i].uid], Depot[i].blip.sprite)
                    SetBlipDisplay(Blip[Depot[i].uid], 4)
                    SetBlipScale(Blip[Depot[i].uid], Depot[i].blip.scale)
                    SetBlipColour(Blip[Depot[i].uid], Depot[i].blip.color)
                    SetBlipAsShortRange(Blip[Depot[i].uid], true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString("Bus Transfer")
                    EndTextCommandSetBlipName(Blip[Depot[i].uid])
                end
            end
        end
    end
end)
--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
        if activeBus ~= nil then
            local buscoords = GetEntityCoords(activeBus)
            local distancetostop = GetDistanceBetweenCoords(buscoords[1], buscoords[2], buscoords[3], activeDepot.zones.recieving.x, activeDepot.zones.recieving.y, activeDepot.zones.recieving.z, false)
            -- local busseats = GetVehicleModelNumberOfSeats(GetEntityModel(activeBus))
            if activeState == nil  then
                TaskVehicleTempAction(activeDriver, activeBus, 6, 2000)
                SetVehicleHandbrake(activeBus, true)
                SetVehicleEngineOn(activeBus, true, true, false)
            else
                SetVehicleHandbrake(activeBus, false)
                if distancetostop <= 120.0 then
                    if distancetostop >= 119.0 then                         
                    -- TaskVehicleTempAction(activeDriver, activeBus, 1)
                        -- print('slowing speedlr')
                        TaskVehicleDriveToCoordLongrange(activeDriver, activeBus, activeDepot.zones.recieving.x, activeDepot.zones.recieving.y, activeDepot.zones.recieving.z, 12.5, 411, 5.0)
                        SetPedKeepTask(activeDriver, true)
                    end
                end
                if distancetostop <= 75.0 then
                    if distancetostop >= 74.0 then                         
                    -- TaskVehicleTempAction(activeDriver, activeBus, 1)
                        -- print('slowing speedmr')
                        TaskVehicleDriveToCoordLongrange(activeDriver, activeBus, activeDepot.zones.recieving.x, activeDepot.zones.recieving.y, activeDepot.zones.recieving.z, 10.0, 411, 5.0)
                        SetPedKeepTask(activeDriver, true)
                    end
                end
                if distancetostop <= 50.0 then
                    if distancetostop >= 49.0 then                         
                    -- TaskVehicleTempAction(activeDriver, activeBus, 1)
                        -- print('slowing speedsr')
                        TaskVehicleDriveToCoordLongrange(activeDriver, activeBus, activeDepot.zones.recieving.x, activeDepot.zones.recieving.y, activeDepot.zones.recieving.z, 7.5, 411, 5.0)
                        SetPedKeepTask(activeDriver, true)
                    end
                end
                if distancetostop <= 30.0 then
                    if distancetostop >= 29.0 then                         
                    -- TaskVehicleTempAction(activeDriver, activeBus, 1)
                        -- print('slowing speedsr')
                        TaskVehicleDriveToCoordLongrange(activeDriver, activeBus, activeDepot.zones.recieving.x, activeDepot.zones.recieving.y, activeDepot.zones.recieving.z, 5.0, 411, 5.0)
                        SetPedKeepTask(activeDriver, true)
                    end
                end
                if distancetostop <= 15.0 then  
                    print('brake applied')  
                    TaskVehicleTempAction(activeDriver, activeBus, 6, 2000)
                    SetVehicleHandbrake(activeBus, true)
                    SetVehicleEngineOn(activeBus, false, true, false)                    
                    local playerPed = PlayerPedId()    
                    ClearPedTasks(playerPed)
                    TaskLeaveVehicle(playerPed, activeBus, 512)
                    Citizen.Wait(5000)
                    DeleteBusAndDriver(activeBus, activeDriver)  
                end
            end            
        end
	end
end)
RegisterNUICallback('nuifocus', function(nuistate, cb)    
    SetNuiFocus(nuistate.state, nuistate.state)
    cb(true)
end)
RegisterNUICallback('depotSelected', function(zone, cb)
    TriggerServerEvent('bdm:requestRoute', zone)
    cb(true)
end)
--------------INIT--------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if NetworkIsPlayerActive(PlayerId()) then
			TriggerServerEvent('bdm:getlists')
            local v, pedGroup = AddRelationshipGroup('bdmDrivers')  
            SetRelationshipBetweenGroups(0, GetHashKey("PLAYER"), pedGroup) -- players and bus drivers
            SetRelationshipBetweenGroups(0, pedGroup, GetHashKey("PLAYER")) -- bus drivers and players    
            print('Bus Driver<>Player Relationship Set to : '..GetRelationshipBetweenGroups(GetHashKey("PLAYER"), pedGroup))
            isReady = true
			break
		end
	end
end)