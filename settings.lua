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
	print( tostring(new_value) )
end

local mod_id = "boss_reworks" -- This should match the name of your mod's folder.
mod_settings_version = 1
mod_settings = 
{
	{
		id = "boss_armor",
		ui_name = "Boss armor",
		ui_description = "Boss armor makes bosses more fair by making it less effective to deal massive amounts of damage at once.\nThis creates a more fair fight and ensures the boss will survive for long enough to do a few attacks.\nYou can turn this off if you want but it will make me sad.",
		value_default = true,
		scope = MOD_SETTING_SCOPE_RUNTIME,
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
				ui_name = "Pyramid Boss",
				ui_description = "Rework the Pyramid Boss (Kolmisilmän Koipi).\nThis grants it a new Path of Dark Flame attack, allows it to consume its\nminions for benefits, and allows its orb projectiles to travel through walls.\nAnti-cheese: The boss can no longer be frozen, or damaged while its insides are not exposed.",
				value_default = true,
				scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
			},
			{
				id = "rework_dragon",
				ui_name = "Dragon",
				ui_description = "Rework the Dragon (Suomuhauki).\nThis makes its tail orbs more bouncy, changes the fire breath\nto be more interesting, and gives it a new projectile attack.\nAnti-cheese: The boss can no longer be frozen.",
				value_default = true,
				scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
			},
			{
				id = "rework_alchemist",
				ui_name = "High Alchemist",
				ui_description = "Rework the High Alchemist (Ylialkemisti).\nThis changes its shield to be more useful but less common, makes the bouncing\nwand projectile last longer, and gives it a new projectile attack.\nAnti-cheese: The boss can no longer be damaged by any means while its shield is up.",
				value_default = true,
				scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
			},
			{
				id = "rework_gate",
				ui_name = "Gate Guardians",
				ui_description = "Rework the Gate Guardians (Veska, Molari, Mokke, Seula).\nThis gives them two new projectile attacks:\nOne that is more powerful with more segments and one that is more powerful with less.\nAnti-cheese: The boss can no longer be killed by destroying its physics body.",
				value_default = true,
				scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
			},
			{
				id = "rework_fish",
				ui_name = "Leviathan",
				ui_description = "Rework the Leviathan (Syväolento).\nThis makes the boss more vulnerable to projectile and explosion damage,\nand grants it two new attacks that interact with the battle environment.\nAnti-cheese: The boss can no longer damage itself.",
				value_default = true,
				scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
			},
			{
				id = "rework_ghost",
				ui_name = "Forgotten",
				ui_description = "Rework the Forgotten (Unohdettu).\nThis gives the boss a teleport ability, makes the minions more useful, and makes the\nplasma activate faster without damaging the environment (or your Paha Silmä).\nAnti-cheese: The boss no longer takes damage from acid.",
				value_default = true,
				scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
			},
			{
				id = "rework_robot",
				ui_name = "Mecha-Kolmi",
				ui_description = "Rework Mecha-Kolmi (Kolmisilmän silmä).\nThis gives the boss an attractive beam ability, while making the missiles less\ndangerous and making the boss more vulnerable to projectile and explosion damage.\nAnti-cheese: The boss can no longer be frozen.",
				value_default = true,
				scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
			},
			{
				id = "rework_wizard",
				ui_name = "Master of Masters",
				ui_description = "Rework the Master of Masters (Mestarien mestari).\nThis makes the boss's status effects more fair and interesting, and grants\nthe boss some new abilities in all 3 phases.\nAnti-cheese: The boss no longer takes damage from acid, and ambrosia is less effective.",
				value_default = true,
				scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
			},
			{
				id = "rework_pit",
				ui_name = "Squidward",
				ui_description = "Rework Squidward (Sauvojen Tuntija).\nThis hrrnggngngng",
				value_default = true,
				scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
			},
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
