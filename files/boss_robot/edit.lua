dofile("mods/boss_reworks/files/lib/injection.lua")
local nxml = dofile("mods/boss_reworks/files/lib/nxml.lua")
local path = "data/entities/animals/boss_robot/boss_robot.xml"
local tree = nxml.parse(ModTextFileGetContent(path))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/boss_armor_init.lua"> </LuaComponent>'))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/boss_robot/beam.lua"> </LuaComponent>'))
for k, v in ipairs(tree.children) do
	if v.name == "DamageModelComponent" then
		v.children[1].attr.projectile = 0.1
		v.children[1].attr.explosion = 0.1
		v.children[1].attr.holy = 0.2
	end
	if v.name == "Entity" then
		for k2, v2 in ipairs(v.children) do
			if v2.attr.effect == "PROTECTION_PROJECTILE" then
				v2.attr.frames = "1"
			end
		end
	end
end
ModTextFileSetContent(path, tostring(tree))

inject(args.SS,modes.R,"data/entities/animals/boss_robot/rocket.xml", 'fire="2.2"', 'fire="0"')
inject(args.SS,modes.R,"data/entities/animals/boss_robot/rocket.xml", 'lifetime="100"', 'lifetime="60"')
inject(args.SS,modes.R,"data/entities/animals/boss_robot/rocket.xml", 'damage="6"', 'damage="1"')