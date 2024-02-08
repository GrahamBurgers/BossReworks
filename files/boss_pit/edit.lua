dofile("mods/boss_reworks/files/lib/injection.lua")
local nxml = dofile("mods/boss_reworks/files/lib/nxml.lua")

local path = "data/entities/animals/boss_pit/boss_pit.xml"
local tree = nxml.parse(ModTextFileGetContent(path))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/healthbar_counter.lua" </LuaComponent>'))
table.insert(tree.children,
	nxml.parse('<VariableStorageComponent _tags="squid_shield_trigger" value_int="1" ></VariableStorageComponent>'))
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
		v.children[1].attr.projectile = 1
		v.children[1].attr.explosion = 1
		v.children[1].attr.holy = 0
		-- v.attr.ragdoll_fx_forced = "NONE" -- causes issues with tentacle segments
		v.attr.ragdoll_material = "meat_slime_green"
	end
end
ModTextFileSetContent(path, tostring(tree))