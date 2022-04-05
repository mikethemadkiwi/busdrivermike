local isReady = false
local polydebug = false
local Depot = {}
local Driver = {}
local Blip = {}
local BusBlip = {}
local pZones = {}
local PassengerZones = {}
local signObjs = {}
local DepotPolyList = nil
local currentZone = nil
local currentRoutes = nil
local pedGroup = nil
local drivingStyle = 411
activeDepot = nil
activeBus = nil
activeBusNetId = nil
activeDriver = nil
activeState = nil
-- wot?
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
    table.insert(pZones, CircleZone:Create(vector3(depot.zones.menu.x, depot.zones.menu.y, depot.zones.menu.z), radius, {
        name=depot.name,
        useZ=useZ,
        data=depot,
        debugPoly=polydebug
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
        activeDriver = CreatePed(5, 'u_m_m_promourn_01', Depot.zones.menu.x+1.0, Depot.zones.menu.y, Depot.zones.menu.z, 0.0, true, false)        
        SetEntityInvincible(activeDriver, true)        
        SetDriverAbility(activeDriver, 1.0)
        SetDriverAggressiveness(activeDriver, 0.0)
        SetPedCanBeDraggedOut(activeDriver, false)
        SetPedStayInVehicleWhenJacked(activeDriver, true)
        SetBlockingOfNonTemporaryEvents(activeDriver, false)
        SetPedCanPlayAmbientAnims(activeDriver, true)
        SetPedRelationshipGroupDefaultHash(activeDriver, pedGroup)
        SetPedRelationshipGroupHash(activeDriver, pedGroup)
        SetCanAttackFriendly(activeDriver, false, false)
        SetPedCombatMovement(activeDriver, 0)
        print('driver spawn:'.. activeDriver .. '')
        if cb ~= nil then
			cb(activeDriver)
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
		activeBus = CreateVehicle(model, x, y, z, heading, true, false)
		activeBusNetId      = NetworkGetNetworkIdFromEntity(activeBus)
		SetNetworkIdCanMigrate(activeBusNetId, true)
		SetEntityAsMissionEntity(activeBus, true, false)
		SetVehicleHasBeenOwnedByPlayer(activeBus, false)
        SetDisableVehicleWindowCollisions(activeBus, false)
        SetEntityInvincible(activeBus, true)
		SetVehicleNeedsToBeHotwired(activeBus, false)
		SetModelAsNoLongerNeeded(model)
		RequestCollisionAtCoord(x, y, z)
		while not HasCollisionLoadedAroundEntity(activeBus) do
			RequestCollisionAtCoord(x, y, z)
			Citizen.Wait(0)
		end
		SetVehRadioStation(activeBus, 'OFF')
        print('bus spawn:'.. activeBus .. ' netid: '.. activeBusNetId ..'')
		if cb ~= nil then
			cb(activeBus)
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
function putplayerinseat(busid)    
    local numPass = GetVehicleMaxNumberOfPassengers(busid) - 1 
    for j=-1, numPass do
        local isfree = IsVehicleSeatFree(busid, j)        
        if isfree == 1 then
            local playerPed = PlayerPedId()
            TaskEnterVehicle(playerPed, busid, 15000, j, 2.0, 1, 0)
            TriggerServerEvent('bdm:passentered', {busid})
            break
        end        
    end
end
-- NET HANDLERS
AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() == resourceName then
        DeleteBusAndDriver(activeBus, activeDriver)
        for j=1, #signObjs do
            DeleteObject(signObjs[j])        
        end
    end
end)
RegisterNetEvent('bdm:errormsg')
AddEventHandler('bdm:errormsg', function(errormsg)	
    print(errormsg)    
end)
--
RegisterNetEvent('bdm:updatedepot')
AddEventHandler('bdm:updatedepot', function(depot)
    Depot = depot
    for j=1, #signObjs do
        DeleteObject(signObjs[j])        
    end
    for i=1, #depot do
        addBusPZones(depot[i], 2.0, false, true, {})
        signObjs[Depot[i].uid] = CreateObject(-1022684418, Depot[i].zones.menu.x, Depot[i].zones.menu.y, Depot[i].zones.menu.z, false, false, false)
    end    
    DepotPolyList = ComboZone:Create(pZones, {name="DepotPolyList", debugPoly=polydebug})
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
end)
--
RegisterNetEvent('bdm:makeclientpass')
AddEventHandler('bdm:makeclientpass', function(bId)
    -- SetVehicleIsConsideredByPlayer(buspass, false)
    local pCoords = vector3(bId[3].zones.passenger.x, bId[3].zones.passenger.y, bId[3].zones.passenger.z)
    PassengerZones[bId[2]] = CircleZone:Create(pCoords, 1.0, {
        name="passengerZone",
        useZ=false,
        debugPoly=polydebug
    })
    PassengerZones[bId[2]]:onPlayerInOut(function(isPointInside, point, zone)
        if isPointInside then
            local buspass = NetworkGetEntityFromNetworkId(bId[2])
            putplayerinseat(buspass) 
            print('Entered Bus LOCAL: '..buspass..' NET: '..bId[2]..' ')
        end
    end)	
end)
--
RegisterNetEvent('bdm:delclientpass')
AddEventHandler('bdm:delclientpass', function(bId)
    -- local buspass = NetworkGetEntityFromNetworkId(bId[2])  
    PassengerZones[bId[2]]:destroy()
end)
--
RegisterNetEvent('bdm:oob')
AddEventHandler('bdm:oob', function(bId) 
    local playerPed = PlayerPedId()
    local isinbus = GetVehiclePedIsIn(playerPed, false)
    local buspass = NetworkGetEntityFromNetworkId(bId[2]) 
    if isinbus == buspass then
        TaskLeaveVehicle(playerPed, buspass, 512)
    end
end)
--
RegisterNetEvent('bdm:beginroute')
AddEventHandler('bdm:beginroute', function(busData)
    local zData = busData[1]
    activeDepot = busData[2]
    if activeBus ~= nil then DeleteBusAndDriver(activeBus, activeDriver) end
    Citizen.Wait(100)
    local busdriver = spawnBusDriver(zData, function(pData)
        Citizen.Wait(100)
        local drivenbus = spawnBusAtDepot('coach', zData.zones.departure.x, zData.zones.departure.y, zData.zones.departure.z, zData.zones.departure.h, pData, 1, function(bData)
            SetPedIntoVehicle(activeDriver, activeBus, -1)            
            -----------------------------------------------------
            TriggerServerEvent('bdm:makepass', {activeBus,activeBusNetId,zData})  
            Citizen.Wait(30000)
            TriggerServerEvent('bdm:delpass', {activeBus,activeBusNetId})
            Citizen.Wait(1000)
            for i = 0, 5 do
                SetVehicleDoorShut(activeBus, i, false)
            end
            activeState = 1
            TaskVehicleDriveToCoordLongrange(activeDriver, activeBus, activeDepot.zones.recieving.x, activeDepot.zones.recieving.y, activeDepot.zones.recieving.z, 15.0, drivingStyle, 5.0)
            SetPedKeepTask(activeDriver, true)
            ---------------------------------------------------- 
        end)
    end)
    --
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

            if IsVehicleStuckOnRoof(activeBus) or IsEntityUpsidedown(activeBus) or IsEntityDead(activeDriver) or IsEntityDead(activeBus) then
                DeleteBusAndDriver(activeBus, activeDriver)  
            end

            local buscoords = GetEntityCoords(activeBus)
            local distancetostop = GetDistanceBetweenCoords(buscoords[1], buscoords[2], buscoords[3], activeDepot.zones.recieving.x, activeDepot.zones.recieving.y, activeDepot.zones.recieving.z, false)
            if activeState == nil  then
                TaskVehicleTempAction(activeDriver, activeBus, 6, 2000)
                SetVehicleHandbrake(activeBus, true)
                SetVehicleEngineOn(activeBus, true, true, false)
            else
                SetVehicleHandbrake(activeBus, false)
                if distancetostop <= 100.0 then
                    if distancetostop >= 99.0 then
                        TaskVehicleDriveToCoordLongrange(activeDriver, activeBus, activeDepot.zones.recieving.x, activeDepot.zones.recieving.y, activeDepot.zones.recieving.z, 12.5, drivingStyle, 5.0)
                        SetPedKeepTask(activeDriver, true)
                    end
                end
                if distancetostop <= 75.0 then
                    if distancetostop >= 74.0 then
                        TaskVehicleDriveToCoordLongrange(activeDriver, activeBus, activeDepot.zones.recieving.x, activeDepot.zones.recieving.y, activeDepot.zones.recieving.z, 10.0, drivingStyle, 5.0)
                        SetPedKeepTask(activeDriver, true)
                    end
                end
                if distancetostop <= 50.0 then
                    if distancetostop >= 49.0 then 
                        TaskVehicleDriveToCoordLongrange(activeDriver, activeBus, activeDepot.zones.recieving.x, activeDepot.zones.recieving.y, activeDepot.zones.recieving.z, 7.5, drivingStyle, 5.0)
                        SetPedKeepTask(activeDriver, true)
                    end
                end
                if distancetostop <= 30.0 then
                    if distancetostop >= 29.0 then 
                        TaskVehicleDriveToCoordLongrange(activeDriver, activeBus, activeDepot.zones.recieving.x, activeDepot.zones.recieving.y, activeDepot.zones.recieving.z, 5.0, drivingStyle, 5.0)
                        SetPedKeepTask(activeDriver, true)
                    end
                end
                if distancetostop <= 15.0 then
                    TaskVehicleTempAction(activeDriver, activeBus, 6, 2000)
                    SetVehicleHandbrake(activeBus, true)
                    SetVehicleEngineOn(activeBus, false, true, false)                    
                    local playerPed = PlayerPedId()    
                    ClearPedTasks(playerPed)
                    local netid = NetworkGetNetworkIdFromEntity(activeBus)
                    TriggerServerEvent('bdm:getoutofbus', {activeBus,netid})
                    Citizen.Wait(15000)
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
            SetRelationshipBetweenGroups(0, GetHashKey("PLAYER"), pedGroup) -- doesnt this need to be done every tick??
            SetRelationshipBetweenGroups(0, pedGroup, GetHashKey("PLAYER"))
            isReady = true
			break
		end
	end
end)
----------------------------------------------------
RegisterCommand('getInfoForWaypoint', function(source, args)     
    local playerPed = PlayerPedId()  
    local pCoords = GetEntityCoords(playerPed) 
    local pheading = GetEntityHeading(playerPed)
    local zoneid = GetZoneAtCoords(pCoords[1],pCoords[2],pCoords[3])
    local zonename = GetNameOfZone(pCoords[1],pCoords[2],pCoords[3])
    local didWork, groundZ  = GetGroundZFor_3dCoord(pCoords[1],pCoords[2],pCoords[3],0)
    print('x:'..pCoords[1]..' y:'..pCoords[2]..' z:'..pCoords[3])
    print('heading:'..pheading..' groundLevel:'..groundZ..'') 
    print('zonename:'..zonename..' zoneid:'..zoneid..'') 
end,false)