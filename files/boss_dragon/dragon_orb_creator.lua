local me = GetUpdatedEntityID()
local comp = EntityGetFirstComponent(me, "SpriteParticleEmitterComponent")
local x, y = EntityGetTransform(me)
local player = EntityGetClosestWithTag(x, y, "player_unit") or EntityGetClosestWithTag(x, y, "polymorphed_player")
if comp ~= nil then
	local xs, ys = ComponentGetValue2(comp, "scale")
	xs = xs + (0.5 - xs) / 5
	ys = ys + (0.5 - ys) / 5
	ComponentSetValue2(comp, "scale", xs, ys)
end
local vel = EntityGetFirstComponent(me, "VelocityComponent")
if vel and ComponentGetValue2(vel, "mVelocity") == 0 and player ~= nil then
	local x2, y2 = EntityGetTransform(player)
	local newx, newy
	if x2 > x then newx = 90 else newx = -90 end
	if y2 > y then newy = -90 else newy = 90 end
	ComponentSetValue2(vel, "mVelocity", newx, newy)
end

local toggle = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")
if (toggle + 1) % 20 == 0 then
	if player ~= nil then
		dofile_once("mods/boss_reworks/files/projectile_utils.lua")
		local px, py = EntityGetTransform(player)
		local theta = math.atan((py - y) / (px - x))
		theta = theta + ((math.random() > 0.5) and -0.32 or 0.32)
		if px < x then theta = theta + math.pi end
		ShootProjectile(me, "mods/boss_reworks/files/boss_dragon/dragon_orb.xml", x, y, math.cos(theta), math.sin(theta), 0.4)
	end
end
