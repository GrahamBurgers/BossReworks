dofile("mods/boss_reworks/files/lib/injection.lua")
local nxml = dofile("mods/boss_reworks/files/lib/nxml.lua")

local path = "data/entities/animals/maggot_tiny/maggot_tiny.xml"
local tree = nxml.parse(ModTextFileGetContent(path))
tree.attr.tags = tree.attr.tags .. ",miniboss,boss"
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/boss_armor_init.lua"> </LuaComponent>'))
ModTextFileSetContent(path, tostring(tree))

inject(args.SS,modes.P,"data/entities/animals/maggot_tiny/death.lua", 'GameAddFlagRun( "miniboss_maggot" )', [[
	if not GameHasFlagRun("br_killed_animal_maggot_tiny") then
		GameAddFlagRun("br_killed_animal_maggot_tiny")
		dofile_once("mods/boss_reworks/files/soul_things.lua")
		CreateItemActionEntity(Soul("BR_REWARD_TINY"), pos_x + 4, pos_y)
	end
]])