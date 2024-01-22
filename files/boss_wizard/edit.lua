dofile("mods/boss_reworks/files/lib/injection.lua")
local nxml = dofile("mods/boss_reworks/files/lib/nxml.lua")
local path = "data/entities/animals/boss_wizard/boss_wizard.xml"
local tree = nxml.parse(ModTextFileGetContent(path))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/boss_armor_init.lua"> </LuaComponent>'))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/healthbar_counter.lua" </LuaComponent>'))
table.insert(tree.children,
	nxml.parse('<CellEaterComponent radius="40" eat_probability="35" ignored_material="swamp" ></CellEaterComponent>'))
ModTextFileSetContent(path, tostring(tree))

path = "data/entities/animals/boss_wizard/wizard_orb_blood.xml"
tree = nxml.parse(ModTextFileGetContent(path))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/boss_wizard/ambrosia_bleed.lua" </LuaComponent>'))
ModTextFileSetContent(path, tostring(tree))

inject(args.SS,modes.R,"data/entities/animals/boss_wizard/wizard_orb_death.xml", 'blood_material="blood"', 'blood_material="smoke"')
inject(args.SS,modes.R,"data/entities/animals/boss_wizard/wizard_orb_death.xml", 'blood_spray_material="blood"', 'blood_spray_material="smoke"')