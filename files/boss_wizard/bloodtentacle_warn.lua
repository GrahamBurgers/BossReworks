dofile_once("mods/boss_reworks/files/projectile_utils.lua")
local me = GetUpdatedEntityID()
local mine = EntityGetFirstComponent(me, "VelocityComponent")
if not mine then return end
local x, y = ComponentGetValue2(mine, "mPrevPosition")
local xv, yv = ComponentGetValue2(mine, "mVelocity")
EntitySetTransform(me, x, y)

local action = 60
local comp = EntityGetFirstComponent(me, "SpriteComponent")
if comp then
    ComponentSetValue2(comp, "alpha", ComponentGetValue2(comp, "alpha") + 1 / action)
end

local toggle = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")
if toggle >= action then
    local eid = ShootProjectile(me, "mods/boss_reworks/files/boss_wizard/bloodtentacle_new.xml", x, y, xv, yv)
    -- hax to make the tentacles not stick to his stupid hand
    local parent = EntityGetRootEntity(eid)
    if parent ~= eid then
        EntityRemoveFromParent(eid)
        local child = EntityGetAllChildren(parent)[1]
        if child then
            EntityAddChild(child, eid)
        end
    end
    EntityKill(GetUpdatedEntityID())
end