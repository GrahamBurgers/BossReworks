dofile("mods/boss_reworks/files/lib/injection.lua")
local nxml = dofile("mods/boss_reworks/files/lib/nxml.lua")
local path = "data/entities/animals/boss_robot/boss_robot.xml"
local tree = nxml.parse(ModTextFileGetContent(path))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/boss_armor_init.lua"> </LuaComponent>'))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/healthbar_counter.lua" </LuaComponent>'))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/boss_robot/beam.lua"> </LuaComponent>'))
table.insert(tree.children,
	nxml.parse('<GameEffectComponent frames="-1" effect="PROTECTION_FREEZE" </GameEffectComponent>'))
for k, v in ipairs(tree.children) do
	if v.name == "DamageModelComponent" then
		v.children[1].attr.projectile = 0.1
		v.children[1].attr.explosion = 0.1
		v.children[1].attr.holy = 0.2
		v.attr.blood_multiplier = 0.2
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
inject(args.SS,modes.R,"data/entities/animals/boss_robot/state.lua", 'EntityLoad( "data/entities/animals/robobase/healerdrone_physics.xml", x, y )', [[
	local eid = EntityLoad( "data/entities/animals/robobase/healerdrone_physics.xml", x, y )
	EntitySetComponentIsEnabled(eid, EntityGetFirstComponent(eid, "MaterialInventoryComponent"), false)
	EntitySetComponentIsEnabled(eid, EntityGetFirstComponent(eid, "ExplodeOnDamageComponent"), false)
	local dmg = EntityGetFirstComponent(eid, "DamageModelComponent")
	if dmg then
		ComponentSetValue2(dmg, "blood_material", "smoke")
		ComponentSetValue2(dmg, "blood_spray_material", "smoke")
	end
]])
inject(args.SS,modes.R,"data/entities/animals/boss_robot/rocket.xml", 'count_min="5"', 'count_min="0"')
inject(args.SS,modes.R,"data/entities/animals/boss_robot/rocket.xml", 'count_max="5"', 'count_max="1"')
inject(args.SS,modes.R,"data/entities/animals/boss_robot/rocket.xml", 'create_cell_probability="5"', 'create_cell_probability="1"')

inject(args.SS,modes.P,"data/entities/animals/boss_robot/death.lua", 'AddFlagPersistent( "miniboss_robot" )', [[
	if not GameHasFlagRun("br_killed_animal_boss_robot") then
		GameAddFlagRun("br_killed_animal_boss_robot")
		CreateItemActionEntity("BR_REWARD_ROBOT", x, y - 20)
	end

]])

path = "data/entities/items/pickup/wandstone.xml"
tree = nxml.parse(ModTextFileGetContent(path))
for k, v in ipairs(tree.children) do
	if v.name == "GameEffectComponent" then
		if v.attr.effect == "EDIT_WANDS_EVERYWHERE" then
			v.attr._tags = v.attr._tags .. ",enabled_in_inventory"
		end
	end
end
ModTextFileSetContent(path, tostring(tree))