dofile_once("mods/boss_reworks/files/projectile_utils.lua")
local x, y = EntityGetTransform(GetUpdatedEntityID())
local teleporters = EntityGetWithTag("boss_ghost_teleporter")
local target_entity = EntityGetClosestWithTag(x, y, "player_unit") or EntityGetClosestWithTag(x, y, "polymorphed_player") or 0
if target_entity > 0 then
    x, y = EntityGetTransform(target_entity)
end
local highest = 0
local highest_entity = GetUpdatedEntityID()
local x2, y2
for i = 1, #teleporters do
    x2, y2 = EntityGetTransform(teleporters[i])
    local distance = math.sqrt((x2 - x)^2 + (y2 - y)^2)
    if distance > highest then
        highest = distance
        highest_entity = teleporters[i]
    end
end
for i = 1, #teleporters do
    x2, y2 = EntityGetTransform(teleporters[i])
    if teleporters[i] == highest_entity then
        EntityApplyTransform(GetUpdatedEntityID(), x2, y2)
        local vel = EntityGetFirstComponent(GetUpdatedEntityID(), "VelocityComponent")
        if vel then ComponentSetValue2(vel, "mVelocity", 0, 0) end
    else
        ShootProjectileAtEntity(GetUpdatedEntityID(), "data/entities/animals/boss_ghost/boss_ghost_polyp.xml", x2, y2, target_entity, 0.3)
        ShootProjectile(GetUpdatedEntityID(), "data/entities/animals/boss_ghost/boss_ghost_polyp.xml", x2, y2, 0, 0, 1)
    end
end