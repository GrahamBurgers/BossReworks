-- bouncy ball lasts longer and gets bigger
dofile("mods/boss_reworks/files/lib/injection.lua")
local nxml = dofile("mods/boss_reworks/files/lib/nxml.lua")

local path = "data/entities/animals/boss_alchemist/wand_orb.xml"
local tree = nxml.parse(ModTextFileGetContent(path))
for k, v in ipairs(tree.children) do
	if v.name == "ProjectileComponent" then
		v.attr.lifetime = v.attr.lifetime * 2
		v.attr.damage = v.attr.damage * 0.2
	end
end
table.insert(tree.children, nxml.parse(
	'<LuaComponent script_source_file="mods/boss_reworks/files/boss_alchemist/orb_grow.lua"></LuaComponent>'
))
table.insert(tree.children, nxml.parse(
	'<GameAreaEffectComponent radius="4" frame_length="1"></GameAreaEffectComponent>'
))
ModTextFileSetContent(path, tostring(tree))
-- TODO: the explosion particles on the ball look silly

local path = "data/entities/animals/boss_alchemist/projectile_counter.xml"
local tree = nxml.parse(ModTextFileGetContent(path))
for k, v in ipairs(tree.children) do
	if v.name == "LuaComponent" then
		if v.attr.script_source_file == "data/entities/animals/boss_alchemist/projectile_counter.lua" then
			v.attr.script_source_file = "mods/boss_reworks/files/boss_alchemist/projectile_counter_not_stupid.lua"
		end
	end
end
ModTextFileSetContent(path, tostring(tree))

-- armour
local path = "data/entities/animals/boss_alchemist/boss_alchemist.xml"
local tree = nxml.parse(ModTextFileGetContent(path))
for k, v in ipairs(tree.children) do
	if v.name == "Base" then
		for k2, v2 in ipairs(v.children) do
			if v2.name == "AnimalAIComponent" then
				v2.attr.attack_ranged_frames_between = v2.attr.attack_ranged_frames_between * 2
			end
			if v2.name == "DamageModelComponent" then
				v2.blood_multiplier = 0.1
				v2.children[1].attr.slice = 0.5
				v2.children[1].attr.projectile = 0.6
			end
		end
	end
end
table.insert(tree.children,
	nxml.parse('<GameEffectComponent effect="KNOCKBACK_IMMUNITY" frames="-1" </GameEffectComponent>'))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/boss_armor_init.lua"> </LuaComponent>'))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/healthbar_counter.lua" </LuaComponent>'))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/boss_alchemist/ball_shooter_shoot.lua" execute_every_n_frame="300"> </LuaComponent>'))

-- make the parries actually work 

table.insert(tree.children,
	nxml.parse(
		'<LuaComponent script_damage_about_to_be_received="mods/boss_reworks/files/boss_alchemist/anticheese.lua"> </LuaComponent>'))

ModTextFileSetContent(path, tostring(tree))



inject(args.SS, modes.P, "data/entities/animals/boss_alchemist/projectile_counter_create.lua", "local entity_id",
[[local comp = EntityGetFirstComponent(GetUpdatedEntityID(),"HitboxComponent")
if comp and ComponentGetValue2(comp,"damage_multiplier") <= 0.01 then return end
]])

inject(args.SS, modes.R, "data/entities/animals/boss_alchemist/projectile_counter_create.lua", 'ComponentSetValue2( c, "execute_every_n_frame", 600 )',
[[
	ComponentSetValue2( c, "execute_every_n_frame", 660 )
	ComponentSetValue2( c, "mNextExecutionTime", GameGetFrameNum() + 660 )
]])

inject(args.SS,modes.R,"data/entities/animals/boss_alchemist/projectile_counter_create_damage.lua",
[[local eid = EntityLoad( "data/entities/animals/boss_alchemist/projectile_counter.xml", x, y )
		EntityAddChild( entity_id, eid )]],"dofile(\"data/entities/animals/boss_alchemist/projectile_counter_create.lua\")")

inject(args.SS,modes.R,"data/entities/animals/boss_alchemist/projectile_counter_create_damage.lua",
"cumulative >= 3.0", "cumulative >= 7.0")

inject(args.SS,modes.R,"data/entities/animals/boss_alchemist/projectile_counter_create_damage.lua",
"cumulative = cumulative - 3.0", "cumulative = -7.0")

inject(args.SS,modes.A,"data/entities/animals/boss_alchemist/death.lua", [[SetRandomSeed( pw, 60 )]], [[
	if not GameHasFlagRun("br_killed_animal_boss_alchemist") then
		GameAddFlagRun("br_killed_animal_boss_alchemist")
		CreateItemActionEntity("BR_REWARD_ALCHEMIST", x + 32, y)
	end
]])

inject(args.SS,modes.A,"data/entities/animals/boss_alchemist/projectile_counter.xml", '<CellEaterComponent', ' ignored_material="boss_reworks_templebrick_indestructible"')
print(ModTextFileGetContent("data/entities/animals/boss_alchemist/projectile_counter.xml"))