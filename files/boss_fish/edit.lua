local nxml = dofile("mods/boss_reworks/files/lib/nxml.lua")
local path = "data/entities/animals/boss_fish/fish_giga.xml"
local tree = nxml.parse(ModTextFileGetContent(path))
tree.attr.tags = tree.attr.tags .. ",boss_fish"
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/boss_armor_init.lua"> </LuaComponent>'))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/healthbar_counter.lua" </LuaComponent>'))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/boss_fish/fish_targeter_add.lua" execute_every_n_frame="700"> </LuaComponent>'))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/boss_fish/orb_warning.lua"> </LuaComponent>'))
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

path = "data/entities/animals/boss_fish/orb_big.xml"
local content = ModTextFileGetContent(path)
content = content:gsub("mortal", "player_unit")
content = content:gsub("penetrate_world", "on_death_gfx_leave_sprite")
content = content:gsub("penetrate_entities=\"1\"", "collide_with_entities=\"0\"")
content = content:gsub("liquid_drag=\"0\"", "liquid_drag=\"-0.05\"")
ModTextFileSetContent(path, content)

ModLuaFileAppend("data/entities/animals/boss_fish/damage.lua", "mods/boss_reworks/files/boss_fish/damage_append.lua")