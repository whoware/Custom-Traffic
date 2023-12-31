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
        local playersReference
        menu.action(menu.my_root(), translate("Player", "• Take me to Custom Traffic •"), {}, "Select either YOURSELF or ANOTHER PLAYER from the > Players list!", function()
            playersReference = playersReference or menu.ref_by_path("Players")
            menu.trigger_command(playersReference, "")
        end)
	---@param pId Player
ServerSide = function(pId)
    menu.divider(menu.player_root(pId), "• Custom Traffic •")
    if not menu_already_added then 
        local helpText = translate("• Custom Traffic •", "Join the discord for updates / info / help / suggestions.")
        local menuName = translate("• Custom Traffic •", "• Join %s")
        menu.hyperlink(menu.my_root(), menuName:format("Whoware Discord •"), "https://discord.gg/S3GtdAq", helpText:format("komt"))
        menu_already_added = true
    end
	local function createMenuToggle(menuObj, optionName, default, toggleCallback)
		return menu.toggle(menuObj, translate(optionName, optionName), {}, default, toggleCallback)
	end
	local function createMenuSlider(menuObj, optionName, description, min, max, default, step, sliderCallback)
		return menu.slider(menuObj, translate(optionName, optionName), {}, description, min, max, default, step, sliderCallback)
	end
	local function calculate_distance(x1, y1, z1, x2, y2, z2)
		local distVars = {
			dx = x1 - x2,
			dy = y1 - y2,
			dz = z1 - z2
		}
		return math.sqrt(distVars.dx * distVars.dx + distVars.dy * distVars.dy + distVars.dz * distVars.dz)
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
			TextColor = {r = 1, g = 0.7, b = 0.4, a = 0.80},  
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
			x = 0.55, 
			y = 0.83  
		},
		npcJumpActivatedxy = {
			TextColor = {r = 1, g = 0.6, b = 0.2, a = 0.85},
			x = 0.55, 
			y = 0.85  
		},
		playerProximityHomingActivatedxy = {
			TextColor = {r = .5, g = 0.6, b = 0.2, a = 0.85},
			x = 0.57, 
			y = 0.87
		},
		proximityHomingActivatedxy = {
			TextColor = {r = .5, g = 0.6, b = 0.2, a = 0.85},
			x = 0.57, 
			y = 0.86 
		},
		explodeOnCollisionActivatedxy = {
			TextColor = {r = .1, g = .9, b = 5, a = 0.85}, 
			x = 0.53, 
			y = 0.88 
		},
		explodeOnCollision2Activatedxy = {
			TextColor = {r = .1, g = 1.1, b = 5, a = 0.85}, 
			x = 0.55, 
			y = 0.88 
		},
		explodeOnCollision3Activatedxy = {
			TextColor = {r = .3, g = 1.9, b = 5, a = 0.85}, 
			x = 0.57, 
			y = 0.88 
		},
		explodeOnCollision4Activatedxy = {
			TextColor = {r = .8, g = 2.4, b = 5, a = 0.85}, 
			x = 0.585, 
			y = 0.88 
		},
		playerbruteForceActivatedxy = {
			TextColor = {r = 0, g = 0.8, b = 0.2, a = 0.85}, 
			x = 0.55, 
			y = 0.89 
		},
		superhotActivatedxy = {
			TextColor = {r = 0.5, g = 0.5, b = 1, a = 0.85},
			x = 0.55, 
			y = 0.90 
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
	local settings = {
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
		},
		GamerModeOn = {
			isOn = false
		},
		ComboModeOn = {
			isOn = false
		},
		SmashBrawlOn = {
			isOn = false
		}
	}
	local ChaoticOpt <const> = menu.list(menu.player_root(pId), translate("Player", "• Ultimate Custom Traffic •"), {}, "Wait, it's important you understand this - Turning 'Custom Traffic' ON, enables NPCs to chase everyone in the lobby. So even if you stop spectating the person you applied Custom Traffic to, and spectate someone else, Custom Traffic will remain running as long as your target remains in the lobby! Super Power settings will also still work on Chaotic Vehicles, so long Custom Traffic is ENABLED and the player you put it on is PRESENT.")
	local WorldSpawns <const> = menu.list(menu.player_root(pId), translate("", "• World Object Spawns •"), {}, "Lobby-Wide Object Spawning. Spawn objects on every player in your lobby at once!")
	local customExplosions <const> = menu.list(menu.player_root(pId), translate("Ultimate Custom Traffic", "• Customize Explosions •"), {}, "Customize a grid of explosions around the player, and the type.")
	local ExtraTrollingOptions <const> = menu.list(menu.player_root(pId), translate("Trolling", "• Extra Trolling Options •"), {}, "Random shit that hasn't been fully fleshed out / is a stand-alone troll option that's separate from Custom Traffic functions, goes inside this folder.")

	--ws
	local RandomWorldSpawns = menu.list(WorldSpawns, translate("Ultimate Custom Traffic", "Random World Spawns"), {}, "")
	local SelectedWorldSpawns = menu.list(WorldSpawns, translate("Ultimate Custom Traffic", "Selective World Spawns"), {}, "")
	--sb
	local SmashBrawlContainer = {}
	SmashBrawlContainer.SmashBrawlFolder = menu.list(menu.player_root(pId), translate("Ultimate Custom Traffic", "• Smash Brawl Traffic •"), {}, "Custom Traffic on Steroids. NPC Drivers need to either touch or be in proximity of any player in order to aquire Hit Points -> with higher Hit Point values, grants more sophisticated NPCs powers, without you having to enable or disable anything.")
	SmashBrawlContainer.SmashBrawlUtilities = menu.list(SmashBrawlContainer.SmashBrawlFolder, translate("Ultimate Custom Traffic", "Smash Brawl Tools"), {}, "Customize the Hit Point system in realtime. | Tip: HPLoss is completely reset to 0 whenever a 3-Hit Combo event is triggered (3-hit Combos are when NPCDrivers touch a player vehicle 3 times within a .250ms window)")
	menu.toggle(SmashBrawlContainer.SmashBrawlFolder, "Player Vehicles Only", {}, "When enabled, NPC drivers target player-controlled vehicles instead of players.", function(state)
		PlayerVehiclesOnly = state
	end)
	SmashBrawlContainer.SmashBrawlHPLoss = menu.list(SmashBrawlContainer.SmashBrawlUtilities, translate("Ultimate Custom Traffic", "Control Hit Points"), {}, "Add or Subtract from HPLoss, which controls the rate at which Hit Points will lose value overtime. | Tip: HP Loss will only ever increase while Hit Points is a value above 0; otherwise HPLoss will remain frozen in its previous state waiting for Hit Points to again increase.")
	SmashBrawlContainer.SmashBrawlDecrement = menu.list(SmashBrawlContainer.SmashBrawlUtilities, translate("Ultimate Custom Traffic", "Control HP Loss"), {}, "Add or Subtract from Hit Points, which control what Power Stage NPCDrivers are in. | Tip: Hit Points are gained naturally when NPCDrivers are near players, are touching player vehicles, or while 'Super Hot' and 'EoC' are being triggered.")
	SmashBrawlContainer.SmashBrawlHitAdd = menu.list(SmashBrawlContainer.SmashBrawlHPLoss, translate("Ultimate Custom Traffic", "+ Hit Points"), {}, "Smash Brawl needs to be enabled for this to take effect.")
	SmashBrawlContainer.SmashBrawlHitSub = menu.list(SmashBrawlContainer.SmashBrawlHPLoss, translate("Ultimate Custom Traffic", "- Hit Points"), {}, "Smash Brawl needs to be enabled for this to take effect.")
	SmashBrawlContainer.SmashBrawlDecAdd = menu.list(SmashBrawlContainer.SmashBrawlDecrement, translate("Ultimate Custom Traffic", "+ HPLoss"), {}, "Smash Brawl needs to be enabled for this to take effect.")
	SmashBrawlContainer.SmashBrawlDecSub = menu.list(SmashBrawlContainer.SmashBrawlDecrement, translate("Ultimate Custom Traffic", "- HPLoss"), {}, "Smash Brawl needs to be enabled for this to take effect.")



		local function create_Chaotic_vehicle(targetId, vehicleHash, pedHash)
			if isDebugOn then
				util.toast("create_Chaotic_vehicle activated.")
			end
			local chaoticVars = {
				targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(targetId),
				pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(targetId), false),
				driver = 0,
				vehicle = nil,
				networkVehicleId = nil,
				offset = nil,
				outCoords = v3.new(),
				networkPedId = nil
			}
			request_model(vehicleHash)
			request_model(pedHash)
			chaoticVars.vehicle = entities.create_vehicle(vehicleHash, chaoticVars.pos, 0.0)
			chaoticVars.networkVehicleId = NETWORK.VEH_TO_NET(chaoticVars.vehicle)
			NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(chaoticVars.networkVehicleId, true)
			for i = 0, 50 do
				local numMods = VEHICLE.GET_NUM_VEHICLE_MODS(chaoticVars.vehicle, i)
				VEHICLE.SET_VEHICLE_MOD(chaoticVars.vehicle, i, numMods - 1, false)
			end
			chaoticVars.offset = get_random_offset_from_entity(chaoticVars.vehicle, math.random(150.0, 400.0), math.random(150.0, 400.0))
			if PATHFIND.GET_CLOSEST_VEHICLE_NODE(chaoticVars.offset.x, chaoticVars.offset.y, chaoticVars.offset.z, chaoticVars.outCoords, 1, 3.0, 0.0) then
				chaoticVars.driver = entities.create_ped(5, pedHash, chaoticVars.pos, 0.0)
				chaoticVars.networkPedId = NETWORK.PED_TO_NET(chaoticVars.driver)
				NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(chaoticVars.networkPedId, true)
				PED.SET_PED_INTO_VEHICLE(chaoticVars.driver, chaoticVars.vehicle, -1)
				ENTITY.SET_ENTITY_COORDS(chaoticVars.vehicle, chaoticVars.outCoords.x, chaoticVars.outCoords.y, chaoticVars.outCoords.z, false, false, false, true)
				set_entity_face_entity(chaoticVars.vehicle, chaoticVars.targetPed, false)
				VEHICLE.SET_VEHICLE_ENGINE_ON(chaoticVars.vehicle, true, true, true)
				VEHICLE.SET_VEHICLE_IS_CONSIDERED_BY_PLAYER(chaoticVars.vehicle, false)
				PED.SET_PED_COMBAT_ATTRIBUTES(chaoticVars.driver, 1, true)
				PED.SET_PED_COMBAT_ATTRIBUTES(chaoticVars.driver, 3, false)
				PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(chaoticVars.driver, true)
				TASK.TASK_VEHICLE_MISSION_PED_TARGET(chaoticVars.driver, chaoticVars.vehicle, chaoticVars.targetPed, 6, 500.0, 786988, 0.0, 0.0, true)
				PED.SET_PED_CAN_BE_KNOCKED_OFF_VEHICLE(chaoticVars.driver, 1)
				STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(pedHash)
				STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(vehicleHash)
				VEHICLE.SET_VEHICLE_ENGINE_HEALTH(chaoticVars.vehicle, 14000)
			end
			return chaoticVars.vehicle, chaoticVars.driver
		end		
local ChaoticVehicles <const> = menu.list(menu.player_root(pId), translate("Ultimate Custom Traffic", "• Chaotic Vehicles •"), {}, "This will spawn your choice of Peds and Vehicles to target players! Please note - you need to be spectating the player you want Chaotic Vehicles to target. (Spawned Chaotic Vehicles are operating separate from Custom Traffic! Additionally, Trollies are considered 'controlled / reaped', therefor when spawned, they automatically aquire user-enabled & configured super powers, whether Custom Traffic is enabled or not)")
local extraTraffic = menu.list(ChaoticVehicles, translate("Ultimate Custom Traffic", "Lobby-Wide Options •"), {}, "Options within this folder affect ALL players currently inside your session.")

local options <const> = {
	--ground vehicles
	"technical2", "bmx", "panto", "Dump", "slamvan6", 
	"blazer5", "faction3", "Monster4", "stingertt", "buffalo5", 
	"coureur", "Blazer", "rcbandito", "Barrage", 
	"Chernobog", "Ripley", "Zhaba", "Sandking", 
	"Cerberus", "Wastelander", "Chimera", "Veto", 
	"Pounder", "Biff", "Vetir", "Mule", 
	"rogue", "stunt", "mammatus", "avenger2", 
	"Cutter", "Phantom2", "Go-Kart", "AMBULANCE", 
	"Barracks", "rubble", "dominator",
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
	"retinue", "cyclone", "visione",
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
local ChaoticLoop = false
local ChaoticVehiclesConfig = {
    CVarsConfig = {  
        currentPedList = pedAnimals,
        spawnDelay = 5000,
        spawnDelayOnAll = 35000,
        setInvincible = false,
        makeVehiclesInvisible = false,
        makeDriversInvisible = false,
        spawnCount = 1,
        count = 0,
        ChaoticVehiclesTable = {},
        ChaoticVehicleTypesCount = {} 
    }
}
local function remove_Chaotic_vehicle(vehicle)
	if isDebugOn then
		util.toast("remove_Chaotic_vehicle activated.")
	end
	local vehicleType = ChaoticVehiclesConfig.CVarsConfig.ChaoticVehiclesTable[vehicle].type
	ChaoticVehiclesConfig.CVarsConfig.ChaoticVehiclesTable[vehicle] = nil
	if ChaoticVehiclesConfig.CVarsConfig.ChaoticVehicleTypesCount[vehicleType] then
		ChaoticVehiclesConfig.CVarsConfig.ChaoticVehicleTypesCount[vehicleType] = ChaoticVehiclesConfig.CVarsConfig.ChaoticVehicleTypesCount[vehicleType] - 1
		if ChaoticVehiclesConfig.CVarsConfig.ChaoticVehicleTypesCount[vehicleType] == 0 then
			ChaoticVehiclesConfig.CVarsConfig.ChaoticVehicleTypesCount[vehicleType] = nil
		end
	end
	scriptFns.updateNpcDriversCount()
end
local function updateChaoticVehicleTypesCount()
	if isDebugOn then
		util.toast("updateChaoticVehicleTypesCount activated.")
	end
	scriptFns.updateNpcDriversCount()
	ChaoticVehiclesConfig.CVarsConfig.count = 0
	for vehicle, data in pairs(ChaoticVehiclesConfig.CVarsConfig.ChaoticVehiclesTable) do
		if ENTITY.IS_ENTITY_DEAD(data.driver) then
			remove_Chaotic_vehicle(vehicle)
		else
			ChaoticVehiclesConfig.CVarsConfig.count = ChaoticVehiclesConfig.CVarsConfig.count + 1
		end
	end
end

local function spawn_Chaotic_vehicle(option, pId, pedHash)
    if isDebugOn then
        util.toast("spawn_Chaotic_vehicle activated.")
    end
    local CVVars = {
        randomPedIndex = math.random(#ChaoticVehiclesConfig.CVarsConfig.currentPedList),
        pedHash = nil,
        vehicleHash = util.joaat(option),
        vehicle = nil,
        driver = nil,
        weaponHash = nil
    }
    CVVars.pedHash = util.joaat(ChaoticVehiclesConfig.CVarsConfig.currentPedList[CVVars.randomPedIndex])            
    CVVars.vehicle, CVVars.driver = create_Chaotic_vehicle(pId, CVVars.vehicleHash, CVVars.pedHash)
    ENTITY.SET_ENTITY_INVINCIBLE(CVVars.vehicle, ChaoticVehiclesConfig.CVarsConfig.setInvincible)
    ENTITY.SET_ENTITY_VISIBLE(CVVars.vehicle, not ChaoticVehiclesConfig.CVarsConfig.makeVehiclesInvisible, false)
    ENTITY.SET_ENTITY_VISIBLE(CVVars.driver, not ChaoticVehiclesConfig.CVarsConfig.makeDriversInvisible, false)
    ChaoticVehiclesConfig.CVarsConfig.ChaoticVehiclesTable[CVVars.vehicle] = { type = option, driver = CVVars.driver }
    if ChaoticVehiclesConfig.CVarsConfig.ChaoticVehicleTypesCount[option] then
        ChaoticVehiclesConfig.CVarsConfig.ChaoticVehicleTypesCount[option] = ChaoticVehiclesConfig.CVarsConfig.ChaoticVehicleTypesCount[option] + 1
    else
        ChaoticVehiclesConfig.CVarsConfig.ChaoticVehicleTypesCount[option] = 1
    end
    local randomBlipType = math.random(695, 1285)
    add_blip_for_entity(CVVars.vehicle, 1, randomBlipType)
end


local function spawnSelectedVehicle(opt, pId)
    if isDebugOn then
        util.toast("Send Chaotic Vehicle activated.")
    end
    local count = ChaoticVehiclesConfig.CVarsConfig.spawnCount
    util.toast(string.format('Fetching %d %s(s)...', count, opt))
    for i = 1, count do
        spawn_Chaotic_vehicle(opt, pId, nil)  -- Call the spawn function with the selected option
        util.yield(520)  -- Delay between spawns if needed
    end
    util.toast(string.format('%d %s(s) fetched!', count, opt))
end



local ChaoticLoop = menu.toggle(extraTraffic, translate("Trolling", "Persistent Random Vehicles on All Players"), {}, "Sends Random Vehicles for half of the active players in the lobby at intervals set by the 'On-All Spawn Delay', adding an element of surprise to the gameplay.", function()
    if isDebugOn then
        util.toast("Persistent Random Chaotic Vehicles activated.")
    end
    local activePlayers = {}
    for pId = 0, 31 do
        if PLAYER.IS_PLAYER_PLAYING(pId) then
            table.insert(activePlayers, pId)
        end
    end
    local selectedPlayers = {}
    local halfCount = math.ceil(#activePlayers / math.random(2, 4))
    while #selectedPlayers < halfCount do
        local randomIndex = math.random(#activePlayers)
        table.insert(selectedPlayers, table.remove(activePlayers, randomIndex))
    end
    local numberOfVehiclesPerPlayer = 1
    for _, pId in ipairs(selectedPlayers) do
        local playerName = PLAYER.GET_PLAYER_NAME(pId)
        for i = 1, numberOfVehiclesPerPlayer do
            local CVRVars = {
                randomVehicleIndex = math.random(#options),
                randomPedIndex = math.random(#ChaoticVehiclesConfig.CVarsConfig.currentPedList),
                pedHash = util.joaat(ChaoticVehiclesConfig.CVarsConfig.currentPedList[math.random(#ChaoticVehiclesConfig.CVarsConfig.currentPedList)]),
                randomVehicle = options[math.random(#options)]
            }
            spawn_Chaotic_vehicle(CVRVars.randomVehicle, pId, CVRVars.pedHash)
            util.toast(string.format('Fetching %s for %s', CVRVars.randomVehicle, playerName, pId))
            util.yield(60)
        end
    end
    util.yield(ChaoticVehiclesConfig.CVarsConfig.spawnDelayOnAll)
end)
local OnAllspawnDelaySlider = createMenuSlider(extraTraffic, "On-All Spawn Delay • >", "Modify the delay between Chaotic vehicle spawns in seconds(1000ms).", 20000, 60000, 35000, 5000, function(value)
    if isDebugOn then
        util.toast("spawnDelaySlider Onall activated.")
    end
    ChaoticVehiclesConfig.CVarsConfig.spawnDelayOnAll = value 
end)
menu.action(extraTraffic, translate("Trolling", "Send 9 Random Chaotic Vehicle To All Players"), {}, "WARNING - THIS CANNOT BE SPAMMED OR YOU'RE GONNA CRASH YOURSELF | This option sends a group of random Chaotic vehicles on all players inside the lobby. Chaotic Vehicles will not despawn unless they are killed.", function()
    if isDebugOn then
        util.toast("spawnDelaySlider activated.")
    end
    local totalVehiclesSpawned = 0
    for pId = 0, 31 do 
        if PLAYER.IS_PLAYER_PLAYING(pId) then
            local playerName = PLAYER.GET_PLAYER_NAME(pId)
            for i = 1, 9 do
                local CVActionVars = {
                    randomVehicleIndex = math.random(#options),
                    randomVehicle = options[math.random(#options)],
                    randomPedIndex = math.random(#ChaoticVehiclesConfig.CVarsConfig.currentPedList),
                    pedHash = util.joaat(ChaoticVehiclesConfig.CVarsConfig.currentPedList[math.random(#ChaoticVehiclesConfig.CVarsConfig.currentPedList)])
                }
                util.toast(string.format('Fetching %s for %s...', CVActionVars.randomVehicle, playerName))
                spawn_Chaotic_vehicle(CVActionVars.randomVehicle, pId, CVActionVars.pedHash)
                totalVehiclesSpawned = totalVehiclesSpawned + 1
                util.yield(200)
            end
        end
    end
    util.toast(string.format('%d Random Chaotic Vehicles Fetched!', totalVehiclesSpawned))
end)
menu.action(extraTraffic, translate("Trolling", "Send 1 Random Chaotic Vehicle To All Players"), {}, "WARNING - THIS CANNOT BE SPAMMED OR YOU'RE GONNA CRASH YOURSELF | This option sends a group of random Chaotic vehicles on all players inside the lobby. Chaotic Vehicles will not despawn unless they are killed.", function()
    if isDebugOn then
        util.toast("spawnDelaySlider activated.")
    end
    local totalVehiclesSpawned = 0
    for pId = 0, 31 do 
        if PLAYER.IS_PLAYER_PLAYING(pId) then
            local playerName = PLAYER.GET_PLAYER_NAME(pId)
            for i = 1, 1 do
                local CVActionVars = {
                    randomVehicleIndex = math.random(#options),
                    randomVehicle = options[math.random(#options)],
                    randomPedIndex = math.random(#ChaoticVehiclesConfig.CVarsConfig.currentPedList),
                    pedHash = util.joaat(ChaoticVehiclesConfig.CVarsConfig.currentPedList[math.random(#ChaoticVehiclesConfig.CVarsConfig.currentPedList)])
                }
                util.toast(string.format('Fetching %s for %s...', CVActionVars.randomVehicle, playerName))
                spawn_Chaotic_vehicle(CVActionVars.randomVehicle, pId, CVActionVars.pedHash)
                totalVehiclesSpawned = totalVehiclesSpawned + 1
                util.yield(40)
            end
        end
    end
    util.toast(string.format('%d Random Chaotic Vehicles Fetched!', totalVehiclesSpawned))
end)
WorldClear = menu.action(extraTraffic, "[{World Clear}]", {}, "Performs a clearing action by temporarily freezing the GTA Client for .7 seconds, spamming 10 delete functions, then unfreezing the client - in order to maximize entities cleared.", function()
	local WCVars = { 
		start = os.clock(), 
		interval = .7,
		deletedentities = 0,
		RAC = memory.alloc(4) 
	}
	local allEntities = {}
	for _, ent in ipairs(entities.get_all_vehicles_as_handles()) do table.insert(allEntities, ent) end
	for _, ent in ipairs(entities.get_all_peds_as_handles()) do table.insert(allEntities, ent) end
	for _, ent in ipairs(entities.get_all_objects_as_handles()) do table.insert(allEntities, ent) end
	for _, ent in ipairs(allEntities) do
		if not PED.IS_PED_A_PLAYER(ent) then
			entities.delete(ent)
			WCVars.deletedentities = WCVars.deletedentities + 1
		end
	end
	for i = 0, 100 do
		memory.write_int(WCVars.RAC, i)
		if PHYSICS.DOES_ROPE_EXIST(WCVars.RAC) then
			PHYSICS.DELETE_ROPE(WCVars.RAC)
			WCVars.deletedentities = WCVars.deletedentities + 1
		end
	end
	repeat until os.clock() - WCVars.start >= WCVars.interval
	util.toast("World Clear Complete. Entities Cleared: " .. WCVars.deletedentities)
end)
local SpawnedVehicleAttributes = menu.list(ChaoticVehicles, translate("Ultimate Custom Traffic", "Spawned Vehicle Attributes"), {}, "Modify spawned vehicle attributes like invisibility, indestructible, etc.")
menu.slider(SpawnedVehicleAttributes, translate("Trolling", "Choose Ped Type"), {}, "Choose between Animals(0) or Humans(1). Please note, between these two categories, there is around 30+ different models contained within the tables. This is done to randomize the Model each spawn which increases the maximum allowed entities by bypassing stands object-spam detection. Previously 50 objects was the max, now you can reach 100-150 before the menu begins deletion.", 0, 1, 0, 1, function(val)
	if isDebugOn then
		util.toast("Choose Ped Type activated.")
	end
	if val == 0 then
		ChaoticVehiclesConfig.CVarsConfig.currentPedList = pedAnimals
	else
		ChaoticVehiclesConfig.CVarsConfig.currentPedList = pedModels
	end
end)
local spawnDelaySlider = createMenuSlider(SpawnedVehicleAttributes, "Spawn Delay • >", "Modify the delay between Chaotic vehicle spawns in seconds(1000ms).", 1000, 60000, 5000, 1000, function(value) 
	if isDebugOn then
		util.toast("spawnDelaySlider activated.")
	end
	ChaoticVehiclesConfig.CVarsConfig.spawnDelay = value 
end)
menu.toggle(SpawnedVehicleAttributes, translate("Trolling - Chaotic Vehicles", "Make Chaotic Vehicles Indestructible"), {}, "Toggle to make spawned Chaotic Vehicles Indestructible",
function(toggle) ChaoticVehiclesConfig.CVarsConfig.setInvincible = toggle end)
menu.toggle(SpawnedVehicleAttributes, "Make Chaotic Vehicles Invisible", {}, "Toggle to make spawned vehicles invisible.", function(value)
    ChaoticVehiclesConfig.CVarsConfig.makeVehiclesInvisible = value
    if isDebugOn then
        util.toast("Make Vehicles Invisible setting is now " .. tostring(value))
    end
end)
menu.toggle(SpawnedVehicleAttributes, "Make Drivers Invisible", {}, "Toggle to make only the drivers of spawned vehicles invisible.", function(value)
    ChaoticVehiclesConfig.CVarsConfig.makeDriversInvisible = value
    if isDebugOn then
        util.toast("Make Drivers Invisible setting is now " .. tostring(value))
    end
end)
local chaoticVehiclesMenu = menu.list(ChaoticVehicles, translate("Trolling", "Send Chaotic Vehicle"), {}, "")
for _, vehicleOption in ipairs(options) do
    menu.action(chaoticVehiclesMenu, vehicleOption, {}, "", function()
        spawnSelectedVehicle(vehicleOption, pId)
    end)
end



menu.slider(ChaoticVehicles, translate("Trolling - Chaotic Vehicles", "Amount?"), {}, "How many Chaotic Vehicles per selection?",
1, 99, 1, 1, function(value) ChaoticVehiclesConfig.CVarsConfig.spawnCount = value end)




menu.action(ChaoticVehicles, translate("Trolling", "Send Random Chaotic Vehicle"), {}, "This option sends a random vehicle from the Chaotic vehicle options. Chaotic Vehicles will not despawn unless if by force or they are killed.", function()
    if isDebugOn then
        util.toast("spawnDelaySlider activated.")
    end
    local CVActionVars = {
        i = 0,
        randomVehicleIndex = math.random(#options),
        randomVehicle = nil,
        randomPedIndex = math.random(#ChaoticVehiclesConfig.CVarsConfig.currentPedList),
        pedHash = nil
    }
    CVActionVars.randomVehicle = options[CVActionVars.randomVehicleIndex]
    CVActionVars.pedHash = util.joaat(ChaoticVehiclesConfig.CVarsConfig.currentPedList[CVActionVars.randomPedIndex])
    util.toast(string.format('Fetching %d %s(s) every %d ms...', ChaoticVehiclesConfig.CVarsConfig.spawnCount, CVActionVars.randomVehicle, 520)) 
    repeat
        spawn_Chaotic_vehicle(CVActionVars.randomVehicle, pId, CVActionVars.pedHash)
        CVActionVars.i = CVActionVars.i + 1
        util.yield(520)
    until CVActionVars.i == ChaoticVehiclesConfig.CVarsConfig.spawnCount  
    util.toast(string.format('%d %s Fetched!', ChaoticVehiclesConfig.CVarsConfig.spawnCount, CVActionVars.randomVehicle)) 
end)
menu.toggle_loop(ChaoticVehicles, translate("Trolling", "Persistant Random Vehicles on Spectated"), {}, "Sends a random Chaotic Vehicle that will only target the spectated player every 5000ms", function()
    if isDebugOn then
        util.toast("Persistant Random Chaotic Vehicles activated.")
    end
    local CVRVars = {
        randomVehicleIndex = math.random(#options),
        randomPedIndex = math.random(#ChaoticVehiclesConfig.CVarsConfig.currentPedList),
        pedHash = nil,
        randomVehicle = nil
    }
    CVRVars.randomVehicle = options[CVRVars.randomVehicleIndex]
    CVRVars.pedHash = util.joaat(ChaoticVehiclesConfig.CVarsConfig.currentPedList[CVRVars.randomPedIndex])
    util.toast(string.format('Fetching %s(s) every %d ms...', CVRVars.randomVehicle, ChaoticVehiclesConfig.CVarsConfig.spawnDelay))
    spawn_Chaotic_vehicle(CVRVars.randomVehicle, pId, CVRVars.pedHash)
    util.toast(string.format('%s Fetched!', CVRVars.randomVehicle))
    util.yield(ChaoticVehiclesConfig.CVarsConfig.spawnDelay)
end)
WorldClear = menu.action(ChaoticVehicles, "[{World Clear}]", {}, "Performs a clearing action by temporarily freezing the GTA Client for .7 seconds, spamming 10 delete functions, then unfreezing the client - in order to maximize entities cleared.", function()
	local WCVars = { 
		start = os.clock(), 
		interval = .7,
		deletedentities = 0,
		RAC = memory.alloc(4) 
	}
	local allEntities = {}
	for _, ent in ipairs(entities.get_all_vehicles_as_handles()) do table.insert(allEntities, ent) end
	for _, ent in ipairs(entities.get_all_peds_as_handles()) do table.insert(allEntities, ent) end
	for _, ent in ipairs(entities.get_all_objects_as_handles()) do table.insert(allEntities, ent) end
	for _, ent in ipairs(allEntities) do
		if not PED.IS_PED_A_PLAYER(ent) then
			entities.delete(ent)
			WCVars.deletedentities = WCVars.deletedentities + 1
		end
	end
	for i = 0, 100 do
		memory.write_int(WCVars.RAC, i)
		if PHYSICS.DOES_ROPE_EXIST(WCVars.RAC) then
			PHYSICS.DELETE_ROPE(WCVars.RAC)
			WCVars.deletedentities = WCVars.deletedentities + 1
		end
	end
	repeat until os.clock() - WCVars.start >= WCVars.interval
	util.toast("World Clear Complete. Entities Cleared: " .. WCVars.deletedentities)
end)
	local CTLCustoms = menu.list(ChaoticOpt, translate("Trolling", "CTL Customs | Tools"), {}, "Warning - CTL | Custom Traffic On/Off needs to be enabled for any of the features within this folder to take effect! Modify raw Custom Traffic Functions in realtime, that of which all control the behavior of NPCs and the script while Custom Traffic is enabled.")
	local superPowersMenu = menu.list(CTLCustoms, translate("Ultimate Custom Traffic", "Add SuperPowers • >"), {}, "Warning - Custom Traffic On/Off needs to be enabled for these to take effect! Lets step it up a notch.")
	local CTLCustomsXT = menu.list(CTLCustoms, translate("Trolling", "CTL Customs Extras • >"), {}, "Less important functions are kept in here incase the user ever needs them.")

	--main ctl functions 
	local isCustomTrafficOn = false
	local callCount = 0
	local lastCallTime = os.time()
	local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
	local selectedPlayerId = {}
	local npcDrivers = {}
	local destroyedVehicles = {}
	local destroyedVehicleTime = 0
	local npcDriversCount = 25
	local maxNpcDrivers = 25
	local npcRange = 120
	local newDriverTime = 0
	local npcDriversCountPrev = 0 
	local targetedUsernames = {}
	local lastDisplayTime = os.time()
	local PlayerVehiclesOnly = false
	local lastVehicleDeletionTime = nil

	--conditions and indexes
	local explodeTypes = {65, 66, 9, 64, 59, 43, 21}
	local explodeTypes2 = {66, 65, 9, 64, 59, 43, 21}
	local explodeTypes3 = {64, 65, 9, 64, 59, 43, 21}
	local explodeTypes4 = {67, 65, 9, 64, 59, 43, 21}
	local blipTypes = {84, 3, 153, 146}
	local currentBlipType = 3  --good ones 84 / 3 / 153 / 146 /  

	--systemthrottle
	local lastTime = os.clock()
	local lastCheckTime = os.clock()

	--npcdriver hate conditions
	local targetPlayersInVehiclesOnly = false
	local targetPlayersOutsideVehiclesOnly = false

	local gravity_multiplier = 1

	local SuperPowersConfig = {
		playerProximityConfig = { 
			isPlayerProximityHomingOn = false, 
			push_timer = 10,
			push_cooldown = 0,
			push_force_multiplier = 1,
			push_threshold = 1,
			distance_threshold = 10,
			playerProximityHomingTime = 0
		},
		explodeOnCollisionConfig = {
			isExplodeOnCollisionOn = false,
			explosionDistance = 4,
			explosionType = 65,
			explosionDamage = 1,
			explodeOnCollisionTime = 0,
			explodeOnCollisionCounter = 0,
			explodeOnCollisionCheckFrequency = 20
		},
		audioSpamConfig = {
			isAudioSpamOn = false, 
			audioSpamTriggerDistance = 30.350,
			audioSpamType = 21, 
			audioSpamDamage = 0,
			audioSpamInvisible = true,
			audioSpamAudible = true 
		},
		audioSpamConfig2 = {
			IsAudioSpam2On = false,
			AP2TriggerDistance = 30.350,
			AP2audioType = 58,
			AP2audioDamage = 0,
			AP2audioInvisible = true,
			AP2spamAudible = true
		},
		ConditionsConfig = {
			onlyInVehiclesPH = false,
			onlyInVehiclesEoC = false, 
			onlyInVehiclesAP = false,
			onlyInVehiclesBF = true,
			onlyInVehiclesJump = false
		},
		JumpCoreConfig = {
			lastJump = newTimer(),
			isJumpCooldownOn = false,
			dynamic_force_multiplier_value = 33,
			constant_multiplier_value = 94,
			player_speed_divisor_value = 33,
			jump_cooldown_value = 650,
			npcJumpTime = 0
		},
		PlayerBruteForceConfig = {
			isPlayerBruteForceOn = false,
			playerBruteForce_push_timer = 0.6,
			playerBruteForce_push_cooldown = 0,
			playerBruteForce_push_threshold = 20.0,
			playerBruteForce_push_force_multiplier = 15,
			playerbruteForceTime = 0
		},
		BruteForceConfig = {
			isBruteForceOn = false,
			hit_counter_reset = false,
			recent_hits_times = {},
			toast_queue = {},
			isBruteForceRapidAddOn = false,
			isBruteForceRapidSubtractOn = false,
			isIncrementDecrementValueOn = false,
			isDecrementDecrementValueOn = false,
			last_decrement_adjust_time = os.clock(),
			last_rapid_add_time = os.clock(),
			last_hit_time = os.clock(),
			HitcountStabalizer = 0.001,
			rapid_hit_threshold = 3,
			rapid_hit_bonus = 7.3,
			rapid_hit_time_window = 1,
			total_rapid_combo_triggers = 0,
			hit_counter = 0,
			hit_counter_trigger_count = 0,
			last_toast_time = 0,
			toast_interval = 2.7,
			last_toast_display_time = 0,
			decrement_value = 0,
			last_decrement_time = 0,
			decrement_tracker = 0,
			Max_Hit_Counter = 1900,
			bruteForceCounter = 0,
			bruteForceCheckFrequency = 7,
			push_timer = 10,
			push_cooldown = 0,
			push_threshold = 20.0,
			push_force_multiplier = 1,
			max_push_force_multiplier = 6,
			bruteForceTime = 0
		},
		OGBruteForceConfig = {
			isOGBruteForceOn = false,
			OGBFpush_timer = 10,
			OGBFpush_cooldown = 0,
			OGBFpush_threshold = 20.0, 
			OGBFpush_force_multiplier = 10
		},
		ProximityHomingConfig = {
			isProximityHomingOn = false,
			proximity_push_timer = 0,
			proximity_push_cooldown = 85,
			proximity_push_threshold = 3,
			proximity_push_force_multiplier = 1,
			proximity_distance_threshold = 10.1,
			proximityHomingTime = 0
		},
		DWGravityConfig = {
			isDownwardsGravityOn = false,
			downwards_force = -.445 * gravity_multiplier
		},
		SuperHotConfig = {
			isSuperHotOn = false,
			SHproximity_push_timer = 0,
			SHproximity_push_cooldown = 85,
			SHproximity_push_threshold = 3,
			SHproximityHomingTime = 0
		},
		SuperSpeedConfig = {
			isSuperSpeedOn = false,
			speedMultiplier = 1
		},
		InvincibilityAndMissionEntityConfig = {
			isInvincibilityAndMissionEntityOn = false
		},
		explodeOnCollisionConfig2 = {
			isExplodeOnCollisionOn2 = false,
			explosionDistance2 = 4,
			explosionType2 = 66, --26 vehicle KO, 38 fire, 
			explosionDamage = 1,
			explodeOnCollision2Time = 0,
			explodeOnCollisionCounter = 0,
			explodeOnCollisionCheckFrequency = 20
		},
		explodeOnCollisionConfig3 = {
			isExplodeOnCollisionOn3 = false,
			explosionDistance3 = 7,
			explosionType3 = 64,
			explosionDamage3 = 1,
			explodeOnCollision3Time = 0,
			explodeOnCollisionCounter3 = 0,
			explodeOnCollisionCheckFrequency3 = 20
		},
		explodeOnCollisionConfig4 = {
			isExplodeOnCollisionOn4 = false,
			explosionDistance4 = 7,
			explosionType4 = 67,
			explosionDamage4 = 1,
			explodeOnCollision4Time = 0,
			explodeOnCollisionCounter4 = 0,
			explodeOnCollisionCheckFrequency4 = 30
		}
	}
	local CountTextUI = {
		DR_TXT_SCALE = {
			textScale = 0.6
		},
		DR2_TXT_SCALE = {
			textScale = 0.32
		},
	}
	local PresetUI = {
		PRESET_SCALE = {
			textScale = 0.4
		},
		DEMONIC_SCALE = {
			textScale = 0.45
		}
	}
	local DriverCount_textProperties = {
		color = {
			r = 0,
			g = 0,
			b = 0,
			a = 0.70
		},
		position = {
			x = 0.55,
			y = 0.80
		}
	}
	local function ChaoticVehicleLoop(enabled)
		menu.set_value(ChaoticLoop, enabled)
	end
	scriptFunctions = {}
	local function scriptFunctions()
		local functions = {}
		functions.onSliderValueChanged = function(newMaxNpcDrivers)
			if isDebugOn then
				util.toast("onSliderValueChanged activated.")
			end
			maxNpcDrivers = newMaxNpcDrivers
			SPscriptFns.removeExcessNPCDrivers()
		end
		functions.is_colliding = function(entity1, entity2)
			if isDebugOn then
				util.toast("is_colliding activated.")
			end
			return ENTITY.IS_ENTITY_TOUCHING_ENTITY(entity1, entity2)
		end
		functions.is_player_in_tough_spot = function(player)
			if isDebugOn then
				util.toast("is_player_in_tough_spot activated.")
			end
			local playerCoords = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player), false)
			return playerCoords.z > 0.5
		end
		functions.distance_2d = function(a, b)
			if isDebugOn then
				util.toast("distance_2d activated.")
			end
			return math.sqrt((b.x - a.x) ^ 2 + (b.y - a.y) ^ 2)
		end
		functions.calculate_attraction_force = function(distance)
			if isDebugOn then
				util.toast("calculate_attraction_force activated.")
			end
			return 2 ^ distance
		end
		functions.deleteDestroyedVehicles = function()
			if isDebugOn then
				util.toast("deleteDestroyedVehicles was called or is currently active.")
			end
			if isManualDebugOn then
				util.toast("deleteDestroyedVehicles1 activated")
			end
			for _, vehicle in ipairs(entities.get_all_vehicles_as_handles()) do
				if VEHICLE.IS_VEHICLE_DRIVEABLE(vehicle, false) == false or ENTITY.IS_ENTITY_DEAD(vehicle) then
					local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1)
					if not PED.IS_PED_A_PLAYER(driver) then
						entities.delete(vehicle)
						destroyedVehicleTime = os.clock()
					end
				end
			end
		end
		functions.handleDestroyedNpcDriver = function(driver)
			if isDebugOn then
				util.toast("handleDestroyedNpcDriver activated")
			end
			if isManualDebugOn then
				util.toast("handleDestroyedNpcDriver2 activated")
			end
			local HNDvars = {
				exists = ENTITY.DOES_ENTITY_EXIST(driver),
				targetPed = nil,
				playerVehicle = nil
			}
			if HNDvars.exists then
				HNDvars.targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID())
				HNDvars.playerVehicle = PED.GET_VEHICLE_PED_IS_IN(HNDvars.targetPed, false)
			end
		end
		functions.handleVehicleDestroyed = function(driver, vehicle)
			if not ENTITY.DOES_ENTITY_EXIST(vehicle) or not VEHICLE.IS_VEHICLE_DRIVEABLE(vehicle, false) or ENTITY.IS_ENTITY_DEAD(vehicle) then
				if isDebugOn then
					util.toast("handleVehicleDestroyed activated")
				end
				if isManualDebugOn then
					util.toast("handleVehicleDestroyed3 activated")
				end
				functions.handleDestroyedNpcDriver(driver)
				npcDrivers[driver] = nil
				destroyedVehicleTime = os.clock()
				destroyedDriverTime = os.clock()
			end
		end
		functions.clearNPCDrivers = function()
			if isDebugOn then
				util.toast("clearNPCDrivers was called or is currently active.")
			end
			if isManualDebugOn then
				util.toast("clearNPCDrivers4 activated")
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
		functions.despawnDeadPeds = function() 
			local currentTime = os.clock()
			if currentTime - lastCheckTime >= 6.0 then
				for _, ped in ipairs(entities.get_all_peds_as_handles()) do
					if ENTITY.IS_ENTITY_DEAD(ped) and not PED.IS_PED_A_PLAYER(ped) then
						if not PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
							entities.delete(ped, pedAnimals)
						end
					end
				end
				lastCheckTime = currentTime
			end
		end
		functions.adjust_npc_trajectory = function(npc, targetPosition)
			if isDebugOn then
				util.toast("adjust_npc_trajectory activated.")
			end
			local ANJvars = {
				npcCoords = ENTITY.GET_ENTITY_COORDS(npc, false),
				dx = nil,
				dy = nil,
				dz = nil,
				distance = nil,
				verticalDistance = nil,
				desiredSpeed = nil,
				timeToReachTarget = nil,
				velocity = {x = nil, y = nil, z = nil},
				angle = nil
			}
			ANJvars.dx = targetPosition.x - ANJvars.npcCoords.x
			ANJvars.dy = targetPosition.y - ANJvars.npcCoords.y
			ANJvars.dz = targetPosition.z - ANJvars.npcCoords.z
			ANJvars.distance = math.sqrt(ANJvars.dx*ANJvars.dx + ANJvars.dy*ANJvars.dy + ANJvars.dz*ANJvars.dz)
			ANJvars.verticalDistance = math.abs(targetPosition.z - ANJvars.npcCoords.z)
			ANJvars.desiredSpeed = math.max(1, ANJvars.verticalDistance / 2)
			ANJvars.timeToReachTarget = ANJvars.distance / ANJvars.desiredSpeed
			ANJvars.velocity.x = ANJvars.dx / ANJvars.timeToReachTarget
			ANJvars.velocity.y = ANJvars.dy / ANJvars.timeToReachTarget
			ANJvars.velocity.z = ANJvars.dz / ANJvars.timeToReachTarget
			ENTITY.SET_ENTITY_VELOCITY(npc, ANJvars.velocity.x, ANJvars.velocity.y, ANJvars.velocity.z)
			ANJvars.angle = math.deg(math.atan2(ANJvars.dy, ANJvars.dx))
			ENTITY.SET_ENTITY_ROTATION(npc, 0, 0, ANJvars.angle)
		end
		functions.enqueueToast = function(message)
			table.insert(SuperPowersConfig.BruteForceConfig.toast_queue, message)
		end
		functions.hitsRequiredForStage = function(n)
			return math.floor(7 * n^2 + 7 * n)
		end
		functions.getStageFromHits = function(hit_count)
			local n = 0
			while functions.hitsRequiredForStage(n + 1) <= hit_count do
				n = n + 1
			end
			return n
		end
		functions.calculateHitBonusForStage = function(stage)
			return 11.35 * stage
		end
		functions.findIndex = function(tbl, value)
			for index, v in ipairs(tbl) do
				if v == value then
					return index
				end
			end
			return 1
		end
		functions.isAnyPresetActive = function()
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
				   settings.CarPunchingNPCsOn.isOn or
				   settings.GamerModeOn.isOn or
				   settings.ComboModeOn.isOn or
				   settings.SmashBrawlOn.isOn
		end
		functions.drawPreset = function(presetName, presetData)
			if isDebugOn then
				util.toast("drawPreset activated.")
			end
			directx.draw_text(presetData.x, presetData.y, presetName, 
			ALIGN_CENTRE, 
			PresetUI.PRESET_SCALE.textScale, presetData.TextColor, false)
		end
		functions.updateTargetPlayers = function()
			if isDebugOn then
				util.toast("updateTargetPlayers was called or is currently active. The heart of the script.")
			end
			local UPVars = {
				selectedPlayerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(selectedPlayerId),
				selectedPlayerCoords = nil,
				targetPed = nil,
				targetCoords = nil,
				distance = nil
			}
			UPVars.selectedPlayerCoords = ENTITY.GET_ENTITY_COORDS(UPVars.selectedPlayerPed, true)
			for pId = 0, 31 do
				UPVars.targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
				UPVars.targetCoords = ENTITY.GET_ENTITY_COORDS(UPVars.targetPed, true)
				UPVars.distance = calculate_distance(
					UPVars.selectedPlayerCoords.x, UPVars.selectedPlayerCoords.y, UPVars.selectedPlayerCoords.z,
					UPVars.targetCoords.x, UPVars.targetCoords.y, UPVars.targetCoords.z
				)
				if UPVars.distance <= npcRange then
					targetPlayers[pId] = true
				else
					targetPlayers[pId] = nil
				end
			end
		end
		functions.updateNpcDriversCount = function()--this function is responsible for keeping track of how many npc drivers are under control
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
		functions.should_npc_jump = function(driver, player)
			local SNJvars = {
				driverCoords = ENTITY.GET_ENTITY_COORDS(driver, false),
				playerCoords = ENTITY.GET_ENTITY_COORDS(player, false),
				playerVelocity = ENTITY.GET_ENTITY_VELOCITY(player)
			}
			SNJvars.preliminaryDistance = functions.distance_2d(SNJvars.driverCoords, SNJvars.playerCoords)
			SNJvars.prediction_time = 0.3
			SNJvars.predicted_position = calculate_future_position(SNJvars.playerCoords, SNJvars.playerVelocity, SNJvars.prediction_time)
			SNJvars.dx, SNJvars.dy, SNJvars.dz = SNJvars.predicted_position.x - SNJvars.driverCoords.x, SNJvars.predicted_position.y - SNJvars.driverCoords.y, SNJvars.predicted_position.z - SNJvars.driverCoords.z
			SNJvars.distanceXY = functions.distance_2d(SNJvars.driverCoords, SNJvars.predicted_position)
			SNJvars.distanceZ = math.abs(SNJvars.driverCoords.z - SNJvars.predicted_position.z)
			SNJvars.player_speed = vector_magnitude(SNJvars.playerVelocity.x, SNJvars.playerVelocity.y, SNJvars.playerVelocity.z)
			SNJvars.dynamic_force_multiplier = (SuperPowersConfig.JumpCoreConfig.dynamic_force_multiplier_value / 100) * ((SuperPowersConfig.JumpCoreConfig.constant_multiplier_value / 100) + SNJvars.player_speed / SuperPowersConfig.JumpCoreConfig.player_speed_divisor_value)
			SNJvars.max_height_difference = 3
			SNJvars.isDriverInAir = ENTITY.IS_ENTITY_IN_AIR(driver)
			SNJvars.vehicle = PED.GET_VEHICLE_PED_IS_IN(ped, false)
			SNJvars.vehicleSpeed = ENTITY.GET_ENTITY_SPEED(SNJvars.vehicle)
			SNJvars.speedMultiplier = 1 + SNJvars.vehicleSpeed / 50 
			SNJvars.isPlayerInAir = ENTITY.IS_ENTITY_IN_AIR(player)
			SNJvars.isGentleJump = SNJvars.driverCoords.z - SNJvars.playerCoords.z > SNJvars.max_height_difference
			SNJvars.jumpHeight = 9
			SNJvars.gentleJumpHeight = 6
			if isDebugOn then
				util.toast("NPCJump is currently scanning for ideal jump condition opportunities.")
			end
			if SuperPowersConfig.ConditionsConfig.onlyInVehiclesJump and not PED.IS_PED_IN_ANY_VEHICLE(targetPed, false) then
				return
			end
			for _, ped in ipairs(entities.get_all_peds_as_handles()) do
				if not PED.IS_PED_A_PLAYER(ped) then
					local npcDriverCoords = ENTITY.GET_ENTITY_COORDS(ped, false)
					if math.abs(npcDriverCoords.z - SNJvars.playerCoords.z) < 1.0 then
						return nil
					end
				end
			end
			SNJvars.preliminaryDistance = functions.distance_2d(SNJvars.driverCoords, SNJvars.playerCoords)
			if SNJvars.preliminaryDistance > 150 then
				return nil
			end
			SNJvars.predicted_position = calculate_future_position(SNJvars.playerCoords, SNJvars.playerVelocity, SNJvars.prediction_time)
			SNJvars.dx, SNJvars.dy, SNJvars.dz = SNJvars.predicted_position.x - SNJvars.driverCoords.x, SNJvars.predicted_position.y - SNJvars.driverCoords.y, SNJvars.predicted_position.z - SNJvars.driverCoords.z
			SNJvars.distanceXY = functions.distance_2d(SNJvars.driverCoords, SNJvars.predicted_position)
			SNJvars.distanceZ = math.abs(SNJvars.driverCoords.z - SNJvars.predicted_position.z)
			if SNJvars.isDriverInAir then
				SNJvars.max_height_difference = SNJvars.max_height_difference * 0.05
			end
			if SNJvars.isDriverInAir then
				SNJvars.max_height_difference = 3 
			end
			SNJvars.speedMultiplier = 1 + SNJvars.vehicleSpeed / 50 
			if SNJvars.isGentleJump then
				SNJvars.speedMultiplier = 1 
			end
			local forceZ = SNJvars.isGentleJump and SNJvars.gentleJumpHeight or SNJvars.jumpHeight
			if SNJvars.isPlayerInAir and SNJvars.isDriverInAir and SNJvars.driverCoords.z > SNJvars.playerCoords.z then
				forceZ = -forceZ * 0.75
			end
			SNJvars.force = {
				x = SNJvars.dx * SNJvars.dynamic_force_multiplier * SNJvars.speedMultiplier,
				y = SNJvars.dy * SNJvars.dynamic_force_multiplier * SNJvars.speedMultiplier,
				z = forceZ
			}
			if SNJvars.distanceXY < 100 and (SNJvars.distanceZ > 3 or SNJvars.driverCoords.z - SNJvars.playerCoords.z > SNJvars.max_height_difference) then 
				SuperPowersConfig.JumpCoreConfig.npcJumpTime = os.clock()
				return SNJvars.force
			else
				return nil
			end
		end
		
		functions.downwardsGravity = function(pId)
			if isDebugOn then
				util.toast("downwardsGravity was called.")
			end
			for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 50.0)) do
				if TASK.GET_ACTIVE_VEHICLE_MISSION_TYPE(vehicle) ~= 6 then
					local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
					if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
						request_control_once(driver)
					end
				end
			end
		end
		functions.applyDownwardForce = function(vehicle)
			if isDebugOn then
				util.toast("applyDownwardForce was called.")
			end
			if SuperPowersConfig.DWGravityConfig.isDownwardsGravityOn then
				local currentVelocity = ENTITY.GET_ENTITY_VELOCITY(vehicle)
				ENTITY.SET_ENTITY_VELOCITY(vehicle, currentVelocity.x, currentVelocity.y, currentVelocity.z + SuperPowersConfig.DWGravityConfig.downwards_force)
				ENTITY.SET_ENTITY_COLLISION(vehicle, true, true)
			end
		end
		
		functions.calculateDistance = function(coord1, coord2)
			if isDebugOn then
				util.toast("calculateDistance was called.")
			end
			local dx, dy, dz = coord2.x - coord1.x, coord2.y - coord1.y, coord2.z - coord1.z
			return math.sqrt(dx*dx + dy*dy + dz*dz)
		end
		functions.calculateForce = function(coord1, coord2)
			if isDebugOn then
				util.toast("calculateForce was called.")
			end
			local dx, dy, dz = coord2.x - coord1.x, coord2.y - coord1.y, coord2.z - coord1.z
			return {x = dx * SuperPowersConfig.ProximityHomingConfig.proximity_push_force_multiplier, y = dy * SuperPowersConfig.ProximityHomingConfig.proximity_push_force_multiplier, z = dz * SuperPowersConfig.ProximityHomingConfig.proximity_push_force_multiplier}
		end
		functions.getPlayerSpeedMPH = function(pId)
			local PSvars = {
				ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId),
				vehicle = nil,
				speedMS = nil,
				speedMPH = nil
			}
			if PED.IS_PED_IN_ANY_VEHICLE(PSvars.ped, false) then
				PSvars.vehicle = PED.GET_VEHICLE_PED_IS_IN(PSvars.ped, false)
				PSvars.speedMS = ENTITY.GET_ENTITY_SPEED(PSvars.vehicle)
			else
				PSvars.speedMS = ENTITY.GET_ENTITY_SPEED(PSvars.ped)
			end
			PSvars.speedMPH = PSvars.speedMS * 2.23694
			return PSvars.speedMPH
		end
		functions.getPlayerVelocity = function(pId)
			local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
			return ENTITY.GET_ENTITY_VELOCITY(ped)
		end
		functions.predictPlayerPosition = function(targetPedCoords, playerVelocity, predictionFactor)
			local PPPvars = {
				predicted = {x = nil, y = nil, z = nil},
				velocity = playerVelocity
			}
			PPPvars.predicted.x = targetPedCoords.x + (PPPvars.velocity.x * predictionFactor)
			PPPvars.predicted.y = targetPedCoords.y + (PPPvars.velocity.y * predictionFactor)
			PPPvars.predicted.z = targetPedCoords.z + (PPPvars.velocity.z * predictionFactor)
			return PPPvars.predicted
		end
		functions.setNPCDriverSpeed = function(vehicle, desiredSpeedMPH)
			local speedMS = desiredSpeedMPH / 2.23694
			VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle, speedMS)
		end
		functions.calculateDirectionalForce = function(fromPosition, toPosition)
			local force = {
				x = toPosition.x - fromPosition.x,
				y = toPosition.y - fromPosition.y,
				z = toPosition.z - fromPosition.z
			}
			return force
		end
		functions.getVehicleDirection = function(vehicle)
			local VDvars = {
				velocity = ENTITY.GET_ENTITY_VELOCITY(vehicle),
				magnitude = nil,
				direction = {x = nil, y = nil, z = nil}
			}
			VDvars.magnitude = math.sqrt(VDvars.velocity.x^2 + VDvars.velocity.y^2 + VDvars.velocity.z^2)
			VDvars.direction.x = VDvars.velocity.x / VDvars.magnitude
			VDvars.direction.y = VDvars.velocity.y / VDvars.magnitude
			VDvars.direction.z = VDvars.velocity.z / VDvars.magnitude
			return VDvars.direction
		end
		functions.dotProduct = function(v1, v2)
			return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
		end
		return functions
	end
	local scriptFns = scriptFunctions()
		local defaultExplodeIndex = scriptFns.findIndex(explodeTypes, 65)
		local defaultExplodeIndex2 = scriptFns.findIndex(explodeTypes2, 66)
		local defaultExplodeIndex3 = scriptFns.findIndex(explodeTypes3, 64)
		local defaultExplodeIndex4 = scriptFns.findIndex(explodeTypes4, 67)
		local defaultBlipIndex = scriptFns.findIndex(blipTypes, 3)
		SuperPowersFuncList = {}
		local function SuperPowersFuncList()
			local functionSP = {}

		functionSP.explodeOnCollisionEffect = function(pId)
			if isDebugOn then
				util.toast("ExplodeOnCollision detected scanning for active nearby players.")
			end
			local EoCvars = {
				targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId),
				playerVehicle = nil,
				vehicleCoords = nil,
				targetCoords = nil,
				distance_to_player = nil,
				explosionCoords = nil
			}
			EoCvars.playerVehicle = PED.GET_VEHICLE_PED_IS_IN(EoCvars.targetPed, false)
			if PlayerVehiclesOnly and EoCvars.playerVehicle ~= 0 then
				EoCvars.targetCoords = ENTITY.GET_ENTITY_COORDS(EoCvars.playerVehicle, true)
			else
				EoCvars.targetCoords = ENTITY.GET_ENTITY_COORDS(EoCvars.targetPed, true)
			end
			if SuperPowersConfig.ConditionsConfig.onlyInVehiclesEoC and not PED.IS_PED_IN_ANY_VEHICLE(EoCvars.targetPed, false) then
				return
			end
			for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 25.0)) do
				local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
				if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
					EoCvars.vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
					EoCvars.distance_to_player = calculate_distance(EoCvars.vehicleCoords.x, EoCvars.vehicleCoords.y, EoCvars.vehicleCoords.z, EoCvars.targetCoords.x, EoCvars.targetCoords.y, EoCvars.targetCoords.z)
					if EoCvars.distance_to_player <= SuperPowersConfig.explodeOnCollisionConfig.explosionDistance then
						EoCvars.explosionCoords = EoCvars.vehicleCoords
						FIRE.ADD_EXPLOSION(EoCvars.explosionCoords.x, EoCvars.explosionCoords.y, EoCvars.explosionCoords.z, SuperPowersConfig.explodeOnCollisionConfig.explosionType, SuperPowersConfig.explodeOnCollisionConfig.explosionType, SuperPowersConfig.explodeOnCollisionConfig.explosionAudible, SuperPowersConfig.explodeOnCollisionConfig.explosionInvisible, 0)
						SuperPowersConfig.explodeOnCollisionConfig.explodeOnCollisionTime = os.clock()
					end
				end
			end
		end
		functionSP.explodeOnCollisionEffect2 = function(pId)
			if isDebugOn then
				util.toast("ExplodeOnCollision2 detected scanning for active nearby players.")
			end
			local EoCvars2 = {
				targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId),
				playerVehicle = nil,
				vehicleCoords = nil,
				targetPedCoords = nil,
				distance_to_player = nil,
				explosionCoords = nil
			}
			EoCvars2.playerVehicle = PED.GET_VEHICLE_PED_IS_IN(EoCvars2.targetPed, false)
			if SuperPowersConfig.ConditionsConfig.onlyInVehiclesEoC and not PED.IS_PED_IN_ANY_VEHICLE(EoCvars2.targetPed, false) then
				return
			end
			for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 25.0)) do
				local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
				if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
					EoCvars2.vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
					EoCvars2.targetPedCoords = ENTITY.GET_ENTITY_COORDS(EoCvars2.targetPed, true)
					EoCvars2.distance_to_player = calculate_distance(EoCvars2.vehicleCoords.x, EoCvars2.vehicleCoords.y, EoCvars2.vehicleCoords.z, EoCvars2.targetPedCoords.x, EoCvars2.targetPedCoords.y, EoCvars2.targetPedCoords.z)
					if EoCvars2.distance_to_player <= SuperPowersConfig.explodeOnCollisionConfig2.explosionDistance2 then
						EoCvars2.explosionCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
						FIRE.ADD_EXPLOSION(EoCvars2.explosionCoords.x, EoCvars2.explosionCoords.y, EoCvars2.explosionCoords.z, SuperPowersConfig.explodeOnCollisionConfig2.explosionType2, SuperPowersConfig.explodeOnCollisionConfig2.explosionDamage, SuperPowersConfig.explodeOnCollisionConfig2.explosionAudible, SuperPowersConfig.explodeOnCollisionConfig2.explosionInvisible, 0)
						SuperPowersConfig.explodeOnCollisionConfig2.explodeOnCollision2Time = os.clock()
					end
				end
			end
		end
		functionSP.explodeOnCollisionEffect3 = function(pId)
			if isDebugOn then
				util.toast("ExplodeOnCollision3 detected scanning for active nearby players.")
			end
			local EoCvars3 = {
				targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId),
				playerVehicle = nil,
				vehicleCoords = nil,
				targetPedCoords = nil,
				distance_to_player = nil,
				explosionCoords = nil
			}
			EoCvars3.playerVehicle = PED.GET_VEHICLE_PED_IS_IN(EoCvars3.targetPed, false)
			if SuperPowersConfig.ConditionsConfig.onlyInVehiclesEoC and not PED.IS_PED_IN_ANY_VEHICLE(EoCvars3.targetPed, false) then
				return
			end
			for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 25.0)) do
				local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
				if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
					EoCvars3.vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
					EoCvars3.targetPedCoords = ENTITY.GET_ENTITY_COORDS(EoCvars3.targetPed, true)
					EoCvars3.distance_to_player = calculate_distance(EoCvars3.vehicleCoords.x, EoCvars3.vehicleCoords.y, EoCvars3.vehicleCoords.z, EoCvars3.targetPedCoords.x, EoCvars3.targetPedCoords.y, EoCvars3.targetPedCoords.z)
					if EoCvars3.distance_to_player <= SuperPowersConfig.explodeOnCollisionConfig3.explosionDistance3 then
						EoCvars3.explosionCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
						FIRE.ADD_EXPLOSION(EoCvars3.explosionCoords.x, EoCvars3.explosionCoords.y, EoCvars3.explosionCoords.z, SuperPowersConfig.explodeOnCollisionConfig3.explosionType3, SuperPowersConfig.explodeOnCollisionConfig3.explosionDamage3, SuperPowersConfig.explodeOnCollisionConfig3.explosionAudible, SuperPowersConfig.explodeOnCollisionConfig3.explosionInvisible, 0)
						SuperPowersConfig.explodeOnCollisionConfig3.explodeOnCollision3Time = os.clock()
					end
				end
			end
		end
		functionSP.explodeOnCollisionEffect4 = function(pId)
			if isDebugOn then
				util.toast("ExplodeOnCollision3 detected scanning for active nearby players.")
			end
			local EoCvars4 = {
				targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId),
				playerVehicle = nil,
				vehicleCoords = nil,
				targetPedCoords = nil,
				distance_to_player = nil,
				explosionCoords = nil
			}
		
			EoCvars4.playerVehicle = PED.GET_VEHICLE_PED_IS_IN(EoCvars4.targetPed, false)
			if SuperPowersConfig.ConditionsConfig.onlyInVehiclesEoC and not PED.IS_PED_IN_ANY_VEHICLE(EoCvars4.targetPed, false) then
				return
			end
		
			for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 25.0)) do
				local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
				if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
					EoCvars4.vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
					EoCvars4.targetPedCoords = ENTITY.GET_ENTITY_COORDS(EoCvars4.targetPed, true)
					EoCvars4.distance_to_player = calculate_distance(EoCvars4.vehicleCoords.x, EoCvars4.vehicleCoords.y, EoCvars4.vehicleCoords.z, EoCvars4.targetPedCoords.x, EoCvars4.targetPedCoords.y, EoCvars4.targetPedCoords.z)
					if EoCvars4.distance_to_player <= SuperPowersConfig.explodeOnCollisionConfig4.explosionDistance4 then
						EoCvars4.explosionCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
						FIRE.ADD_EXPLOSION(EoCvars4.explosionCoords.x, EoCvars4.explosionCoords.y, EoCvars4.explosionCoords.z, SuperPowersConfig.explodeOnCollisionConfig4.explosionType4, SuperPowersConfig.explodeOnCollisionConfig4.explosionDamage4, SuperPowersConfig.explodeOnCollisionConfig4.explosionAudible, SuperPowersConfig.explodeOnCollisionConfig4.explosionInvisible, 0)
						SuperPowersConfig.explodeOnCollisionConfig4.explodeOnCollision4Time = os.clock()
					end
				end
			end
		end
		functionSP.SmashBrawl = function(pId)
			if isDebugOn then
				util.toast("Bruteforce detected a collision or was activated for some reason.")
			end
			local BFvars = {
				targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId),
				playerVehicle = nil,
				isVehicleDrivenByNPC = false,
				vehicleCoords = nil,
				targetPedCoords = nil,
				distance_to_player = nil,
				dx = nil,
				dy = nil,
				dz = nil,
				force = nil,
				current_stage = nil
			}
			for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 20.0)) do
				BFvars.playerVehicle = PED.GET_VEHICLE_PED_IS_IN(BFvars.targetPed, false)
				for driver, drvVehicle in pairs(npcDrivers) do
					if drvVehicle == vehicle then
						BFvars.isVehicleDrivenByNPC = true
						break
					end
				end
				if BFvars.playerVehicle ~= 0 and vehicle ~= BFvars.playerVehicle and scriptFns.is_colliding(vehicle, BFvars.playerVehicle) and BFvars.isVehicleDrivenByNPC then
					BFvars.vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
					BFvars.targetPedCoords = ENTITY.GET_ENTITY_COORDS(BFvars.targetPed, true)
					BFvars.distance_to_player = calculate_distance(BFvars.vehicleCoords.x, BFvars.vehicleCoords.y, BFvars.vehicleCoords.z, BFvars.targetPedCoords.x, BFvars.targetPedCoords.y, BFvars.targetPedCoords.z)
					if SuperPowersConfig.BruteForceConfig.isBruteForceOn and BFvars.distance_to_player <= SuperPowersConfig.BruteForceConfig.push_threshold and current_ms() >= SuperPowersConfig.BruteForceConfig.push_timer then
						table.insert(SuperPowersConfig.BruteForceConfig.recent_hits_times, os.clock())
						for i, hit_time in ipairs(SuperPowersConfig.BruteForceConfig.recent_hits_times) do
							if os.clock() - hit_time > SuperPowersConfig.BruteForceConfig.rapid_hit_time_window then
								table.remove(SuperPowersConfig.BruteForceConfig.recent_hits_times, i)
							end
						end
						if SuperPowersConfig.BruteForceConfig.hit_counter > 0 then
							if #SuperPowersConfig.BruteForceConfig.recent_hits_times >= SuperPowersConfig.BruteForceConfig.rapid_hit_threshold then
								SuperPowersConfig.BruteForceConfig.hit_counter = SuperPowersConfig.BruteForceConfig.hit_counter + SuperPowersConfig.BruteForceConfig.rapid_hit_bonus
								SuperPowersConfig.BruteForceConfig.hit_counter = math.min(SuperPowersConfig.BruteForceConfig.hit_counter, SuperPowersConfig.BruteForceConfig.Max_Hit_Counter)
								SuperPowersConfig.BruteForceConfig.recent_hits_times = {}
								SuperPowersConfig.BruteForceConfig.decrement_value = 0 -- base decrement
								SuperPowersConfig.BruteForceConfig.total_rapid_combo_triggers = SuperPowersConfig.BruteForceConfig.total_rapid_combo_triggers + 1
							end
						end
						SuperPowersConfig.BruteForceConfig.hit_counter = SuperPowersConfig.BruteForceConfig.hit_counter + 6.37
						SuperPowersConfig.BruteForceConfig.hit_counter = math.min(SuperPowersConfig.BruteForceConfig.hit_counter, SuperPowersConfig.BruteForceConfig.Max_Hit_Counter)
						if SuperPowersConfig.BruteForceConfig.hit_counter > 0 then
							SuperPowersConfig.BruteForceConfig.hit_counter_trigger_count = SuperPowersConfig.BruteForceConfig.hit_counter_trigger_count + 1
						end
						if SuperPowersConfig.BruteForceConfig.hit_counter < 1 then
							SuperPowersConfig.BruteForceConfig.hit_counter_trigger_count = 0
						end
						if BruteForceComboCounter then
							BFvars.current_stage = scriptFns.getStageFromHits(SuperPowersConfig.BruteForceConfig.hit_counter)
							local rapid_hit_bonus = scriptFns.calculateHitBonusForStage(BFvars.current_stage)
							if BFvars.current_stage == 0 then
								SuperPowersConfig.BruteForceConfig.push_force_multiplier = 0.05 * SuperPowersConfig.BruteForceConfig.max_push_force_multiplier
							elseif BFvars.current_stage == 1 then
								SuperPowersConfig.BruteForceConfig.push_force_multiplier = 0.1 * SuperPowersConfig.BruteForceConfig.max_push_force_multiplier
							elseif BFvars.current_stage == 2 then
								SuperPowersConfig.BruteForceConfig.push_force_multiplier = 0.15 * SuperPowersConfig.BruteForceConfig.max_push_force_multiplier
							elseif BFvars.current_stage == 3 then
								SuperPowersConfig.BruteForceConfig.push_force_multiplier = 0.2 * SuperPowersConfig.BruteForceConfig.max_push_force_multiplier
							elseif BFvars.current_stage == 4 then
								SuperPowersConfig.BruteForceConfig.push_force_multiplier = 0.35 * SuperPowersConfig.BruteForceConfig.max_push_force_multiplier
							elseif BFvars.current_stage == 5 then
								SuperPowersConfig.BruteForceConfig.push_force_multiplier = 0.5 * SuperPowersConfig.BruteForceConfig.max_push_force_multiplier
							elseif BFvars.current_stage == 6 then
								SuperPowersConfig.BruteForceConfig.push_force_multiplier = 1.0 * SuperPowersConfig.BruteForceConfig.max_push_force_multiplier
							elseif BFvars.current_stage == 7 then
								SuperPowersConfig.BruteForceConfig.push_force_multiplier = 1.5 * SuperPowersConfig.BruteForceConfig.max_push_force_multiplier
							elseif BFvars.current_stage == 8 then
								SuperPowersConfig.BruteForceConfig.push_force_multiplier = 2.0 * SuperPowersConfig.BruteForceConfig.max_push_force_multiplier
							elseif BFvars.current_stage == 9 then
								SuperPowersConfig.BruteForceConfig.push_force_multiplier = 3.5 * SuperPowersConfig.BruteForceConfig.max_push_force_multiplier
							else
								SuperPowersConfig.BruteForceConfig.push_force_multiplier = SuperPowersConfig.BruteForceConfig.max_push_force_multiplier * math.random(5.0, 7.0)
								scriptFns.enqueueToast("Full Combo! 500% Power + " .. tostring(rapid_hit_bonus) .. " Stage-Bonus")
							end
						end
						BFvars.dx = BFvars.targetPedCoords.x - BFvars.vehicleCoords.x
						BFvars.dy = BFvars.targetPedCoords.y - BFvars.vehicleCoords.y
						BFvars.dz = BFvars.targetPedCoords.z - BFvars.vehicleCoords.z
						BFvars.force = {x = BFvars.dx * SuperPowersConfig.BruteForceConfig.push_force_multiplier, y = BFvars.dy * SuperPowersConfig.BruteForceConfig.push_force_multiplier, z = BFvars.dz * SuperPowersConfig.BruteForceConfig.push_force_multiplier}
						if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(BFvars.playerVehicle) then
							ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(BFvars.playerVehicle, 1, BFvars.force.x, BFvars.force.y, BFvars.force.z, false, false, true, false)
							SuperPowersConfig.BruteForceConfig.push_timer = current_ms() + SuperPowersConfig.BruteForceConfig.push_cooldown
							SuperPowersConfig.BruteForceConfig.bruteForceTime = os.clock()
						end
					end
				end
			end
		end
		functionSP.bruteForceEffect = function(pId)
			if isDebugOn then
				util.toast("Bruteforce detected a collision or was activated for some reason.")
			end
			local BFEvars = {
				targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId),
				playerVehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId), false),
				isVehicleDrivenByNPC = false,
				vehicleCoords = nil,
				targetPedCoords = nil,
				dx = nil,
				dy = nil,
				dz = nil,
				force = nil
			}
			for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 20.0)) do
				BFEvars.isVehicleDrivenByNPC = npcDrivers[VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)] ~= nil
				if BFEvars.playerVehicle ~= 0 and vehicle ~= BFEvars.playerVehicle and ENTITY.IS_ENTITY_TOUCHING_ENTITY(vehicle, BFEvars.playerVehicle) and BFEvars.isVehicleDrivenByNPC then
					BFEvars.vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
					BFEvars.targetPedCoords = ENTITY.GET_ENTITY_COORDS(BFEvars.targetPed, true)
					BFEvars.dx = BFEvars.targetPedCoords.x - BFEvars.vehicleCoords.x
					BFEvars.dy = BFEvars.targetPedCoords.y - BFEvars.vehicleCoords.y
					BFEvars.dz = BFEvars.targetPedCoords.z - BFEvars.vehicleCoords.z
					BFEvars.force = {x = BFEvars.dx * SuperPowersConfig.OGBruteForceConfig.OGBFpush_force_multiplier, y = BFEvars.dy * SuperPowersConfig.OGBruteForceConfig.OGBFpush_force_multiplier, z = BFEvars.dz * SuperPowersConfig.OGBruteForceConfig.OGBFpush_force_multiplier}
					if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(BFEvars.playerVehicle) then
						ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(BFEvars.playerVehicle, 1, BFEvars.force.x, BFEvars.force.y, BFEvars.force.z, false, false, true, false)
						SuperPowersConfig.OGBruteForceConfig.OGBFpush_timer = current_ms() + SuperPowersConfig.OGBruteForceConfig.OGBFpush_cooldown
						bruteForceTime = os.clock()
					end
				end
			end
		end
		
		
		functionSP.playerBruteForceEffect = function(pId)
			if isDebugOn then
				util.toast("PlayerBruteForce detected a collision or was activated for some reason.")
			end
			local PBFvars = {
				playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId),
				npcVehicles = get_vehicles_in_player_range(pId, 20.0),
				playerVehicle = nil,
				npcVehicleCoords = nil,
				playerPedCoords = nil,
				distance_to_player = nil,
				dx = nil,
				dy = nil,
				dz = nil,
				force = {
					x = nil,
					y = nil,
					z = nil
				}
			}
			for _, npcVehicle in ipairs(PBFvars.npcVehicles) do
				PBFvars.playerVehicle = PED.GET_VEHICLE_PED_IS_IN(PBFvars.playerPed, false)
				if PBFvars.playerVehicle ~= 0 and npcVehicle ~= PBFvars.playerVehicle and scriptFns.is_colliding(npcVehicle, PBFvars.playerVehicle) then
					PBFvars.npcVehicleCoords = ENTITY.GET_ENTITY_COORDS(npcVehicle, true)
					PBFvars.playerPedCoords = ENTITY.GET_ENTITY_COORDS(PBFvars.playerPed, true)
					PBFvars.distance_to_player = calculate_distance(PBFvars.npcVehicleCoords.x, PBFvars.npcVehicleCoords.y, PBFvars.npcVehicleCoords.z, PBFvars.playerPedCoords.x, PBFvars.playerPedCoords.y, PBFvars.playerPedCoords.z)
					if PBFvars.distance_to_player <= SuperPowersConfig.PlayerBruteForceConfig.playerBruteForce_push_threshold and current_ms() >= SuperPowersConfig.PlayerBruteForceConfig.playerBruteForce_push_timer then
						PBFvars.dx = PBFvars.npcVehicleCoords.x - PBFvars.playerPedCoords.x
						PBFvars.dy = PBFvars.npcVehicleCoords.y - PBFvars.playerPedCoords.y
						PBFvars.dz = PBFvars.npcVehicleCoords.z - PBFvars.playerPedCoords.z
						PBFvars.force.x = PBFvars.dx * SuperPowersConfig.PlayerBruteForceConfig.playerBruteForce_push_force_multiplier
						PBFvars.force.y = PBFvars.dy * SuperPowersConfig.PlayerBruteForceConfig.playerBruteForce_push_force_multiplier
						PBFvars.force.z = PBFvars.dz * SuperPowersConfig.PlayerBruteForceConfig.playerBruteForce_push_force_multiplier
						if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(npcVehicle) then
							ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(npcVehicle, 1, PBFvars.force.x, PBFvars.force.y, PBFvars.force.z, false, false, true, false)
							SuperPowersConfig.PlayerBruteForceConfig.playerBruteForce_push_timer = current_ms() + SuperPowersConfig.PlayerBruteForceConfig.playerBruteForce_push_cooldown
							SuperPowersConfig.PlayerBruteForceConfig.playerbruteForceTime = os.clock()
						end
					end									
				end
			end
		end
		functionSP.SuperHot = function(driver, vehicle, targetPed)
			if isDebugOn and SHvars.SuperHotdistance_to_player <= 50 and SHvars.SuperHotspeedMPH > 0.5 then
				util.toast("Player is moving at " .. tostring(math.floor(SHvars.SuperHotspeedMPH)) .. " MPH")
			end
			local SHvars = {
				SHvehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true),
				SHtargetPedCoords = ENTITY.GET_ENTITY_COORDS(targetPed, true),
				SuperHotdistance_to_player = nil,
				SuperHotspeedMPH = scriptFns.getPlayerSpeedMPH(pId),
				SHplayerVelocity = scriptFns.getPlayerVelocity(pId),
				SHpredictionFactor = 0.05,
				SHpredictedPosition = nil,
				proximity_distance_threshold = nil,
				adjustedThreshold = nil,
				adjustedSpeed = nil,
				force = nil,
				vehicleDirection = nil,
				magnitude = nil,
				alignment = nil
			}
			if not VEHICLE.GET_IS_VEHICLE_ENGINE_RUNNING(vehicle) then
				return
			end
			SHvars.SuperHotdistance_to_player = scriptFns.calculateDistance(SHvars.SHvehicleCoords, SHvars.SHtargetPedCoords)
			SHvars.SHpredictedPosition = scriptFns.predictPlayerPosition(SHvars.SHtargetPedCoords, SHvars.SHplayerVelocity, SHvars.SHpredictionFactor)
			SHvars.proximity_distance_threshold = SHvars.SuperHotspeedMPH * 0.15
			if ProximityMPHMirroring and SHvars.SuperHotspeedMPH > 0 then
				SuperPowersConfig.SuperHotConfig.SHproximity_push_threshold = SuperPowersConfig.SuperHotConfig.SHproximity_push_threshold * (1 + (SHvars.SuperHotspeedMPH * 0.15))
			end
			SHvars.adjustedThreshold = 4 + (SHvars.SuperHotspeedMPH * 0.3)
			if SHvars.SuperHotdistance_to_player <= SHvars.adjustedThreshold then
				SHvars.adjustedSpeed = SHvars.SuperHotspeedMPH + 1.1
				scriptFns.setNPCDriverSpeed(vehicle, SHvars.adjustedSpeed)
			end
			if SHvars.SuperHotdistance_to_player <= SHvars.proximity_distance_threshold then
				SHvars.force = scriptFns.calculateDirectionalForce(SHvars.SHvehicleCoords, SHvars.SHpredictedPosition)
				SHvars.vehicleDirection = scriptFns.getVehicleDirection(vehicle)
				SHvars.magnitude = math.sqrt(SHvars.force.x^2 + SHvars.force.y^2 + SHvars.force.z^2)
				SHvars.force.x = SHvars.force.x / SHvars.magnitude
				SHvars.force.y = SHvars.force.y / SHvars.magnitude
				SHvars.force.z = SHvars.force.z / SHvars.magnitude
				SHvars.alignment = scriptFns.dotProduct(SHvars.vehicleDirection, SHvars.force)
				if SHvars.alignment < 0.5 then
					SHvars.force.x = SHvars.force.x * 2
					SHvars.force.y = SHvars.force.y * 2
					SHvars.force.z = SHvars.force.z * 2
				end
				if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle) then
					ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, SHvars.force.x, SHvars.force.y, SHvars.force.z, 0, 0, 0, 0, false, false, true, false, true)
					SuperPowersConfig.SuperHotConfig.SHproximity_push_timer = current_ms() + SuperPowersConfig.SuperHotConfig.SHproximity_push_cooldown
					SuperPowersConfig.SuperHotConfig.SHproximityHomingTime = os.clock()
				end
			end
		end
		functionSP.proximityHoming = function(driver, vehicle, targetPed)
			if isDebugOn then
				util.toast("proximityHoming was called.")
			end
			local PHvars = {
				vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true),
				targetPedCoords = ENTITY.GET_ENTITY_COORDS(targetPed, true),
				distance_to_player = nil,
				speedMPH = scriptFns.getPlayerSpeedMPH(pId),
				force = nil
			}
			PHvars.distance_to_player = scriptFns.calculateDistance(PHvars.vehicleCoords, PHvars.targetPedCoords)
			if SuperPowersConfig.ConditionsConfig.onlyInVehiclesPH and not PED.IS_PED_IN_ANY_VEHICLE(targetPed, false) then
				return
			end
			SuperPowersConfig.ProximityHomingConfig.proximity_distance_threshold = PHvars.speedMPH * 0.15
			if ProximityMPHMirroring and PHvars.speedMPH > 0 then
				SuperPowersConfig.ProximityHomingConfig.proximity_push_threshold = SuperPowersConfig.ProximityHomingConfig.proximity_push_threshold * (1 + (PHvars.speedMPH * 0.15))
			end
			if PHvars.distance_to_player <= SuperPowersConfig.ProximityHomingConfig.proximity_distance_threshold then
				PHvars.force = scriptFns.calculateForce(PHvars.vehicleCoords, PHvars.targetPedCoords)
				if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle) then
					ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, PHvars.force.x, PHvars.force.y, PHvars.force.z, 0, 0, 0, 0, false, false, true, false, true)
					SuperPowersConfig.ProximityHomingConfig.proximity_push_timer = current_ms() + SuperPowersConfig.ProximityHomingConfig.proximity_push_cooldown
					SuperPowersConfig.ProximityHomingConfig.proximityHomingTime = os.clock()
				end
			end
		end
		functionSP.audioSpamEffect = function(pId)
			if isDebugOn then
				util.toast("audioSpam detected as activated for some reason.")
			end
			local audioSpamVars = {
				targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId),
				vehicleCoords = nil,
				targetPedCoords = nil,
				distance_to_player = nil,
				explosionCoords = nil
			}
			if SuperPowersConfig.ConditionsConfig.onlyInVehiclesAP and not PED.IS_PED_IN_ANY_VEHICLE(audioSpamVars.targetPed, false) then
				return
			end
			for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 150.0)) do
				local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
				if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
					audioSpamVars.vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
					audioSpamVars.targetPedCoords = ENTITY.GET_ENTITY_COORDS(audioSpamVars.targetPed, true)
					audioSpamVars.distance_to_player = calculate_distance(audioSpamVars.vehicleCoords.x, audioSpamVars.vehicleCoords.y, audioSpamVars.vehicleCoords.z, audioSpamVars.targetPedCoords.x, audioSpamVars.targetPedCoords.y, audioSpamVars.targetPedCoords.z)
					if audioSpamVars.distance_to_player <= SuperPowersConfig.audioSpamConfig.audioSpamTriggerDistance then
						audioSpamVars.explosionCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
						FIRE.ADD_EXPLOSION(audioSpamVars.explosionCoords.x, audioSpamVars.explosionCoords.y, audioSpamVars.explosionCoords.z, SuperPowersConfig.audioSpamConfig.audioSpamType, SuperPowersConfig.audioSpamConfig.audioSpamDamage, SuperPowersConfig.audioSpamConfig.audioSpamAudible, SuperPowersConfig.audioSpamConfig.audioSpamInvisible, 1321.0, false)
					end
				end
			end
		end
		functionSP.Nodetraffic = function()
			functionSP.Nodetraffic = function() 
				local pId = PLAYER.PLAYER_ID()
				local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
				if not PED.IS_PED_IN_ANY_VEHICLE(playerPed, false) then
					return
				end
				local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed, false)
				if not ENTITY.IS_ENTITY_IN_AIR(playerVehicle) then
					return
				end
			end
			local vars = {
				npc_detection_ranges = {},
				force = {},
				vehicleCoords = {},
				targetPedCoords = {},
				targetPedVelocity = {},
				predicted_position = {},
				normalized_direction = {},
				stiffness_multiplier = .01,
				base_push_force_multiplier = .1,
				max_controlled_nodes = 175,
				controlled_nodes_count = 0,
				levitation_height = 0.0001,
				node_distance_from_player = -999,
				dynamic_push_force_multiplier = 0,
				player_speed = 0,
				direction_x = 0,
				direction_y = 0,
				direction_z = 0,
				dx = 0,
				dy = 0,
				dz = 0,
				direction_magnitude = 0
			}
			for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 700)) do
				local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
				if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) and vars.controlled_nodes_count < vars.max_controlled_nodes then
					vars.vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
					vars.targetPedCoords = ENTITY.GET_ENTITY_COORDS(targetPed, true)
					vars.targetPedVelocity = ENTITY.GET_ENTITY_VELOCITY(targetPed)
					vars.predicted_position = calculate_future_position(vars.targetPedCoords, vars.targetPedVelocity, .4)
					local z_velocity = vars.targetPedVelocity.z
					local adjustment_height = 1e-26 -- updated to simulate a infinitesimally small positive number
					if z_velocity > 0 then
						vars.predicted_position.z = vars.predicted_position.z - adjustment_height
					elseif z_velocity < 0 then
						vars.predicted_position.z = vars.predicted_position.z + adjustment_height
					end
					vars.dx, vars.dy, vars.dz = vars.predicted_position.x - vars.vehicleCoords.x, vars.predicted_position.y - vars.vehicleCoords.y, vars.predicted_position.z - vars.vehicleCoords.z
					vars.player_speed = vector_magnitude(vars.targetPedVelocity.x, vars.targetPedVelocity.y, vars.targetPedVelocity.z)
					vars.dynamic_push_force_multiplier = vars.base_push_force_multiplier * (0.1 + vars.player_speed / 0.1) * vars.stiffness_multiplier
					vars.force = {x = vars.dx * vars.dynamic_push_force_multiplier, y = vars.dy * vars.dynamic_push_force_multiplier, z = vars.dz * vars.dynamic_push_force_multiplier}
					vars.direction_x, vars.direction_y, vars.direction_z = vars.vehicleCoords.x - vars.targetPedCoords.x, vars.vehicleCoords.y - vars.targetPedCoords.y, vars.vehicleCoords.z - vars.targetPedCoords.z
					vars.direction_magnitude = vector_magnitude(vars.direction_x, vars.direction_y, vars.direction_z)
					vars.normalized_direction = {x = vars.direction_x / vars.direction_magnitude, y = vars.direction_y / vars.direction_magnitude, z = vars.direction_z / vars.direction_magnitude}
					vars.predicted_position.x = vars.predicted_position.x + vars.normalized_direction.x * vars.node_distance_from_player
					vars.predicted_position.y = vars.predicted_position.y + vars.normalized_direction.y * vars.node_distance_from_player
					vars.predicted_position.z = vars.predicted_position.z + vars.normalized_direction.z * vars.node_distance_from_player + vars.levitation_height
					if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle) then
						ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, vars.force.x, vars.force.y, vars.force.z, 0, 0, 0, 0, false, false, true, false, true)
						vars.controlled_nodes_count = vars.controlled_nodes_count + 1
					end
				end
			end
		end
		functionSP.playerProximityHoming = function(driver, vehicle, targetPed)
			if isDebugOn then
				util.toast("playerProximityHoming was called.")
			end
			local PPHvars = {
				vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true),
				playerVehicle = nil,
				playerCoords = nil,
				distance_to_player = nil,
				force = nil
			}
			if PlayerVehiclesOnly then
				PPHvars.playerVehicle = PED.GET_VEHICLE_PED_IS_IN(targetPed, false)
				if PPHvars.playerVehicle ~= 0 then
					PPHvars.playerCoords = ENTITY.GET_ENTITY_COORDS(PPHvars.playerVehicle, true)
				else
					return
				end
			else
				PPHvars.playerCoords = ENTITY.GET_ENTITY_COORDS(targetPed, true)
			end
			PPHvars.distance_to_player = scriptFns.calculateDistance(PPHvars.vehicleCoords, PPHvars.playerCoords)
			if PPHvars.distance_to_player <= SuperPowersConfig.playerProximityConfig.distance_threshold then
				PPHvars.force = scriptFns.calculateForce(PPHvars.playerCoords, PPHvars.vehicleCoords)
				local targetEntity = PlayerVehiclesOnly and PPHvars.playerVehicle or targetPed
				if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(targetEntity) then
					ENTITY.APPLY_FORCE_TO_ENTITY(targetEntity, 1.0, PPHvars.force.x, PPHvars.force.y, PPHvars.force.z, 0, 0, 0, 0, false, false, true, false, true)
					SuperPowersConfig.playerProximityConfig.push_timer = current_ms() + SuperPowersConfig.playerProximityConfig.push_cooldown
					SuperPowersConfig.playerProximityConfig.playerProximityHomingTime = os.clock()
				end
			end
		end
		functionSP.applySuperPowers = function(driver, vehicle)
			if not isCustomTrafficOn then  
				return
			end
			if isDebugOn then
				util.toast("applySuperPowers enabled, it's likely that Super Speed or Invincibility is enabled.")
			end
			if SuperPowersConfig.SuperSpeedConfig.isSuperSpeedOn then
				local current_top_speed = VEHICLE.GET_VEHICLE_MODEL_ESTIMATED_MAX_SPEED(ENTITY.GET_ENTITY_MODEL(vehicle))
				VEHICLE.MODIFY_VEHICLE_TOP_SPEED(vehicle, current_top_speed * SuperPowersConfig.SuperSpeedConfig.speedMultiplier)
			end
			if SuperPowersConfig.SuperSpeedConfig.isInvincibilityAndMissionEntityOn then
			if not VEHICLE.GET_IS_VEHICLE_ENGINE_RUNNING(vehicle) then
				return
			end
				ENTITY.SET_ENTITY_INVINCIBLE(vehicle, true)
				ENTITY.SET_ENTITY_INVINCIBLE(driver, true)
			else
				ENTITY.SET_ENTITY_INVINCIBLE(vehicle, false)
				ENTITY.SET_ENTITY_INVINCIBLE(driver, false)
			end
		end
		functionSP.customTraffic = function(pId)
			local CTvars = {
				currentTime = os.time(),
				lastCallTime = lastCallTime,
				callCount = callCount, 
				targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId),
				targetCoords = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId), true),
				targetVehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId), false),
				driver = nil,
				driverCoords = nil,
				distance = nil
			}
			if isDebugOn then
				if CTvars.currentTime - CTvars.lastCallTime >= 1 then
					util.toast("customTraffic was called " .. CTvars.callCount .. " times in the last second.")
					CTvars.callCount = 0
					CTvars.lastCallTime = CTvars.currentTime
				end
			end
			if CTvars.callCount >= 1 then
				return
			end
			scriptFns.updateNpcDriversCount()
			if not isCustomTrafficOn then
				return util.stop_thread()
			end
			for _, vehicle in ipairs(get_vehicles_in_player_range(pId, npcRange)) do
				if npcDriversCount >= maxNpcDrivers then
					drawMaxCount()
					break
				end
				if targetPlayersInVehiclesOnly then
					if CTvars.targetVehicle == 0 then 
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
					if CTvars.targetVehicle ~= 0 then -- Player is in a vehicle
						for driver, vehicle in pairs(npcDrivers) do
							resetNPCBehavior(driver, vehicle)
						end
						return
					end
				end

				if TASK.GET_ACTIVE_VEHICLE_MISSION_TYPE(vehicle) ~= 6 then
					CTvars.driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
					CTvars.driverCoords = ENTITY.GET_ENTITY_COORDS(CTvars.driver, true)
					CTvars.distance = calculate_distance(CTvars.targetCoords.x, CTvars.targetCoords.y, CTvars.targetCoords.z, CTvars.driverCoords.x, CTvars.driverCoords.y, CTvars.driverCoords.z)
					if ENTITY.DOES_ENTITY_EXIST(CTvars.driver) and not PED.IS_PED_A_PLAYER(CTvars.driver) and npcDrivers[CTvars.driver] == nil then
						request_control_once(CTvars.driver)
						PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(CTvars.driver, true)
						TASK.TASK_VEHICLE_MISSION_PED_TARGET(CTvars.driver, vehicle, CTvars.targetPed, 6, 100.0, 0, 0.0, 0.0, true)
						PED.SET_PED_CAN_BE_KNOCKED_OFF_VEHICLE(CTvars.driver, 1)
						npcDrivers[CTvars.driver] = vehicle
						functionSP.applySuperPowers(CTvars.driver, vehicle)
						npcDriversCount = npcDriversCount + 1
						add_blip_for_entity(CTvars.driver, currentBlipType, math.random(-6300, -4000))
						PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(CTvars.driver, true)
						newDriverTime = os.clock() 
						npcDriversCountPrev = npcDriversCount
						CTvars.callCount = CTvars.callCount + 1
						if isCustomTrafficOn then
							local playerName = PLAYER.GET_PLAYER_NAME(pId)
							if targetedUsernames[playerName] then
								targetedUsernames[playerName] = targetedUsernames[playerName] + 1
							else
								targetedUsernames[playerName] = 1
							end
							if PlayerVehiclesOnly and CTvars.targetPed then
								TASK.TASK_VEHICLE_MISSION(CTvars.driver, vehicle, CTvars.targetPed, 6, 100.0, 0, 0.0, 0.0, true)
							else
								TASK.TASK_VEHICLE_MISSION_PED_TARGET(CTvars.driver, vehicle, CTvars.targetPed, 6, 100.0, 0, 0.0, 0.0, true)
							end
						end
					end
				end
			end
		end
		functionSP.removeExcessNPCDrivers = function() -- if ctl on then -> until stop
			if isDebugOn then
				util.toast("removeExcessNPCDrivers is currently active (Fun fact, this is being used to run the Draw Text separate from the Custom Traffic, which patched the old flickering text bug.)")
			end
			function shouldExecuteForVehicleCondition(pId)
				if SuperPowersConfig.ConditionsConfig.onlyInVehiclesBF or SuperPowersConfig.ConditionsConfig.onlyInVehiclesEoC or SuperPowersConfig.ConditionsConfig.onlyInVehiclesPH or SuperPowersConfig.ConditionsConfig.onlyInVehiclesAP or SuperPowersConfig.ConditionsConfig.onlyInVehiclesJump then
					local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
					local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(targetPed, false)
					return playerVehicle ~= 0
				end
				return true  
			end
			function resetNPCBehavior(driver, vehicle)
				if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) and npcDrivers[driver] then
					PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(driver, false)
					TASK.CLEAR_PED_TASKS(driver)
					npcDrivers[driver] = nil
				end
			end
			function drawHitCount()
				if BruteForceComboCounter then
					local HCvars = {
						textProperties = {
							color = {
								r = 1,
								g = 1,
								b = 1,
								a = 1
							},
							position = {
								x = 0.44,
								y = 0.80
							}
						},
						textUI = {
							HC_TXT_SCALE = {
								textScale = 0.5
							},
							HC_AST_SCALE = {
								textScale = 1.1
							}
						},
						scaleText = "|",
						scaleRatio = SuperPowersConfig.BruteForceConfig.hit_counter / 4000,
						scaleLength = 20 * (SuperPowersConfig.BruteForceConfig.hit_counter / 4000)
					}
					local DHTvars = {
						whole_part = math.floor(SuperPowersConfig.BruteForceConfig.hit_counter),
						decimal_part = SuperPowersConfig.BruteForceConfig.hit_counter - math.floor(SuperPowersConfig.BruteForceConfig.hit_counter),
						decimal_scale_factor = 0.7,
						adjusted_decimal_scale = HCvars.textUI.HC_TXT_SCALE.textScale * 0.7,
						wholePartLength = string.len(tostring(math.floor(SuperPowersConfig.BruteForceConfig.hit_counter))),
						characterWidth = nil,
						offsetX = nil,
						asteriskOffsetX = -0.03,
						spacingBetweenAsterisks = 0.009,
						BASE_WIDTH = 0.031,
						DECAY_FACTOR = 0.788,
						HitCountDrawText = SuperPowersConfig.BruteForceConfig.hit_counter / 375,
						HitCountDrawText2 = (SuperPowersConfig.BruteForceConfig.hit_counter - 375) / (750 - 375),
						HitCountDrawText3 = (SuperPowersConfig.BruteForceConfig.hit_counter - 750) / (1125 - 750),
						invertColorInterval = 0.7
					}
					function lerp(a, b, t)
						return a + (b - a) * t 
					end
					function lerp(a, b, t)
						return a + (b - a) * t
					end
					function lerpColor(color1, color2, t)
						return {
							r = lerp(color1.r, color2.r, t), g = lerp(color1.g, color2.g, t), b = lerp(color1.b, color2.b, t), a = lerp(color1.a, color2.a, t)}
					end
					function invertColor(color)
						return {
							r = 1 - color.r, g = 1 - color.g, b = 1 - color.b, a = color.a}
					end
					function getAsteriskColor(baseColor, currentTime)
						local GACvars = {
							invertedColor = invertColor(baseColor), cyclePosition = (currentTime % DHTvars.invertColorInterval) / DHTvars.invertColorInterval, fadeFactor = nil, resultantColor = nil}
						GACvars.fadeFactor = math.abs(GACvars.cyclePosition * 2 - 1)
						GACvars.resultantColor = lerpColor(baseColor, GACvars.invertedColor, GACvars.fadeFactor)
						return GACvars.resultantColor
					end
					function getAsteriskScale(currentTime)
						local ASvars = {
							scaleFrequency = 1.5, minScale = 0.8, maxScale = 1.2, scaleVariation = (math.sin(currentTime * 1.5) + 1) / 2}
						return lerp(ASvars.minScale, ASvars.maxScale, ASvars.scaleVariation)
					end
					function drawColoredAsterisk(offsetX, baseColor)
						local DCAvars = {
							currentTime = os.clock(), color = getAsteriskColor(baseColor, os.clock()), scale = getAsteriskScale(os.clock())}
						directx.draw_text(
							HCvars.textProperties.position.x + offsetX, HCvars.textProperties.position.y - 0.01, "*", ALIGN_CENTRE, HCvars.textUI.HC_AST_SCALE.textScale * DCAvars.scale, DCAvars.color, false)
					end
					if SuperPowersConfig.BruteForceConfig.hit_counter > 10 then drawColoredAsterisk(DHTvars.asteriskOffsetX, { r = 1, g = 0.8, b = 0.6, a = 1 }) end
					if SuperPowersConfig.BruteForceConfig.hit_counter > 350 then drawColoredAsterisk(DHTvars.asteriskOffsetX + DHTvars.spacingBetweenAsterisks * 1, { r = 1, g = 0.8, b = 0.4, a = 1 }) end
					if SuperPowersConfig.BruteForceConfig.hit_counter > 650 then drawColoredAsterisk(DHTvars.asteriskOffsetX + DHTvars.spacingBetweenAsterisks * 2, { r = 1, g = 0.6, b = 0.4, a = 1 }) end
					if SuperPowersConfig.BruteForceConfig.hit_counter > 875 then drawColoredAsterisk(DHTvars.asteriskOffsetX + DHTvars.spacingBetweenAsterisks * 3, { r = 1, g = 0.4, b = 0.2, a = 1 }) end
					if SuperPowersConfig.BruteForceConfig.hit_counter > 950 then drawColoredAsterisk(DHTvars.asteriskOffsetX + DHTvars.spacingBetweenAsterisks * 4, { r = 1, g = 0.2, b = 0.1, a = 1 }) end
					if SuperPowersConfig.BruteForceConfig.hit_counter > 1050 then drawColoredAsterisk(DHTvars.asteriskOffsetX + DHTvars.spacingBetweenAsterisks * 5, { r = 1, g = 0.1, b = 0.05, a = 1 }) end
					if SuperPowersConfig.BruteForceConfig.hit_counter > 1250 then drawColoredAsterisk(DHTvars.asteriskOffsetX + DHTvars.spacingBetweenAsterisks * 6, { r = 1, g = 0.05, b = 0.025, a = 1 }) end
					if SuperPowersConfig.BruteForceConfig.hit_counter > 1350 then drawColoredAsterisk(DHTvars.asteriskOffsetX + DHTvars.spacingBetweenAsterisks * 7, { r = 1, g = 0.5, b = 0.015, a = 1 }) end
					if SuperPowersConfig.BruteForceConfig.hit_counter > 1550 then drawColoredAsterisk(DHTvars.asteriskOffsetX + DHTvars.spacingBetweenAsterisks * 8, { r = 1, g = 0.6, b = 0.005, a = 1 }) end
					DHTvars.characterWidth = DHTvars.BASE_WIDTH / (1 + DHTvars.DECAY_FACTOR * (DHTvars.wholePartLength - 1))
					if SuperPowersConfig.BruteForceConfig.hit_counter <= 375 then
						HCvars.textProperties.color.r = 0.7 HCvars.textProperties.color.g = 0.7 HCvars.textProperties.color.b = lerp(1, 0, DHTvars.HitCountDrawText)
					elseif SuperPowersConfig.BruteForceConfig.hit_counter <= 750 then
						HCvars.textProperties.color.r = 1 HCvars.textProperties.color.g = lerp(1, 0.5, DHTvars.HitCountDrawText2) HCvars.textProperties.color.b = 0
					elseif SuperPowersConfig.BruteForceConfig.hit_counter <= 1125 then
						HCvars.textProperties.color.r = 1 HCvars.textProperties.color.g = lerp(0.5, 0, DHTvars.HitCountDrawText3) HCvars.textProperties.color.b = 0
					else
						HCvars.textProperties.color.r = 1 HCvars.textProperties.color.g = 0 HCvars.textProperties.color.b = 0
					end
					DHTvars.offsetX = DHTvars.wholePartLength * DHTvars.characterWidth
					local centralRect = {
						position = {x = 0.509, y = 0.834},
						size = {width = 0.205, height = 0.14},
						color = {r = 0, g = 0, b = 0.004, a = 0.2}
					}
					local border = {
						steps = 5,
						maxAlpha = 0.2,
					}
					for i = 1, border.steps do
						local alpha = border.maxAlpha * (0.6 - (i / border.steps))
						local expansion = i * 0.005
						local size = {
							width = centralRect.size.width + expansion,
							height = centralRect.size.height + expansion
						}
						directx.draw_rect(
							centralRect.position.x - (size.width / 2),
							centralRect.position.y - (size.height / 2),
							size.width,
							size.height,
							centralRect.color.r,
							centralRect.color.g,
							centralRect.color.b,
							alpha
						)
					end
					directx.draw_rect(
						centralRect.position.x - (centralRect.size.width / 2),
						centralRect.position.y - (centralRect.size.height / 2),
						centralRect.size.width,
						centralRect.size.height,
						centralRect.color.r,
						centralRect.color.g,
						centralRect.color.b,
						centralRect.color.a
					)
					scriptFns.current_stage = scriptFns.getStageFromHits(SuperPowersConfig.BruteForceConfig.hit_counter)
					directx.draw_text(
						HCvars.textProperties.position.x, 
						HCvars.textProperties.position.y, 
						"Hit Points: |x" .. tostring(DHTvars.whole_part) .. ".", 
						ALIGN_CENTRE, 
						HCvars.textUI.HC_TXT_SCALE.textScale, 
						HCvars.textProperties.color, 
						false
					)
			
					local stageText = "Stage: " .. tostring(scriptFns.current_stage)
					directx.draw_text(
						HCvars.textProperties.position.x - 1.28e-2,
						HCvars.textProperties.position.y + 4e-2,
						stageText, 
						ALIGN_CENTRE, 
						HCvars.textUI.HC_TXT_SCALE.textScale, 
						HCvars.textProperties.color, 
						false
					)
					scriptFns.current_stage = scriptFns.getStageFromHits(SuperPowersConfig.BruteForceConfig.hit_counter)
					local rapid_hit_bonus = scriptFns.calculateHitBonusForStage(scriptFns.current_stage)
					local stageBonusText = "            +" .. tostring(rapid_hit_bonus + 7.3) .. " Combo-Bonus"
					directx.draw_text(
						HCvars.textProperties.position.x - 2e-4,
						HCvars.textProperties.position.y + 5.5e-2,
						stageBonusText, 
						ALIGN_CENTRE, 
						HCvars.textUI.HC_TXT_SCALE.textScale, 
						HCvars.textProperties.color, 
						false
					)
					local function onComboTrigger()
						SuperPowersConfig.BruteForceConfig.total_rapid_combo_triggers = SuperPowersConfig.BruteForceConfig.total_rapid_combo_triggers + 1
						SuperPowersConfig.BruteForceConfig.additionalTime = SuperPowersConfig.BruteForceConfig.additionalTime + 3
					end
					scriptFns.current_stage = scriptFns.getStageFromHits(SuperPowersConfig.BruteForceConfig.hit_counter)
					local comboTriggerText = "      3-Hit Combos: " .. tostring(SuperPowersConfig.BruteForceConfig.total_rapid_combo_triggers)
					directx.draw_text(
						HCvars.textProperties.position.x - 9e-4,
						HCvars.textProperties.position.y + 6.8e-2,
						comboTriggerText, 
						ALIGN_CENTRE, 
						HCvars.textUI.HC_TXT_SCALE.textScale, 
						HCvars.textProperties.color, 
						false
					)
					scriptFns.current_stage = scriptFns.getStageFromHits(SuperPowersConfig.BruteForceConfig.hit_counter)
					local decrementValueText = "        HP Loss: x" .. string.format("%.4f", SuperPowersConfig.BruteForceConfig.decrement_tracker)
					directx.draw_text(
						HCvars.textProperties.position.x - 9e-4,
						HCvars.textProperties.position.y + 8.15e-2,
						decrementValueText, 
						ALIGN_CENTRE, 
						HCvars.textUI.HC_TXT_SCALE.textScale, 
						HCvars.textProperties.color, 
						false
					)
					scriptFns.current_stage = scriptFns.getStageFromHits(SuperPowersConfig.BruteForceConfig.hit_counter)
					local hitCounterTriggersText = "Hits x" .. tostring(SuperPowersConfig.BruteForceConfig.hit_counter_trigger_count)
					directx.draw_text(
						HCvars.textProperties.position.x - 1.4e-2,
						HCvars.textProperties.position.y + 8.35e-2 + 1e-2,
						hitCounterTriggersText, 
						ALIGN_CENTRE, 
						HCvars.textUI.HC_TXT_SCALE.textScale, 
						HCvars.textProperties.color, 
						false
					)
					directx.draw_text(
						HCvars.textProperties.position.x + DHTvars.offsetX, HCvars.textProperties.position.y, string.format("%.3f", DHTvars.decimal_part):sub(3), ALIGN_CENTRE, DHTvars.adjusted_decimal_scale, HCvars.textProperties.color, false)
					for i = 1, HCvars.scaleLength do
						HCvars.scaleText = HCvars.scaleText .. "•~"
					end
					if SuperPowersConfig.BruteForceConfig.hit_counter >= 1800 then
						HCvars.scaleText = HCvars.scaleText .. "|"
					end
					directx.draw_text(
						HCvars.textProperties.position.x, HCvars.textProperties.position.y + 0.017, HCvars.scaleText, ALIGN_CENTRE, HCvars.textUI.HC_TXT_SCALE.textScale, HCvars.textProperties.color, false)
				end
			end
			function drawTextLoop()
				DriverCount_textProperties.color.r = 1
				DriverCount_textProperties.color.g = math.max(3 - (npcDriversCount/7), 0)
				directx.draw_text(
					DriverCount_textProperties.position.x, DriverCount_textProperties.position.y, "  NPC Drivers: " .. tostring(npcDriversCount), ALIGN_CENTRE, CountTextUI.DR_TXT_SCALE.textScale, 
					{r = DriverCount_textProperties.color.r, g = DriverCount_textProperties.color.g, b = DriverCount_textProperties.color.b, a = DriverCount_textProperties.color.a}, false)
			end
			function drawPresetActiveText()
				if scriptFns.isAnyPresetActive() then scriptFns.drawPreset("PRESET ACTIVE •", GlobalTextVariables.Preset) end
				if settings.DemonicNPCsOn.isOn and (os.clock() - DemonicNPCsTime < 1) then scriptFns.drawPreset("• DEMONIC NPCS", GlobalTextVariables.DemonicNPCsActivated) end
				if settings.BumperCarsOn.isOn and (os.clock() - BumperCarsTime< 1) then scriptFns.drawPreset("• BUMPER CARS", GlobalTextVariables.BumperCarsActivated) end
				if settings.RabidHomingNPCsOn.isOn and (os.clock() - RabidHomingNPCsTime< 1) then scriptFns.drawPreset("• RABID HOMING NPCS", GlobalTextVariables.RabidHomingNPCsActivated) end
				if settings.SpeedyNPCsOn.isOn and (os.clock() - SpeedyNPCsTime< 1) then scriptFns.drawPreset("• SPEEDY NPCS", GlobalTextVariables.SpeedyNPCsActivated) end
				if settings.FastNPCsOn.isOn and (os.clock() - FastNPCsTime< 1) then scriptFns.drawPreset("• FAST NPCS", GlobalTextVariables.FastNPCsActivated) end
				if settings.ExplosiveNPCsOn.isOn and (os.clock() - ExplosiveNPCsTime< 1) then scriptFns.drawPreset("• EMP NPCS", GlobalTextVariables.ExplosiveNPCsActivated) end
				if settings.SpikeExplosiveNPCsOn.isOn and (os.clock() - SpikeExplosiveNPCsTime< 1) then scriptFns.drawPreset("• TIRESPIKE NPCS", GlobalTextVariables.SpikeExplosiveNPCsActivated) end
				if settings.RandomExplosiveNPCsOn.isOn and (os.clock() - RandomExplosiveNPCsTime< 1) then scriptFns.drawPreset("• RANDOM EXPLOSION CHAOS", GlobalTextVariables.RandomExplosiveNPCsActivated) end
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
			function updateHitCounterAndDecrement()
				if BruteForceComboCounter and lastVehicleDeletionTime and os.clock() - lastVehicleDeletionTime < .025 then
					SuperPowersConfig.BruteForceConfig.hit_counter = SuperPowersConfig.BruteForceConfig.hit_counter - .499
			
					-- Adjust decrement_value based on hit_counter's value
					if SuperPowersConfig.BruteForceConfig.hit_counter > 0 then
						SuperPowersConfig.BruteForceConfig.decrement_value = SuperPowersConfig.BruteForceConfig.decrement_value + 0.0006
					end
			
					if SuperPowersConfig.BruteForceConfig.hit_counter < 0 and SuperPowersConfig.BruteForceConfig.hit_counter > -50 then
						SuperPowersConfig.BruteForceConfig.decrement_value = SuperPowersConfig.BruteForceConfig.decrement_value - 0.0050
					end
			
					if SuperPowersConfig.BruteForceConfig.hit_counter == 0 then
						SuperPowersConfig.BruteForceConfig.decrement_value = SuperPowersConfig.BruteForceConfig.decrement_value - 1.0000
						-- Ensure decrement_value does not go below 0
						if SuperPowersConfig.BruteForceConfig.decrement_value < 0 then
							SuperPowersConfig.BruteForceConfig.decrement_value = 0
						end
					end
			
					-- Cap hit_counter at -50
					if SuperPowersConfig.BruteForceConfig.hit_counter < -50 then
						SuperPowersConfig.BruteForceConfig.hit_counter = -50
					end
				end
			end
			
			function drawDestroyedVehicle()
				if lastVehicleDeletionTime and os.clock() - lastVehicleDeletionTime < 1.2 then
					directx.draw_text(GlobalTextVariables.destroyedVehiclexy.x, GlobalTextVariables.destroyedVehiclexy.y, "• An NPCDriver's vehicle has been destroyed!", ALIGN_CENTRE, CountTextUI.DR2_TXT_SCALE.textScale, GlobalTextVariables.destroyedVehiclexy.TextColor, false)
					updateHitCounterAndDecrement()
				end
			end
			function drawDestroyedVehicle()
				if lastVehicleDeletionTime and os.clock() - lastVehicleDeletionTime < 1.2 then
					directx.draw_text(GlobalTextVariables.destroyedVehiclexy.x, GlobalTextVariables.destroyedVehiclexy.y, "• An NPCDriver's vehicle has been destroyed!", ALIGN_CENTRE, CountTextUI.DR2_TXT_SCALE.textScale, GlobalTextVariables.destroyedVehiclexy.TextColor, false)
					updateHitCounterAndDecrement()
				end
			end
			
			function drawBruteForceActivated()
				if os.clock() - SuperPowersConfig.BruteForceConfig.bruteForceTime < .6 then 
					directx.draw_text(GlobalTextVariables.bruteForceActivatedxy.x, GlobalTextVariables.bruteForceActivatedxy.y, "• Brute Force Triggered", ALIGN_CENTRE, CountTextUI.DR2_TXT_SCALE.textScale, GlobalTextVariables.bruteForceActivatedxy.TextColor, false)
				end
			end
			function drawPlayerBruteForceActivated()
				if os.clock() - SuperPowersConfig.PlayerBruteForceConfig.playerbruteForceTime < .6 then 
					directx.draw_text(GlobalTextVariables.playerbruteForceActivatedxy.x, GlobalTextVariables.playerbruteForceActivatedxy.y, "• Player Brute Force Triggered", ALIGN_CENTRE, CountTextUI.DR2_TXT_SCALE.textScale, GlobalTextVariables.playerbruteForceActivatedxy.TextColor, false)
				end
			end
			function updateHitCounterForSuperHot()
				if BruteForceComboCounter and SuperPowersConfig.SuperHotConfig.isSuperHotOn then
					local currentTime = os.clock()
					if currentTime - SuperPowersConfig.SuperHotConfig.SHproximityHomingTime < .9 then
						if not SuperPowersConfig.BruteForceConfig.lastIncrementTime then
							SuperPowersConfig.BruteForceConfig.lastIncrementTime = currentTime
						end
						if currentTime - SuperPowersConfig.BruteForceConfig.lastIncrementTime >= 0.066 then
							SuperPowersConfig.BruteForceConfig.hit_counter = SuperPowersConfig.BruteForceConfig.hit_counter + .599
							SuperPowersConfig.BruteForceConfig.hit_counter = math.min(SuperPowersConfig.BruteForceConfig.hit_counter, SuperPowersConfig.BruteForceConfig.Max_Hit_Counter)
							if SuperPowersConfig.BruteForceConfig.decrement_value then
								SuperPowersConfig.BruteForceConfig.decrement_value = SuperPowersConfig.BruteForceConfig.decrement_value - .00023
								SuperPowersConfig.BruteForceConfig.decrement_value = math.max(SuperPowersConfig.BruteForceConfig.decrement_value, 0)
							end
							SuperPowersConfig.BruteForceConfig.lastIncrementTime = currentTime
						end
					else
						SuperPowersConfig.BruteForceConfig.lastIncrementTime = nil
					end
				end
			end
			function drawSuperHotActivated()
				if os.clock() - SuperPowersConfig.SuperHotConfig.SHproximityHomingTime < .9 then
					directx.draw_text(GlobalTextVariables.superhotActivatedxy.x, GlobalTextVariables.superhotActivatedxy.y, "• Super Hot: ON", ALIGN_CENTRE, CountTextUI.DR2_TXT_SCALE.textScale, GlobalTextVariables.superhotActivatedxy.TextColor, false)
					updateHitCounterForSuperHot()
				end
			end
			function drawPlayerProximityHomingActivated()
				if os.clock() - SuperPowersConfig.playerProximityConfig.playerProximityHomingTime < .8 then
					directx.draw_text(GlobalTextVariables.playerProximityHomingActivatedxy.x, GlobalTextVariables.playerProximityHomingActivatedxy.y, "• PPH", ALIGN_CENTRE, CountTextUI.DR2_TXT_SCALE.textScale, GlobalTextVariables.playerProximityHomingActivatedxy.TextColor, false)
				end
			end
			function drawProximityHomingActivated()
				if os.clock() - SuperPowersConfig.ProximityHomingConfig.proximityHomingTime < .8 then
					directx.draw_text(GlobalTextVariables.proximityHomingActivatedxy.x, GlobalTextVariables.proximityHomingActivatedxy.y, "• Proximity Homing: ON", ALIGN_CENTRE, CountTextUI.DR2_TXT_SCALE.textScale, GlobalTextVariables.proximityHomingActivatedxy.TextColor, false)
				end
			end
			function drawNPCJumpActivated()
				if os.clock() - SuperPowersConfig.JumpCoreConfig.npcJumpTime < .5 then 
					directx.draw_text(GlobalTextVariables.npcJumpActivatedxy.x, GlobalTextVariables.npcJumpActivatedxy.y, "• An NPC has Jumped!", ALIGN_CENTRE, CountTextUI.DR2_TXT_SCALE.textScale, GlobalTextVariables.npcJumpActivatedxy.TextColor, false)
				end
			end
			function updateHitCounterForExplodeOnCollision()
				local currentTime = os.clock()
				if BruteForceComboCounter and currentTime - SuperPowersConfig.explodeOnCollisionConfig.explodeOnCollisionTime < .38 then
					if not SuperPowersConfig.BruteForceConfig.lastIncrementTimeEoC then
						SuperPowersConfig.BruteForceConfig.lastIncrementTimeEoC = currentTime
					end
					if currentTime - SuperPowersConfig.BruteForceConfig.lastIncrementTimeEoC >= .066 then
						SuperPowersConfig.BruteForceConfig.hit_counter = SuperPowersConfig.BruteForceConfig.hit_counter + .299
						SuperPowersConfig.BruteForceConfig.hit_counter = math.min(SuperPowersConfig.BruteForceConfig.hit_counter, SuperPowersConfig.BruteForceConfig.Max_Hit_Counter)
						if SuperPowersConfig.BruteForceConfig.decrement_value then
							SuperPowersConfig.BruteForceConfig.decrement_value = SuperPowersConfig.BruteForceConfig.decrement_value - .0019
							SuperPowersConfig.BruteForceConfig.decrement_value = math.max(SuperPowersConfig.BruteForceConfig.decrement_value, 0)
						end
						SuperPowersConfig.BruteForceConfig.lastIncrementTimeEoC = currentTime
					end
				else
					SuperPowersConfig.BruteForceConfig.lastIncrementTimeEoC = nil
				end
			end
			function drawExplodeOnCollisionActivated()
				if os.clock() - SuperPowersConfig.explodeOnCollisionConfig.explodeOnCollisionTime < .38 then
					directx.draw_text(GlobalTextVariables.explodeOnCollisionActivatedxy.x, GlobalTextVariables.explodeOnCollisionActivatedxy.y, "• EMP", ALIGN_CENTRE, CountTextUI.DR2_TXT_SCALE.textScale, GlobalTextVariables.explodeOnCollisionActivatedxy.TextColor, false)
					updateHitCounterForExplodeOnCollision()
				end
			end
			function updateHitCounterForExplodeOnCollision2()
				local currentTime = os.clock()
				if BruteForceComboCounter and currentTime - SuperPowersConfig.explodeOnCollisionConfig2.explodeOnCollision2Time < .38 then
					if not SuperPowersConfig.BruteForceConfig.lastIncrementTimeEoC then
						SuperPowersConfig.BruteForceConfig.lastIncrementTimeEoC = currentTime
					end
					if currentTime - SuperPowersConfig.BruteForceConfig.lastIncrementTimeEoC >= .066 then
						SuperPowersConfig.BruteForceConfig.hit_counter = SuperPowersConfig.BruteForceConfig.hit_counter + .139
						SuperPowersConfig.BruteForceConfig.hit_counter = math.min(SuperPowersConfig.BruteForceConfig.hit_counter, SuperPowersConfig.BruteForceConfig.Max_Hit_Counter)
						if SuperPowersConfig.BruteForceConfig.decrement_value then
							SuperPowersConfig.BruteForceConfig.decrement_value = SuperPowersConfig.BruteForceConfig.decrement_value - .0035
							SuperPowersConfig.BruteForceConfig.decrement_value = math.max(SuperPowersConfig.BruteForceConfig.decrement_value, 0)
						end
						SuperPowersConfig.BruteForceConfig.lastIncrementTimeEoC = currentTime
					end
				else
					SuperPowersConfig.BruteForceConfig.lastIncrementTimeEoC = nil
				end
			end
			function drawExplodeOnCollision2Activated()
				if os.clock() - SuperPowersConfig.explodeOnCollisionConfig2.explodeOnCollision2Time < .38 then
					directx.draw_text(GlobalTextVariables.explodeOnCollision2Activatedxy.x, GlobalTextVariables.explodeOnCollision2Activatedxy.y, "• Spikes", ALIGN_CENTRE, CountTextUI.DR2_TXT_SCALE.textScale, GlobalTextVariables.explodeOnCollision2Activatedxy.TextColor, false)
					updateHitCounterForExplodeOnCollision2()
				end
			end
			function updateHitCounterForExplodeOnCollision3()
				local currentTime = os.clock()
				if BruteForceComboCounter and currentTime - SuperPowersConfig.explodeOnCollisionConfig3.explodeOnCollision3Time < .38 then
					if not SuperPowersConfig.BruteForceConfig.lastIncrementTimeEoC then
						SuperPowersConfig.BruteForceConfig.lastIncrementTimeEoC = currentTime
					end
					if currentTime - SuperPowersConfig.BruteForceConfig.lastIncrementTimeEoC >= .066 then
						SuperPowersConfig.BruteForceConfig.hit_counter = SuperPowersConfig.BruteForceConfig.hit_counter + .069
						SuperPowersConfig.BruteForceConfig.hit_counter = math.min(SuperPowersConfig.BruteForceConfig.hit_counter, SuperPowersConfig.BruteForceConfig.Max_Hit_Counter)
						if SuperPowersConfig.BruteForceConfig.decrement_value then
							SuperPowersConfig.BruteForceConfig.decrement_value = SuperPowersConfig.BruteForceConfig.decrement_value - .0009
							SuperPowersConfig.BruteForceConfig.decrement_value = math.max(SuperPowersConfig.BruteForceConfig.decrement_value, 0)
						end
						SuperPowersConfig.BruteForceConfig.lastIncrementTimeEoC = currentTime
					end
				else
					SuperPowersConfig.BruteForceConfig.lastIncrementTimeEoC = nil
				end
			end
			function drawExplodeOnCollision3Activated()
				if os.clock() - SuperPowersConfig.explodeOnCollisionConfig3.explodeOnCollision3Time < .38 then
					directx.draw_text(GlobalTextVariables.explodeOnCollision3Activatedxy.x, GlobalTextVariables.explodeOnCollision3Activatedxy.y, "• Boom", ALIGN_CENTRE, CountTextUI.DR2_TXT_SCALE.textScale, GlobalTextVariables.explodeOnCollision3Activatedxy.TextColor, false)
					updateHitCounterForExplodeOnCollision3()
				end
			end
			function updateHitCounterForExplodeOnCollision4()
				local currentTime = os.clock()
				if BruteForceComboCounter and currentTime - SuperPowersConfig.explodeOnCollisionConfig4.explodeOnCollision4Time < .38 then
					if not SuperPowersConfig.BruteForceConfig.lastIncrementTimeEoC then
						SuperPowersConfig.BruteForceConfig.lastIncrementTimeEoC = currentTime
					end
					if currentTime - SuperPowersConfig.BruteForceConfig.lastIncrementTimeEoC >= .066 then
						SuperPowersConfig.BruteForceConfig.hit_counter = SuperPowersConfig.BruteForceConfig.hit_counter + .099
						SuperPowersConfig.BruteForceConfig.hit_counter = math.min(SuperPowersConfig.BruteForceConfig.hit_counter, SuperPowersConfig.BruteForceConfig.Max_Hit_Counter)
						if SuperPowersConfig.BruteForceConfig.decrement_value then
							SuperPowersConfig.BruteForceConfig.decrement_value = SuperPowersConfig.BruteForceConfig.decrement_value - .0004
							SuperPowersConfig.BruteForceConfig.decrement_value = math.max(SuperPowersConfig.BruteForceConfig.decrement_value, 0)
						end
						SuperPowersConfig.BruteForceConfig.lastIncrementTimeEoC = currentTime
					end
				else
					SuperPowersConfig.BruteForceConfig.lastIncrementTimeEoC = nil
				end
			end
			function drawExplodeOnCollision4Activated()
				if os.clock() - SuperPowersConfig.explodeOnCollisionConfig4.explodeOnCollision4Time < .38 then
					directx.draw_text(GlobalTextVariables.explodeOnCollision4Activatedxy.x, GlobalTextVariables.explodeOnCollision4Activatedxy.y, "• Oil", ALIGN_CENTRE, CountTextUI.DR2_TXT_SCALE.textScale, GlobalTextVariables.explodeOnCollision4Activatedxy.TextColor, false)
					updateHitCounterForExplodeOnCollision4()
				end
			end




			if scriptFns.isAnyPresetActive() then
				drawPresetActiveText()
			end
			
			drawTextLoop()
			drawHitCount()
			drawNewDriver()
			drawRemovedDriver()
			drawDestroyedVehicle()
			drawNPCJumpActivated()
			drawSuperHotActivated()
			drawBruteForceActivated()
			drawProximityHomingActivated()
			drawPlayerBruteForceActivated()
			drawExplodeOnCollisionActivated()
			drawExplodeOnCollision2Activated()
			drawExplodeOnCollision3Activated()
			drawExplodeOnCollision4Activated()
			drawPlayerProximityHomingActivated()
			for driver, vehicle in pairs(npcDrivers) do
				scriptFns.handleVehicleDestroyed(driver, vehicle)
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
		return functionSP
	end

	local SPscriptFns = SuperPowersFuncList()
		local function customTrafficLoop()
			while true do
				scriptFns.despawnDeadPeds()
				if PlayerVehiclesOnly then
					CTvars.targetVehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId), false)
					if CTvars.targetVehicle == 0 then
						-- Player is not in a vehicle, skip targeting
						if isDebugOn then
							util.toast("Player is on foot. NPC drivers will ignore.")
						end
						return
					else
						-- Ensure the target is the vehicle, not the player ped
						CTvars.targetPed = CTvars.targetVehicle
						if isDebugOn then
							util.toast("Targeting player-controlled vehicle.")
						end
					end
				end
				if ResetPresetsOn then
					isCustomTrafficOn = false
					SuperPowersConfig.SuperSpeedConfig.isSuperSpeedOn = false
					SuperPowersConfig.SuperSpeedConfig.isInvincibilityAndMissionEntityOn = false
					SuperPowersConfig.BruteForceConfig.isBruteForceOn = false
					isJumpCooldownOn = false
					SuperPowersConfig.PlayerBruteForceConfig.isPlayerBruteForceOn = false
					AudioSpam_isOn = false
					SuperPowersConfig.playerProximityConfig.isPlayerProximityHomingOn = false
					SuperPowersConfig.explodeOnCollisionConfig.isExplodeOnCollisionOn = false
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
					settings.GamerModeOn.isOn = false
					settings.ComboModeOn.isOn = false
					settings.SmashBrawlOn.isOn = false
					explosionInvisible = false
					explosionAudible = false
					SuperPowersConfig.ProximityHomingConfig.isProximityHomingOn = false
					SuperPowersConfig.DWGravityConfig.isDownwardsGravityOn = false
					isOn = false
					audioInvisible = true
					spamAudible = true
					onlyInVehicles = false
					SuperPowersConfig.ConditionsConfig.onlyInVehiclesEoC = false 
					SuperPowersConfig.ConditionsConfig.onlyInVehiclesAP = false
					explosionDistance = 3
					SuperPowersConfig.DWGravityConfig.downwards_force = -1.245
					SuperPowersConfig.DWGravityConfig.gravity_multiplier = 1
					SuperPowersConfig.SuperSpeedConfig.speedMultiplier = 1
					explosionType = 9
					explosionDamage = 1
					push_timer = 0.6
					push_cooldown = 15
					push_threshold = 20.0 
					push_force_multiplier = 25
					SuperPowersConfig.ProximityHomingConfig.proximity_push_timer = 0
					SuperPowersConfig.ProximityHomingConfig.proximity_push_cooldown = 85
					SuperPowersConfig.ProximityHomingConfig.proximity_push_threshold = 30 
					SuperPowersConfig.ProximityHomingConfig.proximity_push_force_multiplier = 1 
					SuperPowersConfig.ProximityHomingConfig.proximity_distance_threshold = 10 
					npcDriversCount = 25
					maxNpcDrivers = 25
					npcRange = 120
					npcDriversCountPrev = 0 
					bruteForceTime = 0 
					SuperPowersConfig.PlayerBruteForceConfig.playerbruteForceTime = 0
					SuperPowersConfig.ProximityHomingConfig.proximityHomingTime = 0
					playerProximityHomingTime = 0
					SuperPowersConfig.JumpCoreConfig.npcJumpTime = 0
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
					scriptFns.clearNPCDrivers()
					util.toast("Applied Clean Slate + Wiped previous existing NPCs . . . Disable me when you're done!")
				end
				if settings.ComboModeOn.isOn then
					isCustomTrafficOn = true
					SuperPowersConfig.ProximityHomingConfig.isProximityHomingOn = true
					isJumpCooldownOn = true
					SuperPowersConfig.PlayerBruteForceConfig.isPlayerBruteForceOn = true
					SuperPowersConfig.SuperSpeedConfig.isSuperSpeedOn = true
					SuperPowersConfig.BruteForceConfig.isBruteForceOn = true
					BruteForceComboCounter = true
					ProximityMPHMirroring = true
				end
				if settings.SmashBrawlOn.isOn then
					isCustomTrafficOn = true
					SuperPowersConfig.BruteForceConfig.isBruteForceOn = true
					BruteForceComboCounter = true
				end
				if settings.GamerModeOn.isOn then
					isCustomTrafficOn = true
					SuperPowersConfig.ProximityHomingConfig.isProximityHomingOn = true
					isJumpCooldownOn = true
					SuperPowersConfig.PlayerBruteForceConfig.isPlayerBruteForceOn = true
					SuperPowersConfig.explodeOnCollisionConfig.isExplodeOnCollisionOn = true
					SuperPowersConfig.audioSpamConfig.isAudioSpamOn = true
					SuperPowersConfig.SuperSpeedConfig.isSuperSpeedOn = true
					SuperPowersConfig.ConditionsConfig.onlyInVehiclesPH = true
					SuperPowersConfig.ConditionsConfig.onlyInVehiclesEoC = true
					SuperPowersConfig.ConditionsConfig.onlyInVehiclesAP = true
					SuperPowersConfig.ConditionsConfig.onlyInVehiclesJump = true
					SuperPowersConfig.ProximityHomingConfig.proximity_distance_threshold = 17
					SuperPowersConfig.PlayerBruteForceConfig.playerBruteForce_push_force_multiplier = 6
					explodeOnCollision_explosionType = math.random(64, 66)
				end
				if settings.CarPunchingNPCsOn.isOn then
					isCustomTrafficOn = true
					SuperPowersConfig.DWGravityConfig.isDownwardsGravityOn = true
					SuperPowersConfig.ProximityHomingConfig.isProximityHomingOn = true
					isJumpCooldownOn = true
					SuperPowersConfig.BruteForceConfig.isBruteForceOn = true
					SuperPowersConfig.PlayerBruteForceConfig.isPlayerBruteForceOn = true
					SuperPowersConfig.SuperSpeedConfig.isInvincibilityAndMissionEntityOn = true
					SuperPowersConfig.ProximityHomingConfig.proximity_distance_threshold = 100
				end
				if settings.RabidHomingNPCsOn.isOn then
					isCustomTrafficOn = true
					SuperPowersConfig.ProximityHomingConfig.isProximityHomingOn = true
					SuperPowersConfig.SuperSpeedConfig.isSuperSpeedOn = true
					SuperPowersConfig.DWGravityConfig.isDownwardsGravityOn = true
					SuperPowersConfig.ProximityHomingConfig.isProximityHomingOn = true
					SuperPowersConfig.BruteForceConfig.isBruteForceOn = true
					isJumpCooldownOn = true
					SuperPowersConfig.ProximityHomingConfig.proximity_distance_threshold = math.random(5, 10)
					SuperPowersConfig.ProximityHomingConfig.proximity_push_force_multiplier = 1 / 2 
					push_force_multiplier = math.random(5, 15)
					npcRange = 120
					maxNpcDrivers = 55
					RabidHomingNPCsTime = os.clock()
				end
				if settings.SpeedyNPCsOn.isOn then
					isCustomTrafficOn = true
					SuperPowersConfig.SuperSpeedConfig.isSuperSpeedOn = true
					SuperPowersConfig.DWGravityConfig.isDownwardsGravityOn = true
					SuperPowersConfig.BruteForceConfig.isBruteForceOn = true
					push_force_multiplier = math.random(1, 45)
					npcRange = 160
					maxNpcDrivers = 15
					SuperPowersConfig.SuperSpeedConfig.speedMultiplier = 8000
					SpeedyNPCsTime = os.clock()
				end
				if settings.FastNPCsOn.isOn then
					isCustomTrafficOn = true
					SuperPowersConfig.SuperSpeedConfig.isSuperSpeedOn = true
					AudioSpam_isOn = true
					npcRange = 140
					maxNpcDrivers = 55
					FastNPCsTime = os.clock()
				end
				if settings.BumperCarsOn.isOn then
					isCustomTrafficOn = true
					SuperPowersConfig.SuperSpeedConfig.isSuperSpeedOn = true
					SuperPowersConfig.BruteForceConfig.isBruteForceOn = true
					SuperPowersConfig.PlayerBruteForceConfig.isPlayerBruteForceOn = true
					push_force_multiplier = math.random(5, 35)
					SuperPowersConfig.PlayerBruteForceConfig.playerBruteForce_push_force_multiplier = math.random(5, 75)
					SuperPowersConfig.BruteForceConfig.push_cooldown = math.random(5, 15)
					SuperPowersConfig.PlayerBruteForceConfig.playerBruteForce_push_cooldown = math.random(0, 35)
					SuperPowersConfig.SuperSpeedConfig.speedMultiplier = 9000
					npcRange = 120
					maxNpcDrivers = 25
					BumperCarsTime = os.clock()
				end
				if settings.DemonicNPCsOn.isOn then
					isCustomTrafficOn = true
					SuperPowersConfig.SuperSpeedConfig.isSuperSpeedOn = true
					SuperPowersConfig.DWGravityConfig.isDownwardsGravityOn = true
					SuperPowersConfig.BruteForceConfig.isBruteForceOn = true
					SuperPowersConfig.ProximityHomingConfig.isProximityHomingOn = true
					isJumpCooldownOn = true
					SuperPowersConfig.SuperSpeedConfig.isInvincibilityAndMissionEntityOn = true
					SuperPowersConfig.PlayerBruteForceConfig.playerBruteForce_push_force_multiplier = math.random(1, 75)
					push_force_multiplier = math.random(5, 150)
					npcRange = 220
					maxNpcDrivers = 65
					max_height_difference_value = 3
					SuperPowersConfig.ProximityHomingConfig.proximity_distance_threshold = math.random(300, 750)
					SuperPowersConfig.ProximityHomingConfig.proximity_push_force_multiplier = math.random(15, 495)
					SuperPowersConfig.DWGravityConfig.downwards_force = math.random(-28, 12)
					DemonicNPCsTime = os.clock()
				end
				if settings.ExplosiveNPCsOn.isOn then
					isCustomTrafficOn = true
					SuperPowersConfig.SuperSpeedConfig.isSuperSpeedOn = true
					SuperPowersConfig.DWGravityConfig.isDownwardsGravityOn = true
					SuperPowersConfig.explodeOnCollisionConfig.isExplodeOnCollisionOn = true
					explodeOnCollision_explosionType = 65
					explodeOnCollision_explosionDistance = 7
					npcRange = 120
					maxNpcDrivers = 20
					ExplosiveNPCsTime = os.clock()
				end
				if settings.SpikeExplosiveNPCsOn.isOn then
					isCustomTrafficOn = true
					SuperPowersConfig.SuperSpeedConfig.isSuperSpeedOn = true
					SuperPowersConfig.DWGravityConfig.isDownwardsGravityOn = true
					SuperPowersConfig.explodeOnCollisionConfig.isExplodeOnCollisionOn = true
					explodeOnCollision_explosionType = 66
					explodeOnCollision_explosionDistance = 5
					npcRange = 120
					maxNpcDrivers = 20
					SpikeExplosiveNPCsTime = os.clock()
				end
				if settings.RandomExplosiveNPCsOn.isOn then
					isCustomTrafficOn = true
					SuperPowersConfig.SuperSpeedConfig.isSuperSpeedOn = true
					SuperPowersConfig.DWGravityConfig.isDownwardsGravityOn = true
					SuperPowersConfig.ProximityHomingConfig.isProximityHomingOn = true
					SuperPowersConfig.explodeOnCollisionConfig.isExplodeOnCollisionOn = true
					explodeOnCollision_explosionType = math.random(1, 75)
					explodeOnCollision_explosionDamage = math.random(0, 1)
					explodeOnCollision_explosionDistance = 17
					npcRange = 120
					maxNpcDrivers = 20
					RandomExplosiveNPCsTime = os.clock()
				end
				if settings.AnnoyingExplosiveNPCsOn.isOn then
					isCustomTrafficOn = true
					SuperPowersConfig.SuperSpeedConfig.isSuperSpeedOn = true
					SuperPowersConfig.DWGravityConfig.isDownwardsGravityOn = true
					SuperPowersConfig.explodeOnCollisionConfig.isExplodeOnCollisionOn = true
					explodeOnCollision_explosionType = math.random(64, 66)
					maxNpcDrivers = 35
					SuperPowersConfig.SuperSpeedConfig.speedMultiplier = 9000
				end
			
				if SuperPowersConfig.BruteForceConfig.isBruteForceOn and BruteForceComboCounter then
					SuperPowersConfig.SuperHotConfig.isSuperHotOn = true
					if SuperPowersConfig.BruteForceConfig.hit_counter > 1790 then
						maxNpcDrivers = 50
						SuperPowersConfig.audioSpamConfig2.IsAudioSpam2On = true
					elseif SuperPowersConfig.BruteForceConfig.hit_counter > 1750 then
						maxNpcDrivers = 45
						SuperPowersConfig.PlayerBruteForceConfig.isPlayerBruteForceOn = true
					elseif SuperPowersConfig.BruteForceConfig.hit_counter > 1500 then
						maxNpcDrivers = 40
						SuperPowersConfig.explodeOnCollisionConfig3.isExplodeOnCollisionOn3 = true
					elseif SuperPowersConfig.BruteForceConfig.hit_counter > 1350 then
						maxNpcDrivers = 38
						onlyInVehiclesEoC = true
						isJumpCooldownOn = true
					elseif SuperPowersConfig.BruteForceConfig.hit_counter > 1250 then
						maxNpcDrivers = 35
						SuperPowersConfig.playerProximityConfig.isPlayerProximityHomingOn = true
					elseif SuperPowersConfig.BruteForceConfig.hit_counter > 1150 then
						maxNpcDrivers = 30
						SuperPowersConfig.explodeOnCollisionConfig.isExplodeOnCollisionOn = true
					elseif SuperPowersConfig.BruteForceConfig.hit_counter > 950 then
						maxNpcDrivers = 28
						SuperPowersConfig.DWGravityConfig.isDownwardsGravityOn = true
					elseif SuperPowersConfig.BruteForceConfig.hit_counter > 825 then
						maxNpcDrivers = 26
						SuperPowersConfig.explodeOnCollisionConfig2.isExplodeOnCollisionOn2 = true
					elseif SuperPowersConfig.BruteForceConfig.hit_counter > 750 then
						maxNpcDrivers = 24
					elseif SuperPowersConfig.BruteForceConfig.hit_counter > 650 then
						maxNpcDrivers = 22
					elseif SuperPowersConfig.BruteForceConfig.hit_counter > 550 then
						maxNpcDrivers = 20
					elseif SuperPowersConfig.BruteForceConfig.hit_counter > 450 then
						maxNpcDrivers = 18
					elseif SuperPowersConfig.BruteForceConfig.hit_counter > 350 then
						maxNpcDrivers = 16
						SuperPowersConfig.audioSpamConfig.isAudioSpamOn = true
						SuperPowersConfig.SuperSpeedConfig.speedMultiplier = 7200
					elseif SuperPowersConfig.BruteForceConfig.hit_counter > 150 then
						maxNpcDrivers = 14
						SuperPowersConfig.ProximityHomingConfig.isProximityHomingOn = true
					elseif SuperPowersConfig.BruteForceConfig.hit_counter > 10 then
						maxNpcDrivers = 12
						SuperPowersConfig.explodeOnCollisionConfig4.isExplodeOnCollisionOn4 = true
						SuperPowersConfig.SuperSpeedConfig.isSuperSpeedOn = true
					end
					if SuperPowersConfig.BruteForceConfig.hit_counter < 1 then
						onlyInVehiclesEoC = false
						SuperPowersConfig.SuperSpeedConfig.speedMultiplier = 5000
						maxNpcDrivers = 10
						SuperPowersConfig.explodeOnCollisionConfig4.isExplodeOnCollisionOn4 = false
						SuperPowersConfig.explodeOnCollisionConfig3.isExplodeOnCollisionOn3 = false
						SuperPowersConfig.explodeOnCollisionConfig2.isExplodeOnCollisionOn2 = false
						SuperPowersConfig.explodeOnCollisionConfig.isExplodeOnCollisionOn = false
						isJumpCooldownOn = false
						SuperPowersConfig.DWGravityConfig.isDownwardsGravityOn = false
						SuperPowersConfig.audioSpamConfig2.IsAudioSpam2On = false
						SuperPowersConfig.JumpCoreConfig.isJumpCooldownOn = false
						SuperPowersConfig.audioSpamConfig.isAudioSpamOn = false
						SuperPowersConfig.SuperSpeedConfig.isSuperSpeedOn = false
						SuperPowersConfig.ProximityHomingConfig.isProximityHomingOn = false
						SuperPowersConfig.PlayerBruteForceConfig.isPlayerBruteForceOn = false
						SuperPowersConfig.playerProximityConfig.isPlayerProximityHomingOn = false
					end
				end
				if SuperPowersConfig.BruteForceConfig.hit_counter < -5 then
					maxNpcDrivers = 9
				end
				if SuperPowersConfig.BruteForceConfig.hit_counter < -10 then
					maxNpcDrivers = 8
				end
				if SuperPowersConfig.BruteForceConfig.hit_counter < -15 then
					maxNpcDrivers = 7
				end
				if SuperPowersConfig.BruteForceConfig.hit_counter < -25 then
					maxNpcDrivers = 6
				end
				if SuperPowersConfig.BruteForceConfig.hit_counter < -35 then
					maxNpcDrivers = 4
				end
				if SuperPowersConfig.BruteForceConfig.hit_counter < -48 then
					maxNpcDrivers = 3
				end
				if isJumpCooldownOn then
					if isDebugOn then
						util.toast("JumpCooldown internal loop activated.")
					end
					local JCDvars = {
						jumpElapsed = SuperPowersConfig.JumpCoreConfig.lastJump.elapsed(),
						cooldownValue = SuperPowersConfig.JumpCoreConfig.jump_cooldown_value,
						trafficOn = isCustomTrafficOn,
						targetPed = nil,
						driver = nil,
						force = nil
					}
					if JCDvars.jumpElapsed > JCDvars.cooldownValue and JCDvars.trafficOn then
					for pId = 0, 31 do
							JCDvars.targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
							if scriptFns.is_player_in_tough_spot(pId) then
								for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 150)) do
									JCDvars.driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1)
									if not PED.IS_PED_A_PLAYER(JCDvars.driver) then
										JCDvars.force = scriptFns.should_npc_jump(JCDvars.driver, JCDvars.targetPed)
										if JCDvars.force then
											request_control_once(vehicle)
											ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, JCDvars.force.x, JCDvars.force.y, JCDvars.force.z, 0.0, 0.0, 0.0, 0, false, false, true, false, false)
										end
									end
								end
							end
						end
						SuperPowersConfig.JumpCoreConfig.lastJump.reset()
					end
				end
				if SuperPowersConfig.ProximityHomingConfig.isProximityHomingOn then
					if isDebugOn then
						util.toast("ProximityHoming detected scanning for active nearby players.")
					end
					local PHvars = {
						trafficOn = isCustomTrafficOn,
						targetPed = nil,
						vehicleList = nil,
						driver = nil
					}
					for pId = 0, 31 do
						if PHvars.trafficOn then
							PHvars.targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
							PHvars.vehicleList = get_vehicles_in_player_range(pId, 20.0)
							for _, vehicle in ipairs(PHvars.vehicleList) do
								PHvars.driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
								if ENTITY.DOES_ENTITY_EXIST(PHvars.driver) and not PED.IS_PED_A_PLAYER(PHvars.driver) then
									SPscriptFns.proximityHoming(PHvars.driver, vehicle, PHvars.targetPed)
								end
							end
						end
					end
				end
				if SuperPowersConfig.SuperHotConfig.isSuperHotOn then
					if isDebugOn then
						util.toast("SuperHot detected scanning for active nearby players.")
					end
					local SHvars = {
						trafficOn = isCustomTrafficOn,
						targetPed = nil,
						vehicleList = nil,
						driver = nil
					}
					for pId = 0, 31 do
						if SHvars.trafficOn then
							SHvars.targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
							SHvars.vehicleList = get_vehicles_in_player_range(pId, 20.0)
							for _, vehicle in ipairs(SHvars.vehicleList) do
								SHvars.driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
								if ENTITY.DOES_ENTITY_EXIST(SHvars.driver) and not PED.IS_PED_A_PLAYER(SHvars.driver) then
									SPscriptFns.SuperHot(SHvars.driver, vehicle, SHvars.targetPed)
								end
							end
						end
					end
				end
				if SuperPowersConfig.playerProximityConfig.isPlayerProximityHomingOn then
					if isDebugOn then
						util.toast("PlayerProximityHoming detected scanning for active nearby players.")
					end
					local PPHvars = {
						trafficOn = isCustomTrafficOn,
						targetPed = nil,
						vehicleList = nil,
						driver = nil
					}
					for pId = 0, 31 do
						if PPHvars.trafficOn then
							PPHvars.targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
							PPHvars.vehicleList = get_vehicles_in_player_range(pId, 20.0)
							for _, vehicle in ipairs(PPHvars.vehicleList) do
								PPHvars.driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
								if ENTITY.DOES_ENTITY_EXIST(PPHvars.driver) and not PED.IS_PED_A_PLAYER(PPHvars.driver) then
									SPscriptFns.playerProximityHoming(PPHvars.driver, vehicle, PPHvars.targetPed)
								end
							end
						end
					end
				end
				if SuperPowersConfig.explodeOnCollisionConfig.isExplodeOnCollisionOn then
					local speedMPH = scriptFns.getPlayerSpeedMPH(pId)
					if speedMPH > 0 then
						SuperPowersConfig.explodeOnCollisionConfig.explodeOnCollisionCheckFrequency = math.max(10, 100 - speedMPH)
					else
						SuperPowersConfig.explodeOnCollisionConfig.explodeOnCollisionCheckFrequency = 150
					end
					SuperPowersConfig.explodeOnCollisionConfig.explodeOnCollisionCounter = SuperPowersConfig.explodeOnCollisionConfig.explodeOnCollisionCounter + 9
					if SuperPowersConfig.explodeOnCollisionConfig.explodeOnCollisionCounter >= SuperPowersConfig.explodeOnCollisionConfig.explodeOnCollisionCheckFrequency then
						for pId = 0, 31 do
							if isCustomTrafficOn then
								SPscriptFns.explodeOnCollisionEffect(pId)
							end
						end
						SuperPowersConfig.explodeOnCollisionConfig.explodeOnCollisionCounter = 0
					end
				end
				if SuperPowersConfig.explodeOnCollisionConfig2.isExplodeOnCollisionOn2 then
					local speedMPH = scriptFns.getPlayerSpeedMPH(pId)
					if speedMPH > 0 then
						SuperPowersConfig.explodeOnCollisionConfig2.explodeOnCollisionCheckFrequency = math.max(10, 100 - speedMPH)
					else
						SuperPowersConfig.explodeOnCollisionConfig2.explodeOnCollisionCheckFrequency = 150
					end
					SuperPowersConfig.explodeOnCollisionConfig2.explodeOnCollisionCounter = SuperPowersConfig.explodeOnCollisionConfig2.explodeOnCollisionCounter + 9
					if SuperPowersConfig.explodeOnCollisionConfig2.explodeOnCollisionCounter >= SuperPowersConfig.explodeOnCollisionConfig2.explodeOnCollisionCheckFrequency then
						for pId = 0, 31 do
							if isCustomTrafficOn then
								SPscriptFns.explodeOnCollisionEffect2(pId)
							end
						end
						SuperPowersConfig.explodeOnCollisionConfig2.explodeOnCollisionCounter = 0
					end
				end
				if SuperPowersConfig.explodeOnCollisionConfig3.isExplodeOnCollisionOn3 then
					local speedMPH = scriptFns.getPlayerSpeedMPH(pId)
					if speedMPH > 0 then
						SuperPowersConfig.explodeOnCollisionConfig3.explodeOnCollisionCheckFrequency3 = math.max(10, 100 - speedMPH)
					else
						SuperPowersConfig.explodeOnCollisionConfig3.explodeOnCollisionCheckFrequency3 = 150
					end
					SuperPowersConfig.explodeOnCollisionConfig3.explodeOnCollisionCounter3 = SuperPowersConfig.explodeOnCollisionConfig3.explodeOnCollisionCounter3 + 9
					if SuperPowersConfig.explodeOnCollisionConfig3.explodeOnCollisionCounter3 >= SuperPowersConfig.explodeOnCollisionConfig3.explodeOnCollisionCheckFrequency3 then
						for pId = 0, 31 do
							if isCustomTrafficOn then
								SPscriptFns.explodeOnCollisionEffect3(pId)
							end
						end
						SuperPowersConfig.explodeOnCollisionConfig3.explodeOnCollisionCounter3 = 0
					end
				end
				if SuperPowersConfig.explodeOnCollisionConfig4.isExplodeOnCollisionOn4 then
					local speedMPH = scriptFns.getPlayerSpeedMPH(pId)
					if speedMPH > 0 then
						SuperPowersConfig.explodeOnCollisionConfig4.explodeOnCollisionCheckFrequency4 = math.max(10, 100 - speedMPH)
					else
						SuperPowersConfig.explodeOnCollisionConfig4.explodeOnCollisionCheckFrequency4 = 150
					end
					SuperPowersConfig.explodeOnCollisionConfig4.explodeOnCollisionCounter4 = SuperPowersConfig.explodeOnCollisionConfig4.explodeOnCollisionCounter4 + 9
					if SuperPowersConfig.explodeOnCollisionConfig4.explodeOnCollisionCounter4 >= SuperPowersConfig.explodeOnCollisionConfig4.explodeOnCollisionCheckFrequency4 then
						for pId = 0, 31 do
							if isCustomTrafficOn then
								SPscriptFns.explodeOnCollisionEffect4(pId)
							end
						end
						SuperPowersConfig.explodeOnCollisionConfig4.explodeOnCollisionCounter4 = 0
					end
				end
				if SuperPowersConfig.audioSpamConfig.isAudioSpamOn then
					for pId = 0, 31 do
						if isCustomTrafficOn then
							SPscriptFns.audioSpamEffect(pId)
						end
					end
				end
				if SuperPowersConfig.audioSpamConfig2.IsAudioSpam2On then
					local AS2vars = {
						trafficOn = isCustomTrafficOn,
						targetPed = nil,
						vehicleList = nil,
						driver = nil,
						vehicleCoords = nil,
						targetPedCoords = nil,
						distance_to_player = nil,
						explosionCoords = nil
					}
					for pId = 0, 31 do
						if AS2vars.trafficOn then
							AS2vars.targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
							AS2vars.vehicleList = get_vehicles_in_player_range(pId, 150.0)
							for _, vehicle in ipairs(AS2vars.vehicleList) do
								AS2vars.driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
								if ENTITY.DOES_ENTITY_EXIST(AS2vars.driver) and not PED.IS_PED_A_PLAYER(AS2vars.driver) then
									AS2vars.vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
									AS2vars.targetPedCoords = ENTITY.GET_ENTITY_COORDS(AS2vars.targetPed, true)
									AS2vars.distance_to_player = calculate_distance(AS2vars.vehicleCoords.x, AS2vars.vehicleCoords.y, AS2vars.vehicleCoords.z, AS2vars.targetPedCoords.x, AS2vars.targetPedCoords.y, AS2vars.targetPedCoords.z)
									if AS2vars.distance_to_player <= SuperPowersConfig.audioSpamConfig2.AP2TriggerDistance then --AP
										AS2vars.explosionCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
										FIRE.ADD_EXPLOSION(AS2vars.explosionCoords.x, AS2vars.explosionCoords.y, AS2vars.explosionCoords.z, SuperPowersConfig.audioSpamConfig2.AP2audioType, SuperPowersConfig.audioSpamConfig2.AP2audioDamage, SuperPowersConfig.audioSpamConfig2.AP2spamAudible, SuperPowersConfig.audioSpamConfig2.AP2audioInvisible, 1321.0, false)
									end
								end
							end
						end
					end
				end
				if SuperPowersConfig.BruteForceConfig.isBruteForceOn then
					SuperPowersConfig.BruteForceConfig.bruteForceCounter = SuperPowersConfig.BruteForceConfig.bruteForceCounter + 1
					if SuperPowersConfig.BruteForceConfig.bruteForceCounter >= SuperPowersConfig.BruteForceConfig.bruteForceCheckFrequency then
						for pId = 0, 31 do
							if isCustomTrafficOn then
								SPscriptFns.SmashBrawl(pId)
							end
						end
						SuperPowersConfig.BruteForceConfig.bruteForceCounter = 0
					end
				end
				if SuperPowersConfig.OGBruteForceConfig.isOGBruteForceOn then
					for pId = 0, 31 do
						if isCustomTrafficOn then
							SPscriptFns.bruteForceEffect(pId)
						end
					end
				end
				if SuperPowersConfig.PlayerBruteForceConfig.isPlayerBruteForceOn then
					for pId = 0, 31 do
						if isCustomTrafficOn then
							SPscriptFns.playerBruteForceEffect(pId)
						end
					end
				end
				--sb
				if os.clock() - SuperPowersConfig.BruteForceConfig.last_toast_display_time >= 2 then
					if #SuperPowersConfig.BruteForceConfig.toast_queue > 0 then
						local message = SuperPowersConfig.BruteForceConfig.toast_queue[#SuperPowersConfig.BruteForceConfig.toast_queue]
						util.toast(message)
						SuperPowersConfig.BruteForceConfig.toast_queue = {}
						SuperPowersConfig.BruteForceConfig.last_toast_display_time = os.clock()
					end
				end
				if os.clock() - SuperPowersConfig.BruteForceConfig.last_decrement_time >= 0.066 then
					if SuperPowersConfig.BruteForceConfig.hit_counter > 0 then
						SuperPowersConfig.BruteForceConfig.hit_counter = SuperPowersConfig.BruteForceConfig.hit_counter - SuperPowersConfig.BruteForceConfig.decrement_value
						SuperPowersConfig.BruteForceConfig.decrement_value = SuperPowersConfig.BruteForceConfig.decrement_value + 9.99e-4
					-- Exclude decrement logic when hit_counter is negative
					elseif SuperPowersConfig.BruteForceConfig.hit_counter < 0 and SuperPowersConfig.BruteForceConfig.hit_counter > -50 then
						-- Leave hit_counter as it is
					end
				
					if math.abs(SuperPowersConfig.BruteForceConfig.hit_counter) < (SuperPowersConfig.BruteForceConfig.decrement_value / 2) then
						SuperPowersConfig.BruteForceConfig.hit_counter = 0
					end
				
					SuperPowersConfig.BruteForceConfig.hit_counter = math.min(math.max(SuperPowersConfig.BruteForceConfig.hit_counter, -50), SuperPowersConfig.BruteForceConfig.Max_Hit_Counter)
				
					SuperPowersConfig.BruteForceConfig.last_decrement_time = os.clock()
					SuperPowersConfig.BruteForceConfig.decrement_tracker = SuperPowersConfig.BruteForceConfig.decrement_value
				
					if SuperPowersConfig.BruteForceConfig.hit_counter <= SuperPowersConfig.BruteForceConfig.HitcountStabalizer and not SuperPowersConfig.BruteForceConfig.hit_counter_reset then
						SuperPowersConfig.BruteForceConfig.hit_counter_reset = true
						SuperPowersConfig.BruteForceConfig.decrement_tracker = 0
					elseif SuperPowersConfig.BruteForceConfig.hit_counter > 0 then
						SuperPowersConfig.BruteForceConfig.hit_counter_reset = false
					end
				end
				
				if SuperPowersConfig.BruteForceConfig.isBruteForceRapidAddOn then
					if os.clock() - SuperPowersConfig.BruteForceConfig.last_rapid_add_time >= 6.6e-4 then
						SuperPowersConfig.BruteForceConfig.hit_counter = SuperPowersConfig.BruteForceConfig.hit_counter + 3.3e-1
						SuperPowersConfig.BruteForceConfig.hit_counter = math.min(SuperPowersConfig.BruteForceConfig.hit_counter, SuperPowersConfig.BruteForceConfig.Max_Hit_Counter)
						SuperPowersConfig.BruteForceConfig.last_rapid_add_time = os.clock()
					end
				end
				if SuperPowersConfig.BruteForceConfig.isBruteForceRapidAdd2On then
					if os.clock() - SuperPowersConfig.BruteForceConfig.last_rapid_add_time >= 6.6e-4 then
						SuperPowersConfig.BruteForceConfig.hit_counter = SuperPowersConfig.BruteForceConfig.hit_counter + 3.33
						SuperPowersConfig.BruteForceConfig.hit_counter = math.min(SuperPowersConfig.BruteForceConfig.hit_counter, SuperPowersConfig.BruteForceConfig.Max_Hit_Counter)
						SuperPowersConfig.BruteForceConfig.last_rapid_add_time = os.clock()
					end
				end
				if SuperPowersConfig.BruteForceConfig.isBruteForceRapidSubtractOn then
					if os.clock() - SuperPowersConfig.BruteForceConfig.last_rapid_add_time >= 6.6e-4 then
						SuperPowersConfig.BruteForceConfig.hit_counter = SuperPowersConfig.BruteForceConfig.hit_counter - 2.66
						SuperPowersConfig.BruteForceConfig.hit_counter = math.min(SuperPowersConfig.BruteForceConfig.hit_counter, SuperPowersConfig.BruteForceConfig.Max_Hit_Counter)
						SuperPowersConfig.BruteForceConfig.last_rapid_add_time = os.clock()
					end
				end
				if SuperPowersConfig.BruteForceConfig.isBruteForceRapidSubtract2On then
					if os.clock() - SuperPowersConfig.BruteForceConfig.last_rapid_add_time >= 6.6e-4 then
						SuperPowersConfig.BruteForceConfig.hit_counter = SuperPowersConfig.BruteForceConfig.hit_counter - 12.66
						SuperPowersConfig.BruteForceConfig.hit_counter = math.min(SuperPowersConfig.BruteForceConfig.hit_counter, SuperPowersConfig.BruteForceConfig.Max_Hit_Counter)
						SuperPowersConfig.BruteForceConfig.last_rapid_add_time = os.clock()
					end
				end
				if SuperPowersConfig.BruteForceConfig.isIncrementDecrementValueOn then
					if os.clock() - SuperPowersConfig.BruteForceConfig.last_decrement_adjust_time >= 6.6e-4 then
						SuperPowersConfig.BruteForceConfig.decrement_value = SuperPowersConfig.BruteForceConfig.decrement_value + 4e-4
						SuperPowersConfig.BruteForceConfig.last_decrement_adjust_time = os.clock()
					end
				end
				if SuperPowersConfig.BruteForceConfig.isDecrementDecrementValueOn then
					if os.clock() - SuperPowersConfig.BruteForceConfig.last_decrement_adjust_time >= 6.6e-4 then
						if SuperPowersConfig.BruteForceConfig.decrement_value > 1e-4 then
							SuperPowersConfig.BruteForceConfig.decrement_value = SuperPowersConfig.BruteForceConfig.decrement_value - 1.6e-3
						else
							SuperPowersConfig.BruteForceConfig.decrement_value = 0
						end
						SuperPowersConfig.BruteForceConfig.last_decrement_adjust_time = os.clock()
					end
				end
				--ctl
				if os.time() - lastDisplayTime >= 3.3 then
					if next(targetedUsernames) ~= nil then  -- Check if the table is not empty
						local usernamesStr = ""
						for playerName, count in pairs(targetedUsernames) do
							if count <= maxNpcDrivers then
								usernamesStr = usernamesStr .. count .. "->" .. playerName .. ", "
							else
								usernamesStr = usernamesStr .. playerName .. ", "
							end
						end
						-- Remove the last comma and space
						usernamesStr = usernamesStr:sub(1, -3)
						util.toast("Added NPCDrivers: " .. usernamesStr)
						targetedUsernames = {}  -- Reset the table
					end
					lastDisplayTime = os.time()
				end
				if isCustomTrafficOn then
					if isDebugOn then
						util.toast("isCustomTrafficOn internal loop activated.")
					end
					for pId = 0, 31 do
						SPscriptFns.customTraffic(pId)
					end
					for driver, vehicle in pairs(npcDrivers) do
						SPscriptFns.applySuperPowers(driver, vehicle)
						scriptFns.applyDownwardForce(vehicle)
						if VEHICLE.IS_VEHICLE_DRIVEABLE(vehicle, false) == false or ENTITY.IS_ENTITY_DEAD(vehicle) then
							local attacker = ENTITY.GET_ENTITY_ATTACHED_TO(vehicle)
							if ENTITY.DOES_ENTITY_EXIST(attacker) then
								ENTITY.DETACH_ENTITY(vehicle, true, true)
							end
							entities.delete(vehicle)
							npcDrivers[driver] = nil
							lastVehicleDeletionTime = os.clock()
						end
					end
					SPscriptFns.removeExcessNPCDrivers()
				end
				local timeControlVars = {
					currentTime = os.time(),
					lastCheck = lastCheckTime,
					callThreshold = 17,
					extraCalls = 0,
					sleepDuration = 0
				}
				if timeControlVars.currentTime - timeControlVars.lastCheck >= 1 then
					if callCount > timeControlVars.callThreshold then
						timeControlVars.extraCalls = callCount - timeControlVars.callThreshold
						timeControlVars.sleepDuration = math.min(12, timeControlVars.extraCalls * 2)
						util.yield(timeControlVars.sleepDuration)
					else
						util.yield(0)
					end
					callCount = 0
					timeControlVars.lastCheck = timeControlVars.currentTime
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
				scriptFns.deleteDestroyedVehicles()	
				scriptFns.clearNPCDrivers()
				util.toast("--==[[Custom traffic has been disabled. Previously Controlled NPCDrivers have been removed]]==--")
			end
		end
		local function DebugToggle(on)
			isDebugOn = on
		end
		local function ManualDebugToggle(on)
			isManualDebugOn = on
		end
		local CustomTrafficLoop = menu.toggle(ChaoticOpt, translate("Ultimate Custom Traffic", "CTL | Custom Traffic | On/Off •"), {}, "Turns on/off the default Custom Traffic system. When enabled, it manages how NPCDrivers will target players, based on your customized settings within CTL Customs.", customTrafficToggle, false)
		local customTrafficOpt = menu.list(CTLCustomsXT, translate("Trolling", "Depriciated features"), {}, "Leftovers / extra space for future features")
		local Debug = menu.toggle(CTLCustomsXT, translate("Menu Debugger - Watch the script run in realtime", "Menu Debugger"), {}, false, DebugToggle)
		local ManualDebug = menu.toggle(CTLCustomsXT, translate("Menu Manual Debugger - Watch the script run in realtime", "Menu Manual Debugger"), {}, false, ManualDebugToggle)
		local npcDriversSlider = menu.slider(CTLCustoms, translate("Ultimate Custom Traffic", "MAX NPC Drivers • >"), {}, "Warning - Custom Traffic needs to be enabled for these to take effect! Control the amount of NPC Drivers you want chasing the player, decreasing the number deletes NPCs based on the value to save FPS", 0, 126, 25, 1, function(value) maxNpcDrivers = value SPscriptFns.removeExcessNPCDrivers() end)
		local npcRangeSlider = menu.slider(CTLCustoms, translate("Ultimate Custom Traffic", "NPC Attraction Range • >"), {}, "Warning - Custom Traffic needs to be enabled for these to take effect! Set your own custom range for how far from the player NPCs will become reaped for control, go wild.", 20, 460, 120, 10, function(value) npcRange = value end)
		local blipTypeSlider = menu.slider(CTLCustomsXT, translate("Blip Type Selector", "Select NPC Blip Type • >"), {}, "Select the type of blip that will be displayed on your Mini-Map for NPCDrivers.",1, #blipTypes, defaultBlipIndex, 1, function(index) currentBlipType = blipTypes[index] end)
		local CTLPresets <const> = menu.list(menu.player_root(pId), translate("Trolling", "• CTL Presets •"), {}, "Dont feel like customizing NPC Super powers right now? Try out a few pre-made presets to see whats possible at a glance | Tip: Don't be afraid to turn multiple presets on at once, every preset has SPECIAL abilities, that can be overlapped into other presets, just turn all corrsponding presets with powers you want on, then leave the final most powerful preset ON for highest NPC and PC preformance - turning all the weakest presets off except one. Dont worry, the settings wont undo unless they are overwritten / reset to default by you.")
		local CTLSpecials = menu.list(ChaoticOpt, translate("Trolling", "CTL Special Settings • >"), {}, "[Alpha - WIP] Apply special super powers that dont exist in native CTL Super powers. These settings give NPCs / Players special specific abilities.")
		menu.toggle(CTLSpecials, "Player Vehicles Only", {}, "When enabled, NPC drivers target player-controlled vehicles instead of players.", function(state)
			PlayerVehiclesOnly = state
		end)
		WorldClear = menu.action(ChaoticOpt, "[{World Clear}]", {}, "Performs a clearing action by temporarily freezing the GTA Client for .7 seconds, spamming 10 delete functions, then unfreezing the client - in order to maximize entities cleared.", function()
			local WCVars = { 
				start = os.clock(), 
				interval = .7,
				deletedentities = 0,
				RAC = memory.alloc(4) 
			}
			local allEntities = {}
			for _, ent in ipairs(entities.get_all_vehicles_as_handles()) do table.insert(allEntities, ent) end
			for _, ent in ipairs(entities.get_all_peds_as_handles()) do table.insert(allEntities, ent) end
			for _, ent in ipairs(entities.get_all_objects_as_handles()) do table.insert(allEntities, ent) end
			for _, ent in ipairs(allEntities) do
				if not PED.IS_PED_A_PLAYER(ent) then
					entities.delete(ent)
					WCVars.deletedentities = WCVars.deletedentities + 1
				end
			end
			for i = 0, 100 do
				memory.write_int(WCVars.RAC, i)
				if PHYSICS.DOES_ROPE_EXIST(WCVars.RAC) then
					PHYSICS.DELETE_ROPE(WCVars.RAC)
					WCVars.deletedentities = WCVars.deletedentities + 1
				end
			end
			repeat until os.clock() - WCVars.start >= WCVars.interval
			util.toast("World Clear Complete. Entities Cleared: " .. WCVars.deletedentities)
		end)
		local moreToolslist = menu.list(customTrafficOpt, translate("Ultimate Custom Traffic", "More Tools / Options •     >"), {}, "Go crazy, go stupid.")
		local NPCPowers = menu.list(superPowersMenu, translate("Ultimate Custom Traffic", "NPC Powers •     >"), {}, "Warning - Custom Traffic On/Off needs to be enabled for these to take effect! Powers within this tab will apply to NPCDrivers and Chaotic Drivers.")
		local customizeNPCPowers = menu.list(NPCPowers, translate("Ultimate Custom Traffic", "Customize NPC Powers •     >"), {}, "Warning - Custom Traffic needs to be enabled for these to take effect!")
		local PlayerPower = menu.list(superPowersMenu, translate("Ultimate Custom Traffic", "Player Powers •     >"), {}, "Warning - Custom Traffic On/Off needs to be enabled for these to take effect! Powers within this tab will apply to Players and their cars.")
		local customizePlayerPower = menu.list(PlayerPower, translate("Ultimate Custom Traffic", "Customize Player Powers •     >"), {}, "Warning - Custom Traffic needs to be enabled for these to take effect! Please note: These settings only need to be configured once per lobby IF you apply them to yourself and spectate OTHER players. CTL will iterate THROUGH whoever has CTL enabled, so it's recommended to apply them to yourself and sit offmap / in the ocean, then spectate people and watch the chaos start around them as CTL iterates through you!")
		local CTLVehConditions = menu.list(NPCPowers, translate("Trolling", "NPCDrivers Target Vehicles Only"), {}, "Warning - Custom Traffic and Super Powers need to be enabled for these to take effect! Enable specific Super Power conditions to prioritize targetting only players in vehicles.")
		



		local function customExplosionFunction()
			local CEVars = {
				customExplosion = menu.list(customExplosions, translate("Trolling", "[Spinning Explosion]"), {}, ""),
				Explosion = {
					audible = false,
					delay = 0,
					owned = false,
					type = 64,
					invisible = false,
					doesNoDamage = false,
					xOffset = 0,
					yOffset = 0,
					zOffset = -1.0,
					explosionScale = 500000,
					currentAngle = 0,
					explosionDistance = 2,
					verticalExplosionOffset = -1
				},
				usingExplosionLoop = false,
				distance = function(pos1, pos2)
					return math.sqrt((pos2.x - pos1.x)^2 + (pos2.y - pos1.y)^2 + (pos2.z - pos1.z)^2)
				end
			}
			function CEVars.Explosion:explodePlayer(pId)
				local CEV = {
					pos = players.get_position(pId),
					explosionPos = nil,
					angle = nil,
					explosionDistance = self.explosionDistance,
					explosionX = nil,
					explosionY = nil,
					explosionZ = nil
				}
				for i = 1, 36 do
					CEV.angle = math.rad(self.currentAngle + (i - 1) * 10)
					CEV.explosionX = CEV.pos.x + CEV.explosionDistance * math.cos(CEV.angle)
					CEV.explosionY = CEV.pos.y + CEV.explosionDistance * math.sin(CEV.angle)
					CEV.explosionZ = CEV.pos.z + self.verticalExplosionOffset
					CEV.explosionPos = v3(CEV.explosionX, CEV.explosionY, CEV.explosionZ)
					if self.owned then
						self:addOwnedExplosion(CEV.explosionPos)
					else
						self:addExplosion(CEV.explosionPos)
					end
					self.currentAngle = (self.currentAngle + 30) % 360
				end
			end
			function CEVars.Explosion:addOwnedExplosion(pos)
				local CEV = {
					playerPos = players.get_position(players.user_ped()),
					dist = nil,
					explosionScale = nil
				}
				CEV.dist = CEVars.distance(CEV.playerPos, pos)
				CEV.explosionScale = math.max(self.explosionScale, 1 - CEV.dist * 0.1)
				FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z, self.type, CEV.explosionScale, self.audible, self.invisible, 0.0)
			end
			function CEVars.Explosion:addExplosion(pos)
				local CEV = {
					playerPos = players.get_position(players.user_ped()),
					dist = nil,
					explosionScale = nil
				}
				CEV.dist = CEVars.distance(CEV.playerPos, pos)
				CEV.explosionScale = math.max(self.explosionScale, 1 - CEV.dist * 0.1)
				FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, self.type, CEV.explosionScale, self.audible, self.invisible, 0.0, false)
			end
			menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Type"), {}, "", 0, 72, 64, 1, function(value) CEVars.Explosion.type = value end)
			menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Distance"), {}, "", 0, 100, 2, 1, function(value) CEVars.Explosion.explosionDistance = value end)
			menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Scale"), {}, "", 0, 100000, 68000, 1000, function(value) CEVars.Explosion.explosionScale = value / 100000 end)
			menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Vertical Explosion Offset"), {}, "", -50, 50, -1, 1, function(value) CEVars.Explosion.verticalExplosionOffset = value end)
			menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Invisible]"), {}, "", function(on) CEVars.Explosion.invisible = on end)
			menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Silent]"), {}, "", function(on) CEVars.Explosion.audible = not on end)
			menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Harmless Explosions]"), {}, "", function(on) CEVars.Explosion.doesNoDamage = on end)
			menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Explosion Loop] •"), {}, "", function(on)
				CEVars.usingExplosionLoop = on
				while CEVars.usingExplosionLoop and not util.is_session_transition_active() do
					CEVars.Explosion:explodePlayer(pId)
					CEVars.Explosion.currentAngle = (CEVars.Explosion.currentAngle + 300) % 360 
					util.yield(CEVars.Explosion.delay)
				end
			end)
			menu.action(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Trigger Explosion"), {}, "", function()
				CEVars.Explosion:explodePlayer(pId)
			end)			
		end
		customExplosionFunction()

		local function customSExplosionFunction()
			local CEVars = {
				customExplosion = menu.list(customExplosions, translate("Trolling", "[Spiral Explosion]"), {}, ""),
				Explosion = {
					audible = false,
					delay = 0,
					owned = false,
					type = 59,
					invisible = false,
					doesNoDamage = false,
					xOffset = 0,
					yOffset = 0,
					zOffset = -1.0,
					explosionScale = 100000,
					currentAngle = 0,
					explosionDistance = 39,
					verticalExplosionOffset = 0
				},
				usingExplosionLoop = false,
				distance = function(pos1, pos2)
					return math.sqrt((pos2.x - pos1.x)^2 + (pos2.y - pos1.y)^2 + (pos2.z - pos1.z)^2)
				end
			}
			function CEVars.Explosion:explodePlayer(pId)
				local CEV = {
					pos = players.get_position(pId),
					explosionPos = nil,
					angle = nil,
					explosionDistance = self.explosionDistance,
					explosionX = nil,
					explosionY = nil,
					explosionZ = nil
				}
				for i = 1, 36 do
					CEV.angle = math.rad(self.currentAngle + (i - 1) * 10)
					CEV.explosionX = CEV.pos.x + CEV.explosionDistance * math.cos(CEV.angle)
					CEV.explosionY = CEV.pos.y + CEV.explosionDistance * math.sin(CEV.angle)
					CEV.explosionZ = CEV.pos.z + self.verticalExplosionOffset
					CEV.explosionPos = v3(CEV.explosionX, CEV.explosionY, CEV.explosionZ)
					if self.owned then
						self:addOwnedExplosion(CEV.explosionPos)
					else
						self:addExplosion(CEV.explosionPos)
					end
					self.currentAngle = (self.currentAngle + 1) % 360
				end
			end
			function CEVars.Explosion:addOwnedExplosion(pos)
				local CEV = {
					playerPos = players.get_position(players.user_ped()),
					dist = nil,
					explosionScale = nil
				}
				CEV.dist = CEVars.distance(CEV.playerPos, pos)
				CEV.explosionScale = math.max(self.explosionScale, 1 - CEV.dist * 0.1)
				FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z, self.type, CEV.explosionScale, self.audible, self.invisible, 0.0)
			end
			function CEVars.Explosion:addExplosion(pos)
				local CEV = {
					playerPos = players.get_position(players.user_ped()),
					dist = nil,
					explosionScale = nil
				}
				CEV.dist = CEVars.distance(CEV.playerPos, pos)
				CEV.explosionScale = math.max(self.explosionScale, 1 - CEV.dist * 0.1)
				FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, self.type, CEV.explosionScale, self.audible, self.invisible, 0.0, false)
			end
			menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Type"), {}, "", 0, 72, 59, 1, function(value) CEVars.Explosion.type = value end)
			menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Distance"), {}, "", 0, 100, 39, 1, function(value) CEVars.Explosion.explosionDistance = value end)
			menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Scale"), {}, "", 0, 100000, 100000, 1000, function(value) CEVars.Explosion.explosionScale = value / 100000 end)
			menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Vertical Explosion Offset"), {}, "", -50, 50, 0, 1, function(value) CEVars.Explosion.verticalExplosionOffset = value end)
			menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Invisible]"), {}, "", function(on) CEVars.Explosion.invisible = on end)
			menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Silent]"), {}, "", function(on) CEVars.Explosion.audible = not on end)
			menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Harmless Explosions]"), {}, "", function(on) CEVars.Explosion.doesNoDamage = on end)
			menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Explosion Loop] •"), {}, "", function(on)
				CEVars.usingExplosionLoop = on
				while CEVars.usingExplosionLoop and not util.is_session_transition_active() do
					CEVars.Explosion:explodePlayer(pId)
					CEVars.Explosion.currentAngle = (CEVars.Explosion.currentAngle + 300) % 360 
					util.yield(CEVars.Explosion.delay)
				end
			end)
			menu.action(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Trigger Explosion"), {}, "", function()
				CEVars.Explosion:explodePlayer(pId)
			end)			
		end
		customSExplosionFunction()


		local function customS1ExplosionFunction()
			local CEVars = {
				customExplosion = menu.list(customExplosions, translate("Trolling", "[Solar Explosion]"), {}, ""),
				Explosion = {
					audible = false,
					delay = 0,
					owned = false,
					type = 59,
					invisible = false,
					doesNoDamage = false,
					xOffset = 0,
					yOffset = 0,
					zOffset = -1.0,
					explosionScale = 100000,
					currentAngle = 0,
					explosionDistance = 39,
					verticalExplosionOffset = 0
				},
				usingExplosionLoop = false,
				distance = function(pos1, pos2)
					return math.sqrt((pos2.x - pos1.x)^2 + (pos2.y - pos1.y)^2 + (pos2.z - pos1.z)^2)
				end
			}
			function CEVars.Explosion:explodePlayer(pId)
				local CEV = {
					pos = players.get_position(pId),
					explosionPos = nil,
					angle = nil,
					explosionDistance = self.explosionDistance,
					explosionX = nil,
					explosionY = nil,
					explosionZ = nil,
					verticalStep = 360 / 36
				}
				for i = 1, 36 do
					CEV.angle = math.rad(self.currentAngle + (i - 1) * 10)
					CEV.explosionX = CEV.pos.x + CEV.explosionDistance * math.cos(CEV.angle)
					CEV.explosionY = CEV.pos.y + CEV.explosionDistance * math.sin(CEV.angle)
					local verticalAngle = math.rad((self.currentAngle + (i - 1) * CEV.verticalStep) % 360)
					CEV.explosionZ = CEV.pos.z + self.verticalExplosionOffset + math.sin(verticalAngle) * self.explosionDistance
					CEV.explosionPos = v3(CEV.explosionX, CEV.explosionY, CEV.explosionZ)
					if self.owned then
						self:addOwnedExplosion(CEV.explosionPos)
					else
						self:addExplosion(CEV.explosionPos)
					end
					self.currentAngle = (self.currentAngle + 1) % 360
				end
			end
			function CEVars.Explosion:addOwnedExplosion(pos)
				local CEV = {
					playerPos = players.get_position(players.user_ped()),
					dist = nil,
					explosionScale = nil
				}
				CEV.dist = CEVars.distance(CEV.playerPos, pos)
				CEV.explosionScale = math.max(self.explosionScale, 1 - CEV.dist * 0.1)
				FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z, self.type, CEV.explosionScale, self.audible, self.invisible, 0.0)
			end
			function CEVars.Explosion:addExplosion(pos)
				local CEV = {
					playerPos = players.get_position(players.user_ped()),
					dist = nil,
					explosionScale = nil
				}
				CEV.dist = CEVars.distance(CEV.playerPos, pos)
				CEV.explosionScale = math.max(self.explosionScale, 1 - CEV.dist * 0.1)
				FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, self.type, CEV.explosionScale, self.audible, self.invisible, 0.0, false)
			end
			menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Type"), {}, "", 0, 72, 59, 1, function(value) CEVars.Explosion.type = value end)
			menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Distance"), {}, "", 0, 100, 39, 1, function(value) CEVars.Explosion.explosionDistance = value end)
			menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Scale"), {}, "", 0, 100000, 100000, 1000, function(value) CEVars.Explosion.explosionScale = value / 100000 end)
			menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Vertical Explosion Offset"), {}, "", -50, 50, 0, 1, function(value) CEVars.Explosion.verticalExplosionOffset = value end)
			menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Invisible]"), {}, "", function(on) CEVars.Explosion.invisible = on end)
			menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Silent]"), {}, "", function(on) CEVars.Explosion.audible = not on end)
			menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Harmless Explosions]"), {}, "", function(on) CEVars.Explosion.doesNoDamage = on end)
			menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Explosion Loop] •"), {}, "", function(on)
				CEVars.usingExplosionLoop = on
				while CEVars.usingExplosionLoop and not util.is_session_transition_active() do
					CEVars.Explosion:explodePlayer(pId)
					CEVars.Explosion.currentAngle = (CEVars.Explosion.currentAngle + 300) % 360 
					util.yield(CEVars.Explosion.delay)
				end
			end)
			menu.action(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Trigger Explosion"), {}, "", function()
				CEVars.Explosion:explodePlayer(pId)
			end)			
		end
		customS1ExplosionFunction()

		local function customS2ExplosionFunction()
			local CEVars = {
				customExplosion = menu.list(customExplosions, translate("Trolling", "[Dome Explosion]"), {}, "Explosion dome created using math."),
				Explosion = {
					audible = false,
					delay = 0,
					owned = false,
					type = 59,
					invisible = false,
					doesNoDamage = false,
					xOffset = 0,
					yOffset = 0,
					zOffset = -1.0,
					explosionScale = 100000,
					currentAngle = 0,
					explosionDistance = 39,
					verticalExplosionOffset = 0
				},
				usingExplosionLoop = false,
				distance = function(pos1, pos2)
					return math.sqrt((pos2.x - pos1.x)^2 + (pos2.y - pos1.y)^2 + (pos2.z - pos1.z)^2)
				end
			}
			function CEVars.Explosion:explodePlayer(pId)
				local CEV = {
					pos = players.get_position(pId),
					explosionPos = nil,
					angle = nil,
					explosionDistance = self.explosionDistance,
					explosionX = nil,
					explosionY = nil,
					explosionZ = nil,
					verticalStep = 360 / 36,
					horizontalStep = 510
				}
				for i = 1, 36 do
					CEV.angle = math.rad(self.currentAngle + (i - 1) * CEV.horizontalStep)
					local verticalAngle = math.rad((self.currentAngle + (i - 1) * CEV.verticalStep) % 360)
					
					CEV.explosionX = CEV.pos.x + CEV.explosionDistance * math.cos(CEV.angle)
					CEV.explosionY = CEV.pos.y + CEV.explosionDistance * math.sin(CEV.angle)
					CEV.explosionZ = CEV.pos.z + self.verticalExplosionOffset + math.sin(verticalAngle) * self.explosionDistance
					
					CEV.explosionPos = v3(CEV.explosionX, CEV.explosionY, CEV.explosionZ)
					
					if self.owned then
						self:addOwnedExplosion(CEV.explosionPos)
					else
						self:addExplosion(CEV.explosionPos)
					end
					self.currentAngle = (self.currentAngle + 1) % 360
				end
			end
			function CEVars.Explosion:addOwnedExplosion(pos)
				local CEV = {
					playerPos = players.get_position(players.user_ped()),
					dist = nil,
					explosionScale = nil
				}
				CEV.dist = CEVars.distance(CEV.playerPos, pos)
				CEV.explosionScale = math.max(self.explosionScale, 1 - CEV.dist * 0.1)
				FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z, self.type, CEV.explosionScale, self.audible, self.invisible, 0.0)
			end
			function CEVars.Explosion:addExplosion(pos)
				local CEV = {
					playerPos = players.get_position(players.user_ped()),
					dist = nil,
					explosionScale = nil
				}
				CEV.dist = CEVars.distance(CEV.playerPos, pos)
				CEV.explosionScale = math.max(self.explosionScale, 1 - CEV.dist * 0.1)
				FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, self.type, CEV.explosionScale, self.audible, self.invisible, 0.0, false)
			end
			menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Type"), {}, "", 0, 72, 59, 1, function(value) CEVars.Explosion.type = value end)
			menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Distance"), {}, "", 0, 100, 39, 1, function(value) CEVars.Explosion.explosionDistance = value end)
			menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Scale"), {}, "", 0, 100000, 100000, 1000, function(value) CEVars.Explosion.explosionScale = value / 100000 end)
			menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Vertical Explosion Offset"), {}, "", -50, 50, 0, 1, function(value) CEVars.Explosion.verticalExplosionOffset = value end)
			menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Invisible]"), {}, "", function(on) CEVars.Explosion.invisible = on end)
			menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Silent]"), {}, "", function(on) CEVars.Explosion.audible = not on end)
			menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Harmless Explosions]"), {}, "", function(on) CEVars.Explosion.doesNoDamage = on end)
			menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Explosion Loop] •"), {}, "", function(on)
				CEVars.usingExplosionLoop = on
				while CEVars.usingExplosionLoop and not util.is_session_transition_active() do
					CEVars.Explosion:explodePlayer(pId)
					CEVars.Explosion.currentAngle = (CEVars.Explosion.currentAngle + 300) % 360 
					util.yield(CEVars.Explosion.delay)
				end
			end)
			menu.action(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Trigger Explosion"), {}, "", function()
				CEVars.Explosion:explodePlayer(pId)
			end)			
		end
		customS2ExplosionFunction()

		local function customS21ExplosionFunction()
			local CEVars = {
				customExplosion = menu.list(customExplosions, translate("Trolling", "[Tirespike Skies Explosion]"), {}, "Explosion dome created using math."),
				Explosion = {
					audible = false,
					delay = 0,
					owned = false,
					type = 66,
					invisible = false,
					doesNoDamage = false,
					xOffset = 0,
					yOffset = 0,
					zOffset = -1.0,
					explosionScale = 4000,
					currentAngle = 0,
					explosionDistance = 4,
					verticalExplosionOffset = 0
				},
				usingExplosionLoop = false,
				distance = function(pos1, pos2)
					return math.sqrt((pos2.x - pos1.x)^2 + (pos2.y - pos1.y)^2 + (pos2.z - pos1.z)^2)
				end
			}
			function CEVars.Explosion:explodePlayer(pId)
				local CEV = {
					pos = players.get_position(pId),
					explosionPos = nil,
					angle = nil,
					explosionDistance = self.explosionDistance,
					explosionX = nil,
					explosionY = nil,
					explosionZ = nil,
					verticalStep = 360 / 36,
					horizontalStep = 510
				}
				for i = 1, 36 do
					CEV.angle = math.rad(self.currentAngle + (i - 1) * CEV.horizontalStep)
					local verticalAngle = math.rad((self.currentAngle + (i - 1) * CEV.verticalStep) % 360)
					CEV.explosionX = CEV.pos.x + CEV.explosionDistance * math.cos(CEV.angle)
					CEV.explosionY = CEV.pos.y + CEV.explosionDistance * math.sin(CEV.angle)
					CEV.explosionZ = CEV.pos.z + self.verticalExplosionOffset + math.sin(verticalAngle) * self.explosionDistance
					CEV.explosionPos = v3(CEV.explosionX, CEV.explosionY, CEV.explosionZ)
					if self.owned then
						self:addOwnedExplosion(CEV.explosionPos)
					else
						self:addExplosion(CEV.explosionPos)
					end
					self.currentAngle = (self.currentAngle + 1) % 360
				end
			end
			function CEVars.Explosion:addOwnedExplosion(pos)
				local CEV = {
					playerPos = players.get_position(players.user_ped()),
					dist = nil,
					explosionScale = nil
				}
				CEV.dist = CEVars.distance(CEV.playerPos, pos)
				CEV.explosionScale = math.max(self.explosionScale, 1 - CEV.dist * 0.1)
				FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z, self.type, CEV.explosionScale, self.audible, self.invisible, 0.0)
			end
			function CEVars.Explosion:addExplosion(pos)
				local CEV = {
					playerPos = players.get_position(players.user_ped()),
					dist = nil,
					explosionScale = nil
				}
				CEV.dist = CEVars.distance(CEV.playerPos, pos)
				CEV.explosionScale = math.max(self.explosionScale, 1 - CEV.dist * 0.1)
				FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, self.type, CEV.explosionScale, self.audible, self.invisible, 0.0, false)
			end
			menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Type"), {}, "", 0, 72, 66, 1, function(value) CEVars.Explosion.type = value end)
			menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Distance"), {}, "", 0, 100, 4, 1, function(value) CEVars.Explosion.explosionDistance = value end)
			menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Scale"), {}, "", 0, 100000, 4000, 1000, function(value) CEVars.Explosion.explosionScale = value / 100000 end)
			menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Vertical Explosion Offset"), {}, "", -50, 50, 0, 1, function(value) CEVars.Explosion.verticalExplosionOffset = value end)
			menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Invisible]"), {}, "", function(on) CEVars.Explosion.invisible = on end)
			menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Silent]"), {}, "", function(on) CEVars.Explosion.audible = not on end)
			menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Harmless Explosions]"), {}, "", function(on) CEVars.Explosion.doesNoDamage = on end)
			menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Explosion Loop] •"), {}, "", function(on)
				CEVars.usingExplosionLoop = on
				while CEVars.usingExplosionLoop and not util.is_session_transition_active() do
					CEVars.Explosion:explodePlayer(pId)
					CEVars.Explosion.currentAngle = (CEVars.Explosion.currentAngle + 300) % 360 
					util.yield(CEVars.Explosion.delay)
				end
			end)
			menu.action(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Trigger Explosion"), {}, "", function()
				CEVars.Explosion:explodePlayer(pId)
			end)			
		end
		customS21ExplosionFunction()

			local function customExplosionFunction()
				local CEVars = {
					customExplosion = menu.list(customExplosions, translate("Trolling", "[Star Explosion]"), {}, "experimental placeholder"),
					Explosion = {
						audible = false,
						delay = 0,
						owned = false,
						type = 59,
						invisible = false,
						doesNoDamage = false,
						xOffset = 0,
						yOffset = 0,
						zOffset = -1.0,
						explosionScale = 500000,
						currentAngle = 0,
						explosionDistance = 20
					},
					usingExplosionLoop = false,
					distance = function(pos1, pos2)
						return math.sqrt((pos2.x - pos1.x)^2 + (pos2.y - pos1.y)^2 + (pos2.z - pos1.z)^2)
					end
				}
				function CEVars.Explosion:explodePlayer(pId)
					local CEV = {
						pos = players.get_position(pId),
						explosionPos = nil,
						angle = nil,
						explosionDistance = self.explosionDistance,
						explosionX = nil,
						explosionY = nil,
						explosionZ = nil
					}
					for i = 1, 2 do
						CEV.angle = math.rad(self.currentAngle + (i - 1) * 180)
						CEV.explosionX = CEV.pos.x + CEV.explosionDistance * math.cos(CEV.angle)
						CEV.explosionY = CEV.pos.y + CEV.explosionDistance * math.sin(CEV.angle)
						CEV.explosionZ = CEV.pos.z
						CEV.explosionPos = v3(CEV.explosionX, CEV.explosionY, CEV.explosionZ)
						if self.owned then
							self:addOwnedExplosion(CEV.explosionPos)
						else
							self:addExplosion(CEV.explosionPos)
						end
					end
				end
				function CEVars.Explosion:addOwnedExplosion(pos)
					local CEV = {
						playerPos = players.get_position(players.user_ped()),
						dist = nil,
						explosionScale = nil
					}
					CEV.dist = CEVars.distance(CEV.playerPos, pos)
					CEV.explosionScale = math.max(self.explosionScale, 1 - CEV.dist * 0.1)
				
					FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z, self.type, CEV.explosionScale, self.audible, self.invisible, 0.0)
				end
				function CEVars.Explosion:addExplosion(pos)
					local CEV = {
						playerPos = players.get_position(players.user_ped()),
						dist = nil,
						explosionScale = nil
					}
					CEV.dist = CEVars.distance(CEV.playerPos, pos)
					CEV.explosionScale = math.max(self.explosionScale, 1 - CEV.dist * 0.1)
					FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, self.type, CEV.explosionScale, self.audible, self.invisible, 0.0, false)
				end
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Type"), {}, "", 0, 72, 59, 1, function(value) CEVars.Explosion.type = value end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Invisible]"), {}, "", function(on) CEVars.Explosion.invisible = on end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Silent]"), {}, "", function(on) CEVars.Explosion.audible = not on end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Harmless Explosions]"), {}, "", function(on) CEVars.Explosion.doesNoDamage = on end)
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Scale"), {}, "", 1, 500000, 500000, 200, function(value) CEVars.Explosion.explosionScale = value / 100000 end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Explosion Loop] •"), {}, "", function(on)
					CEVars.usingExplosionLoop = on
					while CEVars.usingExplosionLoop and not util.is_session_transition_active() do
						CEVars.Explosion:explodePlayer(pId)
						CEVars.Explosion.currentAngle = (CEVars.Explosion.currentAngle + 300) % 360 
						util.yield(CEVars.Explosion.delay)
					end
				end)
			end
			customExplosionFunction()


			local function customSPIRExplosionFunction()
				local CEVars = {
					customExplosion = menu.list(customExplosions, translate("Trolling", "[Spiralz Explosions]"), {}, "Use on players who are near any water source - it will cause water sources to create huge waves around the player."),
					Explosion = {
						audible = false,
						delay = 10,
						owned = false,
						type = 65,
						invisible = false,
						doesNoDamage = false,
						xOffset = 0,
						yOffset = 0,
						zOffset = -1.0,
						explosionScale = 100000,
						currentAngle = 0,
						explosionDistance = 17,
						verticalExplosionOffset = -7
					},
					usingExplosionLoop = false,
					distance = function(pos1, pos2)
						return math.sqrt((pos2.x - pos1.x)^2 + (pos2.y - pos1.y)^2 + (pos2.z - pos1.z)^2)
					end
				}
				function CEVars.Explosion:explodePlayer(pId)
					local CEV = {
						pos = players.get_position(pId),
						explosionPos = nil,
						angle = math.rad(self.currentAngle),
						explosionDistance = self.explosionDistance,
						explosionX = nil,
						explosionY = nil,
						explosionZ = nil,
						angleIncrement = math.rad(500),  --Controls the tightness of the spiral. 1 is very tight, 3600 is very loose.
						radiusIncrement = 10.9  --Controls the spacing between each loop of the spiral. Smaller values are tighter spirals.
					}
					for i = 1, 86 do
						CEV.explosionX = CEV.pos.x + CEV.explosionDistance * math.cos(CEV.angle)
						CEV.explosionY = CEV.pos.y + CEV.explosionDistance * math.sin(CEV.angle)
						CEV.explosionZ = CEV.pos.z + self.verticalExplosionOffset
						CEV.explosionPos = v3(CEV.explosionX, CEV.explosionY, CEV.explosionZ)
						if self.owned then
							self:addOwnedExplosion(CEV.explosionPos)
						else
							self:addExplosion(CEV.explosionPos)
						end
						CEV.angle = CEV.angle + CEV.angleIncrement
						CEV.explosionDistance = CEV.explosionDistance + CEV.radiusIncrement
					end
					self.currentAngle = (self.currentAngle + 30) % 360
				end
				

				function CEVars.Explosion:addOwnedExplosion(pos)
					local CEV = {
						playerPos = players.get_position(players.user_ped()),
						dist = nil,
						explosionScale = nil
					}
					CEV.dist = CEVars.distance(CEV.playerPos, pos)
					CEV.explosionScale = math.max(self.explosionScale, 1 - CEV.dist * 0.1)
					FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z, self.type, CEV.explosionScale, self.audible, self.invisible, 0.0)
				end
				function CEVars.Explosion:addExplosion(pos)
					local CEV = {
						playerPos = players.get_position(players.user_ped()),
						dist = nil,
						explosionScale = nil
					}
					CEV.dist = CEVars.distance(CEV.playerPos, pos)
					CEV.explosionScale = math.max(self.explosionScale, 1 - CEV.dist * 0.1)
					FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, self.type, CEV.explosionScale, self.audible, self.invisible, 0.0, false)
				end
				
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Type"), {}, "", 0, 72, 65, 1, function(value) CEVars.Explosion.type = value end)
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Distance"), {}, "", 0, 100, 17, 1, function(value) CEVars.Explosion.explosionDistance = value end)
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Scale"), {}, "", 0, 100000, 100000, 1000, function(value) CEVars.Explosion.explosionScale = value / 100000 end)
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Vertical Explosion Offset"), {}, "", -50, 50, -7, 1, function(value) CEVars.Explosion.verticalExplosionOffset = value end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Invisible]"), {}, "", function(on) CEVars.Explosion.invisible = on end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Silent]"), {}, "", function(on) CEVars.Explosion.audible = not on end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Harmless Explosions]"), {}, "", function(on) CEVars.Explosion.doesNoDamage = on end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Explosion Loop] •"), {}, "", function(on)
					CEVars.usingExplosionLoop = on
					while CEVars.usingExplosionLoop and not util.is_session_transition_active() do
						CEVars.Explosion:explodePlayer(pId)
						CEVars.Explosion.currentAngle = (CEVars.Explosion.currentAngle + 300) % 360 
						util.yield(CEVars.Explosion.delay)
					end
				end)
				menu.action(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Trigger Explosion"), {}, "", function()
					CEVars.Explosion:explodePlayer(pId)
				end)			
			end
			customSPIRExplosionFunction()






			local function customSPIRAExplosionFunction()
				local CEVars = {
					customExplosion = menu.list(customExplosions, translate("Trolling", "[3 Explosions]"), {}, "Use on players who are near any water source - it will cause water sources to create huge waves around the player."),
					Explosion = {
						audible = false,
						delay = 10,
						owned = false,
						type = 65,
						invisible = false,
						doesNoDamage = false,
						xOffset = 0,
						yOffset = 0,
						zOffset = -1.0,
						explosionScale = 100000,
						currentAngle = 0,
						explosionDistance = 17,
						verticalExplosionOffset = -7
					},
					usingExplosionLoop = false,
					distance = function(pos1, pos2)
						return math.sqrt((pos2.x - pos1.x)^2 + (pos2.y - pos1.y)^2 + (pos2.z - pos1.z)^2)
					end
				}
				function CEVars.Explosion:explodePlayer(pId)
					local CEV = {
						pos = players.get_position(pId),
						explosionPos = nil,
						angle = math.rad(self.currentAngle),
						explosionDistance = self.explosionDistance,
						explosionX = nil,
						explosionY = nil,
						explosionZ = nil,
						angleIncrement = math.rad(500),  --Controls the tightness of the spiral. 1 is very tight, 3600 is very loose.
						radiusIncrement = 500.9  --Controls the spacing between each loop of the spiral. Smaller values are tighter spirals.
					}
					for i = 1, 86 do
						CEV.explosionX = CEV.pos.x + CEV.explosionDistance * math.cos(CEV.angle)
						CEV.explosionY = CEV.pos.y + CEV.explosionDistance * math.sin(CEV.angle)
						CEV.explosionZ = CEV.pos.z + self.verticalExplosionOffset
						CEV.explosionPos = v3(CEV.explosionX, CEV.explosionY, CEV.explosionZ)
						if self.owned then
							self:addOwnedExplosion(CEV.explosionPos)
						else
							self:addExplosion(CEV.explosionPos)
						end
						CEV.angle = CEV.angle + CEV.angleIncrement
						CEV.explosionDistance = CEV.explosionDistance + CEV.radiusIncrement
					end
					self.currentAngle = (self.currentAngle + 30) % 360
				end
				

				function CEVars.Explosion:addOwnedExplosion(pos)
					local CEV = {
						playerPos = players.get_position(players.user_ped()),
						dist = nil,
						explosionScale = nil
					}
					CEV.dist = CEVars.distance(CEV.playerPos, pos)
					CEV.explosionScale = math.max(self.explosionScale, 1 - CEV.dist * 0.1)
					FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z, self.type, CEV.explosionScale, self.audible, self.invisible, 0.0)
				end
				function CEVars.Explosion:addExplosion(pos)
					local CEV = {
						playerPos = players.get_position(players.user_ped()),
						dist = nil,
						explosionScale = nil
					}
					CEV.dist = CEVars.distance(CEV.playerPos, pos)
					CEV.explosionScale = math.max(self.explosionScale, 1 - CEV.dist * 0.1)
					FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, self.type, CEV.explosionScale, self.audible, self.invisible, 0.0, false)
				end
				
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Type"), {}, "", 0, 72, 65, 1, function(value) CEVars.Explosion.type = value end)
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Distance"), {}, "", 0, 100, 17, 1, function(value) CEVars.Explosion.explosionDistance = value end)
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Scale"), {}, "", 0, 100000, 100000, 1000, function(value) CEVars.Explosion.explosionScale = value / 100000 end)
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Vertical Explosion Offset"), {}, "", -50, 50, -7, 1, function(value) CEVars.Explosion.verticalExplosionOffset = value end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Invisible]"), {}, "", function(on) CEVars.Explosion.invisible = on end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Silent]"), {}, "", function(on) CEVars.Explosion.audible = not on end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Harmless Explosions]"), {}, "", function(on) CEVars.Explosion.doesNoDamage = on end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Explosion Loop] •"), {}, "", function(on)
					CEVars.usingExplosionLoop = on
					while CEVars.usingExplosionLoop and not util.is_session_transition_active() do
						CEVars.Explosion:explodePlayer(pId)
						CEVars.Explosion.currentAngle = (CEVars.Explosion.currentAngle + 300) % 360 
						util.yield(CEVars.Explosion.delay)
					end
				end)
				menu.action(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Trigger Explosion"), {}, "", function()
					CEVars.Explosion:explodePlayer(pId)
				end)			
			end
			customSPIRAExplosionFunction()






			local function customSPIExplosionFunction()
				local CEVars = {
					customExplosion = menu.list(customExplosions, translate("Trolling", "[Galaxy Explosions]"), {}, "This uses different sinoids to control the Explosion path around the player."),
					Explosion = {
						audible = false,
						delay = 0,
						owned = false,
						type = 65,
						invisible = false,
						doesNoDamage = false,
						xOffset = 0,
						yOffset = 0,
						zOffset = -1.0,
						explosionScale = 100000,
						currentAngle = 0,
						explosionDistance = 11,
						verticalExplosionOffset = -7
					},
					usingExplosionLoop = false,
					distance = function(pos1, pos2)
						return math.sqrt((pos2.x - pos1.x)^2 + (pos2.y - pos1.y)^2 + (pos2.z - pos1.z)^2)
					end
				}
				function CEVars.Explosion:explodePlayer(pId)
					local CEV = {
						pos = players.get_position(pId),
						explosionPos = nil,
						angle = self.currentAngle,
						radius = self.explosionDistance,
						radiusIncrement = 0.5, -- This controls the spacing of the spiral
						numberOfExplosions = 36, -- This can be controlled by a new slider
					}
					for i = 1, CEV.numberOfExplosions do
						CEV.explosionX = CEV.pos.x + CEV.radius * math.cos(CEV.angle)
						CEV.explosionY = CEV.pos.y + CEV.radius * math.sin(CEV.angle)
						CEV.explosionZ = CEV.pos.z + self.verticalExplosionOffset
						CEV.explosionPos = v3(CEV.explosionX, CEV.explosionY, CEV.explosionZ)
						if self.owned then
							self:addOwnedExplosion(CEV.explosionPos)
						else
							self:addExplosion(CEV.explosionPos)
						end
						-- Update the angle and radius for the next explosion
						CEV.angle = CEV.angle + math.rad(10) -- This controls the tightness of the spiral
						CEV.radius = CEV.radius + CEV.radiusIncrement
					end
				end				
				function CEVars.Explosion:addOwnedExplosion(pos)
					local CEV = {
						playerPos = players.get_position(players.user_ped()),
						dist = nil,
						explosionScale = nil
					}
					CEV.dist = CEVars.distance(CEV.playerPos, pos)
					CEV.explosionScale = math.max(self.explosionScale, 1 - CEV.dist * 0.1)
					FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z, self.type, CEV.explosionScale, self.audible, self.invisible, 0.0)
				end
				function CEVars.Explosion:addExplosion(pos)
					local CEV = {
						playerPos = players.get_position(players.user_ped()),
						dist = nil,
						explosionScale = nil
					}
					CEV.dist = CEVars.distance(CEV.playerPos, pos)
					CEV.explosionScale = math.max(self.explosionScale, 1 - CEV.dist * 0.1)
					FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, self.type, CEV.explosionScale, self.audible, self.invisible, 0.0, false)
				end
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Type"), {}, "", 0, 72, 65, 1, function(value) CEVars.Explosion.type = value end)
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Distance"), {}, "", 0, 100, 11, 1, function(value) CEVars.Explosion.explosionDistance = value end)
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Scale"), {}, "", 0, 100000, 100000, 1000, function(value) CEVars.Explosion.explosionScale = value / 100000 end)
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Vertical Explosion Offset"), {}, "", -50, 50, -7, 1, function(value) CEVars.Explosion.verticalExplosionOffset = value end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Invisible]"), {}, "", function(on) CEVars.Explosion.invisible = on end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Silent]"), {}, "", function(on) CEVars.Explosion.audible = not on end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Harmless Explosions]"), {}, "", function(on) CEVars.Explosion.doesNoDamage = on end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Explosion Loop] •"), {}, "", function(on)
					CEVars.usingExplosionLoop = on
					while CEVars.usingExplosionLoop and not util.is_session_transition_active() do
						CEVars.Explosion:explodePlayer(pId)
						CEVars.Explosion.currentAngle = (CEVars.Explosion.currentAngle + 300) % 360 
						util.yield(CEVars.Explosion.delay)
					end
				end)
				menu.action(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Trigger Explosion"), {}, "", function()
					CEVars.Explosion:explodePlayer(pId)
				end)			
			end
			customSPIExplosionFunction()
















			local function customSPIExplosionFunction()
				local CEVars = {
					customExplosion = menu.list(customExplosions, translate("Trolling", "[Storm Explosions]"), {}, "Use on players who are near any water source - it will cause water sources to create huge waves around the player."),
					Explosion = {
						audible = false,
						delay = 0,
						owned = false,
						type = 64,
						invisible = false,
						doesNoDamage = false,
						xOffset = 0,
						yOffset = 0,
						zOffset = -1.0,
						explosionScale = 100000,
						currentAngle = 0,
						explosionDistance = 11,
						verticalExplosionOffset = 9
					},
					usingExplosionLoop = false,
					distance = function(pos1, pos2)
						return math.sqrt((pos2.x - pos1.x)^2 + (pos2.y - pos1.y)^2 + (pos2.z - pos1.z)^2)
					end
				}
				function CEVars.Explosion:explodePlayer(pId)
					local CEV = {
						pos = players.get_position(pId),
						explosionPos = nil,
						angle = self.currentAngle,
						radius = self.explosionDistance,
						radiusIncrement = 0.5, -- This controls the spacing of the spiral
						numberOfExplosions = 36, -- This can be controlled by a new slider
					}
					for i = 1, CEV.numberOfExplosions do
						CEV.explosionX = CEV.pos.x + CEV.radius * math.cos(CEV.angle)
						CEV.explosionY = CEV.pos.y + CEV.radius * math.sin(CEV.angle)
						CEV.explosionZ = CEV.pos.z + self.verticalExplosionOffset
						CEV.explosionPos = v3(CEV.explosionX, CEV.explosionY, CEV.explosionZ)
						if self.owned then
							self:addOwnedExplosion(CEV.explosionPos)
						else
							self:addExplosion(CEV.explosionPos)
						end
						-- Update the angle and radius for the next explosion
						CEV.angle = CEV.angle + math.rad(10) -- This controls the tightness of the spiral
						CEV.radius = CEV.radius + CEV.radiusIncrement
					end
				end				
				function CEVars.Explosion:addOwnedExplosion(pos)
					local CEV = {
						playerPos = players.get_position(players.user_ped()),
						dist = nil,
						explosionScale = nil
					}
					CEV.dist = CEVars.distance(CEV.playerPos, pos)
					CEV.explosionScale = math.max(self.explosionScale, 1 - CEV.dist * 0.1)
					FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z, self.type, CEV.explosionScale, self.audible, self.invisible, 0.0)
				end
				function CEVars.Explosion:addExplosion(pos)
					local CEV = {
						playerPos = players.get_position(players.user_ped()),
						dist = nil,
						explosionScale = nil
					}
					CEV.dist = CEVars.distance(CEV.playerPos, pos)
					CEV.explosionScale = math.max(self.explosionScale, 1 - CEV.dist * 0.1)
					FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, self.type, CEV.explosionScale, self.audible, self.invisible, 0.0, false)
				end
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Type"), {}, "", 0, 72, 65, 1, function(value) CEVars.Explosion.type = value end)
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Distance"), {}, "", 0, 100, 11, 1, function(value) CEVars.Explosion.explosionDistance = value end)
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Scale"), {}, "", 0, 100000, 100000, 1000, function(value) CEVars.Explosion.explosionScale = value / 100000 end)
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Vertical Explosion Offset"), {}, "", -50, 50, 9, 1, function(value) CEVars.Explosion.verticalExplosionOffset = value end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Invisible]"), {}, "", function(on) CEVars.Explosion.invisible = on end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Silent]"), {}, "", function(on) CEVars.Explosion.audible = not on end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Harmless Explosions]"), {}, "", function(on) CEVars.Explosion.doesNoDamage = on end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Explosion Loop] •"), {}, "", function(on)
					CEVars.usingExplosionLoop = on
					while CEVars.usingExplosionLoop and not util.is_session_transition_active() do
						CEVars.Explosion:explodePlayer(pId)
						CEVars.Explosion.currentAngle = (CEVars.Explosion.currentAngle + 300) % 360 
						util.yield(CEVars.Explosion.delay)
					end
				end)
				menu.action(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Trigger Explosion"), {}, "", function()
					CEVars.Explosion:explodePlayer(pId)
				end)			
			end
			customSPIExplosionFunction()





			local function customUWExplosionFunction()
				local CEVars = {
					customExplosion = menu.list(customExplosions, translate("Trolling", "[Hurricane Explosions]"), {}, "Use on players who are near any water source - it will cause water sources to create huge waves around the player."),
					Explosion = {
						audible = false,
						delay = 0,
						owned = false,
						type = 65,
						invisible = false,
						doesNoDamage = false,
						xOffset = 0,
						yOffset = 0,
						zOffset = -1.0,
						explosionScale = 100000,
						currentAngle = 0,
						explosionDistance = 11,
						verticalExplosionOffset = -7
					},
					usingExplosionLoop = false,
					distance = function(pos1, pos2)
						return math.sqrt((pos2.x - pos1.x)^2 + (pos2.y - pos1.y)^2 + (pos2.z - pos1.z)^2)
					end
				}
				function CEVars.Explosion:explodePlayer(pId)
					local CEV = {
						pos = players.get_position(pId),
						explosionPos = nil,
						angle = nil,
						explosionDistance = self.explosionDistance,
						explosionX = nil,
						explosionY = nil,
						explosionZ = nil
					}
					for i = 1, 36 do
						CEV.angle = math.rad(self.currentAngle + (i - 1) * 10)
						CEV.explosionX = CEV.pos.x + CEV.explosionDistance * math.cos(CEV.angle)
						CEV.explosionY = CEV.pos.y + CEV.explosionDistance * math.sin(CEV.angle)
						CEV.explosionZ = CEV.pos.z + self.verticalExplosionOffset
						CEV.explosionPos = v3(CEV.explosionX, CEV.explosionY, CEV.explosionZ)
						if self.owned then
							self:addOwnedExplosion(CEV.explosionPos)
						else
							self:addExplosion(CEV.explosionPos)
						end
						self.currentAngle = (self.currentAngle + 30) % 360
					end
				end
				function CEVars.Explosion:addOwnedExplosion(pos)
					local CEV = {
						playerPos = players.get_position(players.user_ped()),
						dist = nil,
						explosionScale = nil
					}
					CEV.dist = CEVars.distance(CEV.playerPos, pos)
					CEV.explosionScale = math.max(self.explosionScale, 1 - CEV.dist * 0.1)
					FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z, self.type, CEV.explosionScale, self.audible, self.invisible, 0.0)
				end
				function CEVars.Explosion:addExplosion(pos)
					local CEV = {
						playerPos = players.get_position(players.user_ped()),
						dist = nil,
						explosionScale = nil
					}
					CEV.dist = CEVars.distance(CEV.playerPos, pos)
					CEV.explosionScale = math.max(self.explosionScale, 1 - CEV.dist * 0.1)
					FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, self.type, CEV.explosionScale, self.audible, self.invisible, 0.0, false)
				end
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Type"), {}, "", 0, 72, 65, 1, function(value) CEVars.Explosion.type = value end)
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Distance"), {}, "", 0, 100, 11, 1, function(value) CEVars.Explosion.explosionDistance = value end)
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Scale"), {}, "", 0, 100000, 100000, 1000, function(value) CEVars.Explosion.explosionScale = value / 100000 end)
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Vertical Explosion Offset"), {}, "", -50, 50, -7, 1, function(value) CEVars.Explosion.verticalExplosionOffset = value end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Invisible]"), {}, "", function(on) CEVars.Explosion.invisible = on end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Silent]"), {}, "", function(on) CEVars.Explosion.audible = not on end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Harmless Explosions]"), {}, "", function(on) CEVars.Explosion.doesNoDamage = on end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Explosion Loop] •"), {}, "", function(on)
					CEVars.usingExplosionLoop = on
					while CEVars.usingExplosionLoop and not util.is_session_transition_active() do
						CEVars.Explosion:explodePlayer(pId)
						CEVars.Explosion.currentAngle = (CEVars.Explosion.currentAngle + 300) % 360 
						util.yield(CEVars.Explosion.delay)
					end
				end)
				menu.action(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Trigger Explosion"), {}, "", function()
					CEVars.Explosion:explodePlayer(pId)
				end)			
			end
			customUWExplosionFunction()
			local function customHEExplosionFunction()
				local CEVars = {
					customExplosion = menu.list(customExplosions, translate("Trolling", "[Nuclear Explosions]"), {}, ""),
					Explosion = {
						audible = false,
						delay = 0,
						owned = false,
						type = 59,
						invisible = false,
						doesNoDamage = false,
						xOffset = 0,
						yOffset = 0,
						zOffset = -1.0,
						explosionScale = 100000,
						currentAngle = 0,
						explosionDistance = math.random(10, 20),
						verticalExplosionOffset = math.random(0, 2)
					},
					usingExplosionLoop = false,
					distance = function(pos1, pos2)
						return math.sqrt((pos2.x - pos1.x)^2 + (pos2.y - pos1.y)^2 + (pos2.z - pos1.z)^2)
					end
				}
				function CEVars.Explosion:explodePlayer(pId)
					local CEV = {
						pos = players.get_position(pId),
						explosionPos = nil,
						angle = nil,
						explosionDistance = self.explosionDistance,
						explosionX = nil,
						explosionY = nil,
						explosionZ = nil
					}
					for i = 1, 36 do
						CEV.angle = math.rad(self.currentAngle + (i - 1) * 10)
						CEV.explosionX = CEV.pos.x + CEV.explosionDistance * math.cos(CEV.angle)
						CEV.explosionY = CEV.pos.y + CEV.explosionDistance * math.sin(CEV.angle)
						CEV.explosionZ = CEV.pos.z + self.verticalExplosionOffset
						CEV.explosionPos = v3(CEV.explosionX, CEV.explosionY, CEV.explosionZ)
						if self.owned then
							self:addOwnedExplosion(CEV.explosionPos)
						else
							self:addExplosion(CEV.explosionPos)
						end
						self.currentAngle = (self.currentAngle + 30) % 360
					end
				end
				function CEVars.Explosion:addOwnedExplosion(pos)
					local CEV = {
						playerPos = players.get_position(players.user_ped()),
						dist = nil,
						explosionScale = nil
					}
					CEV.dist = CEVars.distance(CEV.playerPos, pos)
					CEV.explosionScale = math.max(self.explosionScale, 1 - CEV.dist * 0.1)
					FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z, self.type, CEV.explosionScale, self.audible, self.invisible, 0.0)
				end
				function CEVars.Explosion:addExplosion(pos)
					local CEV = {
						playerPos = players.get_position(players.user_ped()),
						dist = nil,
						explosionScale = nil
					}
					CEV.dist = CEVars.distance(CEV.playerPos, pos)
					CEV.explosionScale = math.max(self.explosionScale, 1 - CEV.dist * 0.1)
					FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, self.type, CEV.explosionScale, self.audible, self.invisible, 0.0, false)
				end
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Type"), {}, "", 0, 72, 59, 1, function(value) CEVars.Explosion.type = value end)
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Distance"), {}, "", 0, 100, -1, 1, function(value) CEVars.Explosion.explosionDistance = value end)
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Scale"), {}, "", 0, 100000, 100000, 1000, function(value) CEVars.Explosion.explosionScale = value / 100000 end)
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Vertical Explosion Offset"), {}, "", -50, 50, -10, 1, function(value) CEVars.Explosion.verticalExplosionOffset = value end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Invisible]"), {}, "", function(on) CEVars.Explosion.invisible = on end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Silent]"), {}, "", function(on) CEVars.Explosion.audible = not on end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Harmless Explosions]"), {}, "", function(on) CEVars.Explosion.doesNoDamage = on end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Explosion Loop] •"), {}, "", function(on)
					CEVars.usingExplosionLoop = on
					while CEVars.usingExplosionLoop and not util.is_session_transition_active() do
						CEVars.Explosion:explodePlayer(pId)
						CEVars.Explosion.currentAngle = (CEVars.Explosion.currentAngle + 300) % 360 
						util.yield(CEVars.Explosion.delay)
					end
				end)
				menu.action(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Trigger Explosion"), {}, "", function()
					CEVars.Explosion:explodePlayer(pId)
				end)			
			end
			customHEExplosionFunction()
			local function customHEExplosionFunction()
				local CEVars = {
					customExplosion = menu.list(customExplosions, translate("Trolling", "[FireBall]"), {}, "Creates a trail of fire around the player"),
					Explosion = {
						audible = false,
						delay = 0,
						owned = false,
						type = 38,
						invisible = false,
						doesNoDamage = false,
						xOffset = 0,
						yOffset = 0,
						zOffset = -1.0,
						explosionScale = 100000,
						currentAngle = 0,
						explosionDistance = 5,
						verticalExplosionOffset = 0
					},
					usingExplosionLoop = false,
					distance = function(pos1, pos2)
						return math.sqrt((pos2.x - pos1.x)^2 + (pos2.y - pos1.y)^2 + (pos2.z - pos1.z)^2)
					end
				}
				function CEVars.Explosion:explodePlayer(pId)
					local CEV = {
						pos = players.get_position(pId),
						explosionPos = nil,
						angle = nil,
						explosionDistance = self.explosionDistance,
						explosionX = nil,
						explosionY = nil,
						explosionZ = nil
					}
					for i = 1, 36 do
						CEV.angle = math.rad(self.currentAngle + (i - 1) * 10)
						CEV.explosionX = CEV.pos.x + CEV.explosionDistance * math.cos(CEV.angle)
						CEV.explosionY = CEV.pos.y + CEV.explosionDistance * math.sin(CEV.angle)
						CEV.explosionZ = CEV.pos.z + self.verticalExplosionOffset
						CEV.explosionPos = v3(CEV.explosionX, CEV.explosionY, CEV.explosionZ)
						if self.owned then
							self:addOwnedExplosion(CEV.explosionPos)
						else
							self:addExplosion(CEV.explosionPos)
						end
						self.currentAngle = (self.currentAngle + 30) % 360
					end
				end
				function CEVars.Explosion:addOwnedExplosion(pos)
					local CEV = {
						playerPos = players.get_position(players.user_ped()),
						dist = nil,
						explosionScale = nil
					}
					CEV.dist = CEVars.distance(CEV.playerPos, pos)
					CEV.explosionScale = math.max(self.explosionScale, 1 - CEV.dist * 0.1)
					FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z, self.type, CEV.explosionScale, self.audible, self.invisible, 0.0)
				end
				function CEVars.Explosion:addExplosion(pos)
					local CEV = {
						playerPos = players.get_position(players.user_ped()),
						dist = nil,
						explosionScale = nil
					}
					CEV.dist = CEVars.distance(CEV.playerPos, pos)
					CEV.explosionScale = math.max(self.explosionScale, 1 - CEV.dist * 0.1)
					FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, self.type, CEV.explosionScale, self.audible, self.invisible, 0.0, false)
				end
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Type"), {}, "", 0, 72, 38, 1, function(value) CEVars.Explosion.type = value end)
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Distance"), {}, "", 0, 100, 5, 1, function(value) CEVars.Explosion.explosionDistance = value end)
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Explosion Scale"), {}, "", 0, 100000, 100000, 1000, function(value) CEVars.Explosion.explosionScale = value / 100000 end)
				menu.slider(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Vertical Explosion Offset"), {}, "", -50, 50, 0, 1, function(value) CEVars.Explosion.verticalExplosionOffset = value end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Invisible]"), {}, "", function(on) CEVars.Explosion.invisible = on end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Silent]"), {}, "", function(on) CEVars.Explosion.audible = not on end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Harmless Explosions]"), {}, "", function(on) CEVars.Explosion.doesNoDamage = on end)
				menu.toggle(CEVars.customExplosion, translate("Trolling - Custom Explosion", "[Explosion Loop] •"), {}, "", function(on)
					CEVars.usingExplosionLoop = on
					while CEVars.usingExplosionLoop and not util.is_session_transition_active() do
						CEVars.Explosion:explodePlayer(pId)
						CEVars.Explosion.currentAngle = (CEVars.Explosion.currentAngle + 300) % 360 
						util.yield(CEVars.Explosion.delay)
					end
				end)
				menu.action(CEVars.customExplosion, translate("Trolling - Custom Explosion", "Trigger Explosion"), {}, "", function()
					CEVars.Explosion:explodePlayer(pId)
				end)			
			end
			customHEExplosionFunction()
		local MenuDependancies = {
			VehicleConditionsMenu = {},
			newInstance = {},
			presetMenuToggles = {},
			PlayerProximityHomingMenuClass = {},
			AudioSpamMenuClass = {},
			ExplodeOnCollisionMenuClass = {},
			ExplodeOnCollisionMenuClass2 = {},
			ExplodeOnCollisionMenuClass3 = {},
			ExplodeOnCollisionMenuClass4 = {},
			SmashBrawlMenuClass = {},
			BruteForceMenuClass = {},
			PlayerBruteForceMenuClass = {},
			SuperPowersMenuClass = {},
			CTLSpecialsMenuClass = {},
			AudioSpam2MenuClass = {},
			NodeTrafficMenuClass = {},
			self = setmetatable({}, VehicleConditionsMenu)
		}
		MenuDependancies.VehicleConditionsMenu.__index = VehicleConditionsMenu
		function MenuDependancies.PlayerBruteForceMenuClass:new(customizePlayerPower)
			setmetatable(MenuDependancies.newInstance, self)
			self.__index = self
			self.menu = menu.list(customizePlayerPower, translate("Customize Player BruteForce •     >", "Customize Player BruteForce •     >"))
			self.toggle = createMenuToggle(PlayerPower, "Player Brute Force", false, function(on) SuperPowersConfig.PlayerBruteForceConfig.isPlayerBruteForceOn = on end)
			self.pushTimerSlider = createMenuSlider(self.menu, "Player BruteF Push Timer (ms) • >", "Cooldown between pushes in ms", 1, 1000, SuperPowersConfig.PlayerBruteForceConfig.playerBruteForce_push_cooldown, 25, function(value) SuperPowersConfig.PlayerBruteForceConfig.playerBruteForce_push_cooldown = value end)
			self.pushThresholdSlider = createMenuSlider(self.menu, 
											"Player BruteF Push Threshold (Tenths of a Meter) • >", "Maximum distance between player and other vehicles to trigger the push in tenths of a meter.", 
											1, 
											1000, 
											SuperPowersConfig.PlayerBruteForceConfig.playerBruteForce_push_threshold * 10, 5, 
											function(value) 
												SuperPowersConfig.PlayerBruteForceConfig.playerBruteForce_push_threshold = value / 10 
											end)
			self.pushForceMultiplierSlider = createMenuSlider(self.menu, "Player BruteF Push Force Multiplier  • >", "Multiplier for the force applied to push vehicles.", 1, 5000, SuperPowersConfig.PlayerBruteForceConfig.playerBruteForce_push_force_multiplier, 1, function(value) SuperPowersConfig.PlayerBruteForceConfig.playerBruteForce_push_force_multiplier = value end)
			return newInstance
		end
		function MenuDependancies.SmashBrawlMenuClass:new(customizeNPCPowers)
			setmetatable(MenuDependancies.newInstance, self)
			self.__index = self
			self.menu = menu.list(customizeNPCPowers, translate("Customize Smash Brawl Mode •     >", "Customize NPC Smash Brawl •     >"))
			self.toggle = createMenuToggle(NPCPowers, "Smash Brawl", false, function(on) SuperPowersConfig.BruteForceConfig.isBruteForceOn = on end)
			self.pushTimerSlider = createMenuSlider(self.menu, "Smash Brawl Timer (ms) • >", "Cooldown between pushes in ms", 1, 1000, SuperPowersConfig.BruteForceConfig.push_cooldown, 25, function(value) SuperPowersConfig.BruteForceConfig.push_cooldown = value end)
			self.pushThresholdSlider = createMenuSlider(self.menu, 
											"Smash Brawl Threshold (Tenths of a Meter) • >", 
											"Maximum distance between player and other vehicles to trigger the push in tenths of a meter.", 
											1, 
											1000, 
											SuperPowersConfig.BruteForceConfig.push_threshold * 10, 15, 
											function(value) 
												SuperPowersConfig.BruteForceConfig.push_threshold = value / 10 
											end)
			self.pushForceMultiplierSlider = createMenuSlider(self.menu, "Smash Brawl Push Force Multiplier  • >", "Multiplier for the force applied to push vehicles.", 1, 5000, SuperPowersConfig.BruteForceConfig.push_force_multiplier, 1, function(value) SuperPowersConfig.BruteForceConfig.push_force_multiplier = value end)
			return newInstance
		end
		function MenuDependancies.BruteForceMenuClass:new(customizeNPCPowers)
			self.__index = self
			self.bruteForceToggle = createMenuToggle(NPCPowers, "OG Brute Force", false, function(on) SuperPowersConfig.OGBruteForceConfig.isOGBruteForceOn = on end)
			self.bruteForceList = menu.list(customizeNPCPowers, translate("Customize OG BruteForce •     >", "Customize NPC BruteForce •     >"))
			self.pushTimerSliderBruteF = createMenuSlider(self.bruteForceList, "BruteF Push Timer (ms) • >", "Cooldown between pushes in ms", 1, 1000, SuperPowersConfig.OGBruteForceConfig.OGBFpush_cooldown, 25, function(value) SuperPowersConfig.OGBruteForceConfig.OGBFpush_cooldown = value end)
			self.pushThresholdSliderBruteF = createMenuSlider(self.bruteForceList, 
											"BruteF Push Threshold (Tenths of a Meter) • >", 
											"Maximum distance between player and other vehicles to trigger the push in tenths of a meter.", 
											1, 
											1000, 
											SuperPowersConfig.OGBruteForceConfig.OGBFpush_threshold * 10, 
											15, 
											function(value) 
												SuperPowersConfig.OGBruteForceConfig.OGBFpush_threshold = value / 10 
											end)
			self.pushForceMultiplierSliderBruteF = createMenuSlider(self.bruteForceList, "BruteF Push Force Multiplier  • >", "Multiplier for the force applied to push vehicles.", 1, 5000, SuperPowersConfig.OGBruteForceConfig.OGBFpush_force_multiplier, 1, function(value) SuperPowersConfig.OGBruteForceConfig.OGBFpush_force_multiplier = value end)
			return newInstance
		end
		function MenuDependancies.PlayerProximityHomingMenuClass:new(customizePlayerPower)
			setmetatable(MenuDependancies.newInstance, self)
			self.__index = self
			self.menu = menu.list(customizePlayerPower, translate("Customize Player Proximity Homing •     >", "Customize Player Proximity Homing •     >"))
			self.homingToggle = createMenuToggle(PlayerPower, "Player Proximity Homing", false, function(on) SuperPowersConfig.playerProximityConfig.isPlayerProximityHomingOn = on end)
			self.pushCooldownSlider = createMenuSlider(self.menu, "PH Player Lunge Cooldown", "", 0, 10000, SuperPowersConfig.playerProximityConfig.push_cooldown, 100, function(value) SuperPowersConfig.playerProximityConfig.push_cooldown = value end)
			self.pushTimerSlider = createMenuSlider(self.menu, "PH Player Lunge Duration", "?", 0, 2000, SuperPowersConfig.playerProximityConfig.push_timer, 1, function(value) SuperPowersConfig.playerProximityConfig.push_timer = value end)
			self.pushThresholdSlider = createMenuSlider(self.menu, "PH Player Lunge Threshold", "How powerful will the player be attracted to the NPC within their range?", 0, 5000, SuperPowersConfig.playerProximityConfig.push_threshold, 1, function(value) SuperPowersConfig.playerProximityConfig.push_threshold = value end)
			self.pushForceMultiplierSlider = createMenuSlider(self.menu, 
											"PH Lunge Force Multiplier", 
											"Multiples the Lunge Threshold value by this value", 
											0, 
											5000, 
											SuperPowersConfig.playerProximityConfig.push_force_multiplier * 1, 
											1, 
											function(value) 
												SuperPowersConfig.playerProximityConfig.push_force_multiplier = value / 100 
											end)
			self.distanceThresholdSlider = createMenuSlider(self.menu, "PH Attraction Range", "How close before the player lunges at the NPC to keep them pinned", 0, 5000, (SuperPowersConfig.playerProximityConfig.distance_threshold * 10) - 98, 1, function(value) SuperPowersConfig.playerProximityConfig.distance_threshold = (value + 85) / 10 end)
			return newInstance
		end
		function MenuDependancies.AudioSpamMenuClass:new(customizeNPCPowers)
			setmetatable(MenuDependancies.newInstance, self)
			self.__index = self
			self.menu = menu.list(customizeNPCPowers, translate("Customize Audio Spam •     >", "Customize Audio Spam •     >"))
			self.toggle = createMenuToggle(NPCPowers, "AP Audio Spam ", false, function(on) SuperPowersConfig.audioSpamConfig.isAudioSpamOn = on end)
			self.invisibleToggle = createMenuToggle(self.menu, "AP Invisible Explosion @", true, function(on) SuperPowersConfig.audioSpamConfig.audioSpamInvisible = on end)
			self.audibleToggle = createMenuToggle(self.menu, "AP Audible @", true, function(on) SuperPowersConfig.audioSpamConfig.audioSpamAudible = on end)
			self.typeSlider = createMenuSlider(self.menu, "AP Audio Type • >", "Default: Predator Calls", 0, 82, SuperPowersConfig.audioSpamConfig.audioSpamType, 1, function(value) SuperPowersConfig.audioSpamConfig.audioSpamType = value end)
			self.distanceSlider = createMenuSlider(self.menu, 
											"AP Trigger Distance • >", "How far from the car to the player will count as a collision?", 
											1, 
											1000, 
											math.floor(SuperPowersConfig.audioSpamConfig.audioSpamTriggerDistance * 10), 
											25, 
											function(value) 
												SuperPowersConfig.audioSpamConfig.audioSpamTriggerDistance = value / 10 
											end)
			self.damageSlider = createMenuSlider(self.menu, "AP Damage • >", "Go nuts", 0, 1000, SuperPowersConfig.audioSpamConfig.audioSpamDamage, 1, function(value) SuperPowersConfig.audioSpamConfig.audioSpamDamage = value end)
			return newInstance
		end
		function MenuDependancies.AudioSpam2MenuClass:new(customizeNPCPowers)
			setmetatable(MenuDependancies.newInstance, self)
			self.__index = self
			self.menu = menu.list(customizeNPCPowers, translate("Customize Audio Spam • >", "Customize Audio Spam 2 • >"))
			self.AudioSpamToggle2 = createMenuToggle(NPCPowers, "AP Audio Spam 2", false, function(on) SuperPowersConfig.audioSpamConfig2.IsAudioSpam2On = on end)
			self.audioInvisibleToggle2 = createMenuToggle(self.menu, "AP Invisible Explosion @", true, function(on) SuperPowersConfig.audioSpamConfig2.AP2audioInvisible = on end)
			self.spamAudibleToggle2 = createMenuToggle(self.menu, "AP Audible @", true, function(on) SuperPowersConfig.audioSpamConfig2.AP2spamAudible = on end)
			self.TriggerDistanceSlider2 = createMenuSlider(self.menu, "AP Trigger Distance • >", "How far from the car to the player will count as a collision?", 1, 1000, 450, 25, function(value) SuperPowersConfig.audioSpamConfig2.AP2TriggerDistance = value / 10 end)
			self.audioTypeSlider2 = createMenuSlider(self.menu, "AP Audio Type • >", "Default: Earthquake", 0, 82, 58, 1, function(value) SuperPowersConfig.audioSpamConfig2.AP2audioType = value end)
			self.audioDamageSlider2 = createMenuSlider(self.menu, "AP Damage • >", "Go nuts", 0, 1000, 0, 1, function(value) SuperPowersConfig.audioSpamConfig2.AP2audioDamage = value end)
			return newInstance
		end
		function MenuDependancies.NodeTrafficMenuClass:new(customizeNPCPowers)
			setmetatable(MenuDependancies.newInstance, self)
			self.NodeTrafficToggle = menu.toggle_loop(NPCPowers, translate("Ultimate Custom Traffic", "NodeTraffic"),{}, false, SPscriptFns.Nodetraffic)
			return newInstance
		end
		function MenuDependancies.ExplodeOnCollisionMenuClass:new(customizeNPCPowers, explodeTypes, defaultExplodeIndex)
			setmetatable(MenuDependancies.newInstance, self)
			self.__index = self
			self.menu = menu.list(customizeNPCPowers, translate("Customize Explode On Collision •     >", "Customize Explode On Collision •     >"))
			self.toggle = createMenuToggle(NPCPowers, "EoC Explode on Collision ", false, function(on) SuperPowersConfig.explodeOnCollisionConfig.isExplodeOnCollisionOn = on end)
			self.distanceSlider = createMenuSlider(self.menu, "EoC Explosion Distance • >", "How far from the car to the player will count as a collision?", 1, 1000, math.floor(SuperPowersConfig.explodeOnCollisionConfig.explosionDistance * 10), 1, function(value) SuperPowersConfig.explodeOnCollisionConfig.explosionDistance = value / 10 end)
			self.typesSlider = menu.slider(self.menu, 
											translate("Type Selector", "Select NPC Explosion Type • >"), 
											{}, 
											"1 = InstaBoom. 2 = Tire Spikes. 3 = EMP. 4 = Player Thrower.",
											1, #explodeTypes, defaultExplodeIndex, 1,
											function(index)
												SuperPowersConfig.explodeOnCollisionConfig.explosionType = explodeTypes[index]
											end)
			self.damageSlider = createMenuSlider(self.menu, "EoCExplosion Damage • >", "Go nuts", 0, 1000, SuperPowersConfig.explodeOnCollisionConfig.explosionType, 1, function(value) SuperPowersConfig.explodeOnCollisionConfig.explosionType = value end)
			return newInstance
		end
		function MenuDependancies.ExplodeOnCollisionMenuClass2:new(customizeNPCPowers, explodeTypes2, defaultExplodeIndex2)
			local newInstance = setmetatable({}, self)
			self.__index = self
			self.menu = menu.list(customizeNPCPowers, "Customize Explode On Collision 2 • >")
			self.toggle = createMenuToggle(NPCPowers, "EoC2 Explode on Collision", false, function(on) SuperPowersConfig.explodeOnCollisionConfig2.isExplodeOnCollisionOn2 = on end)
			self.distanceSlider = createMenuSlider(self.menu, "EoC2 Explosion Distance • >", "How far from the car to the player will count as a collision?", 1, 1000, math.floor(SuperPowersConfig.explodeOnCollisionConfig2.explosionDistance2 * 10), 1, function(value) SuperPowersConfig.explodeOnCollisionConfig2.explosionDistance2 = value / 10 end)
			self.typesSlider = menu.slider(self.menu, "Select NPC Explosion Type 2 • >", explodeTypes2, "1 = InstaBoom. 2 = Tire Spikes. 3 = EMP. 4 = Player Thrower.", 1, #explodeTypes2, defaultExplodeIndex2, 1, function(index) SuperPowersConfig.explodeOnCollisionConfig2.explosionType2 = explodeTypes[index] end)
			self.damageSlider = createMenuSlider(self.menu, "EoC2 Explosion Damage • >", "Adjust explosion damage.", 0, 1000, SuperPowersConfig.explodeOnCollisionConfig2.explosionDamage, 1, function(value) SuperPowersConfig.explodeOnCollisionConfig2.explosionDamage = value end)
			return newInstance
		end
		function MenuDependancies.ExplodeOnCollisionMenuClass3:new(customizeNPCPowers, explodeTypes3, defaultExplodeIndex3)
			local newInstance = setmetatable({}, self)
			self.__index = self
			self.menu = menu.list(customizeNPCPowers, "Customize Explode On Collision 3 • >")
			self.toggle = createMenuToggle(NPCPowers, "EoC3 Explode on Collision", false, function(on) SuperPowersConfig.explodeOnCollisionConfig3.isExplodeOnCollisionOn3 = on end)
			self.distanceSlider = createMenuSlider(self.menu, "EoC3 Explosion Distance • >", "How far from the car to the player will count as a collision?", 1, 1000, math.floor(SuperPowersConfig.explodeOnCollisionConfig3.explosionDistance3 * 10), 1, function(value) SuperPowersConfig.explodeOnCollisionConfig3.explosionDistance3 = value / 10 end)
			self.typesSlider = menu.slider(self.menu, "Select NPC Explosion Type 3 • >", explodeTypes3, "1 = InstaBoom. 2 = Tire Spikes. 3 = EMP. 4 = Player Thrower.", 1, #explodeTypes3, defaultExplodeIndex3, 1, function(index) SuperPowersConfig.explodeOnCollisionConfig3.explosionType3 = explodeTypes[index] end)
			self.damageSlider = createMenuSlider(self.menu, "EoC3 Explosion Damage • >", "Adjust explosion damage.", 0, 1000, SuperPowersConfig.explodeOnCollisionConfig3.explosionDamage3, 1, function(value) SuperPowersConfig.explodeOnCollisionConfig3.explosionDamage3 = value end)
			return newInstance
		end
		function MenuDependancies.ExplodeOnCollisionMenuClass4:new(customizeNPCPowers, explodeTypes4, defaultExplodeIndex4)
			local newInstance = setmetatable({}, self)
			self.__index = self
			self.menu = menu.list(customizeNPCPowers, "Customize Explode On Collision 4 • >")
			self.toggle = createMenuToggle(NPCPowers, "EoC4 Explode on Collision", false, function(on) SuperPowersConfig.explodeOnCollisionConfig4.isExplodeOnCollisionOn4 = on end)
			self.distanceSlider = createMenuSlider(self.menu, "EoC4 Explosion Distance • >", "How far from the car to the player will count as a collision?", 1, 1000, math.floor(SuperPowersConfig.explodeOnCollisionConfig4.explosionDistance4 * 10), 1, function(value) SuperPowersConfig.explodeOnCollisionConfig4.explosionDistance4 = value / 10 end)
			self.typesSlider = menu.slider(self.menu, "Select NPC Explosion Type 4 • >", explodeTypes4, "1 = InstaBoom. 2 = Tire Spikes. 3 = EMP. 4 = Player Thrower.", 1, #explodeTypes4, defaultExplodeIndex4, 1, function(index) SuperPowersConfig.explodeOnCollisionConfig4.explosionType4 = explodeTypes[index] end)
			self.damageSlider = createMenuSlider(self.menu, "EoC4 Explosion Damage • >", "Adjust explosion damage.", 0, 1000, SuperPowersConfig.explodeOnCollisionConfig4.explosionDamage4, 1, function(value) SuperPowersConfig.explodeOnCollisionConfig4.explosionDamage4 = value end)
			return newInstance
		end
		function MenuDependancies.VehicleConditionsMenu:new(CTLVehConditions, config)
			self.onlyInVehiclesSlider = createMenuSlider(CTLVehConditions, "Proximity Homing | Only in player vehicles", "This forces super power behavior to prioritize towards player vehicles only", 0, 1, 0, 1, function(value)
				config.ConditionsConfig.onlyInVehiclesPH = value == 1
			end)
			self.onlyInVehiclesEoCSlider = createMenuSlider(CTLVehConditions, "Explode on Collision | Only in player vehicles", "This forces super power behavior to prioritize towards player vehicles only", 0, 1, 0, 1, function(value)
				config.ConditionsConfig.onlyInVehiclesEoC = value == 1
			end)
			self.onlyInVehiclesAPSlider = createMenuSlider(CTLVehConditions, "Audio Spam | Only in player vehicles", "This forces super power behavior to prioritize towards player vehicles only", 0, 1, 0, 1, function(value)
				config.ConditionsConfig.onlyInVehiclesAP = value == 1
			end)
			self.onlyInVehiclesJumpSlider = createMenuSlider(CTLVehConditions, "NPCJump Ability | Only in player vehicles", "This forces super power behavior to prioritize towards player vehicles only", 0, 1, 0, 1, function(value)
				config.ConditionsConfig.onlyInVehiclesJump = value == 1
			end)
			self.onlyInVehiclesBFSlider = createMenuSlider(CTLVehConditions, "BruteForce | Only in player vehicles", "This forces super power behavior to prioritize towards player vehicles only", 0, 1, 0, 1, function(value)
				config.ConditionsConfig.onlyInVehiclesBF = value == 1
			end)
			return self
		end
		function MenuDependancies.SuperPowersMenuClass:new(CTLCustoms, moreToolslist, NPCPowers)
			self.__index = self
			self.jumpCooldownToggle = createMenuToggle(CTLCustoms, "NPC Jump Ability", false, function(on) isJumpCooldownOn = on end)
			self.upwardforceSlider = createMenuSlider(CTLCustoms, "NPC Gravity Slider • >", "How strong is the NPC gravity? THIS NEEDS TO BE Enabled within > Add Super Powers > NPC Powers > NPC Gravity Control", -1000, 10000, math.floor(SuperPowersConfig.DWGravityConfig.downwards_force), 1, function(value) SuperPowersConfig.DWGravityConfig.downwards_force = value / 40 end)
			self.downwardsGravity = createMenuToggle(NPCPowers, "NPC Gravity Control", false, function(on) SuperPowersConfig.DWGravityConfig.isDownwardsGravityOn = on end)
			self.invincibilityAndMissionEntityToggle = createMenuToggle(NPCPowers, "Invincibility & Mission Entity", false, function(on) SuperPowersConfig.SuperSpeedConfig.isInvincibilityAndMissionEntityOn = on end)
			self.SuperHotToggle = createMenuToggle(NPCPowers, "SuperHot Homing", false, function(on) SuperPowersConfig.SuperHotConfig.isSuperHotOn = on end)
			self.proximityHomingToggle = createMenuToggle(NPCPowers, "Proximity Homing", false, function(on) SuperPowersConfig.ProximityHomingConfig.isProximityHomingOn = on end)
			self.superSpeedToggle = createMenuToggle(NPCPowers, "Super Speed", false, function(on) SuperPowersConfig.SuperSpeedConfig.isSuperSpeedOn = on end)
			self.superSpeedSlider = createMenuSlider(CTLCustoms, "Super Speed Multiplier • >", "Modify the engine power and wheel torque of NPC & Chaotic Drivers! THIS NEEDS TO BE Enabled within > Add Super Powers > NPC Powers > Super Speed", 0, 50000, 5000, 1000, function(value) SuperPowersConfig.SuperSpeedConfig.speedMultiplier = value end)
			return newInstance
		end
		function MenuDependancies.CTLSpecialsMenuClass:new(CTLSpecials)
			setmetatable(MenuDependancies.newInstance, self)
			self.__index = self
			self.BruteForceCounter = menu.toggle(CTLSpecials, "Turn Brute-Force into Smash Brawl", {}, false, function(val)
				BruteForceComboCounter = val
			end)
			self.BruteForceRapidAdd = menu.toggle(SmashBrawlContainer.SmashBrawlHitAdd, "+.33 Add to Hit Counter", {}, false, function(val)
				SuperPowersConfig.BruteForceConfig.isBruteForceRapidAddOn = val
			end)
			self.BruteForceRapidAdd = menu.toggle(SmashBrawlContainer.SmashBrawlHitAdd, "+3.33 Add to Hit Counter", {}, false, function(val)
				SuperPowersConfig.BruteForceConfig.isBruteForceRapidAdd2On = val
			end)
			self.BruteForceRapidAdd = menu.toggle(SmashBrawlContainer.SmashBrawlHitSub, "-2.66 Subtract from Hit Counter", {}, false, function(val)
				SuperPowersConfig.BruteForceConfig.isBruteForceRapidSubtractOn = val
			end)
			self.BruteForceRapidAdd = menu.toggle(SmashBrawlContainer.SmashBrawlHitSub, "-12.66 Subtract from Hit Counter", {}, false, function(val)
				SuperPowersConfig.BruteForceConfig.isBruteForceRapidSubtract2On = val
			end)
			self.AddDecrementValue = menu.toggle(SmashBrawlContainer.SmashBrawlDecAdd, "+.00040 Add to HPLoss", {}, false, function(val)
				SuperPowersConfig.BruteForceConfig.isIncrementDecrementValueOn = val
			end)
			self.SubtractDecrementValue = menu.toggle(SmashBrawlContainer.SmashBrawlDecSub, "-.00160 Subtract from HPLoss", {}, false, function(val)
				SuperPowersConfig.BruteForceConfig.isDecrementDecrementValueOn = val
			end)
			self.ProximityMPHMirror = menu.toggle(CTLSpecials, "Proximity Homing MPH & Range Mirroring", {}, false, function(val)
				ProximityMPHMirroring = val
			end)
			self.TargetPlayersInVehiclesToggle = menu.toggle(CTLSpecials, "NPCDrivers Hate Players in Vehicles", {}, false, function(val)
				targetPlayersInVehiclesOnly = val
			end)
			self.TargetPlayersOutsideVehiclesToggle = menu.toggle(CTLSpecials, "NPCDrivers Hate Players On Foot", {}, false, function(val)
				targetPlayersOutsideVehiclesOnly = val
			end)
			return newInstance
		end
		local MenusContainer = {
			PlayerProximity = MenuDependancies.PlayerProximityHomingMenuClass:new(customizePlayerPower),
			SmashBrawl = MenuDependancies.SmashBrawlMenuClass:new(customizeNPCPowers),
			AudioSpam = MenuDependancies.AudioSpamMenuClass:new(customizeNPCPowers),
			AudioSpam2 = MenuDependancies.AudioSpam2MenuClass:new(customizeNPCPowers),
			NodeTraffic = MenuDependancies.NodeTrafficMenuClass:new(customizeNPCPowers),
			ExplodeOnCollision = MenuDependancies.ExplodeOnCollisionMenuClass:new(customizeNPCPowers, explodeTypes, defaultExplodeIndex),
			ExplodeOnCollision2 = MenuDependancies.ExplodeOnCollisionMenuClass2:new(customizeNPCPowers, explodeTypes2, defaultExplodeIndex2),
			ExplodeOnCollision3 = MenuDependancies.ExplodeOnCollisionMenuClass3:new(customizeNPCPowers, explodeTypes3, defaultExplodeIndex3),
			ExplodeOnCollision3 = MenuDependancies.ExplodeOnCollisionMenuClass4:new(customizeNPCPowers, explodeTypes4, defaultExplodeIndex4),
			BruteForce = MenuDependancies.BruteForceMenuClass:new(customizeNPCPowers),
			PlayerBruteForce = MenuDependancies.PlayerBruteForceMenuClass:new(customizePlayerPower),
			SuperPowers = MenuDependancies.SuperPowersMenuClass:new(CTLCustoms, moreToolslist, NPCPowers),
			VehicleConditions = MenuDependancies.VehicleConditionsMenu:new(CTLVehConditions, SuperPowersConfig),
			CTLSpecials = MenuDependancies.CTLSpecialsMenuClass:new(CTLSpecials)
		}
		--presets
		MenuDependancies.presetMenuToggles.ResetPresets = createMenuToggle(CTLPresets, "Disable Presets + Despawn NPCs | You do not need to worry about this setting unless you are using Ultimate Custom Traffic > CTL Presets.", false, function(on) 
			ResetPresetsOn = on end)
		MenuDependancies.presetMenuToggles.SmashBrawlOn = createMenuToggle(CTLPresets, "NEW Smash Brawl Mode | Custom Traffic | NPC Drivers need to touch player cars in order to aquire more Hit Points, a higher Hit Point value gives NPCs powers automatically!", false, function(on) 
			settings.SmashBrawlOn.isOn = on end)
		MenuDependancies.presetMenuToggles.GamerModeOn = createMenuToggle(CTLPresets, "FAIR | GAMER MODE | A more fair experience for normal GTA players against Traffic. Applied Settings - NPC Attraction Range = 120 - MaxNPCs = 25 - Player Brute Force - ProximityHoming - OnlyInVehiclesPH", false, function(on) 
			settings.GamerModeOn.isOn = on end)
		MenuDependancies.presetMenuToggles.ComboModeOn = createMenuToggle(CTLPresets, "FAIR | COMBO MODE | NPC Drivers need to get combos on player cars to throw them across the map, additional powers already applied. Applied Settings - NPC Attraction Range = 120 - MaxNPCs = 25 - Player Brute Force - ProximityHoming - OnlyInVehiclesPH", false, function(on) 
			settings.ComboModeOn.isOn = on end)
		MenuDependancies.presetMenuToggles.FastNPCs = createMenuToggle(CTLPresets, "FAIR | Simply Fast NPCs | Turns any underperforming NPC into a speed demon! Applied Settings - NPC Attraction Range = 140 - MaxNPCs = 15 - Downwards Gravity - Super Speed", false, function(on) 
			settings.FastNPCsOn.isOn = on end)
		MenuDependancies.presetMenuToggles.SpeedyNPCs = createMenuToggle(CTLPresets, "RUDE | Speedy Strong Crowding NPCs | A Horde That Throws Player Cars! Applied Settings - NPC Attraction Range = 160 - MaxNPCs = 55 - Brute Force / Strength = 10 - Downwards Gravity - Super Speed", false, function(on) 
			settings.SpeedyNPCsOn.isOn = on end)
		MenuDependancies.presetMenuToggles.BumperCars = createMenuToggle(CTLPresets, "FUNNY | Bumper Cars | Woah - Home Run! Player Cars Throw NPCs to the moon. Applied Settings - NPC Attraction Range = 120 - MaxNPCs = 15 - Brute Force / Strength = 35 - Player Brute Force / Strength = 35 - Downwards Gravity - Super Speed - Jump Ability", false, function(on) 
			settings.BumperCarsOn.isOn = on end)
		MenuDependancies.presetMenuToggles.RabidHomingNPCs = createMenuToggle(CTLPresets, "UNFAIR | Rabid Homing NPCs | They won't stop lunging at me! Applied Settings - NPC Attraction Range = 120 - MaxNPCs = 55 - Brute Force / Strength = 3 - Proximity Homing - Downwards Gravity - Super Speed = 15,000", false, function(on) 
			settings.RabidHomingNPCsOn.isOn = on end)
		MenuDependancies.presetMenuToggles.DemonicNPCs = createMenuToggle(CTLPresets, "IMPOSSIBLE | Demonic Cars | Okay guys, who cursed the NPCs? Applied Settings - NPC Attraction Range = 460 - MaxNPCs = 126 - Brute Force / Strength = 395 - Player Brute Force / Strength = 15 - Player Proximity Homing CHAOS MODE - Proximity Homing CHAOS MODE - EoC CHAOS MODE - Downwards Gravity CHAOS MODE - Super Speed - Invincibility - Jump Ability", false, function(on) 
			settings.DemonicNPCsOn.isOn = on end)
		MenuDependancies.presetMenuToggles.ExplosiveEMPNPCs = createMenuToggle(CTLPresets, "EMP | EXPLOSIVE TRAFFIC | Short Circuit! | Looks like the NPCs are going haywire again. Applied Settings - NPC Attraction Range = 120 - MaxNPCs = 20 - EoC - Downwards Gravity - Super Speed", false, function(on) 
			settings.ExplosiveNPCsOn.isOn = on end)
		MenuDependancies.presetMenuToggles.SpikeExplosiveNPCs = createMenuToggle(CTLPresets, "TIRE SPIKES! | EXPLOSIVE TRAFFIC | Tire Spike Explosion On Collision! Applied Settings - NPC Attraction Range = 180 - MaxNPCs = 55 - EoC - Downwards Gravity - Super Speed", false, function(on) 
			settings.SpikeExplosiveNPCsOn.isOn = on end)
		MenuDependancies.presetMenuToggles.RandomExplosiveNPCs = createMenuToggle(CTLPresets, "RANDOM CHAOS | EXPLOSIVE TRAFFIC | Each explosion is Randomized, and has a 50/50 chance of doing 0 damage to players! Applied Settings - NPC Attraction Range = 180 - MaxNPCs = 55 - EoC - Downwards Gravity - Super Speed", false, function(on) 
			settings.RandomExplosiveNPCsOn.isOn = on end)
		MenuDependancies.presetMenuToggles.AnnoyingExplosiveNPCs = createMenuToggle(CTLPresets, "ANNOYING | EXPLOSIVE TRAFFIC | Annoying Explosion On Collision! Applied Settings - NPC Attraction Range = 180 - MaxNPCs = 55 - EoC - Downwards Gravity - Super Speed", false, function(on) 
			settings.AnnoyingExplosiveNPCsOn.isOn = on end)
		MenuDependancies.presetMenuToggles.CarPunchingNPCsOn = createMenuToggle(CTLPresets, "FUNNY | BOOMERANG TRAFFIC | Get them off my car! Applied Settings - NPC Attraction Range = 90 - MaxNPCs = 15 - Downwards Gravity - Player Brute Force - Brute Force - ProximityHoming + Range = 100", false, function(on) 
			settings.CarPunchingNPCsOn.isOn = on end)
		MenuDependancies.presetMenuToggles.SmashBrawlOn = createMenuToggle(SmashBrawlContainer.SmashBrawlFolder, "Smash Brawl Mode | Custom Traffic | NPC Drivers need to either touch or be in proximity of any player in order to aquire Hit Points -> with higher Hit Point values, grants more sophisticated NPCs powers, without you having to enable or disable anything.", false, function(on) 
			settings.SmashBrawlOn.isOn = on end)
			WorldClear = menu.action(SmashBrawlContainer.SmashBrawlFolder, "[{World Clear}]", {}, "Performs a clearing action by temporarily freezing the GTA Client for .7 seconds, spamming 10 delete functions, then unfreezing the client - in order to maximize entities cleared.", function()
				local WCVars = { 
					start = os.clock(), 
					interval = .7,
					deletedentities = 0,
					RAC = memory.alloc(4) 
				}
				local allEntities = {}
				for _, ent in ipairs(entities.get_all_vehicles_as_handles()) do table.insert(allEntities, ent) end
				for _, ent in ipairs(entities.get_all_peds_as_handles()) do table.insert(allEntities, ent) end
				for _, ent in ipairs(entities.get_all_objects_as_handles()) do table.insert(allEntities, ent) end
				for _, ent in ipairs(allEntities) do
					if not PED.IS_PED_A_PLAYER(ent) then
						entities.delete(ent)
						WCVars.deletedentities = WCVars.deletedentities + 1
					end
				end
				for i = 0, 100 do
					memory.write_int(WCVars.RAC, i)
					if PHYSICS.DOES_ROPE_EXIST(WCVars.RAC) then
						PHYSICS.DELETE_ROPE(WCVars.RAC)
						WCVars.deletedentities = WCVars.deletedentities + 1
					end
				end
				repeat until os.clock() - WCVars.start >= WCVars.interval
				util.toast("World Clear Complete. Entities Cleared: " .. WCVars.deletedentities)
			end)
			local ResetPresets = createMenuToggle(SmashBrawlContainer.SmashBrawlUtilities, "Disable SmashBrawl + Despawn NPCs | You will reset any customized NPC Powers within Custom Traffic if you enable this. Warning - Disable once enabled or Custom Traffic will not be permitted to function.", false, function(on) ResetPresetsOn = on end)
		util.create_thread(customTrafficLoop)
		local function findMDIndex(tbl, value)
			for index, v in ipairs(tbl) do
				if v == value then
					return index
				end
			end
			return 1
		end
		local modelNames = {
			"xs_terrain_dyst_ground_07",
			"xs_combined_dyst_03_build_d",
			"xs_terrain_set_dystopian_05",
			"xs_combined_dyst_06_roads",
			"xs_combined2_dyst_08_towers",
			"xs_combined2_terrain_dystopian_08",
			"xs_propint4_waste_10_trees",
			"xs_propint5_waste_09_ground",
			"xs_propint5_waste_07_ground",
			"xs_terrain_set_dystopian_09",
			"xs_propint3_waste_01_trees",
			"xs_propint3_waste_02_trees",
			"xs_propint3_waste_03_trees",
			"xs_propint3_waste_04_trees",
			"xs_propint4_waste_06_trees",
			"xs_propint4_waste_07_trees",
			"xs_propint4_waste_08_trees",
			"xs_propint4_waste_09_trees",
			"xs_propint4_waste_10_trees",
			"xs_prop_ar_tunnel_01a",
			"xs_prop_arena_gaspole_01",
			"xs_prop_arena_industrial_a",
			"xs_prop_arena_industrial_b",
			"xs_prop_arena_industrial_c",
			"xs_prop_arena_industrial_d",
			"xs_prop_arena_industrial_e",
			"xs_prop_arena_station_01a",
			"xs_prop_arena_station_02a",
			"xs_prop_arena_flipper_large_01a_sf",
			"xs_propint3_set_waste_03_licencep",
			"xs_propint3_waste04_wall",
			"xs_propint3_waste_01_bottles",
			"xs_propint3_waste_01_garbage_a",
			"xs_propint3_waste_01_garbage_b",
			"xs_propint3_waste_01_jumps",
			"xs_propint3_waste_01_neon",
			"xs_propint3_waste_01_plates",
			"xs_propint3_waste_01_rim",
			"xs_propint3_waste_01_statues",
			"xs_propint3_waste_01_trees",
			"xs_propint3_waste_02_garbage_a",
			"xs_propint3_waste_02_garbage_b",
			"xs_propint3_waste_02_garbage_c",
			"xs_propint3_waste_02_plates",
			"xs_propint3_waste_02_rims",
			"xs_propint3_waste_02_statues",
			"xs_propint3_waste_02_tires",
			"xs_propint3_waste_02_trees",
			"xs_propint3_waste_03_bikerim",
			"xs_propint3_waste_03_bluejump",
			"xs_propint3_waste_03_firering",
			"xs_propint3_waste_03_mascottes",
			"xs_propint3_waste_03_redjump",
			"xs_propint3_waste_03_siderim",
			"xs_propint3_waste_03_tirerim",
			"xs_propint3_waste_03_tires",
			"xs_propint3_waste_03_trees",
			"xs_propint3_waste_04_firering",
			"xs_propint3_waste_04_rims",
			"xs_propint3_waste_04_statues",
			"xs_propint3_waste_04_tires",
			"xs_propint3_waste_04_trees",
			"xs_propint3_waste_05_goals",
			"xs_propint3_waste_05_tires",
			"xs_propint4_waste_06_burgers",
			"xs_propint4_waste_06_garbage",
			"xs_propint4_waste_06_neon",
			"xs_propint4_waste_06_plates",
			"xs_propint4_waste_06_rim",
			"xs_propint4_waste_06_statue",
			"xs_propint4_waste_06_tire",
			"xs_propint4_waste_06_trees",
			"xs_propint4_waste_07_licence",
			"xs_propint4_waste_07_neon",
			"xs_propint4_waste_07_props",
			"xs_propint4_waste_07_props02",
			"xs_propint4_waste_07_rims",
			"xs_propint4_waste_07_statue_team",
			"xs_propint4_waste_07_tires",
			"xs_propint4_waste_07_trees",
			"xs_propint4_waste_08_garbage",
			"xs_propint4_waste_08_plates",
			"xs_propint4_waste_08_rim",
			"xs_propint4_waste_08_statue",
			"xs_propint4_waste_08_trees",
			"xs_propint4_waste_09_bikerim",
			"xs_propint4_waste_09_cans",
			"xs_propint4_waste_09_intube",
			"xs_propint4_waste_09_lollywall",
			"xs_propint4_waste_09_loops",
			"xs_propint4_waste_09_rim",
			"xs_propint4_waste_09_tire",
			"xs_propint4_waste_09_trees",
			"xs_propint4_waste_10_garbage",
			"xs_propint4_waste_10_plates",
			"xs_propint4_waste_10_statues",
			"xs_propint4_waste_10_tires",
			"xs_propint4_waste_10_trees",
			"xs_propint2_barrier_01",
			"xs_propint2_building_01",
			"xs_propint2_building_02",
			"xs_propint2_building_03",
			"xs_propint2_building_04",
			"xs_propint2_building_05",
			"xs_propint2_building_05b",
			"xs_propint2_building_06",
			"xs_propint2_building_07",
			"xs_propint2_building_08",
			"xs_propint2_building_base_01",
			"xs_propint2_building_base_02",
			"xs_propint2_building_base_03",
		}
		local defaultModelIndex = findMDIndex(modelNames, "xs_terrain_dyst_ground_07")
		local spawnTimer = nil
		local spawnEnabled = false
		local lastSpawnPositions = {}
		local randomSpawnEnabled = false
		local spawnCounter = 0
		local totalSpawnedModels = 0
		local lastToastTime = os.clock()
		local movedPlayers = {}
		function ProcessModels(hash)
			util.request_model(hash, 2000)
		end
		function spawnBrazil(pid)
			local coords = players.get_position(pid)
			if lastSpawnPositions[pid] then
				local lastCoords = lastSpawnPositions[pid]
				local distance = calculate_distance(coords.x, coords.y, coords.z, lastCoords.x, lastCoords.y, lastCoords.z)
				if distance <= 90 then
					util.toast("ProcessModels Spawned! Player has exceeded the maximum allowed unit distance.")
					return  
				end
			end
			local modelName = modelNames[defaultModelIndex]
			local hash = util.joaat(modelName)
			ProcessModels(hash)
			local dust = OBJECT.CREATE_OBJECT_NO_OFFSET(hash, coords['x'], coords['y'], coords['z']-40, true, false, false)
			if NETWORK.REGISTER_ENTITY_AS_NETWORKED then
				NETWORK.REGISTER_ENTITY_AS_NETWORKED(dust)
			end
			if NETWORK.OBJECT_TO_NET then
				local networkId = NETWORK.OBJECT_TO_NET(dust)
				NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(networkId, true)
			end
			ENTITY.FREEZE_ENTITY_POSITION(dust, true)
			lastSpawnPositions[pid] = coords
		end
		function Loop()
			while spawnEnabled do
				for pId = 0, 31 do
					if PLAYER.IS_PLAYER_PLAYING(pId) then
						spawnBrazil(pId)
					end
				end
				util.yield(1000)
			end
		end
		function randomSpawnBrazil(pid)
			local RSBVars = {
				coords = players.get_position(pid),
				lastCoords = lastSpawnPositions[pid],
				distance = nil,
				randomModelIndex = math.random(1, #modelNames),
				modelName = nil,
				hash = nil,
				dust = nil
			}
			if spawnCounter >= 1000 then
				randomSpawnEnabled = false
				util.toast("Spawn limit reached. Disabling random spawns.")
				return
			end
			if RSBVars.lastCoords then
				RSBVars.distance = calculate_distance(RSBVars.coords.x, RSBVars.coords.y, RSBVars.coords.z, RSBVars.lastCoords.x, RSBVars.lastCoords.y, RSBVars.lastCoords.z)
				if RSBVars.distance <= 50 then
					local playerName = PLAYER.GET_PLAYER_NAME(pid)
					if not movedPlayers[playerName] then
						movedPlayers[playerName] = true
					end
					return
				end
			end
			RSBVars.modelName = modelNames[RSBVars.randomModelIndex]
			RSBVars.hash = util.joaat(RSBVars.modelName)
			ProcessModels(RSBVars.hash)
			RSBVars.dust = OBJECT.CREATE_OBJECT_NO_OFFSET(RSBVars.hash, RSBVars.coords.x, RSBVars.coords.y, RSBVars.coords.z - 44, true, false, false)
			if NETWORK.REGISTER_ENTITY_AS_NETWORKED then
				NETWORK.REGISTER_ENTITY_AS_NETWORKED(RSBVars.dust)
			end
			if NETWORK.OBJECT_TO_NET then
				local networkId = NETWORK.OBJECT_TO_NET(RSBVars.dust)
				NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(networkId, true)
			end
			ENTITY.FREEZE_ENTITY_POSITION(RSBVars.dust, true)
			lastSpawnPositions[pid] = RSBVars.coords
			spawnCounter = spawnCounter + 1
		end
		
		function randomSpawnLoop()
			while randomSpawnEnabled do
				for pId = 0, 31 do
					if PLAYER.IS_PLAYER_PLAYING(pId) then
						randomSpawnBrazil(pId)
					end
				end
				if os.clock() - lastToastTime >= 5 then
					totalSpawnedModels = totalSpawnedModels + spawnCounter
					local movingPlayersList = {}
					for playerName, _ in pairs(movedPlayers) do
						table.insert(movingPlayersList, playerName)
					end
					util.toast("Spawned " .. spawnCounter .. " models in the last 5 seconds. Total models spawned: " .. totalSpawnedModels .. ".")
					spawnCounter = 0
					movedPlayers = {}
					lastToastTime = os.clock()
				end
				util.yield(600)
			end
		end
		function spawn1RandomGridPointsAroundPlayer(pId)
			if PLAYER.IS_PLAYER_PLAYING(pId) then
				local coords = players.get_position(pId)
				local offsets = {
					{0, 10},
					{0, -10},
					{10, 0},
					{-10, 0},
					{10, 10},
					{10, -10},
					{-10, 10},
					{-10, -10}
				}
				local n = #offsets
				while n > 2 do
					local k = math.random(n)
					offsets[n], offsets[k] = offsets[k], offsets[n]
					n = n - 1
				end
				for i = 1, 1 do
					local modelName = modelNames[math.random(#modelNames)]
					local hash = util.joaat(modelName)
					print("Hash: " .. tostring(hash))
					print("Coords: " .. tostring(coords))
					print("Offset: " .. tostring(offsets[i]))
					ProcessModels(hash)
					local dust = OBJECT.CREATE_OBJECT_NO_OFFSET(hash, coords['x'] + offsets[i][1], coords['y'] + offsets[i][2], coords['z'] -35, true, false, false)
					ENTITY.FREEZE_ENTITY_POSITION(dust, true)
					util.yield(100)
					totalSpawnedModels = totalSpawnedModels + 1
				end
				lastSpawnPositions[pId] = coords
			end
		end
		function spawn6RandomGridPointsAroundPlayer(pId)
			if PLAYER.IS_PLAYER_PLAYING(pId) then
				local coords = players.get_position(pId)
				local offsets = {
					{0, 10},
					{0, -10},
					{10, 0},
					{-10, 0},
					{10, 10},
					{10, -10},
					{-10, 10},
					{-10, -10}
				}
				local n = #offsets
				while n > 2 do
					local k = math.random(n)
					offsets[n], offsets[k] = offsets[k], offsets[n]
					n = n - 1
				end
				for i = 1, 6 do
					local modelName = modelNames[math.random(#modelNames)]
					local hash = util.joaat(modelName)
					print("Hash: " .. tostring(hash))
					print("Coords: " .. tostring(coords))
					print("Offset: " .. tostring(offsets[i]))
					ProcessModels(hash)
					local dust = OBJECT.CREATE_OBJECT_NO_OFFSET(hash, coords['x'] + offsets[i][1], coords['y'] + offsets[i][2], coords['z'] -40, true, false, false)
					ENTITY.FREEZE_ENTITY_POSITION(dust, true)
					util.yield(80)
					totalSpawnedModels = totalSpawnedModels + 1
				end
				lastSpawnPositions[pId] = coords
			end
		end
		function spawn6RandomPointsModelOnAll()
			for pId = 0, 31 do
				if PLAYER.IS_PLAYER_PLAYING(pId) then
					spawn6RandomGridPointsAroundPlayer(pId)
				end
			end
			util.toast("Spawned random objects around user grid points for all players. Total models spawned: " .. totalSpawnedModels)
		end
		function spawn1RandomPointsModelOnAll()
			for pId = 0, 31 do
				if PLAYER.IS_PLAYER_PLAYING(pId) then
					spawn1RandomGridPointsAroundPlayer(pId)
				end
			end
			util.toast("Spawned random objects around user grid points for all players. Total models spawned: " .. totalSpawnedModels)
		end
		function spawnSelectedModelOnAll()
			for pId = 0, 31 do
				if PLAYER.IS_PLAYER_PLAYING(pId) then
					spawnBrazil(pId)
				end
			end
			util.toast("Spawned model on all players: " .. modelNames[defaultModelIndex])
		end


		spawnBrazilToggle = createMenuToggle(SelectedWorldSpawns, "Loop Model Type on All •", false, function(on)
				spawnEnabled = on
				if on and not spawnTimer then
					spawnTimer = util.create_thread(Loop)
				elseif not on and spawnTimer then
					spawnTimer = nil
				end
			end)



			modelNameSlider = menu.slider(SelectedWorldSpawns, 
			translate("Model Selector", "Model Type • >"), 
			{}, 
			"1 ground1 2 builds 3 ground2 4 roads 5 towers 6 dystopian1 7 trees 8 ground3 9 ground4 10 dystopian2",
			1, #modelNames, defaultModelIndex, 1,
			function(index)
				defaultModelIndex = index
			end)



			spawnAction = menu.action(SelectedWorldSpawns, "Spawn Model Type on All", {}, "Spawns the model represented by the current slider value on all players.", function(on)
				spawnSelectedModelOnAll()
			end)
			spawn1RandomGridPointsAction = menu.action(RandomWorldSpawns, "1 Random Model on All Players", {}, "Spawns 1 random object, each player will get a different model to increase variation.", function(on)
				spawn1RandomPointsModelOnAll()
			end)
			spawn6RandomGridPointsAction = menu.action(RandomWorldSpawns, "6 Random Models on All Players", {}, "Spawns 6 random objects, each player will get a different model to increase variation.", function(on)
				spawn6RandomPointsModelOnAll()
			end)
			randomSpawnToggle = createMenuToggle(RandomWorldSpawns, "Trailing World Spawns | This enables a running conditioned loop that calculates how far all Players are from the center of mass from the most recently spawned model, which allows objects to dynamically spawn on all players as they individually move throughout the lobby, without objects spawning in and overlapping eachother.", false, function(on)
				randomSpawnEnabled = on
				if on then
					util.create_thread(randomSpawnLoop)
				end
			end)
			WorldClear = menu.action(WorldSpawns, "[{World Clear}]", {}, "Performs a clearing action by temporarily freezing the GTA Client for .7 seconds, spamming 10 delete functions, then unfreezing the client - in order to maximize entities cleared.", function()
				local WCVars = { 
					start = os.clock(), 
					interval = .7,
					deletedentities = 0,
					RAC = memory.alloc(4) 
				}
				local allEntities = {}
				for _, ent in ipairs(entities.get_all_vehicles_as_handles()) do table.insert(allEntities, ent) end
				for _, ent in ipairs(entities.get_all_peds_as_handles()) do table.insert(allEntities, ent) end
				for _, ent in ipairs(entities.get_all_objects_as_handles()) do table.insert(allEntities, ent) end
				for _, ent in ipairs(allEntities) do
					if not PED.IS_PED_A_PLAYER(ent) then
						entities.delete(ent)
						WCVars.deletedentities = WCVars.deletedentities + 1
					end
				end
				for i = 0, 100 do
					memory.write_int(WCVars.RAC, i)
					if PHYSICS.DOES_ROPE_EXIST(WCVars.RAC) then
						PHYSICS.DELETE_ROPE(WCVars.RAC)
						WCVars.deletedentities = WCVars.deletedentities + 1
					end
				end
				repeat until os.clock() - WCVars.start >= WCVars.interval
				util.toast("World Clear Complete. Entities Cleared: " .. WCVars.deletedentities)
			end)
			local HomingVehiclesOptions = menu.list(ExtraTrollingOptions, translate("Homing Vehicles Options", "Homing Vehicles"), {}, "Homing Vehicles Options")
			local HomingVehiclesCategoryNPCDrivers = menu.list(HomingVehiclesOptions, translate("NPCDrivers", "NPCDrivers"), {}, "NPCDriver Homing Options")
			local HomingVehiclesCategoryPlayers = menu.list(HomingVehiclesOptions, translate("Player Vehicles", "Player Vehicles"), {}, "Player Vehicle Homing Options")
			menu.toggle_loop(HomingVehiclesCategoryNPCDrivers, translate("Trolling", "Aggressive Homing Vehicles Toggle"), {}, "NPC Controlled vehicles are sent hurdling towards the spectated players center of mass at 10,056-MPH. Best used on Modders / Users inside Interiors - as the NPCDrivers sometimes no-clip through terrain and walls.", function()
				local THHTVars = {
					targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId),
					pushForceMultiplier = 10056.80,
					maxDistanceThreshold = 1,
					vehicleCoords = nil,
					targetPedCoords = nil,
					distanceToPlayer = nil,
					force = {x = nil, y = nil, z = nil},
					dx = nil,
					dy = nil,
					dz = nil
				}
				for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 7000.0)) do
					if TASK.GET_ACTIVE_VEHICLE_MISSION_TYPE(vehicle) ~= 6 then
						local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
						if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
							request_control_once(driver)
							ENTITY.SET_ENTITY_LOAD_COLLISION_FLAG(driver, true)
							TASK.TASK_VEHICLE_MISSION_PED_TARGET(driver, vehicle, THHTVars.targetPed, 6, 100.0, 0, 0.0, 0.0, true)
							ENTITY.SET_ENTITY_INVINCIBLE(vehicle, true)
						end
					end
				end
				for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 2225.0)) do
					local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
					if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
						THHTVars.vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
						THHTVars.targetPedCoords = ENTITY.GET_ENTITY_COORDS(THHTVars.targetPed, true)
						THHTVars.distanceToPlayer = calculate_distance(THHTVars.vehicleCoords.x, THHTVars.vehicleCoords.y, THHTVars.vehicleCoords.z, THHTVars.targetPedCoords.x, THHTVars.targetPedCoords.y, THHTVars.targetPedCoords.z)
						if THHTVars.distanceToPlayer > THHTVars.maxDistanceThreshold then
							THHTVars.dx = THHTVars.targetPedCoords.x - THHTVars.vehicleCoords.x
							THHTVars.dy = THHTVars.targetPedCoords.y - THHTVars.vehicleCoords.y
							THHTVars.dz = THHTVars.targetPedCoords.z - THHTVars.vehicleCoords.z
							THHTVars.force.x = THHTVars.dx * THHTVars.pushForceMultiplier
							THHTVars.force.y = THHTVars.dy * THHTVars.pushForceMultiplier
							THHTVars.force.z = THHTVars.dz * THHTVars.pushForceMultiplier
							if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle) then
								ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, THHTVars.force.x, THHTVars.force.y, THHTVars.force.z, 0, 0, 0, 0, false, false, true, false, true)
							end
						end
					end
				end
			end)
			menu.toggle_loop(HomingVehiclesCategoryNPCDrivers, translate("Trolling", "Regular Homing Vehicles Toggle"), {}, "NPC Controlled vehicles are sent hurdling towards the spectated players center of mass at 5-70MPH. ", function()
				local THHTVars = {
					targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId),
					pushForceMultiplier = 1,
					maxDistanceThreshold = 1,
					vehicleCoords = nil,
					targetPedCoords = nil,
					distanceToPlayer = nil,
					force = {x = nil, y = nil, z = nil},
					dx = nil,
					dy = nil,
					dz = nil
				}
				for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 7000.0)) do
					if TASK.GET_ACTIVE_VEHICLE_MISSION_TYPE(vehicle) ~= 6 then
						local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
						if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
							request_control_once(driver)
							ENTITY.SET_ENTITY_LOAD_COLLISION_FLAG(driver, true)
							TASK.TASK_VEHICLE_MISSION_PED_TARGET(driver, vehicle, THHTVars.targetPed, 6, 100.0, 0, 0.0, 0.0, true)
							ENTITY.SET_ENTITY_INVINCIBLE(vehicle, true)
						end
					end
				end
				for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 2225.0)) do
					local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
					if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
						THHTVars.vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
						THHTVars.targetPedCoords = ENTITY.GET_ENTITY_COORDS(THHTVars.targetPed, true)
						THHTVars.distanceToPlayer = calculate_distance(THHTVars.vehicleCoords.x, THHTVars.vehicleCoords.y, THHTVars.vehicleCoords.z, THHTVars.targetPedCoords.x, THHTVars.targetPedCoords.y, THHTVars.targetPedCoords.z)
						if THHTVars.distanceToPlayer > THHTVars.maxDistanceThreshold then
							THHTVars.dx = THHTVars.targetPedCoords.x - THHTVars.vehicleCoords.x
							THHTVars.dy = THHTVars.targetPedCoords.y - THHTVars.vehicleCoords.y
							THHTVars.dz = THHTVars.targetPedCoords.z - THHTVars.vehicleCoords.z
							THHTVars.force.x = THHTVars.dx * THHTVars.pushForceMultiplier
							THHTVars.force.y = THHTVars.dy * THHTVars.pushForceMultiplier
							THHTVars.force.z = THHTVars.dz * THHTVars.pushForceMultiplier
							if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle) then
								ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, THHTVars.force.x, THHTVars.force.y, THHTVars.force.z, 0, 0, 0, 0, false, false, true, false, true)
							end
						end
					end
				end
			end)
			menu.toggle_loop(HomingVehiclesCategoryNPCDrivers, translate("Trolling", "Gentle Homing Vehicles Toggle"), {}, "NPC Controlled vehicles are sent hurdling towards the spectated players center of mass at 1-MPH. ", function()
				local THHTVars = {
					targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId),
					pushForceMultiplier = 0.007,
					maxDistanceThreshold = 1,
					vehicleCoords = nil,
					targetPedCoords = nil,
					distanceToPlayer = nil,
					force = {x = nil, y = nil, z = nil},
					dx = nil,
					dy = nil,
					dz = nil
				}
				for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 7000.0)) do
					if TASK.GET_ACTIVE_VEHICLE_MISSION_TYPE(vehicle) ~= 6 then
						local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
						if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
							request_control_once(driver)
							ENTITY.SET_ENTITY_LOAD_COLLISION_FLAG(driver, true)
							TASK.TASK_VEHICLE_MISSION_PED_TARGET(driver, vehicle, THHTVars.targetPed, 6, 100.0, 0, 0.0, 0.0, true)
							ENTITY.SET_ENTITY_INVINCIBLE(vehicle, true)
						end
					end
				end
				for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 2225.0)) do
					local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
					if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
						THHTVars.vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
						THHTVars.targetPedCoords = ENTITY.GET_ENTITY_COORDS(THHTVars.targetPed, true)
						THHTVars.distanceToPlayer = calculate_distance(THHTVars.vehicleCoords.x, THHTVars.vehicleCoords.y, THHTVars.vehicleCoords.z, THHTVars.targetPedCoords.x, THHTVars.targetPedCoords.y, THHTVars.targetPedCoords.z)
						if THHTVars.distanceToPlayer > THHTVars.maxDistanceThreshold then
							THHTVars.dx = THHTVars.targetPedCoords.x - THHTVars.vehicleCoords.x
							THHTVars.dy = THHTVars.targetPedCoords.y - THHTVars.vehicleCoords.y
							THHTVars.dz = THHTVars.targetPedCoords.z - THHTVars.vehicleCoords.z
							THHTVars.force.x = THHTVars.dx * THHTVars.pushForceMultiplier
							THHTVars.force.y = THHTVars.dy * THHTVars.pushForceMultiplier
							THHTVars.force.z = THHTVars.dz * THHTVars.pushForceMultiplier
							if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle) then
								ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, THHTVars.force.x, THHTVars.force.y, THHTVars.force.z, 0, 0, 0, 0, false, false, true, false, true)
							end
						end
					end
				end
			end)
			menu.toggle_loop(HomingVehiclesCategoryPlayers, translate("Trolling", "Hybrid Homing Vehicles Toggle"), {}, "Launches both NPC & Player controlled Vehicles at once into the spectated players center of mass.", function()
				local THHTVars = {
					targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId),
					pushForceMultiplier = 1556.80,
					maxDistanceThreshold = 1,
					vehicleCoords = nil,
					targetPedCoords = nil,
					distanceToPlayer = nil,
					force = {x = nil, y = nil, z = nil},
					dx = nil,
					dy = nil,
					dz = nil
				}
				for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 7000.0)) do
					if TASK.GET_ACTIVE_VEHICLE_MISSION_TYPE(vehicle) ~= 6 then
						local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
						if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
							request_control_once(driver)
							ENTITY.SET_ENTITY_LOAD_COLLISION_FLAG(driver, true)
							TASK.TASK_VEHICLE_MISSION_PED_TARGET(driver, vehicle, THHTVars.targetPed, 6, 100.0, 0, 0.0, 0.0, true)
						end
					end
				end
				for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 2225.0)) do
					local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
					if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
						THHTVars.vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
						THHTVars.targetPedCoords = ENTITY.GET_ENTITY_COORDS(THHTVars.targetPed, true)
						THHTVars.distanceToPlayer = calculate_distance(THHTVars.vehicleCoords.x, THHTVars.vehicleCoords.y, THHTVars.vehicleCoords.z, THHTVars.targetPedCoords.x, THHTVars.targetPedCoords.y, THHTVars.targetPedCoords.z)
						if THHTVars.distanceToPlayer > THHTVars.maxDistanceThreshold then
							THHTVars.dx = THHTVars.targetPedCoords.x - THHTVars.vehicleCoords.x
							THHTVars.dy = THHTVars.targetPedCoords.y - THHTVars.vehicleCoords.y
							THHTVars.dz = THHTVars.targetPedCoords.z - THHTVars.vehicleCoords.z
							THHTVars.force.x = THHTVars.dx * THHTVars.pushForceMultiplier
							THHTVars.force.y = THHTVars.dy * THHTVars.pushForceMultiplier
							THHTVars.force.z = THHTVars.dz * THHTVars.pushForceMultiplier
							if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle) then
								ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, THHTVars.force.x, THHTVars.force.y, THHTVars.force.z, 0, 0, 0, 0, false, false, true, false, true)
							end
						end
					end
				end
			end)
			menu.toggle_loop(HomingVehiclesCategoryPlayers, translate("Trolling", "Launch Player Vehicles into Spectated"), {}, "Launches Player Controlled Vehicles towards the Spectated players center of mass, usually resulting in a lot of chaos and confusion for the parties affected.", function()
				local THHTVars = {
					targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId),
					pushForceMultiplier = 10000.80,
					maxDistanceThreshold = 1,
					vehicleCoords = nil,
					targetPedCoords = nil,
					distanceToPlayer = nil,
					force = {x = nil, y = nil, z = nil},
					dx = nil,
					dy = nil,
					dz = nil
				}
				for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 222115.0)) do
					local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
					if ENTITY.DOES_ENTITY_EXIST(driver) and PED.IS_PED_A_PLAYER(driver) then
						ENTITY.SET_ENTITY_LOAD_COLLISION_FLAG(vehicle, false, 1)
						THHTVars.vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
						THHTVars.targetPedCoords = ENTITY.GET_ENTITY_COORDS(THHTVars.targetPed, true)
						THHTVars.distanceToPlayer = calculate_distance(THHTVars.vehicleCoords.x, THHTVars.vehicleCoords.y, THHTVars.vehicleCoords.z, THHTVars.targetPedCoords.x, THHTVars.targetPedCoords.y, THHTVars.targetPedCoords.z)
			
						if THHTVars.distanceToPlayer > THHTVars.maxDistanceThreshold then
							THHTVars.dx = THHTVars.targetPedCoords.x - THHTVars.vehicleCoords.x
							THHTVars.dy = THHTVars.targetPedCoords.y - THHTVars.vehicleCoords.y
							THHTVars.dz = THHTVars.targetPedCoords.z - THHTVars.vehicleCoords.z
							THHTVars.force.x = THHTVars.dx * THHTVars.pushForceMultiplier
							THHTVars.force.y = THHTVars.dy * THHTVars.pushForceMultiplier
							THHTVars.force.z = THHTVars.dz * THHTVars.pushForceMultiplier
			
							if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle) then
								ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, THHTVars.force.x, THHTVars.force.y, THHTVars.force.z, 0, 0, 0, 0, false, false, true, false, true)
							end
						end
					end
				end
			end)
			menu.action(HomingVehiclesOptions, translate("Trolling", "Launch NPCs at Spectated Player"), {}, "Launches NPC Vehicles at the players center of mass.", function()
				local THHTVars = {
					targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId),
					pushForceMultiplier = 16.80,
					maxDistanceThreshold = 1,
					vehicleCoords = nil,
					targetPedCoords = nil,
					distanceToPlayer = nil,
					force = {x = nil, y = nil, z = nil},
					dx = nil,
					dy = nil,
					dz = nil
				}
				for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 7000.0)) do
					if TASK.GET_ACTIVE_VEHICLE_MISSION_TYPE(vehicle) ~= 6 then
						local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
						if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
							request_control_once(driver)
							ENTITY.SET_ENTITY_LOAD_COLLISION_FLAG(driver, true)
							TASK.TASK_VEHICLE_MISSION_PED_TARGET(driver, vehicle, THHTVars.targetPed, 6, 100.0, 0, 0.0, 0.0, true)
						end
					end
				end
				for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 2225.0)) do
					local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
					if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
						THHTVars.vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
						THHTVars.targetPedCoords = ENTITY.GET_ENTITY_COORDS(THHTVars.targetPed, true)
						THHTVars.distanceToPlayer = calculate_distance(THHTVars.vehicleCoords.x, THHTVars.vehicleCoords.y, THHTVars.vehicleCoords.z, THHTVars.targetPedCoords.x, THHTVars.targetPedCoords.y, THHTVars.targetPedCoords.z)
						if THHTVars.distanceToPlayer > THHTVars.maxDistanceThreshold then
							THHTVars.dx = THHTVars.targetPedCoords.x - THHTVars.vehicleCoords.x
							THHTVars.dy = THHTVars.targetPedCoords.y - THHTVars.vehicleCoords.y
							THHTVars.dz = THHTVars.targetPedCoords.z - THHTVars.vehicleCoords.z
							THHTVars.force.x = THHTVars.dx * THHTVars.pushForceMultiplier
							THHTVars.force.y = THHTVars.dy * THHTVars.pushForceMultiplier
							THHTVars.force.z = THHTVars.dz * THHTVars.pushForceMultiplier
							if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle) then
								ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, THHTVars.force.x, THHTVars.force.y, THHTVars.force.z, 0, 0, 0, 0, false, false, true, false, true)
							end
						end
					end
				end
			end)








			
			--[[menu.toggle_loop(ExtraTrollingOptions, translate("Trolling", "Hostile Traffic"), {}, "", function()
				local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
				for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 70.0)) do
					if TASK.GET_ACTIVE_VEHICLE_MISSION_TYPE(vehicle) ~= 6 then
						local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
						if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
							request_control_once(driver)
							PED.SET_PED_MAX_HEALTH(driver, 300)
							ENTITY.SET_ENTITY_HEALTH(driver, 300, 0)
							PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(driver, true)
							TASK.TASK_VEHICLE_MISSION_PED_TARGET(driver, vehicle, targetPed, 6, 100.0, 0, 0.0, 0.0, true)
						end
					end
				end
			end)]]









			menu.toggle_loop(ExtraTrollingOptions, translate("Trolling", "Make NPCs surround players vehicle [Experimental / Buggy]"), {}, "", function()
				-- Identify player-controlled vehicles
				local playerVehicles = {} -- Table to store player-controlled vehicles
				for _, pid in pairs(players.list(true, true, true)) do
					local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false)
					if playerVehicle ~= 0 then
						table.insert(playerVehicles, playerVehicle)
					end
				end
			
				-- Assign NPCs to enter player vehicles
				for _, vehicle in ipairs(playerVehicles) do
					for _, ped in pairs(entities.get_all_peds_as_handles()) do
						if not PED.IS_PED_A_PLAYER(ped) then
							request_control_once(ped)
							TASK.TASK_ENTER_VEHICLE(ped, vehicle, 20000, -1, 2.0, 8, 0)
						end
					end
				end
			end)
			menu.action(ExtraTrollingOptions, translate("Trolling", "Make NPCs surround players vehicle [Experimental / Buggy]"), {}, "v2", function()
				-- Identify player-controlled vehicles
				local playerVehicles = {} -- Table to store player-controlled vehicles
				for _, pid in pairs(players.list(true, true, true)) do
					local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false)
					if playerVehicle ~= 0 then
						table.insert(playerVehicles, playerVehicle)
					end
				end
			
				-- Assign NPCs to enter player vehicles
				for _, vehicle in ipairs(playerVehicles) do
					for _, ped in pairs(entities.get_all_peds_as_handles()) do
						if not PED.IS_PED_A_PLAYER(ped) then
							request_control_once(ped)
							PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
							TASK.TASK_ENTER_VEHICLE(ped, vehicle, 20000, -1, 2.0, 8, 0)
						end
					end
				end
			end)
			


			
			
end 

function onStopScript()
    scriptFns.despawnDeadPeds()
    scriptFns.clearNPCDrivers()
	scriptFns.deleteDestroyedVehicles()
end
players.on_join(ServerSide)
players.dispatch_on_join()
util.log("On join dispatched")