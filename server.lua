local depotLock = {}
-- local dbfile = LoadResourceFile(GetCurrentResourceName(), "BDDB.json")
-- BDDB = json.decode(dbfile)
-- if BDDB == nil then
    BDDB = {}
    BDDB.Depot = {
        {
            uid = 'Legion1',
            name = "Legion Square",
            aZone = 997,
            zones = {
                menu = {x = 256.040, y = -866.1, z = 28.357},
                passenger = {x = 242.461, y = -862.791, z = 28.683},
                departure = {x = 238.818, y = -859.174, z = 30.478, h = 249.654},
                recieving = {x = 238.818, y = -859.174, z = 30.478, h = 249.654}
            },
            blip = {sprite = 58, color = 3, scale = 1.0}
        },
        {
            uid = 'city1',
            name = "Town Hall",
            aZone = 17,
            zones = {
                menu = {x = -560.992, y = -174.790, z = 37.11},
                passenger = {x = -563.057, y = -165.685, z = 37.096},
                departure = {x = -568.056, y = -165.575, z = 38.040, h = 289.892},
                recieving = {x = -569.6, y = -158.8, z = 38.1, h = 289.892}
            },
            blip = {sprite = 58, color = 3, scale = 1.0}
        },
        {
            uid = 'pillhub1',
            name = "Pillbox Dashound",
            aZone = 138,
            zones = {
                menu = {x = 457.4, y = -596.9, z = 27.499},
                passenger = {x = 469.526, y = -611.367, z = 27.499},
                departure = {x = 471.7, y = -606.8, z = 28.495, h = 174.100},
                recieving = {x = 442.503, y = -584.429, z = 28.495, h = 259.700}
            },
            blip = {sprite = 58, color = 3, scale = 1.0}
        },
        {
            uid = 'strawb1',
            name = "Strawberry Metro",
            aZone = 74,
            zones = {
                menu = {x = 260.424, y = -1202.279, z = 28.288},
                passenger = {x = 265.424, y = -1185.714, z = 28.537},
                departure = {x = 270.053, y = -1187.702, z = 29.443, h = 86.426},
                recieving = {x = 276.4, y = -1217.4, z = 29.443, h = 268.426}
            },
            blip = {sprite = 58, color = 3, scale = 1.0}
        },
        {
            uid = 'casino1',
            name = "Casino",
            aZone = 160,
            zones = {
                menu = {x = 935.0, y = 147.7, z = 79.830},
                passenger = {x = 950.307, y = 148.141, z = 79.830},
                departure = {x = 946.2, y = 150.9, z = 80.81, h = 256.099},
                recieving = {x = 960.6, y = 141.1, z = 81.01, h = 334.07}
            },
            blip = {sprite = 58, color = 3, scale = 1.0}
        },
        {
            uid = 'sandy1',
            name = "Sandy Shores",
            aZone = 233,
            zones = {
                menu = {x = 1976.2, y = 3718.2, z = 31.019},
                passenger = {x = 1967.282, y = 3712.100, z = 31.178},
                departure = {x = 1965.3, y = 3707.5, z = 32.2, h = 356.442},
                recieving = {x = 1968.5, y = 3728.5, z = 32.4, h = 334.07}
            },
            blip = {sprite = 58, color = 3, scale = 1.0}
        },   
        {
            uid = 'paleto1',
            name = "Paleto Bay",
            aZone = 213,
            zones = {
                menu = {x = -276.32, y = 6072.8, z = 30.434},
                passenger = {x = -282.840, y = 6049.770, z = 30.050},
                departure = {x = -280.5, y = 6045.5, z = 31.5, h = 49.08},
                recieving = {x = -273.6, y = 6039.8, z = 31.6, h = 334.07}
            },
            blip = {sprite = 58, color = 3, scale = 1.0}
        }, 
        {
            uid = 'greatoceanhwy1',
            name = "Barbareno Pier",
            aZone = 661,
            zones = {
                menu = {x = -3241.2, y = 981.7, z = 11.701},
                passenger = {x = -3241.013, y = 991.709, z = 11.447},
                departure = {x = -3245.9, y = 992.6, z = 12.6, h = 280.169},
                recieving = {x = -3230.5, y = 985.3, z = 12.7, h = 334.07}
            },
            blip = {sprite = 58, color = 3, scale = 1.0},
        },
        {
            uid = 'pier1',
            name = "Del Perro Beach",
            aZone = 680,
            zones = {
                menu = {x = -1605.8, y = -943.4, z = 12.324},
                passenger = {x = -1610.333, y = -968.929, z = 12.017},
                departure = {x = -1614.7, y = -971.3, z = 14.41, h = 318.830},
                recieving = {x = -1598.8, y = -942.1, z = 13.01, h = 332.07}
            },
            blip = {sprite = 58, color = 3, scale = 1.0}
        }, 
        {
            uid = 'harmony1',
            name = "Harmony (route 68)",
            aZone = 256,
            zones = {
                menu = {x = 652.1, y = 2736.4, z = 40.882},
                passenger = {x = 658.259, y = 2732.425, z = 40.923},
                departure = {x = 660.3, y = 2736.9, z = 42.01, h = 175.11},
                recieving = {x = 660.4, y = 2746.4, z = 42.01, h = 332.07}
            },
            blip = {sprite = 58, color = 3, scale = 1.0}
        },
        {
            uid = 'airport1',
            name = "Airport",
            aZone = 495,
            zones = {
                menu = {x = -942.011, y = -2565.722, z = 12.960},
                passenger = {x = -933.263, y = -2560.046, z = 12.959},
                departure = {x = -930.061, y = -2556.211, z = 14.55, h = 159.9},
                recieving = {x = -938.7, y = -2547.2, z = 14.55, h = 332.07}
            },
            blip = {sprite = 58, color = 3, scale = 1.0}
        }, 
        {
            uid = 'observ1',
            name = "Observatory",
            aZone = 184,
            zones = {
                menu = {x = -425.597, y = 1200.817, z = 324.758},
                passenger = {x = -409.733, y = 1204.272, z = 324.641},
                departure = {x = -406.9, y = 1208.4, z = 325.63, h = 165.248},
                recieving = {x = -407.477, y = 1234.554, z = 325.63, h = 332.07}
            },
            blip = {sprite = 58, color = 3, scale = 1.0}
        }, 
        {
            uid = 'dock1',
            name = "Industrial Dock",
            aZone = 164,
            zones = {
                menu = {x = 771.983, y = -2991.597, z = 5.020},
                passenger = {x = 766.092, y = -2996.319, z = 4.863},
                departure = {x = 769.257, y = -3000.363, z = 5.95, h = 60.108},
                recieving = {x = 760.9, y = -2948.5, z = 5.85, h = 332.07}
            },
            blip = {sprite = 58, color = 3, scale = 1.0}
        }, 
        {
            uid = 'Event1',
            name = "Player Event Location",
            aZone = 486,
            zones = {
                menu = {x = 1988.687, y = 2680.971, z = 45.111},
                passenger = {x = 2015.521, y = 2659.573, z = 46.861},
                departure = {x = 2010.668, y = 2657.876, z = 47.680, h = 310.133},
                recieving = {x = 2009.414, y = 2676.459, z = 47.63, h = 127.206}
            },
            blip = {sprite = 58, color = 3, scale = 1.0}
        }
    }
    BDDB.Driver = {}
    BDDB.Garage = {
        {   
            uid = 'depotwork1',
            name = "Depot Workshop",
            aZone = 58,
            blip = {sprite = 289, color = 3, scale = 0.8},
            menu = {x = 456.742, y = -556.037, z = 28.50},
            fuel  = {x = 455.333, y = -565.233, z = 28.50},
            repair = {x = 455.333, y = -565.233, z = 28.50},
            routes = false
        }
    }
--     local encodedData = json.encode(BDDB)
--     local saved = SaveResourceFile(GetCurrentResourceName(), "BDDB.json", encodedData, -1)
-- end
--
RegisterServerEvent('bdm:updatedepot')
AddEventHandler('bdm:updatedepot', function(depot)
    local updated = depot
    -- do things
    TriggerClientEvent('bdm:updatedepot', -1, BDDB.Depot)
end)
RegisterServerEvent('bdm:updatedriver')
AddEventHandler('bdm:updatedriver', function(driver)
    local updated = driver
    -- do things
    TriggerClientEvent('bdm:updatedriver', -1, BDDB.Driver)
end)
RegisterServerEvent('bdm:makepass')
AddEventHandler('bdm:makepass', function(bId)
    TriggerClientEvent('bdm:makeclientpass', -1, bId)
    print('['.. source ..'] spawned BusId:'.. bId[1] ..' NetId:'.. bId[2] ..'')
end)
RegisterServerEvent('bdm:delpass')
AddEventHandler('bdm:delpass', function(bId)
    TriggerClientEvent('bdm:delclientpass', -1, bId)
end)
RegisterServerEvent('bdm:getoutofbus')
AddEventHandler('bdm:getoutofbus', function(bId)
    TriggerClientEvent('bdm:oob', -1, bId)
end)
RegisterServerEvent('bdm:getlists')
AddEventHandler('bdm:getlists', function()
    TriggerClientEvent('bdm:updatedepot', source, BDDB.Depot)
    TriggerClientEvent('bdm:updatedriver', source, BDDB.Driver)
end)
RegisterServerEvent('bdm:passentered')
AddEventHandler('bdm:passentered', function(bId)
    print('['.. source ..'] entered BusId:'.. bId[1] ..'')
end)
RegisterServerEvent('bdm:requestRoute')
AddEventHandler('bdm:requestRoute', function(zone)
    local inZone = zone["in"]
    local outZone = zone["out"]
    if depotLock[inZone.uid] ~= nil then
        if GetGameTimer() >= depotLock[inZone.uid] then
            print('Route: '..outZone.name..' Requested by '..GetPlayerName(source)..' from Zone: '..inZone.name)
            TriggerClientEvent('bdm:beginroute', source, {inZone, outZone})
        else            
            print('Route: '..outZone.name..' Request FAILED '..GetPlayerName(source)..' from Zone: '..inZone.name)
            TriggerClientEvent('bdm:errormsg', source, 'Transfer Used Too Recently! Please Wait!')
        end
    else
        depotLock[inZone.uid] = GetGameTimer() + 120000
        print('Route: '..outZone.name..' Requested by '..GetPlayerName(source)..' from Zone: '..inZone.name)
        TriggerClientEvent('bdm:beginroute', source, {inZone, outZone})
    end
end)