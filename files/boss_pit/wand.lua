dofile_once("mods/boss_reworks/files/projectile_utils.lua")

local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local player = EntityGetClosestWithTag(x, y, "player_unit") or EntityGetClosestWithTag(x, y, "polymorphed_player")
local proj = ""
local mult = 1
local comps = EntityGetComponent(me, "VariableStorageComponent") or {}
for i = 1, #comps do
	local n = ComponentGetValue2(comps[i], "name")
	if n == "memory" then
		proj = ComponentGetValue2(comps[i], "value_string")
		mult = ComponentGetValue2(comps[i], "value_int")
	end
end

if ( player ~= nil ) and ( #proj > 0 ) then
	local px,py = EntityGetTransform( player )
	local dir = math.atan((py - y) / (px - x))
	if px < x then dir = dir + math.pi end

	local pid = ShootProjectile( me, proj, x, y, math.cos( dir ), math.sin( dir ), mult)
	local comp = EntityGetFirstComponent(pid, "ProjectileComponent")
	if comp then
		ComponentSetValue2(comp, "die_on_low_velocity", false)
		ComponentSetValue2(comp, "penetrate_world", true)
		ComponentSetValue2(comp, "penetrate_world_velocity_coeff", 1)
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
end