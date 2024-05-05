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
	if v.name == "ParticleEmitterComponent" and v.attr.emitted_material_name == "blood" then
		v.attr.emitted_material_name = "boss_reworks_blood_nostain"
	end
	if v.name == "LuaComponent" and v.attr.script_source_file == "data/entities/animals/boss_wizard/bloodtentacle.lua" then
		-- v.attr._enabled = "1"
		v.attr.execute_every_n_frame = "4"
		v.attr.script_source_file = "mods/boss_reworks/files/boss_wizard/bloodtentacle_new.lua"
	end
	if v.name == "Base" then
		for k2, v2 in ipairs(v.children) do
			if v2.name == "DamageModelComponent" then
				v2.attr.materials_damage = "0"
			end
		end
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

path = "data/entities/animals/boss_wizard/wizard_orb_death.xml"
tree = nxml.parse(ModTextFileGetContent(path))
for k, v in ipairs(tree.children) do
	if v.name == "ParticleEmitterComponent" and v.attr.emitted_material_name == "slime" then
		v.attr.emitted_material_name = "boss_reworks_slime_nostain"
	end
	if v.name == "DamageModelComponent" then
		v.attr.blood_material = "smoke"
		v.attr.blood_spray_material = "smoke"
		v.attr.materials_damage = "0"
		v.attr.blood_multiplier = "0.2"
		v.attr.blood_spray_create_some_cosmetic = "1"
		v.children[1].attr.projectile="0.8"
		v.children[1].attr.explosion="0.8"
		v.children[1].attr.electricity="0.8"
		v.children[1].attr.fire="0.8"
		v.children[1].attr.ice="0.8"
		v.children[1].attr.melee="0.8"
		v.children[1].attr.slice="0.8"
	end
	if v.name == "AreaDamageComponent" then
		v.attr._enabled = "0"
	end
end
ModTextFileSetContent(path, tostring(tree))

path = "data/entities/animals/boss_wizard/wizard_orb_blood.xml"
tree = nxml.parse(ModTextFileGetContent(path))
tree.attr.tags = tree.attr.tags .. ",wizard_orb_blood"
for k, v in ipairs(tree.children) do
	if v.name == "ParticleEmitterComponent" and v.attr.emitted_material_name == "blood" then
		v.attr.emitted_material_name = "boss_reworks_blood_nostain"
	end
	if v.name == "DamageModelComponent" then
		v.attr.wait_for_kill_flag_on_death = "1"
		v.attr.materials_damage = "0"
	end
end
ModTextFileSetContent(path, tostring(tree))

inject(args.SS,modes.R,"data/entities/animals/boss_wizard/statusburst.xml", 'data/entities/animals/boss_wizard/statusburst.lua', 'mods/boss_reworks/files/boss_wizard/statusburst_new.lua')
inject(args.SS,modes.R,"data/entities/animals/boss_wizard/statusburst.xml", 'execute_every_n_frame="2"', 'execute_every_n_frame="4"')
inject(args.SS,modes.P,"data/entities/animals/boss_wizard/state.lua", 'if ( mode == 0 ) then', [[
	-- HAX, projectiles fired from projectiles advance his state for some reason
	if EntityHasTag(pid, "br_effect_projectile") then return end
	]])
inject(args.SS,modes.R,"data/entities/animals/boss_wizard/wizard_nullify.lua", '( projectile_id ~= proj_id ) then', '( projectile_id ~= proj_id ) and false then')
inject(args.SS,modes.R,"data/entities/animals/boss_wizard/state.lua", 'data/entities/animals/boss_wizard/bloodtentacle.xml', 'mods/boss_reworks/files/boss_wizard/bloodtentacle_new.xml')
inject(args.SS,modes.A,"data/entities/animals/boss_wizard/wizard_nullify.lua", 'mode = 2', [[

	local children = EntityGetAllChildren(entity_id)
	for i = 1, #children do
		if EntityHasTag(children[i], "wizard_orb_blood") then
			local x2, y2 = EntityGetTransform(children[i])
			EntityLoad( "data/entities/particles/blood_explosion.xml", x2, y2 )
			EntityKill(children[i])
		end
	end
]])

inject(args.SS,modes.A,"data/entities/animals/boss_wizard/death.lua", [[AddFlagPersistent( "miniboss_wizard" )]], [[

	if not GameHasFlagRun("br_killed_animal_boss_wizard") then
		GameAddFlagRun("br_killed_animal_boss_wizard")
		dofile_once("mods/boss_reworks/files/soul_things.lua")
		CreateItemActionEntity(Soul("BR_REWARD_MASTER"), x + 4, y)
	end
]])

inject(args.SS,modes.P,"data/entities/animals/boss_wizard/spawn_wizard.lua", 'for i=1,1 do', [[
	if GlobalsGetValue("BR_BOSS_RUSH_ACTIVE", "0") == "1" then
		opts = { "wizard_dark", "wizard_poly", "wizard_homing", "wizard_twitchy", "wizard_neutral", "wizard_returner" }
	end
]])