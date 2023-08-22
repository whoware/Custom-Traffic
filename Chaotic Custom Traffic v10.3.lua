--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||        WHOWARE CUSTOM TRAFFIC & POWERS         ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||        WHOWARE CUSTOM TRAFFIC & POWERS         ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
Traffic = 10
util.require_natives(1663599433)

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

---@param pId Player
ServerSide = function(pId)
	menu.divider(menu.player_root(pId), "WhoWare")

local playersReference
menu.action(menu.my_root(), translate("Player", "Take me to Custom Traffic"), {}, "Select either YOURSELF or ANOTHER PLAYER from the > Players list!", function()
	playersReference = playersReference or menu.ref_by_path("Players")
	menu.trigger_command(playersReference, "")
	
end)
	
	local function createMenuToggle(menuObj, optionName, default, toggleCallback)
		return menu.toggle(menuObj, translate(optionName, optionName), {}, default, toggleCallback)
	end
	
	local function createMenuSlider(menuObj, optionName, description, min, max, default, step, sliderCallback)
		return menu.slider(menuObj, translate(optionName, optionName), {}, description, min, max, default, step, sliderCallback)
	end

	local function calculate_distance(x1, y1, z1, x2, y2, z2)
		return math.sqrt((x1 - x2)^2 + (y1 - y2)^2 + (z1 - z2)^2)
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

	local function calculate_distance(x1, y1, z1, x2, y2, z2)--This function is available for any other function to use for calculations, mainly used by "BruteForce" and "Explode on Collision"
		local dx = x1 - x2
		local dy = y1 - y2
		local dz = z1 - z2
		return math.sqrt(dx * dx + dy * dy + dz * dz)
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
		tcxy = {
			TextColor = {r = 0, g = 0, b = 0, a = 0.40}, 
			x = 0.55,
			y = 0.80
		},
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
			TextColor = {r = 1, g = 1, b = 1, a = 0.30}, 
			x = 0.70, 
			y = 0.88  
		},
		bruteForceActivatedxy = {
			TextColor = {r = 1, g = 0, b = 0, a = 0.10}, 
			x = 0.50, 
			y = 0.86  
		},
		npcJumpActivatedxy = {
			TextColor = {r = 0, g = 0.8, b = 0.2, a = 0.15},
			x = 0.50, 
			y = 0.88  
		},
		playerProximityHomingActivatedxy = {
			TextColor = {r = 0, g = 0.8, b = 0.2, a = 0.15}, 
			x = 0.50, 
			y = 0.90  
		},
		proximityHomingActivatedxy = {
			TextColor = {r = 1, g = 0, b = 0, a = 0.15},
			x = 0.50, 
			y = 0.92  
		},
		explodeOnCollisionActivatedxy = {
			TextColor = {r = 1, g = 0, b = 0, a = 0.15}, 
			x = 0.50, 
			y = 0.94 
		},
		playerbruteForceActivatedxy = {
			TextColor = {r = 0, g = 0.8, b = 0.2, a = 0.15}, 
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

	local settings2 = {
		audioSpam = {
			isOn = false,
			TriggerDistance = 30.350,
			audioType = 58,
			audioDamage = 0,
			audioInvisible = true,
			spamAudible = true
		}
	}

	local settings = {
		audioSpam = {
			isOn = false,
			TriggerDistance = 30.350,
			audioType = 21,
			audioDamage = 0,
			audioInvisible = true,
			spamAudible = true
		},
		explodeOnCollision = {
			isOn = false,
			explosionDistance = 3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679,
			explosionType = 9,
			explosionDamage = 1,               -- 9 = instaboom 22 = flare 23 = weak fire bomp 43 = weird gas bomp
			explosionInvisible = false,
			explosionAudible = false
		},
		playerBruteForce = {
			isOn = false,
			push_timer = 0.6,
			push_cooldown = 0,
			push_threshold = 20.0,
			push_force_multiplier = 15
		},
		playerProximityHoming = {
			isOn = false,
			push_timer = 0,
			push_cooldown = 15, 
			push_threshold = 30, 
			push_force_multiplier = 1,
			distance_threshold = 10,
		},
		NPC_TimeWarp = {
			isOn = false,
			warp_timer = 0,
			warp_cooldown = 3000,
			warp_distance = 20,
		},
		playerGravityControl = {
			isOn = false,
			gravity_multiplier = 1,
		},
		despawnEntities = {
			isOn = false,
		},
		handleNpc = {
			isOn = false,
		},
		handleVehicle = {
			isOn = false,
		},
		clearNpc = {
			isOn = true,
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
		}
	}

	
	local trollingOpt <const> = menu.list(menu.player_root(pId), translate("Player", "Custom Traffic"), {}, "Turning 'Custom Traffic | Begin the Chaos onto one person, turns it on for everyone in the lobby. So even if you stop spectating the person you applied Custom Traffic to, and spectate someone else, Custom Traffic will remain running AS LONG AS THE PLAYER WHO YOU TURNED IT ONTO REMAINS IN THE LOBBY. Super Power settings will also still work so long Custom Traffic is ENABLED and the player you put it on is PRESENT.")


--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||            TROLLY VEHICLES REIMAGINED          ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||            TROLLY VEHICLES REIMAGINED          ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--

local function create_trolly_vehicle(targetId, vehicleHash, pedHash)
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

	-- More vehicle settings
	set_decor_flag(vehicle, DecorFlag_isTrollyVehicle)
	VEHICLE.SET_VEHICLE_MOD_KIT(vehicle, 0)

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
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||                   CTL CORE                     ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||                   CTL CORE                     ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--


	local customTrollingOpt = menu.list(trollingOpt, translate("Trolling", "Depriciated features"), {}, "Leftovers / extra space for future features")
	local CTLCustoms = menu.list(trollingOpt, translate("Trolling", "CTL Customs • SUPER | POWERS •         >"), {}, "Modify RAW Custom Traffic Functions in REALTIME, that of which all control the behavior of NPCs and the script while | Custom Traffic • NORMAL | MODE • RAW | is enabled.")
	local superPowersMenu = menu.list(CTLCustoms, translate("Ultimate Custom Traffic", "Add SuperPowers •                >"), {}, "Lets step it up a notch. Please note: Super powers and CTL need to only be applied to a single player per lobby! It is recommended you apply both super powers and CTL onto only yourself / or 1 other person!")
	local NPCJumpCore = menu.list(CTLCustoms, translate("Trolling", "NPC Jump behavior •             >"), {}, "Control the core Jump Conditions for NPCs")
	local max_health_slider = createMenuSlider(CTLCustoms, "Max Health", "", 0, 100000, 6000, 500, function(value) max_health = value end)
	local health_slider = createMenuSlider(CTLCustoms, "Health", "", 0, 100000, 6000, 500, function(value) health = value end)
	local CTLCustomsXT = menu.list(CTLCustoms, translate("Trolling", "CTL Customs Extras •            >"), {}, "Less important functions are kept in here incase the user ever needs them.")
	--Jumpcore
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
	local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
	local selectedPlayerId = {}
	local npcDrivers = {}
	local destroyedVehicles = {}
	local npcDriversCount = 15
	local maxNpcDrivers = 15
	local npcRange = 90
	local destroyedVehicleTime = 0
	local newDriverTime = 0
	local npcDriversCountPrev = 0 
	local bruteForceTime = 0 
	local playerbruteForceTime = 0
	local proximityHomingTime = 0
	local playerProximityHomingTime = 0
	local npcJumpTime = 0
	local explodeOnCollisionTime = 0


	--Superpower variables for "Super Speed/Invincibility"
	local isSuperSpeedOn = false
	local isInvincibilityAndMissionEntityOn = false
	local speedMultiplier = 1
	
	--Variables for the "BruteForce"
	local isBruteForceOn = false
	local push_timer = 0.6
	local push_cooldown = 2
	local push_threshold = 20.0 
	local push_force_multiplier = 25
	
	--ProximityHoming--
	local isProximityHomingOn = false
	local proximity_push_timer = 0
	local proximity_push_cooldown = 85
	local proximity_push_threshold = 30 
	local proximity_push_force_multiplier = 1 
	local proximity_distance_threshold = 10 
	
	--Downward Gravity--
	local isDownwardsGravityOn = false
	local gravity_multiplier = 1
	local downwards_force = -1.245 * gravity_multiplier

	local my_cur_car = entities.get_user_vehicle_as_handle()

	--Presets

	local function isAnyPresetActive()
		return settings.RabidHomingNPCsOn.isOn or 
			   settings.SpeedyNPCsOn.isOn or 
			   settings.FastNPCsOn.isOn or 
			   settings.BumperCarsOn.isOn or 
			   settings.DemonicNPCsOn.isOn or 
			   settings.ExplosiveNPCsOn.isOn or 
			   settings.SpikeExplosiveNPCsOn.isOn or 
			   settings.RandomExplosiveNPCsOn.isOn or 
			   settings.AnnoyingExplosiveNPCsOn.isOn
	end

	local function drawPreset(presetName, presetData)
		directx.draw_text(presetData.x, presetData.y, presetName, ALIGN_CENTRE, PresetUI.PRESET_SCALE.textScale, presetData.TextColor, false)
	end
	
		local function onSliderValueChanged(newMaxNpcDrivers)
			maxNpcDrivers = newMaxNpcDrivers
			removeExcessNPCDrivers()
		end	
	
		local function is_colliding(entity1, entity2)--this function is meant to detect collisions within the script, and is currently primarily used for Explode on Collision but other functions can be coded to use this local function
			return ENTITY.IS_ENTITY_TOUCHING_ENTITY(entity1, entity2)
		end
	
		local function is_player_in_tough_spot(player)
			local playerCoords = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player), false)
			return playerCoords.z > 0.5
		end
		
		local function distance_2d(a, b)
			return math.sqrt((b.x - a.x)^2 + (b.y - a.y)^2)
		end

		local function calculate_attraction_force(distance)
			return 2 ^ distance  -- Double the base attraction force for every 1 meter
		end
		
		local function should_npc_jump(driver, player)
			local driverCoords = ENTITY.GET_ENTITY_COORDS(driver, false)
			local playerCoords = ENTITY.GET_ENTITY_COORDS(player, false)
			local playerVelocity = ENTITY.GET_ENTITY_VELOCITY(player)
			
			local prediction_time = 0.3
		
			local predicted_position = calculate_future_position(playerCoords, playerVelocity, prediction_time)
			local dx, dy, dz = predicted_position.x - driverCoords.x, predicted_position.y - driverCoords.y, predicted_position.z - driverCoords.z
		
			local distanceXY = distance_2d(driverCoords, predicted_position)
			local distanceZ = math.abs(driverCoords.z - predicted_position.z)
		
			local player_speed = vector_magnitude(playerVelocity.x, playerVelocity.y, playerVelocity.z)
			local dynamic_force_multiplier = (dynamic_force_multiplier_value / 100) * ((constant_multiplier_value / 100) + player_speed / player_speed_divisor_value) 
		
			local max_height_difference = 3
		
			if distanceXY < 100 and distanceZ > 3 and driverCoords.z - playerCoords.z < max_height_difference then 
				npcJumpTime = os.clock()
		
				local jumpHeight = 8 
				
				-- Compensate for the downward gravity if it's on
				if isDownwardsGravityOn then
					local gravity_compensation = -downwards_force
					jumpHeight = jumpHeight + gravity_compensation
					jumpHeight = 14
					jump_cooldown_value = 175
				end
		
				local force = {
					x = dx * dynamic_force_multiplier,
					y = dy * dynamic_force_multiplier,
					z = jumpHeight
				}
		
				ENTITY.APPLY_FORCE_TO_ENTITY(driver, 1, force.x, force.y, force.z, 0, 0, 0, 0, false, false, true, false, true)
				return force
			else
				return nil
			end
		end
		
		local lastJump = newTimer()
		
	
		local function updateNpcDriversCount()--this function is responsible for keeping track of how many npc drivers are under control
			npcDriversCount = 0
			for driver, vehicle in pairs(npcDrivers) do
				if ENTITY.DOES_ENTITY_EXIST(driver) then
					npcDriversCount = npcDriversCount + 1
				else
					npcDrivers[driver] = nil
				end
			end
		end	
	
		local function applyDownwardForce(vehicle)
			if isDownwardsGravityOn then
				ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(vehicle, 1, 0, 0, downwards_force, false, false, true, false)
			end
		end
		
		local function downwardsGravity(pId)
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

		local function applyPlayerGravityControl(targetPed)
			local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(targetPed, false)
			if playerVehicle then
				NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(playerVehicle)
				local gravity_force = -1.395 * settings.playerGravityControl.gravity_multiplier
				ENTITY.APPLY_FORCE_TO_ENTITY(playerVehicle, 1, 0, 0, gravity_force, 0, 0, 1000, 0, false, false, false)
			end
		end

		function calculateDistance(coord1, coord2)
			local dx, dy, dz = coord2.x - coord1.x, coord2.y - coord1.y, coord2.z - coord1.z
			return math.sqrt(dx*dx + dy*dy + dz*dz)
		end
		
		function calculateForce(coord1, coord2)
			local dx, dy, dz = coord2.x - coord1.x, coord2.y - coord1.y, coord2.z - coord1.z
			return {x = dx * proximity_push_force_multiplier, y = dy * proximity_push_force_multiplier, z = dz * proximity_push_force_multiplier}
		end
	
		local function proximityHoming(driver, vehicle, targetPed)
			local vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
			local targetPedCoords = ENTITY.GET_ENTITY_COORDS(targetPed, true)
			local distance_to_player = calculateDistance(vehicleCoords, targetPedCoords)
		
			if distance_to_player <= proximity_distance_threshold then
				local force = calculateForce(vehicleCoords, targetPedCoords)
				
				if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle) then
					ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, force.x, force.y, force.z, 0, 0, 0, 0, false, false, true, false, true)
					ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, force.x, force.y, force.z, 0, 0, 0, 0, false, false, true, false, true)
					proximity_push_timer = current_ms() + proximity_push_cooldown
					proximityHomingTime = os.clock()
				end
			end
		end

		local function playerProximityHoming(driver, vehicle, targetPed)
			local vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
			local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(targetPed, false)
			local playerCoords = ENTITY.GET_ENTITY_COORDS(playerVehicle, true)
			local distance_to_player = calculateDistance(vehicleCoords, playerCoords)
			
			if distance_to_player <= settings.playerProximityHoming.distance_threshold then
				local force = calculateForce(playerCoords, vehicleCoords)
				
				if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(playerVehicle) then
					ENTITY.APPLY_FORCE_TO_ENTITY(playerVehicle, 1, force.x, force.y, force.z, 0, 0, 0, 0, false, false, true, false, true)
					ENTITY.APPLY_FORCE_TO_ENTITY(playerVehicle, 1, force.x, force.y, force.z, 0, 0, 0, 0, false, false, true, false, true)
					settings.playerProximityHoming.push_timer = current_ms() + settings.playerProximityHoming.push_cooldown
					playerProximityHomingTime = os.clock() -- Save the time when player proximity homing was activated
				end
			end
		end

		local function NPC_TimeWarp(driver, vehicle, targetPed)
			local vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
			local forwardVector = ENTITY.GET_ENTITY_FORWARD_VECTOR(vehicle)
			local warpCoords = {
				x = vehicleCoords.x + forwardVector.x * settings.NPC_TimeWarp.warp_distance,
				y = vehicleCoords.y + forwardVector.y * settings.NPC_TimeWarp.warp_distance,
				z = vehicleCoords.z
			}
	
			if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle) then
				ENTITY.SET_ENTITY_COORDS_NO_OFFSET(vehicle, warpCoords.x, warpCoords.y, warpCoords.z, false, false, true)
				settings.NPC_TimeWarp.warp_timer = current_ms() + settings.NPC_TimeWarp.warp_cooldown
			end
		end
		
	
		local function applySuperPowers(driver, vehicle)--this function controls applying super powers for any controlled npc while customTrafficLoop is enabled
			if isSuperSpeedOn then
				local current_top_speed = VEHICLE.GET_VEHICLE_MODEL_ESTIMATED_MAX_SPEED(ENTITY.GET_ENTITY_MODEL(vehicle))
				VEHICLE.MODIFY_VEHICLE_TOP_SPEED(vehicle, current_top_speed * speedMultiplier)
			end
		
			if isInvincibilityAndMissionEntityOn then--this function is meant to detect if "invincibility & mission entity" menu.slider is toggled on, and if it is it:
				ENTITY.SET_ENTITY_INVINCIBLE(vehicle, true)
				ENTITY.SET_ENTITY_INVINCIBLE(driver, true)
			else  -- this functions purpose is to Remove flags if invincibility & mission entity menu.slider is turned off
				ENTITY.SET_ENTITY_INVINCIBLE(vehicle, false)
				ENTITY.SET_ENTITY_INVINCIBLE(driver, false)
			end
		end		
		local function deleteDestroyedVehicles() --cleans
			for _, vehicle in ipairs(entities.get_all_vehicles_as_handles()) do
				if VEHICLE.IS_VEHICLE_DRIVEABLE(vehicle, false) == false or ENTITY.IS_ENTITY_DEAD(vehicle) then
					local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1)
					if not PED.IS_PED_A_PLAYER(driver) then
						ENTITY.SET_ENTITY_AS_MISSION_ENTITY(vehicle, false, false)
						entities.delete_by_handle(vehicle)
					end
				end
			end
		end
		
		
		local function handleDestroyedNpcDriver(driver)
			if not settings.handleNpc.isOn then
				return
			end
			if ENTITY.DOES_ENTITY_EXIST(driver) then
				local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID())
				local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(targetPed, false)
			end
		end
		
		local function handleVehicleDestroyed(driver, vehicle)
			if not ENTITY.DOES_ENTITY_EXIST(vehicle) or not VEHICLE.IS_VEHICLE_DRIVEABLE(vehicle, false) or ENTITY.IS_ENTITY_DEAD(vehicle) then
				handleDestroyedNpcDriver(driver)
				npcDrivers[driver] = nil
				destroyedVehicleTime = os.clock()
				destroyedDriverTime = os.clock() 
			end
		end
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||                ^ END OF CTL CORE ^             ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||              v MAIN EXCECUTION LOOP v          ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--

		local function customTraffic(pId)
			updateNpcDriversCount()
		
			if not is_player_active(pId, false, true) or not isCustomTrafficOn then
				util.toast("A major error has occured and the script cannot run for some reason. Player not active or custom traffic is off")
				return util.stop_thread()
			end
		
			local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
			local targetCoords = ENTITY.GET_ENTITY_COORDS(targetPed, true)
		
			for _, vehicle in ipairs(get_vehicles_in_player_range(pId, npcRange)) do
				if npcDriversCount >= maxNpcDrivers then
					drawMaxCount()
					break
				end
		
				if TASK.GET_ACTIVE_VEHICLE_MISSION_TYPE(vehicle) ~= 6 then
					local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
					local driverCoords = ENTITY.GET_ENTITY_COORDS(driver, true)
					local distance = calculate_distance(targetCoords.x, targetCoords.y, targetCoords.z, driverCoords.x, driverCoords.y, driverCoords.z)
					local max_health_val = menu.get_value(max_health_slider)
					local health_val = menu.get_value(health_slider)
					
					if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) and npcDrivers[driver] == nil then
						request_control_once(driver)
						PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(driver, true)
						TASK.TASK_VEHICLE_MISSION_PED_TARGET(driver, vehicle, targetPed, 6, 100.0, 0, 0.0, 0.0, true)
						PED.SET_PED_CAN_BE_KNOCKED_OFF_VEHICLE(driver, 1)
		
						npcDrivers[driver] = vehicle
						applySuperPowers(driver, vehicle)
						npcDriversCount = npcDriversCount + 1
						add_blip_for_entity(driver, 1, 9)
						PED.SET_PED_MAX_HEALTH(driver, max_health_val)
						ENTITY.SET_ENTITY_HEALTH(driver, health_val, 0)
						PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(driver, true)
						newDriverTime = os.clock() 
						npcDriversCountPrev = npcDriversCount
					end
				end
			end
			
			function drawTextLoop()
				local red = 1
				local green = math.max(3 - (npcDriversCount/7), 0) -- Decrease green as the count approaches 15
				GlobalTextVariables.tcxy.TextColor.r = red
				GlobalTextVariables.tcxy.TextColor.g = green
				directx.draw_text(GlobalTextVariables.tcxy.x, GlobalTextVariables.tcxy.y, "  NPC Drivers: " .. tostring(npcDriversCount), ALIGN_CENTRE, CountTextUI.DR_TXT_SCALE.textScale, GlobalTextVariables.tcxy.TextColor, false)
			end
			
			function drawPresetActiveText()
				if isAnyPresetActive() then
					drawPreset("PRESET ACTIVE •", GlobalTextVariables.Preset)
				end
				-- Check each preset here
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
			function drawDestroyedVehicle()
				if os.clock() - destroyedVehicleTime < 3 then 
					directx.draw_text(GlobalTextVariables.destroyedVehiclexy.x, GlobalTextVariables.destroyedVehiclexy.y, "An NPCDriver's vehicle has been destroyed!", ALIGN_CENTRE, CountTextUI.DR_TXT_SCALE.textScale, GlobalTextVariables.destroyedVehiclexy.TextColor, false)
				end
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
		end
		
		local function removeExcessNPCDrivers()
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
					entities.delete_by_handle(driver)
					entities.delete_by_handle(vehicle)
					npcDrivers[driver] = nil
					removedCount = removedCount + 1
				end
			end
			npcDriversCount = npcDriversCount - removedCount
		end
		
		local function clearNPCDrivers()
			if not settings.clearNpc.isOn then
				return
			end
			for driver, vehicle in pairs(npcDrivers) do
				if ENTITY.DOES_ENTITY_EXIST(driver) and ENTITY.DOES_ENTITY_EXIST(vehicle) then
					TASK.CLEAR_PED_TASKS_IMMEDIATELY(driver)
					ENTITY.SET_ENTITY_AS_MISSION_ENTITY(driver, false, false)
					ENTITY.SET_ENTITY_AS_MISSION_ENTITY(vehicle, false, false)
					PED.SET_PED_CAN_BE_TARGETTED(driver, true)
					TASK.TASK_WANDER_STANDARD(driver, 10.0, 10)
					entities.delete_by_handle(driver)
					entities.delete_by_handle(vehicle)
				end
			end
			npcDrivers = {}
		end
		
		local function updateTargetPlayers()
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
		
		local function despawnDeadPedsAndEmptyVehicles()
			if not settings.despawnEntities.isOn then
				return
			end
			for _, ped in ipairs(entities.get_all_peds_as_handles()) do
				if ENTITY.IS_ENTITY_DEAD(ped) and not PED.IS_PED_A_PLAYER(ped) then
					TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
					entities.delete_by_handle(ped)
				end
			end
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
			settings.playerBruteForce.isOn = false
			settings.playerProximityHoming.isOn = false
			settings.playerGravityControl.IsOn = false
			settings.explodeOnCollision.isOn = false
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
			proximity_push_threshold = 30 
			proximity_push_force_multiplier = 1 
			downwards_force = -1.245
			proximity_distance_threshold = 10 
			isDownwardsGravityOn = false
			npcDriversCount = 15
			maxNpcDrivers = 15
			npcRange = 90
			destroyedVehicleTime = 0
			newDriverTime = 0
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
			util.toast("Clean Slate Applied - NPC Behavior has been made default, please note that NPCs will still attempt to run players over after this.")
		end
		
		local function customTrafficLoop()
			push_timer = current_ms() + push_cooldown 
	
			while true do
				despawnDeadPedsAndEmptyVehicles()

				if settings.playerProximityHoming.isOn then
					for pId = 0, 31 do
						if is_player_active(pId, false, true) and isCustomTrafficOn then
							local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
							for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 50.0)) do
								local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
								if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
									playerProximityHoming(driver, vehicle, targetPed)
								end
							end
						end
					end
				end
				
				if settings.explodeOnCollision.isOn then --EoC
					for pId = 0, 31 do
						if is_player_active(pId, false, true) and isCustomTrafficOn then
							local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
							for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 65.0)) do
								local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
								if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
									local vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
									local targetPedCoords = ENTITY.GET_ENTITY_COORDS(targetPed, true)
									local distance_to_player = calculate_distance(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, targetPedCoords.x, targetPedCoords.y, targetPedCoords.z)				
									
									local function customTrafficLoop()
										while true do
									
											if isCustomTrafficOn then -- powers
												for pId, _ in pairs(targetPlayers) do
													if is_player_active(pId, false, true) then
														customTraffic(pId)
													end
												end
												for driver, vehicle in pairs(npcDrivers) do --powers
													applySuperPowers(driver, vehicle)
													applyDownwardForce(vehicle)
													if VEHICLE.IS_VEHICLE_DRIVEABLE(vehicle, false) == false or ENTITY.IS_ENTITY_DEAD(vehicle) then
														entities.delete_by_handle(driver)
														destroyedVehicles[vehicle] = true
														npcDrivers[driver] = nil
													end
												end
											end
										end
									end
									
									if distance_to_player <= settings.explodeOnCollision.explosionDistance then --EoC
										local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
										if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
											local explosionCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
											FIRE.ADD_EXPLOSION(explosionCoords.x, explosionCoords.y, explosionCoords.z, settings.explodeOnCollision.explosionType, settings.explodeOnCollision.explosionDamage, settings.explodeOnCollision.explosionAudible, settings.explodeOnCollision.explosionInvisible, 0)
											explodeOnCollisionTime = os.clock() 
										end
									end
								end
							end
						end
					end
				end

				if isBruteForceOn then --bf
					for pId = 0, 31 do
						if is_player_active(pId, false, true) and isCustomTrafficOn then
							local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
							for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 70.0)) do
								local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(targetPed, false)
								
								if playerVehicle ~= 0 and vehicle ~= playerVehicle and is_colliding(vehicle, playerVehicle) then
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
							end
						end
					end
				end

				if isProximityHomingOn then
					for pId = 0, 31 do
						if is_player_active(pId, false, true) and isCustomTrafficOn then
							local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
							for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 50.0)) do
								local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
								if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
									proximityHoming(driver, vehicle, targetPed)
								end
							end
						end
					end
				end
	
				if settings.audioSpam.isOn then --AP
					for pId = 0, 31 do
						if is_player_active(pId, false, true) and isCustomTrafficOn then
							local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
							for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 150.0)) do
								local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
								if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
									local vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
									local targetPedCoords = ENTITY.GET_ENTITY_COORDS(targetPed, true)
									local distance_to_player = calculate_distance(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, targetPedCoords.x, targetPedCoords.y, targetPedCoords.z)
				
									if distance_to_player <= settings.audioSpam.TriggerDistance then --AP
										local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
										if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
											local explosionCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
											FIRE.ADD_EXPLOSION(explosionCoords.x, explosionCoords.y, explosionCoords.z, settings.audioSpam.audioType, settings.audioSpam.audioDamage, settings.audioSpam.spamAudible, settings.audioSpam.audioInvisible, 1321.0, false)
										end
									end
								end									
							end
						end
					end
				end

				if settings2.audioSpam.isOn then --AP2
					for pId = 0, 31 do
						if is_player_active(pId, false, true) and isCustomTrafficOn then
							local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
							for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 150.0)) do
								local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
								if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
									local vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
									local targetPedCoords = ENTITY.GET_ENTITY_COORDS(targetPed, true)
									local distance_to_player = calculate_distance(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, targetPedCoords.x, targetPedCoords.y, targetPedCoords.z)
				
									if distance_to_player <= settings.audioSpam.TriggerDistance then --AP
										local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
										if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
											local explosionCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
											FIRE.ADD_EXPLOSION(explosionCoords.x, explosionCoords.y, explosionCoords.z, settings2.audioSpam.audioType, settings2.audioSpam.audioDamage, settings2.audioSpam.spamAudible, settings2.audioSpam.audioInvisible, 1321.0, false)
										end
									end
								end									
							end
						end
					end
				end
			

				if settings.playerBruteForce.isOn then --pbf
					for pId = 0, 31 do
						if is_player_active(pId, false, true) and isCustomTrafficOn then
							local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
							for _, npcVehicle in ipairs(get_vehicles_in_player_range(pId, 70.0)) do
								local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed, false)
				
								if playerVehicle ~= 0 and npcVehicle ~= playerVehicle and is_colliding(npcVehicle, playerVehicle) then
									local npcVehicleCoords = ENTITY.GET_ENTITY_COORDS(npcVehicle, true)
									local playerPedCoords = ENTITY.GET_ENTITY_COORDS(playerPed, true)
									local distance_to_player = calculate_distance(npcVehicleCoords.x, npcVehicleCoords.y, npcVehicleCoords.z, playerPedCoords.x, playerPedCoords.y, playerPedCoords.z)
				
									if distance_to_player <= settings.playerBruteForce.push_threshold and current_ms() >= settings.playerBruteForce.push_timer then
										local dx, dy, dz = npcVehicleCoords.x - playerPedCoords.x, npcVehicleCoords.y - playerPedCoords.y, npcVehicleCoords.z - playerPedCoords.z
										local force = {x = dx * settings.playerBruteForce.push_force_multiplier, y = dy * settings.playerBruteForce.push_force_multiplier, z = dz * settings.playerBruteForce.push_force_multiplier}
									
										if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(npcVehicle) then
											ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(npcVehicle, 1, force.x, force.y, force.z, false, false, true, false)
											settings.playerBruteForce.push_timer = current_ms() + settings.playerBruteForce.push_cooldown
											playerbruteForceTime = os.clock()
										end
									end									
								end
							end
						end
					end
				end

				if settings.playerGravityControl.isOn then
					for pId = 0, 31 do
						if is_player_active(pId, false, true) and isCustomTrafficOn then
							local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
							applyPlayerGravityControl(targetPed)
						end
					end
				end

				if settings.NPC_TimeWarp.isOn then
					for pId = 0, 31 do
						if is_player_active(pId, false, true) then
							local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
							for _, npcVehicle in ipairs(get_vehicles_in_player_range(pId, 70.0)) do
								NPC_TimeWarp(_, npcVehicle, playerPed)
							end
						end
					end
				end

				if ResetPresetsOn then
					isCustomTrafficOn = false
					isSuperSpeedOn = false
					isInvincibilityAndMissionEntityOn = false
					isBruteForceOn = false
					isJumpCooldownOn = false
					settings.playerBruteForce.isOn = false
					settings.playerProximityHoming.isOn = false
					settings.playerGravityControl.IsOn = false
					settings.explodeOnCollision.isOn = false
					settings.RabidHomingNPCsOn.isOn = false 
					settings.SpeedyNPCsOn.isOn = false 
					settings.FastNPCsOn.isOn = false 
					settings.BumperCarsOn.isOn = false 
					settings.DemonicNPCsOn.isOn = false 
					settings.ExplosiveNPCsOn.isOn = false 
					settings.SpikeExplosiveNPCsOn.isOn = false 
					settings.RandomExplosiveNPCsOn.isOn = false 
					settings.AnnoyingExplosiveNPCsOn.isOn = false
					explosionInvisible = false
					explosionAudible = false
					isProximityHomingOn = false
					isDownwardsGravityOn = false
					isOn = false
					audioInvisible = true
					spamAudible = true
					explosionDistance = 3
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
					npcDriversCount = 15
					maxNpcDrivers = 15
					npcRange = 90
					destroyedVehicleTime = 0
					newDriverTime = 0
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

				if settings.RabidHomingNPCsOn.isOn then
					isCustomTrafficOn = true
					isProximityHomingOn = true
					isSuperSpeedOn = true
					isDownwardsGravityOn = true
					isProximityHomingOn = true
					playerBruteForce = true
					isBruteForceOn = true
					isJumpCooldownOn = true
					push_force_multiplier = math.random(5, 15)
					npcRange = 120
					maxNpcDrivers = 55
					downwards_force = math.random(-8, 2)
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
					speedMultiplier = 15000
					SpeedyNPCsTime = os.clock()
				end

				if settings.FastNPCsOn.isOn then
					isCustomTrafficOn = true
					isSuperSpeedOn = true
					isDownwardsGravityOn = true
					npcRange = 140
					maxNpcDrivers = 15
					FastNPCsTime = os.clock()
				end

				if settings.BumperCarsOn.isOn then
					isCustomTrafficOn = true
					isSuperSpeedOn = true
					isDownwardsGravityOn = true
					isBruteForceOn = true
					settings.playerBruteForce.isOn = true
					push_force_multiplier = math.random(5, 35)
					settings.playerBruteForce.push_force_multiplier = math.random(5, 75)
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
					settings.playerBruteForce.isOn = true
					settings.playerBruteForce.push_force_multiplier = math.random(1, 75)
					settings.playerProximityHoming.distance_threshold = math.random(350, 1750)
					settings.playerProximityHoming.isOn = true
					settings.explodeOnCollision.isOn = true
					settings.explodeOnCollision.explosionType = math.random(1, 75)
					settings.explodeOnCollision.explosionDamage = math.random(0, 1)
					settings.explodeOnCollision.explosionDistance = math.random(3, 20)
					isJumpCooldownOn = true
					isInvincibilityAndMissionEntityOn = true
					push_force_multiplier = math.random(5, 150)
					npcRange = 460
					maxNpcDrivers = 126
					max_height_difference_value = 3
					distanceXY_value = 150
					distanceZ_value = 2
					proximity_distance_threshold = math.random(300, 1750)
					proximity_push_force_multiplier = math.random(15, 495)
					gravity_force = math.random(-28, 12)
					DemonicNPCsTime = os.clock()
				end

				if settings.ExplosiveNPCsOn.isOn then
					isCustomTrafficOn = true
					isSuperSpeedOn = true
					isDownwardsGravityOn = true
					settings.explodeOnCollision.isOn = true
					settings.explodeOnCollision.explosionType = 65
					settings.explodeOnCollision.explosionDamage = math.random(0, 1)
					npcRange = 120
					maxNpcDrivers = 20
					ExplosiveNPCsTime = os.clock()
				end

				if settings.SpikeExplosiveNPCsOn.isOn then
					isCustomTrafficOn = true
					isSuperSpeedOn = true
					isDownwardsGravityOn = true
					settings.explodeOnCollision.isOn = true
					settings.explodeOnCollision.explosionType = 66
					settings.explodeOnCollision.explosionDamage = math.random(0, 1)
					npcRange = 120
					maxNpcDrivers = 20
					SpikeExplosiveNPCsTime = os.clock()
				end

				if settings.RandomExplosiveNPCsOn.isOn then
					isCustomTrafficOn = true
					isSuperSpeedOn = true
					isDownwardsGravityOn = true
					settings.explodeOnCollision.isOn = true
					settings.explodeOnCollision.explosionType = math.random(1, 75)
					settings.explodeOnCollision.explosionDamage = math.random(0, 1)
					npcRange = 120
					maxNpcDrivers = 20
					RandomExplosiveNPCsTime = os.clock()
				end

				if settings.AnnoyingExplosiveNPCsOn.isOn then
					isCustomTrafficOn = true
					isSuperSpeedOn = true
					isDownwardsGravityOn = true
					settings.explodeOnCollision.isOn = true
					settings.explodeOnCollision.explosionType = 63
					settings.explodeOnCollision.explosionDamage = math.random(0, 1)
					npcRange = 120
					maxNpcDrivers = 20
				end

				
				if isJumpCooldownOn then
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

				updateNpcDriversCount()
				if isCustomTrafficOn then
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
							entities.delete_by_handle(vehicle)
							destroyedVehicles[vehicle] = true
							npcDrivers[driver] = nil
			
							handleDestroyedNpcDriver(driver)  
						end
					end
					removeExcessNPCDrivers()
				else
					clearNPCDrivers()
				end
			
				deleteDestroyedVehicles()
				util.yield()
			end
		end
		
		local function customTrafficToggle(on)
			isCustomTrafficOn = on
			if not isCustomTrafficOn then
				clearNPCDrivers()
			end
		end
		
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||     ^ END OF CUSTOM TRAFFIC LOOP ^             ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||    v CTL HOME / TOGGLES / FOLDERS v            ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
	
		local npcDriversSlider = menu.slider(CTLCustoms, translate("Ultimate Custom Traffic", "Number of NPC Drivers • >"), {}, "Control the amount of NPC Drivers you want chasing the player, decreasing the number deletes NPCs based on the value to save FPS",
		0, 126, 15, 1,
		function(value)
			maxNpcDrivers = value
			removeExcessNPCDrivers()
		end)
		local npcRangeSlider = menu.slider(CTLCustoms, translate("Ultimate Custom Traffic", "NPC Attraction Range • >"), {}, "Set your own custom range for how far from the player NPCs will become reaped for control, go wild.",
		20, 460, 90, 10,
		function(value)
			npcRange = value
		end)


		local toggleLoop = menu.toggle(trollingOpt, translate("Ultimate Custom Traffic", "Custom Traffic • NORMAL | MODE • RAW > "), {}, false, customTrafficToggle)
		local CTLPresets = menu.list(trollingOpt, translate("Trolling", "CTL Presets •                                             >"), {}, "Dont feel like customizing NPC Super powers right now? Try out a few pre-made presets to see whats possible at a glance | Tip: Don't be afraid to turn multiple presets on at once, every preset has SPECIAL abilities, that can be overlapped into other presets, just turn all corrsponding presets with powers you want on, then leave the final most powerful preset ON for highest NPC and PC preformance - turning all the weakest presets off except one. Dont worry, the settings wont undo unless they are overwritten / reset to default by you.")
		local CTLSpecials = menu.list(CTLCustoms, translate("Trolling", "CTL Special Settings •               >"), {}, "Apply special super powers that dont exist in native CTL Super powers. These settings give NPCs / Players special specific abilities.")
		local ResetPresets = menu.action(trollingOpt, "| Reset Default Settings |", {}, "Reset all existing / current active presets to a clean slate - WITHOUT turning Custom Traffic OFF. It's a seamless transition into NPC Normalcy, leave players rattled and confused!", function()
			resetPresetsToDefault()
		end)
		local ResetPresets = createMenuToggle(trollingOpt, "Disable Presets + Despawn NPCs | You do not need to worry about this setting unless you are using Custom Traffic > CTL Presets.", false, function(on) ResetPresetsOn = on end)

		local SchitzoToggle = menu.toggle(trollingOpt, "Schizophrenic Pedestrians", {}, false, function(on)
			MISC.SET_RIOT_MODE_ENABLED(on)
			
		
			if on then
				for pId = 0, 31 do
					for _, npc in ipairs(entities.get_all_peds_as_handles()) do
						local closestVehicle = nil
						local closestDistance = nil
					
						for _, vehicle in ipairs(entities.get_all_vehicles_as_handles()) do
							local npcPos = ENTITY.GET_ENTITY_COORDS(npc, true)
							local vehiclePos = ENTITY.GET_ENTITY_COORDS(vehicle, true)
		
							local distance = (npcPos.x - vehiclePos.x)^2 + (npcPos.y - vehiclePos.y)^2 + (npcPos.z - vehiclePos.z)^2  -- Squared distance between NPC and vehicle
		
							if not closestDistance or distance < closestDistance then
								closestDistance = distance
								closestVehicle = vehicle
							end
						end
		
						if closestVehicle then
							PED.SET_PED_INTO_VEHICLE(npc, closestVehicle, -1)
							util.yield(1500)
						end
					end					
				end
			end
		end)
		local handleNpcToggle = createMenuToggle(CTLCustomsXT, "Handle Destroyed NPC Driver", false, function(on) settings.handleNpc.isOn = on end)
		local handleVehicleToggle = createMenuToggle(CTLCustomsXT, "Handle Destroyed Vehicle", false, function(on) settings.handleVehicle.isOn = on end)
		local clearNpcToggle = createMenuToggle(CTLCustomsXT, "Clear NPC Drivers", true, function(on) settings.clearNpc.isOn = on end)
		local despawnEntitiesToggle = createMenuToggle(CTLCustomsXT, "Despawn Dead Peds and Empty Vehicles", false, function(on) settings.despawnEntities.isOn = on end)
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||              ^ END OF CTL CORE ^               ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||    v BEGINNING OF TROLLY VEHICLE INTERNALS v   ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--

		local trollyVehicles <const> = menu.list(trollingOpt, translate("Ultimate Custom Traffic", "Trolly Vehicles Reimagined"), {}, "This will spawn your choice of Peds and Vehicles to target players! Please note - you need to be spectating the player you want TROLLY VEHICLES to target. (Spawned Trolly Vehicles are operating separate from Custom Traffic! Additionally, Trollies are considered 'controlled / reaped', therefor when spawned, they automatically aquire user-enabled & configured super powers, whether Custom Traffic is enabled or not)")
		
		local options <const> = {
			--ground vehicles
			"bmx", "panto", "Dump", "slamvan6", "blazer5", "faction3", "Monster4", "stingertt", "buffalo5", "coureur", "Blazer", "rcbandito", "Barrage", 
			"Chernobog", "Ripley", "Zhaba", "Sandking", "Thruster", "Cerberus", "Wastelander", "Chimera", "Veto", 
			
			--helis
			"Skylift", "valkyrie", "supervolito", "maverick", "swift2", "buzzard2", "buzzard", "supervolito2", "cargobob3", "valkyrie2", "annihilator", 
			"havok", "swift", "cargobob", "frogger", "cargobob4", "seasparrow", "frogger2", "volatus", "savage", "hunt", "cargobob2", "akula", "hunter", 
			
			--planes
			"shamal", "nimbus", "velum2", "avenger", "blimp2", "microlight", "velum", "alphaz1",
			"tula", "blimp3", "duster", "bombushka", "blimp", "molotok", "pyro", "seabreeze", "volatol", "starling", "cuban800", "hydra", 
			"mogul", "titan", "lazer", "nokota", "miljet", "strikeforce", "howard", "cargoplane", "dodo", "besra", 
			
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
			"a_c_rabbit_01", "a_c_rat", "a_c_retriever", "a_c_rhesus", "a_c_rottweiler", "a_c_mtlion", "a_c_hen", "a_c_deer", "a_c_crow", 
			"a_c_coyote", "a_c_cow", "a_c_chop", "a_c_chimp", "a_c_chickenhawk", "a_c_cat_01", "a_c_boar"
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
		local spawnDelay = 15000
		local setInvincible = false
		local spawnCount = 1
		local count = 0
		local AttackType <const> = {
			explode = 0,
			dropMine = 1
		}
		local attacktype = 0
		local trollyVehiclesTable = {}
		local trollyVehicleTypesCount = {}
		local displayTrollyVehiclesCountToggleState = false
		local function remove_trolly_vehicle(vehicle)
			local vehicleType = trollyVehiclesTable[vehicle].type
			trollyVehiclesTable[vehicle] = nil
			if trollyVehicleTypesCount[vehicleType] then
				trollyVehicleTypesCount[vehicleType] = trollyVehicleTypesCount[vehicleType] - 1
				if trollyVehicleTypesCount[vehicleType] == 0 then
					trollyVehicleTypesCount[vehicleType] = nil
				end
			end
			updateNpcDriversCount()
		end

		local function updatetrollyVehicleTypesCount()
			updateNpcDriversCount()
			count = 0
			for vehicle, data in pairs(trollyVehiclesTable) do
				if ENTITY.IS_ENTITY_DEAD(data.driver) then
					remove_trolly_vehicle(vehicle)
				else
					count = count + 1
				end
			end
		end
		

		local function spawn_trolly_vehicle(option, pId, pedHash)
			local randomPedIndex = math.random(#currentPedList)
			local pedHash <const> = util.joaat(currentPedList[randomPedIndex])			
			local vehicleHash <const> = util.joaat(option)
			local vehicle, driver = create_trolly_vehicle(pId, vehicleHash, pedHash)		
			ENTITY.SET_ENTITY_INVINCIBLE(vehicle, setInvincible)
			ENTITY.SET_ENTITY_VISIBLE(driver, true, true)
			trollyVehiclesTable[vehicle] = { type = option, driver = driver }
			if trollyVehicleTypesCount[option] then
				trollyVehicleTypesCount[option] = trollyVehicleTypesCount[option] + 1
			else
				trollyVehicleTypesCount[option] = 1
			end

			if option == "Thruster" then
				for i = 1, 8 do
					local weaponHash <const> = util.joaat("VEHICLE_WEAPON_SPACE_ROCKET")
					WEAPON.REMOVE_WEAPON_FROM_PED(driver, weaponHash, i)
				end
			end
			add_blip_for_entity(vehicle, 1, 25)
		end
		
		menu.toggle_loop(trollyVehicles, translate("Trolling", "Persistant Random Trolly Vehicles"), {}, "Sends a RANDOM Trolly Vehicle every 15 seconds. Customize this yourself if you want spawn rates to be lower.", function()
			if not is_player_active(pId, false, true) then
				return util.stop_thread()
			end
		
			local randomVehicleIndex = math.random(#options)
			local randomVehicle = options[randomVehicleIndex]
			local randomPedIndex = math.random(#currentPedList)
			local pedHash <const> = util.joaat(currentPedList[randomPedIndex])			
			util.toast(string.format('Fetching %s(s) every %d ms...', randomVehicle, spawnDelay))
		
			spawn_trolly_vehicle(randomVehicle, pId, pedHash)
			util.toast(string.format('%s Fetched!', randomVehicle))
		
			util.yield(spawnDelay)
		end)

		local spawnDelaySlider = createMenuSlider(trollyVehicles, "Spawn Delay • >", "Modify the delay between trolly vehicle spawns in milliseconds.", 1000, 60000, 5000, 1000, function(value) 
			spawnDelay = value 
		end)

		menu.action(trollyVehicles, translate("Trolling", "Send Random Trolly Vehicle"), {}, "This option sends a random vehicle from the trolly vehicle options", function()
			local i = 0
			local randomVehicleIndex = math.random(#options)
			local randomVehicle = options[randomVehicleIndex]
			local randomPedIndex = math.random(#currentPedList)
			local pedHash <const> = util.joaat(currentPedList[randomPedIndex])			
			util.toast(string.format('Fetching %d %s(s) every %d ms...', spawnCount, randomVehicle, 520)) -- use spawnCount instead of count
			repeat
				spawn_trolly_vehicle(randomVehicle, pId, pedHash)
				i = i + 1
				util.yield(520)
			until i == spawnCount  -- use spawnCount instead of count
			util.toast(string.format('%d %s Fetched!', spawnCount, randomVehicle)) -- use spawnCount instead of count
		end)

		menu.slider(trollyVehicles, translate("Trolling", "Choose Ped Type"), {}, "Choose between Animals(0) or Humans(1). Please note, between these two categories, there is around 30+ different models contained within the tables. This is done to randomize the Model each spawn which increases the maximum allowed entities by bypassing stands object-spam detection. Previously 50 objects was the max, now you can reach 100-150 before the menu begins deletion.", 0, 1, 0, 1, function(val)
			if val == 0 then
				currentPedList = pedAnimals
			else
				currentPedList = pedModels
			end
		end)

		menu.action_slider(trollyVehicles, translate("Trolling", "Send Trolly Vehicle"), {}, "", options, function(index, opt)
			local i = 0
			util.toast(string.format('Fetching %d %s(s) every %d ms...', spawnCount, opt, 520)) -- use spawnCount instead of count
			repeat
				if opt == "Go-Kart" then
					local vehicleHash <const> = util.joaat("veto2")
					local gokart, driver = create_trolly_vehicle(pId, vehicleHash, pedHash)
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
					spawn_trolly_vehicle(opt, pId, pedHash)
				end
				i = i + 1
				util.yield(520)
			until i == spawnCount  -- use spawnCount instead of count
			util.toast(string.format('%d %s Fetched!', spawnCount, opt)) -- use spawnCount instead of count
		end)

		menu.slider(trollyVehicles, translate("Trolling - Trolly Vehicles", "Amount"), {}, "",
		1, 99, 1, 1, function(value) spawnCount = value end)  -- update spawnCount instead of count
		menu.toggle(trollyVehicles, translate("Trolling - Trolly Vehicles", "Invincible?"), {}, "",
		function(toggle) setInvincible = toggle end)
		menu.action(trollyVehicles, translate("Trolling - Trolly Vehicles", "Delete Trolly's"), {}, "Forces all functions except deletion from occuring, then spams the session with 10 delete requests within 3 seconds, after which the script releases your client from the intentional freeze. This is done in order to reduce lobby desync issues overtime due to entity overflowing via improper deletion", function()
			local start = os.clock()
			local interval = 3 / 10 -- executes 10 times within 3 seconds, so every 0.3 seconds
			local clearedEntities = 0 -- counter for cleared entities
			for i = 1, 10 do
				for _, vehicle in ipairs(entities.get_all_vehicles_as_handles()) do
					if is_decor_flag_set(vehicle, DecorFlag_isTrollyVehicle) then
						local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
						entities.delete_by_handle(driver)
						entities.delete_by_handle(vehicle)
						clearedEntities = clearedEntities + 1
						remove_trolly_vehicle(vehicle) -- Call the function to update trollyVehicleTypesCount
					elseif VEHICLE.IS_VEHICLE_DRIVEABLE(vehicle, false) == false or ENTITY.IS_ENTITY_DEAD(vehicle) then
						local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1)
						if not PED.IS_PED_A_PLAYER(driver) then
							ENTITY.SET_ENTITY_AS_MISSION_ENTITY(vehicle, false, false)
							entities.delete_by_handle(vehicle)
							clearedEntities = clearedEntities + 1
						end
					end
				end
				repeat until os.clock() - start >= interval * i
			end
			util.toast(string.format('(Freeze is coded in and intentional, dont worry) World Cleared! %d entities removed. If you commonly need to clear your lobbies due to desync buildup, consider keeping your values lower, especially in higher ping lobbies.', clearedEntities))
		end)

				function getOffsetFromEntityGivenDistance(entity, distance)
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

			menu.action(CTLCustomsXT, translate("Trolling - Trolly Vehicles", "Delete NPCDrivers"), {}, "Forces all functions except deletion from occurring, then spams the session with 10 delete requests within 3 seconds, after which the script releases your client from the intentional freeze. This is done in order to reduce lobby desync issues overtime due to entity overflowing via improper deletion", function()
				local start = os.clock()
				local interval = 3 / 10 -- executes 10 times within 3 seconds, so every 0.3 seconds
				local clearedEntities = 0 -- counter for cleared entities
			
				for i = 1, 10 do
					-- Deletion conditions for reaped NPC drivers
					for driver, vehicle in pairs(npcDrivers) do
						if ENTITY.DOES_ENTITY_EXIST(driver) and ENTITY.DOES_ENTITY_EXIST(vehicle) then
							TASK.CLEAR_PED_TASKS_IMMEDIATELY(driver)
							ENTITY.SET_ENTITY_AS_MISSION_ENTITY(driver, false, false)
							ENTITY.SET_ENTITY_AS_MISSION_ENTITY(vehicle, false, false)
							entities.delete_by_handle(driver)
							entities.delete_by_handle(vehicle)
							clearedEntities = clearedEntities + 1
							npcDrivers[driver] = nil
						end
					end
					repeat until os.clock() - start >= interval * i 
				end
			
				removeExcessNPCDrivers() -- Call the removal function to remove excess NPC drivers after the deletion process
			
				util.toast(string.format('World Cleared! %d entities removed. If you commonly need to clear your lobbies due to desync buildup, consider keeping your values lower, especially in higher ping lobbies.', clearedEntities))
			end)
	
	function getClosestPlayer(currentPed)
		local minDistance = math.huge
		local closestPlayer = -1
		for i = 0, 31 do
			if players.exists(i) then
				local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(i)
				if targetPed ~= currentPed then
					local distance = ENTITY.GET_ENTITY_COORDS(targetPed):distance(ENTITY.GET_ENTITY_COORDS(currentPed))
					if distance < minDistance then
						minDistance = distance
						closestPlayer = i
					end
				end
			end
		end
		return closestPlayer
	end
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||       ^ END OF TROLLY VEHICLES INTERNALS ^        ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||   v BEGINNING AND END OF MENU.LIST STRUCTURE v    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
--==||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||==--
	
		local extraTraffic = menu.list(trollyVehicles, translate("Ultimate Custom Traffic", "Extra Traffic Options •     >"), {}, "Extra options that ill throw in as later updates come")
		local extrasList = menu.list(extraTraffic, translate("Ultimate Custom Traffic", "X Extra Traffic Options •     >"), {}, "The functions inside of this folder are the god fathers of the Super powers within > CTL Customs. I decided to keep them in the script in their raw form, since they have their own practical applications. Be warned, in their raw forms, they are unrestricted and have been configured for the purpose of trolling / griefing. Do not apply these to anyone you care about.")
		
		--room for x extras


		local moreToolslist = menu.list(customTrollingOpt, translate("Ultimate Custom Traffic", "More Tools / Options •     >"), {}, "Go crazy, go stupid.")
		
		local NPCPowers = menu.list(superPowersMenu, translate("Ultimate Custom Traffic", "NPC Powers •     >"), {}, "Powers within this tab will apply to NPCDrivers and Trolly Drivers.")
		local customizeNPCPowers = menu.list(NPCPowers, translate("Ultimate Custom Traffic", "Customize NPC Powers •     >"), {}, "Go crazy, go stupid. Please note: These settings only need to be configured once per lobby IF you apply them to yourself and spectate OTHER players. CTL will iterate THROUGH whoever has CTL enabled, so it's recommended to apply them to yourself and sit offmap / in the ocean, then spectate people and watch the chaos start around them as CTL iterates through you!")
		
		local PlayerPower = menu.list(superPowersMenu, translate("Ultimate Custom Traffic", "Player Powers •     >"), {}, "Powers within this tab will apply to Players and their cars.")
		local customizePlayerPower = menu.list(PlayerPower, translate("Ultimate Custom Traffic", "Customize Player Powers •     >"), {}, "Please note: These settings only need to be configured once per lobby IF you apply them to yourself and spectate OTHER players. CTL will iterate THROUGH whoever has CTL enabled, so it's recommended to apply them to yourself and sit offmap / in the ocean, then spectate people and watch the chaos start around them as CTL iterates through you!")


		local jumpCooldownToggle = createMenuToggle(NPCJumpCore, "NPC Jump Ability", false, function(on) isJumpCooldownOn = on end)
		local upwardforceSlider2 = createMenuSlider(CTLCustoms, "NPC Gravity • >", "How strong is the NPC gravity? THIS NEEDS TO BE Enabled within > Add Super Powers > NPC Powers > Downwards Gravity", -1000, 10000, math.floor(downwards_force), 1, function(value) downwards_force = value / 10 end)
		local gravityMultiplierSlider = createMenuSlider(CTLCustoms, "Player Gravity • >", "How strong is the Player gravity? THIS NEEDS TO BE Enabled within > Add Super Powers > Player Powers > Player Gravity", 0, 100, settings.playerGravityControl.gravity_multiplier, 1, function(value) settings.playerGravityControl.gravity_multiplier = value end)
		local playerGravityControlToggle = createMenuToggle(PlayerPower, "Player Gravity Control", false, function(on) settings.playerGravityControl.isOn = on end)

		local downwardsGravity = createMenuToggle(NPCPowers, "Downwards Gravity", false, function(on) isDownwardsGravityOn = on end)
		local invincibilityAndMissionEntityToggle = createMenuToggle(NPCPowers, "Invincibility & Mission Entity", false, function(on) isInvincibilityAndMissionEntityOn = on end)
		local superSpeedToggle = createMenuToggle(NPCPowers, "Super Speed", false, function(on) isSuperSpeedOn = on end)

		local playerProximityHomingMenu = menu.list(customizePlayerPower, translate("Customize Player Proximity Homing •     >", "Customize Player Proximity Homing •     >"))
		local pushCooldownSlider = createMenuSlider(playerProximityHomingMenu, "PH Player Lunge Cooldown", "", 0, 10000, settings.playerProximityHoming.push_cooldown, 100, function(value) settings.playerProximityHoming.push_cooldown = value end)
		local pushTimerSlider = createMenuSlider(playerProximityHomingMenu, "PH Player Lunge Duration", "?", 0, 2000, settings.playerProximityHoming.push_timer, 1, function(value) settings.playerProximityHoming.push_timer = value end)
		local pushThresholdSlider = createMenuSlider(playerProximityHomingMenu, "PH Player Lunge Threshold", "How powerful will the player be attracted to the NPC within their range?", 0, 5000, settings.playerProximityHoming.push_threshold, 1, function(value) settings.playerProximityHoming.push_threshold = value end)
		local pushForceMultiplierSlider = createMenuSlider(playerProximityHomingMenu, "PH Lunge Force Multiplier", "Multiples the Lunge Threshold value by this value", 0, 5000, settings.playerProximityHoming.push_force_multiplier * 5, 1, function(value) settings.playerProximityHoming.push_force_multiplier = value / 100 end)
		local distanceThresholdSlider = createMenuSlider(playerProximityHomingMenu, "PH Attraction Range", "How close before the player lunges at the NPC to keep them pinned", 0, 5000, (settings.playerProximityHoming.distance_threshold * 10) - 85, 1, function(value) settings.playerProximityHoming.distance_threshold = (value + 85) / 10 end)
		local playerProximityHomingToggle = createMenuToggle(PlayerPower, "Player Proximity Homing", false, function(on) settings.playerProximityHoming.isOn = on end)
		
		local superSpeedSlider = createMenuSlider(customizeNPCPowers, "Super Speed Multiplier • >", "Modify the engine power and wheel torque of NPC & Trolly Drivers!", 0, 50000, 5000, 1000, function(value) speedMultiplier = value end)
		
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
		
		local playerBruteForceToggle = createMenuToggle(PlayerPower, "Player Brute Force", false, function(on) settings.playerBruteForce.isOn = on end)
		local playerBruteForce = menu.list(customizePlayerPower, translate("Customize Player BruteForce •     >", "Customize Player BruteForce •     >"))
		local pushTimerSliderPlayerBruteF = createMenuSlider(playerBruteForce, "Player BruteF Push Timer (ms) • >", "Cooldown between pushes in ms", 1, 1000, settings.playerBruteForce.push_cooldown, 25, function(value) settings.playerBruteForce.push_cooldown = value end)
		local pushThresholdSliderPlayerBruteF = createMenuSlider(playerBruteForce, "Player BruteF Push Threshold (Tenths of a Meter) • >", "Maximum distance between player and other vehicles to trigger the push in tenths of a meter.", 1, 1000, settings.playerBruteForce.push_threshold * 10, 5, function(value) settings.playerBruteForce.push_threshold = value / 10 end)
		local pushForceMultiplierSliderPlayerBruteF = createMenuSlider(playerBruteForce, "Player BruteF Push Force Multiplier  • >", "Multiplier for the force applied to push vehicles.", 1, 5000, settings.playerBruteForce.push_force_multiplier, 1, function(value) settings.playerBruteForce.push_force_multiplier = value end)
	
		local ExplodeOnCollision = menu.list(customizeNPCPowers, translate("Customize Explode On Collision •     >", "Customize Explode On Collision •     >"))
		local explodeOnCollisionToggle = createMenuToggle(NPCPowers, "EoC Explode on Collision ", false, function(on) settings.explodeOnCollision.isOn = on end)
		local explodeInvisibleToggle = createMenuToggle(ExplodeOnCollision, "EoC Invisible Explosion @", false, function(on) settings.explodeOnCollision.explosionInvisible = on end)
		local explodeAudibleToggle = createMenuToggle(ExplodeOnCollision, "EoC Audible Explosion @", false, function(on) settings.explodeOnCollision.explosionAudible = on end)
		local explodeDistanceSlider = createMenuSlider(ExplodeOnCollision, "EoC Explosion Distance • >", "How far from the car to the player will count as a collision?", 1, 1000, 27, 1, function(value) settings.explodeOnCollision.explosionDistance = value / 10 end)
		local explodeTypeSlider = createMenuSlider(ExplodeOnCollision, "EoC Explosion Type • >", "P.S 59 is basically a nuke, 70 is EMP, 65 is Kenetic Mine...", 0, 82, 9, 1, function(value) settings.explodeOnCollision.explosionType = value end)
		local explodeDamageSlider = createMenuSlider(ExplodeOnCollision, "EoCExplosion Damage • >", "Go nuts", 0, 1000, 1, 1, function(value) settings.explodeOnCollision.explosionDamage = value end)
	
		local AudioSpam = menu.list(customizeNPCPowers, translate("Customize Audio Spam •     >", "Customize Audio Spam •     >"))
		local AudioSpamToggle = createMenuToggle(NPCPowers, "AP Audio Spam ", false, function(on) settings.audioSpam.isOn = on end)
		local audioInvisibleToggle = createMenuToggle(AudioSpam, "AP Invisible Explosion @", true, function(on) settings.audioSpam.audioInvisible = on end)
		local spamAudibleToggle = createMenuToggle(AudioSpam, "AP Audible @", true, function(on) settings.audioSpam.spamAudible = on end)
		local TriggerDistanceSlider = createMenuSlider(AudioSpam, "AP Trigger Distance • >", "How far from the car to the player will count as a collision?", 1, 1000, 450, 25, function(value) settings.audioSpam.TriggerDistance = value / 10 end)
		local audioTypeSlider = createMenuSlider(AudioSpam, "AP Audio Type • >", "Default: Predator Calls", 0, 82, 21, 1, function(value) settings.audioSpam.audioType = value end)
		local audioDamageSlider = createMenuSlider(AudioSpam, "AP Damage • >", "Go nuts", 0, 1000, 0, 1, function(value) settings.audioSpam.audioDamage = value end)

		local AudioSpam2 = menu.list(customizeNPCPowers, translate("Customize Audio Spam •     >", "Customize Audio Spam 2 •     >"))
		local AudioSpamToggle2 = createMenuToggle(NPCPowers, "AP Audio Spam 2", false, function(on) settings2.audioSpam.isOn = on end)
		local audioInvisibleToggle2 = createMenuToggle(AudioSpam2, "AP Invisible Explosion @", true, function(on) settings2.audioSpam.audioInvisible = on end)
		local spamAudibleToggle2 = createMenuToggle(AudioSpam2, "AP Audible @", true, function(on) settings2.audioSpam.spamAudible = on end)
		local TriggerDistanceSlider2 = createMenuSlider(AudioSpam2, "AP Trigger Distance • >", "How far from the car to the player will count as a collision?", 1, 1000, 450, 25, function(value) settings2.audioSpam.TriggerDistance = value / 10 end)
		local audioTypeSlider2 = createMenuSlider(AudioSpam2, "AP Audio Type • >", "Default: Earthquake", 0, 82, 58, 1, function(value) settings2.audioSpam.audioType = value end)
		local audioDamageSlider2 = createMenuSlider(AudioSpam2, "AP Damage • >", "Go nuts", 0, 1000, 0, 1, function(value) settings2.audioSpam.audioDamage = value end)

		local NPC_TimeWarpMenu = menu.list(customizeNPCPowers, translate("Customize NPC Time Warp •     >", "Customize NPC Time Warp •     >"))
		local warpCooldownSlider = createMenuSlider(NPC_TimeWarpMenu, "TW Cooldown", "Cooldown period between warps", 0, 10000, settings.NPC_TimeWarp.warp_cooldown, 100, function(value) settings.NPC_TimeWarp.warp_cooldown = value end)
		local warpDistanceSlider = createMenuSlider(NPC_TimeWarpMenu, "TW Warp Distance", "Distance the NPC vehicle warps ahead", 0, 100, settings.NPC_TimeWarp.warp_distance, 1, function(value) settings.NPC_TimeWarp.warp_distance = value end)
		local NPC_TimeWarpToggle = createMenuToggle(NPCPowers, "NPC Time Warp", false, function(on) settings.NPC_TimeWarp.isOn = on end)
		

		--presets
		local ResetPresets = createMenuToggle(CTLPresets, "Disable Presets + Despawn NPCs | You do not need to worry about this setting unless you are using Ultimate Custom Traffic > CTL Presets.", false, function(on) 
			ResetPresetsOn = on end)
		local FastNPCs = createMenuToggle(CTLPresets, "FAIR | Simply Fast NPCs | Turns any underpreforming NPC into a speed demon! Applied Settings - NPC Attraction Range = 140 - MaxNPCs = 15 - Downwards Gravity - Super Speed", false, function(on) 
			settings.FastNPCsOn.isOn = on end)
		local SpeedyNPCs = createMenuToggle(CTLPresets, "RUDE | Speedy Strong Crowding NPCs | A Horde That Throws Player Cars! Applied Settings - NPC Attraction Range = 160 - MaxNPCs = 55 - Brute Force / Strength = 10 - Downwards Gravity - Super Speed", false, function(on) 
			settings.SpeedyNPCsOn.isOn = on end)
		local BumperCars = createMenuToggle(CTLPresets, "FUNNY | Bumper Cars | Woah - Home Run! Player Cars Throw NPCs too? Applied Settings - NPC Attraction Range = 120 - MaxNPCs = 15 - Brute Force / Strength = 35 - Player Brute Force / Strength = 35 - Downwards Gravity - Super Speed - Jump Ability", false, function(on) 
			settings.BumperCarsOn.isOn = on end)
		local RabidHomingNPCs = createMenuToggle(CTLPresets, "UNFAIR | Rabid Homing NPCs | They won't stop lunging at me! Applied Settings - NPC Attraction Range = 120 - MaxNPCs = 55 - Brute Force / Strength = 3 - Proximity Homing - Downwards Gravity - Super Speed = 15,000", false, function(on) 
			settings.RabidHomingNPCsOn.isOn = on end)		
		local DemonicNPCs = createMenuToggle(CTLPresets, "IMPOSSIBLE | Demonic Cars | Okay guys, who cursed the NPCs? Applied Settings - NPC Attraction Range = 460 - MaxNPCs = 126 - Brute Force / Strength = 395 - Player Brute Force / Strength = 15 - Player Proximity Homing CHAOS MODE - Proximity Homing CHAOS MODE - EoC CHAOS MODE - Downwards Gravity CHAOS MODE - Super Speed - Invincibility - Jump Ability", false, function(on) 
			settings.DemonicNPCsOn.isOn = on end)
		local ExplosiveEMPNPCs = createMenuToggle(CTLPresets, "EMP | EXPLOSIVE TRAFFIC | Short Circuit! | Looks like the NPCs are going haywire again. Applied Settings - NPC Attraction Range = 120 - MaxNPCs = 20 - EoC - Downwards Gravity - Super Speed", false, function(on) 
			settings.ExplosiveNPCsOn.isOn = on end)
		local SpikeExplosiveNPCs = createMenuToggle(CTLPresets, "TIRE SPIKES! | EXPLOSIVE TRAFFIC | Tire Spike Explosion On Collision! Applied Settings - NPC Attraction Range = 180 - MaxNPCs = 55 - EoC - Downwards Gravity - Super Speed", false, function(on) 
			settings.SpikeExplosiveNPCsOn.isOn = on end)
		local RandomExplosiveNPCs = createMenuToggle(CTLPresets, "RANDOM CHAOS | EXPLOSIVE TRAFFIC | Each explosion is Randomized, and has a 50/50 chance of doing 0 damage to players! Applied Settings - NPC Attraction Range = 180 - MaxNPCs = 55 - EoC - Downwards Gravity - Super Speed", false, function(on) 
			settings.RandomExplosiveNPCsOn.isOn = on end)
		local AnnoyingExplosiveNPCs = createMenuToggle(CTLPresets, "ANNOYING | EXPLOSIVE TRAFFIC | Annoying Explosion On Collision! Applied Settings - NPC Attraction Range = 180 - MaxNPCs = 55 - EoC - Downwards Gravity - Super Speed", false, function(on) 
			settings.AnnoyingExplosiveNPCsOn.isOn = on end)


		util.create_thread(customTrafficLoop)

	local usingPiggyback = false
	local usingRape = false

	local helpText = translate("Trolling", "Attatch to player for better traffic / ped sync")
	menu.toggle(moreToolslist, translate("Trolling", "Attatch to player for better traffic / ped sync"), {}, helpText, function (on)
		usingRape = on
		-- Otherwise the game would crash
		if pId == players.user() then
			return
		end

		if usingRape then
			usingPiggyback = false
			local target = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
			STREAMING.REQUEST_ANIM_DICT("rcmpaparazzo_2")
			while not STREAMING.HAS_ANIM_DICT_LOADED("rcmpaparazzo_2") do
				util.yield_once()
			end
			TASK.TASK_PLAY_ANIM(players.user_ped(), "rcmpaparazzo_2", "shag_loop_a", 8.0, -8.0, -1, 1, 0.0, false, false, false)
			ENTITY.ATTACH_ENTITY_TO_ENTITY(players.user_ped(), target, 0, 0, -0.3, 0, 0.0, 0.0, 0.0, false, true, false, false, 0, true, 0)
			while usingRape and is_player_active(pId, false, true) and
			not util.is_session_transition_active() do
				util.yield_once()
			end
			usingRape = false
			TASK.CLEAR_PED_TASKS_IMMEDIATELY(players.user_ped())
			ENTITY.DETACH_ENTITY(players.user_ped(), true, false)
		end
	end)
end 

players.on_join(ServerSide)
players.dispatch_on_join()
util.log("On join dispatched")