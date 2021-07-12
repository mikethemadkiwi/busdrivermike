local depotLock = {}
local dbfile = LoadResourceFile(GetCurrentResourceName(), "BDDB.json")
BDDB = json.decode(dbfile)
if BDDB == nil then
    BDDB = {}
    BDDB.Depot = {
        {
            uid = 'city1',
            name = "Town Hall Transfer",
            aZone = 17,
            zones = {
                menu = {x = -560.992, y = -174.790, z = 38.104},
                passenger = {},
                departure = {x = -568.056, y = -165.575, z = 38.040, h = 289.892},
                recieving = {x = -569.6, y = -158.8, z = 38.1, h = 289.892}
            },
            blip = {sprite = 58, color = 3, scale = 1.0}
        },
        {
            uid = 'pillhub1',
            name = "Pillbox Dashound Transfer",
            aZone = 138,
            zones = {
                menu = {x = 437.590, y = -624.364, z = 28.708},
                passenger = {},
                departure = {x = 471.7, y = -606.8, z = 28.495, h = 174.100},
                recieving = {x = 442.503, y = -584.429, z = 28.495, h = 259.700}
            },
            blip = {sprite = 58, color = 3, scale = 1.0}
        },
        {
            uid = 'strawb1',
            name = "Strawberry Metro Transfer",
            aZone = 74,
            zones = {
                menu = {x = 260.424, y = -1202.279, z = 29.289},
                passenger = {},
                departure = {x = 270.053, y = -1187.702, z = 29.443, h = 86.426},
                recieving = {x = 276.4, y = -1217.4, z = 29.443, h = 268.426}
            },
            blip = {sprite = 58, color = 3, scale = 1.0}
        },
        {
            uid = 'casino1',
            name = "Casino Transfer",
            aZone = 160,
            zones = {
                menu = {x = 935.0, y = 147.7, z = 80.8},
                passenger = {},
                departure = {x = 946.2, y = 150.9, z = 80.81, h = 256.099},
                recieving = {x = 960.6, y = 141.1, z = 81.01, h = 334.07}
            },
            blip = {sprite = 58, color = 3, scale = 1.0}
        },
        {
            uid = 'sandy1',
            name = "Sandy Shores Transfer",
            aZone = 233,
            zones = {
                menu = {x = 1976.2, y = 3718.2, z = 32.0},
                passenger = {},
                departure = {x = 1965.3, y = 3707.5, z = 32.2, h = 356.442},
                recieving = {x = 1968.5, y = 3728.5, z = 32.4, h = 334.07}
            },
            blip = {sprite = 58, color = 3, scale = 1.0}
        },   
        {
            uid = 'paleto1',
            name = "Paleto Bay Transfer",
            aZone = 213,
            zones = {
                menu = {x = -276.32, y = 6072.8, z = 31.4},
                passenger = {},
                departure = {x = -280.5, y = 6045.5, z = 31.5, h = 49.08},
                recieving = {x = -273.6, y = 6039.8, z = 31.6, h = 334.07}
            },
            blip = {sprite = 58, color = 3, scale = 1.0}
        }, 
        {
            uid = 'greatoceanhwy1',
            name = "Barbareno Pier Transfer",
            aZone = 661,
            zones = {
                menu = {x = -3241.2, y = 981.7, z = 12.7},
                passenger = {},
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
                menu = {x = -1605.8, y = -943.4, z = 13.31},
                passenger = {},
                departure = {x = -1614.7, y = -971.3, z = 14.41, h = 318.830},
                recieving = {x = -1598.8, y = -942.1, z = 13.01, h = 332.07}
            },
            blip = {sprite = 58, color = 3, scale = 1.0}
        }, 
        {
            uid = 'harmony1',
            name = "Harmony (route 68) Transfer",
            aZone = 256,
            zones = {
                menu = {x = 652.1, y = 2736.4, z = 41.993},
                passenger = {},
                departure = {x = 660.3, y = 2736.9, z = 42.01, h = 175.11},
                recieving = {x = 660.4, y = 2746.4, z = 42.01, h = 332.07}
            },
            blip = {sprite = 58, color = 3, scale = 1.0}
        }, 
        {
            uid = 'arena1',
            name = "Maze Bank Arena Transfer",
            aZone = 69,
            zones = {
                menu = {x = -130.4, y = -1993.4, z = 22.8},
                passenger = {},
                departure = {x = -140.1, y = -1982.7, z = 22.81, h = 91.851},
                recieving = {x = -152.7, y = -1981.9, z = 22.91, h = 332.07}
            },
            blip = {sprite = 58, color = 3, scale = 1.0}
        }, 
        {
            uid = 'airport1',
            name = "Airport Transfer",
            aZone = 495,
            zones = {
                menu = {x = -1022.7, y = -2693.0, z = 14.01},
                passenger = {},
                departure = {x = -1025.1, y = -2682.8, z = 13.83, h = 147.1},
                recieving = {x = -1025.1, y = -2682.8, z = 13.83, h = 332.07}
            },
            blip = {sprite = 58, color = 3, scale = 1.0}
        }, 
        {
            uid = 'observ1',
            name = "Observatory Transfer",
            aZone = 184,
            zones = {
                menu = {x = -413.6, y = 1169.1, z = 323.81},
                passenger = {},
                departure = {x = -406.9, y = 1208.4, z = 325.63, h = 165.248},
                recieving = {x = -390.1, y = 1214.1, z = 325.63, h = 332.07}
            },
            blip = {sprite = 58, color = 3, scale = 1.0}
        }, 
        {
            uid = 'dock1',
            name = "Industrial Dock Transfer",
            aZone = 164,
            zones = {
                menu = {x = 784.3, y = -2947.8, z = 5.9},
                passenger = {},
                departure = {x = 760.9, y = -2948.5, z = 5.83, h = 181.11},
                recieving = {x = 760.9, y = -2948.5, z = 5.85, h = 332.07}
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
    local encodedData = json.encode(BDDB)
    local saved = SaveResourceFile(GetCurrentResourceName(), "BDDB.json", encodedData, -1)
end
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
RegisterServerEvent('bdm:getlists')
AddEventHandler('bdm:getlists', function()
    TriggerClientEvent('bdm:updatedepot', source, BDDB.Depot)
    TriggerClientEvent('bdm:updatedriver', source, BDDB.Driver)
end)
RegisterServerEvent('bdm:requestRoute')
AddEventHandler('bdm:requestRoute', function(zone)
    -- local now = date
    local inZone = zone["in"]
    local outZone = zone["out"]
    print('Route: '..outZone.name..' Requested by '..GetPlayerName(source)..' from Zone: '..inZone.name)
    TriggerClientEvent('bdm:beginroute', source, {inZone, outZone})
end)