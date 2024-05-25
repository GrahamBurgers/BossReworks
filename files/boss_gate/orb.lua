local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local x2, y2 = 0, 0
local orbs = EntityGetInRadiusWithTag(x, y, 14, "boss_reworks_orb") or {}
local whoshot = ComponentGetValue2(EntityGetFirstComponent(me, "ProjectileComponent") or 0, "mWhoShot")
local go = false
for i = 1, #orbs do
	local whoshot2 = ComponentGetValue2(EntityGetFirstComponent(orbs[i], "ProjectileComponent") or 0, "mWhoShot")
	if whoshot ~= whoshot2 then
		go = true
		x2, y2 = EntityGetTransform(orbs[i])
		break
	end
end

if go then
	for i = 1, #orbs do
		EntityKill(orbs[i])
	end
	local player = EntityGetClosestWithTag(x, y, "player_unit") or 0
	if player == 0 then
		player = EntityGetClosestWithTag(x, y, "polymorphed_player") or 0
	end
	dofile_once("mods/boss_reworks/files/projectile_utils.lua")
	if player > 0 then
		ShootProjectileAtEntity(whoshot, "mods/boss_reworks/files/boss_gate/dart.xml", (x + x2) / 2, (y + y2) / 2, player)
	end
end
