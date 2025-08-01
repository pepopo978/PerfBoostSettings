-- No PerfBoost v2, no need for settings
local has_perf_boost = pcall(GetCVar, "PB_Enabled")
if not has_perf_boost then
	DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00Pepo PerfBoost|cffffaaaa not present hiding settings.")
	return
end

PerfBoost = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceDebug-2.0", "AceModuleCore-2.0", "AceConsole-2.0", "AceDB-2.0", "AceHook-2.1")
PerfBoost:RegisterDB("PerfBoostSettingsDB")
PerfBoost:RegisterDefaults("profile", {
	per_character_settings = false,
})
PerfBoost.frame = CreateFrame("Frame", "PerfBoost", UIParent)

-- used when turning on per character settings
function PerfBoost:SavePerCharacterSettings()
	for settingKey, settingData in pairs(PerfBoost.cmdtable.args) do
		if string.find(settingKey, "PB_") == 1 then
			settingData.set(settingData.get()) -- trigger the set function for each setting with the current value
		end
	end
end

function PerfBoost:ApplySavedSettings()
	for settingKey, settingData in pairs(PerfBoost.cmdtable.args) do
		-- only apply settings that are prefixed with PB_
		if string.find(settingKey, "PB_") == 1 then
			if PerfBoost.db.profile[settingKey] ~= nil then
				settingData.set(PerfBoost.db.profile[settingKey])
			end
		end
	end
end

function PerfBoost:OnEnable()
	-- if per character settings are enabled, apply them
	if PerfBoost.db.profile.per_character_settings then
		PerfBoost:ApplySavedSettings()
	end
end

PerfBoost.cmdtable = {
	type = "group",
	handler = PerfBoost,
	args = {
		per_character_settings = {
			type = "toggle",
			name = "Enable Per Character Settings",
			desc = "Whether to use per character settings for all of the PB_ settings.  This will cause settings saved in your character's PerfBoostSettings.lua to override any global settings in Config.wtf.",
			order = 1,
			get = function()
				return PerfBoost.db.profile.per_character_settings
			end,
			set = function(v)
				if v ~= PerfBoost.db.profile.per_character_settings then
					PerfBoost.db.profile.per_character_settings = v
					if v == true then
						PerfBoost:SavePerCharacterSettings()
					end
				end
			end,
		},
		PB_Enabled = {
			type = "toggle",
			name = "Enable Performance Boost",
			desc = "Enable/disable all performance boost features",
			order = 5,
			get = function()
				return GetCVar("PB_Enabled") == "1"
			end,
			set = function(v)
				PerfBoost.db.profile.PB_Enabled = v
				if v == true then
					SetCVar("PB_Enabled", "1")
				else
					SetCVar("PB_Enabled", "0")
				end
			end,
		},

		spacera = {
			type = "header",
			name = " ",
			order = 10,
		},

		PB_AlwaysRenderRaidMarks = {
			type = "toggle",
			name = "Always Render Raid Marks",
			desc = "Whether to always render raid marks",
			order = 15,
			get = function()
				return GetCVar("PB_AlwaysRenderRaidMarks") == "1"
			end,
			set = function(v)
				PerfBoost.db.profile.PB_AlwaysRenderRaidMarks = v
				if v == true then
					SetCVar("PB_AlwaysRenderRaidMarks", "1")
				else
					SetCVar("PB_AlwaysRenderRaidMarks", "0")
				end
			end,
		},

		spacerb = {
			type = "header",
			name = " ",
			order = 20,
		},

		PB_PlayerRenderDistInCombat = {
			type = "range",
			name = "In Combat Player Render Distance",
			desc = "Max distance to render players when in combat",
			order = 35,
			min = -1,
			max = 100,
			step = 1,
			get = function()
				local val = GetCVar("PB_PlayerRenderDistInCombat")
				return val and tonumber(val) or 0
			end,
			set = function(v)
				PerfBoost.db.profile.PB_PlayerRenderDistInCombat = v
				SetCVar("PB_PlayerRenderDistInCombat", tostring(v))
			end,
		},
		PB_PlayerRenderDistInCities = {
			type = "range",
			name = "In Cities Player Render Distance",
			desc = "Max distance to render players when in cities",
			order = 37,
			min = -1,
			max = 100,
			step = 1,
			get = function()
				local val = GetCVar("PB_PlayerRenderDistInCities")
				return val and tonumber(val) or 0
			end,
			set = function(v)
				PerfBoost.db.profile.PB_PlayerRenderDistInCities = v
				SetCVar("PB_PlayerRenderDistInCities", tostring(v))
			end,
		},
		PB_PlayerRenderDist = {
			type = "range",
			name = "Default Player Render Distance",
			desc = "Max distance to render players when not in combat",
			order = 30,
			min = -1,
			max = 100,
			step = 1,
			get = function()
				local val = GetCVar("PB_PlayerRenderDist")
				return val and tonumber(val) or 0
			end,
			set = function(v)
				PerfBoost.db.profile.PB_PlayerRenderDist = v
				SetCVar("PB_PlayerRenderDist", tostring(v))
			end,
		},

		spacerc = {
			type = "header",
			name = " ",
			order = 50,
		},

		PB_TrashUnitRenderDistInCombat = {
			type = "range",
			name = "In Combat Trash Unit (lvl < 63) Render Distance",
			desc = "Max distance to render trash units when in combat",
			order = 70,
			min = -1,
			max = 100,
			step = 1,
			get = function()
				local val = GetCVar("PB_TrashUnitRenderDistInCombat")
				return val and tonumber(val) or 0
			end,
			set = function(v)
				PerfBoost.db.profile.PB_TrashUnitRenderDistInCombat = v
				SetCVar("PB_TrashUnitRenderDistInCombat", tostring(v))
			end,
		},
		PB_TrashUnitRenderDist = {
			type = "range",
			name = "Default Trash Unit (lvl < 63) Render Distance",
			desc = "Max distance to render trash units when not in combat",
			order = 60,
			min = -1,
			max = 100,
			step = 1,
			get = function()
				local val = GetCVar("PB_TrashUnitRenderDist")
				return val and tonumber(val) or 0
			end,
			set = function(v)
				PerfBoost.db.profile.PB_TrashUnitRenderDist = v
				SetCVar("PB_TrashUnitRenderDist", tostring(v))
			end,
		},

		spacerd = {
			type = "header",
			name = " ",
			order = 75,
		},

		PB_PetRenderDist = {
			type = "range",
			name = "Default Pet Render Distance",
			desc = "Max distance to render pets when not in combat",
			order = 76,
			min = -1,
			max = 100,
			step = 1,
			get = function()
				local val = GetCVar("PB_PetRenderDist")
				return val and tonumber(val) or 0
			end,
			set = function(v)
				PerfBoost.db.profile.PB_PetRenderDist = v
				SetCVar("PB_PetRenderDist", tostring(v))
			end,
		},
		PB_PetRenderDistInCombat = {
			type = "range",
			name = "In Combat Pet Render Distance",
			desc = "Max distance to render pets when in combat",
			order = 77,
			min = -1,
			max = 100,
			step = 1,
			get = function()
				local val = GetCVar("PB_PetRenderDistInCombat")
				return val and tonumber(val) or 0
			end,
			set = function(v)
				PerfBoost.db.profile.PB_PetRenderDistInCombat = v
				SetCVar("PB_PetRenderDistInCombat", tostring(v))
			end,
		},

		spacere = {
			type = "header",
			name = " ",
			order = 78,
		},

		PB_CorpseRenderDist = {
			type = "range",
			name = "Corpse Render Distance",
			desc = "Max distance to render corpses",
			order = 80,
			min = -1,
			max = 100,
			step = 1,
			get = function()
				local val = GetCVar("PB_CorpseRenderDist")
				return val and tonumber(val) or 0
			end,
			set = function(v)
				PerfBoost.db.profile.PB_CorpseRenderDist = v
				SetCVar("PB_CorpseRenderDist", tostring(v))
			end,
		},
	},
}

local deuce = PerfBoost:NewModule("PerfBoost Options Menu")
deuce.hasFuBar = IsAddOnLoaded("FuBar") and FuBar
deuce.consoleCmd = not deuce.hasFuBar

PerfBoostOptions = AceLibrary("AceAddon-2.0"):new("AceDB-2.0", "FuBarPlugin-2.0")
PerfBoostOptions.name = "FuBar - PerfBoost"
PerfBoostOptions.hasIcon = "Interface\\Icons\\Spell_Nature_Strength"
PerfBoostOptions.defaultMinimapPosition = 180
PerfBoostOptions.independentProfile = true
PerfBoostOptions.hideWithoutStandby = false

PerfBoostOptions.OnMenuRequest = PerfBoost.cmdtable
local args = AceLibrary("FuBarPlugin-2.0"):GetAceOptionsDataTable(PerfBoostOptions)
for k, v in pairs(args) do
	if PerfBoostOptions.OnMenuRequest.args[k] == nil then
		PerfBoostOptions.OnMenuRequest.args[k] = v
	end
end

SLASH_PBENABLE1, SLASH_PBENABLE2 = '/pbenable', '/perfboostenable'
function SlashCmdList.PBENABLE(msg, editbox)
	local v = not GetCVar("PB_Enabled") == "1"
	PerfBoost.db.profile.PB_Enabled = v
	if v == true then
		SetCVar("PB_Enabled", "1")
	else
		SetCVar("PB_Enabled", "0")
	end
end
