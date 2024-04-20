dofile("mods/boss_reworks/files/lib/injection.lua")
local nxml = dofile("mods/boss_reworks/files/lib/nxml.lua")

local path = "data/entities/animals/boss_meat/boss_meat.xml"
local tree = nxml.parse(ModTextFileGetContent(path))
tree.attr.tags = tree.attr.tags .. ",touchmagic_immunity"
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/boss_armor_init.lua"> </LuaComponent>'))
table.insert(tree.children,
	nxml.parse('<LuaComponent execute_every_n_frame="-1" script_damage_about_to_be_received="mods/boss_reworks/files/boss_meat/anticheese.lua">'))
table.insert(tree.children,
	nxml.parse('<GameEffectComponent frames="-1" effect="PROTECTION_FREEZE"> </GameEffectComponent>'))
ModTextFileSetContent(path, tostring(tree))