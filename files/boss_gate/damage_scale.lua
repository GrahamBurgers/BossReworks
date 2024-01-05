local me = GetUpdatedEntityID()
local comp = EntityGetFirstComponent(me, "DamageModelComponent") or 0
local ratio = ComponentGetValue2(comp, "hp") / ComponentGetValue2(comp, "max_hp")
local amount = 40 - 20 * ratio
comp = EntityGetFirstComponent(me, "AreaDamageComponent") or 0
ComponentSetValue2(comp, "aabb_min", 0 - amount, 0 - amount)
ComponentSetValue2(comp, "aabb_max", amount, amount)
comp = EntityGetFirstComponent(me, "ParticleEmitterComponent") or 0
ComponentSetValue2(comp, "area_circle_radius", amount, amount)
if GameGetFrameNum() % 180 == 0 and #EntityGetWithTag("gate_monster") > 1 then
	local x, y = EntityGetTransform(me)
	local how_many = 8
	local angle_inc = (2 * 3.14159) / how_many
	local theta = 0
	local length = 90

	for i = 1, how_many do
		local vel_x = math.cos(theta) * length
		local vel_y = math.sin(theta) * length
		theta = theta + angle_inc

		local px = x + vel_x * 0.1
		local py = y + vel_y * 0.1

		GameEntityPlaySound(me, "duplicate")
		dofile_once("mods/boss_reworks/files/projectile_utils.lua")
		ShootProjectile(me, "mods/boss_reworks/files/boss_gate/orb.xml", px, py, vel_x, vel_y)
	end
end
