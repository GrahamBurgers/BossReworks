dofile("mods/boss_reworks/files/lib/injection.lua")
local nxml = dofile("mods/boss_reworks/files/lib/nxml.lua")
local path = "data/entities/animals/boss_wizard/boss_wizard.xml"
local tree = nxml.parse(ModTextFileGetContent(path))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/boss_armor_init.lua"> </LuaComponent>'))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/healthbar_counter.lua" </LuaComponent>'))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/boss_wizard/phase3.lua" </LuaComponent>'))
table.insert(tree.children,
	nxml.parse('<CellEaterComponent radius="50" eat_probability="4" ignored_material="swamp" ></CellEaterComponent>'))
table.insert(tree.children,
	nxml.parse('<GameEffectComponent effect="KNOCKBACK_IMMUNITY" frames="-1" </GameEffectComponent>'))
table.insert(tree.children,
	nxml.parse('<VariableStorageComponent _tags="boss_wizard_rotato" name="rotato" value_int="0" value_float="0" value_string="1" ></VariableStorageComponent>'))
for k, v in ipairs(tree.children) do
	if v.name == "LuaComponent" and v.attr.script_source_file == "data/entities/animals/boss_wizard/bloodtentacle.lua" then
		-- v.attr._enabled = "1"
		v.attr.execute_every_n_frame = "4"
		v.attr.script_source_file = "mods/boss_reworks/files/boss_wizard/bloodtentacle_new.lua"
	end
end
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
inject(args.SS,modes.R,"data/entities/animals/boss_wizard/wizard_orb_death.xml", '101', '100')
inject(args.SS,modes.R,"data/entities/animals/boss_wizard/wizard_orb_death.xml", '<AreaDamageComponent', '<AreaDamageComponent _enabled="0"') -- no need to discourage the player from staying near the boss
inject(args.SS,modes.R,"data/entities/animals/boss_wizard/wizard_orb_blood.xml", 'polymorphable_NOT', 'wizard_orb_blood,polymorphable_NOT')
inject(args.SS,modes.A,"data/entities/animals/boss_wizard/wizard_orb_blood.xml", 'physics_objects_damage="0"', 'wait_for_kill_flag_on_death="1"')
inject(args.SS,modes.R,"data/entities/animals/boss_wizard/statusburst.xml", 'data/entities/animals/boss_wizard/statusburst.lua', 'mods/boss_reworks/files/boss_wizard/statusburst_new.lua')
inject(args.SS,modes.R,"data/entities/animals/boss_wizard/statusburst.xml", 'execute_every_n_frame="2"', 'execute_every_n_frame="4"')
inject(args.SS,modes.P,"data/entities/animals/boss_wizard/state.lua", 'if ( mode == 0 ) then', [[
	-- HAX, projectiles fired from projectiles advance his state for some reason
	if EntityHasTag(pid, "br_effect_projectile") then return end
	]])
inject(args.SS,modes.R,"data/entities/animals/boss_wizard/wizard_nullify.lua", 'x, y, 36, "projectile"', 'x, y, 0, "projectile"')
inject(args.SS,modes.R,"data/entities/animals/boss_wizard/state.lua", 'data/entities/animals/boss_wizard/bloodtentacle.xml', 'mods/boss_reworks/files/boss_wizard/bloodtentacle_new.xml')
inject(args.SS,modes.A,"data/entities/animals/boss_wizard/wizard_nullify.lua", 'mode = 1', [[

	local children = EntityGetAllChildren(entity_id)
	for i = 1, #children do
		if EntityHasTag(children[i], "wizard_orb_blood") then
			local x2, y2 = EntityGetTransform(children[i])
			EntityLoad( "data/entities/particles/blood_explosion.xml", x2, y2 )
			EntityKill(children[i])
		end
	end
]])