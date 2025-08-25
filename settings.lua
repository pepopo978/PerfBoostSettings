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

BINDING_HEADER_PERFBOOST = "PerfBoost";
BINDING_NAME_PERFBOOSTENABLE = "Toggles whether perfboot is enabled/disabled";
BINDING_NAME_PBHIDEALLPLAYERS = "Toggle hide all players";

-- used when turning on per character settings
function PerfBoost:SavePerCharacterSettings()
	local function saveNestedSettings(args)
		for settingKey, settingData in pairs(args) do
			if string.find(settingKey, "PB_") == 1 and settingData.get and settingData.set then
				settingData.set(settingData.get()) -- trigger the set function for each setting with the current value
			elseif settingData.args then
				saveNestedSettings(settingData.args)
			end
		end
	end
	saveNestedSettings(PerfBoost.cmdtable.args)
end

function PerfBoost:ApplySavedSettings()
	local function applyNestedSettings(args)
		for settingKey, settingData in pairs(args) do
			if string.find(settingKey, "PB_") == 1 and settingData.set then
				if PerfBoost.db.profile[settingKey] ~= nil then
					settingData.set(PerfBoost.db.profile[settingKey])
				end
			elseif settingData.args then
				applyNestedSettings(settingData.args)
			end
		end
	end
	applyNestedSettings(PerfBoost.cmdtable.args)
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

		rendering = {
			type = "group",
			name = "Rendering Settings",
			desc = "Configure all rendering and visibility options",
			order = 15,
			args = {
				PB_AlwaysRenderRaidMarks = {
					type = "toggle",
					name = "Always Render Raid Marks",
					desc = "Whether to always render raid marks",
					order = 1,
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

				PB_AlwaysRenderPVP = {
					type = "toggle",
					name = "Always Render PVP Players",
					desc = "Whether to always render players flagged for PVP",
					order = 2,
					get = function()
						return GetCVar("PB_AlwaysRenderPVP") == "1"
					end,
					set = function(v)
						PerfBoost.db.profile.PB_AlwaysRenderPVP = v
						if v == true then
							SetCVar("PB_AlwaysRenderPVP", "1")
						else
							SetCVar("PB_AlwaysRenderPVP", "0")
						end
					end,
				},

				PB_AlwaysRenderPlayersWithAggro = {
					type = "toggle",
					name = "Always Render Players With Aggro",
					desc = "Whether to always render players who have aggro from enemies",
					order = 3,
					get = function()
						return GetCVar("PB_AlwaysRenderPlayersWithAggro") == "1"
					end,
					set = function(v)
						PerfBoost.db.profile.PB_AlwaysRenderPlayersWithAggro = v
						if v == true then
							SetCVar("PB_AlwaysRenderPlayersWithAggro", "1")
						else
							SetCVar("PB_AlwaysRenderPlayersWithAggro", "0")
						end
					end,
				},

				PB_AlwaysRenderPlayers = {
					type = "text",
					name = "Always Render Players (ENTER to save)",
					desc = "Comma separated list of playernames to always render regardless of other settings",
					usage = "Name1,Name2,etc",
					order = 4,
					get = function()
						return GetCVar("PB_AlwaysRenderPlayers") or ""
					end,
					set = function(v)
						PerfBoost.db.profile.PB_AlwaysRenderPlayers = v
						SetCVar("PB_AlwaysRenderPlayers", v)
					end,
				},

				PB_NeverRenderPlayers = {
					type = "text",
					name = "Never Render Players (ENTER to save)",
					desc = "Comma separated list of playernames to never render regardless of other settings",
					usage = "Name1,Name2,etc",
					order = 5,
					get = function()
						return GetCVar("PB_NeverRenderPlayers") or ""
					end,
					set = function(v)
						PerfBoost.db.profile.PB_NeverRenderPlayers = v
						SetCVar("PB_NeverRenderPlayers", v)
					end,
				},

				PB_HideAllPlayers = {
					type = "toggle",
					name = "Hide All Players",
					desc = "Hide all players regardless of other render settings",
					order = 6,
					get = function()
						return GetCVar("PB_HideAllPlayers") == "1"
					end,
					set = function(v)
						PerfBoost.db.profile.PB_HideAllPlayers = v
						if v == true then
							SetCVar("PB_HideAllPlayers", "1")
						else
							SetCVar("PB_HideAllPlayers", "0")
						end
					end,
				},

				spacer_player = {
					type = "header",
					name = "Player Distances",
					order = 10,
				},

				PB_PlayerRenderDist = {
					type = "range",
					name = "Default Player Render Distance",
					desc = "Max distance to render players when not in combat",
					order = 11,
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
				PB_PlayerRenderDistInCombat = {
					type = "range",
					name = "In Combat Player Render Distance",
					desc = "Max distance to render players when in combat",
					order = 12,
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
					order = 13,
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

				spacer_trash = {
					type = "header",
					name = "Trash Units",
					order = 20,
				},

				PB_TrashUnitRenderDist = {
					type = "range",
					name = "Default Trash Unit (lvl < 63) Render Distance",
					desc = "Max distance to render trash units when not in combat",
					order = 21,
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
				PB_TrashUnitRenderDistInCombat = {
					type = "range",
					name = "In Combat Trash Unit (lvl < 63) Render Distance",
					desc = "Max distance to render trash units when in combat",
					order = 22,
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

				spacer_pets = {
					type = "header",
					name = "Pets & Summons",
					order = 30,
				},

				PB_PetRenderDist = {
					type = "range",
					name = "Default Pet Render Distance",
					desc = "Max distance to render pets when not in combat.  Your own pet is always shown.",
					order = 31,
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
					desc = "Max distance to render pets when in combat. Your own pet is always shown.",
					order = 32,
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

				PB_SummonRenderDist = {
					type = "range",
					name = "Default Totem/Guardian Render Distance",
					desc = "Max distance to render unnamed summons when not in combat. Your own totems and guardians are always shown.",
					order = 33,
					min = -1,
					max = 100,
					step = 1,
					get = function()
						local val = GetCVar("PB_SummonRenderDist")
						return val and tonumber(val) or 0
					end,
					set = function(v)
						PerfBoost.db.profile.PB_SummonRenderDist = v
						SetCVar("PB_SummonRenderDist", tostring(v))
					end,
				},
				PB_SummonRenderDistInCombat = {
					type = "range",
					name = "In Combat Totem/Guardian Render Distance",
					desc = "Max distance to render unnamed summons when in combat. Your own totems and guardians are always shown.",
					order = 34,
					min = -1,
					max = 100,
					step = 1,
					get = function()
						local val = GetCVar("PB_SummonRenderDistInCombat")
						return val and tonumber(val) or 0
					end,
					set = function(v)
						PerfBoost.db.profile.PB_SummonRenderDistInCombat = v
						SetCVar("PB_SummonRenderDistInCombat", tostring(v))
					end,
				},

				spacer_corpse = {
					type = "header",
					name = "Other Objects",
					order = 40,
				},

				PB_CorpseRenderDist = {
					type = "range",
					name = "Corpse Render Distance",
					desc = "Max distance to render corpses",
					order = 41,
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
		},

		spells = {
			type = "group",
			name = "Spell Visual Settings",
			desc = "Configure spell visual effects and filtering",
			order = 20,
			args = {
				PB_ShowPlayerSpellVisuals = {
					type = "toggle",
					name = "Show Other Player Spell Visuals",
					desc = "Whether to show spell visual effects from other players.  This includes spell casts, ranged weapon projectiles, wanding, not sure what else.",
					order = 1,
					get = function()
						return GetCVar("PB_ShowPlayerSpellVisuals") == "1"
					end,
					set = function(v)
						PerfBoost.db.profile.PB_ShowPlayerSpellVisuals = v
						if v == true then
							SetCVar("PB_ShowPlayerSpellVisuals", "1")
						else
							SetCVar("PB_ShowPlayerSpellVisuals", "0")
						end
					end,
				},

				PB_ShowPlayerGroundEffects = {
					type = "toggle",
					name = "Show Other Player Ground Effects",
					desc = "Whether to show ground effects from players",
					order = 2,
					get = function()
						return GetCVar("PB_ShowPlayerGroundEffects") == "1"
					end,
					set = function(v)
						PerfBoost.db.profile.PB_ShowPlayerGroundEffects = v
						if v == true then
							SetCVar("PB_ShowPlayerGroundEffects", "1")
						else
							SetCVar("PB_ShowPlayerGroundEffects", "0")
						end
					end,
				},

				PB_ShowPlayerAuraVisuals = {
					type = "toggle",
					name = "Show Other Player Aura Visuals",
					desc = "Whether to show aura visual effects on players",
					order = 3,
					get = function()
						return GetCVar("PB_ShowPlayerAuraVisuals") == "1"
					end,
					set = function(v)
						PerfBoost.db.profile.PB_ShowPlayerAuraVisuals = v
						if v == true then
							SetCVar("PB_ShowPlayerAuraVisuals", "1")
						else
							SetCVar("PB_ShowPlayerAuraVisuals", "0")
						end
					end,
				},

				PB_ShowUnitAuraVisuals = {
					type = "toggle",
					name = "Show Unit Aura Visuals",
					desc = "Whether to show aura visual effects on units (NPCs, mobs)",
					order = 4,
					get = function()
						return GetCVar("PB_ShowUnitAuraVisuals") == "1"
					end,
					set = function(v)
						PerfBoost.db.profile.PB_ShowUnitAuraVisuals = v
						if v == true then
							SetCVar("PB_ShowUnitAuraVisuals", "1")
						else
							SetCVar("PB_ShowUnitAuraVisuals", "0")
						end
					end,
				},

				PB_HideSpellsForHiddenPlayers = {
					type = "toggle",
					name = "Hide Spells for Hidden Players",
					desc = "Hide spell visuals from players that are hidden due to render distance or other settings",
					order = 5,
					get = function()
						return GetCVar("PB_HideSpellsForHiddenPlayers") == "1"
					end,
					set = function(v)
						PerfBoost.db.profile.PB_HideSpellsForHiddenPlayers = v
						if v == true then
							SetCVar("PB_HideSpellsForHiddenPlayers", "1")
						else
							SetCVar("PB_HideSpellsForHiddenPlayers", "0")
						end
					end,
				},

				spacer_spells = {
					type = "header",
					order = 10,
				},

				PB_HiddenSpellIds = {
					type = "text",
					name = "Always Hidden Spell IDs (ENTER to save)",
					desc = "Comma separated list of spell IDs to hide visuals for",
					usage = "1234,5678,etc",
					order = 11,
					get = function()
						return GetCVar("PB_HiddenSpellIds") or ""
					end,
					set = function(v)
						PerfBoost.db.profile.PB_HiddenSpellIds = v
						SetCVar("PB_HiddenSpellIds", v)
					end,
				},

				PB_AlwaysShownSpellIds = {
					type = "text",
					name = "Always Shown Spell IDs (ENTER to save)",
					desc = "Comma separated list of spell IDs to always show visuals for, overriding other settings",
					usage = "1234,5678,etc",
					order = 12,
					get = function()
						return GetCVar("PB_AlwaysShownSpellIds") or ""
					end,
					set = function(v)
						PerfBoost.db.profile.PB_AlwaysShownSpellIds = v
						SetCVar("PB_AlwaysShownSpellIds", v)
					end,
				},

				PB_ApplyHiddenSpellIdsToMe = {
					type = "toggle",
					name = "Apply Hidden Spell IDs to Me",
					desc = "Whether to apply the hidden spell IDs list to your own character's spells",
					order = 13,
					get = function()
						return GetCVar("PB_ApplyHiddenSpellIdsToMe") == "1"
					end,
					set = function(v)
						PerfBoost.db.profile.PB_ApplyHiddenSpellIdsToMe = v
						if v == true then
							SetCVar("PB_ApplyHiddenSpellIdsToMe", "1")
						else
							SetCVar("PB_ApplyHiddenSpellIdsToMe", "0")
						end
					end,
				},
			},
		},

		spacer_main = {
			type = "header",
			name = " ",
			order = 25,
		},

		PB_FilterGuidEvents = {
			type = "toggle",
			name = "Filter GUID Events",
			desc = "Filters out generally unnecessary superwow GUID-based events to reduce event spam and improve performance. Blocks events like UNIT_AURA, UNIT_HEALTH, UNIT_MANA when triggered with a guid instead of a string like 'player' or 'raid1', while preserving commonly used guid events like UNIT_COMBAT and UNIT_MODEL_CHANGED.",
			order = 30,
			get = function()
				return GetCVar("PB_FilterGuidEvents") == "1"
			end,
			set = function(v)
				PerfBoost.db.profile.PB_FilterGuidEvents = v
				if v == true then
					SetCVar("PB_FilterGuidEvents", "1")
				else
					SetCVar("PB_FilterGuidEvents", "0")
				end
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
	local v = not (GetCVar("PB_Enabled") == "1")
	PerfBoost.db.profile.PB_Enabled = v
	if v == true then
		SetCVar("PB_Enabled", "1")
		DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00PerfBoost:|r enabled")
	else
		SetCVar("PB_Enabled", "0")
		DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00PerfBoost:|r disabled")
	end
end

SLASH_PBALWAYSRENDER1, SLASH_PBALWAYSRENDER2 = '/pbalwaysrender', '/pbar'
function SlashCmdList.PBALWAYSRENDER(msg, editbox)
	local target = UnitName("target")
	if not target then
		DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00PerfBoost:|r No target selected")
		return
	end
	
	local current = GetCVar("PB_AlwaysRenderPlayers") or ""
	local names = {}
	if current ~= "" then
		for name in string.gfind(current, "([^,]+)") do
			name = string.gsub(name, "^%s*(.-)%s*$", "%1")
			if name ~= "" then
				names[name] = true
			end
		end
	end
	
	if names[target] then
		DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00PerfBoost:|r " .. target .. " is already in always render list")
		return
	end
	
	names[target] = true
	local newList = ""
	for name in pairs(names) do
		if newList == "" then
			newList = name
		else
			newList = newList .. "," .. name
		end
	end
	
	PerfBoost.db.profile.PB_AlwaysRenderPlayers = newList
	SetCVar("PB_AlwaysRenderPlayers", newList)
	DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00PerfBoost:|r Added " .. target .. " to always render list")
end

SLASH_PBNEVERRENDER1, SLASH_PBNEVERRENDER2 = '/pbneverrender', '/pbnr'
function SlashCmdList.PBNEVERRENDER(msg, editbox)
	local target = UnitName("target")
	if not target then
		DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00PerfBoost:|r No target selected")
		return
	end
	
	local current = GetCVar("PB_NeverRenderPlayers") or ""
	local names = {}
	if current ~= "" then
		for name in string.gfind(current, "([^,]+)") do
			name = string.gsub(name, "^%s*(.-)%s*$", "%1")
			if name ~= "" then
				names[name] = true
			end
		end
	end
	
	if names[target] then
		DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00PerfBoost:|r " .. target .. " is already in never render list")
		return
	end
	
	names[target] = true
	local newList = ""
	for name in pairs(names) do
		if newList == "" then
			newList = name
		else
			newList = newList .. "," .. name
		end
	end
	
	PerfBoost.db.profile.PB_NeverRenderPlayers = newList
	SetCVar("PB_NeverRenderPlayers", newList)
	DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00PerfBoost:|r Added " .. target .. " to never render list")
end

SLASH_PBALWAYSRENDERREMOVE1, SLASH_PBALWAYSRENDERREMOVE2 = '/pbalwaysrenderremove', '/pbarr'
function SlashCmdList.PBALWAYSRENDERREMOVE(msg, editbox)
	local target = UnitName("target")
	if not target then
		DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00PerfBoost:|r No target selected")
		return
	end
	
	local current = GetCVar("PB_AlwaysRenderPlayers") or ""
	local names = {}
	if current ~= "" then
		for name in string.gfind(current, "([^,]+)") do
			name = string.gsub(name, "^%s*(.-)%s*$", "%1")
			if name ~= "" and name ~= target then
				names[name] = true
			end
		end
	end
	
	local newList = ""
	for name in pairs(names) do
		if newList == "" then
			newList = name
		else
			newList = newList .. "," .. name
		end
	end
	
	PerfBoost.db.profile.PB_AlwaysRenderPlayers = newList
	SetCVar("PB_AlwaysRenderPlayers", newList)
	DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00PerfBoost:|r Removed " .. target .. " from always render list")
end

SLASH_PBNEVERRENDERREMOVE1, SLASH_PBNEVERRENDERREMOVE2 = '/pbneverrenderremove', '/pbnrr'
function SlashCmdList.PBNEVERRENDERREMOVE(msg, editbox)
	local target = UnitName("target")
	if not target then
		DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00PerfBoost:|r No target selected")
		return
	end
	
	local current = GetCVar("PB_NeverRenderPlayers") or ""
	local names = {}
	if current ~= "" then
		for name in string.gfind(current, "([^,]+)") do
			name = string.gsub(name, "^%s*(.-)%s*$", "%1")
			if name ~= "" and name ~= target then
				names[name] = true
			end
		end
	end
	
	local newList = ""
	for name in pairs(names) do
		if newList == "" then
			newList = name
		else
			newList = newList .. "," .. name
		end
	end
	
	PerfBoost.db.profile.PB_NeverRenderPlayers = newList
	SetCVar("PB_NeverRenderPlayers", newList)
	DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00PerfBoost:|r Removed " .. target .. " from never render list")
end

SLASH_PBALWAYSRENDERCLEAR1, SLASH_PBALWAYSRENDERCLEAR2 = '/pbalwaysrenderclear', '/pbarc'
function SlashCmdList.PBALWAYSRENDERCLEAR(msg, editbox)
	PerfBoost.db.profile.PB_AlwaysRenderPlayers = ""
	SetCVar("PB_AlwaysRenderPlayers", "")
	DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00PerfBoost:|r Cleared always render list")
end

SLASH_PBNEVERRENDERCLEAR1, SLASH_PBNEVERRENDERCLEAR2 = '/pbneverrenderclear', '/pbnrc'
function SlashCmdList.PBNEVERRENDERCLEAR(msg, editbox)
	PerfBoost.db.profile.PB_NeverRenderPlayers = ""
	SetCVar("PB_NeverRenderPlayers", "")
	DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00PerfBoost:|r Cleared never render list")
end

SLASH_PBHIDEALLPLAYERS1, SLASH_PBHIDEALLPLAYERS2 = '/pbhideallplayers', '/pbhap'
function SlashCmdList.PBHIDEALLPLAYERS(msg, editbox)
	local v = not (GetCVar("PB_HideAllPlayers") == "1")
	PerfBoost.db.profile.PB_HideAllPlayers = v
	if v == true then
		SetCVar("PB_HideAllPlayers", "1")
		DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00PerfBoost:|r Hide all players enabled")
	else
		SetCVar("PB_HideAllPlayers", "0")
		DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00PerfBoost:|r Hide all players disabled")
	end
end
