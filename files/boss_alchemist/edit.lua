-- bouncy ball lasts longer and gets bigger
dofile("mods/boss_reworks/files/lib/injection.lua")
local nxml = dofile("mods/boss_reworks/files/lib/nxml.lua")

local path = "data/entities/animals/boss_alchemist/wand_orb.xml"
local tree = nxml.parse(ModTextFileGetContent(path))
for k, v in ipairs(tree.children) do
	if v.name == "ProjectileComponent" then
		v.attr.lifetime = 5 * 60
	end
end
table.insert(tree.children, nxml.parse(
	"<LuaComponent script_source_file=\"mods/boss_reworks/files/boss_alchemist/orb_grow.lua\"></LuaComponent>"
))
table.insert(tree.children, nxml.parse(
	"<GameAreaEffectComponent radius=\"4\" frame_length=\"1\"></GameAreaEffectComponent>"
))
ModTextFileSetContent(path, tostring(tree))
-- TODO: the explosion particles on the ball look silly

-- armour
local path = "data/entities/animals/boss_alchemist/boss_alchemist.xml"
local tree = nxml.parse(ModTextFileGetContent(path))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/boss_armor_init.lua"> </LuaComponent>'))
ModTextFileSetContent(path, tostring(tree))
