local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local distance_full = 80
local multiplier = 0.14
local vel = EntityGetFirstComponent(me, "VelocityComponent")
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
if not vel or not proj then return end
local vx, vy = ComponentGetValue2(vel, "mVelocity")
vx, vy = vx * multiplier, vy * multiplier

function calculate_force_for_body(entity, body_mass, body_x, body_y, body_vel_x, body_vel_y, body_vel_angular)
    local fx = vx * body_mass * 6
    local fy = vy * body_mass * 6

    return body_x,body_y,fx,fy,0 -- forcePosX,forcePosY,forceX,forceY,forceAngular
end
local size = distance_full * 0.5
PhysicsApplyForceOnArea(calculate_force_for_body, me, x-size, y-size, x+size, y+size)

local entities = EntityGetInRadiusWithTag(x, y, distance_full, "hittable") or {}
for i = 1, #entities do
    local cd = EntityGetFirstComponent(entities[i], "CharacterDataComponent")
    if cd and entities[i] ~= ComponentGetValue2(proj, "mWhoShot") and #PhysicsBodyIDGetFromEntity(entities[i]) == 0 then
        local x2, y2 = ComponentGetValue2(cd, "mVelocity")
        x2 = x2 + vx * 2
        y2 = y2 + vy * 2
        ComponentSetValue2(cd, "mVelocity", x2, y2)
    end
end

local projectiles = EntityGetInRadiusWithTag(x, y, distance_full, "projectile") or {}
for i = 1, #projectiles do
    local cd = EntityGetFirstComponent(projectiles[i], "VelocityComponent")
    if cd and #PhysicsBodyIDGetFromEntity(projectiles[i]) == 0 then
        local x2, y2 = ComponentGetValue2(cd, "mVelocity")
        x2 = x2 + vx * 1.8
        y2 = y2 + vy * 1.8
        ComponentSetValue2(cd, "mVelocity", x2, y2)
    end
end