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

-- blood
for k, v in ipairs(tree.children) do
	if v.name == "DamageModelComponent" then
		v.attr.blood_multipier = 0.3
	end
end

-- make the parries actually work 

table.insert(tree.children,
	nxml.parse(
		'<LuaComponent script_damage_about_to_be_received="mods/boss_reworks/files/boss_alchemist/anticheese.lua"> </LuaComponent>'))

ModTextFileSetContent(path, tostring(tree))

inject(args.SS, modes.R, "data/entities/animals/boss_alchemist/projectile_counter.lua", "shoot_projectile",
	"nil\ndofile_once(\"mods/boss_reworks/files/projectile_utils.lua\")\neid = ShootProjectile")

inject(args.SS, modes.P, "data/entities/animals/boss_alchemist/projectile_counter_create.lua", "local entity_id",
[[local comp = EntityGetFirstComponent(GetUpdatedEntityID(),"HitboxComponent")
if comp and ComponentGetValue2(comp,"damage_multiplier") <= 0.01 then return end
]])

inject(args.SS,modes.R,"data/entities/animals/boss_alchemist/projectile_counter_create_damage.lua",
[[local eid = EntityLoad( "data/entities/animals/boss_alchemist/projectile_counter.xml", x, y )
		EntityAddChild( entity_id, eid )]],"dofile(\"data/entities/animals/boss_alchemist/projectile_counter_create.lua\")")