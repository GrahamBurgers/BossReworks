dofile("data/scripts/lib/mod_settings.lua")

function mod_setting_bool_custom( mod_id, gui, in_main_menu, im_id, setting )
	local value = ModSettingGetNextValue( mod_setting_get_id(mod_id,setting) )
	local text = setting.ui_name .. " - " .. GameTextGet( value and "$option_on" or "$option_off" )

	if GuiButton( gui, im_id, mod_setting_group_x_offset, 0, text ) then
		ModSettingSetNextValue( mod_setting_get_id(mod_id,setting), not value, false )
	end

	mod_setting_tooltip( mod_id, gui, in_main_menu, setting )
end

function mod_setting_change_callback( mod_id, gui, in_main_menu, setting, old_value, new_value  )
end

local defaults = {
	{"boss_armor_intensity", "Default"},
	{"mode", "Normal"},
	{"souls", true},
	{"shuffle", false},
	{"timer", false},
	{"rework_limbs", true},
	{"rework_dragon", true},
	{"rework_alchemist", true},
	{"rework_gate", true},
	{"rework_fish", true},
	{"rework_ghost", true},
	{"rework_robot", true},
	{"rework_wizard", true},
	{"rework_pit", true},
	{"rework_tiny", true},
	{"rework_meat", true},
	{"rework_deer", true},
}
for i = 1, #defaults do
	local id = "boss_reworks." .. defaults[i][1]
	local id_fake = "boss_reworks.fake_" .. defaults[i][1]
	if ModSettingGet(id) == nil then
		ModSettingSet(id, defaults[i][2])
		ModSettingSet(id_fake, 1)
	end
end

local function copypaste(setting, gui, options, im_id, offset_x, name, desc)
	local id = "boss_reworks." .. setting
	local id_fake = "boss_reworks.fake_" .. setting
	GuiLayoutBeginHorizontal(gui, 0, 0, false, 0, 0)
	local current = ModSettingGet(id_fake)
	if current == nil then
		ModSettingSet(id_fake, 1)
		ModSettingSet(id, options[1])
		current = 1
	end

	GuiColorSetForNextWidget(gui, 0.8, 0.8, 0.8, 0.6)
	GuiText(gui, offset_x, 0, name)
	GuiTooltip(gui, desc, "")

	local lmb, rmb = GuiButton(gui, im_id, 0, 0, tostring(options[current]))
	if lmb then
		local next = (current % #options) + 1
		ModSettingSet(id_fake, next)
		ModSettingSet(id, options[next])
	end
	if rmb then
		local next = 1
		ModSettingSet(id_fake, next)
		ModSettingSet(id, options[next])
	end
	GuiLayoutEnd(gui)
end

local mod_id = "boss_reworks" -- This should match the name of your mod's folder.
mod_settings_version = 1
mod_settings = 
{
	{
		id = "boss_armor_intensity",
		ui_name = "",
		ui_description = "",
		value_default = true,
		not_setting = true,
		scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
		ui_fn = function(mod_id, gui, in_main_menu, im_id, setting)
			copypaste("boss_armor_intensity", gui, {"Default (60%)", "Weak (30%)", "Strong (90%)", "Off (0%)"}, im_id, 0,
			"Boss armor intensity: ",
			"Boss armor makes bosses more fair by making it less effective to deal massive amounts of damage at once.\nThis creates a more fair fight and ensures the boss will survive for long enough to do a few attacks.\nYou can turn this off if you want but it will make me sad.\nAll reworked bosses have boss armor by default, except for Sauvojen Tuntija.\nRequires a restart to change. Maybe don't change this mid-fight."
			)
		end
	},
	{
		id = "mode",
		ui_name = "",
		ui_description = "",
		value_default = "Normal",
		not_setting = true,
		scope = MOD_SETTING_SCOPE_NEW_GAME,
		ui_fn = function(mod_id, gui, in_main_menu, im_id, setting)
			copypaste("mode", gui, {"Normal", "Boss Rush", "Calamari", "Powerful", "Shuffle", "Wormy", "Regular Armor"}, im_id, 0,
			"Mode: ",
			"Silly bonus run modifiers. Not for use in traditional runs. Can't be changed mid-run.\nBoss Rush: Spawn in Boss Rush.\nCalamari: Spawn in the Wand Connoisseur's Boss Rush arena with just your starting gear.\nPowerful: YOU have boss armor. Very untested.\nShuffle: Boss soul drops are shuffled.\nWormy: You're a worm. Keep a combo going or you die.\nRegular Armor: Everything BUT you has boss armor. Very untested."
			)
		end
	},
	{
		id = "souls",
		ui_name = "",
		ui_description = "",
		value_default = true,
		not_setting = true,
		scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
		ui_fn = function(mod_id, gui, in_main_menu, im_id, setting)
			copypaste("souls", gui, {true, false}, im_id, 0,
			"Souls: ",
			"Killed bosses will drop their Soul if their rework is enabled.\nSouls are special spells that always and only drop from their respective boss.\nThese aren't just any old projectile spells, though!\nThey have unique effects that aren't explored by any vanilla spells.\nCollect them all!"
			)
		end
	},
	{
		id = "shuffle",
		ui_name = "",
		ui_description = "",
		value_default = false,
		not_setting = true,
		scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
		ui_fn = function(mod_id, gui, in_main_menu, im_id, setting)
			copypaste("shuffle", gui, {false, true}, im_id, 0,
			"Shuffle Boss Rush: ",
			"Randomize the order of bosses in Boss Rush.\nMildly jank. Use with caution."
			)
		end
	},
	{
		id = "timer",
		ui_name = "",
		ui_description = "",
		value_default = false,
		not_setting = true,
		scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
		ui_fn = function(mod_id, gui, in_main_menu, im_id, setting)
			copypaste("timer", gui, {false, true}, im_id, 0,
			"Boss Rush timer: ",
			"Display a timer while in Boss Rush.\nYou'll still be shown your final time at the end if you have this disabled.\nMay be jank. Use with caution."
			)
		end
	},
	{
		category_id = "specific_bosses",
		ui_name = "List of reworks",
		ui_description = "Toggle reworks for specific bosses.\nTurning off a boss's rework will forfeit their unique spell drops.\nPlease don't disable a boss's rework before you've fought the reworked boss at least once, OK?",
		settings = {
			-- todo: what order do we put these in? boss rush order?
			-- also todo: is it even worth explaining the reworks here? might be better off linking to a wiki page
			{
				id = "rework_limbs",
				ui_name = "",
				ui_description = "",
				value_default = true,
				not_setting = true,
				scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
				ui_fn = function(mod_id, gui, in_main_menu, im_id, setting)
					copypaste("rework_limbs", gui, {true, false}, im_id, 5,
					"Pyramid Boss: ",
					"Rework the Pyramid Boss (Kolmisilmän Koipi).\nThis grants the boss 2 new abilities and makes its minions tougher.\nAnti-cheese: The boss can no longer be frozen, or damaged while its insides are not exposed."
					)
				end
			},
			{
				id = "rework_dragon",
				ui_name = "",
				ui_description = "",
				value_default = true,
				not_setting = true,
				scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
				ui_fn = function(mod_id, gui, in_main_menu, im_id, setting)
					copypaste("rework_dragon", gui, {true, false}, im_id, 5,
					"Dragon: ",
					"Rework the Dragon (Suomuhauki).\nThis grants the boss 1 new ability, and modifies 2 of its existing abilities.\nAnti-cheese: The boss can no longer be frozen."
					)
				end
			},
			{
				id = "rework_alchemist",
				ui_name = "",
				ui_description = "",
				value_default = true,
				not_setting = true,
				scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
				ui_fn = function(mod_id, gui, in_main_menu, im_id, setting)
					copypaste("rework_alchemist", gui, {true, false}, im_id, 5,
					"High Alchemist: ",
					"Rework the High Alchemist (Ylialkemisti).\nThis grants the boss 1 new ability, and modifies 2 of its existing abilities.\nVulnerabilities: The boss takes more slice and projectile damage.\nAnti-cheese: The boss can no longer be damaged by any means while its shield is up."
					)
				end
			},
			{
				id = "rework_gate",
				ui_name = "",
				ui_description = "",
				value_default = true,
				not_setting = true,
				scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
				ui_fn = function(mod_id, gui, in_main_menu, im_id, setting)
					copypaste("rework_gate", gui, {true, false}, im_id, 5,
					"Gate Guardians: ",
					"Rework the Gate Guardians (Veska, Molari, Mokke, Seula).\nThis grants the boss 2 new abilities and modifies 1 of its existing abilities.\nVulnerabilities: The boss takes more projectile damage.\nAnti-cheese: The boss's physics body can no longer be destroyed by most means."
					)
				end
			},
			{
				id = "rework_fish",
				ui_name = "",
				ui_description = "",
				value_default = true,
				not_setting = true,
				scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
				ui_fn = function(mod_id, gui, in_main_menu, im_id, setting)
					copypaste("rework_fish", gui, {true, false}, im_id, 5,
					"Leviathan: ",
					"Rework the Leviathan (Syväolento).\nThis grants the boss 2 new abilities and modifies 2 of its existing abilities.\nVulnerabilities: The boss takes more projectile and explosion damage.\nAnti-cheese: The boss can no longer damage itself."
					)
				end
			},
			{
				id = "rework_ghost",
				ui_name = "",
				ui_description = "",
				value_default = true,
				not_setting = true,
				scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
				ui_fn = function(mod_id, gui, in_main_menu, im_id, setting)
					copypaste("rework_ghost", gui, {true, false}, im_id, 5,
					"Forgotten: ",
					"Rework the Forgotten (Unohdettu).\nThis grants the boss 1 new ability and modifies 1 of its existing abilities, as well as making its minions tougher.\nAnti-cheese: The boss no longer takes damage from acid."
					)
				end
			},
			{
				id = "rework_robot",
				ui_name = "",
				ui_description = "",
				value_default = true,
				not_setting = true,
				scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
				ui_fn = function(mod_id, gui, in_main_menu, im_id, setting)
					copypaste("rework_robot", gui, {true, false}, im_id, 5,
					"Mecha-Kolmi: ",
					"Rework Mecha-Kolmi (Kolmisilmän silmä).\nThis grants the boss 1 new ability and modifies 1 of its existing abilities.\nVulnerabilities: The boss takes more projectile and explosion damage, and takes less holy damage.\nAnti-cheese: The boss can no longer be frozen."
					)
				end
			},
			{
				id = "rework_wizard",
				ui_name = "",
				ui_description = "",
				value_default = true,
				not_setting = true,
				scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
				ui_fn = function(mod_id, gui, in_main_menu, im_id, setting)
					copypaste("rework_wizard", gui, {true, false}, im_id, 5,
					"Master of Masters: ",
					"Rework the Master of Masters (Mestarien mestari).\nThis grants the boss 1 new ability and modifies 4 of its existing abilities.\nVulnerabilities: The purple death orbs now take 80% damage instead of 50% from most types.\nAnti-cheese: The boss no longer takes damage from acid, and ambrosia is less effective."
					)
				end
			},
			{
				id = "rework_pit",
				ui_name = "",
				ui_description = "",
				value_default = true,
				not_setting = true,
				scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
				ui_fn = function(mod_id, gui, in_main_menu, im_id, setting)
					copypaste("rework_pit", gui, {true, false}, im_id, 5,
					"Connoisseur of Wands: ",
					"Rework the Connoisseur of Wands (Sauvojen Tuntija).\nThis overhauls basically the entire boss.\nAnti-cheese: Ambrosia is less effective, and don't even bother trying any shenanigans with tablets."
					)
				end
			},
			{
				id = "rework_tiny",
				ui_name = "",
				ui_description = "",
				value_default = true,
				not_setting = true,
				scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
				ui_fn = function(mod_id, gui, in_main_menu, im_id, setting)
					copypaste("rework_tiny", gui, {true, false}, im_id, 5,
					"Tiny: ",
					"Rework Tiny (Limatoukka).\nThis does nothing special, but grants boss armor.\nThis is subject to change in the future!"
					)
				end
			},
			{
				id = "rework_meat",
				ui_name = "",
				ui_description = "",
				value_default = true,
				not_setting = true,
				scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
				ui_fn = function(mod_id, gui, in_main_menu, im_id, setting)
					copypaste("rework_meat", gui, {true, false}, im_id, 5,
					"Meat Boss: ",
					"Rework the Meat Boss (Kolmisilmän sydän).\nThis does nothing special, but grants boss armor and fixes some cheese.\nThis boss currently does not have a special Soul drop.\nThis is subject to change in the future!"
					)
				end
			},
			--[[{
				id = "rework_deer",
				ui_name = "",
				ui_description = "",
				value_default = true,
				not_setting = true,
				scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
				ui_fn = function(mod_id, gui, in_main_menu, im_id, setting)
					copypaste("rework_deer", gui, {true, false}, im_id, 5,
					"Deer: ",
					"Rework Deer (Tapion vasalli)."
					)
				end
			},]]--
		},
	},
}

function ModSettingsUpdate( init_scope )
	local old_version = mod_settings_get_version( mod_id ) -- This can be used to migrate some settings between mod versions.
	mod_settings_update( mod_id, mod_settings, init_scope )
end

function ModSettingsGuiCount()
	return mod_settings_gui_count( mod_id, mod_settings )
end

-- This function is called to display the settings UI for this mod. Your mod's settings wont be visible in the mod settings menu if this function isn't defined correctly.
function ModSettingsGui( gui, in_main_menu )
	mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )
end
