local x, y = EntityGetTransform(GetUpdatedEntityID())
local mine = EntityGetFirstComponent(GetUpdatedEntityID(), "VelocityComponent")
local proj = EntityGetFirstComponent(GetUpdatedEntityID(), "ProjectileComponent")
if not mine or not proj then return end
local boss = ComponentGetValue2(proj, "mWhoShot")
local x2 = ComponentGetValue2(proj, "ragdoll_force_multiplier")
local y2 = ComponentGetValue2(proj, "hit_particle_force_multiplier")
local bx, by = EntityGetTransform(boss)
local xv, yv = ComponentGetValue2(mine, "mVelocity")
if bx and by then EntitySetTransform(GetUpdatedEntityID(), bx + x2, by + y2) end
xv = xv * -1
yv = yv * -1
local tick = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")
if tick <= 12 then return end

local entities = EntityGetInRadiusWithTag(x, y, 16, "hittable") or {}
local projectiles = EntityGetInRadiusWithTag(x, y, 16, "projectile") or {}
for i = 1, #entities do
    local velco = EntityGetFirstComponent(entities[i], "CharacterDataComponent")
    if velco then
        local x3, y3 = ComponentGetValue2(velco, "mVelocity")
        ComponentSetValue2(velco, "mVelocity", x3 + xv, y3 + yv)
    end
end
for i = 1, #projectiles do
    local proj2 = EntityGetFirstComponent(projectiles[i], "ProjectileComponent")
    if proj2 and ComponentGetValue2(proj2, "mWhoShot") ~= boss then
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

if tick == 200 then
    EntityAddComponent2(GetUpdatedEntityID(), "LifetimeComponent", {
        lifetime=20,
        fade_sprites=true,
    })
end