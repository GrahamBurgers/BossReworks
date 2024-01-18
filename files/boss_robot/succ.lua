local x, y = EntityGetTransform(GetUpdatedEntityID())
local mine = EntityGetFirstComponent(GetUpdatedEntityID(), "VelocityComponent")
if not mine then return end
local xv, yv = ComponentGetValue2(mine, "mVelocity")
local xold, yold = ComponentGetValue2(mine, "mPrevPosition")
EntitySetTransform(GetUpdatedEntityID(), xold, yold)
xv = xv * -1
yv = yv * -1
local entities = EntityGetInRadiusWithTag(x, y, 16, "hittable") or {}
local projectiles = EntityGetInRadiusWithTag(x, y, 16, "projectile") or {}
for i = 1, #entities do
    if EntityGetName(entities[i]) ~= "boss_reworks_succ" then
        local velco = EntityGetFirstComponent(entities[i], "CharacterDataComponent")
        if velco then
            local x3, y3 = ComponentGetValue2(velco, "mVelocity")
            ComponentSetValue2(velco, "mVelocity", x3 + xv, y3 + yv)
        end
    end
end
for i = 1, #projectiles do
    if EntityGetName(projectiles[i]) ~= "boss_reworks_succ" then
        local velco = EntityGetFirstComponent(projectiles[i], "VelocityComponent")
        if velco then
            local x3, y3 = ComponentGetValue2(velco, "mVelocity")
            ComponentSetValue2(velco, "mVelocity", x3 + xv, y3 + yv)
        end
    end
end
function calculate_force_for_body( entity, body_mass, body_x, body_y, body_vel_x, body_vel_y, body_vel_angular )
	local xv2 = xv * body_mass
	local yv2 = yv * body_mass

    return body_x,body_y,xv2,yv2,0 -- forcePosX,forcePosY,forceX,forceY,forceAngular
end
PhysicsApplyForceOnArea(calculate_force_for_body, GetUpdatedEntityID(), x - 10, y - 10, x + 10, y + 10)

local tick = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")
if tick == 180 then
    EntityAddComponent2(GetUpdatedEntityID(), "LifetimeComponent", {
        lifetime=40,
        fade_sprites=true,
    })
end