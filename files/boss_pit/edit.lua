dofile("mods/boss_reworks/files/lib/injection.lua")
local nxml = dofile("mods/boss_reworks/files/lib/nxml.lua")

local path = "data/entities/animals/boss_pit/boss_pit.xml"
local tree = nxml.parse(ModTextFileGetContent(path))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/healthbar_counter.lua" </LuaComponent>'))
table.insert(tree.children,
	nxml.parse('<VariableStorageComponent _tags="squid_shield_trigger" value_int="1" ></VariableStorageComponent>'))
table.insert(tree.children,
	nxml.parse('<VariableStorageComponent _tags="squid_last_attack_frame" value_int="0" ></VariableStorageComponent>'))
for k, v in ipairs(tree.children) do
	if v.name == "LuaComponent" and v.attr.script_damage_received == "data/entities/animals/boss_pit/boss_pit_damage.lua" then
		v.attr.script_damage_received = ""
		v.attr.script_damage_about_to_be_received = "mods/boss_reworks/files/boss_pit/squid_armor.lua"
	end
	if v.name == "LuaComponent" and v.attr.script_source_file == "data/entities/animals/boss_pit/boss_pit_logic.lua" then
		v.attr.script_source_file = "mods/boss_reworks/files/boss_pit/logic_new.lua"
		v.attr.execute_every_n_frame = "1"
	end
	if v.name == "DamageModelComponent" then
		v.children[1].attr.projectile = 0.8
		v.children[1].attr.explosion = 0.5
		v.children[1].attr.holy = 0
		-- v.attr.ragdoll_fx_forced = "NONE" -- causes issues with tentacle segments
		v.attr.ragdoll_material = "meat_slime_green"
		v.attr.blood_multiplier = "0.2"
	end
	if v.name == "HitboxComponent" then
		v.attr.damage_multiplier = "1"
	end
end
ModTextFileSetContent(path, tostring(tree))
inject(args.SS,modes.P,"data/entities/animals/boss_pit/boss_pit_death.lua", 'if flag_status then', [[
	if not GameHasFlagRun("br_killed_animal_boss_pit") then
		GameAddFlagRun("br_killed_animal_boss_pit")
		dofile_once("mods/boss_reworks/files/soul_things.lua")
		CreateItemActionEntity(Soul("BR_REWARD_SQUIDWARD"), x, y)
	end
]])