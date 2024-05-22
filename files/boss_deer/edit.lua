dofile("mods/boss_reworks/files/lib/injection.lua")
local nxml = dofile("mods/boss_reworks/files/lib/nxml.lua")

local path = "data/entities/animals/boss_spirit/islandspirit.xml"
local tree = nxml.parse(ModTextFileGetContent(path))
for k, v in ipairs(tree.children) do
	if v.name == "LuaComponent" then
		if v.attr.script_source_file == "data/entities/animals/boss_spirit/islandspirit.lua" then
			v.attr.script_source_file = "mods/boss_reworks/files/boss_deer/logic.lua"
			v.attr.script_damage_received = "mods/boss_reworks/files/boss_deer/logic.lua"
			v.attr.script_death = "mods/boss_reworks/files/boss_deer/logic.lua"
		end
		if v.attr.script_source_file == "data/entities/animals/boss_spirit/init.lua" then
			v.attr.script_source_file = "mods/boss_reworks/files/boss_deer/init.lua"
		end
	end
	if v.name == "Base" then
		for k2, v2 in ipairs(v.children) do
			if v2.name == "DamageModelComponent" then
				v2.attr.hp = 10
				v2.attr.blood_multiplier = 0.1
				v2.children[1].attr.slice = 0.5
				v2.children[1].attr.projectile = 0.6
				v2.children[1].attr.holy = -4
			end
		end
	end
	if v.name == "Entity" then
		for k2, v2 in ipairs(v.children) do
			if v2.attr.effect == "PROTECTION_PROJECTILE" then
				v2.attr.frames = "1"
			end
		end
	end
end
table.insert(tree.children,
	nxml.parse('<VariableStorageComponent _tags="no_gold_drop"> </VariableStorageComponent>'))
ModTextFileSetContent(path, tostring(tree))