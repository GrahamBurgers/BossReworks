dofile_once("mods/boss_reworks/files/projectile_utils.lua")

local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local player = EntityGetClosestWithTag(x, y, "player_unit") or EntityGetClosestWithTag(x, y, "polymorphed_player") or 0
local proj = ""
local mult = 1
local comps = EntityGetComponent(me, "VariableStorageComponent") or {}
for i = 1, #comps do
	local n = ComponentGetValue2(comps[i], "name")
	if n == "memory" then
		proj = ComponentGetValue2(comps[i], "value_string")
		mult = ComponentGetValue2(comps[i], "value_float")
	end
end

if ( player > 0 ) and ( #proj > 0 ) then
	local px,py = EntityGetTransform( player )
	local dir = math.atan((py - y) / (px - x))
	if px < x then dir = dir + math.pi end
	local vx, vy = math.cos(dir), math.sin(dir)

	local pid = ShootProjectile( me, proj, x + vx / 5, y + vx / 5, vx, vy, mult)
	EntityAddTag(pid, "resist_repulsion")
	local comp = EntityGetFirstComponent(pid, "ProjectileComponent")
	if comp then
		ComponentSetValue2(comp, "die_on_low_velocity", false)
		ComponentSetValue2(comp, "penetrate_world", true)
		ComponentSetValue2(comp, "penetrate_world_velocity_coeff", 1)
		ComponentObjectSetValue2(comp, "config_explosion", "explosion_sprite_emissive", true)
		ComponentSetValue2(comp, "spawn_entity", "")
	end
	local sprites = EntityGetComponent(pid, "SpriteComponent") or {}
	for i = 1, #sprites do
		ComponentSetValue2(sprites[i], "emissive", true)
		EntityRefreshSprite(pid, sprites[i])
	end
	local particles = EntityGetComponent(pid, "ParticleEmitterComponent") or {}
	for i = 1, #particles do
		ComponentSetValue2(particles[i], "render_back", false)
		ComponentSetValue2(particles[i], "cosmetic_force_create", true)
	end
	local velocity = EntityGetComponent(pid, "VelocityComponent") or {}
	for i = 1, #velocity do
		ComponentSetValue2(velocity[i], "liquid_drag", 0)
		ComponentSetValue2(velocity[i], "displace_liquid", false)
	end
	local celleater = EntityGetComponent(pid, "CellEaterComponent") or {}
	for i = 1, #celleater do
		ComponentSetValue2(celleater[i], "radius", 0)
	end
end