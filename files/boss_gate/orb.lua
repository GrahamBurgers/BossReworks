local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local orbs = EntityGetInRadiusWithTag(x, y, 14, "boss_reworks_orb") or {}
local whoshot = ComponentGetValue2(EntityGetFirstComponent(me, "ProjectileComponent") or 0, "mWhoShot")
local go = false
for i = 1, #orbs do
    local whoshot2 = ComponentGetValue2(EntityGetFirstComponent(orbs[i], "ProjectileComponent") or 0, "mWhoShot")
    if whoshot ~= whoshot2 then
        go = true
        break
    end
end
function rotate_radians(x2, y2, radians)
    SetRandomSeed(x2 + 425909, y2 + GameGetFrameNum())
	local ca = math.cos(radians)
	local sa = math.sin(radians)
	local out_x = ca * x2 - sa * y2
	local out_y = sa * x2 + ca * y2
	return out_x, out_y
end
if go then
    for i = 1, #orbs do
        EntityKill(orbs[i])
    end
    local target_entity = EntityGetClosestWithTag(x, y, "player_unit") or EntityGetClosestWithTag(x, y, "polymorphed_player")
    dofile_once("mods/boss_reworks/files/projectile_utils.lua")
    Shoot_projectile( whoshot, "mods/boss_reworks/files/boss_gate/dart.xml", x, y, 0, 0, target_entity)
end