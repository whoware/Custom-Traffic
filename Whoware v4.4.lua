--[[
--------------------------------
THIS FILE BASED OFF OF WIRISCRIPT
Script base creator: Nowiry#2663
Custom Traffic made by Who.
--------------------------------
]]

---@diagnostic disable: local-limit
local scriptStartTime = util.current_time_millis()
gVersion = 29.51
util.require_natives(1663599433)

local required <const> = {
	"lib/natives-1663599433.lua",
	"lib/wiriscript/functions.lua",
	"lib/wiriscript/ufo.lua",
	"lib/wiriscript/guided_missile.lua",
	"lib/pretty/json.lua",
	"lib/pretty/json/constant.lua",
	"lib/pretty/json/parser.lua",
	"lib/pretty/json/serializer.lua",
	"lib/wiriscript/ped_list.lua",
	"lib/wiriscript/homing_missiles.lua",
	"lib/wiriscript/orbital_cannon.lua"
}
local scriptdir <const> = filesystem.scripts_dir()
for _, file in ipairs(required) do
	assert(filesystem.exists(scriptdir .. file), "required file not found: " .. file)
end

local Functions = require "wiriscript.functions"
local UFO = require "wiriscript.ufo"
local GuidedMissile = require "wiriscript.guided_missile"
local PedList <const> = require "wiriscript.ped_list"
local HomingMissiles = require "wiriscript.homing_missiles"
local OrbitalCannon = require "wiriscript.orbital_cannon"

if filesystem.exists(filesystem.resources_dir() .. "WiriTextures.ytd") then
	util.register_file(filesystem.resources_dir() .. "WiriTextures.ytd")
	notification.txdDict = "WiriTextures"
	notification.txdName = "logo"
	request_streamed_texture_dict("WiriTextures")
else
	error("required file not found: WiriTextures.ytd" )
end


if Functions.version ~= gVersion or UFO.getVersion() ~= gVersion or GuidedMissile.getVersion() ~= gVersion or
HomingMissiles.getVersion() ~= gVersion or OrbitalCannon.getVersion() ~= gVersion then
	error("versions of WiriScript's files don't match")
end

-----------------------------------
-- FILE SYSTEM
-----------------------------------	

local wiriDir <const> = scriptdir .. "WiriScript\\"
local languageDir <const> = wiriDir .. "language\\"
local configFile <const> = wiriDir .. "config.ini"


if not filesystem.exists(wiriDir) then
	filesystem.mkdir(wiriDir)
end

if not filesystem.exists(languageDir) then
	filesystem.mkdir(languageDir)
end

if not filesystem.exists(wiriDir .. "profiles") then
	filesystem.mkdir(wiriDir .. "profiles")
end

if not filesystem.exists(wiriDir .. "handling") then
	filesystem.mkdir(wiriDir .. "handling")
end

if not filesystem.exists(wiriDir .. "bodyguards") then
	filesystem.mkdir(wiriDir .. "bodyguards")
end

---------------------------------
-- CONFIG/LANGUAGE
---------------------------------

if filesystem.exists(configFile) then
	for s, tbl in pairs(Ini.load(configFile)) do
		for k, v in pairs(tbl) do
			Config[s] = Config[s] or {}
			Config[s][k] = v
		end
	end
	util.log("Configuration loaded")
end

if Config.general.language ~= "english" then
	local ok, errmsg = load_translation(Config.general.language .. ".json")
	if not ok then notification:help("Couldn't load tranlation: " .. errmsg, HudColour.red) end
end

-----------------------------------
-- LABELS
-----------------------------------	

local customLabels <const> =
{
	EnterFileName = translate("Labels", "Enter the file name"),
	InvalidChar = translate("Labels", "Got an invalid character, try again"),
	EnterValue = translate("Labels", "Enter the value"),
	ValueMustBeNumber = translate("Labels", "The value must be a number, try again"),
	Search = translate("Labels" ,"Type the word to search"),
}

for key, text in pairs(customLabels) do
	customLabels[key] = util.register_label(text)
end

-----------------------------------
-- PEDS LIST
-----------------------------------

-- Here you can modify which peds are available to choose
-- ["name shown in Stand"] = "ped model ID"
local attackerList <const> = {
	["Prisoner (Muscular)"] = "s_m_y_prismuscl_01",
	["Mime Artist"] = "s_m_y_mime",
	["Movie Astronaut"] = "s_m_m_movspace_01",
	["SWAT"] = "s_m_y_swat_01",
	["Ballas Ganster"] = "g_m_y_ballaorig_01",
	["Marine"]= "csb_ramp_marine",
	["Cop Female"] = "s_f_y_cop_01",
	["Cop Male"] = "s_m_y_cop_01",
	["Jesus"] = "u_m_m_jesus_01",
	["Zombie"] = "u_m_y_zombie_01",
	["Avon Juggernaut"] = "u_m_y_juggernaut_01",
	["Clown"] = "s_m_y_clown_01",
	["Hooker"] = "s_f_y_hooker_02",
	["Altruist"] = "a_m_y_acult_01",
	["Fireman Male"] = "s_m_y_fireman_01",
	["Bigfoot"] = "ig_orleans",
	["Mariachi"] = "u_m_y_mani",
	["Priest"] = "ig_priest",
	["Transvestite Male"] = "a_m_m_tranvest_01",
	["General Fat Male"] = "a_m_m_genfat_01",
	["Grandma"] = "a_f_o_genstreet_01",
	["Bouncer"] = "s_m_m_bouncer_01",
	["High Security"] = "s_m_m_highsec_02",
	["Maid"] = "s_f_m_maid_01",
	["Juggalo Female"] = "a_f_y_juggalo_01",
	["Beach Female"] = "a_f_m_beach_01",
	["Beverly Hills Female"] = "a_f_m_bevhills_01",
	["Hipster"] = "ig_ramp_hipster",
	["Hipster Female"] = "a_f_y_hipster_01",
	["FIB Agent"] = "mp_m_fibsec_01",
	["Female Baywatch"] = "s_f_y_baywatch_01",
	["Franklyn"] = "player_one",
	["Trevor"] = "player_two",
	["Michael"] = "player_zero",
	["Pogo the Monkey"] = "u_m_y_pogo_01",
	["Space Ranger"] = "u_m_y_rsranger_01",
	["Stone Man"] = "s_m_m_strperf_01",
	["Street Art Male"] = "u_m_m_streetart_01",
	["Impotent Rage"] = "u_m_y_imporage",
	["Mechanic"] = "s_m_y_xmech_02",
}

---@class ModelList
ModelList =
{
	reference = 0,
	default = nil,
	name = "",
	command = "",
	---@type fun(caption: string, model: string)?
	onClick = nil,
	changeName = false,
	---@type table
	options = {},
	foundOpts = {},
}
ModelList.__index = ModelList

---@param parent integer
---@param name string
---@param command string
---@param helpText string
---@param tbl table
---@param onClick? fun(caption: string, model: string)
---@param changeName boolean #If the list's name will change to show the selected model.
---@param searchOpt boolean
---@return ModelList
function ModelList.new(parent, name, command, helpText, tbl, onClick, changeName, searchOpt)
	local self = setmetatable({}, ModelList)
	self.name = name
	self.command = command
	self.onClick = onClick
	self.changeName = changeName
	self.foundOpts = {}
	self.options = tbl
	self.reference = menu.list(parent, name, {self.command}, helpText or "")

	if searchOpt then
		self:createSearchList(self.reference, translate("Misc", "Search"))
	end

	for caption, value in pairs_by_keys(self.options) do
		if type(value) == "string" then
			self:addOpt(self.reference, caption, value)

		elseif type(value) == "table" then
			local section = menu.list(self.reference, caption, {}, "")
			self:addSection(section, value)
		end
	end

	return self
end


---@param parent integer
---@param caption string
---@param model string
function ModelList:addOpt(parent, caption, model)
	local command = self.command ~= "" and self.command .. caption or ""

	return menu.action(parent, caption, {command}, "", function(click)
		if self.changeName then
			local newName = string.format("%s: %s", self.name, caption)
			menu.set_menu_name(self.reference, newName)
		end
		if (click & CLICK_FLAG_AUTO) == 0 then menu.focus(self.reference) end
		if self.onClick then self.onClick(caption, model) end
	end)
end


---@param parent integer
---@param tbl table<string, string>
---@param outReferences integer[]?
function ModelList:addSection(parent, tbl, outReferences)
	for caption, name in pairs_by_keys(tbl) do
		local reference = self:addOpt(parent, caption, name)
		if outReferences then table.insert(outReferences, reference) end
	end
end


---@param parent integer
---@param menu_name string
function ModelList:createSearchList(parent, menu_name)
	local reference = menu.list(parent, menu_name, {}, "")

	menu.action(reference, menu_name, {}, "", function (click)
		if (CLICK_FLAG_AUTO & click) ~= 0 then
			return
		end

		for _, reference in ipairs(self.foundOpts) do
			menu.delete(reference)
			self.foundOpts = {}
		end

		local text = get_input_from_screen_keyboard(customLabels.Search, 20, "")
		if text == "" then
			return
		else
			text = string.lower(text)
		end

		for caption, value in pairs(self.options) do
			if type(value) == "string" then
				if string.lower(caption):find(text) or value:find(text) then
					local opt = self:addOpt(reference, caption, value)
					table.insert(self.foundOpts, opt)
				end

			elseif type(value) == "table" then
				local tbl = value
				local matches = self.getSectionMatches(caption, text, tbl)
				self:addSection(reference, matches, self.foundOpts)
			end
		end
	end)
end


---@param section string
---@param find string
---@param tbl table<string, string>
---@return table
function ModelList.getSectionMatches(section, find, tbl)
	local matches = {}
	find = string.lower(find)

	for caption, model in pairs(tbl) do
		if string.lower(caption):find(find) or
		model:find(find) then matches[section .. " > " .. caption] = model end
	end
	return matches
end

-----------------------------------
-- WEAPONS LIST
-----------------------------------

local Weapons <const> =
{
	-- Shotguns
	VAULT_WMENUI_2 =
	{
		WT_SG_PMP = "weapon_pumpshotgun",
		WT_SG_PMP2 = "weapon_pumpshotgun_mk2",
		WT_SG_SOF = "weapon_sawnoffshotgun",
		WT_SG_BLP = "weapon_bullpupshotgun",
		WT_SG_ASL = "weapon_assaultshotgun",
		WT_MUSKET = "weapon_musket",
		WT_HVYSHOT = "weapon_heavyshotgun",
		WT_DBSHGN = "weapon_dbshotgun",
		WT_AUTOSHGN = "weapon_autoshotgun",
		WT_CMBSHGN = "weapon_combatshotgun",
	},
	-- Machine guns
	VAULT_WMENUI_3 =
	{
		WT_SMG_MCR = "weapon_microsmg",
		WT_MCHPIST = "weapon_machinepistol",
		WT_MINISMG = "weapon_minismg",
		WT_SMG = "weapon_smg",
		WT_SMG2 = "weapon_smg_mk2",
		WT_SMG_ASL = "weapon_assaultsmg",
		WT_COMBATPDW = "weapon_combatpdw",
		WT_MG = "weapon_mg",
		WT_MG_CBT = "weapon_combatmg",
		WT_MG_CBT2 = "weapon_combatmg_mk2",
		WT_GUSENBERG = "weapon_gusenberg",
		WT_RAYCARBINE = "weapon_raycarbine",
	},
	-- Rifles
	VAULT_WMENUI_4 =
	{
		WT_RIFLE_ASL = "weapon_assaultrifle",
		WT_RIFLE_ASL2 = "weapon_assaultrifle_mk2",
		WT_RIFLE_CBN = "weapon_carbinerifle",
		WT_RIFLE_CBN2 = "weapon_carbinerifle_mk2",
		WT_RIFLE_ADV = "weapon_advancedrifle",
		WT_RIFLE_SCBN = "weapon_specialcarbine",
		WT_SPCARBINE2 = "weapon_specialcarbine_mk2",
		WT_BULLRIFLE = "weapon_bullpuprifle",
		WT_BULLRIFLE2 = "weapon_bullpuprifle_mk2",
		WT_CMPRIFLE = "weapon_compactrifle",
		WT_MLTRYRFL = "weapon_militaryrifle",
		WT_HEAVYRIFLE = "WEAPON_HEAVYRIFLE",
		WT_TACRIFLE = "WEAPON_TACTICALRIFLE",
	},
	-- Sniper rifles
	VAULT_WMENUI_5 =
	{
		WT_SNIP_RIF = "weapon_sniperrifle",
		WT_SNIP_HVY = "weapon_heavysniper",
		WT_SNIP_HVY2 = "weapon_heavysniper_mk2",
		WT_MKRIFLE = "weapon_marksmanrifle",
		WT_MKRIFLE2 = "weapon_marksmanrifle_mk2",
		WT_PRCSRIFLE = "WEAPON_PRECISIONRIFLE",
	},
	-- Heavy weapons
	VAULT_WMENUI_6 =
	{
		WT_GL = "weapon_grenadelauncher",
		WT_RPG = "weapon_rpg",
		WT_MINIGUN = "weapon_minigun",
		WT_FWRKLNCHR = "weapon_firework",
		WT_RAILGUN = "weapon_railgun",
		WT_HOMLNCH = "weapon_hominglauncher",
		WT_CMPGL = "weapon_compactlauncher",
		WT_RAYMINIGUN = "weapon_rayminigun",
	},
	-- Melee weapons
	VAULT_WMENUI_8 =
	{
		WT_UNARMED = "weapon_unarmed",
		WT_KNIFE = "weapon_knife",
		WT_NGTSTK = "weapon_nightstick",
		WT_HAMMER = "weapon_hammer",
		WT_BAT = "weapon_bat",
		WT_CROWBAR = "weapon_crowbar",
		WT_GOLFCLUB = "weapon_golfclub",
		WT_BOTTLE = "weapon_bottle",
		WT_DAGGER = "weapon_dagger",
		WT_SHATCHET = "weapon_stone_hatchet",
		WT_KNUCKLE = "weapon_knuckle",
		WT_MACHETE = "weapon_machete",
		WT_FLASHLIGHT = "weapon_flashlight",
		WT_SWTCHBLDE = "weapon_switchblade",
		WT_BATTLEAXE = "weapon_battleaxe",
		WT_POOLCUE = "weapon_poolcue",
		WT_WRENCH = "weapon_wrench",
		WT_HATCHET = "weapon_hatchet",
	},
	-- Pistols
	VAULT_WMENUI_9 =
	{
		WT_PIST = "weapon_pistol",
		WT_PIST2  = "weapon_pistol_mk2",
		WT_PIST_CBT = "weapon_combatpistol",
		WT_PIST_50 = "weapon_pistol50",
		WT_SNSPISTOL = "weapon_snspistol",
		WT_SNSPISTOL2 = "weapon_snspistol_mk2",
		WT_HEAVYPSTL = "weapon_heavypistol",
		WT_VPISTOL = "weapon_vintagepistol",
		WT_CERPST = "weapon_ceramicpistol",
		WT_MKPISTOL = "weapon_marksmanpistol",
		WT_REVOLVER = "weapon_revolver",
		WT_REVOLVER2 = "weapon_revolver_mk2",
		WT_REV_DA = "weapon_doubleaction",
		WT_REV_NV= "weapon_navyrevolver",
		WT_GDGTPST = "weapon_gadgetpistol",
		WT_STUN = "weapon_stungun",
		WT_FLAREGUN = "weapon_flaregun",
		WT_RAYPISTOL = "weapon_raypistol",
		WT_PIST_AP = "weapon_appistol",
	},
}

---@class WeaponList
WeaponList =
{
	reference = 0,
	---@type string?
	name = "",
	---@type string?
	command = "",
	---@type fun(caption: string, model: string)?
	onClick = nil,
	changeName = false,
	selected = nil,
}
WeaponList.__index = WeaponList


---@param parent integer
---@param name string
---@param command? string
---@param helpText? string
---@param onClick? fun(caption: string, model: string)
---@param changeName boolean
---@return WeaponList
function WeaponList.new(parent, name, command, helpText, onClick, changeName)
	local self = setmetatable({}, WeaponList)
	self.name = name
	self.command = command
	self.changeName = changeName
	self.onClick = onClick
	self.reference = menu.list(parent, name, {self.command}, helpText or "")

	for section, tbl in pairs_by_keys(Weapons) do
		self:addSection(section, tbl)
	end

	return self
end


---@param parent integer
---@param label string
---@param model string
function WeaponList:addOpt(parent, label, model)
	local name = util.get_label_text(label)
	local command = self.command ~= "" and self.command .. name or ""
	menu.action(parent, name, {command}, "", function(click)
		if self.changeName then
			local newName = string.format("%s: %s", self.name, name)
			menu.set_menu_name(self.reference, newName)
		end
		self.selected = model
		if click == CLICK_MENU then menu.focus(self.reference) end
		if self.onClick then self.onClick(name, model) end
	end)
end


---@param section string
---@param weapons table<string, string>
function WeaponList:addSection(section, weapons)
	local list = menu.list(self.reference, util.get_label_text(section), {}, "")
	for label, model in pairs_by_keys(weapons) do self:addOpt(list, label, model) end
end

-----------------------------------
-- OTHERS
-----------------------------------

-- [name] = {"keyboard; controller", index}
local Imputs <const> =
{
	INPUT_JUMP = {"Spacebar; X", 22},
	INPUT_VEH_ATTACK = {"Mouse L; RB", 69},
	INPUT_VEH_AIM = {"Mouse R; LB", 68},
	INPUT_VEH_DUCK = {"X; A", 73},
	INPUT_VEH_HORN = {"E; L3", 86},
	INPUT_VEH_CINEMATIC_UP_ONLY = {"Numpad +; none", 96},
	INPUT_VEH_CINEMATIC_DOWN_ONLY = {"Numpad -; none", 97}
}

local NULL <const> = 0
DecorFlag_isTrollyVehicle = 1 << 0
DecorFlag_isEnemyVehicle = 1 << 1
DecorFlag_isAttacker = 1 << 2

-----------------------------------
-- HTTP
-----------------------------------

async_http.init("pastebin.com", "/raw/EhH1C6Dh", function(output)
	local version = tonumber(output)
	if version and version > gVersion then
    	notification:normal("WiriScript ~g~v" .. output .. "~s~" .. " is available.", HudColour.purpleDark)
		menu.hyperlink(menu.my_root(), "How to get WiriScript v" .. output, "https://cutt.ly/get-wiriscript", "")
	end
end, function() util.log("Failed to check for updates.") end)
async_http.dispatch()


async_http.init("pastebin.com", "/raw/WMUmGzNj", function(output)
	if string.match(output, '^#') ~= nil then
		local msg = string.match(output, '^#(.+)')
        notification:normal("~b~~italic~Nowiry: ~s~" .. msg, HudColour.purpleDark)
    end
end, function() util.log("Failed to get message.") end)
async_http.dispatch()

-------------------------------------
-- OPENING CREDITS
-------------------------------------

---@class OpeningCredits
OpeningCredits = {handle = 0}
OpeningCredits.__index = OpeningCredits

function OpeningCredits.new()
	local self = setmetatable({}, OpeningCredits)
	self:REQUEST_SCALEFORM_MOVIE()
	return self
end

function OpeningCredits:REQUEST_SCALEFORM_MOVIE()
	self.handle = request_scaleform_movie("OPENING_CREDITS")
end

function OpeningCredits:HAS_LOADED()
	return GRAPHICS.HAS_SCALEFORM_MOVIE_LOADED(self.handle)
end

---@param mcName string
---@param text string
---@param font string
---@param colour string
function OpeningCredits:ADD_TEXT_TO_SINGLE_LINE(mcName, text, font, colour)
	GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(self.handle, "ADD_TEXT_TO_SINGLE_LINE")
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING(mcName)
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING(text)
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING(font)
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING(colour)
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_BOOL(true)
	GRAPHICS.END_SCALEFORM_MOVIE_METHOD()
end

---@param mcName string
function OpeningCredits:HIDE(mcName, stepDuration)
	GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(self.handle, "HIDE")
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING(mcName)
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT(stepDuration)
	GRAPHICS.END_SCALEFORM_MOVIE_METHOD()
end

---@param mcName string
---@param fadeInDuration number
---@param fadeOutDuration number
---@param x number
---@param y number
---@param align string
function OpeningCredits:SETUP_SINGLE_LINE(mcName, fadeInDuration, fadeOutDuration, x, y, align)
	GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(self.handle, "SETUP_SINGLE_LINE")
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING(mcName)
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT(fadeInDuration)
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT(fadeOutDuration)
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT(x)
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT(y)
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING(align)
	GRAPHICS.END_SCALEFORM_MOVIE_METHOD()
end

---@param mcName string
function OpeningCredits:SHOW_SINGLE_LINE(mcName)
	GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(self.handle, "SHOW_SINGLE_LINE")
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING(mcName)
	GRAPHICS.END_SCALEFORM_MOVIE_METHOD()
end

---@param r integer
---@param g integer
---@param b integer
---@param a integer
function OpeningCredits:DRAW_FULLSCREEN(r, g, b, a)
	GRAPHICS.DRAW_SCALEFORM_MOVIE_FULLSCREEN(self.handle, r, g, b, a, 0)
end

function OpeningCredits:SET_AS_NO_LONGER_NEEDED()
	set_scaleform_movie_as_no_longer_needed(self.handle)
end

---@param mcName string
---@param x number
---@param y number
---@param align string
---@param fadeInDuration number
---@param fadeOutDuration number
function OpeningCredits:SETUP_CREDIT_BLOCK(mcName, x, y, align, fadeInDuration, fadeOutDuration)
	GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(self.handle, "SETUP_CREDIT_BLOCK")
	GRAPHICS.BEGIN_TEXT_COMMAND_SCALEFORM_STRING("STRING")
	HUD.ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME(mcName)
	GRAPHICS.END_TEXT_COMMAND_SCALEFORM_STRING()
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT(x)
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT(y)
	GRAPHICS.BEGIN_TEXT_COMMAND_SCALEFORM_STRING("STRING")
	HUD.ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME(align)
	GRAPHICS.END_TEXT_COMMAND_SCALEFORM_STRING()
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT(fadeInDuration)
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT(fadeOutDuration)
	GRAPHICS.END_SCALEFORM_MOVIE_METHOD()
end

---@param mcName string
---@param role string
---@param xOffset number
---@param colour string
---@param isRawText boolean
function OpeningCredits:ADD_ROLE_TO_CREDIT_BLOCK(mcName, role, xOffset, colour, isRawText)
	GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(self.handle, "ADD_ROLE_TO_CREDIT_BLOCK")
	GRAPHICS.BEGIN_TEXT_COMMAND_SCALEFORM_STRING("STRING")
	HUD.ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME(mcName)
	GRAPHICS.END_TEXT_COMMAND_SCALEFORM_STRING()
	GRAPHICS.BEGIN_TEXT_COMMAND_SCALEFORM_STRING("STRING")
	HUD.ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME(role)
	GRAPHICS.END_TEXT_COMMAND_SCALEFORM_STRING()
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT(xOffset)
	GRAPHICS.BEGIN_TEXT_COMMAND_SCALEFORM_STRING("STRING")
	HUD.ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME(colour)
	GRAPHICS.END_TEXT_COMMAND_SCALEFORM_STRING()
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_BOOL(isRawText)
	GRAPHICS.END_SCALEFORM_MOVIE_METHOD()
end

---@param mcName string
---@param names string
---@param xOffset number
---@param delimeter string
---@param isRawText boolean
function OpeningCredits:ADD_NAMES_TO_CREDIT_BLOCK(mcName, names, xOffset, delimeter, isRawText)
	GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(self.handle, "ADD_NAMES_TO_CREDIT_BLOCK")
	GRAPHICS.BEGIN_TEXT_COMMAND_SCALEFORM_STRING("STRING")
	HUD.ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME(mcName)
	GRAPHICS.END_TEXT_COMMAND_SCALEFORM_STRING()
	GRAPHICS.BEGIN_TEXT_COMMAND_SCALEFORM_STRING("STRING")
	HUD.ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME(names)
	GRAPHICS.END_TEXT_COMMAND_SCALEFORM_STRING()
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT(xOffset)
	GRAPHICS.BEGIN_TEXT_COMMAND_SCALEFORM_STRING("STRING")
	HUD.ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME(delimeter)
	GRAPHICS.END_TEXT_COMMAND_SCALEFORM_STRING()
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_BOOL(isRawText)
	GRAPHICS.END_SCALEFORM_MOVIE_METHOD()
end

---@param mcName string
---@param stepDuration number
function OpeningCredits:SHOW_CREDIT_BLOCK(mcName, stepDuration)
	GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(self.handle, "SHOW_CREDIT_BLOCK")
	GRAPHICS.BEGIN_TEXT_COMMAND_SCALEFORM_STRING("STRING")
	HUD.ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME(mcName)
	GRAPHICS.END_TEXT_COMMAND_SCALEFORM_STRING()
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT(stepDuration)
	GRAPHICS.END_SCALEFORM_MOVIE_METHOD()
end


local openingCredits <const> = OpeningCredits.new()

-------------------------------------
-- INTRO
-------------------------------------

if SCRIPT_MANUAL_START and not SCRIPT_SILENT_START and Config.general.showintro then
	g_ShowingIntro = true
	local state = 0
	local timer <const> = newTimer()
	local menuPosX = menu.get_position()
	local posX = menuPosX > 0.5 and 0.0 or 100.0
	local align = posX == 0.0 and "left" or "right"

	util.create_tick_handler(function()
		if state == 0 and timer.elapsed() < 600 then
			---wait
		elseif openingCredits:HAS_LOADED() then
			if state ==  0 then
				openingCredits:SETUP_SINGLE_LINE("production", 0.5, 0.5, posX, 0.0, align)
				openingCredits:ADD_TEXT_TO_SINGLE_LINE("production", 'a', "$font5", "HUD_COLOUR_WHITE")
				openingCredits:ADD_TEXT_TO_SINGLE_LINE("production", "whoware", "$font2", "HUD_COLOUR_FREEMODE")
				openingCredits:ADD_TEXT_TO_SINGLE_LINE("production", "Production. Introducing...", "$font5", "HUD_COLOUR_WHITE")
				openingCredits:ADD_TEXT_TO_SINGLE_LINE("production", "Custom Traffic", "$font3", "HUD_COLOUR_FREEMODE")
				openingCredits:SHOW_SINGLE_LINE("production")
				AUDIO.PLAY_SOUND_FROM_ENTITY(-1, "Pre_Screen_Stinger", players.user_ped(), "DLC_HEISTS_FINALE_SCREEN_SOUNDS", true, 20)
				state = 1
				timer.reset()
			end

			if state == 1  and timer.elapsed() >= 4000 then
				openingCredits:HIDE("production", 0.1667)
				state = 2
				timer.reset()
			end

			if state == 2 and timer.elapsed() >= 3000 then
				openingCredits:SETUP_SINGLE_LINE("wiriscript", 0.5, 0.5, posX, 0.0, align)
				openingCredits:ADD_TEXT_TO_SINGLE_LINE("wiriscript", "wiriscript", "$font2", "HUD_COLOUR_FREEMODE")
				openingCredits:ADD_TEXT_TO_SINGLE_LINE("wiriscript", 'REIMAGINED. Based on v' .. gVersion, "$font5", "HUD_COLOUR_WHITE")
				openingCredits:SHOW_SINGLE_LINE("wiriscript")
				AUDIO.PLAY_SOUND_FROM_ENTITY(-1, "SPAWN", players.user_ped(), "BARRY_01_SOUNDSET", true, 20)
				state = 3
				timer.reset()
			end

			if state == 3 and timer.elapsed() >= 4000 then
				openingCredits:HIDE("wiriscript", 0.1667)
				state = 4
				timer.reset()
			end

			if state == 4 and timer.elapsed() >= 3000 then
				openingCredits:SET_AS_NO_LONGER_NEEDED()
				g_ShowingIntro = false
				return false
			end
			openingCredits:DRAW_FULLSCREEN(255, 255, 255, 255)
		else
			openingCredits:REQUEST_SCALEFORM_MOVIE()
		end
	end)
end

-------------------------------------
-- CREW
-------------------------------------

---@class Crew
Crew =
{
	icon = 0,
	tag = "",
	name = "",
	motto = "",
	alt_badge = "Off",
	rank = "",
}
Crew.__index = Crew

---@param o? table
---@return Crew
function Crew.new(o)
	o = o or {}
	local self = setmetatable(o, Crew)
	return self
end

---@param player integer
---@return Crew
function Crew.get_player_crew(player)
	local self = setmetatable({}, Crew)
	local networkHandle = memory.alloc(104)
	local clanDesc = memory.alloc(280)
	NETWORK.NETWORK_HANDLE_FROM_PLAYER(player, networkHandle, 13)

	if NETWORK.NETWORK_IS_HANDLE_VALID(networkHandle, 13) and
	NETWORK.NETWORK_CLAN_PLAYER_GET_DESC(clanDesc, 35, networkHandle) then
		self.icon = memory.read_int(clanDesc)
		self.name = memory.read_string(clanDesc + 0x08)
		self.tag = memory.read_string(clanDesc + 0x88)
		self.rank = memory.read_string(clanDesc + 0xB0)
		self.motto = players.clan_get_motto(player)
		self.alt_badge = memory.read_byte(clanDesc + 0xA0) ~= 0 and "On" or "Off"
		--self.rank = memory.read_int(clanDesc + 30 * 8)
	end
	return self
end


local crewInfo =
{
	Name = translate("Spoofing Profile - Crew", "Name"),
	ID = translate("Spoofing Profile - Crew", "ID"),
	Tag = translate("Spoofing Profile - Crew", "Tag"),
	AltBadge = translate("Spoofing Profile - Crew", "Alternative Badge"),
	Yes = translate("Misc", "Yes"),
	No = translate("Misc", "No"),
	Motto = translate("Spoofing Profile - Crew", "Motto"),
	None = translate("Spoofing Profile - Crew", "None"),
}


---Creates a list with the crew's information
---@param parent integer
---@param name string
function Crew:createInfoList(parent, name)
	if self.icon == 0 then
		menu.action(parent, name .. ": " .. crewInfo.None, {}, "", function()end)
		return
	end
	local actions <const> = {{crewInfo.Name, self.name}, {crewInfo.ID, self.icon}, {crewInfo.Tag, self.tag},
	{crewInfo.Motto, self.motto}, {crewInfo.AltBadge, self.alt_badge == "On" and crewInfo.Yes or crewInfo.No}}
	local root = menu.list(parent, name, {}, "")
	for _, tbl in ipairs(actions) do menu.readonly(root, tbl[1], tbl[2]) end
end

Crew.__eq = function (a, b)
	return a.icon == b.icon and a.tag == b.tag and a.name == b.name
end

Crew.__pairs = function(tbl)
	local k <const> = {"icon", "name", "tag", "motto", "alt_badge", "rank"}
	local i = 0
	local iter = function()
		i = i + 1
		if tbl[k[i]] == nil then return nil end
		return k[i], tbl[k[i]]
	end
	return iter, tbl, nil
end

---Returns if a `Crew` (or table with crew information) is valid.
---If it's not, it also returns the error message.
---@param o table|Crew
---@return boolean
---@return string? errmsg
function Crew.isValid(o)
	if not o or not next(o) then return true end
	local types <const> =
	{
		icon = "number",
		tag = "string",
		name = "string",
		motto = "string|nil",
		alt_badge = "string|nil",
		rank = "string|nil"
	}
	for k, t in pairs(types) do
		local ok, errmsg = type_match(rawget(o, k), t)
		if not ok then return false, "field " .. k .. ", " .. errmsg end
	end
	return true
end

-------------------------------------
-- PROFILE
-------------------------------------

ProfileFlag_SpoofName = 1 << 0
ProfileFlag_SpoofRId = 1 << 1
ProfileFlag_SpoofCrew = 1 << 2
ProfileFlag_SpoofIp = 1 << 3


---@class Profile
Profile =
{
	name = "**Invalid**",
	rid = 0,
	crew = Crew.new(),
	flags = ProfileFlag_SpoofName | ProfileFlag_SpoofRId,
	---@type string|nil
	ip = nil,
}
Profile.__index = Profile

---@param o? table
---@return Profile
function Profile.new(o)
	o = o or {}
	local self = setmetatable(o, Profile)
	self.crew = Crew.new(self.crew)
	return self
end


---@param player integer
---@return Profile
function Profile.get_profile_from_player(player)
	local self = setmetatable({}, Profile)
	self.name = PLAYER.GET_PLAYER_NAME(player)
	self.rid = players.get_rockstar_id(player)
	self.crew = Crew.get_player_crew(player)
	self.ip = get_external_ip(player)
	return self
end


function Profile:enableName()
	local nameSpoofing = menu.ref_by_path("Online>Spoofing>Name Spoofing", 33)
	local spoofName =  menu.ref_by_rel_path(nameSpoofing, "Name Spoofing")
	if menu.get_value(spoofName) ~= 1 then
		menu.trigger_command(spoofName, "on")
	end
	local spoofedName = menu.ref_by_rel_path(nameSpoofing, "Spoofed Name")
	menu.trigger_command(spoofedName, self.name)
end


function Profile:enableRId()
	local rIdSpoofing = menu.ref_by_path("Online>Spoofing>RID Spoofing", 33)
	local spoofRId = menu.ref_by_rel_path(rIdSpoofing, "RID Spoofing")
	if menu.get_value(spoofRId) ~= 2 then
		menu.trigger_command(spoofRId, "2")
	end
	local spoofedRId = menu.ref_by_rel_path(rIdSpoofing, "Spoofed RID")
	menu.trigger_command(spoofedRId, tostring(self.rid))
end


function Profile:enableCrew()
	local crewSpoofing = menu.ref_by_path("Online>Spoofing>Crew Spoofing", 33)
	local crew = menu.ref_by_rel_path(crewSpoofing, "Crew Spoofing")
	if menu.get_value(crew) ~= 1 then
		menu.trigger_command(crew, "on")
	end

	local crewId = menu.ref_by_rel_path(crewSpoofing, "ID")
	menu.trigger_command(crewId, tostring(self.crew.icon))

	local crewTag = menu.ref_by_rel_path(crewSpoofing, "Tag")
	menu.trigger_command(crewTag, self.crew.tag)

	local crewAltBadge = menu.ref_by_rel_path(crewSpoofing, "Alternative Badge")
	local altBadgeValue = (self.crew.alt_badge == "On") and 1 or 0
	if menu.get_value(crewAltBadge) ~= altBadgeValue then
		menu.trigger_command(crewAltBadge, string.lower(self.crew.alt_badge))
	end

	local crewName = menu.ref_by_rel_path(crewSpoofing, "Name")
	menu.trigger_command(crewName, self.crew.name)

	local crewMotto = menu.ref_by_rel_path(crewSpoofing, "Motto")
	menu.trigger_command(crewMotto, self.crew.motto)
end


function Profile:enableIp()
	local ipSpoofing = menu.ref_by_path("Online>Spoofing>IP Address Spoofing", 35)
	local toggleIpSpoofing = menu.ref_by_rel_path(ipSpoofing, "IP Address Spoofing")
	if menu.get_value(toggleIpSpoofing) ~= 1 then
		menu.trigger_command(toggleIpSpoofing, "on")
	end
	local spoofedIp = menu.ref_by_rel_path(ipSpoofing, "Spoofed IP Address")
	menu.trigger_command(spoofedIp, self.ip)
end


---@param flag integer
function Profile:isFlagOn(flag)
	return (self.flags & flag) ~= 0
end


---@param flag integer
---@param value boolean
function Profile:setFlag(flag, value)
	self.flags = value and (self.flags | flag) or (self.flags & ~flag)
end


function Profile:enable()
	if self:isFlagOn(ProfileFlag_SpoofName) then self:enableName() end
	if self:isFlagOn(ProfileFlag_SpoofRId) then self:enableRId() end
	if self:isFlagOn(ProfileFlag_SpoofCrew) then self:enableCrew() end
	if self:isFlagOn(ProfileFlag_SpoofIp) then self:enableIp() end
end


---@param a Profile
---@param b Profile
Profile.__eq = function (a, b)
	return a.name == b.name and a.rid == b.rid and
	a.crew == b.crew and a.ip == b.ip
end

Profile.__pairs = function(tbl)
	local k <const> = {"name", "rid", "crew", "ip"}
	local i = 0
	local iter = function()
		i = i + 1
		if tbl[k[i]] == nil then return nil end
		return k[i], tbl[k[i]]
	end
	return iter, tbl, nil
end

---Returns if a `Profile` (or table with a profile information) is valid.
---If it's not, it also returns the error message
---@param obj table|Profile
---@return boolean
---@return string? errmsg
function Profile.isValid(obj)
	local types <const> =
	{
		name = "string",
		rid  = "string|number",
		crew = "table|nil",
		ip = "string|nil",
	}
	for k, t in pairs(types) do
		local ok, errmsg = type_match(rawget(obj, k), t)
		if not ok then return false, "field " .. k  .. ", ".. errmsg end
	end

	if type(obj.rid) == "string" and not tonumber(obj.rid) then
		return false, "field rid is not string castable"
	end

	local ok, errmsg = Crew.isValid(obj.crew)
	if not ok then
		return false, errmsg
	end

	return true
end

-------------------------------------
-- PROFILE MANAGER
-------------------------------------

local trans =
{
	ProfileDisabled = translate("Spoofing Profile", "Spoofing Profile disabled"),
	NotNumber = translate("Spoofing Profile", "RID must be a number"),
	MissingData = translate("Spoofing Profile", "Name and RID are required"),
	AlreadyExists = translate("Spoofing Profile", "Profile already exists"),
	NotUsingProfile = translate("Spoofing Profile", "You are not using any spoofing profile"),
	ProfileSaved = translate("Spoofing Profile", "Spoofing Profile saved"),
	Enabled = translate("Spoofing Profile", "Proofile enabled"),
	MovedToBin = translate("Spoofing Profile", "Profile moved to recycle bin"),
	InvalidProfile = translate("Spoofing Profile", "%s is an invalid profile: %s"),
	ClickToRestore = translate("Spoofing Profile", "Click to restore")
}

---@class ProfileManager
ProfileManager =
{
	reference = 0,
	---@type table<string, Profile>
	profiles = {},
	---@type table<string, integer>
	menuLists = {},
	recycleBin = 0,
	dir = wiriDir .. "profiles\\",
	isUsingAnyProfile = false,
	---@type table<string, boolean>
	deletedProfiles = {},
	---@type Profile
	activeProfile = nil
}
ProfileManager.__index = ProfileManager


---@param parent integer
function ProfileManager.new(parent)
	local self = setmetatable({}, ProfileManager)
	local trans_SpoofingProfiles = translate("Spoofing Profile", "Spoofing Profile")
	self.reference = menu.list(parent, trans_SpoofingProfiles, {}, "THESE FUNCTIONS ARE NOT OFFICIALLY SUPPORTED BY WHOWARE, PLEASE GO TO > Players TO USE CUSTOM TRAFFIC")
	self.menuLists = {}
	self.deletedProfiles = {}
	self.profiles = {}

	local name <const> = translate("Spoofing Profile", "Disable Spoofing")
	menu.action(self.reference, name, {"disableprofile"}, "", function()
		if not self:isAnyProfileEnabled() then
			notification:help(trans.NotUsingProfile, HudColour.red)
		else
			local name <const> = self.activeProfile.name
			self:disableSpoofing()
			notification:normal("%s: %s", HudColour.black, trans.ProfileDisabled, name)
		end
	end)

	local name <const> = translate("Spoofing Profile", "Add Profile")
	local addList = menu.list(self.reference, name, {"addprofile"}, "")
	local profile = {}

	local name <const> = translate("Spoofing Profile", "Name")
	local helpText = translate("Spoofing Profile", "Type the profile's name")
	menu.text_input(addList, name, {"profilename"}, helpText, function(name, click)
		if click ~= CLICK_SCRIPTED and name ~= "" then profile.name = name end
	end)

	local name <const> = translate("Spoofing Profile", "RID")
	local helpText = translate("Spoofing Profile", "Type the profile's RID")
	menu.text_input(addList, name, {"profilerid"}, helpText, function(rid, click)
		if click ~= CLICK_SCRIPTED and rid ~= "" then
			if not tonumber(rid) then return notification:help(trans.NotNumber, HudColour.red) end
			profile.rid = rid
		end
	end)

	local name <const> = translate("Spoofing Profile", "Save Spoofing Profile")
	menu.action(addList, name, {"saveprofile"}, "", function()
		if not profile.name or not profile.rid then
			return notification:help(trans.MissingData, HudColour.red)
		end
		local valid, errmsg = Profile.isValid(profile)
		if not valid then
			return notification:help("%s: %s", HudColour.red, trans.InvalidProfile, errmsg)
		end
		local profile = Profile.new(profile)
		if self:includes(profile) then
			return notification:help(trans.AlreadyExists, HudColour.red)
		end
		self:save(profile, true)
		notification:normal("%s: %s", HudColour.black, trans.ProfileSaved, profile.name)
	end)

	self.recycleBin = menu.list(self.reference, translate("Spoofing Profile", "Recycle Bin"), {}, "")
	menu.divider(self.reference, trans_SpoofingProfiles)
	self:load()
	return self
end


---@param profile Profile
---@return boolean
function ProfileManager:includes(profile)
	return table.find(self.profiles, profile) ~= nil
end

---@param menuName string
---@param profile Profile
function ProfileManager:add(menuName, profile)
	local root = menu.list(self.reference, menuName, {}, "")
	menu.divider(root, menuName)
	self.profiles[menuName] = profile; self.menuLists[menuName] = root

	menu.action(root, translate("Spoofing Profile", "Enable Spoofing Profile"), {}, "", function()
		if self:isAnyProfileEnabled() then self:disableSpoofing() end
		profile:enable()
		self.activeProfile = profile
		notification:normal("%s: %s", HudColour.back, trans.Enabled, profile.name)
	end)

	menu.action(root, translate("Spoofing Profile", "Open Profile"), {}, "", function()
		local pHandle = memory.alloc(104)
		NETWORK.NETWORK_HANDLE_FROM_MEMBER_ID(tostring(profile.rid), pHandle, 13)
		NETWORK.NETWORK_SHOW_PROFILE_UI(pHandle)
	end)

	menu.action(root, translate("Spoofing Profile", "Delete") , {}, "", function()
		self:remove(menuName, profile)
		notification:normal(trans.MovedToBin)
	end)

	menu.toggle(root, translate("Spoofing Profile", "Name"), {}, "", function(on)
		profile:setFlag(ProfileFlag_SpoofName, on)
	end, true)

	local name <const> = translate("Spoofing Profile", "RID")
	menu.toggle(root, name .. ": " .. profile.rid, {}, "", function(on)
		profile:setFlag(ProfileFlag_SpoofRId, on)
	end, true)

	if profile.ip then
		local name <const> = translate("Spoofing Profile", "IP")
		menu.toggle(root, name .. ": " .. profile.ip , {}, "", function(on)
			profile:setFlag(ProfileFlag_SpoofIp, on)
		end, false)
	end

	menu.toggle(root, translate("Spoofing Profile", "Crew Spoofing"), {}, "",
		function(toggle) profile:setFlag(ProfileFlag_SpoofCrew, toggle) end, false)
	profile.crew:createInfoList(root, translate("Spoofing Profile", "Crew"))
end


---@param profile Profile
---@param add boolean
function ProfileManager:save(profile, add)
	local fileName = profile.name
	if self.profiles[fileName] then
		local i = 2
		repeat
			fileName = string.format("%s (%d)", profile.name, i)
			i = i + 1
		until not self.profiles[fileName]
	end
	local file <close> = assert(io.open(self.dir .. fileName .. ".json", "w"))
	local content = json.stringify(profile, nil, 4)
	file:write(content)
	if add then self:add(fileName, profile) end
end


---@param name string
---@param profile Profile
function ProfileManager:remove(name, profile)
	menu.delete(self.menuLists[name])
	self.profiles[name] = nil; self.menuLists[name] = nil
	if self.deletedProfiles[ name ] then return end

	local command
	command = menu.action(self.recycleBin, name, {}, trans.ClickToRestore, function()
		self:save(profile, true)
		menu.delete(command)
		self.deletedProfiles[name] = nil
	end)

	local filePath = self.dir .. name .. ".json"
	os.remove(filePath)
	self.deletedProfiles[name] = true
end


---@return boolean
function ProfileManager:isAnyProfileEnabled()
	return self.activeProfile ~= nil
end


function ProfileManager:disableSpoofing()
	if not self.activeProfile then return end
	local spoofing = menu.ref_by_path("Online>Spoofing", 33)
	if self.activeProfile:isFlagOn(ProfileFlag_SpoofName) then
		local spoofName = menu.ref_by_rel_path(spoofing, "Name Spoofing>Name Spoofing")
		if menu.get_value(spoofName) ~= 0 then menu.trigger_command(spoofName, "off") end
	end

	if self.activeProfile:isFlagOn(ProfileFlag_SpoofRId) then
		local spoofRId = menu.ref_by_rel_path(spoofing, "RID Spoofing>RID Spoofing")
		if menu.get_value(spoofRId) ~= 0 then menu.trigger_command(spoofRId, "off") end
	end

	if self.activeProfile:isFlagOn(ProfileFlag_SpoofCrew) then
		local spoofCrew = menu.ref_by_rel_path(spoofing, "Crew Spoofing>Crew Spoofing")
		if menu.get_value(spoofCrew) ~= 0 then menu.trigger_command(spoofCrew, "off") end
	end

	if self.activeProfile:isFlagOn(ProfileFlag_SpoofIp) then
		local ipSpoofing = menu.ref_by_rel_path(spoofing, "IP Address Spoofing>IP Address Spoofing")
		if menu.get_value(ipSpoofing) ~= 0 then menu.trigger_command(ipSpoofing, "off") end
	end
	self.activeProfile = nil
end


function ProfileManager:load()
	local count = 0
	for _, path in ipairs(filesystem.list_files(self.dir)) do
		local filename, ext = string.match(path, '^.+\\(.+)%.(.+)$')
		if ext ~= "json" then
			os.remove(path)
			goto LABEL_CONTINUE
		end

		local ok, result = json.parse(path, false)
		if not ok then
			notification:help(result, HudColour.red)
			goto LABEL_CONTINUE
		end

		local valid, errmsg = Profile.isValid(result)
		if not valid then
			notification:help(trans.InvalidProfile, HudColour.red, filename, errmsg)
			goto LABEL_CONTINUE
		end

		local profile = Profile.new(result)
		self:add(filename, profile)
		count = count + 1

	::LABEL_CONTINUE::
	end
	util.log("Spoofing Profiles loaded: %d", count)
end

local profilesList <const> = ProfileManager.new(menu.my_root())
util.log("Spoofing Profiles initialized")


---@param pId Player
NetworkPlayerOpts = function(pId)
	menu.divider(menu.player_root(pId), "WhoWare")




-- add function that detects if a player destroyed an npc vehicle, if true, then enable CTL for 10 seconds
-- add menu.slider for txt_scale and add it into new menu.list called "CTLTextUI" 







	
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

	local GlobalTextVariables = {
		tcxy = {
			TextColor = {r = 1, g = 0.5, b = 0, a = 0.40},
			x = 0.55,
			y = 0.80
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
			x = 0.51, 
			y = 0.80
		},
		removedDriverxy = {
			TextColor = {r = 1, g = 0, b = 0, a = 0.99},
			x = 0.59, 
			y = 0.80 
		},
		finishedVehicleCleanupxy = {
			TextColor = {r = 1, g = 1, b = 1, a = 0.30}, -- White text
			x = 0.70, -- Can adjust according to your needs
			y = 0.88  -- Slightly below "An NPC Drivers vehicle has been destroyed!" text
		}		
	}
 --higher = closer to the right 
-- higher = closer to bottom
	local CountTextUI = {
		DR_TXT_SCALE = {
			textScale = 0.6
		}
	}

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
			explosionDistance = 3.350,
			explosionType = 9,
			explosionDamage = 1,               -- 9 = instaboom 22 = flare 23 = weak fire bomp 43 = weird gas bomp
			explosionInvisible = false,
			explosionAudible = false
		},
		playerBruteForce = {
			isOn = false,
			push_timer = 0.6,
			push_cooldown = 250,
			push_threshold = 20.0,
			push_force_multiplier = 15
		},
		playerProximityHoming = {
			isOn = false,
			push_timer = 0,
			push_cooldown = 100, 
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
		}
	}
	local trollingOpt <const> = menu.list(menu.player_root(pId), translate("Player", "Custom Traffic"), {}, "ONLY APPLY CUSTOM TRAFFIC AND IT'S POWERS TO A SINGLE PERSON PER LOBBY. IT'S ADVISED YOU APPLIED CUSTOM TRAFFIC AND THE POWERS TO YOURSELF, THEN SIT OFFWORLD AND SPECTATE PLAYERS FOR IT TO TAKE EFFECT.")


--[[ Function to create a trolly vehicle in the game with specified parameters ]]
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
		VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_ALL_PLAYERS(vehicle, true)
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

	local customTrollingOpt = menu.list(trollingOpt, translate("Trolling", "Ultimate Custom Traffic"), {}, "Lets get started.")
	local CTLCustoms = menu.list(customTrollingOpt, translate("Trolling", "CTL Customs •               >"), {}, "Modify hardcoded Custom Traffic Functions, that of which all control the behavior of NPCs and the script while enabled.")
	local superPowersMenu = menu.list(CTLCustoms, translate("Ultimate Custom Traffic", "Add SuperPowers •                >"), {}, "Lets step it up a notch. Please note: Super powers and CTL need to only be applied to a single player per lobby! It is recommended you apply both super powers and CTL onto only yourself / or 1 other person!")
	local NPCJumpCore = menu.list(CTLCustoms, translate("Trolling", "NPC Jump behavior •             >"), {}, "Control the core Jump Conditions for NPCs")
	local max_health_slider = createMenuSlider(CTLCustoms, "Max Health", "", 500, 100000, 2000, 500, function(value) max_health = value end)
	local health_slider = createMenuSlider(CTLCustoms, "Health", "", 500, 100000, 2000, 500, function(value) health = value end)
	local CTLCustomsXT = menu.list(CTLCustoms, translate("Trolling", "CTL Customs Extras •            >"), {}, "Less important functions are kept in here incase the user ever needs them.")
	
	--Jumpcore
	local dynamic_force_multiplier_value = 33
	local constant_multiplier_value = 94
	local player_speed_divisor_value = 33
	local prediction_time_value = 30 -- Change to integer representation
	local max_height_difference_value = 3
	local distanceXY_value = 60
	local distanceZ_value = 3
	local jumpHeight_value = 8
	local jump_cooldown_value = 375
	local jump_cooldown_slider = createMenuSlider(NPCJumpCore, "Jump Cooldown", "Time in milliseconds before NPCs are allowed to jump again.", 0, 10000, jump_cooldown_value, 25, function(value) jump_cooldown_value = value end)	
	local dynamic_force_multiplier_slider = createMenuSlider(NPCJumpCore, "Dynamic Force Multiplier", "Sensitivity of the force applied to NPCs based on player speed.", 0, 1000, dynamic_force_multiplier_value, 1, function(value) dynamic_force_multiplier_value = value end)
	local constant_multiplier_slider = createMenuSlider(NPCJumpCore, "Constant Multiplier", "Constant value added to dynamic force calculation.", 0, 2000, constant_multiplier_value, 1, function(value) constant_multiplier_value = value end)
	local player_speed_divisor_slider = createMenuSlider(NPCJumpCore, "Player Speed Divisor", "Value that the player's speed is divided by in dynamic force calculation.", 0, 1000, player_speed_divisor_value, 1, function(value) player_speed_divisor_value = value end)
	local prediction_time_slider = createMenuSlider(NPCJumpCore, "Prediction Time", "Time used to predict player position in future. (x0.1 second)", 0, 1000, prediction_time_value, 10, function(value) prediction_time_value = value end) -- Set step as 10
	local max_height_difference_slider = createMenuSlider(NPCJumpCore, "Max Height Difference", "Maximum difference in Z axis between NPC and player for jump.", 0, 1000, max_height_difference_value, 1, function(value) max_height_difference_value = value end)
	local distanceXY_slider = createMenuSlider(NPCJumpCore, "Max XY Distance", "Maximum 2D distance between NPC and player for jump.", 0, 2000, distanceXY_value, 1, function(value) distanceXY_value = value end)
	local distanceZ_slider = createMenuSlider(NPCJumpCore, "Min Z Distance", "Minimum Z distance between NPC and player for jump.", 0, 1000, distanceZ_value, 1, function(value) distanceZ_value = value end)
	local jumpHeight_slider = createMenuSlider(NPCJumpCore, "Jump Height", "Force applied to NPC's Z axis when jumping.", 0, 2000, jumpHeight_value, 1, function(value) jumpHeight_value = value end)

	--main ctl functions
	local isCustomTrafficOn = false
	local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
	local selectedPlayerId = {}
	local npcDrivers = {}
	local npcDriversCount = 15
	local maxNpcDrivers = 15
	local npcRange = 80
	local destroyedVehicles = {}
	local destroyedVehicleTime = 0
	local newDriverTime = 0
	local npcDriversCountPrev = 0 

	--Superpower variables for "Super Speed/Invincibility"
	local isSuperSpeedOn = false
	local isInvincibilityAndMissionEntityOn = false
	local speedMultiplier = 1
	
	--Variables for the "BruteForce"
	local isBruteForceOn = false
	local push_timer = 0.6
	local push_cooldown = 250
	local push_threshold = 20.0 
	local push_force_multiplier = 15
	
	--ProximityHoming--
	local isProximityHomingOn = false
	local proximity_push_timer = 0
	local proximity_push_cooldown = 100 
	local proximity_push_threshold = 30 
	local proximity_push_force_multiplier = 1 
	local proximity_distance_threshold = 10 
	
	--Downward Gravity--
	local isDownwardsGravityOn = false
	local gravity_multiplier = 1
	local downwards_force = -1.395 * gravity_multiplier
	
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
				util.toast("NPC Jumped!")
		
				local jumpHeight = 8 
		
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
		
		function calculateDistance(coord1, coord2)
			local dx, dy, dz = coord2.x - coord1.x, coord2.y - coord1.y, coord2.z - coord1.z
			return math.sqrt(dx*dx + dy*dy + dz*dz)
		end
		
		function calculateForce(coord1, coord2)
			local dx, dy, dz = coord2.x - coord1.x, coord2.y - coord1.y, coord2.z - coord1.z
			return {x = dx * proximity_push_force_multiplier, y = dy * proximity_push_force_multiplier, z = dz * proximity_push_force_multiplier}
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
		
		
		local function customTraffic(pId)
			updateNpcDriversCount() -- update count at the beginning
		
			if not is_player_active(pId, false, true) or not isCustomTrafficOn then
				util.toast("A major error has occured and the script cannot run for some reason. Player not active or custom traffic is off")
				return util.stop_thread()
			end
		
			local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
		
			for _, vehicle in ipairs(get_vehicles_in_player_range(pId, npcRange)) do
				if npcDriversCount >= maxNpcDrivers then
					drawMaxCount() -- call the function to draw text when max count is reached
					break
				end
		
				if TASK.GET_ACTIVE_VEHICLE_MISSION_TYPE(vehicle) ~= 6 then
					local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
					local max_health_val = menu.get_value(max_health_slider)
					local health_val = menu.get_value(health_slider)
					if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) and npcDrivers[driver] == nil then
						request_control_once(driver)
						VEHICLE.SET_VEHICLE_DOORS_LOCKED(vehicle, -1, 0, 1, 2, 3)
						PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(driver, true)
						TASK.TASK_VEHICLE_MISSION_PED_TARGET(driver, vehicle, targetPed, 6, 100.0, 0, 0.0, 0.0, true)
						
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
				directx.draw_text(GlobalTextVariables.tcxy.x, GlobalTextVariables.tcxy.y, "NPC Drivers: " .. tostring(npcDriversCount), ALIGN_CENTRE, CountTextUI.DR_TXT_SCALE.textScale, GlobalTextVariables.tcxy.TextColor, false)
			end
			function drawMaxCount()
				directx.draw_text(GlobalTextVariables.maxCountxy.x, GlobalTextVariables.maxCountxy.y, "MAX", ALIGN_CENTRE, CountTextUI.DR_TXT_SCALE.textScale, GlobalTextVariables.maxCountxy.TextColor, false)
			end
			function drawDestroyedVehicle()
				if os.clock() - destroyedVehicleTime < 3 then -- if less than 1 second has passed
					directx.draw_text(GlobalTextVariables.destroyedVehiclexy.x, GlobalTextVariables.destroyedVehiclexy.y, "An NPCDriver's vehicle has been destroyed!", ALIGN_CENTRE, CountTextUI.DR_TXT_SCALE.textScale, GlobalTextVariables.destroyedVehiclexy.TextColor, false)
				end
			end
			function drawNewDriver()
				if os.clock() - newDriverTime < 0.1 then -- if less than 1 second has passed
					directx.draw_text(GlobalTextVariables.newDriverxy.x, GlobalTextVariables.newDriverxy.y, "+1", ALIGN_CENTRE, CountTextUI.DR_TXT_SCALE.textScale, GlobalTextVariables.newDriverxy.TextColor, false)
				end
			end
			function drawRemovedDriver()
				if npcDriversCount < npcDriversCountPrev then -- if count has decreased
					directx.draw_text(GlobalTextVariables.removedDriverxy.x, GlobalTextVariables.removedDriverxy.y, "-1", ALIGN_CENTRE, CountTextUI.DR_TXT_SCALE.textScale, GlobalTextVariables.removedDriverxy.TextColor, false)
				end
			end
			drawTextLoop()
			drawNewDriver()
			drawRemovedDriver()
			drawDestroyedVehicle()
		
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
			for _, vehicle in ipairs(entities.get_all_vehicles_as_handles()) do
				local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
				if not ENTITY.DOES_ENTITY_EXIST(driver) then
					entities.delete_by_handle(vehicle)
				end
			end
			for _, ped in ipairs(entities.get_all_peds_as_handles()) do
				if not PED.IS_PED_A_PLAYER(ped) and PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
					local vehicle = PED.GET_VEHICLE_PED_IS_IN(ped, false)
					local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
					if driver ~= ped then
						TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
						entities.delete_by_handle(ped)
					end
				end
			end
		end		
		
		
		local function customTrafficLoop()
			push_timer = current_ms() + push_cooldown 
	
			while true do
				despawnDeadPedsAndEmptyVehicles()
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
											FIRE.ADD_EXPLOSION(explosionCoords.x, explosionCoords.y, explosionCoords.z, settings.explodeOnCollision.explosionType, settings.explodeOnCollision.explosionDamage, settings.explodeOnCollision.explosionAudible, settings.explodeOnCollision.explosionInvisible, 1321.0, false)
										end
									end
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
				util.yield(12)
			end
		end
		
		local function customTrafficToggle(on)
			isCustomTrafficOn = on
			if not isCustomTrafficOn then
				clearNPCDrivers()
			end
		end
		
		--beginning of the menu.list toggles & sliders / add menu.toggle that grants player veh slow regen that gives their vehicle 10%health every 20seconds	


		local npcDriversSlider = menu.slider(CTLCustoms, translate("Ultimate Custom Traffic", "Number of NPC Drivers • >"), {}, "Control the amount of NPC Drivers you want chasing the player, decreasing the number deletes NPCs based on the value to save FPS",
		0, 126, 15, 1,
		function(value)
			maxNpcDrivers = value
			removeExcessNPCDrivers()
		end)
		local npcRangeSlider = menu.slider(CTLCustoms, translate("Ultimate Custom Traffic", "NPC Attraction Range • >"), {}, "Set your own custom range for how far from the player NPCs will become reaped for control, go wild.",
		20, 460, 80, 10,
		function(value)
			npcRange = value
		end)

		local toggleLoop = menu.toggle(trollingOpt, translate("Ultimate Custom Traffic", "Custom Traffic • | • Begin the Chaos           > "), {}, false, customTrafficToggle)		
		local despawnEntitiesToggle = createMenuToggle(CTLCustomsXT, "Despawn Dead Peds and Empty Vehicles", false, function(on) settings.despawnEntities.isOn = on end)

		local trollyVehicles <const> = menu.list(trollingOpt, translate("Ultimate Custom Traffic", "Trolly Vehicles Reimagined"), {}, "Spawned Trolly Vehicles are considered 'controlled / reaped', therefor when spawned, they automatically aquire enabled super powers, whether Custom Traffic is enabled or not")
		local options <const> = {"Dump", "blazer5", "faction3", "Monster", "monstrociti", "stingertt", "buffalo5", "coureur", "Blazer", "rcbandito", "Barrage", "Chernobog", "Ripley", "Zhaba", "Sandking", "Thruster", 	"Cerberus", "Wastelander", "Chimera", "Veto", "Skylift", "Cutter", "Phantom2", "Go-Kart", "AMBULANCE", "Barracks", "Vetir", "Mule", "Pounder", "Biff", "Benson", "Forklift", "Docktug", "Mower"}
		local setInvincible = false
		local spawnCount = 1
		local count = 1
		local AttackType <const> = {explode = 0, dropMine = 1}
		local attacktype = 0
		local trollyVehiclesTable = {}
		local trollyVehicleTypesCount = {}
		local function remove_trolly_vehicle(vehicle)
			local vehicleType = trollyVehiclesTable[vehicle].type
			trollyVehiclesTable[vehicle] = nil
			if trollyVehicleTypesCount[vehicleType] then
				trollyVehicleTypesCount[vehicleType] = trollyVehicleTypesCount[vehicleType] - 1
				if trollyVehicleTypesCount[vehicleType] == 0 then
					trollyVehicleTypesCount[vehicleType] = nil
				end
			end
			if trollyVehiclesTable[vehicle] then
				trollyVehiclesTable[vehicle] = nil
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

		function drawTVTextLoop()
			updatetrollyVehicleTypesCount() -- This checks for dead drivers and updates the vehicle counts
			directx.draw_text(tvGlobalTextVariables.tvxy.tvx, tvGlobalTextVariables.tvxy.tvy - 0.1, "Trolly Drivers: " .. tostring(count), ALIGN_CENTRE, tvCountTextUI.TVDR_TXT_SCALE.TVtextScale, tvGlobalTextVariables.tvxy.tvTextColor, false)
		
			local yPositionOffset = 0.1 -- the starting y-position offset
			for vehicleType, vehicleCount in pairs(trollyVehicleTypesCount) do
				if vehicleCount > 0 then
					yPositionOffset = yPositionOffset + 0.02 -- increment the y-position offset for each vehicle type
					directx.draw_text(tvGlobalTextVariables.tvxy.tvx, tvGlobalTextVariables.tvxy.tvy - yPositionOffset, vehicleType .. ": " .. tostring(vehicleCount), ALIGN_CENTRE, tvCountTextUI.TVDR_TXT_SCALE.TVtextScale, tvGlobalTextVariables.tvxy.tvTextColor, false)
				end
			end
		end

		local displayTrollyVehiclesCountToggleState = false
		local function 
			updatetrollyVehicleTypesCount()
			updateNpcDriversCount()
			count = 0
			for _ in pairs(trollyVehiclesTable) do
				count = count + 1
			end
		end

		menu.action_slider(trollyVehicles, translate("Trolling", "Send Trolly Vehicle"), {}, "", options, function(index, opt)
			local pedHash <const> = util.joaat("mp_m_freemode_01")
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
		1, 15, 1, 1, function(value) spawnCount = value end)  -- update spawnCount instead of count
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
				repeat until os.clock() - start >= interval * i -- wait until the next execution time
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
					repeat until os.clock() - start >= interval * i -- wait until the next execution time
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
	
		local extraTraffic = menu.list(trollyVehicles, translate("Ultimate Custom Traffic", "Extra Traffic Options •     >"), {}, "Extra options that ill throw in as later updates come")
	
		local extrasList = menu.list(customTrollingOpt, translate("Ultimate Custom Traffic", "X Extra Traffic Options •     >"), {}, "The functions inside of this folder are the god fathers of the Super powers within > CTL Customs. I decided to keep them in the script in their raw form, since they have their own practical applications. Be warned, in their raw forms, they are unrestricted and have been configured for the purpose of trolling / griefing. Do not apply these to anyone you care about.")
	
	
		local active_vehicles = {}

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
		
		local npc_detection_ranges = {}
		local default_detection_range = 100
		
		menu.toggle_loop(extrasList, translate("Trolling", "JohnWick + ShotPred Anglemechs DynPush"), {}, "JW", function()
			if not is_player_active(pId, false, true) then
				util.toast("Player not active. Stopping thread.")
				return util.stop_thread()
			end
		
			local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
			util.toast("Preparing NPCs")
			for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 2650.0)) do
				if TASK.GET_ACTIVE_VEHICLE_MISSION_TYPE(vehicle) ~= 6 then
					prepare_npc(vehicle, targetPed)
				end
			end
			
			util.toast("Processing vehicle push")
			local base_push_cooldown = 900
			local max_distance_threshold = 100
			local cooldown_distance_multiplier = 3
			local base_push_force_multiplier = 19.77
			local push_timers = {}
			local prediction_time = 0.3
			
			for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 3725.0)) do
				process_vehicle_push(vehicle, targetPed, max_distance_threshold, base_push_cooldown, cooldown_distance_multiplier, base_push_force_multiplier, push_timers, prediction_time)
			end
		end)
		
		function prepare_npc(vehicle, targetPed)
			local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
			if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
				request_control_once(driver)
				PED.SET_PED_MAX_HEALTH(driver, 1000)
				ENTITY.SET_ENTITY_HEALTH(driver, 1000, 0)
				ENTITY.SET_ENTITY_AS_MISSION_ENTITY(vehicle, true, true)
				ENTITY.SET_ENTITY_AS_MISSION_ENTITY(driver, true, true)
				ENTITY.SET_ENTITY_LOAD_COLLISION_FLAG(driver, true)
				VEHICLE.MODIFY_VEHICLE_TOP_SPEED(vehicle, 5050)
			end
			TASK.TASK_VEHICLE_MISSION_PED_TARGET(driver, vehicle, targetPed, 6, 100.0, 0, 0.0, 0.0, true)
			util.toast("NPC prepared")
		end
		
		function process_vehicle_push(vehicle, targetPed, max_distance_threshold, base_push_cooldown, cooldown_distance_multiplier, base_push_force_multiplier, push_timers, prediction_time)
			local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
			if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
				local vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
				local targetPedCoords = ENTITY.GET_ENTITY_COORDS(targetPed, true)
				local distance_to_player = calculate_distance(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, targetPedCoords.x, targetPedCoords.y, targetPedCoords.z)
		
				if distance_to_player > max_distance_threshold then
					local last_push_time = push_timers[vehicle] or 0
					local dynamic_push_cooldown = base_push_cooldown - (max_distance_threshold - distance_to_player) * cooldown_distance_multiplier
		
					if (os.clock() * 1000 - last_push_time) >= dynamic_push_cooldown then
						local targetPedVelocity = ENTITY.GET_ENTITY_VELOCITY(targetPed)
						local predicted_position = calculate_future_position(targetPedCoords, targetPedVelocity, prediction_time)
						local dx, dy, dz = predicted_position.x - vehicleCoords.x, predicted_position.y - vehicleCoords.y, predicted_position.z - vehicleCoords.z
						local player_speed = vector_magnitude(targetPedVelocity.x, targetPedVelocity.y, targetPedVelocity.z)
						local dynamic_push_force_multiplier = base_push_force_multiplier * (1 + player_speed / 110)
						local force = {x = dx * dynamic_push_force_multiplier, y = dy * dynamic_push_force_multiplier, z = dz * dynamic_push_force_multiplier}
		
						if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle) then
							ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, force.x, force.y, force.z, 0, 0, 0, 0, false, false, true, false, true)
							push_timers[vehicle] = os.clock() * 1000
							util.toast("Force applied to vehicle")
						end
					end
				end
			end
		end
		
		
	
		local function calculate_distance(x1, y1, z1, x2, y2, z2)
			local dx = x1 - x2
			local dy = y1 - y2
			local dz = z1 - z2
			return math.sqrt(dx * dx + dy * dy + dz * dz)
		end
		
		local push_timer = 0.2
		local push_cooldown = 500 -- In milliseconds, e.g., 1000 ms = 1 second
		local npc_detection_ranges = {} 
		local function current_ms()
			return os.time() * 10000
		end
		
		local npc_detection_ranges = {}
		
		local default_detection_range = 50
		
		menu.toggle_loop(extrasList, translate("Trolling", "True Hybrid Homing Traffic +++Speed +++Power"), {}, "{No survival for whoever this is summoned onto, even modders will suffer.} Reaps all nearby NPCs, only with this version, NPCs laser beam directly into the player with absolute Precision & Syncronization at any distance you set, customizable within the file! I'm telling you, get your ass in the file and experiment with the values, you're missing out. {Caution: The higher the push force, the greater chance desyncs occur between NPC and Player.}", function()
			if not is_player_active(pId, false, true) then
				return util.stop_thread()
			end
		
			local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
			for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 7000.0)) do
				if TASK.GET_ACTIVE_VEHICLE_MISSION_TYPE(vehicle) ~= 6 then
					local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
					if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
						request_control_once(driver)
						VEHICLE.MODIFY_VEHICLE_TOP_SPEED(vehicle, 20050)
						ENTITY.SET_ENTITY_AS_MISSION_ENTITY(vehicle, true, true)
						ENTITY.SET_ENTITY_AS_MISSION_ENTITY(driver, true, true)
						ENTITY.SET_ENTITY_LOAD_COLLISION_FLAG(driver, true)
						TASK.TASK_VEHICLE_MISSION_PED_TARGET(driver, vehicle, targetPed, 6, 100.0, 0, 0.0, 0.0, true)
					end
				end
			end
		
			-- Check and trigger push effect
			local push_force_multiplier = 16.80 -- Adjust the push force
			local max_distance_threshold = 1 -- Maximum distance before applying force
			
			for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 2225.0)) do
				local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
				if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
					local vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
					local targetPedCoords = ENTITY.GET_ENTITY_COORDS(targetPed, true)
					local distance_to_player = calculate_distance(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, targetPedCoords.x, targetPedCoords.y, targetPedCoords.z)
			
					-- Check if the player is further away than the maximum allowed distance
					if distance_to_player > max_distance_threshold then
						local dx, dy, dz = targetPedCoords.x - vehicleCoords.x, targetPedCoords.y - vehicleCoords.y, targetPedCoords.z - vehicleCoords.z
						local force = {x = dx * push_force_multiplier, y = dy * push_force_multiplier, z = dz * push_force_multiplier}
			
						-- Request control of the vehicle for network synchronization
						if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle) then
							ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, force.x, force.y, force.z, 0, 0, 0, 0, false, false, true, false, true)
						end
					end
				end
			end
		end)
	
		local function calculate_distance(x1, y1, z1, x2, y2, z2)
			return math.sqrt((x1 - x2)^2 + (y1 - y2)^2 + (z1 - z2)^2)
		end
		
		local npc_detection_ranges = {}
		
		local default_detection_range = 155
		
		menu.toggle_loop(extrasList, translate("Trolling", "BASIC John Wick Traffic"), {}, "...", function()
			if not is_player_active(pId, false, true) then return util.stop_thread() end
		
			local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
			for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 2650.0)) do
				if TASK.GET_ACTIVE_VEHICLE_MISSION_TYPE(vehicle) ~= 6 then
					local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
					if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
						request_control_once(driver)
						TASK.TASK_VEHICLE_MISSION_PED_TARGET(driver, vehicle, targetPed, 6, 100.0, 0, 0.0, 0.0, true)
					end
				end
			end
		
			local push_cooldown, max_distance_threshold = 2500, 255
			local push_force_multiplier, push_timers = 20.77, {}
		
			for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 2225.0)) do
				local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
				if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
					local vehicleCoords, targetPedCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true), ENTITY.GET_ENTITY_COORDS(targetPed, true)
					local distance_to_player = calculate_distance(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, targetPedCoords.x, targetPedCoords.y, targetPedCoords.z)
			
					if distance_to_player > max_distance_threshold then
						local last_push_time = push_timers[vehicle] or 0
						if (os.clock() * 2500 - last_push_time) >= push_cooldown then
							local dx, dy, dz = targetPedCoords.x - vehicleCoords.x, targetPedCoords.y - vehicleCoords.y, targetPedCoords.z - vehicleCoords.z
							local force = {x = dx * push_force_multiplier, y = dy * push_force_multiplier, z = dz * push_force_multiplier}
				
							if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle) then
								ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, force.x, force.y, force.z, 0, 0, 0, 0, false, false, true, false, true)
								push_timers[vehicle] = os.clock() * 2500
							end
						end
					end
				end
			end
		end)
		
	
		local function vector_magnitude(dx, dy, dz)
			return math.sqrt(dx * dx + dy * dy + dz * dz)
		end
		
		local function calculate_future_position(pos, velocity, time)
			return {x = pos.x + velocity.x * time, y = pos.y + velocity.y * time, z = pos.z + velocity.z * time}
		end
		
		local stiffness_multiplier = 211.0
		local npc_detection_ranges = {}
		
		menu.toggle_loop(extrasList, translate("Trolling", "Node Traffic Targets Above Player"), {}, "Node traffic now sets a point above the players head, sets unreasonably high speed values, which constantly smashes the player down. Cancer.", function()
			if not is_player_active(pId, false, true) then
				return util.stop_thread()
			end
		
			local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
			local targetPedCoords = ENTITY.GET_ENTITY_COORDS(targetPed, true)
			local targetPedVelocity = ENTITY.GET_ENTITY_VELOCITY(targetPed)
			local base_push_force_multiplier = 55354351
			local max_controlled_nodes = 7
			local controlled_nodes_count = 0
			local levitation_height = 6.5301
			local node_distance_from_player = -999
		
			local function current_ms()
				return os.clock() * 500
			end
		
			for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 2225.0)) do
				local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
				if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) and controlled_nodes_count < max_controlled_nodes then
					local vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
					local dx, dy, dz = vehicleCoords.x - targetPedCoords.x, vehicleCoords.y - targetPedCoords.y, vehicleCoords.z - targetPedCoords.z
					local distance_to_player = vector_magnitude(dx, dy, dz)
		
					local predicted_position = calculate_future_position(targetPedCoords, targetPedVelocity, 0.1)
					dx, dy, dz = predicted_position.x - vehicleCoords.x, predicted_position.y - vehicleCoords.y, predicted_position.z + levitation_height - vehicleCoords.z
					local player_speed = vector_magnitude(targetPedVelocity.x, targetPedVelocity.y, targetPedVelocity.z)
					local dynamic_push_force_multiplier = base_push_force_multiplier * (1 + player_speed / 523231) * stiffness_multiplier
					local force = {x = dx * dynamic_push_force_multiplier, y = dy * dynamic_push_force_multiplier, z = dz * dynamic_push_force_multiplier}
		
					local direction_magnitude = vector_magnitude(dx, dy, dz)
					dx, dy, dz = dx / direction_magnitude, dy / direction_magnitude, dz / direction_magnitude
		
					predicted_position.x = predicted_position.x + dx * node_distance_from_player
					predicted_position.y = predicted_position.y + dy * node_distance_from_player
					predicted_position.z = predicted_position.z + dz * node_distance_from_player + levitation_height
		
					if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle) then
						ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, force.x, force.y, force.z, 0, 0, 0, 0, false, false, true, false, true)
						controlled_nodes_count = controlled_nodes_count + 1
					end
				end
			end
		end)
		
	
		local vector_magnitude = function(x, y, z)
			return math.sqrt(x * x + y * y + z * z)
		end
		
		local calculate_distance = function(x1, y1, z1, x2, y2, z2)
			return vector_magnitude(x1 - x2, y1 - y2, z1 - z2)
		end
		
		local calculate_future_position = function(pos, vel, time)
			return {x = pos.x + vel.x * time, y = pos.y + vel.y * time, z = pos.z + vel.z * time}
		end
		
		local npc_detection_ranges = {} -- Automatically Stores the detection range for each NPC (uses the NPC's entity ID as the key)
		
		local stiffness_multiplier = 211.0
		
		menu.toggle_loop(extrasList, translate("Trolling", "Node Traffic Targets Players Feet"), {}, "Just absolute cancer...", function()
			if not is_player_active(pId, false, true) then return util.stop_thread() end
			local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
			for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 91.0)) do
				if TASK.GET_ACTIVE_VEHICLE_MISSION_TYPE(vehicle) ~= 6 then
					local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
					if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
						request_control_once(driver)
						PED.SET_PED_MAX_HEALTH(driver, 300)
						ENTITY.SET_ENTITY_HEALTH(driver, 300, 0)
						ENTITY.SET_ENTITY_INVINCIBLE(vehicle, true)
						ENTITY.SET_ENTITY_INVINCIBLE(driver, true)
						ENTITY.SET_ENTITY_AS_MISSION_ENTITY(vehicle, true, true)
						ENTITY.SET_ENTITY_LOAD_COLLISION_FLAG(driver, true)
						VEHICLE.MODIFY_VEHICLE_TOP_SPEED(vehicle, 20050)
						TASK.TASK_VEHICLE_MISSION_PED_TARGET(driver, vehicle, targetPed, 6, 100.0, 0, 0.0, 0.0, true)
					end
				end
			end
		
			local base_push_force_multiplier = 55354351
			local max_controlled_nodes = 7
			local controlled_nodes_count = 0
			local levitation_height = 0.0001
			local node_distance_from_player = -999
		
			for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 2225.0)) do
				local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
				if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) and controlled_nodes_count < max_controlled_nodes then
					local vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
					local targetPedCoords = ENTITY.GET_ENTITY_COORDS(targetPed, true)
					local targetPedVelocity = ENTITY.GET_ENTITY_VELOCITY(targetPed)
					local distance_to_player = calculate_distance(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, targetPedCoords.x, targetPedCoords.y, targetPedCoords.z)
		
					for _, seconds in ipairs({1.1, 2.1, 5.1}) do
						local predicted_position = calculate_future_position(targetPedCoords, targetPedVelocity, seconds)
						local dx, dy, dz = predicted_position.x - vehicleCoords.x, predicted_position.y - vehicleCoords.y, predicted_position.z - vehicleCoords.z
						local player_speed = vector_magnitude(targetPedVelocity.x, targetPedVelocity.y, targetPedVelocity.z)
						local dynamic_push_force_multiplier = base_push_force_multiplier * (1 + player_speed / (1124342 / (seconds - 0.1))) * stiffness_multiplier
						local force = {x = dx * dynamic_push_force_multiplier, y = dy * dynamic_push_force_multiplier, z = dz * dynamic_push_force_multiplier}
		
						if seconds == 5.1 then
							local direction_x, direction_y, direction_z = vehicleCoords.x - targetPedCoords.x, vehicleCoords.y - targetPedCoords.y, vehicleCoords.z - targetPedCoords.z
							local direction_magnitude = vector_magnitude(direction_x, direction_y, direction_z)
							local normalized_direction_x, normalized_direction_y, normalized_direction_z = direction_x / direction_magnitude, direction_y / direction_magnitude, direction_z / direction_magnitude
							predicted_position.x = predicted_position.x + normalized_direction_x * node_distance_from_player
							predicted_position.y = predicted_position.y + normalized_direction_y * node_distance_from_player
							predicted_position.z = predicted_position.z + normalized_direction_z * node_distance_from_player + levitation_height
						end
		
						if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle) then
							ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, force.x, force.y, force.z, 0, 0, 0, 0, false, false, true, false, true)
							controlled_nodes_count = controlled_nodes_count + 1
						end
					end
				end
			end
		end)
	
		local function vector_magnitude(x, y, z)
			return math.sqrt(x * x + y * y + z * z)
		end
		
		local function calculate_distance(x1, y1, z1, x2, y2, z2)
			local dx = x1 - x2
			local dy = y1 - y2
			local dz = z1 - z2
			return math.sqrt(dx * dx + dy * dy + dz * dz)
		end
		
		local function calculate_future_position(current_position, velocity, time)
			local future_position = {
				x = current_position.x + velocity.x * time,
				y = current_position.y + velocity.y * time,
				z = current_position.z + velocity.z * time
			}
			return future_position
		end
		
		local npc_detection_ranges = {}
		
		menu.toggle_loop(extrasList, translate("Trolling", "Angle offset Demonic Node Possession"), {}, "2 cars will always interrupt the player, only the cars will hit the player at speeds the games visual engine can't physically render", function()
			if not is_player_active(pId, false, true) then
				return util.stop_thread()
			end
		
			local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
		
			local function prepare_vehicle(vehicle)
				local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
				if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
					request_control_once(driver)
					PED.SET_PED_MAX_HEALTH(driver, 300)
					ENTITY.SET_ENTITY_HEALTH(driver, 300, 0)
					ENTITY.SET_ENTITY_INVINCIBLE(vehicle, true)
					ENTITY.SET_ENTITY_INVINCIBLE(driver, true)
					ENTITY.SET_ENTITY_AS_MISSION_ENTITY(vehicle, true, true)
					ENTITY.SET_ENTITY_AS_MISSION_ENTITY(driver, true, true)
					ENTITY.SET_ENTITY_LOAD_COLLISION_FLAG(driver, true)
					VEHICLE.MODIFY_VEHICLE_TOP_SPEED(vehicle, 20050)
					TASK.TASK_VEHICLE_MISSION_PED_TARGET(driver, vehicle, targetPed, 6, 100.0, 0, 0.0, 0.0, true)
				end
			end
		
			for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 9.0)) do
				if TASK.GET_ACTIVE_VEHICLE_MISSION_TYPE(vehicle) ~= 6 then
					prepare_vehicle(vehicle)
				end
			end
		
			local settings = {
				base_push_force_multiplier = 1,
				max_controlled_nodes = 2,
				levitation_height = 1.2,
				node_distance_from_player = 8,
				min_push_force_multiplier = 2,
				node_slowdown_distance = 0.1,
				node_distance_offset_angle = 90
			}
		
			local function current_ms()
				return os.clock() * 500
			end
		
			local controlled_nodes_count = 0
		
			for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 2225.0)) do
				local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
				if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) and controlled_nodes_count < settings.max_controlled_nodes then
					local vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
					local targetPedCoords = ENTITY.GET_ENTITY_COORDS(targetPed, true)
					local targetPedVelocity = ENTITY.GET_ENTITY_VELOCITY(targetPed)
					local distance_to_player = calculate_distance(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, targetPedCoords.x, targetPedCoords.y, targetPedCoords.z)
		
					local predicted_position = calculate_future_position(targetPedCoords, targetPedVelocity, 0.2)
		
					local direction_x, direction_y, direction_z = vehicleCoords.x - targetPedCoords.x, vehicleCoords.y - targetPedCoords.y, vehicleCoords.z - targetPedCoords.z
					local direction_magnitude = vector_magnitude(direction_x, direction_y, direction_z)
					local normalized_direction_x, normalized_direction_y, normalized_direction_z = direction_x / direction_magnitude, direction_y / direction_magnitude, direction_z / direction_magnitude
		
					local angle_offset = settings.node_distance_offset_angle * controlled_nodes_count
					local angle_offset_rad = math.rad(angle_offset)
		
					local node_x = targetPedCoords.x + settings.node_distance_from_player * math.cos(angle_offset_rad) * normalized_direction_x
					local node_y = targetPedCoords.y + settings.node_distance_from_player * math.sin(angle_offset_rad) * normalized_direction_y
					local node_z = targetPedCoords.z + settings.levitation_height
		
					predicted_position.x = node_x
					predicted_position.y = node_y
					predicted_position.z = node_z
		
					local clamped_distance = math.min(distance_to_player, settings.node_distance_from_player)
					local lerp_factor = (clamped_distance - settings.node_slowdown_distance) / (settings.node_distance_from_player - settings.node_slowdown_distance)
					local distance_push_force_multiplier = settings.min_push_force_multiplier + (1 - settings.min_push_force_multiplier) * lerp_factor
		
					local player_speed = vector_magnitude(targetPedVelocity.x, targetPedVelocity.y, targetPedVelocity.z)
		
					local dynamic_push_force_multiplier = settings.base_push_force_multiplier * distance_push_force_multiplier * (1 + player_speed / 0.01)
		
					local dx, dy, dz = predicted_position.x - vehicleCoords.x, predicted_position.y - vehicleCoords.y, predicted_position.z - vehicleCoords.z
		
					local force = {x = dx * dynamic_push_force_multiplier, y = dy * dynamic_push_force_multiplier, z = dz * dynamic_push_force_multiplier}
		
					if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle) then
						ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, force.x, force.y, force.z, 0, 0, 0, 0, false, false, true, false, true)
						controlled_nodes_count = controlled_nodes_count + 1
					end
				end
			end
		end)
	
		local function calculate_distance(x1, y1, z1, x2, y2, z2)
			local dx = x1 - x2
			local dy = y1 - y2
			local dz = z1 - z2
			return math.sqrt(dx * dx + dy * dy + dz * dz)
		end
		
		-- Automatically Stores the detection range for each NPC (uses the NPC's entity ID as the key)
		local npc_detection_ranges = {}
		
		-- Set a default detection range
		local default_detection_range = 150
		
		menu.toggle_loop(extrasList, translate("Trolling", "Traffic Momentum Boost +++Speed"), {}, "Speeds up traffic by introducing a third method for adding lethal momentum without sacrificing NPC Driver control. Pair this with DOWNWARDS and Brute Force for 'Traffic Singularity'.", function()
			if not is_player_active(pId, false, true) then
				return util.stop_thread()
			end
		
			local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
			for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 2230.0)) do
				if TASK.GET_ACTIVE_VEHICLE_MISSION_TYPE(vehicle) ~= 6 then
					local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
					if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
						request_control_once(driver)
						VEHICLE.MODIFY_VEHICLE_TOP_SPEED(vehicle, 20050)
						ENTITY.SET_ENTITY_AS_MISSION_ENTITY(vehicle, true, true)
						ENTITY.SET_ENTITY_AS_MISSION_ENTITY(driver, true, true)
						ENTITY.SET_ENTITY_LOAD_COLLISION_FLAG(driver, true)
						TASK.TASK_VEHICLE_MISSION_PED_TARGET(driver, vehicle, targetPed, 6, 100.0, 0, 0.0, 0.0, true)
					end
				end
			end
		
			local push_timer = 3
			local push_cooldown = 100 
			local max_distance_threshold = 300
			
			local function current_ms()
				return os.time() * 500
			end
			
			local last_push_time = current_ms() -- Initialize the last_push_time
			
			-- Check and trigger push effect
			local push_force_multiplier = 1119.81 -- Adjust the push force
			
			for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 2225.0)) do
				local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
				if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
					local vehicleCoords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
					local targetPedCoords = ENTITY.GET_ENTITY_COORDS(targetPed, true)
					local distance_to_player = calculate_distance(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, targetPedCoords.x, targetPedCoords.y, targetPedCoords.z)
			
					-- Check if the player is further away than the maximum allowed distance
					if distance_to_player > max_distance_threshold and (current_ms() - last_push_time) >= push_cooldown then
						local dx, dy, dz = targetPedCoords.x - vehicleCoords.x, targetPedCoords.y - vehicleCoords.y, targetPedCoords.z - vehicleCoords.z
						local force = {x = dx * push_force_multiplier, y = dy * push_force_multiplier, z = dz * push_force_multiplier}
			
						-- Request control of the vehicle for network synchronization
						if NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle) then
							ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, force.x, force.y, force.z, 0, 0, 0, 0, false, false, true, false, true)
							last_push_time = current_ms() 
						end
					end
				end
			end
		end)
	
		menu.toggle_loop(extrasList, translate("Trolling", "OG 2020 Toxic Traffic"), {}, "K", function()
			if not is_player_active(pId, false, true) then
				return util.stop_thread()
			end
			local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
			for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 70.0)) do
				if TASK.GET_ACTIVE_VEHICLE_MISSION_TYPE(vehicle) ~= 6 then
					local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
					if not PED.IS_PED_A_PLAYER(driver) then
						request_control_once(driver)
						TASK.TASK_VEHICLE_MISSION_PED_TARGET(driver, vehicle, targetPed, 6, 100.0, 0, 0.0, 0.0, true)
					end
				end
			end
		end)


		local moreToolslist = menu.list(customTrollingOpt, translate("Ultimate Custom Traffic", "More Tools / Options •     >"), {}, "Go crazy, go stupid.")
		
		local NPCPowers = menu.list(superPowersMenu, translate("Ultimate Custom Traffic", "NPC Powers •     >"), {}, "Powers within this tab will apply to NPCDrivers and Trolly Drivers.")
		local customizeNPCPowers = menu.list(NPCPowers, translate("Ultimate Custom Traffic", "Customize NPC Powers •     >"), {}, "Go crazy, go stupid. Please note: These settings only need to be configured once per lobby IF you apply them to yourself and spectate OTHER players. CTL will iterate THROUGH whoever has CTL enabled, so it's recommended to apply them to yourself and sit offmap / in the ocean, then spectate people and watch the chaos start around them as CTL iterates through you!")
		
		local PlayerPower = menu.list(superPowersMenu, translate("Ultimate Custom Traffic", "Player Powers •     >"), {}, "Powers within this tab will apply to Players and their cars.")
		local customizePlayerPower = menu.list(PlayerPower, translate("Ultimate Custom Traffic", "Customize Player Powers •     >"), {}, "Please note: These settings only need to be configured once per lobby IF you apply them to yourself and spectate OTHER players. CTL will iterate THROUGH whoever has CTL enabled, so it's recommended to apply them to yourself and sit offmap / in the ocean, then spectate people and watch the chaos start around them as CTL iterates through you!")


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
		
		local superSpeedSlider = createMenuSlider(customizeNPCPowers, "Super Speed Multiplier • >", "Modify the engine power and wheel torque of NPC & Trolly Drivers!", 1000, 50000, 2000, 1000, function(value) speedMultiplier = value end)
		
		local proximityhoming = menu.list(customizeNPCPowers, translate("Customize Proximity Homing •     >", "Customize Proximity Homing •     >"))
		local pushCooldownSlider = createMenuSlider(proximityhoming, "PH NPC Lunge Cooldown", "", 0, 10000, proximity_push_cooldown, 100, function(value) proximity_push_cooldown = value end)
		local pushTimerSlider = createMenuSlider(proximityhoming, "PH NPC Lunge Duration", "?", 0, 2000, proximity_push_timer, 1, function(value) proximity_push_timer = value end)
		local pushThresholdSlider = createMenuSlider(proximityhoming, "PH NPC Lunge Threshold", "How powerful will the NPCs be attracted to the player within their range?", 0, 5000, proximity_push_threshold, 1, function(value) proximity_push_threshold = value end)
		local pushForceMultiplierSlider = createMenuSlider(proximityhoming, "PH Lunge Force Multiplier", "Multiples the Lunge Threshold value by this value", 0, 5000, proximity_push_force_multiplier * 2, 1, function(value) proximity_push_force_multiplier = value / 100 end)
		local distanceThresholdSlider = createMenuSlider(proximityhoming, "PH Attraction Range", "How close before the NPC drivers lunge at the player to keep them pinned", 0, 5000, (proximity_distance_threshold * 10) - 85, 1, function(value) proximity_distance_threshold = (value + 85) / 10 end)
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
		
		util.create_thread(customTrafficLoop)



	-------------------------------------
	-- SEND POLICE CAR
	-------------------------------------
	local attacker = {
		godmode = false,

	}

	menu.action(extraTraffic, translate("Trolling - Attacker Options", "Send Police Car"), {}, "OG Function from Wiriscript, kept in since it follows the (Traffic related) vibe of the script. P.S Dev tip: this function is literally a midget version of trolly vehicles, just insanely condensed into a menu.action. this function could totally be evolved into something else.", function()
		local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
		local offset = get_random_offset_from_entity(targetPed, 50.0, 60.0)
		local outCoords = v3.new()
		local outHeading = memory.alloc(4)

		if PATHFIND.GET_CLOSEST_VEHICLE_NODE_WITH_HEADING(offset.x, offset.y, offset.z, outCoords, outHeading, 1, 3.0, 0) then
			local vehicleHash <const> = util.joaat("police3")
			local pedHash <const> = util.joaat("s_m_y_cop_01")
			request_model(vehicleHash); request_model(pedHash)

			local pos = ENTITY.GET_ENTITY_COORDS(targetPed, false)
			local vehicle = entities.create_vehicle(vehicleHash, pos, 0.0)
			if not ENTITY.DOES_ENTITY_EXIST(vehicle) then return end
			ENTITY.SET_ENTITY_COORDS(vehicle, outCoords.x, outCoords.y, outCoords.z, false, false, false, false)
			ENTITY.SET_ENTITY_HEADING(vehicle, memory.read_float(outHeading))
			VEHICLE.SET_VEHICLE_SIREN(vehicle, true)
			AUDIO.BLIP_SIREN(vehicle)
			VEHICLE.SET_VEHICLE_ENGINE_ON(vehicle, true, true, true)
			ENTITY.SET_ENTITY_INVINCIBLE(vehicle, attacker.godmode)

			local pSequence = memory.alloc_int()
			TASK.OPEN_SEQUENCE_TASK(pSequence)
			TASK.TASK_COMBAT_PED(0, targetPed, 0, 16)
			TASK.TASK_GO_TO_ENTITY(0, targetPed, 6000, 10.0, 3.0, 0.0, 0)
			TASK.SET_SEQUENCE_TO_REPEAT(memory.read_int(pSequence), true)
			TASK.CLOSE_SEQUENCE_TASK(memory.read_int(pSequence))

			for seat = -1, 0 do
				local cop = entities.create_ped(5, pedHash, outCoords, 0.0)
				ENTITY.SET_ENTITY_AS_MISSION_ENTITY(cop, true, false)
				set_decor_flag(cop, DecorFlag_isAttacker)
				PED.SET_PED_INTO_VEHICLE(cop, vehicle, seat)
				PED.SET_PED_RANDOM_COMPONENT_VARIATION(cop, 0)
				local weapon <const> = (seat == -1) and "weapon_pistol" or "weapon_pumpshotgun"
				WEAPON.GIVE_WEAPON_TO_PED(cop, util.joaat(weapon), -1, false, true)
				PED.SET_PED_COMBAT_ATTRIBUTES(cop, 1, true)
				PED.SET_PED_AS_COP(cop, true)
				ENTITY.SET_ENTITY_INVINCIBLE(cop, attacker.godmode)
				TASK.TASK_PERFORM_SEQUENCE(cop, memory.read_int(pSequence))
			end

			TASK.CLEAR_SEQUENCE_TASK(pSequence)
			AUDIO.PLAY_POLICE_REPORT("SCRIPTED_SCANNER_REPORT_FRANLIN_0_KIDNAP", 0.0)
		end
	end)


	-------------------------------------
	-- attatch to selected player
	-------------------------------------

	local usingPiggyback = false
	local usingRape = false

	local helpText = translate("Trolling", "The player won't see you attached to them")
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

	-------------------------------------
	-- ENEMY VEHICLES
	-------------------------------------

	local enemyVehiclesOpt = menu.list(trollingOpt, translate("Trolling", "OG Enemy Vehicles"), {}, "This is the OG Enemy Vehicles from Wiriscript, since it fits the vision I have for this script it has been kept and is planned to be overhauled into a refactored version with special features, just like for what I did with Trolly Vehicles. SOON")
	local options = {"Minitank", "Buzzard", "Lazer"}
	local setGodmode = false
	local gunnerWeapon = util.joaat("weapon_mg")
	local weaponModId = -1
	local count = 1
	
	---@param targetId integer
	local function spawn_minitank(targetId)
		local vehicleHash = util.joaat("minitank")
		local pedHash = util.joaat("s_m_y_blackops_01")
		request_model(vehicleHash); request_model(pedHash)
		local pos = players.get_position(targetId)
		local vehicle = entities.create_vehicle(vehicleHash, pos, 0.0)
		if not ENTITY.DOES_ENTITY_EXIST(vehicle) then
			return
		end
		NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(NETWORK.VEH_TO_NET(vehicle), true)
		ENTITY.SET_ENTITY_AS_MISSION_ENTITY(vehicle, false, true)
		NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(NETWORK.VEH_TO_NET(vehicle), players.user(), true)
		ENTITY.SET_ENTITY_LOAD_COLLISION_FLAG(vehicle, true, 1)
		set_decor_flag(vehicle, DecorFlag_isEnemyVehicle)
		local offset = get_random_offset_from_entity(vehicle, 35.0, 50.0)
		local outHeading = memory.alloc(4)
		local outCoords = v3.new()
		if PATHFIND.GET_CLOSEST_VEHICLE_NODE_WITH_HEADING(offset.x, offset.y, offset.z, outCoords, outHeading, 1, 3.0, 0) then
			local driver = entities.create_ped(5, pedHash, offset, 0.0)
			NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(NETWORK.PED_TO_NET(driver), true)
			ENTITY.SET_ENTITY_AS_MISSION_ENTITY(driver, false, true)
			NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(NETWORK.PED_TO_NET(driver), players.user(), true)
			ENTITY.SET_ENTITY_LOAD_COLLISION_FLAG(driver, true, 1)
			ENTITY.SET_ENTITY_INVINCIBLE(driver, true)
			PED.SET_PED_INTO_VEHICLE(driver, vehicle, -1)
			AUDIO.STOP_PED_SPEAKING(driver, true)
			PED.SET_PED_COMBAT_ATTRIBUTES(driver, 46, true)
			PED.SET_PED_COMBAT_ATTRIBUTES(driver, 1, true)
			PED.SET_PED_COMBAT_ATTRIBUTES(driver, 3, false)
			PED.SET_PED_COMBAT_RANGE(driver, 2)
			PED.SET_PED_SEEING_RANGE(driver, 1000.0)
			PED.SET_PED_SHOOT_RATE(driver, 1000)
			PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(driver, true)
			TASK.SET_DRIVE_TASK_DRIVING_STYLE(driver, 786468)
	
			ENTITY.SET_ENTITY_COORDS(vehicle, outCoords.x, outCoords.y, outCoords.z, false, false, false, false)
			ENTITY.SET_ENTITY_HEADING(vehicle, memory.read_float(outHeading))
			ENTITY.SET_ENTITY_INVINCIBLE(vehicle, setGodmode)
			VEHICLE.SET_VEHICLE_MOD_KIT(vehicle, 0)
			VEHICLE.SET_VEHICLE_MOD(vehicle, 10, weaponModId, false)
			VEHICLE.SET_VEHICLE_ENGINE_ON(vehicle, true, true, true)
			local blip = add_blip_for_entity(vehicle, 742, 4)
	
			util.create_tick_handler(function()
				local target = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(targetId)
				local vehPos = ENTITY.GET_ENTITY_COORDS(vehicle, false)
				if not ENTITY.DOES_ENTITY_EXIST(vehicle) or ENTITY.IS_ENTITY_DEAD(vehicle, false) or
				not ENTITY.DOES_ENTITY_EXIST(driver) or PED.IS_PED_INJURED(driver) then
					return false
	
				elseif not PED.IS_PED_IN_COMBAT(driver, target) and not PED.IS_PED_INJURED(target) then
					TASK.CLEAR_PED_TASKS(driver)
					TASK.TASK_COMBAT_PED(driver, target, 0, 16)
					PED.SET_PED_KEEP_TASK(driver, true)
	
				elseif not is_player_active(targetId, false, true) or
				players.get_position(targetId):distance(vehPos) > 1000.0 then
					TASK.CLEAR_PED_TASKS(driver)
					PED.SET_PED_COMBAT_ATTRIBUTES(driver, 46, false)
					TASK.TASK_VEHICLE_DRIVE_WANDER(driver, vehicle, 10.0, 786603)
					PED.SET_PED_KEEP_TASK(driver, true)
					remove_decor(vehicle)
					util.remove_blip(blip)
					local pVehicle = memory.alloc_int()
					memory.write_int(pVehicle, vehicle)
					ENTITY.SET_VEHICLE_AS_NO_LONGER_NEEDED(pVehicle)
					return false
				end
			end)
		end
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(vehicleHash)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(pedHash)
	end
	
	---@param targetId integer
	local function spawn_buzzard(targetId)
		local vehicleHash = util.joaat("buzzard")
		local pedHash = util.joaat("s_m_y_blackops_01")
		request_model(vehicleHash);	request_model(pedHash)
		local target = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(targetId)
		local playerRelGroup = PED.GET_PED_RELATIONSHIP_GROUP_HASH(target)
		PED.SET_RELATIONSHIP_BETWEEN_GROUPS(5, util.joaat("ARMY"), playerRelGroup)
		PED.SET_RELATIONSHIP_BETWEEN_GROUPS(5, playerRelGroup, util.joaat("ARMY"))
		PED.SET_RELATIONSHIP_BETWEEN_GROUPS(0, util.joaat("ARMY"), util.joaat("ARMY"))
	
		local pos = players.get_position(targetId)
		local heli = entities.create_vehicle(vehicleHash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
		if ENTITY.DOES_ENTITY_EXIST(heli) then
			NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(NETWORK.VEH_TO_NET(heli), true)
			ENTITY.SET_ENTITY_AS_MISSION_ENTITY(heli, false, true)
			NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(NETWORK.VEH_TO_NET(heli), players.user(), true)
			ENTITY.SET_ENTITY_LOAD_COLLISION_FLAG(heli, true, 1)
			set_decor_flag(heli, DecorFlag_isEnemyVehicle)
			local pos = get_random_offset_from_entity(target, 20.0, 40.0)
			pos.z = pos.z + 20.0
			ENTITY.SET_ENTITY_COORDS(heli, pos.x, pos.y, pos.z, false, false, false, false)
			NETWORK.SET_NETWORK_ID_CAN_MIGRATE(NETWORK.VEH_TO_NET(heli), false)
			ENTITY.SET_ENTITY_INVINCIBLE(heli, setGodmode)
			VEHICLE.SET_VEHICLE_ENGINE_ON(heli, true, true, true)
			VEHICLE.SET_HELI_BLADES_FULL_SPEED(heli)
			local blip = add_blip_for_entity(heli, 422, 4)
			set_blip_name(blip, "buzzard2", true)
	
			local pilot = entities.create_ped(29, pedHash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
			PED.SET_PED_INTO_VEHICLE(pilot, heli, -1)
			PED.SET_PED_MAX_HEALTH(pilot, 500)
			ENTITY.SET_ENTITY_HEALTH(pilot, 500, 0)
			ENTITY.SET_ENTITY_INVINCIBLE(pilot, setGodmode)
			PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(pilot, true)
			PED.SET_PED_KEEP_TASK(pilot, true)
			TASK.TASK_HELI_MISSION(pilot, heli, 0, target, 0.0, 0.0, 0.0, 23, 40.0, 40.0, -1.0, 0, 10, -1.0, 0)
	
			for seat = 1, 2 do
				local ped = entities.create_ped(29, pedHash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
				PED.SET_PED_INTO_VEHICLE(ped, heli, seat)
				WEAPON.GIVE_WEAPON_TO_PED(ped, gunnerWeapon, -1, false, true)
				PED.SET_PED_COMBAT_ATTRIBUTES(ped, 20, true)
				PED.SET_PED_MAX_HEALTH(ped, 500)
				ENTITY.SET_ENTITY_HEALTH(ped, 500, 0)
				ENTITY.SET_ENTITY_INVINCIBLE(ped, setGodmode)
				PED.SET_PED_SHOOT_RATE(ped, 1000)
				PED.SET_PED_RELATIONSHIP_GROUP_HASH(ped, util.joaat("ARMY"))
				TASK.TASK_COMBAT_HATED_TARGETS_AROUND_PED(ped, 200.0, 0)
			end
		end
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(pedHash)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(vehicleHash)
	end
	
	---@param targetId integer
	local function spawn_lazer(targetId)
		local jetHash = util.joaat("lazer")
		local pedHash = util.joaat("s_m_y_blackops_01")
		request_model(jetHash); request_model(pedHash)
		local target = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(targetId)
		local pos = players.get_position(targetId)
		local jet = entities.create_vehicle(jetHash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
		if ENTITY.DOES_ENTITY_EXIST(jet) then
			NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(NETWORK.VEH_TO_NET(jet), true)
			ENTITY.SET_ENTITY_AS_MISSION_ENTITY(jet, false, true)
			NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(NETWORK.VEH_TO_NET(jet), players.user(), true)
			ENTITY.SET_ENTITY_LOAD_COLLISION_FLAG(jet, true, 1)
			set_decor_flag(jet, DecorFlag_isEnemyVehicle)
			local pos = get_random_offset_from_entity(jet, 30.0, 80.0)
			pos.z = pos.z + 500.0
			ENTITY.SET_ENTITY_COORDS(jet, pos.x, pos.y, pos.z, false, false, false, false)
			set_entity_face_entity(jet, target, false)
			local blip = add_blip_for_entity(jet, 16, 4)
			set_blip_name(blip, "blip_4xz66m0", true) -- random collision for 0x2257C97F
			VEHICLE.CONTROL_LANDING_GEAR(jet, 3)
			ENTITY.SET_ENTITY_INVINCIBLE(jet, setGodmode)
			VEHICLE.SET_VEHICLE_FORCE_AFTERBURNER(jet, true)
	
			local pilot = entities.create_ped(5, pedHash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
			ENTITY.SET_ENTITY_AS_MISSION_ENTITY(pilot, false, true)
			PED.SET_PED_INTO_VEHICLE(pilot, jet, -1)
			TASK.TASK_PLANE_MISSION(pilot, jet, 0, target, 0.0, 0.0, 0.0, 6, 100.0, 0.0, 0.0, 80.0, 50.0, false)
			PED.SET_PED_COMBAT_ATTRIBUTES(pilot, 1, true)
			VEHICLE.SET_VEHICLE_FORWARD_SPEED(jet, 60.0)
		end
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(jetHash)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(pedHash)
	end
	
	local function spawn_vehicle(option, pId)
		if option == "Minitank" then
			spawn_minitank(pId)
		elseif option == "Lazer" then
			spawn_lazer(pId)
		elseif option == "Buzzard" then
			spawn_buzzard(pId)
		end
	end
	
	local function select_minitank_weapon(index, minitankModIds)
		if index == 1 then
			return minitankModIds.stockWeapon
		elseif index == 2 then
			return minitankModIds.plasmaCannon
		elseif index == 3 then
			return minitankModIds.rocket
		end
	end
	
	menu.textslider(enemyVehiclesOpt, translate("Trolling - Enemy Vehicles", "Send Enemy Vehicle"), {}, "", options, function(index, option)
		local i = 0
		while i < count and players.exists(pId) do
			spawn_vehicle(option, pId)
			i = i + 1
			util.yield(150)
		end
	end)
	
	local minitankModIds = {
		stockWeapon = -1,
		plasmaCannon = 1,
		rocket = 2,
	}
	local gunnerWeaponNames = {
		util.get_label_text("WT_V_PLRBUL"),
		util.get_label_text("MINITANK_WEAP2"),
		util.get_label_text("MINITANK_WEAP3"),
	}
	local name_minitankWeapon = translate("Trolling - Enemy Vehicles", "Minitank Weapon")
	
	menu.textslider_stateful(enemyVehiclesOpt, name_minitankWeapon, {}, "", gunnerWeaponNames, function(index)
		weaponModId = select_minitank_weapon(index, minitankModIds)
	end)
	
	local gunnerWeapons = {"weapon_mg", "weapon_rpg"}
	local enemVehOptions = {util.get_label_text("WT_MG"), util.get_label_text("WT_RPG")}
	
	menu.textslider_stateful(enemyVehiclesOpt, translate("Trolling - Enemy Vehicles", "Gunners Weapon"), {}, "", enemVehOptions, function(index)
		gunnerWeapon = util.joaat(gunnerWeapons[index])
	end)
	
	menu.slider(enemyVehiclesOpt, translate("Trolling - Enemy Vehicles", "Count"), {}, "",
		1, 10, 1, 1, function(value) count = value end)
	
	menu.toggle(enemyVehiclesOpt, translate("Trolling - Enemy Vehicles", "Invincible"), {}, "",
		function(toggle) setGodmode = toggle end)
	
	local deleteVehiclePassengers = function(vehicle)
		for seat = -1, VEHICLE.GET_VEHICLE_MAX_NUMBER_OF_PASSENGERS(vehicle) - 1 do
			if VEHICLE.IS_VEHICLE_SEAT_FREE(vehicle, seat, false) then
				continue
			end
			local passenger = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, seat, false)
			if request_control(passenger, 1000) then entities.delete_by_handle(passenger) end
		end
	end
	
	menu.action(enemyVehiclesOpt, translate("Trolling - Enemy Vehicles", "Delete"), {}, "", function()
		for _, vehicle in ipairs(entities.get_all_vehicles_as_handles()) do
			if is_decor_flag_set(vehicle, DecorFlag_isEnemyVehicle) and request_control(vehicle, 1000) then
				deleteVehiclePassengers(vehicle)
				entities.delete_by_handle(vehicle)
			end
		end
	end)



	-------------------------------------
	-- HOSTILE PEDS
	-------------------------------------

	menu.toggle_loop(moreToolslist, translate("Trolling", "Hostile Peds"), {}, "", function()
		if not is_player_active(pId, false, true) then
			return util.stop_thread()
		end
		local target = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
		local pSequence = memory.alloc_int()
		TASK.OPEN_SEQUENCE_TASK(pSequence)
		TASK.TASK_LEAVE_ANY_VEHICLE(0, 0, 256)
		TASK.TASK_COMBAT_PED(0, target, 0, 0)
		TASK.TASK_GO_TO_ENTITY(0, target, -1, 80.0, 3.0, 0.0, 0)
		TASK.CLOSE_SEQUENCE_TASK(memory.read_int(pSequence))

		for _, ped in ipairs(get_peds_in_player_range(pId, 70.0)) do
			if not PED.IS_PED_A_PLAYER(ped) and TASK.GET_SEQUENCE_PROGRESS(ped) == -1 then
				request_control_once(ped)
				local weapon = table.random(Weapons)
				PED.SET_PED_COMBAT_ATTRIBUTES(ped, 46, true)
				PED.SET_PED_MAX_HEALTH(ped, 300)
				ENTITY.SET_ENTITY_HEALTH(ped, 300, 0)
				WEAPON.GIVE_WEAPON_TO_PED(ped, util.joaat(weapon), -1, false, true)
				WEAPON.SET_PED_DROPS_WEAPONS_WHEN_DEAD(ped, false)
				TASK.CLEAR_PED_TASKS(ped)
				TASK.TASK_PERFORM_SEQUENCE(ped, memory.read_int(pSequence))
			end
		end
		TASK.CLEAR_SEQUENCE_TASK(pSequence)
	end)

	-------------------------------------
	-- NET FORCEFIELD
	-------------------------------------

	local selectedOpt = 1
	local usingForcefield = false

	menu.toggle(moreToolslist, translate("Forcefield", "Forcefield"), {}, "", function(on)
		usingForcefield = on
		while usingForcefield and is_player_active(pId, false, true) and
		not util.is_session_transition_active() do
			if  selectedOpt == 1 then
				local target = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
				local pos = ENTITY.GET_ENTITY_COORDS(target, false)
				for _, vehicle in ipairs(get_vehicles_in_player_range(pId, 10)) do
					if not request_control_once(vehicle) or
					PED.GET_VEHICLE_PED_IS_USING(target) == vehicle then
						continue
					end
					local vehPos = ENTITY.GET_ENTITY_COORDS(vehicle, false)
					local force = v3.new(vehPos)
					force:sub(pos)
					force:normalise()
					ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, force.x, force.y, force.z, 0, 0, 0.5, 0, false, false, true, false, false)
				end

			elseif selectedOpt == 2 then
				local pos = players.get_position(pId)
				FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, 29, 5.0, false, true, 0.0, true)
			end
			util.yield_once()
		end
	end)


	local options <const> = {translate("Forcefield", "Push Out"), translate("Forcefield", "Destroy")}
	menu.textslider_stateful(moreToolslist, translate("Forcefield", "Set Forcefield"), {}, "", options, function(index)
		selectedOpt = index
	end)

	-------------------------------------
	-- KAMIKASE
	-------------------------------------

	local options <const> = {"Lazer", "Mammatus",  "Cuban800"}
	menu.textslider(extrasList, translate("Trolling", "Kamikaze"), {}, "", options, function (index, plane)
		local hash <const> = util.joaat(plane)
		request_model(hash)
		local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pId)
		local pos = get_random_offset_from_entity(targetPed, 20.0, 20.0)
		pos.z = pos.z + 30.0
		local plane = entities.create_vehicle(hash, pos, 0.0)
		set_entity_face_entity(plane, targetPed, true)
		VEHICLE.SET_VEHICLE_FORWARD_SPEED(plane, 150.0)
		VEHICLE.CONTROL_LANDING_GEAR(plane, 3)
	end)



end -- generate_features() BEGINNING OF SELF












---------------------
---------------------
-- VEHICLE
---------------------
---------------------

local vehicleOptions <const> = menu.list(menu.my_root(), translate("Vehicle", "Vehicle"), {}, "THESE FUNCTIONS ARE NOT OFFICIALLY SUPPORTED BY WHOWARE, PLEASE GO TO > Players TO USE CUSTOM TRAFFIC")

-------------------------------------
-- AIRSTRIKE AIRCRAFT
-------------------------------------

local vehicleWeaponRoot <const> = menu.list(vehicleOptions, translate("Vehicle", "Vehicle Weapons"), {"vehicleweapons"}, "THESE FUNCTIONS ARE NOT OFFICIALLY SUPPORTED BY WHOWARE, PLEASE GO TO > Players TO USE CUSTOM TRAFFIC")
local state = 0
local hash <const> = util.joaat("weapon_airstrike_rocket")
local trans =
{
	MenuName = translate("Vehicle", "Airstrike Aircraft"),
	Help = translate("Vehicle", "Use any plane or helicopter to make airstrikes"),
	CornerHelp = translate("Vehicle", "Press ~%s~ to use Airstrike Aircraft"),
	Notification = translate("Vehicle", "Airstrike Aircraft can be used in planes and helicopters"),
	HelpText = translate("Vehicle", "Use any plane or helicopter to make airstrikes"),
}
local timer = newTimer()


menu.toggle_loop(vehicleOptions, trans.MenuName, {"airstrikeplane"}, trans.HelpText, function ()
	local control = Config.controls.airstrikeaircraft
	if state == 0 then
		local action_name = table.find_if(Imputs, function (k, tbl)
			return tbl[2] == control
		end)
		assert(action_name, "control name not found")
		notification:help(trans.Notification)
		util.show_corner_help(trans.CornerHelp:format(action_name))
		state = 1
	end

	if PED.IS_PED_IN_FLYING_VEHICLE(players.user_ped()) and PAD.IS_CONTROL_PRESSED(2, control) and
	timer.elapsed() > 800 then
		local vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false)
		local vehPos = ENTITY.GET_ENTITY_COORDS(vehicle, false)
		local groundZ = get_ground_z(vehPos)
		local startTime = newTimer()

		util.create_tick_handler(function()
			util.yield(500)
			if vehPos.z - groundZ < 10.0 then
				return false
			end
			local pos = get_random_offset_in_range(vehPos, 0.0, 5.0)
			MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(
				pos.x, pos.y, pos.z - 3.0,
				pos.x, pos.y, groundZ,
				200,
				true,
				hash,
				players.user_ped(), true, false, 1000.0
			)
			return startTime.elapsed() < 5000
		end)

		timer.reset()
	end
end, function() state = 0 end)

-------------------------------------
-- VEHICLE WEAPONS
-------------------------------------

---@param vehicle Vehicle
---@return number heading
local get_vehicle_cam_relative_heading = function(vehicle)
	local camDir = CAM.GET_GAMEPLAY_CAM_ROT(0):toDir()
	local fwdVector = ENTITY.GET_ENTITY_FORWARD_VECTOR(vehicle)
	camDir.z, fwdVector.z = 0.0, 0.0
	local angle = math.acos(fwdVector:dot(camDir) / (#camDir * #fwdVector))
	return math.deg(angle)
end

---@param vehicle Vehicle
---@param damage integer
---@param weaponHash Hash
---@param ownerPed Ped
---@param isAudible boolean
---@param isVisible boolean
---@param speed number
---@param target Entity
---@param position integer
local shoot_from_vehicle = function (vehicle, damage, weaponHash, ownerPed, isAudible, isVisible, speed, target, position)
	local min, max = v3.new(), v3.new()
	local offset
	MISC.GET_MODEL_DIMENSIONS(ENTITY.GET_ENTITY_MODEL(vehicle), min, max)
	if position == 0 then
		offset = v3.new(min.x, max.y + 0.25, 0.3)
	elseif position == 1 then
		offset = v3.new(min.x, min.y, 0.3)
	elseif position == 2 then
		offset = v3.new(max.x, max.y + 0.25, 0.3)
	elseif position == 3 then
		offset = v3.new(max.x, min.y, 0.3)
	else
		error("got unexpected position")
	end
	local a = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, offset.x, offset.y, offset.z)
	local direction = ENTITY.GET_ENTITY_ROTATION(vehicle, 2):toDir()
	if get_vehicle_cam_relative_heading(vehicle) > 95.0 then
		direction:mul(-1)
	end
	local b = v3.new(direction)
	b:mul(300.0); b:add(a)

	MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY_NEW(
		a.x, a.y, a.z,
		b.x, b.y, b.z,
		damage,
		true,
		weaponHash,
		ownerPed,
		isAudible,
		not isVisible,
		speed,
		vehicle,
		false, false, target, false, 0, 0, 0
	)
end

-------------------------------------
-- VEHICLE LASER
-------------------------------------

menu.toggle_loop(vehicleWeaponRoot, translate("Vehicle - Vehicle Weapons", "Vehicle Lasers"), {"vehiclelasers"}, "", function ()
	if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
		local vehicle = get_vehicle_player_is_in(players.user())
		local min, max = v3.new(), v3.new()
		MISC.GET_MODEL_DIMENSIONS(ENTITY.GET_ENTITY_MODEL(vehicle), min, max)
		local startLeft = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle,  min.x, max.y, 0.0)
		local endLeft = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, min.x, max.y + 25.0, 0.0)
		GRAPHICS.DRAW_LINE(startLeft.x, startLeft.y, startLeft.z, endLeft.x, endLeft.y, endLeft.z, 255, 0, 0, 150)

		local startRight = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, max.x, max.y, 0.0)
		local endRight = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, max.x, max.y + 25.0, 0)
		GRAPHICS.DRAW_LINE(startRight.x, startRight.y, startRight.z, endRight.x, endRight.y, endRight.z, 255, 0, 0, 150)
	end
end)

-------------------------------------
-- VEHICLE WEAPONS
-------------------------------------

---@class VehicleWeapon
VehicleWeapon = {modelName = "", timeBetweenShots = 0}
VehicleWeapon.__index = VehicleWeapon

function VehicleWeapon.new(modelName, timeBetweenShots)
	local instance = setmetatable({}, VehicleWeapon)
	instance.modelName = modelName
	instance.timeBetweenShots = timeBetweenShots
	return instance
end

---@type table<string, VehicleWeapon>
local vehicleWeaponList <const> = {
	VehicleWeapon.new("weapon_vehicle_rocket", 220),
	VehicleWeapon.new("weapon_raypistol", 50),
	VehicleWeapon.new("weapon_firework", 220),
	VehicleWeapon.new("vehicle_weapon_tank", 220),
	VehicleWeapon.new("vehicle_weapon_player_lazer", 30)
}
local options <const> = {
	{util.get_label_text("WT_V_SPACERKT")}, {util.get_label_text("WT_RAYPISTOL")},
	{util.get_label_text("WT_FWRKLNCHR")}, {util.get_label_text("WT_V_TANK")}, {util.get_label_text("WT_V_PLRBUL")}
}
local selectedOpt = 1
local state = 0
local timer <const> = newTimer()
local msg = translate("Vehicle - Vehicle Weapons", "Press ~%s~ to use Vehicle Weapons")


menu.toggle_loop(vehicleWeaponRoot, translate("Vehicle - Vehicle Weapons", "Vehicle Weapons"), {}, "", function()
	local control = Config.controls.vehicleweapons
	if state == 0 or timer.elapsed() > 120000 then
		local controlName = table.find_if(Imputs, function(k, tbl)
			return tbl[2] == control
		end)
		assert(controlName, "control name not found")
		util.show_corner_help(msg:format(controlName))
		state = 1
		timer.reset()
	end

	local selectedWeapon = vehicleWeaponList[selectedOpt]
	local vehicle = get_vehicle_player_is_in(players.user())
	local weaponHash <const> = util.joaat(selectedWeapon.modelName)
	request_weapon_asset(weaponHash)

	if not ENTITY.DOES_ENTITY_EXIST(vehicle) or not PAD.IS_CONTROL_PRESSED(0, control) or
	timer.elapsed() < selectedWeapon.timeBetweenShots then
		return
	elseif get_vehicle_cam_relative_heading(vehicle) < 95.0 then
		shoot_from_vehicle(vehicle, 200, weaponHash, players.user_ped(), true, true, 2000.0, 0, 0)
		shoot_from_vehicle(vehicle, 200, weaponHash, players.user_ped(), true, true, 2000.0, 0, 2)
		timer.reset()
	else
		shoot_from_vehicle(vehicle, 200, weaponHash, players.user_ped(), true, true, 2000.0, 0, 1)
		shoot_from_vehicle(vehicle, 200, weaponHash, players.user_ped(), true, true, 2000.0, 0, 3)
		timer.reset()
	end
end, function () state = 0 end)


menu.list_select(vehicleWeaponRoot, translate("Vehicle - Vehicle Weapons", "Set Vehicle Weapons"), {}, "THESE FUNCTIONS ARE NOT OFFICIALLY SUPPORTED BY WHOWARE, PLEASE GO TO > Players TO USE CUSTOM TRAFFIC",
	options, 1, function (index) selectedOpt = index end)

-------------------------------------
-- VEHICLE HOMING MISSILE
-------------------------------------

local trans =
{
	HomingMissiles = translate("Vehicle - Vehicle Weapons", "Advanced Homing Missiles"),
	HelpText = translate("Vehicle - Vehicle Weapons", "Allows you to use homing missiles on any vehicle and " ..
	"shoot up to six targets at once"),
	Whitelist = translate("Homing Missiles - Whitelist", "Whitelist"),
	Friends = translate("Homing Missiles - Whitelist", "Friends"),
	OrgMembers = translate("Homing Missiles - Whitelist", "Organization Members"),
	Crew = translate("Homing Missiles - Whitelist", "Crew Members"),
	MaxTargets = translate("Vehicle - Vehicle Weapons", "Max Number Of Targets")
}

local list_homingMissiles = menu.list(vehicleWeaponRoot, trans.HomingMissiles, {}, trans.HelpText)
local toggle

toggle = menu.toggle_loop(list_homingMissiles, trans.HomingMissiles, {"homingmissiles"}, "", function ()
	if not UFO.exists() and not GuidedMissile.exists() then
		HomingMissiles.mainLoop()
	else
		menu.set_value(toggle, false)
	end
end, HomingMissiles.reset)


local whiteList = menu.list(list_homingMissiles, trans.Whitelist, {}, "THESE FUNCTIONS ARE NOT OFFICIALLY SUPPORTED BY WHOWARE, PLEASE GO TO > Players TO USE CUSTOM TRAFFIC")
menu.toggle(whiteList, trans.Friends, {}, "", HomingMissiles.SetIgnoreFriends)
menu.toggle(whiteList, trans.OrgMembers, {}, "", HomingMissiles.SetIgnoreOrgMembers)
menu.toggle(whiteList, trans.Crew, {}, "", HomingMissiles.SetIgnoreCrewMembers)


menu.slider(list_homingMissiles, trans.MaxTargets , {}, "", 1, 6, 6, 1, HomingMissiles.SetMaxTargets)

-------------------------------------
-- VEHICLE HANDLING EDITOR
-------------------------------------

CHandlingData =
{
	--{"m_model_hash", 0x0008},
	{"fMass", 0x000C},
	{"fInitialDragCoeff", 0x0010},
	{"fDownforceModifier", 0x0014},
	{"fPopUpLightRotation", 0x0018},
	{"vecCentreOfMassOffsetX", 0x0020},
	{"vecCentreOfMassOffsetY", 0x0024},
	{"vecCentreOfMassOffsetZ", 0x0028},
	{"vecInertiaMultiplierX", 0x0030},
	{"vecInertiaMultiplierY", 0x0034},
	{"vecInertiaMultiplierZ", 0x0038},
	{"fPercentSubmerged", 0x0040},
	{"fSubmergedRatio", 0x0044},
	{"fDriveBiasFront", 0x0048},
	{"fDriveBiasRear", 0x004C},
	--{"nInitialDriveGears", 0x0050},
	{"fDriveInertia", 0x0054},
	{"fClutchChangeRateScaleUpShift", 0x0058},
	{"fClutchChangeRateScaleDownShift", 0x005C},
	{"fInitialDriveForce", 0x0060},
	{"fDriveMaxFlatVel", 0x0064},
	{"fInitialDriveMaxFlatVel", 0x0068},
	{"fBrakeForce", 0x006C},
	{"fBrakeBiasFront", 0x0074},
	{"fBrakeBiasRear", 0x0078},
	{"fHandBrakeForce", 0x007C},
	{"fSteeringLock", 0x0080},
	{"fSteeringLockRatio", 0x0084},
	{"fTractionCurveMax", 0x0088},
	{"fTractionCurveMaxRatio", 0x008C},
	{"fTractionCurveMin", 0x0090},
	{"fTractionCurveRatio", 0x0094},
	{"fTractionCurveLateral", 0x0098},
	{"fTractionCurveLateralRatio", 0x009C},
	{"fTractionSpringDeltaMax", 0x00A0},
	{"fTractionSpringDeltaMaxRatio", 0x00A4},
	{"fLowSpeedTractionLossMult", 0x00A8},
	{"fCamberStiffnesss", 0x00AC},
	{"fTractionBiasFront", 0x00B0},
	{"fTractionBiasRear", 0x00B4},
	{"fTractionLossMult", 0x00B8},
	{"fSuspensionForce", 0x00BC},
	{"fSuspensionCompDamp", 0x00C0},
	{"fSuspensionReboundDamp", 0x00C4},
	{"fSuspensionUpperLimit", 0x00C8},
	{"fSuspensionLowerLimit", 0x00CC},
	{"fSuspensionRaise", 0x00D0},
	{"fSuspensionBiasFront", 0x00D4},
	{"fSuspensionBiasRear", 0x00D8},
	{"fAntiRollBarForce", 0x00DC},
	{"fAntiRollBarBiasFront", 0x00E0},
	{"fAntiRollBarBiasRear", 0x00E4},
	{"fRollCentreHeightFront", 0x00E8},
	{"fRollCentreHeightRear", 0x00EC},
	{"fCollisionDamageMult", 0x00F0},
	{"fWeaponDamageMult", 0x00F4},
	{"fDeformationDamageMult", 0x00F8},
	{"fEngineDamageMult", 0x00FC},
	{"fPetrolTankVolume", 0x0100},
	{"fOilVolume", 0x0104},
	{"fSeatOffsetDistX", 0x010C},
	{"fSeatOffsetDistY", 0x0110},
	{"fSeatOffsetDistZ", 0x0114},
	--{"nMonetaryValue", 0x0118},
	--{"strModelFlags", 0x0124},
	--{"strHandlingFlags", 0x0128},
	--{"strDamageFlags", 0x012C},
	--{"AIHandling", 0x013C},
}

CFlyingHandlingData =
{
	{"fThrust", 0x0008},
	{"fThrustFallOff", 0x000C},
	{"fThrustVectoring", 0x0010},
	{"fYawMult", 0x001C},
	{"fYawStabilise", 0x0020},
	{"fSideSlipMult", 0x0024},
	{"fRollMult", 0x002C},
	{"fRollStabilise", 0x0030},
	{"fPitchMult", 0x0038},
	{"fPitchStabilise", 0x003C},
	{"fFormLiftMult", 0x0044},
	{"fAttackLiftMult", 0x0048},
	{"fAttackDiveMult", 0x004C},
	{"fGearDownDragV", 0x0050},
	{"fGearDownLiftMult", 0x0054},
	{"fWindMult", 0x0058},
	{"fMoveRes", 0x005C},
	{"vecTurnResX", 0x0060},
	{"vecTurnResY", 0x0064},
	{"vecTurnResZ", 0x0068},
	{"vecSpeedResX", 0x0070},
	{"vecSpeedResY", 0x0074},
	{"vecSpeedResZ", 0x0078},
	{"fGearDoorFrontOpen", 0x0080},
	{"fGearDoorRearOpen", 0x0084},
	{"fGearDoorRearOpen2", 0x0088},
	{"fGearDoorRearMOpen", 0x008C},
	{"fTurbulanceMagnitudMax", 0x0090},
	{"fTurbulanceForceMulti", 0x0094},
	{"fTurbulanceRollTorqueMulti", 0x0098},
	{"fTurbulancePitchTorqueMulti", 0x009C},
	{"fBodyDamageControlEffectMult", 0x00A0},
	{"fInputSensitivityForDifficulty", 0x00A4},
	{"fOnGroundYawBoostSpeedPeak", 0x00A8},
	{"fOnGroundYawBoostSpeedCap", 0x00AC},
	{"fEngineOffGlideMult", 0x00B0},
	{"fAfterburnerEffectRadius", 0x00B4},
	{"fAfterburnerEffectDistance", 0x00B8},
	{"fAfterburnerEffectForceMulti", 0x00BC},
	{"fSubmergeLevelToPullHeliUnderWater", 0x00C0},
	{"fExtraLiftWithRoll", 0x00C4},
}

SubHandlingData =
{
	CBikeHandlingData =
	{
		{"fLeanFwdCOMMult", 0x0008},
		{"fLeanFwdForceMult", 0x000C},
		{"fLeanBakCOMMult", 0x0010},
		{"fLeanBakForceMult", 0x0014},
		{"fMaxBankAngle", 0x0018},
		{"fFullAnimAngle", 0x001C},
		{"fDesLeanReturnFrac", 0x0024},
		{"fStickLeanMult", 0x0028},
		{"fBrakingStabilityMult", 0x002C},
		{"fInAirSteerMult", 0x0030},
		{"fWheelieBalancePoint", 0x0034},
		{"fStoppieBalancePoint", 0x0038},
		{"fWheelieSteerMult", 0x003C},
		{"fRearBalanceMult", 0x0040},
		{"fFrontBalanceMult", 0x0044},
		{"fBikeGroundSideFrictionMult", 0x0048},
		{"fBikeWheelGroundSideFrictionMult", 0x004C},
		{"fBikeOnStandLeanAngle", 0x0050},
		{"fBikeOnStandSteerAngle", 0x0054},
		{"fJumpForce", 0x0058},
	},
	CFlyingHandlingData = CFlyingHandlingData,
	CFlyingHandlingData2 = CFlyingHandlingData,
	CBoatHandlingData =
	{
		{"fBoxFrontMult", 0x0008},
		{"fBoxRearMult", 0x000C},
		{"fBoxSideMult", 0x0010},
		{"fSampleTop", 0x0014},
		{"fSampleBottom", 0x0018},
		{"fSampleBottomTestCorrection", 0x001C},
		{"fAquaplaneForce", 0x0020},
		{"fAquaplanePushWaterMult", 0x0024},
		{"fAquaplanePushWaterCap", 0x0028},
		{"fAquaplanePushWaterApply", 0x002C},
		{"fRudderForce", 0x0030},
		{"fRudderOffsetSubmerge", 0x0034},
		{"fRudderOffsetForce", 0x0038},
		{"fRudderOffsetForceZMult", 0x003C},
		{"fWaveAudioMult", 0x0040},
		{"vecMoveResistanceX", 0x0050},
		{"vecMoveResistanceY", 0x0054},
		{"vecMoveResistanceZ", 0x0058},
		{"vecTurnResistanceX", 0x0060},
		{"vecTurnResistanceY", 0x0064},
		{"vecTurnResistanceZ", 0x0068},
		{"fLook_L_R_CamHeight", 0x0070},
		{"fDragCoefficient", 0x0074},
		{"fKeelSphereSize", 0x0078},
		{"fPropRadius", 0x007C},
		{"fLowLodAngOffset", 0x0080},
		{"fLowLodDraughtOffset", 0x0084},
		{"fImpellerOffset", 0x0088},
		{"fImpellerForceMult", 0x008C},
		{"fDinghySphereBuoyConst", 0x0090},
		{"fProwRaiseMult", 0x0094},
		{"fDeepWaterSampleBuoyancyMult", 0x0098},
		{"fTransmissionMultiplier", 0x009C},
		{"fTractionMultiplier", 0x00A0},
	},
	CSeaPlaneHandlingData =
	{
		{"fPontoonBuoyConst", 0x0010},
		{"fPontoonSampleSizeFront", 0x0014},
		{"fPontoonSampleSizeMiddle", 0x0018},
		{"fPontoonSampleSizeRear", 0x001C},
		{"fPontoonLengthFractionForSamples", 0x0020},
		{"fPontoonDragCoefficient", 0x0024},
		{"fPontoonVerticalDampingCoefficientUp", 0x0028},
		{"fPontoonVerticalDampingCoefficientDown", 0x002C},
		{"fKeelSphereSize", 0x0030},
	},
	CSubmarineHandlingData =
	{
		{"vTurnResX", 0x0010},
		{"vTurnResY", 0x0014},
		{"vTurnResZ", 0x0018},
		{"fMoveResXY", 0x0020},
		{"fMoveResZ", 0x0024},
		{"fPitchMult", 0x0028},
		{"fPitchAngle", 0x002C},
		{"fYawMult", 0x0030},
		{"fDiveSpeed", 0x0034},
		{"fRollMult", 0x0038},
		{"fRollStab", 0x003C}
	},
	CTrainHandlingData =
	{
	},
	CTrailerHandlingData =
	{
	},
	CCarHandlingData =
	{
		{"fBackEndPopUpCarImpulseMult", 0x0008},
		{"fBackEndPopUpBuildingImpulseMult", 0x000C},
		{"fBackEndPopUpMaxDeltaSpeed", 0x0010},
		{"fToeFront", 0x0014},
		{"fToeRear", 0x0018},
		{"fCamberFront", 0x001C},
		{"fCamberRear", 0x0020},
		{"fCastor", 0x0024},
		{"fEngineResistance", 0x0028},
		{"fMaxDriveBiasTransfer", 0x002C},
		{"fJumpForceScale", 0x0030},
		--{"strAdvancedFlags", 0x003C},
	},
	CVehicleWeaponHandlingData =
	{
		{"fUvAnimatiomMult", 0x0320},
		{"fMiscGadgetVar", 0x0324},
		{"fWheelImpactOffset", 0x0328}
	},
	CSpecialFlightHandlingData =
	{
		{"vecAngularDampingX", 0x0010},
		{"vecAngularDampingY", 0x0014},
		{"vecAngularDampingZ", 0x0018},
		{"vecAngularDampingMinX", 0x0020},
		{"vecAngularDampingMinY", 0x0024},
		{"vecAngularDampingMinZ", 0x0028},
		{"vecLinearDampingX", 0x0030},
		{"vecLinearDampingY", 0x0034},
		{"vecLinearDampingZ", 0x0038},
		{"vecLinearDampingMinX", 0x0040},
		{"vecLinearDampingMinY", 0x0044},
		{"vecLinearDampingMinZ", 0x0048},
		{"fLiftCoefficient", 0x0050},
		{"fMinLiftVelocity", 0x0060},
		{"fDragCoefficient", 0x006C},
		{"fRollTorqueScale", 0x0070},
		{"fYawTorqueScale", 0x007C},
		{"fMaxPitchTorque", 0x0088},
		{"fMaxSteeringRollTorque", 0x008C},
		{"fPitchTorqueScale", 0x0090},
		{"fMaxThrust", 0x0098},
		{"fTransitionDuration", 0x009C},
		{"fHoverVelocityScale", 0x00A0},
		{"fMinSpeedForThrustFalloff", 0x00A8},
		{"fBrakingThrustScale", 0x00AC},
		--{"strFlags", 0x00B8},
	},
}

-------------------------------------
-- HANDLING SECTION
-------------------------------------

local subHandlingClasses =
{
	[0]  = "CBikeHandlingData",
	[1]  = "CFlyingHandlingData",
	[2]  = "CFlyingHandlingData2",
	[3]  = "CBoatHandlingData",
	[4]  = "CSeaPlaneHandlingData",
	[5]  = "CSubmarineHandlingData",
	[6]  = "CTrainHandlingData",
	[7]  = "CTrailerHandlingData",
	[8]  = "CCarHandlingData",
	[9]  = "CVehicleWeaponHandlingData",
	[10] = "CSpecialFlightHandlingData",
}


---@param subHandling integer
---@return integer
local function getSubHandlingType(subHandling)
	local funAddress = memory.read_long(memory.read_long(subHandling) + 16)
	return util.call_foreign_function(funAddress, subHandling)
end


---@param handlingData integer
---@return {type: integer, address: integer}[]
local function getSubHandlingArray(handlingData)
	local subHandlingArray = memory.read_long(handlingData + 0x158)
	local numSubHandling = memory.read_ushort(handlingData + 0x160)
	local arr = {}
	local index = 0
	local t = -1

	while true do
		local subHandling = memory.read_long(subHandlingArray + index * 8)
		if subHandling == NULL then
			goto NotFound
		end

		t = getSubHandlingType(subHandling)
		if t >= 0 and t <= 10 then
			table.insert(arr, {type = t, address = subHandling})
		end

	::NotFound::
		index = index + 1
		if index >= numSubHandling then break end
	end

	return arr
end


local p_getModelInfo = 0
memory_scan("GVMI", "48 89 5C 24 ? 57 48 83 EC 20 8B 8A ? ? ? ? 48 8B DA", function (address)
	p_getModelInfo = memory.rip(address + 0x2A)
end)


local GetHandlingDataFromIndex = 0
memory_scan("GHDFI", "40 53 48 83 EC 30 48 8D 54 24 ? 0F 29 74 24 ?", function (address)
	GetHandlingDataFromIndex = memory.rip(address + 0x37)
end)


---@param modelHash Hash
---@return integer CVehicleModelInfo*
local function getModelInfo(modelHash)
	return util.call_foreign_function(p_getModelInfo, modelHash, NULL)
end


---@param modelInfo integer CVehicleModelInfo*
---@return integer CHandlingData*
local function getVehicleModelHandlingData(modelInfo)
	return util.call_foreign_function(GetHandlingDataFromIndex, memory.read_uint(modelInfo + 0x4B8))
end


-------------------------------------
-- HANDLING DATA
-------------------------------------

---@class HandlingData
HandlingData =
{
	reference = 0,
	name = "",
	address = NULL,
	visible = true,
	offsets = {},
	open = false,
}
HandlingData.__index = HandlingData


---@param parent integer
---@param name string
---@param address integer
---@param offsets {[1]:string, [2]:integer}[]
---@return HandlingData
HandlingData.new = function (parent, name, address, offsets)
	local self = setmetatable({address = address, name = name, offsets = offsets}, HandlingData)
	self.reference = menu.list(parent, name, {}, "THESE FUNCTIONS ARE NOT OFFICIALLY SUPPORTED BY WHOWARE, PLEASE GO TO > Players TO USE CUSTOM TRAFFIC", function()
		self.open = true
	end, function()
		self.open = false
	end)

	menu.divider(self.reference, name)
	for _, tbl in ipairs(offsets) do self:addOption(self.reference, tbl[1], tbl[2]) end
	return self
end


---@param self HandlingData
---@param parent integer
---@param name string
---@param offset integer
HandlingData.addOption = function(self, parent, name, offset)
	local value = memory.read_float(self.address + offset) * 100

	menu.slider_float(parent, name, {name}, "", -1e6, 1e6, math.floor(value), 1, function(new)
		memory.write_float(self.address + offset, new / 100)
	end)
end


HandlingData.Remove = function(self)
	menu.delete(self.reference)
end


function HandlingData:get()
	local r = {}

	for _, tbl in ipairs(self.offsets) do
		local value = memory.read_float(self.address + tbl[2])
		r[tbl[1]] = round(value, 3)
	end

	return r
end


function HandlingData:set(values)
	local count = 0

	for _, tbl in ipairs(self.offsets) do
		local value = values[tbl[1]]

		if not value then
			goto label_continue
		end

		memory.write_float(self.address + tbl[2], value)
		count = count + 1

	::label_continue::
	end
end


-------------------------------------
-- HANDLING EDITOR
-------------------------------------


---@class VehicleList
VehicleList = {selected = 0, root = 0, name = "", onClick = nil}
VehicleList.__index = VehicleList

---@param parent integer
---@param name string
---@param onClick fun(vehicle: Hash)?
---@return VehicleList
function VehicleList.new(parent, name, onClick)
	local self = setmetatable({name = name, onClick = onClick}, VehicleList)
	self.root = menu.list(parent, name, {}, "THESE FUNCTIONS ARE NOT OFFICIALLY SUPPORTED BY WHOWARE, PLEASE GO TO > Players TO USE CUSTOM TRAFFIC")

	local classLists = {}
	for _, vehicle in ipairs(util.get_vehicles()) do
		local nameHash = util.joaat(vehicle.name)
		local class = VEHICLE.GET_VEHICLE_CLASS_FROM_NAME(nameHash)

		if not classLists[class] then
			classLists[class] = menu.list(self.root, util.get_label_text("VEH_CLASS_" .. class), {}, "THESE FUNCTIONS ARE NOT OFFICIALLY SUPPORTED BY WHOWARE, PLEASE GO TO > Players TO USE CUSTOM TRAFFIC")
		end

		local menuName = util.get_label_text(vehicle.name)
		if menuName == "NULL" then
			goto label_coninue
		end

		menu.action(classLists[class], util.get_label_text(vehicle.name), {}, "", function()
			self:setSelected(nameHash, vehicle.name)
			menu.focus(self.root)
		end)
	::label_coninue::
	end

	return self
end


---@param nameHash Hash
---@param vehicleName string?
function VehicleList:setSelected(nameHash, vehicleName)
	if not vehicleName then
		vehicleName = VEHICLE.GET_DISPLAY_NAME_FROM_VEHICLE_MODEL(nameHash)
	end
	menu.set_menu_name(self.root, self.name .. ": " .. util.get_label_text(vehicleName))
	self.selected = nameHash
	if self.onClick then self.onClick(nameHash) end
end


-------------------------------------
-- FILE LIST
-------------------------------------

---@class FileList
FileList = {
	dir = "",
	ext = "json",
	open = false,
	reference = 0,
	options = {},
	fileOpts = {},
	onClick = nil
}
FileList.__index = FileList


---@param parent integer
---@param name string
---@param options table
---@param dir string
---@param ext string
---@param onClick fun(opt: integer, fileName: string, path: string)
---@return FileList
function FileList.new(parent, name, options, dir, ext, onClick)
	local self = setmetatable({dir = dir, ext = ext, options = options}, FileList)
	self.fileOpts = {}
	self.onClick = onClick

	self.reference = menu.list(parent, name, {}, "THESE FUNCTIONS ARE NOT OFFICIALLY SUPPORTED BY WHOWARE, PLEASE GO TO > Players TO USE CUSTOM TRAFFIC", function()
		self.open = true
		self:load()
	end, function()
		self.open = false
		self:clear()
	end)

	return self
end


function FileList:load()
	if not self.dir or not filesystem.exists(self.dir) then
		return
	end

	for _, path in ipairs(filesystem.list_files(self.dir)) do
		local name, ext = string.match(path, '^.+\\(.+)%.(.+)$')
		if not self.ext or self.ext == ext then self:createOpt(name, path) end
	end
end


---@param fileName string
---@param path string
function FileList:createOpt(fileName, path)
	local list = menu.list(self.reference, fileName, {}, "THESE FUNCTIONS ARE NOT OFFICIALLY SUPPORTED BY WHOWARE, PLEASE GO TO > Players TO USE CUSTOM TRAFFIC")

	for i, opt in ipairs(self.options) do
		menu.action(list, opt, {}, "", function() self.onClick(i, fileName, path) end)
	end

	self.fileOpts[#self.fileOpts+1] = list
end


function FileList:clear()
	if #self.fileOpts == 0 then
		return
	end

	for i, ref in ipairs(self.fileOpts) do
		menu.delete(ref); self.fileOpts[i] = nil
	end
end


---@param file string #Must include file extension.
---@param content string
function FileList:add(file, content)
	assert(self.dir ~= "", "tried to add a file to a null directory")
	if not filesystem.exists(self.dir) then
		filesystem.mkdir(self.dir)
	end

	local name, ext = string.match(file, '^(.+)%.(.+)$')
	local count = 1

	while filesystem.exists(self.dir .. file) do
		count = count + 1
		file = string.format("%s (%s).%s", name, count, ext)
	end

	local file <close> = assert(io.open(self.dir .. file, "w"))
	file:write(content)
end


function FileList:reload()
	self:clear()
	self:load()
end

-------------------------------------
-- AUTOLOAD LIST
-------------------------------------


local handlingTrans <const> =
{
	SetVehicle = translate("Handling Editor", "Set Vehicle"),
	CurrentVehicle = translate("Handling Editor", "Current Vehicle"),
	SaveHandling = translate("Handling Editor", "Save Handling Data"),
	SavedFiles = translate("Handling Editor", "Saved Files"),
	Load = translate("Handling Editor", "Load"),
	Delete = translate("Handling Editor", "Delete"),
	Autoload = translate("Handling Editor", "Autoload"),
	Saved = translate("Handling Editor", "Handling file saved"),
	Loaded = translate("Handling Editor", "Handling file successfully loaded"),
	WillAutoload = translate("Handling Editor", "File '%s' will be autoloaded"),
	HandlingEditor = translate("Handling Editor", "Handling Editor"),
	AutoloadedFiles = translate("Handling Editor", "Autoloaded Files"),
	ClickToDelete = translate("Handling Editor", "Click to delete"),
	SavedHelp = translate("Handling Editor", "Saved handling files for the selected vehicle model")
}


---@class AutoloadList
AutoloadList = {reference = 0, options = {}}
AutoloadList.__index = AutoloadList


---@param parent integer
---@param name string
---@return AutoloadList
function AutoloadList.new(parent, name)
	local self = setmetatable({options = {}}, AutoloadList)

	self.reference = menu.list(parent, name, {}, "THESE FUNCTIONS ARE NOT OFFICIALLY SUPPORTED BY WHOWARE, PLEASE GO TO > Players TO USE CUSTOM TRAFFIC")
	return self
end


---@param vehLabel string
---@param file string
function AutoloadList:push(vehLabel, file)
	local vehName = util.get_label_text(vehLabel)

	if self.options[vehName] and menu.is_ref_valid(self.options[vehName]) then
		menu.delete(self.options[vehName])
	end

	self.options[vehName] = menu.action(self.reference, string.format("%s: %s", vehName, file), {}, handlingTrans.ClickToDelete, function()
		Config.handlingAutoload[vehLabel] = nil
		menu.delete(self.options[vehName])
		self.options[vehName] = nil
	end)
end


-------------------------------------
-- HANDLING EDITOR
-------------------------------------


---@class HandlingData
HandlingEditor =
{
	references = {root = 0, meta = 0},
	handlingData = nil,
	subHandlings = {},
	currentVehicle = 0,
	open = false,
	---@type FileList
	filesList = nil,
	---@type AutoloadList
	autoloads = nil
}
HandlingEditor.__index = HandlingEditor



---@param parent integer
---@param name string
---@return HandlingData
function HandlingEditor.new(parent, name)
	local self = setmetatable({subHandlings = {}, references = {}}, HandlingEditor)
	self.references.root = menu.list(parent, name, {}, "THESE FUNCTIONS ARE NOT OFFICIALLY SUPPORTED BY WHOWARE, PLEASE GO TO > Players TO USE CUSTOM TRAFFIC", function()
		self.open = true
	end, function() self.open = false end)


	local vehList = VehicleList.new(self.references.root, handlingTrans.SetVehicle, function (vehicle)
		self:SetCurrentVehicle(vehicle)
	end)


	menu.action(self.references.root, handlingTrans.CurrentVehicle, {}, "", function ()
		local vehicle = entities.get_user_vehicle_as_handle()
		if vehicle ~= 0 then vehList:setSelected(ENTITY.GET_ENTITY_MODEL(vehicle)) end
	end)


	self.references.meta = menu.list(self.references.root, "Meta", {}, "THESE FUNCTIONS ARE NOT OFFICIALLY SUPPORTED BY WHOWARE, PLEASE GO TO > Players TO USE CUSTOM TRAFFIC")

	menu.action(self.references.meta, handlingTrans.SaveHandling, {}, "", function()
		local ok, msg = self:save()
		if not ok then
			return notification:help(capitalize(msg), HudColour.red)
		end
		notification:normal(handlingTrans.Saved, HudColour.purpleDark)
	end)


	local fileOpts <const> =
	{
		handlingTrans.Load,
		handlingTrans.Autoload,
		handlingTrans.Delete,
	}

	self.filesList = FileList.new(self.references.meta, handlingTrans.SavedFiles, fileOpts, "", "json", function (opt, fileName, path)
		if  opt == 1 then
			local ok, msg = self:load(path)
			if not ok then
				return notification:help(capitalize(msg), HudColour.red)
			end
			self:SetCurrentVehicle(self.currentVehicle) -- reloading
			notification:normal(handlingTrans.Loaded, HudColour.purpleDark)

		elseif opt == 3 then
			os.remove(path)
			self.filesList:reload()

		elseif opt == 2 then
			local name = VEHICLE.GET_DISPLAY_NAME_FROM_VEHICLE_MODEL(self.currentVehicle)
			if name == "CARNOTFOUND" then
				return
			end
			Config.handlingAutoload[name] = fileName
			self.autoloads:push(name, fileName)
			notification:normal(string.format(handlingTrans.WillAutoload, fileName), HudColour.purpleDark)
		end
	end)

	menu.set_help_text(self.filesList.reference, handlingTrans.SavedHelp)
	self.autoloads = AutoloadList.new(self.references.meta, handlingTrans.AutoloadedFiles)
	return self
end



---@param hash Hash
function HandlingEditor:SetCurrentVehicle(hash)
	if self.handlingData then self:clear() end
	self.currentVehicle = hash
	local root = self.references.root
	local modelInfo = getModelInfo(hash)
	if modelInfo == NULL then
		return
	end

	local handlingAddress = getVehicleModelHandlingData(modelInfo)
	if handlingAddress == NULL then
		return
	end

	self.handlingData = HandlingData.new(root, "CHandlingData", handlingAddress, CHandlingData)
	local subHandlings = getSubHandlingArray(handlingAddress)

	for _, subHandling in ipairs(subHandlings) do
		if subHandling.address == NULL then
			continue
		end
		local name = subHandlingClasses[subHandling.type]
		local offsets = SubHandlingData[name]
		if not self.subHandlings[name] then self.subHandlings[name] = HandlingData.new(root, name, subHandling.address, offsets) end
	end

	local vehicleName = memory.read_string(modelInfo + 0x298)
	self.filesList.dir = wiriDir .. "handling\\" .. string.lower(vehicleName) .. "\\"
end



function HandlingEditor:clear()
	self.handlingData:Remove()
	for _, h in pairs(self.subHandlings) do h:Remove() end

	self.handlingData = nil
	self.subHandlings = {}
	self.currentVehicle = 0
	self.filesList.dir = ""
end



---@return boolean
---@return string? errmsg
function HandlingEditor:save()
	if not self.handlingData then
		return false, "handling data not found"
	end

	local input = ""
	local label = customLabels.EnterFileName

	while true do
		input = get_input_from_screen_keyboard(label, 31, "")
		if input == "" then
			return false, "save canceled"
		end
		if not input:find '[^%w_%.%-]' then break end
		label = customLabels.InvalidChar
		util.yield(200)
	end

	local data = {}
	data[self.handlingData.name] = self.handlingData:get()

	for _, subHandling in pairs(self.subHandlings) do
		data[subHandling.name] = subHandling:get()
	end

	self.filesList:add(input .. ".json", json.stringify(data, nil, 4))
	return true, nil
end



---@param path string
---@return boolean
---@return string? errmsg
function HandlingEditor:load(path)
	if not self.handlingData then
		return false, "handling data not found"
	end

	if not filesystem.exists(path) then
		return false, "file does not exist"
	end

	local ok, result = json.parse(path, false)
	if not ok then
		return false, result
	end

	self.handlingData:set(result.CHandlingData)

	for name, subHandling in pairs(self.subHandlings) do
		if result[name] then subHandling:set(result[name]) end
	end

	return true, nil
end


---@return integer
function HandlingEditor:autoload()
	local count = 0

	for vehicle, file in pairs(Config.handlingAutoload) do
		local path =  wiriDir .. "handling\\" .. string.lower(vehicle) .. "\\" .. file .. ".json"
		local modelHash = util.joaat(vehicle)

		self:SetCurrentVehicle(modelHash)
		if  self:load(path) then
			self.autoloads:push(vehicle, file)
			count = count + 1
		end
	end

	if self.handlingData then self:clear() end
	return count
end



g_handlingEditor = HandlingEditor.new(vehicleOptions, handlingTrans.HandlingEditor)

local numFilesLoaded = g_handlingEditor:autoload()
util.log("%d handling file(s) loaded", numFilesLoaded)


-------------------------------------
-- UFO
-------------------------------------

local objModels <const> = {
	"imp_prop_ship_01a",
	"sum_prop_dufocore_01a"
}
local options <const> = {translate("UFO", "Alien UFO"), translate("UFO", "Military UFO")}
local helpText = translate("UFO", "Drive an UFO, use its tractor beam and cannon")

menu.textslider(vehicleOptions, translate("UFO", "UFO"), {"ufo"}, helpText, options, function (index)
	local obj = objModels[index]
	UFO.setObjModel(obj)
	if not (GuidedMissile.exists() or UFO.exists()) then UFO.create() end
end)

-------------------------------------
-- VEHICLE INSTANT LOCK ON
-------------------------------------

---@class VehicleLockOn
VehicleLockOn = {address = 0, defaultValue = 0}
VehicleLockOn.__index = VehicleLockOn

---@param address integer
---@return VehicleLockOn
function VehicleLockOn.new(address)
	assert(address ~= NULL, "got a null pointer")
	local instance = setmetatable({}, VehicleLockOn)
	instance.address = address
	instance.defaultValue = memory.read_float(address)
	return instance
end

VehicleLockOn.__eq = function (a, b)
	return a.address == b.address
end

---@return number
function VehicleLockOn:getValue()
	return memory.read_float(self.address)
end

---@param value number
function VehicleLockOn:setValue(value)
	memory.write_float(self.address, value)
end

function VehicleLockOn:reset()
	memory.write_float(self.address, self.defaultValue)
end

---@type VehicleLockOn
local modifiedLockOn
menu.toggle_loop(vehicleOptions, translate("Vehicle", "Vehicle Instant Lock-On"), {}, "", function ()
	local CPed = entities.handle_to_pointer(players.user_ped())
	if CPed == NULL then return end
	local address = addr_from_pointer_chain(CPed, {0x10B8, 0x70, 0x60, 0x178})
	if address == NULL then return end
	local lockOn = VehicleLockOn.new(address)
	modifiedLockOn = modifiedLockOn or lockOn

	if lockOn ~= modifiedLockOn then
		modifiedLockOn:reset()
		modifiedLockOn = lockOn
	end

	if modifiedLockOn:getValue() ~= 0.0 then
		modifiedLockOn:setValue(0.0)
	end
end, function ()
	if modifiedLockOn then modifiedLockOn:reset() end
end)


-------------------------------------
-- VEHICLE EFFECTS
-------------------------------------

local effects <const> = {
	{"scr_rcbarry1", "scr_alien_impact_bul", 1.0, 50},
	{"scr_rcbarry2", "scr_clown_appears", 0.3, 500},
	{"core", "ent_dst_elec_fire_sp", 1.0, 100},
	{"scr_rcbarry1", "scr_alien_disintegrate", 0.1, 400},
	{"scr_rcbarry1", "scr_alien_teleport", 0.1, 400}
}
local selectedOpt = 1
local lastEffect <const> = newTimer()


menu.toggle_loop(vehicleOptions, translate("Vehicle Effects", "Vehicle Effects"), {}, "", function ()
	local effect = effects[selectedOpt]
	local vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false)

	if ENTITY.DOES_ENTITY_EXIST(vehicle) and not ENTITY.IS_ENTITY_DEAD(vehicle, false) and
	VEHICLE.IS_VEHICLE_DRIVEABLE(vehicle, false) and lastEffect.elapsed() > effect[4] then
		request_fx_asset(effect[1])
		for _, boneName in pairs({"wheel_lf", "wheel_lr", "wheel_rf", "wheel_rr"}) do
			local bone = ENTITY.GET_ENTITY_BONE_INDEX_BY_NAME(vehicle, boneName)

			GRAPHICS.USE_PARTICLE_FX_ASSET(effect[1])
			GRAPHICS.START_PARTICLE_FX_NON_LOOPED_ON_ENTITY_BONE(
				effect[2],
				vehicle,
				0.0, 0.0, 0.0,
				0.0, 0.0, 0.0,
				bone,
				effect[3],
				false, false, false
			)
		end
		lastEffect.reset()
	end
end)

local options <const> = {
	translate("Vehicle Effects", "Alien Impact"),
	translate("Vehicle Effects", "Clown Appears"),
	translate("Vehicle Effects", "Blue Sparks"),
	translate("Vehicle Effects", "Alien Disintegration"),
	translate("Vehicle Effects", "Firey Particles"),
}
menu.textslider_stateful(vehicleOptions, translate("Vehicle Effects", "Set Vehicle Effect"), {}, "",
	options, function (index) selectedOpt = index end)

-------------------------------------
-- AUTOPILOT
-------------------------------------

local autopilotSpeed = 25.0
local lastBlip
local lastStyle
local lastSpeed
local lastNotification <const> = newTimer()
local drivingStyle = 786988

---@param blip Blip
local task_drive_to_blip = function(blip)
	local vehicle = get_vehicle_player_is_in(players.user())
	local pos = get_blip_coords(blip)
	if ENTITY.DOES_ENTITY_EXIST(vehicle) and pos ~= nil then
		local pSequence = memory.alloc_int()
		PED.SET_DRIVER_ABILITY(players.user_ped(), 1.0)
		TASK.OPEN_SEQUENCE_TASK(pSequence)
		TASK.TASK_VEHICLE_DRIVE_TO_COORD_LONGRANGE(0, vehicle, pos.x, pos.y, pos.z, autopilotSpeed, drivingStyle, 45.0)
		local heading = ENTITY.GET_ENTITY_HEADING(vehicle)
		TASK.TASK_VEHICLE_PARK(0, vehicle, pos.x, pos.y, pos.z, heading, 7, 60.0, true)
		TASK.CLOSE_SEQUENCE_TASK(memory.read_int(pSequence))
		TASK.TASK_PERFORM_SEQUENCE(players.user_ped(), memory.read_int(pSequence))
		TASK.CLEAR_SEQUENCE_TASK(pSequence)
	end
end

local menuName = translate("Vehicle - Autopilot", "Autopilot")
local autopilot <const> = menu.list(vehicleOptions, menuName, {}, "THESE FUNCTIONS ARE NOT OFFICIALLY SUPPORTED BY WHOWARE, PLEASE GO TO > Players TO USE CUSTOM TRAFFIC")
local msg = translate("Vehicle - Autopilot", "Set a waypoint to start driving")

menu.toggle_loop(autopilot, translate("Vehicle - Autopilot", "Autopilot"), {}, "", function()
	local blip = HUD.GET_FIRST_BLIP_INFO_ID(8)
	if blip == 0 then
		if not lastNotification.isEnabled() then
			lastNotification.reset()
		elseif lastNotification.elapsed() > 30000 then
			notification:normal(msg)
			lastNotification.reset()
			return
		end
		if  TASK.GET_SEQUENCE_PROGRESS(players.user_ped()) ~= -1 then
			TASK.CLEAR_PED_TASKS(players.user_ped())
		end
	elseif lastNotification.isEnabled() then
		lastNotification.disable()
	end

	if drivingStyle ~= lastStyle or blip ~= lastBlip or autopilotSpeed ~= lastSpeed or
	TASK.GET_SEQUENCE_PROGRESS(players.user_ped()) == -1 then
		task_drive_to_blip(blip)
		lastStyle = drivingStyle
		lastBlip = blip
		lastSpeed = autopilotSpeed
	end
end, function ()
	TASK.CLEAR_PED_TASKS(players.user_ped())
	lastNotification.disable()
end)

---@class PresetDriveStyle
---@field name string
---@field help string
---@field style integer

---@type PresetDriveStyle[]
local presets <const> =
{
	{
		name = "Normal",
		help = "Stop before vehicles & peds, avoid empty vehicles & objects and stop at traffic lights.",
		style = 786603
	},
	{
	  	name = "Ignore Lights",
	  	help = "Stop before vehicles, avoid vehicles & objects.",
	  	style = 2883621
	},
	{
	  	name = "Avoid Traffic",
	  	help = "Avoid vehicles & objects.",
	  	style = 786468
	},
	{
	  	name = "Rushed",
	  	help = "Stop before vehicles, avoid vehicles, avoid objects",
	  	style = 1074528293
	},
	{
	  	name = "Default",
	  	help = "Avoid vehicles, empty vehicles & objects, allow going wrong way and take shortest path",
	  	style = 786988
	}
}

local drivingStyleList <const> = menu.list(autopilot, translate("Vehicle - Autopilot", "Driving Style"), {}, "THESE FUNCTIONS ARE NOT OFFICIALLY SUPPORTED BY WHOWARE, PLEASE GO TO > Players TO USE CUSTOM TRAFFIC")
menu.divider(drivingStyleList, translate("Autopilot - Driving Style", "Presets"))

for _, preset in ipairs(presets) do
	local name <const> = translate("Autopilot - Driving Style", preset.name)
	menu.action(drivingStyleList, name, {}, preset.help, function()
		drivingStyle = preset.style
	end)
end

menu.divider(drivingStyleList, translate("Autopilot - Driving Style", "Custom"))
local currentFlag = 0
local drivingStyleFlag <const> = {
	["Stop Before Vehicles"] = 1 << 0,
	["Stop Before Peds"] = 1 << 1,
	["Avoid Vehicles"] = 1 << 2,
	["Avoid Empty Vehicles"] = 1 << 3,
	["Avoid Peds"] = 1 << 4,
	["Avoid Objects"] = 1 << 5,
	["Stop At Traffic Lights"] = 1 << 7,
	["Reverse Only"] = 1 << 10,
	["Take Shortest Path"] = 1 << 18,
	["Ignore Roads"] = 1 << 22,
	["Ignore All Pathing"] = 1 << 24,
}
for name, flag in pairs(drivingStyleFlag) do
	menu.toggle(drivingStyleList, translate("Autopilot - Driving Style", name), {}, "", function(toggle)
		currentFlag = toggle and (currentFlag | flag) or (currentFlag & ~flag)
	end)
end

menu.action(drivingStyleList, translate("Autopilot - Driving Style", "Set Custom Driving Style"), {}, "",
	function() drivingStyle = currentFlag end)

menu.slider(autopilot, translate("Vehicle - Autopilot", "Speed"), {"autopilotspeed"}, "",
	5, 200, 20, 1, function(speed) autopilotSpeed = speed * 1.0 end)

-------------------------------------
-- ENGINE ALWAYS ON
-------------------------------------

menu.toggle_loop(vehicleOptions, translate("Vehicle", "Engine Always On"), {"alwayson"}, "", function()
	if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
		local vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false)
		VEHICLE.SET_VEHICLE_ENGINE_ON(vehicle, true, true, true)
		VEHICLE.SET_VEHICLE_LIGHTS(vehicle, 0)
		VEHICLE.SET_VEHICLE_HEADLIGHT_SHADOWS(vehicle, 2)
	end
end)

-------------------------------------
-- TARGET PASSENGERS
-------------------------------------

local menuName = translate("Vehicle", "Target Passengers Ability")
local helpText = translate("Vehicle", "Allows you to shoot other passengers inside the vehicle you're in")

menu.toggle_loop(vehicleOptions, menuName, {"targetpassengers"}, helpText, function()
	local localPed = players.user_ped()
	if not PED.IS_PED_IN_ANY_VEHICLE(localPed, false) then
		return
	end
	local vehicle = PED.GET_VEHICLE_PED_IS_IN(localPed, false)
	for seat = -1, VEHICLE.GET_VEHICLE_MAX_NUMBER_OF_PASSENGERS(vehicle) - 1 do
		local ped = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, seat, false)
		if ENTITY.DOES_ENTITY_EXIST(ped) and ped ~= localPed and PED.IS_PED_A_PLAYER(ped) then
			local playerGroupHash = PED.GET_PED_RELATIONSHIP_GROUP_HASH(ped)
			local myGroupHash = PED.GET_PED_RELATIONSHIP_GROUP_HASH(localPed)
			PED.SET_RELATIONSHIP_BETWEEN_GROUPS(4, playerGroupHash, myGroupHash)
		end
	end
end)

---------------------
---------------------
-- BODYGUARD
---------------------
---------------------

-------------------------------------
-- COMPONENT
-------------------------------------

---@class Component
local Component = {reference = 0, drawableId = -1, textureId = 0, componentId = 0}
Component.__index = Component

local trans <const> =
{
    Type = translate("Wardrobe", "Type"),
    Texture = translate("Wardrobe", "Texture"),
}


---@param parent integer
---@param name string
---@param ped Ped
---@param componentId integer
---@param onChange fun(drawable: integer, texture: integer)
function Component.new(parent, name, ped, componentId, onChange)
    local self = setmetatable({}, Component)
    self.reference = menu.list(parent, name , {}, "THESE FUNCTIONS ARE NOT OFFICIALLY SUPPORTED BY WHOWARE, PLEASE GO TO > Players TO USE CUSTOM TRAFFIC")
    self.componentId = componentId

	local numDrawables = PED.GET_NUMBER_OF_PED_DRAWABLE_VARIATIONS(ped, componentId)
    self.drawableId = PED.GET_PED_DRAWABLE_VARIATION(ped, componentId)
    local textureSlider

    menu.slider(self.reference, trans.Type, {}, "", -1, numDrawables - 1, self.drawableId, 1, function (value, prev, click)
		if (click & CLICK_FLAG_AUTO) ~= 0 then return end
        self.drawableId = value
        local numTextures = PED.GET_NUMBER_OF_PED_TEXTURE_VARIATIONS(ped, componentId, value)
        menu.set_max_value(textureSlider, numTextures - 1)
        self.textureId = 0
		menu.set_value(textureSlider, self.textureId)
        onChange(self.drawableId, self.textureId)
    end)

    self.textureId = PED.GET_PED_TEXTURE_VARIATION(ped, componentId)
    local currentNumTextures = PED.GET_NUMBER_OF_PED_TEXTURE_VARIATIONS(ped, componentId, self.drawableId)

	textureSlider =
    menu.slider(self.reference, trans.Texture, {}, "", 0, currentNumTextures - 1, self.textureId, 1, function (value, prev, click)
		if (click & CLICK_FLAG_AUTO) ~= 0 then return end
        self.textureId = value
        onChange(self.drawableId, self.textureId)
    end)

	return self
end

-------------------------------------
-- PROP
-------------------------------------

---@class Prop
local Prop = {reference = 0, componentId = -1, drawableId = 0, textureId = 0}
Prop.__index = Prop

---@param parent integer
---@param name string
---@param ped Ped
---@param componentId integer
---@param onChange fun(drawableId: integer, textureId: integer)
function Prop.new(parent, name, ped, componentId, onChange)
    local self = setmetatable({}, Prop)
    self.reference = menu.list(parent, name, {}, "THESE FUNCTIONS ARE NOT OFFICIALLY SUPPORTED BY WHOWARE, PLEASE GO TO > Players TO USE CUSTOM TRAFFIC")
    self.componentId = componentId

    local numDrawables = PED.GET_NUMBER_OF_PED_PROP_DRAWABLE_VARIATIONS(ped, componentId)
    self.drawableId = PED.GET_PED_PROP_INDEX(ped, componentId)
    local textureSlider

    menu.slider(self.reference, trans.Type, {}, "", -1, numDrawables - 1, self.drawableId, 1, function (drawableId, prev, click)
		if (click & CLICK_FLAG_AUTO) ~= 0 then return end
        self.drawableId = drawableId
        local numTextures = PED.GET_NUMBER_OF_PED_PROP_TEXTURE_VARIATIONS(ped, componentId, drawableId)
        menu.set_max_value(textureSlider, numTextures - 1)
        self.textureId = 0
		menu.set_value(textureSlider, self.textureId)
        onChange(self.drawableId, self.textureId)
    end)

    self.textureId = PED.GET_NUMBER_OF_PED_PROP_TEXTURE_VARIATIONS(ped, componentId, self.drawableId)
    local currentNumTextures = PED.GET_PED_PROP_TEXTURE_INDEX(ped, componentId)

	textureSlider =
    menu.slider(self.reference, trans.Texture, {}, "", 0, currentNumTextures - 1, self.textureId, 1, function (value, prev, click)
		if (click & CLICK_FLAG_AUTO) ~= 0 then return end
        self.textureId = value
        onChange(self.drawableId, self.textureId)
    end)

	return self
end

-------------------------------------
-- WARDROBE
-------------------------------------

---@class Wardrobe
Wardrobe = {
    reference = 0,
    ---@type table<number, Component>
    components = {},
    ---@type table<number, Prop>
    props = {}
}
Wardrobe.__index = Wardrobe


local components <const> = {
	[0]  = translate("Wardrobe", "Head"),
    [1]  = translate("Wardrobe", "Beard / Mask"),
    [2]  = translate("Wardrobe", "Hair"),
    [3]  = translate("Wardrobe", "Gloves / Torso"),
    [4]  = translate("Wardrobe", "Legs"),
    [5]  = translate("Wardrobe", "Hands / Back"),
    [6]  = translate("Wardrobe", "Shoes"),
    [7]	 = translate("Wardrobe", "Teeth / Scarf / Necklace / Bracelets"),
	[8]  = translate("Wardrobe", "Accesories / Tops"),
    [9]  = translate("Wardrobe", "Task / Armour"),
    [10] = translate("Wardrobe", "Decals"),
    [11] = translate("Wardrobe", "Torso 2"),
}

local props <const> =
{
    [0] = translate("Wardrobe", "Hat"),
    [1] = translate("Wardrobe", "Classes"),
    [2] = translate("Wardrobe", "Earwear"),
    [6] = translate("Wardrobe", "Watch"),
    [7] = translate("Wardrobe", "Bracelet"),
}


---@param parent integer
---@param menu_name string
---@param command_names string[]
---@param help_text string
---@param ped Ped
---@return Wardrobe
function Wardrobe.new(parent, menu_name, command_names, help_text, ped)
    local self = setmetatable({}, Wardrobe)
    self.reference = menu.list(parent, menu_name, command_names, help_text, function ()
        self.isOpen = true
    end, function ()
        self.isOpen = false
    end)
    self.components, self.props = {}, {}

    for componentId, name in pairs_by_keys(components, function (a, b) return a < b end) do
        if PED.GET_NUMBER_OF_PED_DRAWABLE_VARIATIONS(ped, componentId) < 1 then
            continue
        end
		self.components[componentId] =
        Component.new(self.reference, name, ped, componentId, function (drawableId, textureId)
            request_control(ped)
            PED.SET_PED_COMPONENT_VARIATION(ped, componentId, drawableId, textureId, 2)
        end)
    end

    for propId, name in pairs_by_keys(props, function (a, b) return a < b end) do
        if PED.GET_NUMBER_OF_PED_PROP_DRAWABLE_VARIATIONS(ped, propId) < 1 then
            continue
        end
		self.props[propId] =
        Prop.new(self.reference, name, ped, propId, function (drawableId, textureId)
            request_control(ped)
            if drawableId == -1 then PED.CLEAR_PED_PROP(ped, propId)
            else PED.SET_PED_PROP_INDEX(ped, propId, drawableId, textureId, true) end
        end)
    end

    return self
end


---@alias Component_t {drawableId: integer, textureId: integer}
---@alias Prop_t Component_t
---@alias Outfit {components: table<integer, Component_t>, props: table<integer, Prop_t>}

---@return Outfit
function Wardrobe:getOutfit()
    assert(self.reference ~= 0, "wardrobe reference does not exist")
    local tbl = {components = {}, props = {}}

    for componentId, component in pairs(self.components) do
        tbl.components[componentId] =
		{drawableId = component.drawableId, textureId = component.textureId}
    end

    for propId, prop in pairs(self.props) do
        tbl.props[propId] =
		{drawableId = prop.drawableId, textureId = prop.textureId}
    end

    return tbl
end

-------------------------------------
-- MEMBER
-------------------------------------

---@diagnostic disable: exp-in-action, unknown-symbol, break-outside, code-after-break, miss-symbol
---@diagnostic disable: undefined-global
---@param ped Ped
local IsPedAnyAnimal  = function(ped)
	local modelHash = ENTITY.GET_ENTITY_MODEL(ped)
	switch int_to_uint(modelHash) do
		case 0xC2D06F53:
		case 0xCE5FF074:
		case 0x573201B8:
		case 0xFCFA9E1E:
		case 0x644AC75E:
		case 0xD86B5A95:
		case 0x4E8F95A2:
		case 0x1250D7BA:
		case 0xB11BAB56:
		case 0x431D501C:
		case 0x6D362854:
		case 0xDFB55C81:
		case 0x349F33E1:
		case 0x9563221D:
		case 0x431FC24C:
		case 0xAD7844BB:
		case 0xAAB71F62:
		case 0x56E29962:
		case 0x18012A9F:
		case 0x6AF51FAF:
		case 0x06A20728:
		case 0xD3939DFD:
		case 0x8BBAB455:
		case 0x2FD800B7:
		case 0x8D8AC8B9:
		case 0x3C831724:
		case 0x06C3F072:
		case 0xA148614D:
		case 0x14EC17EA:
		case 0x471BE4B2:
			return true
	end
	return false
end


---@diagnostic enable: exp-in-action, unknown-symbol, break-outside, code-after-break, miss-symbol
---@class Member
Member =
{
	handle = 0,
	mgr = 0,
	isMgrOpen = false,
	invincible = 0,
	references =
	{
		invincible = 0,
		teleport = 0,
	},
	weaponHash = 0,
	---@type Wardrobe
	wardrobe = nil,
}
Member.__index = Member


---@param ped Ped
---@return Member
function Member.new(ped)
	local self = setmetatable({}, Member)
	self.handle = ped
	TASK.CLEAR_PED_TASKS(ped)
	PED.SET_PED_HIGHLY_PERCEPTIVE(ped, true)
	PED.SET_PED_SEEING_RANGE(ped, 100.0)

	PED.SET_PED_CAN_PLAY_AMBIENT_ANIMS(ped, false)
	PED.SET_PED_CAN_PLAY_AMBIENT_BASE_ANIMS(ped, false)

	PED.SET_PED_CONFIG_FLAG(ped, 208, true) 		-- PCF_DisableExplosionReactions
	PED.SET_PED_CONFIG_FLAG(ped, 400, true)			-- PCF_IgnorePedTypeForIsFriendlyWith

	PED.SET_COMBAT_FLOAT(ped, 12, 1.0)

	PED.SET_RAGDOLL_BLOCKING_FLAGS(ped, 1)			-- RBF_BULLET_IMPACT
	PED.SET_RAGDOLL_BLOCKING_FLAGS(ped, 4)			-- RBF_FIRE

	PED.SET_PED_COMBAT_ATTRIBUTES(ped, 5, true) 	-- CA_ALWAYS_FIGHT
	PED.SET_PED_COMBAT_ATTRIBUTES(ped, 1, true) 	-- CA_USE_VEHICLE
	PED.SET_PED_COMBAT_ATTRIBUTES(ped, 0, false) 	-- CA_USE_COVER
	PED.SET_PED_COMBAT_ATTRIBUTES(ped, 46, true)	-- CA_CAN_FIGHT_ARMED_PEDS_WHEN_NOT_ARMED
	PED.SET_PED_COMBAT_ATTRIBUTES(ped, 58, true)	-- CA_DISABLE_FLEE_FROM_COMBAT

	PED.SET_PED_FLEE_ATTRIBUTES(ped, 512, true) 	-- FA_NEVER_FLEE

	PED.SET_PED_ALLOW_VEHICLES_OVERRIDE(ped, true)
	add_ai_blip_for_ped(ped, true, false, 100.0, 2, -1)
	return self
end


---@diagnostic enable:undefined-global
---@param modelHash? Hash
function Member:createMember(modelHash)
	local pos = get_random_offset_from_entity(players.user_ped(), 2.0, 3.0)
	pos.z = pos.z - 1.0
	local ped = NULL
	modelHash = modelHash or 0
	if modelHash ~= 0 then
		ped = entities.create_ped(28, modelHash, pos, 0.0)
	else
		local userModelHash = ENTITY.GET_ENTITY_MODEL(players.user_ped())
		ped = entities.create_ped(28, userModelHash, pos, 0.0)
	end
	NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(NETWORK.PED_TO_NET(ped), true)
	ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ped, false, true)
	NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(NETWORK.PED_TO_NET(ped), players.user(), true)
	ENTITY.SET_ENTITY_LOAD_COLLISION_FLAG(ped, true, 1)

	if modelHash == 0 then PED.CLONE_PED_TO_TARGET(players.user_ped(), ped) end
	set_entity_face_entity(ped, players.user_ped(), false)
	return Member.new(ped)
end


function Member:removeMgr()
	if self.mgr == 0 then return end
	menu.delete(self.mgr); self.mgr = 0
end


function Member:delete()
	if ENTITY.DOES_ENTITY_EXIST(self.handle)
	and request_control(self.handle, 1000) then
		entities.delete_by_handle(self.handle);
		self.handle = 0
	end
end


local trans =
{
	Invincible = translate("Bg Menu", "Invincible"),
	TpToMe = translate("Bg Menu", "Teleport to Me"),
	Delete = translate("Bg Menu", "Delete"),
	Weapon = translate("Bg Menu", "Weapon"),
	Appearance = translate("Bg Menu", "Appearance"),
	Save = translate("Bg Menu", "Save"),
	BodyguardSaved = translate("Bg Menu", "Bodyguard saved"),
	SaveCanceled = translate("Bg Menu", "Save canceled")
}


---Creates the list to edit some properties of the bodyguard
---@param parent integer
---@param name string
function Member:createMgr(parent, name)
	self.mgr = menu.list(parent, name, {}, "THESE FUNCTIONS ARE NOT OFFICIALLY SUPPORTED BY WHOWARE, PLEASE GO TO > Players TO USE CUSTOM TRAFFIC", function ()
		self.isMgrOpen = true
	end, function ()
		self.isMgrOpen = false
	end)

	self.references = {}
	if not IsPedAnyAnimal(self.handle) then
		WeaponList.new(self.mgr, trans.Weapon, "", "", function (caption, model)
			local hash <const> = util.joaat(model)
			self:giveWeapon(hash); self.weaponHash = hash
		end, true)
	end

	self.references.invincible = menu.toggle(self.mgr, trans.Invincible, {}, "", function (on)
		request_control(self.handle, 1000)
		ENTITY.SET_ENTITY_INVINCIBLE(self.handle, on)
		ENTITY.SET_ENTITY_PROOFS(self.handle, on, on, on, on, on, on, on, on)
	end)

	self.references.teleport = menu.action(self.mgr, trans.TpToMe, {}, "", function ()
		request_control(self.handle, 1000)
		if not PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
			self:tpToLeader()
		else
			local vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false)
			self:tpToVehicle(vehicle)
		end
	end)

	menu.action(self.mgr, trans.Save, {}, "", function()
		local ok, errmsg = self:save()
		if not ok then notification:help(errmsg, HudColour.red) return end
		notification:normal(trans.BodyguardSaved)
	end)

	self.wardrobe = Wardrobe.new(self.mgr, trans.Appearance, {}, "", self.handle)

	menu.action(self.mgr, trans.Delete, {}, "",  function ()
		self:delete() self:removeMgr()
	end)
end


---@param value boolean
function Member:setInvincible(value)
	assert(self.references.invincible ~= 0, "bodyguard manager not found")
	menu.set_value(self.references.invincible, value)
end


---@param weaponHash Hash
function Member:giveWeapon(weaponHash)
	WEAPON.REMOVE_ALL_PED_WEAPONS(self.handle, true)
	WEAPON.GIVE_WEAPON_TO_PED(self.handle, weaponHash, 9999, true, true)
	WEAPON.SET_CURRENT_PED_WEAPON(self.handle, weaponHash, false)
end


---@param vehicle Vehicle
function Member:tpToVehicle(vehicle)
	if not VEHICLE.ARE_ANY_VEHICLE_SEATS_FREE(vehicle) or
	(PED.IS_PED_IN_ANY_VEHICLE(self.handle, false) and PED.GET_VEHICLE_PED_IS_IN(self.handle, false) == vehicle) then
		return
	end
	local seat
	for i = -1, VEHICLE.GET_VEHICLE_MAX_NUMBER_OF_PASSENGERS(vehicle) -1 do
		if VEHICLE.IS_VEHICLE_SEAT_FREE(vehicle, i, false) then seat = i break end
	end
	PED.SET_PED_INTO_VEHICLE(self.handle, vehicle, seat)
end


function Member:tpToLeader()
	local pos = get_random_offset_from_entity(players.user_ped(), 2.0, 3.0)
	pos.z = pos.z - 1.0
	ENTITY.SET_ENTITY_COORDS(self.handle, pos.x, pos.y, pos.z, false, false, false, false)
	set_entity_face_entity(self.handle, players.user_ped(), false)
end


function Member:tp()
	assert(self.references.teleport ~= 0, "bodyguard manager not found")
	menu.trigger_command(self.references.teleport, "")
end


function Member:getInfo()
	local pWeaponHash = memory.alloc_int()
	WEAPON.GET_CURRENT_PED_WEAPON(self.handle, pWeaponHash, true)
	local tbl = {
		WeaponHash = memory.read_int(pWeaponHash),
		Outfit = self.wardrobe:getOutfit(),
		ModelHash = ENTITY.GET_ENTITY_MODEL(self.handle)
	}
	return tbl
end


---@return boolean
---@return string? errmsg
function Member:save()
	local input = ""
	local label = customLabels.EnterFileName
	while true do
		input = get_input_from_screen_keyboard(label, 31, "")
		if input == "" then
			return false, trans.SaveCanceled
		end

		if not input:find '[^%w_%.%-]' then break end
		label = customLabels.InvalidChar
		util.yield(250)
	end
	local path = wiriDir .. "bodyguards\\" .. input .. ".json"
	local file, errmsg = io.open(path, "w")
	if not file then
		return false, errmsg
	end
	file:write(json.stringify(self:getInfo(), nil, 0, false))
	file:close()
	return true
end


---@param obj Outfit
---@return boolean
---@return string? errmsg
function Member:setOutfit(obj)
	local types =
	{
		components = "table",
		props = "table"
	}
	for k, v in pairs(types) do
		local ok, errmsg = type_match(obj[k], v)
		if not ok then return false, "field " .. k .. ' ' .. errmsg end
	end

	for componentId, tbl in pairs(obj.components) do
		if math.tointeger(componentId) and type(tbl.drawableId) == "number" and
		type(tbl.textureId) == "number" and request_control(self.handle) then
        	PED.SET_PED_COMPONENT_VARIATION(self.handle, math.tointeger(componentId), tbl.drawableId, tbl.textureId, 2)
		end
	end

	for propId, tbl in pairs(obj.props) do
		if math.tointeger(propId) and type(tbl.drawableId) == "number" and
		type(tbl.textureId) == "number" and request_control(self.handle) then
			PED.SET_PED_PROP_INDEX(self.handle, math.tointeger(propId), tbl.drawableId, tbl.textureId, true)
		end
	end
	return true
end





-------------------------------------
-- NANO DRONE
-------------------------------------

function CanSpawnNanoDrone()
	return BitTest(read_global.int(1962996), 23)
end

function CanUseDrone()
	if not is_player_active(players.user(), true, true) then
		return false
	end
	if util.is_session_transition_active() then
		return false
	end
	if players.is_in_interior(players.user()) then
		return false
	end
	if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
		return false
	end
	if PED.IS_PED_IN_ANY_TRAIN(players.user_ped()) or
	PLAYER.IS_PLAYER_RIDING_TRAIN(players.user()) then
		return false
	end
	if PED.IS_PED_FALLING(players.user_ped()) then
		return false
	end
	if ENTITY.GET_ENTITY_SUBMERGED_LEVEL(players.user_ped()) > 0.3 then
		return false
	end
	if ENTITY.IS_ENTITY_IN_AIR(players.user_ped()) then
		return false
	end
	if PED.IS_PED_ON_VEHICLE(players.user_ped()) then
		return false
	end
	return true
end






local helpText = translate("WiriScript", "Join the discord for updates / info / help / suggestions.")
local menuName = translate("WiriScript", "Join %s")
menu.hyperlink(menu.my_root(), menuName:format("Whoware Discord"), "https://discord.gg/S3GtdAq", helpText:format("komt"))



players.on_join(NetworkPlayerOpts)
players.dispatch_on_join()
util.log("On join dispatched")


-------------------------------------
-- MEMORY SCANS / FOREIGN FUNCTS
-------------------------------------

memory_scan("GNGP", "48 83 EC ? 33 C0 38 05 ? ? ? ? 74 ? 83 F9", function (address)
	GetNetGamePlayer_addr = address
end)

--[[memoryScan("UnregisterNetworkObject", "48 89 70 ? 48 89 78 ? 41 54 41 56 41 57 48 83 ec ? 80 7a ? ? 45 8a f9", function (address)
	UnregisterNetworkObject_addr = address - 0xB
end)]]

memory_scan("NOM", "48 8B 0D ? ? ? ? 45 33 C0 E8 ? ? ? ? 33 FF 4C 8B F0", function (address)
	CNetworkObjectMgr = memory.rip(address + 3)
end)

--[[memoryScan("ChangeNetObjOwner", "48 8B C4 48 89 58 08 48 89 68 10 48 89 70 18 48 89 78 20 41 54 41 56 41 57 48 81 EC ? ? ? ? 44 8A 62 4B", function (address)
	ChangeNetObjOwner_addr = address
end)]]

---@param player integer
---@return integer
function GetNetGamePlayer(player)
	return util.call_foreign_function(GetNetGamePlayer_addr, player)
end

---@param addr integer
---@return string
function read_net_address(addr)
	local fields = {}
	for i = 3, 0, -1 do table.insert(fields, memory.read_ubyte(addr + i)) end
	return table.concat(fields, ".")
end

---@param player integer
---@return string? IP
function get_external_ip(player)
	local netPlayer = GetNetGamePlayer(player)
	if netPlayer == NULL then
		return nil
	end
	local CPlayerInfo = memory.read_long(netPlayer + 0xA0)
	if CPlayerInfo == NULL then
		return nil
	end
	local netPlayerData = CPlayerInfo + 0x20
	local netAddress = read_net_address(netPlayerData + 0x4C)
	return netAddress
end

--[[function UnregisterNetworkObject(object, reason, force1, force2)
	local netObj = get_net_obj(object)
	if netObj == NULL then
		return false
	end
	local net_object_mgr = memory.read_long(CNetworkObjectMgr)
	if net_object_mgr == NULL then
		return false
	end
	util.call_foreign_function(UnregisterNetworkObject_addr, net_object_mgr, netObj, reason, force1, force2)
	return true
end]]

--[[function ChangeNetObjOwner(object, player)
	if NETWORK.NETWORK_IS_SESSION_STARTED() then
		local net_object_mgr = memory.read_long(CNetworkObjectMgr)
		if net_object_mgr == NULL then
			return false
		end
		if not ENTITY.DOES_ENTITY_EXIST(object) then
			return false
		end
		local netObj = get_net_obj(object)
		if netObj == NULL then
			return false
		end
		local net_game_player = GetNetGamePlayer(player)
		if net_game_player == NULL then
			return false
		end
		util.call_foreign_function(ChangeNetObjOwner_addr, net_object_mgr, netObj, net_game_player, 0)
		return true
	else
		NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(object)
		return true
	end
end]]

-------------------------------------
--ON STOP
-------------------------------------

-- This function (along with some others on_stop functions) allow us to do 
-- some cleanup when the script stops
util.on_stop(function()

	if GuidedMissile.exists() then
		GuidedMissile.destroy()
	end

	if g_ShowingIntro then
		openingCredits:SET_AS_NO_LONGER_NEEDED()
	end

	set_streamed_texture_dict_as_no_longer_needed("WiriTextures")
	Ini.save(configFile, Config)
end)

util.log("Script loaded in %d millis", util.current_time_millis() - scriptStartTime)


while true do
	GuidedMissile.mainLoop()
	util.yield_once()
end
