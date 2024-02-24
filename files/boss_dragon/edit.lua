local nxml = dofile("mods/boss_reworks/files/lib/nxml.lua")
local path = "data/entities/animals/boss_dragon.xml"
local tree = nxml.parse(ModTextFileGetContent(path))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/boss_armor_init.lua"> </LuaComponent>'))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/healthbar_counter.lua" </LuaComponent>'))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/boss_dragon/speed_scale.lua"> </LuaComponent>'))
for k, v in ipairs(tree.children) do
	if v.name == "Entity" then
		for k2, v2 in ipairs(v.children) do
			if v2.attr.script_source_file == "data/scripts/projectiles/orb_green_dragon.lua" then
				v2.attr.script_source_file = "mods/boss_reworks/files/boss_dragon/tail_orbs.lua"
			end
		end
	elseif v.name == "BossDragonComponent" then
		v.attr.projectile_1 = "mods/boss_reworks/files/boss_dragon/ray.xml"
		v.attr.projectile_2 = "mods/boss_reworks/files/boss_dragon/ray.xml"
	end
end
table.insert(tree.children,
	nxml.parse(
		'<Entity> <InheritTransformComponent/> <GameEffectComponent effect="STUN_PROTECTION_FREEZE" frames="-1"> </GameEffectComponent>'))
ModTextFileSetContent(path, tostring(tree))
-- why is dragon the only one to not get his own folder? :(
inject(args.SS,modes.P,"data/scripts/animals/boss_dragon_death.lua", 'for i=1,count do', 'CreateItemActionEntity("BR_REWARD_DRAGON", pos_x + 16, pos_y)')