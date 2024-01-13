local x, y = EntityGetTransform(GetUpdatedEntityID())
local mine = EntityGetFirstComponent(GetUpdatedEntityID(), "VelocityComponent")
EntityRemoveTag(GetUpdatedEntityID(), "projectile")
EntityRemoveTag(GetUpdatedEntityID(), "hittable")
if not mine then return end
local xv, yv = ComponentGetValue2(mine, "mVelocity")
local xold, yold = ComponentGetValue2(mine, "mPrevPosition")
EntitySetTransform(GetUpdatedEntityID(), xold, yold)
xv = xv * -1
yv = yv * -1
local entities = EntityGetInRadiusWithTag(x, y, 12, "hittable") or {}
local projectiles = EntityGetInRadiusWithTag(x, y, 12, "projectile") or {}
for i = 1, #entities do
    local velco = EntityGetFirstComponent(entities[i], "CharacterDataComponent")
    if velco then
        local x3, y3 = ComponentGetValue2(velco, "mVelocity")
        ComponentSetValue2(velco, "mVelocity", x3 + xv, y3 + yv)
    end
end
for i = 1, #projectiles do
    local velco = EntityGetFirstComponent(projectiles[i], "VelocityComponent")
    if velco then
        local x3, y3 = ComponentGetValue2(velco, "mVelocity")
        ComponentSetValue2(velco, "mVelocity", x3 + xv, y3 + yv)
    end
end
function calculate_force_for_body( entity, body_mass, body_x, body_y, body_vel_x, body_vel_y, body_vel_angular )
	local xv2 = xv * body_mass
	local yv2 = yv * body_mass

    return body_x,body_y,xv2,yv2,0 -- forcePosX,forcePosY,forceX,forceY,forceAngular
end
PhysicsApplyForceOnArea(calculate_force_for_body, GetUpdatedEntityID(), x - 6, y - 6, x + 6, y + 6)
local toggle = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")
if toggle == 60 then
    EntityAddComponent2(GetUpdatedEntityID(), "LifetimeComponent", {
        lifetime=20,
        fade_sprites=true,
    })
end