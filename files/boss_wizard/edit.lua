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

path = "data/entities/animals/boss_wizard/laser.xml"
tree = nxml.parse(ModTextFileGetContent(path))
for k, v in ipairs(tree.children) do
	if v.name == "SpriteComponent" then
		v.attr.emissive = "1"
	end
	if v.name == "LuaComponent" and v.attr.script_source_file == "data/entities/animals/boss_wizard/laser.lua" then
		v.attr.execute_every_n_frame = "24"
		v.attr.script_source_file = "mods/boss_reworks/files/boss_wizard/laser_new.lua"
	end
	if v.name == "ProjectileComponent" then
		v.attr.collide_with_world = "0"
	end
end
ModTextFileSetContent(path, tostring(tree))

path = "data/entities/animals/boss_wizard/debuff_init.xml"
tree = nxml.parse(ModTextFileGetContent(path))
table.insert(tree.children,
	nxml.parse('<LifetimeComponent lifetime="180" ></LifetimeComponent>'))
for k, v in ipairs(tree.children) do
	if v.name == "LuaComponent" and v.attr.script_source_file == "data/entities/animals/boss_wizard/debuff_init.lua" then
		v.attr.execute_every_n_frame = "40"
		v.attr.script_source_file = "mods/boss_reworks/files/boss_wizard/debuff_init_new.lua"
	end
end
ModTextFileSetContent(path, tostring(tree))

inject(args.SS,modes.R,"data/entities/animals/boss_wizard/wizard_orb_death.xml", 'blood_material="blood"', 'blood_material="smoke"')
inject(args.SS,modes.R,"data/entities/animals/boss_wizard/wizard_orb_death.xml", 'blood_spray_material="blood"', 'blood_spray_material="smoke"')
inject(args.SS,modes.R,"data/entities/animals/boss_wizard/wizard_orb_blood.xml", 'polymorphable_NOT', 'wizard_orb_blood,polymorphable_NOT')
inject(args.SS,modes.R,"data/entities/animals/boss_wizard/statusburst.xml", 'data/entities/animals/boss_wizard/statusburst.lua', 'mods/boss_reworks/files/boss_wizard/statusburst_new.lua')
inject(args.SS,modes.R,"data/entities/animals/boss_wizard/statusburst.xml", 'execute_every_n_frame="2"', 'execute_every_n_frame="4"')