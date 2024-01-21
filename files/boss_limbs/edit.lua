dofile("mods/boss_reworks/files/lib/injection.lua")
local nxml = dofile("mods/boss_reworks/files/lib/nxml.lua")

inject(args.SS, modes.R, "data/entities/animals/boss_limbs/boss_limbs_update.lua", ">= 2", ">= 7") -- 7 minion is enough
inject(args.SS, modes.P, "data/entities/animals/boss_limbs/boss_limbs_update.lua", "local slime",
	"\nfor i = 1,2 do x = x + Random(-5,5)\ny = y + Random(-5,5)\n")                               
inject(args.SS, modes.P, "data/entities/animals/boss_limbs/boss_limbs_update.lua", "function get_idle_animation_name",
	"\nend\n")

	-- new phase
inject(args.SS, modes.P, "data/entities/animals/boss_limbs/boss_limbs_update.lua", "function choose_random_phase",
	[[

function phase_dark_flames()
	dofile_once("mods/boss_reworks/files/projectile_utils.lua")
	set_logic_state( DontMove )
	expose_weak_spot()
	local me = GetUpdatedEntityID()
	local x, y = EntityGetTransform(me)
	ShootProjectile(me,"mods/boss_reworks/files/boss_limbs/darkflames.xml", x, y, 0, 0)
	boss_wait(30)
	circleshot()
	hide_weak_spot()
	boss_wait(60)
	expose_weak_spot()
	x, y = EntityGetTransform(me)
	ShootProjectile(me,"mods/boss_reworks/files/boss_limbs/darkflames.xml", x, y, 0, 0)
	hide_weak_spot()
	boss_wait(30)
	spawn_minion()
	boss_wait(30)
	expose_weak_spot()
	boss_wait(3 * 60)
	hide_weak_spot()
	boss_wait(30)
	choose_random_phase()
end
]])

inject(args.SS, modes.A, "data/entities/animals/boss_limbs/boss_limbs_update.lua", "0,4", "+1")
inject(args.SS, modes.R, "data/entities/animals/boss_limbs/boss_limbs_update.lua", "else               ", "elseif r == 4 then ")
inject(args.SS, modes.A, "data/entities/animals/boss_limbs/boss_limbs_update.lua", "state = phase4", " else               state = phase_dark_flames ")

local content = ModTextFileGetContent("data/entities/animals/boss_limbs/orb_boss_limbs.xml")
content = content:gsub("die_on_low_velocity", "collide_with_world")
content = content:gsub('on_collision_die="1"', 'collide_with_tag="player_unit"')
ModTextFileSetContent("data/entities/animals/boss_limbs/orb_boss_limbs.xml", content)

local content = ModTextFileGetContent("data/entities/animals/boss_limbs/orb_pink_big.xml")
content = content:gsub('on_collision_die="1"', 'collide_with_tag="player_unit"')
content = content:gsub('prey', 'player_unit')
ModTextFileSetContent("data/entities/animals/boss_limbs/orb_pink_big.xml", content)

local tree = nxml.parse(ModTextFileGetContent("data/entities/animals/boss_limbs/slimeshooter_boss_limbs.xml"))
tree.attr.tags = tree.attr.tags .. ",boss_limbs_minion"
for k, v in ipairs(tree.children) do
	if v.name == "Base" then
		for k2, v2 in ipairs(v.children) do
			if v2.name == "DamageModelComponent" then
				v2.attr.fire_probability_of_ignition = "0"
			end
			if v2.name == "AnimalAIComponent" then
				v2.attr.dont_counter_attack_own_herd = "1"
			end
		end
	end
end
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/boss_limbs/minion_die.lua"> </LuaComponent>'))
ModTextFileSetContent("data/entities/animals/boss_limbs/slimeshooter_boss_limbs.xml", tostring(tree))
tree = nxml.parse(ModTextFileGetContent("data/entities/animals/boss_limbs/boss_limbs.xml"))
tree.attr.tags = tree.attr.tags .. ",boss_limbs"
table.insert(tree.children,
	nxml.parse('<LuaComponent execute_every_n_frame="240" script_source_file="mods/boss_reworks/files/boss_limbs/eat_minion.lua">'))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/boss_armor_init.lua"> </LuaComponent>'))
table.insert(tree.children,
	nxml.parse('<LuaComponent execute_every_n_frame="-1" script_damage_about_to_be_received="mods/boss_reworks/files/boss_limbs/anticheese.lua">'))
table.insert(tree.children,
	nxml.parse(
		'<Entity> <InheritTransformComponent/> <GameEffectComponent effect="STUN_PROTECTION_FREEZE" frames="-1"> </GameEffectComponent>'))
ModTextFileSetContent("data/entities/animals/boss_limbs/boss_limbs.xml", tostring(tree))

inject(args.SS,modes.R,"data/entities/animals/boss_limbs/slime_boss_limbs.xml", 'speed_min="150"', 'speed_min="80"')
inject(args.SS,modes.R,"data/entities/animals/boss_limbs/slime_boss_limbs.xml", 'speed_max="155"', 'speed_max="80"')