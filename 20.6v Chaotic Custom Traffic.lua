--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||     v 20   WHOWARE CUSTOM TRAFFIC & POWERS   v 20      ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||     v 20   WHOWARE CUSTOM TRAFFIC & POWERS   v 20      ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--

Traffic = 10
util.require_natives(1663599433)
util.require_natives(1660775568)

local required <const> = {
	"lib/natives-1663599433.lua",
	"lib/whowarelib/CustomTraffic.lua",
	"lib/customtrafficlib/json.lua",
	"lib/customtrafficlib/json/constant.lua",
	"lib/customtrafficlib/json/parser.lua",
	"lib/customtrafficlib/json/serializer.lua",
}
local Functions = require "whowarelib.CustomTraffic"

--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||        BEGINNING OF CUSTOM TRAFFIC             ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||        BEGINNING OF CUSTOM TRAFFIC             ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--

        local playersReference
        menu.action(menu.my_root(), translate("Player", "Take me to Custom Traffic"), {}, "Select either YOURSELF or ANOTHER PLAYER from the > Players list!", function()
            playersReference = playersReference or menu.ref_by_path("Players")
            menu.trigger_command(playersReference, "")
        end)
	---@param pId Player
ServerSide = function(pId)
    menu.divider(menu.player_root(pId), "WhoWare")

    if not menu_already_added then 
        local helpText = translate("Whoware", "Join the discord for updates / info / help / suggestions.")
        local menuName = translate("Whoware", "Join %s")
        menu.hyperlink(menu.my_root(), menuName:format("Whoware Discord"), "https://discord.gg/S3GtdAq", helpText:format("komt"))
        

        menu_already_added = true
    end
	
	local function createMenuToggle(menuObj, optionName, default, toggleCallback)
		return menu.toggle(menuObj, translate(optionName, optionName), {}, default, toggleCallback)
	end
	
	local function createMenuSlider(menuObj, optionName, description, min, max, default, step, sliderCallback)
		return menu.slider(menuObj, translate(optionName, optionName), {}, description, min, max, default, step, sliderCallback)
	end

	local function calculate_distance(x1, y1, z1, x2, y2, z2)
		local dx = x1 - x2
		local dy = y1 - y2
		local dz = z1 - z2
		return math.sqrt(dx * dx + dy * dy + dz * dz)
	end
	
	
	local function calculate_future_position(pos, velocity, time)
		return {
			x = pos.x + velocity.x * time,
			y = pos.y + velocity.y * time,
			z = pos.z + velocity.z * time
		}
	end
	
	local function vector_magnitude(x, y, z)
		return math.sqrt(x * x + y * y + z * z)
	end

	local function current_ms()
		return os.time() * 1000
	end

--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||            ON SCREEN TEXT VARIABLES            ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||            ON SCREEN TEXT VARIABLES            ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--

	local tvGlobalTextVariables = {
		tvxy = {
			tvTextColor = {r = 1.0, g = 0.1, b = 0.0, a = 0.50},
			tvx = 0.44,
			tvy = 1.070
		}
	}
	local tvCountTextUI = {
		TVDR_TXT_SCALE = {
			TVtextScale = 0.4
		}
	}
	local GlobalTextVariables = {
		Preset = {
			TextColor = {r = 0.3, g = 0.5, b = 1, a = 0.60}, 
			x = 0.549,
			y = 0.78
		},
		maxCountxy = {
			TextColor = {r = 50, g = 0, b = 0, a = 0.99},
			x = 0.55,
			y = 0.82
		},
		destroyedVehiclexy = {
			TextColor = {r = 0.3, g = 0.5, b = 1, a = 0.40},  
			x = 0.50,
			y = 0.84
		},
		newDriverxy = {
			TextColor = {r = 0.5, g = 1, b = 0.5, a = 0.99},
			x = 0.59, 
			y = 0.80
		},
		removedDriverxy = {
			TextColor = {r = 1, g = 0, b = 0, a = 0.99},
			x = 0.51, 
			y = 0.80
		},
		finishedVehicleCleanupxy = {
			TextColor = {r = 1, g = 1, b = 1, a = 0.80}, 
			x = 0.70, 
			y = 0.88  
		},
		bruteForceActivatedxy = {
			TextColor = {r = 1, g = 0, b = 0, a = 0.80}, 
			x = 0.50, 
			y = 0.86  
		},
		npcJumpActivatedxy = {
			TextColor = {r = 0, g = 0.8, b = 0.2, a = 0.85},
			x = 0.50, 
			y = 0.88  
		},
		playerProximityHomingActivatedxy = {
			TextColor = {r = 0, g = 0.8, b = 0.2, a = 0.85}, 
			x = 0.50, 
			y = 0.90  
		},
		proximityHomingActivatedxy = {
			TextColor = {r = 1, g = 0, b = 0, a = 0.85},
			x = 0.50, 
			y = 0.92  
		},
		explodeOnCollisionActivatedxy = {
			TextColor = {r = 1, g = 0, b = 0, a = 0.85}, 
			x = 0.50, 
			y = 0.94 
		},
		playerbruteForceActivatedxy = {
			TextColor = {r = 0, g = 0.8, b = 0.2, a = 0.85}, 
			x = 0.50, 
			y = 0.96 
		},
		DemonicNPCsActivated = {
			TextColor = {r = 0.8, g = 0.6, b = 1, a = 0.55},
			x = 0.495,
			y = 0.78
		},
		BumperCarsActivated = {
			TextColor = {r = 0.8, g = 0.2, b = 0.4, a = 0.55},
			x = 0.495,
			y = 0.77
		},
		RabidHomingNPCsActivated = {
			TextColor = {r = 0.3, g = 0.6, b = 0.5, a = 0.55},
			x = 0.495,
			y = 0.76
		},
		SpeedyNPCsActivated = {
			TextColor = {r = 0.8, g = 0.3, b = 0.6, a = 0.55},
			x = 0.495,
			y = 0.75
		},
		FastNPCsActivated = {
			TextColor = {r = 0.2, g = 0.6, b = 0.2, a = 0.55},
			x = 0.495,
			y = 0.74
		},
		ExplosiveNPCsActivated = {
			TextColor = {r = 0.8, g = 0.1, b = 0.7, a = 0.55},
			x = 0.495,
			y = 0.73
		},
		SpikeExplosiveNPCsActivated = {
			TextColor = {r = 0.4, g = 0.4, b = 0.75, a = 0.55},
			x = 0.495,
			y = 0.72
		},
		RandomExplosiveNPCsActivated = {
			TextColor = {r = 0.2, g = 0.9, b = 0.6, a = 0.55},
			x = 0.495,
			y = 0.71
		}
	}

	local PresetUI = {
		PRESET_SCALE = {
			textScale = 0.4
		},
		DEMONIC_SCALE = {
			textScale = 0.45
		}
	}

	local CountTextUI = {
		DR_TXT_SCALE = {
			textScale = 0.6
		}
	}

--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||   CUSTOM TRAFFIC PHYSICAL PROPERTIES AND PRESETS   ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||   CUSTOM TRAFFIC PHYSICAL PROPERTIES AND PRESETS   ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--


	local settings = {
		playerGravityControl = {
			isOn = false,
			gravity_multiplier = 1,
		},
		RabidHomingNPCsOn = {
			isOn = false
		},
		SpeedyNPCsOn = {
			isOn = false
		},
		FastNPCsOn = {
			isOn = false
		},
		BumperCarsOn = {
			isOn = false
		},
		DemonicNPCsOn = {
			isOn = false
		},
		ExplosiveNPCsOn = {
			isOn = false
		},
		SpikeExplosiveNPCsOn = {
			isOn = false
		},
		RandomExplosiveNPCsOn = {
			isOn = false
		},
		AnnoyingExplosiveNPCsOn = {
			isOn = false
		},
		CarPunchingNPCsOn = {
			isOn = false
		}
	}

	
	local ChaoticOpt <const> = menu.list(menu.player_root(pId), translate("Player", "Ultimate Custom Traffic"), {}, "Wait, it's important you understand this - Turning 'Custom Traffic' ON, enables NPCs to chase everyone in the lobby. So even if you stop spectating the person you applied Custom Traffic to, and spectate someone else, Custom Traffic will remain running as long as your target remains in the lobby! Super Power settings will also still work on Chaotic Vehicles, so long Custom Traffic is ENABLED and the player you put it on is PRESENT.")


--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||                 Chaotic Vehicles               ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||                 Chaotic Vehicles               ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--

local function create_Chaotic_vehicle(targetId, vehicleHash, pedHash)
	if isDebugOn then
		util.toast("create_Chaotic_vehicle activated.")
	end
	-- Vehicle creation and setting
	request_model(vehicleHash)
	request_model(pedHash)
	local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(targetId)
	local pos = ENTITY.GET_ENTITY_COORDS(targetPed, false)
	local driver = 0
	local vehicle = entities.create_vehicle(vehicleHash, pos, 0.0)

	-- Network settings
	local networkVehicleId = NETWORK.VEH_TO_NET(vehicle)
	NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(networkVehicleId, true)

	for i = 0, 50 do
		local numMods = VEHICLE.GET_NUM_VEHICLE_MODS(vehicle, i)
		VEHICLE.SET_VEHICLE_MOD(vehicle, i, numMods - 1, false)
	end

	-- Driver settings
	local offset = get_random_offset_from_entity(vehicle, 150.0, 100.0)
	local outCoords = v3.new()
	if PATHFIND.GET_CLOSEST_VEHICLE_NODE(offset.x, offset.y, offset.z, outCoords, 1, 3.0, 0.0) then
		driver = entities.create_ped(5, pedHash, pos, 0.0)

		local networkPedId = NETWORK.PED_TO_NET(driver)
		NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(networkPedId, true)

		-- More driver settings
		PED.SET_PED_INTO_VEHICLE(driver, vehicle, -1)
		ENTITY.SET_ENTITY_COORDS(vehicle, outCoords.x, outCoords.y, outCoords.z, false, false, false, true)
		set_entity_face_entity(vehicle, targetPed, false)
		VEHICLE.SET_VEHICLE_ENGINE_ON(vehicle, true, true, true)
		VEHICLE.SET_VEHICLE_IS_CONSIDERED_BY_PLAYER(vehicle, false)
		PED.SET_PED_COMBAT_ATTRIBUTES(driver, 1, true)
		PED.SET_PED_COMBAT_ATTRIBUTES(driver, 3, false)
		PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(driver, true)
		TASK.TASK_VEHICLE_MISSION_PED_TARGET(driver, vehicle, targetPed, 6, 500.0, 786988, 0.0, 0.0, true)
		PED.SET_PED_CAN_BE_KNOCKED_OFF_VEHICLE(driver, 1)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(pedHash)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(vehicleHash)
	end
	
	return vehicle, driver
end
	
local ChaoticVehicles <const> = menu.list(menu.player_root(pId), translate("Ultimate Custom Traffic", "Chaotic Vehicles"), {}, "This will spawn your choice of Peds and Vehicles to target players! Please note - you need to be spectating the player you want Chaotic Vehicles to target. (Spawned Chaotic Vehicles are operating separate from Custom Traffic! Additionally, Trollies are considered 'controlled / reaped', therefor when spawned, they automatically aquire user-enabled & configured super powers, whether Custom Traffic is enabled or not)")
		
local options <const> = {
	--ground vehicles
	"technical2", "bmx", "panto", "Dump", "slamvan6", "blazer5", "faction3", "Monster4", "stingertt", "buffalo5", "coureur", "Blazer", "rcbandito", "Barrage", 
	"Chernobog", "Ripley", "Zhaba", "Sandking", "Cerberus", "Wastelander", "Chimera", "Veto", 
	
	--ground vehicles
	"Pounder", "Biff", "Vetir", "Mule", 
	"jet", "luxor", "luxor2", "vestra", 
	"rogue", "stunt", "mammatus", "avenger2", 
	"Cutter", "Phantom2", "Go-Kart", "AMBULANCE", 
	"Barracks", "rubble", "dominator", "emperor", 
	"emperor2", "emperor3", "entityxf", "exemplar", 
	"elegy2", "f620", "fbi", "fbi2", "felon", 
	"felon2", "feltzer2", "firetruk", "fq2", 
	"fusilade", "fugitive", "futo", "granger", 
	"gauntlet", "habanero", "hauler", "handler", 
	"infernus", "ingot", "intruder", "issi2", 
	"Jackal", "journey", "jb700", "khamelion", 
	"landstalker", "lguard", "manana", "mesa", 
	"mesa2", "mesa3", "crusader", "minivan", 
	"mixer", "mixer2", "monroe", "mule2", 
	"oracle", "oracle2", "packer", "patriot", 
	"pbus", "penumbra", "peyote", "phantom", 
	"phoenix", "picador", "police", "police4", 
	"police2", "police3", "policeold1", "policeold2", 
	"pony", "pony2", "prairie", "pranger", 
	"premier", "primo", "proptrailer", "rancherxl", 
	"rancherxl2", "rapidgt", "rapidgt2", "radi", 
	"ratloader", "rebel", "regina", "rebel2", 
	"rentalbus", "ruiner", "rumpo", "rumpo2", 
	"rhino", "riot", "ripley", "rocoto", 
	"romero", "sabregt", "sadler", "sadler2", 
	"sandking", "sandking2", "schafter2", "schwarzer", 
	"scrap", "seminole", "sentinel", "sentinel2", 
	"zion", "zion2", "serrano", "sheriff", 
	"sheriff2", "speedo", "speedo2", "stanier", 
	"stinger", "stingergt", "stockade", "stockade3", 
	"stratum", "sultan", "superd", "surano", 
	"surfer", "surfer2", "surge", "taco", 
	"tailgater", "taxi", "trash", "tractor", 
	"tractor2", "tractor3", "technical3", "insurgent3", 
	"apc", "tampa3", "dune3", "trailersmall2", 
	"halftrack", "ardent", "vigilante", "rapidgt3", 
	"retinue", "cyclone", "visione", "z190", 
	"viseris", "comet5", "raiden", "riata", 
	"sc1", "autarch", "savestra", "gt500", 
	"comet4", "neon", "sentinel3", "khanjali", 
	"volatol", "deluxo", "stromberg", "riot2", 
	"thruster", "yosemite", "hermes", "hustler", 
	"streiter", "revolter", "pariah", "kamacho", 
	"cheburek", "jester3", "caracara", "hotring", 
	"flashgt", "ellie", "michelli", "fagaloa", 
	"dominator3", "tyrant", "tezeract", "gb200", 
	"issi3", "taipan", "mule4", "pounder2", 
	"speedo4", "pbus2", "patriot2", "swinger", 
	"terbyte", "menacer", "scramjet", "freecrawler", 
	"stafford", "bruiser", "bruiser2", "bruiser3", 
	"brutus", "brutus2", "brutus3", "cerberus2", 
	"cerberus3", "clique", "deathbike", "deathbike2", 
	"deathbike3", "deveste", "deviant", "dominator4", 
	"dominator5", "dominator6", "impaler", "impaler2", 
	"impaler3", "impaler4", "imperator", "imperator2", 
	"imperator3", "issi4", "issi5", "issi6", 
	"italigto", "monster3", "monster5", "Benson", 
	"Forklift", "Docktug", "Mower"
}

local pedAnimals <const> = {
	"a_c_cormorant", "a_c_husky", "a_c_deer", "a_c_pig", "a_c_shepherd", "a_c_westy", "a_c_poodle", "a_c_pug", 
	"a_c_rabbit_01", "a_c_rabbit_02", "a_c_rat", "a_c_retriever", "a_c_rhesus", "a_c_rottweiler", "a_c_mtlion", "a_c_hen", "a_c_deer", "a_c_crow", 
	"a_c_coyote", "a_c_cow", "a_c_chop", "a_c_chimp", "a_c_chickenhawk", "a_c_cat_01", "a_c_boar", "a_c_boar_02"
}

local pedModels <const> = {
	"u_m_y_babyd", "u_m_y_dancerave_01", "u_m_y_staggrm_01",
	"a_m_m_acult_01", "a_m_m_afriamer_01", "a_m_m_beach_01",
	"a_m_m_beach_02", "a_m_m_bevhills_01", "a_m_m_bevhills_02",
	"a_m_m_business_01", "a_m_m_eastsa_01", "a_m_m_eastsa_02",
	"a_m_m_farmer_01", "a_m_m_fatlatin_01", "a_m_m_genfat_01",
	"a_m_m_genfat_02", "a_m_m_golfer_01", "a_m_m_hasjew_01",
	"a_m_m_hillbilly_01", "a_m_m_hillbilly_02", "a_m_m_indian_01",
	"a_m_m_ktown_01", "a_m_m_malibu_01", "a_m_m_mexcntry_01",
	"a_m_m_mexlabor_01", "a_m_m_og_boss_01", "a_m_m_paparazzi_01",
	"a_m_m_polynesian_01", "a_m_m_prolhost_01", "a_m_m_rurmeth_01",
	"a_m_m_salton_01", "a_m_m_salton_02", "a_m_m_salton_03",
	"a_m_m_salton_04", "a_m_m_skater_01", "a_m_m_skidrow_01",
}

local currentPedList = pedAnimals  -- default to animals
local spawnDelay = 5000
local setInvincible = false
local spawnCount = 1
local count = 0
local AttackType <const> = {
	explode = 0,
	dropMine = 1
}
local attacktype = 0
local ChaoticVehiclesTable = {}
local ChaoticVehicleTypesCount = {}
local displayChaoticVehiclesCountToggleState = false
local function remove_Chaotic_vehicle(vehicle)
	if isDebugOn then
		util.toast("remove_Chaotic_vehicle activated.")
	end
	local vehicleType = ChaoticVehiclesTable[vehicle].type
	ChaoticVehiclesTable[vehicle] = nil
	if ChaoticVehicleTypesCount[vehicleType] then
		ChaoticVehicleTypesCount[vehicleType] = ChaoticVehicleTypesCount[vehicleType] - 1
		if ChaoticVehicleTypesCount[vehicleType] == 0 then
			ChaoticVehicleTypesCount[vehicleType] = nil
		end
	end
	updateNpcDriversCount()
end

local function updateChaoticVehicleTypesCount()
	if isDebugOn then
		util.toast("updateChaoticVehicleTypesCount activated.")
	end
	updateNpcDriversCount()
	count = 0
	for vehicle, data in pairs(ChaoticVehiclesTable) do
		if ENTITY.IS_ENTITY_DEAD(data.driver) then
			remove_Chaotic_vehicle(vehicle)
		else
			count = count + 1
		end
	end
end

local function spawn_Chaotic_vehicle(option, pId, pedHash)
	if isDebugOn then
		util.toast("spawn_Chaotic_vehicle activated.")
	end
	local randomPedIndex = math.random(#currentPedList)
	local pedHash <const> = util.joaat(currentPedList[randomPedIndex])			
	local vehicleHash <const> = util.joaat(option)
	local vehicle, driver = create_Chaotic_vehicle(pId, vehicleHash, pedHash)		
	ENTITY.SET_ENTITY_INVINCIBLE(vehicle, setInvincible)
	ENTITY.SET_ENTITY_VISIBLE(driver, true, true)
	ChaoticVehiclesTable[vehicle] = { type = option, driver = driver }
	if ChaoticVehicleTypesCount[option] then
		ChaoticVehicleTypesCount[option] = ChaoticVehicleTypesCount[option] + 1
	else
		ChaoticVehicleTypesCount[option] = 1
	end
	if option == "Thruster" then
		for i = 1, 8 do
			local weaponHash <const> = util.joaat("VEHICLE_WEAPON_SPACE_ROCKET")
			WEAPON.REMOVE_WEAPON_FROM_PED(driver, weaponHash, i)
		end
	end
	add_blip_for_entity(vehicle, 1, 25)
end

menu.toggle_loop(ChaoticVehicles, translate("Trolling", "Persistant Random Chaotic Vehicles"), {}, "Sends a RANDOM Chaotic Vehicle every 5 seconds.", function()
	if isDebugOn then
		util.toast("Persistant Random Chaotic Vehicles activated.")
	end
	if not is_player_active(pId, false, true) then
		return util.stop_thread()
	end
	local randomVehicleIndex = math.random(#options)
	local randomVehicle = options[randomVehicleIndex]
	local randomPedIndex = math.random(#currentPedList)
	local pedHash <const> = util.joaat(currentPedList[randomPedIndex])			
	util.toast(string.format('Fetching %s(s) every %d ms...', randomVehicle, spawnDelay))
	spawn_Chaotic_vehicle(randomVehicle, pId, pedHash)
	util.toast(string.format('%s Fetched!', randomVehicle))
	util.yield(spawnDelay)
end)

local spawnDelaySlider = createMenuSlider(ChaoticVehicles, "Spawn Delay • >", "Modify the delay between Chaotic vehicle spawns in milliseconds.", 1000, 60000, 5000, 1000, function(value) 
	if isDebugOn then
		util.toast("spawnDelaySlider activated.")
	end
	spawnDelay = value 
end)

menu.action(ChaoticVehicles, translate("Trolling", "Send Random Chaotic Vehicle"), {}, "This option sends a random vehicle from the Chaotic vehicle options", function()
	if isDebugOn then
		util.toast("spawnDelaySlider activated.")
	end
	local i = 0
	local randomVehicleIndex = math.random(#options)
	local randomVehicle = options[randomVehicleIndex]
	local randomPedIndex = math.random(#currentPedList)
	local pedHash <const> = util.joaat(currentPedList[randomPedIndex])			
	util.toast(string.format('Fetching %d %s(s) every %d ms...', spawnCount, randomVehicle, 520)) -- use spawnCount instead of count
	repeat
		spawn_Chaotic_vehicle(randomVehicle, pId, pedHash)
		i = i + 1
		util.yield(520)
	until i == spawnCount  -- use spawnCount instead of count
	util.toast(string.format('%d %s Fetched!', spawnCount, randomVehicle)) -- use spawnCount instead of count
end)

menu.slider(ChaoticVehicles, translate("Trolling", "Choose Ped Type"), {}, "Choose between Animals(0) or Humans(1). Please note, between these two categories, there is around 30+ different models contained within the tables. This is done to randomize the Model each spawn which increases the maximum allowed entities by bypassing stands object-spam detection. Previously 50 objects was the max, now you can reach 100-150 before the menu begins deletion.", 0, 1, 0, 1, function(val)
	if isDebugOn then
		util.toast("Choose Ped Type activated.")
	end
	if val == 0 then
		currentPedList = pedAnimals
	else
		currentPedList = pedModels
	end
end)

menu.action_slider(ChaoticVehicles, translate("Trolling", "Send Chaotic Vehicle"), {}, "", options, function(index, opt)
	if isDebugOn then
		util.toast("Send Chaotic Vehicle activated.")
	end
	local i = 0
	util.toast(string.format('Fetching %d %s(s) every %d ms...', spawnCount, opt, 520)) -- use spawnCount instead of count
	repeat
		if opt == "Go-Kart" then
			local vehicleHash <const> = util.joaat("veto2")
			local gokart, driver = create_Chaotic_vehicle(pId, vehicleHash, pedHash)
			ENTITY.SET_ENTITY_INVINCIBLE(gokart, setInvincible)
			VEHICLE.SET_VEHICLE_COLOURS(gokart, 89, 0)
			VEHICLE.TOGGLE_VEHICLE_MOD(gokart, 18, true)
			ENTITY.SET_ENTITY_INVINCIBLE(driver, setInvincible)
			PED.SET_PED_COMPONENT_VARIATION(driver, 3, 111, 13, 2)
			PED.SET_PED_COMPONENT_VARIATION(driver, 4, 67, 5, 2)
			PED.SET_PED_COMPONENT_VARIATION(driver, 6, 101, 1, 2)
			PED.SET_PED_COMPONENT_VARIATION(driver, 8, -1, -1, 2)
			PED.SET_PED_COMPONENT_VARIATION(driver, 11, 148, 5, 2)
			PED.SET_PED_PROP_INDEX(driver, 0, 91, 0, true)
			add_blip_for_entity(gokart, 748, 5)
		else
			spawn_Chaotic_vehicle(opt, pId, pedHash)
		end
		i = i + 1
		util.yield(520)
	until i == spawnCount  -- use spawnCount instead of count
	util.toast(string.format('%d %s Fetched!', spawnCount, opt)) -- use spawnCount instead of count
end)

menu.slider(ChaoticVehicles, translate("Trolling - Chaotic Vehicles", "Amount"), {}, "",
1, 99, 1, 1, function(value) spawnCount = value end)  -- update spawnCount instead of count
menu.toggle(ChaoticVehicles, translate("Trolling - Chaotic Vehicles", "Invincible?"), {}, "",
function(toggle) setInvincible = toggle end)
menu.action(ChaoticVehicles, translate("Trolling - Chaotic Vehicles", "Delete Chaotic's"), {}, "Forces all functions except deletion from occuring, then spams the session with 10 delete requests within 3 seconds, after which the script releases your client from the intentional freeze. This is done in order to reduce lobby desync issues overtime due to entity overflowing via improper deletion", function()
	if isDebugOn then
		util.toast("Delete Chaotic activated.")
	end
	local start = os.clock()
	local interval = 3 / 10 -- executes 10 times within 3 seconds, so every 0.3 seconds
	local clearedEntities = 0 -- counter for cleared entities
	for i = 1, 10 do
		for _, vehicle in ipairs(entities.get_all_vehicles_as_handles()) do
			if is_decor_flag_set(vehicle, DecorFlag_isChaoticVehicle) then
				local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
				entities.delete(driver)
				entities.delete(vehicle)
				clearedEntities = clearedEntities + 1
				remove_Chaotic_vehicle(vehicle) -- Call the function to update ChaoticVehicleTypesCount
			elseif VEHICLE.IS_VEHICLE_DRIVEABLE(vehicle, false) == false or ENTITY.IS_ENTITY_DEAD(vehicle) then
				local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1)
				if not PED.IS_PED_A_PLAYER(driver) then
					ENTITY.SET_ENTITY_AS_MISSION_ENTITY(vehicle, false, false)
					entities.delete(vehicle)
					clearedEntities = clearedEntities + 1
				end
			end
		end
		repeat until os.clock() - start >= interval * i
	end
	util.toast(string.format('(Freeze is coded in and intentional, dont worry) World Cleared! %d entities removed. If you commonly need to clear your lobbies due to desync buildup, consider keeping your values lower, especially in higher ping lobbies.', clearedEntities))
end)

		function getOffsetFromEntityGivenDistance(entity, distance)
			if isDebugOn then
				util.toast("getOffsetFromEntityGivenDistance activated.")
			end
			local coords = ENTITY.GET_ENTITY_COORDS(entity)
			local heading = ENTITY.GET_ENTITY_HEADING(entity)
			local radians = math.rad(heading)
			local offsetX = distance * math.sin(radians)
			local offsetY = distance * math.cos(radians)
			
			return v3.new(coords.x - offsetX, coords.y - offsetY, coords.z)
		end	
		function requestModels(vehicleHash, pedHash)
			STREAMING.REQUEST_MODEL(vehicleHash)
			while not STREAMING.HAS_MODEL_LOADED(vehicleHash) do
				util.yield()
			end
		
			STREAMING.REQUEST_MODEL(pedHash)
			while not STREAMING.HAS_MODEL_LOADED(pedHash) do
				util.yield()
			end
		end

local extraTraffic = menu.list(ChaoticVehicles, translate("Ultimate Custom Traffic", "Extra Traffic Options •     >"), {}, "Extra options that ill throw in as later updates come")
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||               CHAOTIC VEHICLES                 ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||                   CTL CORE                     ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--

	local CTLCustoms = menu.list(ChaoticOpt, translate("Trolling", "CTL | Customs"), {}, "Warning - CTL | Custom Traffic needs to be enabled for these to take effect! Modify RAW Custom Traffic Functions in REALTIME, that of which all control the behavior of NPCs and the script while Custom Traffic is enabled.")
	local superPowersMenu = menu.list(CTLCustoms, translate("Ultimate Custom Traffic", "Add SuperPowers • >"), {}, "Warning - Custom Traffic needs to be enabled for these to take effect! Lets step it up a notch.")
	local NPCJumpCore = menu.list(CTLCustoms, translate("Trolling", "NPC Jump behavior • >"), {}, "Warning - Custom Traffic needs to be enabled for these to take effect! Control the core Jump Conditions for NPCs THIS NEEDS TO BE Enabled within > CTL Customs > NPC Jump Ability")
	local CTLCustomsXT = menu.list(CTLCustoms, translate("Trolling", "CTL Customs Extras • >"), {}, "Less important functions are kept in here incase the user ever needs them.")
	--Jumpcore
	local lastJump = newTimer()
	local dynamic_force_multiplier_value = 33
	local constant_multiplier_value = 94
	local player_speed_divisor_value = 33
	local prediction_time_value = 30 
	local max_height_difference_value = 3
	local distanceXY_value = 40
	local distanceZ_value = 3
	local jumpHeight_value = 8
	local jump_cooldown_value = 650
	local jump_cooldown_slider = createMenuSlider(NPCJumpCore, "Jump Cooldown", "Time in milliseconds before NPCs are allowed to jump again.", 0, 10000, jump_cooldown_value, 25, function(value) jump_cooldown_value = value end)	
	local dynamic_force_multiplier_slider = createMenuSlider(NPCJumpCore, "Dynamic Force Multiplier", "Sensitivity of the force applied to NPCs based on player speed.", 0, 1000, dynamic_force_multiplier_value, 1, function(value) dynamic_force_multiplier_value = value end)
	local constant_multiplier_slider = createMenuSlider(NPCJumpCore, "Constant Multiplier", "Constant value added to dynamic force calculation.", 0, 2000, constant_multiplier_value, 1, function(value) constant_multiplier_value = value end)
	local player_speed_divisor_slider = createMenuSlider(NPCJumpCore, "Player Speed Divisor", "Value that the player's speed is divided by in dynamic force calculation.", 0, 1000, player_speed_divisor_value, 1, function(value) player_speed_divisor_value = value end)
	local prediction_time_slider = createMenuSlider(NPCJumpCore, "Prediction Time", "Time used to predict player position in future. (x0.1 second)", 0, 1000, prediction_time_value, 10, function(value) prediction_time_value = value end) -- Set step as 10
	local max_height_difference_slider = createMenuSlider(NPCJumpCore, "Max Height Difference", "Maximum difference in Z axis between NPC and player for jump.", 0, 1000, max_height_difference_value, 1, function(value) max_height_difference_value = value end)
	local distanceXY_slider = createMenuSlider(NPCJumpCore, "Max XY Distance", "Maximum 2D distance between NPC and player for jump.", 0, 2000, distanceXY_value, 1, function(value) distanceXY_value = value end)
	local distanceZ_slider = createMenuSlider(NPCJumpCore, "Min Z Distance", "Minimum Z distance between NPC and player for jump.", 0, 1000, distanceZ_value, 1, function(value) distanceZ_value = value end)
	local jumpHeight_slider = createMenuSlider(NPCJumpCore, "Jump Height", "Force applied to NPC's Z axis when jumping.", 0, 2000, jumpHeight_value, 1, function(value) jumpHeight_value = value end)

	--main ctl functions NEED TO PATCH SUPER POWERS ITERATING THROUGH ALL NPCS AT ONCE INSTEAD OF CURRENTLY CONTROLLED NPC DRIVERS
	local isCustomTrafficOn = false
	local callCount = 0
	local lastCallTime = os.time()
	local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
	local selectedPlayerId = {}
	local npcDrivers = {}
	local destroyedVehicles = {}
	local npcDriversCount = 35
	local maxNpcDrivers = 35
	local npcRange = 120
	local destroyedVehicleTime = 0
	local newDriverTime = 0
	local npcDriversCountPrev = 0 
	local bruteForceTime = 0 
	local playerbruteForceTime = 0
	local proximityHomingTime = 0
	local playerProximityHomingTime = 0
	local npcJumpTime = 0
	local explodeOnCollisionTime = 0

	--conditions and indexes
	local explodeTypes = {9, 66, 65, 64, 59, 43, 21}
	local blipTypes = {84, 3, 153, 146}
	local currentBlipType = 3  --good ones 84 / 3 / 153 / 146 /  
	--systemthrottle
	local lastTime = os.clock()
	local lastCheckTime = os.clock()
	local frameCount = 0
	local fps = 0
	--npcdriver hate conditions
	local targetPlayersInVehiclesOnly = false
	local targetPlayersOutsideVehiclesOnly = false
	--experimentals
	local isInAirOnly = false
	local ignorePlayersOnFootPH = false
	local ignorePlayersOnFootEoC = false

	--explode on collision
	local isExplodeOnCollisionOn = false
	local explodeOnCollision_explosionDistance = 3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679
	local explodeOnCollision_explosionType = 9
	local explodeOnCollision_explosionDamage = 1
	local explodeOnCollision_explosionInvisible = false
	local explodeOnCollision_explosionAudible = false

	--Superpower variables for "Super Speed/Invincibility"
	local isSuperSpeedOn = false
	local isInvincibilityAndMissionEntityOn = false
	local speedMultiplier = 1
	
	--Variables for the "BruteForce"
	local isBruteForceOn = false
	local push_timer = 10
	local push_cooldown = 0
	local push_threshold = 20.0 
	local push_force_multiplier = 25
	
	--ProximityHoming--
	local isProximityHomingOn = false
	local proximity_push_timer = 0
	local proximity_push_cooldown = 85
	local proximity_push_threshold = 10
	local proximity_push_force_multiplier = 1
	local proximity_distance_threshold = 11

	--playerproximityhoming
	local isPlayerProximityHomingOn = false
	local playerProximity_push_timer = 0
	local playerProximity_push_cooldown = 15
	local playerProximity_push_threshold = 15
	local playerProximity_push_force_multiplier = 1
	local playerProximity_distance_threshold = 10

	--playerbruteforce
	local isPlayerBruteForceOn = false
	local playerBruteForce_push_timer = 0.6
	local playerBruteForce_push_cooldown = 0
	local playerBruteForce_push_threshold = 20.0
	local playerBruteForce_push_force_multiplier = 15
	
	--damage sensitive brute force
	local isBulletBruteForceOn = false
	local bulletBruteForce_push_force_multiplier = 9
	
	--Downward Gravity--
	local isDownwardsGravityOn = false
	local gravity_multiplier = 1
	local downwards_force = -1.245 * gravity_multiplier

	local isAudioSpamOn = false
	local audioSpamTriggerDistance = 30.350
	local audioSpamType = 21
	local audioSpamDamage = 0
	local audioSpamInvisible = true
	local audioSpamAudible = true

	local DriverCount_textColor_r = 0
	local DriverCount_textColor_g = 0
	local DriverCount_textColor_b = 0
	local DriverCount_textColor_a = 0.40
	local DriverCount_textPosition_x = 0.55
	local DriverCount_textPosition_y = 0.80

	local function findIndex(tbl, value)
		for index, v in ipairs(tbl) do
			if v == value then
				return index
			end
		end
		return 1
	end
	local defaultExplodeIndex = findIndex(explodeTypes, 9)
	local defaultBlipIndex = findIndex(blipTypes, 3)
	
	--Presets
	local function isAnyPresetActive()
		if isDebugOn then
			util.toast("isAnyPresetActive activated.")
		end
		return settings.RabidHomingNPCsOn.isOn or 
			   settings.SpeedyNPCsOn.isOn or 
			   settings.FastNPCsOn.isOn or 
			   settings.BumperCarsOn.isOn or 
			   settings.DemonicNPCsOn.isOn or 
			   settings.ExplosiveNPCsOn.isOn or 
			   settings.SpikeExplosiveNPCsOn.isOn or 
			   settings.RandomExplosiveNPCsOn.isOn or 
			   settings.AnnoyingExplosiveNPCsOn.isOn or
			   settings.CarPunchingNPCsOn.isOn
	end

	local function drawPreset(presetName, presetData)
		if isDebugOn then
			util.toast("drawPreset activated.")
		end
		directx.draw_text(presetData.x, presetData.y, presetName, 
		ALIGN_CENTRE, 
		PresetUI.PRESET_SCALE.textScale, presetData.TextColor, false)
	end
	local function updateTargetPlayers()
		if isDebugOn then
			util.toast("updateTargetPlayers was called or is currently active. The heart of the script.")
		end
		local selectedPlayerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(selectedPlayerId)
		local selectedPlayerCoords = ENTITY.GET_ENTITY_COORDS(selectedPlayerPed, true)
		for pId = 0, 31 do
			local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
			local targetCoords = ENTITY.GET_ENTITY_COORDS(targetPed, true)
			local distance = calculate_distance(selectedPlayerCoords.x, selectedPlayerCoords.y, selectedPlayerCoords.z, targetCoords.x, targetCoords.y, targetCoords.z)
			if distance <= npcRange then
				targetPlayers[pId] = true
			else
				targetPlayers[pId] = nil
			end
		end
	end
	local function updateNpcDriversCount()--this function is responsible for keeping track of how many npc drivers are under control
		if isDebugOn then
			util.toast("updateNpcDriversCount was activated")
		end
		npcDriversCount = 0
		for driver, vehicle in pairs(npcDrivers) do
			if ENTITY.DOES_ENTITY_EXIST(driver) then
				npcDriversCount = npcDriversCount + 1
			else
				npcDrivers[driver] = nil
			end
		end
	end
	
		local function onSliderValueChanged(newMaxNpcDrivers)
			if isDebugOn then
				util.toast("onSliderValueChanged activated.")
			end
			maxNpcDrivers = newMaxNpcDrivers
			removeExcessNPCDrivers()
		end	
	
		local function is_colliding(entity1, entity2)--this function is meant to detect collisions within the script, and is currently primarily used for Explode on Collision but other functions can be coded to use this local function
			if isDebugOn then
				util.toast("is_colliding activated.")
			end
			return ENTITY.IS_ENTITY_TOUCHING_ENTITY(entity1, entity2)
		end
	
		local function is_player_in_tough_spot(player)
			if isDebugOn then
				util.toast("is_player_in_tough_spot activated.")
			end
			local playerCoords = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player), false)
			return playerCoords.z > 0.5
		end
		
		local function distance_2d(a, b)
			if isDebugOn then
				util.toast("distance_2d activated.")
			end
			return math.sqrt((b.x - a.x)^2 + (b.y - a.y)^2)
		end

		local function calculate_attraction_force(distance)
			if isDebugOn then
				util.toast("calculate_attraction_force activated.")
			end
			return 2 ^ distance
		end

		local function adjust_npc_trajectory(npc, targetPosition)
			if isDebugOn then
				util.toast("adjust_npc_trajectory activated.")
			end
			local npcCoords = ENTITY.GET_ENTITY_COORDS(npc, false)
			local dx, dy, dz = targetPosition.x - npcCoords.x, targetPosition.y - npcCoords.y, targetPosition.z - npcCoords.z
			local distance = math.sqrt(dx*dx + dy*dy + dz*dz)
			local verticalDistance = math.abs(targetPosition.z - npcCoords.z)
			local desiredSpeed = math.max(1, verticalDistance / 2)
			local timeToReachTarget = distance / desiredSpeed
			local velocity = {
				x = dx / timeToReachTarget,
				y = dy / timeToReachTarget,
				z = dz / timeToReachTarget,
			}
			ENTITY.SET_ENTITY_VELOCITY(npc, velocity.x, velocity.y, velocity.z)
			local angle = math.deg(math.atan2(dy, dx))
			ENTITY.SET_ENTITY_ROTATION(npc, 0, 0, angle)
		end

		local function should_npc_jump(driver, player)
			if isDebugOn then
				util.toast("NPCJump is currently scanning for ideal jump condition opportunities.")
			end
			local driverCoords = ENTITY.GET_ENTITY_COORDS(driver, false)
			local playerCoords = ENTITY.GET_ENTITY_COORDS(player, false)
			for _, ped in ipairs(entities.get_all_peds_as_handles()) do
				if not PED.IS_PED_A_PLAYER(ped) then
					local npcDriverCoords = ENTITY.GET_ENTITY_COORDS(ped, false)
					if math.abs(npcDriverCoords.z - playerCoords.z) < 1.0 then
						return nil
					end
				end
			end
			local preliminaryDistance = distance_2d(driverCoords, playerCoords)
			if preliminaryDistance > 150 then
				return nil
			end
			local playerVelocity = ENTITY.GET_ENTITY_VELOCITY(player)
			local prediction_time = 0.3
			local predicted_position = calculate_future_position(playerCoords, playerVelocity, prediction_time)
			local dx, dy, dz = predicted_position.x - driverCoords.x, predicted_position.y - driverCoords.y, predicted_position.z - driverCoords.z
			local distanceXY = distance_2d(driverCoords, predicted_position)
			local distanceZ = math.abs(driverCoords.z - predicted_position.z)
			local player_speed = vector_magnitude(playerVelocity.x, playerVelocity.y, playerVelocity.z)
			local dynamic_force_multiplier = (dynamic_force_multiplier_value / 100) * ((constant_multiplier_value / 100) + player_speed / player_speed_divisor_value) 
			local max_height_difference = 3
			local isDriverInAir = ENTITY.IS_ENTITY_IN_AIR(driver)
			if isDriverInAir then
				max_height_difference = max_height_difference * 0.05
			end
			if distanceXY < 100 and (distanceZ > 3 or driverCoords.z - playerCoords.z > max_height_difference) then 
				npcJumpTime = os.clock()
				local jumpHeight = 10
				local gentleJumpHeight = 6 
				local isGentleJump = driverCoords.z - playerCoords.z > max_height_difference
				if isDownwardsGravityOn and not DemonicNPCsOn then
					local gravity_compensation = -downwards_force
					jumpHeight = jumpHeight + gravity_compensation
					gentleJumpHeight = gentleJumpHeight + gravity_compensation
					jumpHeight = 14
					jump_cooldown_value = 110
				end
				if DemonicNPCsOn then
					local gravity_compensation = -downwards_force
					jumpHeight = jumpHeight + gravity_compensation
					gentleJumpHeight = gentleJumpHeight + gravity_compensation
					jumpHeight = 18
					jump_cooldown_value = 110
				end
				if isDriverInAir then
					max_height_difference = 3 -- Reset to original value after jump
				end
				local vehicle = PED.GET_VEHICLE_PED_IS_IN(ped, false)
				local vehicleSpeed = ENTITY.GET_ENTITY_SPEED(vehicle)
				local speedMultiplier = 1 + vehicleSpeed / 50 
				if isGentleJump then
					speedMultiplier = 1 
				end
				local isPlayerInAir = ENTITY.IS_ENTITY_IN_AIR(player)
				local isDriverInAir = ENTITY.IS_ENTITY_IN_AIR(driver)
				local forceZ = isGentleJump and gentleJumpHeight or jumpHeight
			
				if isPlayerInAir and isDriverInAir and driverCoords.z > playerCoords.z then
					forceZ = -forceZ * 0.75 -- Reduce the default force to 25% of its original value if the NPC driver is above the player.
				end
				local force = {
					x = dx * dynamic_force_multiplier * speedMultiplier,
					y = dy * dynamic_force_multiplier * speedMultiplier,
					z = forceZ
				}
				return force
			else
				return nil
			end
		end
		
		local function deleteDestroyedVehicles() --cleans
			if isDebugOn then
				util.toast("deleteDestroyedVehicles was called or is currently active.")
			end
			for _, vehicle in ipairs(entities.get_all_vehicles_as_handles()) do
				if VEHICLE.IS_VEHICLE_DRIVEABLE(vehicle, false) == false or ENTITY.IS_ENTITY_DEAD(vehicle) then
					local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1)
					if not PED.IS_PED_A_PLAYER(driver) then
						entities.delete(vehicle)
					end
				end
			end
		end
		local function handleDestroyedNpcDriver(driver) -- after this is triggered once, it runs infinitely until the script stops, instead of only running when triggered
			if isDebugOn then
				util.toast("handleDestroyedNpcDriver activated")
			end
			if ENTITY.DOES_ENTITY_EXIST(driver) then
				local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID())
				local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(targetPed, false)
			end
		end
		
		local function handleVehicleDestroyed(driver, vehicle) -- after this is triggered once, it runs infinitely until the script stops, instead of only running when triggered
			if not ENTITY.DOES_ENTITY_EXIST(vehicle) or not VEHICLE.IS_VEHICLE_DRIVEABLE(vehicle, false) or ENTITY.IS_ENTITY_DEAD(vehicle) then
				if isDebugOn then
					util.toast("handleVehicleDestroyed activated")
				end
				handleDestroyedNpcDriver(driver)
				npcDrivers[driver] = nil
				destroyedVehicleTime = os.clock()
				destroyedDriverTime = os.clock() 
			end
		end
		local function clearNPCDrivers() --this handles script being turned off and on, not realtime..
			if isDebugOn then
				util.toast("deleteDestroyedVehicles was called or is currently active. (Fun fact, this is responsible for clearing NPCDrivers whenever you specifically disable Custom Traffic in any way - a handy function!)")
			end
			for driver, vehicle in pairs(npcDrivers) do
				if ENTITY.DOES_ENTITY_EXIST(driver) and ENTITY.DOES_ENTITY_EXIST(vehicle) then
					TASK.CLEAR_PED_TASKS_IMMEDIATELY(driver)
					PED.SET_PED_CAN_BE_TARGETTED(driver, true)
					TASK.TASK_WANDER_STANDARD(driver, 10.0, 10)
					entities.delete(driver)
					entities.delete(vehicle)
				end
			end
			npcDrivers = {}
		end
	
		local function applyDownwardForce(vehicle)
			if isDebugOn then
				util.toast("applyDownwardForce was called.")
			end
			if isDownwardsGravityOn then
				ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(vehicle, 1, 0, 0, downwards_force, false, false, true, false)
			end
		end
		local function downwardsGravity(pId)
			if isDebugOn then
				util.toast("downwardsGravity was called.")
			end
			if not is_player_active(pId, false, true) then
				return util.stop_thread()
			end
			for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 50.0)) do
				if TASK.GET_ACTIVE_VEHICLE_MISSION_TYPE(vehicle) ~= 6 then
					local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
					if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
						request_control_once(driver)
						apply_downwards_force_to_vehicle(vehicle, downwards_force)
					end
				end
			end
		end

		function calculateDistance(coord1, coord2)
			if isDebugOn then
				util.toast("calculateDistance was called.")
			end
			local dx, dy, dz = coord2.x - coord1.x, coord2.y - coord1.y, coord2.z - coord1.z
			return math.sqrt(dx*dx + dy*dy + dz*dz)
		end
		function calculateForce(coord1, coord2)
			if isDebugOn then
				util.toast("calculateForce was called.")
			end
			local dx, dy, dz = coord2.x - coord1.x, coord2.y - coord1.y, coord2.z - coord1.z
			return {x = dx * proximity_push_force_multiplier, y = dy * proximity_push_force_multiplier, z = dz * proximity_push_force_multiplier}
		end

		local function bruteForce(driver, vehicle, targetPed)
			if isDebugOn then
				util.toast("BruteForce function was called.")
			end
			local vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
			local targetPedCoords = ENTITY.GET_ENTITY_COORDS(targetPed, true)
			local distance_to_player = calculate_distance(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, targetPedCoords.x, targetPedCoords.y, targetPedCoords.z)
			
			if distance_to_player <= push_threshold and current_ms() >= push_timer then
				local dx, dy, dz = targetPedCoords.x - vehicleCoords.x, targetPedCoords.y - vehicleCoords.y, targetPedCoords.z - vehicleCoords.z
				local force = {x = dx * push_force_multiplier, y = dy * push_force_multiplier, z = dz * push_force_multiplier}
				
				if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(playerVehicle) then
					ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(playerVehicle, 1, force.x, force.y, force.z, false, false, true, false)
					push_timer = current_ms() + push_cooldown
					bruteForceTime = os.clock() -- Save the time when brute force was activated
				end
			end
		end
		local function proximityHoming(driver, vehicle, targetPed)
			if isDebugOn then
				util.toast("proximityHoming was called.")
			end
			local vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
			local targetPedCoords = ENTITY.GET_ENTITY_COORDS(targetPed, true)
			local distance_to_player = calculateDistance(vehicleCoords, targetPedCoords)
			if distance_to_player <= proximity_distance_threshold then
				local force = calculateForce(vehicleCoords, targetPedCoords)
				if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle) then
					ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, force.x, force.y, force.z, 0, 0, 0, 0, false, false, true, false, true)
					proximity_push_timer = current_ms() + proximity_push_cooldown
					proximityHomingTime = os.clock()
				end
			end
		end
		local function playerProximityHoming(driver, vehicle, targetPed)
			if isDebugOn then
				util.toast("playerProximityHoming was called.")
			end
			local vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
			local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(targetPed, false)
			local playerCoords = ENTITY.GET_ENTITY_COORDS(playerVehicle, true)
			local distance_to_player = calculateDistance(vehicleCoords, playerCoords)
			if distance_to_player <= playerProximity_distance_threshold then
				local force = calculateForce(playerCoords, vehicleCoords)
				if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(playerVehicle) then
					ENTITY.APPLY_FORCE_TO_ENTITY(playerVehicle, 1, force.x, force.y, force.z, 0, 0, 0, 0, false, false, true, false, true)
					ENTITY.APPLY_FORCE_TO_ENTITY(playerVehicle, 1, force.x, force.y, force.z, 0, 0, 0, 0, false, false, true, false, true)
					playerProximity_push_timer = current_ms() + playerProximity_push_cooldown
					playerProximityHomingTime = os.clock()
				end
			end
		end
		local function bruteForceEffect(pId)
			if isDebugOn then
				util.toast("Bruteforce detected a collision or was activated for some reason.")
			end
		
			local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
			for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 20.0)) do
				local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(targetPed, false)
				local isVehicleDrivenByNPC = false
				for driver, drvVehicle in pairs(npcDrivers) do
					if drvVehicle == vehicle then
						isVehicleDrivenByNPC = true
						break
					end
				end
				if playerVehicle ~= 0 and vehicle ~= playerVehicle and is_colliding(vehicle, playerVehicle) and isVehicleDrivenByNPC then
					local vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
					local targetPedCoords = ENTITY.GET_ENTITY_COORDS(targetPed, true)
					local distance_to_player = calculate_distance(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, targetPedCoords.x, targetPedCoords.y, targetPedCoords.z)
					
					if distance_to_player <= push_threshold and current_ms() >= push_timer then
						local dx, dy, dz = targetPedCoords.x - vehicleCoords.x, targetPedCoords.y - vehicleCoords.y, targetPedCoords.z - vehicleCoords.z
						local force = {x = dx * push_force_multiplier, y = dy * push_force_multiplier, z = dz * push_force_multiplier}
						
						if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(playerVehicle) then
							ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(playerVehicle, 1, force.x, force.y, force.z, false, false, true, false)
							push_timer = current_ms() + push_cooldown
							bruteForceTime = os.clock()
						end
					end
				end
			end
		end
		local function playerBruteForceEffect(pId)
			if isDebugOn then
				util.toast("PlayerBruteForce detected a collision or was activated for some reason.")
			end
			local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
			for _, npcVehicle in ipairs(get_vehicles_in_player_range(pId, 20.0)) do
				local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed, false)
				if playerVehicle ~= 0 and npcVehicle ~= playerVehicle and is_colliding(npcVehicle, playerVehicle) then
					local npcVehicleCoords = ENTITY.GET_ENTITY_COORDS(npcVehicle, true)
					local playerPedCoords = ENTITY.GET_ENTITY_COORDS(playerPed, true)
					local distance_to_player = calculate_distance(npcVehicleCoords.x, npcVehicleCoords.y, npcVehicleCoords.z, playerPedCoords.x, playerPedCoords.y, playerPedCoords.z)
					if distance_to_player <= playerBruteForce_push_threshold and current_ms() >= playerBruteForce_push_timer then
						local dx, dy, dz = npcVehicleCoords.x - playerPedCoords.x, npcVehicleCoords.y - playerPedCoords.y, npcVehicleCoords.z - playerPedCoords.z
						local force = {x = dx * playerBruteForce_push_force_multiplier, y = dy * playerBruteForce_push_force_multiplier, z = dz * playerBruteForce_push_force_multiplier}
						if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(npcVehicle) then
							ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(npcVehicle, 1, force.x, force.y, force.z, false, false, true, false)
							playerBruteForce_push_timer = current_ms() + playerBruteForce_push_cooldown
							playerbruteForceTime = os.clock()
						end
					end									
				end
			end
		end
		local function explodeOnCollisionEffect(pId)
			if isDebugOn then
				util.toast("ExplodeOnCollision detected scanning for active nearby players.")
			end
		
			local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
			local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(targetPed, false)
		
			if playerVehicle ~= 0 or not ignorePlayersOnFootEoC then
				for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 25.0)) do
					local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
					if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
						local vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
						local targetPedCoords = ENTITY.GET_ENTITY_COORDS(targetPed, true)
						local distance_to_player = calculate_distance(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, targetPedCoords.x, targetPedCoords.y, targetPedCoords.z)
		
						if distance_to_player <= explodeOnCollision_explosionDistance then
							local explosionCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
							FIRE.ADD_EXPLOSION(explosionCoords.x, explosionCoords.y, explosionCoords.z, explodeOnCollision_explosionType, explodeOnCollision_explosionDamage, explodeOnCollision_explosionAudible, explodeOnCollision_explosionInvisible, 0)
							explodeOnCollisionTime = os.clock() 
						end
					end
				end
			end
		end
		local function audioSpamEffect(pId)
			if isDebugOn then
				util.toast("audioSpam detected as activated for some reason.")
			end
		
			local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
			for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 150.0)) do
				local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
				if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
					local vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
					local targetPedCoords = ENTITY.GET_ENTITY_COORDS(targetPed, true)
					local distance_to_player = calculate_distance(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, targetPedCoords.x, targetPedCoords.y, targetPedCoords.z)
		
					if distance_to_player <= audioSpamTriggerDistance then
						local explosionCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
						FIRE.ADD_EXPLOSION(explosionCoords.x, explosionCoords.y, explosionCoords.z, audioSpamType, audioSpamDamage, audioSpamAudible, audioSpamInvisible, 1321.0, false)
					end
				end
			end
		end
		local function applySuperPowers(driver, vehicle)
			if not isCustomTrafficOn then  
				return
			end
			if isDebugOn then
				util.toast("applySuperPowers enabled, it's likely that Super Speed or Invincibility is enabled.")
			end
			if isSuperSpeedOn then
				local current_top_speed = VEHICLE.GET_VEHICLE_MODEL_ESTIMATED_MAX_SPEED(ENTITY.GET_ENTITY_MODEL(vehicle))
				VEHICLE.MODIFY_VEHICLE_TOP_SPEED(vehicle, current_top_speed * speedMultiplier)
			end
			if isInvincibilityAndMissionEntityOn then
				ENTITY.SET_ENTITY_INVINCIBLE(vehicle, true)
				ENTITY.SET_ENTITY_INVINCIBLE(driver, true)
			else
				ENTITY.SET_ENTITY_INVINCIBLE(vehicle, false)
				ENTITY.SET_ENTITY_INVINCIBLE(driver, false)
			end
		end
		
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||            v MAIN EXCECUTION LOOP v            ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||            v MAIN EXCECUTION LOOP v            ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--

local function customTraffic(pId)
	local currentTime = os.time()
	if isDebugOn and currentTime - lastCallTime >= 1 then
		util.toast("customTraffic was called " .. callCount .. " times in the last second.")
		callCount = 0
		lastCallTime = currentTime
	end
	if callCount >= 1 then
		return
	end
	updateNpcDriversCount()
	if not is_player_active(pId, false, true) or not isCustomTrafficOn then
		util.toast("A major error has occured and the script cannot run for some reason. Player not active or custom traffic is unable to start due to unforseen conflictions.")
		return util.stop_thread()
	end
	
	for _, vehicle in ipairs(get_vehicles_in_player_range(pId, npcRange)) do
		if npcDriversCount >= maxNpcDrivers then
			drawMaxCount()
			break
		end
		local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
		local targetCoords = ENTITY.GET_ENTITY_COORDS(targetPed, true)
		function resetNPCBehavior(driver, vehicle)
			if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) and npcDrivers[driver] then
				PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(driver, false)
				TASK.CLEAR_PED_TASKS(driver)
				npcDrivers[driver] = nil
			end
		end
		if targetPlayersInVehiclesOnly then
			local targetVehicle = PED.GET_VEHICLE_PED_IS_IN(targetPed, false)
			if targetVehicle == 0 then 
				if isDebugOn then
					util.toast("Player is on foot. Resetting NPC behavior.")
				end
				for driver, vehicle in pairs(npcDrivers) do
					resetNPCBehavior(driver, vehicle)
				end
				return
			else
				if isDebugOn then
					util.toast("TargetPlayersInVehiclesToggle enabled. Targeting players in vehicles.")
				end
			end
		elseif targetPlayersOutsideVehiclesOnly then
			if isDebugOn then
				util.toast("TargetPlayersOutsideVehiclesToggle enabled. Targeting players on foot.")
			end
			local targetVehicle = PED.GET_VEHICLE_PED_IS_IN(targetPed, false)
			if targetVehicle ~= 0 then -- Player is in a vehicle
				for driver, vehicle in pairs(npcDrivers) do
					resetNPCBehavior(driver, vehicle)
				end
				return
			end
		end
		if TASK.GET_ACTIVE_VEHICLE_MISSION_TYPE(vehicle) ~= 6 then
			local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
			local driverCoords = ENTITY.GET_ENTITY_COORDS(driver, true)
			local distance = calculate_distance(targetCoords.x, targetCoords.y, targetCoords.z, driverCoords.x, driverCoords.y, driverCoords.z)
					if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) and npcDrivers[driver] == nil then
						request_control_once(driver)
						PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(driver, true)
						TASK.TASK_VEHICLE_MISSION_PED_TARGET(driver, vehicle, targetPed, 6, 100.0, 0, 0.0, 0.0, true)
						PED.SET_PED_CAN_BE_KNOCKED_OFF_VEHICLE(driver, 1)
						npcDrivers[driver] = vehicle
						applySuperPowers(driver, vehicle)
						npcDriversCount = npcDriversCount + 1
						add_blip_for_entity(driver, currentBlipType, math.random(-6300, -4000))
						PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(driver, true)
						newDriverTime = os.clock() 
						npcDriversCountPrev = npcDriversCount
						callCount = callCount + 1
						if isDebugOn then
							util.toast("removeExcessNPCDrivers is currently active (Fun fact, this is being used to run the Draw Text separate from the Custom Traffic, which patched the old flickering text bug.)")
						end
					end
				end
			end
		end
		
		local function removeExcessNPCDrivers() -- if ctl on then -> until stop
			if isDebugOn then
				util.toast("removeExcessNPCDrivers is currently active (Fun fact, this is being used to run the Draw Text separate from the Custom Traffic, which patched the old flickering text bug.)")
			end
			function drawTextLoop()
				local red = 1
				local green = math.max(3 - (npcDriversCount/7), 0) -- Decrease green as the count approaches 15
				DriverCount_textColor_r = red
				DriverCount_textColor_g = green
				directx.draw_text(DriverCount_textPosition_x, DriverCount_textPosition_y, "  NPC Drivers: " .. tostring(npcDriversCount), ALIGN_CENTRE, CountTextUI.DR_TXT_SCALE.textScale, {r = DriverCount_textColor_r, g = DriverCount_textColor_g, b = DriverCount_textColor_b, a = DriverCount_textColor_a}, false)
			end
			function drawPresetActiveText()
				if isAnyPresetActive() then
					drawPreset("PRESET ACTIVE •", GlobalTextVariables.Preset)
				end
				if settings.DemonicNPCsOn.isOn and (os.clock() - DemonicNPCsTime < 1) then
					drawPreset("• DEMONIC NPCS", GlobalTextVariables.DemonicNPCsActivated)
				end
				if settings.BumperCarsOn.isOn and (os.clock() - BumperCarsTime< 1) then
					drawPreset("• BUMPER CARS", GlobalTextVariables.BumperCarsActivated)
				end
				if settings.RabidHomingNPCsOn.isOn and (os.clock() - RabidHomingNPCsTime< 1) then
					drawPreset("• RABID HOMING NPCS", GlobalTextVariables.RabidHomingNPCsActivated)
				end
				if settings.SpeedyNPCsOn.isOn and (os.clock() - SpeedyNPCsTime< 1) then
					drawPreset("• SPEEDY NPCS", GlobalTextVariables.SpeedyNPCsActivated)
				end
				if settings.FastNPCsOn.isOn and (os.clock() - FastNPCsTime< 1) then
					drawPreset("• FAST NPCS", GlobalTextVariables.FastNPCsActivated)
				end
				if settings.ExplosiveNPCsOn.isOn and (os.clock() - ExplosiveNPCsTime< 1) then
					drawPreset("• EMP NPCS", GlobalTextVariables.ExplosiveNPCsActivated)
				end
				if settings.SpikeExplosiveNPCsOn.isOn and (os.clock() - SpikeExplosiveNPCsTime< 1) then
					drawPreset("• TIRESPIKE NPCS", GlobalTextVariables.SpikeExplosiveNPCsActivated)
				end
				if settings.RandomExplosiveNPCsOn.isOn and (os.clock() - RandomExplosiveNPCsTime< 1) then
					drawPreset("• RANDOM EXPLOSION CHAOS", GlobalTextVariables.RandomExplosiveNPCsActivated)
				end
			end
			function drawMaxCount()
				directx.draw_text(GlobalTextVariables.maxCountxy.x, GlobalTextVariables.maxCountxy.y, "• MAX •", ALIGN_CENTRE, CountTextUI.DR_TXT_SCALE.textScale, GlobalTextVariables.maxCountxy.TextColor, false)
			end
			function drawNewDriver()
				if os.clock() - newDriverTime < 0.1 then 
					directx.draw_text(GlobalTextVariables.newDriverxy.x, GlobalTextVariables.newDriverxy.y, "     • +1", ALIGN_CENTRE, CountTextUI.DR_TXT_SCALE.textScale, GlobalTextVariables.newDriverxy.TextColor, false)
				end
			end
			function drawRemovedDriver()
				if npcDriversCount < npcDriversCountPrev then 
					directx.draw_text(GlobalTextVariables.removedDriverxy.x, GlobalTextVariables.removedDriverxy.y, "-1 •", ALIGN_CENTRE, CountTextUI.DR_TXT_SCALE.textScale, GlobalTextVariables.removedDriverxy.TextColor, false)
				end
			end
			function drawDestroyedVehicle()
				if os.clock() - destroyedVehicleTime < 3 then 
					directx.draw_text(GlobalTextVariables.destroyedVehiclexy.x, GlobalTextVariables.destroyedVehiclexy.y, "An NPCDriver's vehicle has been destroyed!", ALIGN_CENTRE, CountTextUI.DR_TXT_SCALE.textScale, GlobalTextVariables.destroyedVehiclexy.TextColor, false)
				end
			end
			function drawBruteForceActivated()
				if os.clock() - bruteForceTime < 0.6 then 
					directx.draw_text(GlobalTextVariables.bruteForceActivatedxy.x, GlobalTextVariables.bruteForceActivatedxy.y, "• Brute Force: TRIGGERED", ALIGN_CENTRE, CountTextUI.DR_TXT_SCALE.textScale, GlobalTextVariables.bruteForceActivatedxy.TextColor, false)
				end
			end
			function drawPlayerBruteForceActivated()
				if os.clock() - playerbruteForceTime < 0.6 then 
					directx.draw_text(GlobalTextVariables.playerbruteForceActivatedxy.x, GlobalTextVariables.playerbruteForceActivatedxy.y, "• Player Brute Force: TRIGGERED", ALIGN_CENTRE, CountTextUI.DR_TXT_SCALE.textScale, GlobalTextVariables.playerbruteForceActivatedxy.TextColor, false)
				end
			end
			function drawProximityHomingActivated()
				if os.clock() - proximityHomingTime < 0.8 then
					directx.draw_text(GlobalTextVariables.proximityHomingActivatedxy.x, GlobalTextVariables.proximityHomingActivatedxy.y, "• Proximity Homing: ON", ALIGN_CENTRE, CountTextUI.DR_TXT_SCALE.textScale, GlobalTextVariables.proximityHomingActivatedxy.TextColor, false)
				end
			end
			function drawPlayerProximityHomingActivated()
				if os.clock() - playerProximityHomingTime < 0.7 then 
					directx.draw_text(GlobalTextVariables.playerProximityHomingActivatedxy.x, GlobalTextVariables.playerProximityHomingActivatedxy.y, "• Player Proximity Homing: ON", ALIGN_CENTRE, CountTextUI.DR_TXT_SCALE.textScale, GlobalTextVariables.playerProximityHomingActivatedxy.TextColor, false)
				end
			end
			function drawNPCJumpActivated()
				if os.clock() - npcJumpTime < 0.5 then 
					directx.draw_text(GlobalTextVariables.npcJumpActivatedxy.x, GlobalTextVariables.npcJumpActivatedxy.y, "• An NPC has Jumped!", ALIGN_CENTRE, CountTextUI.DR_TXT_SCALE.textScale, GlobalTextVariables.npcJumpActivatedxy.TextColor, false)
				end
			end
			function drawExplodeOnCollisionActivated()
				if os.clock() - explodeOnCollisionTime < 0.5 then 
					directx.draw_text(GlobalTextVariables.explodeOnCollisionActivatedxy.x, GlobalTextVariables.explodeOnCollisionActivatedxy.y, "• EoC: TRIGGERED", ALIGN_CENTRE, CountTextUI.DR_TXT_SCALE.textScale, GlobalTextVariables.explodeOnCollisionActivatedxy.TextColor, false)
				end
			end
			if isAnyPresetActive() then
				drawPresetActiveText()
			end
			drawTextLoop()
			drawNewDriver()
			drawRemovedDriver()
			drawDestroyedVehicle()
			drawNPCJumpActivated()
			drawBruteForceActivated()
			drawProximityHomingActivated()
			drawPlayerBruteForceActivated()
			drawExplodeOnCollisionActivated()
			drawPlayerProximityHomingActivated()
			for driver, vehicle in pairs(npcDrivers) do
				handleVehicleDestroyed(driver, vehicle)
			end
			local removedCount = 0
			for driver, vehicle in pairs(npcDrivers) do
				if removedCount >= npcDriversCount - maxNpcDrivers then
					break
				end
				if ENTITY.DOES_ENTITY_EXIST(driver) and ENTITY.DOES_ENTITY_EXIST(vehicle) then
					TASK.CLEAR_PED_TASKS_IMMEDIATELY(driver)
					ENTITY.SET_ENTITY_AS_MISSION_ENTITY(driver, false, false)
					ENTITY.SET_ENTITY_AS_MISSION_ENTITY(vehicle, false, false)
					PED.SET_PED_CAN_BE_TARGETTED(driver, true)
					TASK.TASK_WANDER_STANDARD(driver, 10.0, 10)
					entities.delete(driver)
					entities.delete(vehicle)
					npcDrivers[driver] = nil
					removedCount = removedCount + 1
				end
			end
			npcDriversCount = npcDriversCount - removedCount
		end	
		local function resetPresetsToDefault()
			if not isCustomTrafficOn then
				util.toast("Nothing happened - Custom Traffic needs to be running for this to take effect!")
				return -- Exit
			end
			isSuperSpeedOn = false
			isInvincibilityAndMissionEntityOn = false
			isBruteForceOn = false
			isJumpCooldownOn = false
			isPlayerBruteForceOn = false
			isPlayerProximityHomingOn = false
			AudioSpam_isOn = false
			settings.playerGravityControl.IsOn = false
			isExplodeOnCollisionOn = false
			explosionDistance = 3
			gravity_multiplier = 1
			speedMultiplier = 1
			explosionType = 9
			explosionDamage = 1
			explosionInvisible = false
			explosionAudible = false
			push_timer = 0.6
			isInvincibilityAndMissionEntityOn = false
			push_cooldown = 15
			push_threshold = 20.0 
			push_force_multiplier = 25
			isProximityHomingOn = false
			proximity_push_timer = 0
			proximity_push_cooldown = 85
			proximity_push_threshold = 7
			proximity_push_force_multiplier = 1 
			downwards_force = -1.245
			proximity_distance_threshold = 10 
			isDownwardsGravityOn = false
			npcDriversCount = 35
			maxNpcDrivers = 35
			npcRange = 120
			npcDriversCountPrev = 0 
			bruteForceTime = 0 
			playerbruteForceTime = 0
			proximityHomingTime = 0
			playerProximityHomingTime = 0
			npcJumpTime = 0
			explodeOnCollisionTime = 0
			isOn = false
			TriggerDistance = 30.350
			audioType = 21
			audioDamage = 0
			audioInvisible = true
			spamAudible = true
			explosionDistance = 3
			explosionType = 9
			explosionDamage = 1
			explosionInvisible = false
			explosionAudible = false
			push_timer = 0.6
			push_cooldown = 0
			push_threshold = 20.0
			push_force_multiplier = 15
			push_timer = 0
			push_cooldown = 15
			push_threshold = 30
			push_force_multiplier = 1
			distance_threshold = 10
			TriggerDistance = 30.350
			audioType = 58
			audioDamage = 0
			audioInvisible = true
			spamAudible = true
			util.toast("Clean Slate Applied - All NPC Behavior has been reverted back to default settings, please note that residual NPCs may still attempt to run players over after this. Uncheck and re-enable Custom Traffic /or Presets to resume.")
		end
		local function customTrafficLoop()
			while true do
				if settings.playerGravityControl.isOn then
					if isDebugOn then
						util.toast("playerGravityControl detected as activated for some reason.")
					end
					for pId = 0, 31 do
						if is_player_active(pId, false, true) and isCustomTrafficOn then
							local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
							applyPlayerGravityControl(targetPed)
						end
					end
				end

				if ResetPresetsOn then
					isCustomTrafficOn = false
					isSuperSpeedOn = false
					isInvincibilityAndMissionEntityOn = false
					isBruteForceOn = false
					isJumpCooldownOn = false
					isPlayerBruteForceOn = false
					AudioSpam_isOn = false
					isPlayerProximityHomingOn = false
					settings.playerGravityControl.IsOn = false
					isExplodeOnCollisionOn = false
					settings.RabidHomingNPCsOn.isOn = false 
					settings.SpeedyNPCsOn.isOn = false 
					settings.FastNPCsOn.isOn = false 
					settings.BumperCarsOn.isOn = false 
					settings.DemonicNPCsOn.isOn = false 
					settings.ExplosiveNPCsOn.isOn = false 
					settings.SpikeExplosiveNPCsOn.isOn = false 
					settings.RandomExplosiveNPCsOn.isOn = false 
					settings.AnnoyingExplosiveNPCsOn.isOn = false
					settings.CarPunchingNPCsOn.isOn = false
					explosionInvisible = false
					explosionAudible = false
					isProximityHomingOn = false
					isDownwardsGravityOn = false
					isOn = false
					audioInvisible = true
					spamAudible = true
					explosionDistance = 3
					downwards_force = -1.245
					gravity_multiplier = 1
					speedMultiplier = 1
					explosionType = 9
					explosionDamage = 1
					push_timer = 0.6
					push_cooldown = 15
					push_threshold = 20.0 
					push_force_multiplier = 25
					proximity_push_timer = 0
					proximity_push_cooldown = 85
					proximity_push_threshold = 30 
					proximity_push_force_multiplier = 1 
					proximity_distance_threshold = 10 
					npcDriversCount = 35
					maxNpcDrivers = 35
					npcRange = 120
					npcDriversCountPrev = 0 
					bruteForceTime = 0 
					playerbruteForceTime = 0
					proximityHomingTime = 0
					playerProximityHomingTime = 0
					npcJumpTime = 0
					explodeOnCollisionTime = 0
					TriggerDistance = 30.350
					explosionDistance = 3
					explosionType = 9
					explosionDamage = 1
					push_timer = 0.6
					push_cooldown = 0
					push_threshold = 20.0
					push_force_multiplier = 15
					push_timer = 0
					push_cooldown = 15
					push_threshold = 30
					push_force_multiplier = 1
					distance_threshold = 10
					TriggerDistance = 30.350
					clearNPCDrivers()
					util.toast("Applied Clean Slate + Wiped previous existing NPCs . . . Disable me when you're done!")
				end

				if settings.CarPunchingNPCsOn.isOn then
					isCustomTrafficOn = true
					isDownwardsGravityOn = true
					isProximityHomingOn = true
					isJumpCooldownOn = true
					isBruteForceOn = true
					isPlayerBruteForceOn = true
					isInvincibilityAndMissionEntityOn = true
					proximity_distance_threshold = 100
				end

				if settings.RabidHomingNPCsOn.isOn then
					isCustomTrafficOn = true
					isProximityHomingOn = true
					isSuperSpeedOn = true
					isDownwardsGravityOn = true
					isProximityHomingOn = true
					isBruteForceOn = true
					isJumpCooldownOn = true
					proximity_distance_threshold = math.random(5, 10)
					proximity_push_force_multiplier = 1 / 2 
					push_force_multiplier = math.random(5, 15)
					npcRange = 120
					maxNpcDrivers = 55
					RabidHomingNPCsTime = os.clock()
				end

				if settings.SpeedyNPCsOn.isOn then
					isCustomTrafficOn = true
					isSuperSpeedOn = true
					isDownwardsGravityOn = true
					isBruteForceOn = true
					push_force_multiplier = math.random(1, 45)
					npcRange = 160
					maxNpcDrivers = 15
					speedMultiplier = 8000
					SpeedyNPCsTime = os.clock()
				end

				if settings.FastNPCsOn.isOn then
					isCustomTrafficOn = true
					isSuperSpeedOn = true
					AudioSpam_isOn = true
					npcRange = 140
					maxNpcDrivers = 55
					FastNPCsTime = os.clock()
				end

				if settings.BumperCarsOn.isOn then
					isCustomTrafficOn = true
					isSuperSpeedOn = true
					isBruteForceOn = true
					isPlayerBruteForceOn = true
					push_force_multiplier = math.random(5, 35)
					playerBruteForce_push_force_multiplier = math.random(5, 75)
					push_cooldown = math.random(5, 15)
					playerBruteForce_push_cooldown = math.random(0, 35)
					speedMultiplier = 9000
					npcRange = 120
					maxNpcDrivers = 25
					BumperCarsTime = os.clock()
				end

				if settings.DemonicNPCsOn.isOn then
					isCustomTrafficOn = true
					isSuperSpeedOn = true
					isDownwardsGravityOn = true
					isBruteForceOn = true
					isProximityHomingOn = true
					isJumpCooldownOn = true
					isInvincibilityAndMissionEntityOn = true
					isPlayerBruteForceOn = false
					isPlayerProximityHomingOn = true
					isExplodeOnCollisionOn = true
					playerBruteForce_push_force_multiplier = math.random(1, 75)
					playerProximityHoming_distance_threshold = math.random(350, 950)
					explodeOnCollision_explosionType = math.random(1, 75)
					explodeOnCollision_explosionDistance = math.random(3, 20)
					push_force_multiplier = math.random(5, 150)
					npcRange = 220
					maxNpcDrivers = 65
					max_height_difference_value = 3
					distanceXY_value = 150
					distanceZ_value = 2
					proximity_distance_threshold = math.random(300, 750)
					proximity_push_force_multiplier = math.random(15, 495)
					downwards_force = math.random(-28, 12)
					DemonicNPCsTime = os.clock()
				end

				if settings.ExplosiveNPCsOn.isOn then
					isCustomTrafficOn = true
					isSuperSpeedOn = true
					isDownwardsGravityOn = true
					isExplodeOnCollisionOn = true
					explodeOnCollision_explosionType = 65
					explodeOnCollision_explosionDistance = 7
					npcRange = 120
					maxNpcDrivers = 20
					ExplosiveNPCsTime = os.clock()
				end

				if settings.SpikeExplosiveNPCsOn.isOn then
					isCustomTrafficOn = true
					isSuperSpeedOn = true
					isDownwardsGravityOn = true
					isExplodeOnCollisionOn = true
					explodeOnCollision_explosionType = 66
					explodeOnCollision_explosionDistance = 5
					npcRange = 120
					maxNpcDrivers = 20
					SpikeExplosiveNPCsTime = os.clock()
				end

				if settings.RandomExplosiveNPCsOn.isOn then
					isCustomTrafficOn = true
					isSuperSpeedOn = true
					isDownwardsGravityOn = true
					isProximityHomingOn = true
					isExplodeOnCollisionOn = true
					explodeOnCollision_explosionType = math.random(1, 75)
					explodeOnCollision_explosionDamage = math.random(0, 1)
					explodeOnCollision_explosionDistance = 17
					npcRange = 120
					maxNpcDrivers = 20
					RandomExplosiveNPCsTime = os.clock()
				end

				if settings.AnnoyingExplosiveNPCsOn.isOn then
					isCustomTrafficOn = true
					isSuperSpeedOn = true
					isDownwardsGravityOn = true
					isExplodeOnCollisionOn = true
					explodeOnCollision_explosionType = math.random(64, 66)
					maxNpcDrivers = 35
					speedMultiplier = 9000
				end
				
				if isJumpCooldownOn then
					if isDebugOn then
						util.toast("JumpCooldown internal loop activated.")
					end
					if lastJump.elapsed() > jump_cooldown_value and isCustomTrafficOn then
						for pId = 0, 31 do
							if is_player_active(pId, false, true) then
								local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
								if is_player_in_tough_spot(pId) then
									for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 150)) do
										local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1)
										if not PED.IS_PED_A_PLAYER(driver) then
											local force = should_npc_jump(driver, targetPed)
											if force then
												request_control_once(vehicle)
												ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, force.x, force.y, force.z, 0.0, 0.0, 0.0, 0, false, false, true, false, false)
											end
										end
									end
								end
							end
						end
						lastJump.reset()
					end
				end
				if isProximityHomingOn then
					if isDebugOn then
						util.toast("ProximityHoming detected scanning for active nearby players.")
					end
						for pId = 0, 31 do
							if is_player_active(pId, false, true) and isCustomTrafficOn then
								local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
								for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 20.0)) do
									local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
									if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
										proximityHoming(driver, vehicle, targetPed)
									end
								end
							end
						end
					end
				if isPlayerProximityHomingOn then
					if isDebugOn then
						util.toast("PlayerProximityHoming detected scanning for active nearby players.")
					end
					for pId = 0, 31 do
						if is_player_active(pId, false, true) and isCustomTrafficOn then
							local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
							for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 20.0)) do
								local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
								if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
									playerProximityHoming(driver, vehicle, targetPed)
								end
							end
						end
					end
				end
				if isExplodeOnCollisionOn then
					for pId = 0, 31 do
						if is_player_active(pId, false, true) and isCustomTrafficOn then
							explodeOnCollisionEffect(pId)
						end
					end
				end				
				if isAudioSpamOn then
					for pId = 0, 31 do
						if is_player_active(pId, false, true) and isCustomTrafficOn then
							audioSpamEffect(pId)
						end
					end
				end				
				if isBruteForceOn then
					for pId = 0, 31 do
						if is_player_active(pId, false, true) and isCustomTrafficOn then
							bruteForceEffect(pId)
						end
					end
				end
				
				if isPlayerBruteForceOn then
					for pId = 0, 31 do
						if is_player_active(pId, false, true) and isCustomTrafficOn then
							playerBruteForceEffect(pId)
						end
					end
				end
				
				if isCustomTrafficOn then
					if isDebugOn then
						util.toast("isCustomTrafficOn internal loop activated.")
					end
					for pId = 0, 31 do
						if is_player_active(pId, false, true) then
							customTraffic(pId)
						end
					end
					for driver, vehicle in pairs(npcDrivers) do
						applySuperPowers(driver, vehicle)
						applyDownwardForce(vehicle)
						if VEHICLE.IS_VEHICLE_DRIVEABLE(vehicle, false) == false or ENTITY.IS_ENTITY_DEAD(vehicle) then
							local attacker = ENTITY.GET_ENTITY_ATTACHED_TO(vehicle)
							if ENTITY.DOES_ENTITY_EXIST(attacker) then
								ENTITY.DETACH_ENTITY(vehicle, true, true)
							end
							entities.delete(vehicle)
							destroyedVehicles[vehicle] = true
							npcDrivers[driver] = nil
						end
					end
					removeExcessNPCDrivers()
				end
				local currentTime = os.time()
				if currentTime - lastCheckTime >= 1 then
					if callCount > 17 then
						local extraCalls = callCount - 17
						local sleepDuration = math.min(12, extraCalls * 2)
						util.yield(sleepDuration)
					else
						util.yield(0)
					end
					callCount = 0
					lastCheckTime = currentTime
				else
					util.yield(0)
				end
			end
		end

		local function customTrafficToggle(on)
			if isDebugOn then
				util.toast("customTrafficToggleOnStop internal loop activated (This shouldnt be on!).")
			end
			isCustomTrafficOn = on
			if not isCustomTrafficOn then
				deleteDestroyedVehicles()
				clearNPCDrivers()
				util.toast("--==[[Custom traffic has been disabled. Previously Controlled NPCDrivers have been removed]]==--")
			end
		end
		local function DebugToggle(on)
			isDebugOn = on
		end
		
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||     ^ END OF CUSTOM TRAFFIC LOOP ^             ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||    v CTL HOME / TOGGLES / FOLDERS v            ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--

		local CustomTrafficLoop = menu.toggle(ChaoticOpt, translate("Ultimate Custom Traffic", "CTL | Custom Traffic | Toggle"), {}, false, customTrafficToggle)
		local customTrafficOpt = menu.list(CTLCustomsXT, translate("Trolling", "Depriciated features"), {}, "Leftovers / extra space for future features")
		local Debug = menu.toggle(CTLCustomsXT, translate("Menu Debugger - Watch the script run in realtime", "Menu Debugger"), {}, false, DebugToggle)
		local npcDriversSlider = menu.slider(CTLCustoms, translate("Ultimate Custom Traffic", "MAX NPC Drivers • >"), {}, "Warning - Custom Traffic needs to be enabled for these to take effect! Control the amount of NPC Drivers you want chasing the player, decreasing the number deletes NPCs based on the value to save FPS",
		0, 126, 35, 1,
		function(value)
			maxNpcDrivers = value
			removeExcessNPCDrivers()
		end)
		local npcRangeSlider = menu.slider(CTLCustoms, translate("Ultimate Custom Traffic", "NPC Attraction Range • >"), {}, "Warning - Custom Traffic needs to be enabled for these to take effect! Set your own custom range for how far from the player NPCs will become reaped for control, go wild.",
		20, 460, 120, 10,
		function(value)
			npcRange = value
		end)

		local blipTypeSlider = menu.slider(CTLCustomsXT, 
		translate("Blip Type Selector", "Select NPC Blip Type • >"), 
		{}, 
		"Select the type of blip that will be displayed on your Mini-Map for NPCDrivers.",
		1, #blipTypes, defaultBlipIndex, 1,
		function(index)
			currentBlipType = blipTypes[index]
		end)

		local CTLPresets <const> = menu.list(menu.player_root(pId), translate("Trolling", "•CTL Presets•"), {}, "Dont feel like customizing NPC Super powers right now? Try out a few pre-made presets to see whats possible at a glance | Tip: Don't be afraid to turn multiple presets on at once, every preset has SPECIAL abilities, that can be overlapped into other presets, just turn all corrsponding presets with powers you want on, then leave the final most powerful preset ON for highest NPC and PC preformance - turning all the weakest presets off except one. Dont worry, the settings wont undo unless they are overwritten / reset to default by you.")
		
		local CTLSpecials = menu.list(ChaoticOpt, translate("Trolling", "CTL Special Settings • >"), {}, "[Alpha - WIP] Apply special super powers that dont exist in native CTL Super powers. These settings give NPCs / Players special specific abilities.")
		local TargetPlayersInVehiclesToggle = menu.toggle(CTLSpecials, "NPCDrivers Hate Players in Vehicles", {}, false, function(val)
			targetPlayersInVehiclesOnly = val
		end)
		local TargetPlayersOutsideVehiclesToggle = menu.toggle(CTLSpecials, "NPCDrivers Hate Players On Foot", {}, false, function(val)
			targetPlayersOutsideVehiclesOnly = val
		end)
		local ResetPresets = menu.action(ChaoticOpt, "Reset Default Settings", {}, "Reset all existing / current active presets to a clean slate - WITHOUT turning Custom Traffic OFF. It's a seamless transition into NPC Normalcy, leave players rattled and confused!", function()
			resetPresetsToDefault()
		end)
		local ResetPresets = createMenuToggle(ChaoticOpt, "Disable Presets + Despawn NPCs | You do not need to worry about this setting unless you are using Custom Traffic > CTL Presets.", false, function(on) ResetPresetsOn = on end)

--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||              ^ END OF CTL CORE ^                  ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||   v BEGINNING AND END OF MENU.LIST STRUCTURE v    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--

		local extrasList = menu.list(extraTraffic, translate("Ultimate Custom Traffic", "X Extra Traffic Options •     >"), {}, "The functions inside of this folder are the god fathers to the SuperPowers within > CTL Customs. I decided to keep them in the script in their raw form, since they have their own practical applications. Be warned, in their raw forms, they are unrestricted and have been configured for the purpose of trolling / griefing. Do not apply these to anyone you care about.")
		local moreToolslist = menu.list(customTrafficOpt, translate("Ultimate Custom Traffic", "More Tools / Options •     >"), {}, "Go crazy, go stupid.")
		local NPCPowers = menu.list(superPowersMenu, translate("Ultimate Custom Traffic", "NPC Powers •     >"), {}, "Warning - Custom Traffic needs to be enabled for these to take effect! Powers within this tab will apply to NPCDrivers and Chaotic Drivers.")
		local customizeNPCPowers = menu.list(NPCPowers, translate("Ultimate Custom Traffic", "Customize NPC Powers •     >"), {}, "Warning - Custom Traffic needs to be enabled for these to take effect!")
		local PlayerPower = menu.list(superPowersMenu, translate("Ultimate Custom Traffic", "Player Powers •     >"), {}, "Warning - Custom Traffic needs to be enabled for these to take effect! Powers within this tab will apply to Players and their cars.")
		local customizePlayerPower = menu.list(PlayerPower, translate("Ultimate Custom Traffic", "Customize Player Powers •     >"), {}, "Warning - Custom Traffic needs to be enabled for these to take effect! Please note: These settings only need to be configured once per lobby IF you apply them to yourself and spectate OTHER players. CTL will iterate THROUGH whoever has CTL enabled, so it's recommended to apply them to yourself and sit offmap / in the ocean, then spectate people and watch the chaos start around them as CTL iterates through you!")
		
		local audioSpam = menu.list(customizeNPCPowers, translate("Customize Audio Spam •     >", "Customize Audio Spam •     >"))
		local audioSpamToggle = createMenuToggle(NPCPowers, "AP Audio Spam ", false, function(on) isAudioSpamOn = on end)
		local audioInvisibleToggle = createMenuToggle(audioSpam, "AP Invisible Explosion @", true, function(on) audioSpamInvisible = on end)
		local spamAudibleToggle = createMenuToggle(audioSpam, "AP Audible @", true, function(on) audioSpamAudible = on end)
		local triggerDistanceSlider = createMenuSlider(audioSpam, "AP Trigger Distance • >", "How far from the car to the player will count as a collision?", 1, 1000, math.floor(audioSpamTriggerDistance * 10), 25, function(value) audioSpamTriggerDistance = value / 10 end)
		local audioTypeSlider = createMenuSlider(audioSpam, "AP Audio Type • >", "Default: Predator Calls", 0, 82, audioSpamType, 1, function(value) audioSpamType = value end)
		local audioDamageSlider = createMenuSlider(audioSpam, "AP Damage • >", "Go nuts", 0, 1000, audioSpamDamage, 1, function(value) audioSpamDamage = value end)

		local jumpCooldownToggle = createMenuToggle(CTLCustoms, "NPC Jump Ability", false, function(on) isJumpCooldownOn = on end)
		local upwardforceSlider2 = createMenuSlider(CTLCustoms, "NPC Gravity Slider • >", "How strong is the NPC gravity? THIS NEEDS TO BE Enabled within > Add Super Powers > NPC Powers > NPC Gravity Control", -1000, 10000, math.floor(downwards_force), 1, function(value) downwards_force = value / 10 end)
		local gravityMultiplierSlider = createMenuSlider(moreToolslist, "Player Gravity • >", "How strong is the Player gravity? THIS NEEDS TO BE Enabled within > Add Super Powers > Player Powers > Player Gravity", 0, 100, settings.playerGravityControl.gravity_multiplier, 1, function(value) settings.playerGravityControl.gravity_multiplier = value end)
		local playerGravityControlToggle = createMenuToggle(moreToolslist, "Player Gravity Control", false, function(on) settings.playerGravityControl.isOn = on end)

		local downwardsGravity = createMenuToggle(NPCPowers, "NPC Gravity Control", false, function(on) isDownwardsGravityOn = on end)
		local invincibilityAndMissionEntityToggle = createMenuToggle(NPCPowers, "Invincibility & Mission Entity", false, function(on) isInvincibilityAndMissionEntityOn = on end)
		local superSpeedToggle = createMenuToggle(NPCPowers, "Super Speed", false, function(on) isSuperSpeedOn = on end)
		local superSpeedSlider = createMenuSlider(CTLCustoms, "Super Speed Multiplier • >", "Modify the engine power and wheel torque of NPC & Chaotic Drivers! THIS NEEDS TO BE Enabled within > Add Super Powers > NPC Powers > Super Speed", 0, 50000, 5000, 1000, function(value) speedMultiplier = value end)

		local playerProximityHomingMenu = menu.list(customizePlayerPower, translate("Customize Player Proximity Homing •     >", "Customize Player Proximity Homing •     >"))
		local pushCooldownSlider = createMenuSlider(playerProximityHomingMenu, "PH Player Lunge Cooldown", "", 0, 10000, playerProximity_push_cooldown, 100, function(value) playerProximity_push_cooldown = value end)
		local pushTimerSlider = createMenuSlider(playerProximityHomingMenu, "PH Player Lunge Duration", "?", 0, 2000, playerProximity_push_timer, 1, function(value) playerProximity_push_timer = value end)
		local pushThresholdSlider = createMenuSlider(playerProximityHomingMenu, "PH Player Lunge Threshold", "How powerful will the player be attracted to the NPC within their range?", 0, 5000, playerProximity_push_threshold, 1, function(value) playerProximity_push_threshold = value end)
		local pushForceMultiplierSlider = createMenuSlider(playerProximityHomingMenu, "PH Lunge Force Multiplier", "Multiples the Lunge Threshold value by this value", 0, 5000, playerProximity_push_force_multiplier * 5, 1, function(value) playerProximity_push_force_multiplier = value / 100 end)
		local distanceThresholdSlider = createMenuSlider(playerProximityHomingMenu, "PH Attraction Range", "How close before the player lunges at the NPC to keep them pinned", 0, 5000, (playerProximity_distance_threshold * 10) - 85, 1, function(value) playerProximity_distance_threshold = (value + 85) / 10 end)
		local playerProximityHomingToggle = createMenuToggle(PlayerPower, "Player Proximity Homing", false, function(on) isPlayerProximityHomingOn = on end)
		
		local proximityhoming = menu.list(customizeNPCPowers, translate("Customize Proximity Homing •     >", "Customize Proximity Homing •     >"))
		local pushCooldownSlider = createMenuSlider(proximityhoming, "PH NPC Lunge Cooldown", "", 0, 10000, proximity_push_cooldown, 100, function(value) proximity_push_cooldown = value end)
		local pushTimerSlider = createMenuSlider(proximityhoming, "PH NPC Lunge Duration", "?", 0, 2000, proximity_push_timer, 1, function(value) proximity_push_timer = value end)
		local pushThresholdSlider = createMenuSlider(proximityhoming, "PH NPC Lunge Threshold", "How powerful will the NPCs be attracted to the player within their range?", 0, 5000, proximity_push_threshold, 1, function(value) proximity_push_threshold = value end)
		local pushForceMultiplierSlider = createMenuSlider(proximityhoming, "PH Lunge Force Multiplier", "Multiples the Lunge Threshold value by this value", 0, 5000, proximity_push_force_multiplier * 2, 1, function(value) proximity_push_force_multiplier = value / 100 end)
		local distanceThresholdSlider = createMenuSlider(proximityhoming, "PH Attraction Range", "How close before the NPC drivers lunge at the player to keep them pinned", 0, 5000, (proximity_distance_threshold * 10) - 97, 1, function(value) proximity_distance_threshold = (value + 85) / 10 end)
		local proximityHomingToggle = createMenuToggle(NPCPowers, "Proximity Homing", false, function(on) isProximityHomingOn = on end)
		
		local bruteForceToggle = createMenuToggle(NPCPowers, "Brute Force", false, function(on) isBruteForceOn = on end)
		local bruteForce = menu.list(customizeNPCPowers, translate("Customize BruteForce •     >", "Customize NPC BruteForce •     >"))
		local pushTimerSliderBruteF = createMenuSlider(bruteForce, "BruteF Push Timer (ms) • >", "Cooldown between pushes in ms", 1, 1000, push_cooldown, 25, function(value) push_cooldown = value end)
		local pushThresholdSliderBruteF = createMenuSlider(bruteForce, "BruteF Push Threshold (Tenths of a Meter) • >", "Maximum distance between player and other vehicles to trigger the push in tenths of a meter.", 1, 1000, push_threshold * 10, 15, function(value) push_threshold = value / 10 end)
		local pushForceMultiplierSliderBruteF = createMenuSlider(bruteForce, "BruteF Push Force Multiplier  • >", "Multiplier for the force applied to push vehicles.", 1, 5000, push_force_multiplier, 1, function(value) push_force_multiplier = value end)
		

		local playerBruteForceToggle = createMenuToggle(PlayerPower, "Player Brute Force", false, function(on) isPlayerBruteForceOn = on end)
		local playerBruteForceMenu = menu.list(customizePlayerPower,  translate("Customize Player BruteForce •     >", "Customize Player BruteForce •     >"))
		local pushTimerSliderPlayerBruteF = createMenuSlider(playerBruteForceMenu, "Player BruteF Push Timer (ms) • >", "Cooldown between pushes in ms", 1, 1000, playerBruteForce_push_cooldown, 25, function(value) playerBruteForce_push_cooldown = value end)
		local pushThresholdSliderPlayerBruteF = createMenuSlider(playerBruteForceMenu, "Player BruteF Push Threshold (Tenths of a Meter) • >", "Maximum distance between player and other vehicles to trigger the push in tenths of a meter.", 1, 1000, playerBruteForce_push_threshold * 10, 5, function(value) playerBruteForce_push_threshold = value / 10 end)
		local pushForceMultiplierSliderPlayerBruteF = createMenuSlider(playerBruteForceMenu, "Player BruteF Push Force Multiplier  • >", "Multiplier for the force applied to push vehicles.", 1, 5000, playerBruteForce_push_force_multiplier, 1, function(value) playerBruteForce_push_force_multiplier = value end)
		
		local ExplodeOnCollisionMenu = menu.list(customizeNPCPowers, translate("Customize Explode On Collision •     >", "Customize Explode On Collision •     >"))
		local explodeOnCollisionToggle = createMenuToggle(NPCPowers, "EoC Explode on Collision ", false, function(on) isExplodeOnCollisionOn = on end)
		local explodeInvisibleToggle = createMenuToggle(ExplodeOnCollisionMenu, "EoC Invisible Explosion @", false, function(on) explodeOnCollision_explosionInvisible = on end)
		local explodeAudibleToggle = createMenuToggle(ExplodeOnCollisionMenu, "EoC Audible Explosion @", false, function(on) explodeOnCollision_explosionAudible = on end)
		local explodeDistanceSlider = createMenuSlider(ExplodeOnCollisionMenu, "EoC Explosion Distance • >", "How far from the car to the player will count as a collision?", 1, 1000, math.floor(explodeOnCollision_explosionDistance * 10), 1, function(value) explodeOnCollision_explosionDistance = value / 10 end)
		local explodeTypesSlider = menu.slider(ExplodeOnCollisionMenu, 
		translate("Blip Type Selector", "Select NPC Explosion Type • >"), 
		{}, 
		"1 = InstaBoom. 2 = Tire Spikes. 3 = EMP. 4 = Player Thrower.",
		1, #explodeTypes, defaultExplodeIndex, 1,
		function(index)
			explodeOnCollision_explosionType = explodeTypes[index]
		end)
		local explodeDamageSlider = createMenuSlider(ExplodeOnCollisionMenu, "EoCExplosion Damage • >", "Go nuts", 0, 1000, explodeOnCollision_explosionDamage, 1, function(value) explodeOnCollision_explosionDamage = value end)
		
		--presets
		local presetMenuToggles = {}

		presetMenuToggles.ResetPresets = createMenuToggle(CTLPresets, "Disable Presets + Despawn NPCs | You do not need to worry about this setting unless you are using Ultimate Custom Traffic > CTL Presets.", false, function(on) 
			ResetPresetsOn = on end)
		presetMenuToggles.FastNPCs = createMenuToggle(CTLPresets, "FAIR | Simply Fast NPCs | Turns any underperforming NPC into a speed demon! Applied Settings - NPC Attraction Range = 140 - MaxNPCs = 15 - Downwards Gravity - Super Speed", false, function(on) 
			settings.FastNPCsOn.isOn = on end)
		presetMenuToggles.SpeedyNPCs = createMenuToggle(CTLPresets, "RUDE | Speedy Strong Crowding NPCs | A Horde That Throws Player Cars! Applied Settings - NPC Attraction Range = 160 - MaxNPCs = 55 - Brute Force / Strength = 10 - Downwards Gravity - Super Speed", false, function(on) 
			settings.SpeedyNPCsOn.isOn = on end)
		presetMenuToggles.BumperCars = createMenuToggle(CTLPresets, "FUNNY | Bumper Cars | Woah - Home Run! Player Cars Throw NPCs too? Applied Settings - NPC Attraction Range = 120 - MaxNPCs = 15 - Brute Force / Strength = 35 - Player Brute Force / Strength = 35 - Downwards Gravity - Super Speed - Jump Ability", false, function(on) 
			settings.BumperCarsOn.isOn = on end)
		presetMenuToggles.RabidHomingNPCs = createMenuToggle(CTLPresets, "UNFAIR | Rabid Homing NPCs | They won't stop lunging at me! Applied Settings - NPC Attraction Range = 120 - MaxNPCs = 55 - Brute Force / Strength = 3 - Proximity Homing - Downwards Gravity - Super Speed = 15,000", false, function(on) 
			settings.RabidHomingNPCsOn.isOn = on end)
		presetMenuToggles.DemonicNPCs = createMenuToggle(CTLPresets, "IMPOSSIBLE | Demonic Cars | Okay guys, who cursed the NPCs? Applied Settings - NPC Attraction Range = 460 - MaxNPCs = 126 - Brute Force / Strength = 395 - Player Brute Force / Strength = 15 - Player Proximity Homing CHAOS MODE - Proximity Homing CHAOS MODE - EoC CHAOS MODE - Downwards Gravity CHAOS MODE - Super Speed - Invincibility - Jump Ability", false, function(on) 
			settings.DemonicNPCsOn.isOn = on end)
		presetMenuToggles.ExplosiveEMPNPCs = createMenuToggle(CTLPresets, "EMP | EXPLOSIVE TRAFFIC | Short Circuit! | Looks like the NPCs are going haywire again. Applied Settings - NPC Attraction Range = 120 - MaxNPCs = 20 - EoC - Downwards Gravity - Super Speed", false, function(on) 
			settings.ExplosiveNPCsOn.isOn = on end)
		presetMenuToggles.SpikeExplosiveNPCs = createMenuToggle(CTLPresets, "TIRE SPIKES! | EXPLOSIVE TRAFFIC | Tire Spike Explosion On Collision! Applied Settings - NPC Attraction Range = 180 - MaxNPCs = 55 - EoC - Downwards Gravity - Super Speed", false, function(on) 
			settings.SpikeExplosiveNPCsOn.isOn = on end)
		presetMenuToggles.RandomExplosiveNPCs = createMenuToggle(CTLPresets, "RANDOM CHAOS | EXPLOSIVE TRAFFIC | Each explosion is Randomized, and has a 50/50 chance of doing 0 damage to players! Applied Settings - NPC Attraction Range = 180 - MaxNPCs = 55 - EoC - Downwards Gravity - Super Speed", false, function(on) 
			settings.RandomExplosiveNPCsOn.isOn = on end)
		presetMenuToggles.AnnoyingExplosiveNPCs = createMenuToggle(CTLPresets, "ANNOYING | EXPLOSIVE TRAFFIC | Annoying Explosion On Collision! Applied Settings - NPC Attraction Range = 180 - MaxNPCs = 55 - EoC - Downwards Gravity - Super Speed", false, function(on) 
			settings.AnnoyingExplosiveNPCsOn.isOn = on end)
		presetMenuToggles.CarPunchingNPCsOn = createMenuToggle(CTLPresets, "FUNNY | BOOMERANG TRAFFIC | Get them off my car! Applied Settings - NPC Attraction Range = 90 - MaxNPCs = 15 - Downwards Gravity - Player Brute Force - Brute Force - ProximityHoming + Range = 100", false, function(on) 
			settings.CarPunchingNPCsOn.isOn = on end)

		util.create_thread(customTrafficLoop)

	local usingSynch = false
	local usingSync = false
	local helpText = translate("Trolling", "Attatch to player for better traffic / ped sync")
	menu.toggle(moreToolslist, translate("Trolling", "Attatch to player for better traffic / ped sync"), {}, helpText, function (on)
		usingSync = on
		if pId == players.user() then
			return
		end
		if usingSync then
			usingSynch = false
			local target = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
			STREAMING.REQUEST_ANIM_DICT("rcmpaparazzo_2")
			while not STREAMING.HAS_ANIM_DICT_LOADED("rcmpaparazzo_2") do
				util.yield_once()
			end
			TASK.TASK_PLAY_ANIM(players.user_ped(), "rcmpaparazzo_2", "shag_loop_a", 8.0, -8.0, -1, 1, 0.0, false, false, false)
			ENTITY.ATTACH_ENTITY_TO_ENTITY(players.user_ped(), target, 0, 0, -0.3, 0, 0.0, 0.0, 0.0, false, true, false, false, 0, true, 0)
			while usingSync and is_player_active(pId, false, true) and
			not util.is_session_transition_active() do
				util.yield_once()
			end
			usingSync = false
			TASK.CLEAR_PED_TASKS_IMMEDIATELY(players.user_ped())
			ENTITY.DETACH_ENTITY(players.user_ped(), true, false)
		end
	end)
end 

function onStopScript()
    despawnDeadPedsAndEmptyVehicles()
    clearNPCDrivers()
	deleteDestroyedVehicles()
end
players.on_join(ServerSide)
players.dispatch_on_join()
util.log("On join dispatched")