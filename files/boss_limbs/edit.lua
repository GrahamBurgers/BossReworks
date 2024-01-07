dofile("mods/boss_reworks/files/lib/injection.lua")
local nxml = dofile("mods/boss_reworks/files/lib/nxml.lua")

inject(args.SS, modes.R, "data/entities/animals/boss_limbs/boss_limbs_update.lua", ">= 2", "> 10") -- 10 minion is enough
inject(args.SS, modes.P, "data/entities/animals/boss_limbs/boss_limbs_update.lua", "local slime",
	"\nfor i = 1,2 do x = x + Random(-5,5)\ny = y + Random(-5,5)\n")                               -- 10 minion is enough
inject(args.SS, modes.P, "data/entities/animals/boss_limbs/boss_limbs_update.lua", "function get_idle_animation_name",
	"\nend\n")                                                                                     -- 10 minion is enough

local tree = nxml.parse(ModTextFileGetContent("data/entities/animals/boss_limbs/slimeshooter_boss_limbs.xml"))
tree.attr.tags = tree.attr.tags .. ",boss_limbs_minion"
for k, v in ipairs(tree.children) do
	if v.name == "Base" then
		for k2, v2 in ipairs(v.children) do
			if v2.name == "DamageModelComponent" then
				v2.attr.fire_probability_of_ignition = "0"
			end
		end
	end
end
-- table.insert(tree.children,nxml.parse("<VariableStorageComponent></VariableStorageComponent>"))
-- table.insert(tree.children,nxml.parse("<LuaComponent execute_on_added=\"1\" remove_after_executed=\"1\" script_source_file=\"mods/boss_reworks/files/boss_limbs/minion_init.lua\"></LuaComponent>"))
-- table.insert(tree.children,nxml.parse("<LuaComponent execute_every_n_frame=\"900\" remove_after_executed=\"1\" script_source_file=\"mods/boss_reworks/files/boss_limbs/minion_powers.lua\"></LuaComponent>"))
ModTextFileSetContent("data/entities/animals/boss_limbs/slimeshooter_boss_limbs.xml", tostring(tree))
local tree = nxml.parse(ModTextFileGetContent("data/entities/animals/boss_limbs/boss_limbs.xml"))
table.insert(tree.children,
	nxml.parse(
		"<LuaComponent execute_every_n_frame=\"120\" script_source_file=\"mods/boss_reworks/files/boss_limbs/eat_minion.lua\">"))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/boss_armor_init.lua"> </LuaComponent>'))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/boss_dragon/speed_scale.lua"> </LuaComponent>'))
ModTextFileSetContent("data/entities/animals/boss_limbs/boss_limbs.xml", tostring(tree))
