local proj = EntityGetFirstComponent(GetUpdatedEntityID(), "ProjectileComponent")
local me = GetUpdatedEntityID()
local comp, who, platforming, damage, vel
if proj then
    who = ComponentGetValue2(proj, "mWhoShot")
    comp = EntityGetFirstComponent(who, "CharacterDataComponent")
    platforming = EntityGetFirstComponent(who, "CharacterPlatformingComponent")
    damage = EntityGetFirstComponent(who, "DamageModelComponent")
    vel = EntityGetFirstComponent(me, "VelocityComponent")
end

if comp and proj and platforming and damage and vel then
    local toggle = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")
    ComponentSetValue2(damage, "air_in_lungs", ComponentGetValue2(damage, "air_in_lungs_max"))
    local x2, y2 = EntityGetTransform(who)
    if toggle == 1 then
        EntitySetTransform(me, x2, y2)
    else
        local vx, vy = ComponentGetValue2(vel, "mVelocity")
        local x, y = EntityGetTransform(me)
        local distance = math.sqrt((x2 - x)^2 + (y2 - y)^2)
        if distance < 50 then -- try not to spam when going through portals
            EntitySetTransform(who, x, y)
        else
            EntityKill(me)
        end
        local gravity = ComponentGetValue2(platforming, "pixel_gravity") / -60.0106489103
        ComponentSetValue2(comp, "mVelocity", vx, vy + gravity) -- how do we trigger fast camera?
    end
end
local toggle = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")
if toggle == 1 then
    local entities = EntityGetWithTag("br_spellname_levi") or {}
    for i = 1, #entities do
        local proj2 = EntityGetFirstComponent(entities[i], "ProjectileComponent")
        local particles = EntityGetFirstComponent(entities[i], "ParticleEmitterComponent")
        if proj2 and particles and ComponentGetValue2(proj2, "mWhoShot") == who and entities[i] < GetUpdatedEntityID() then
            EntityKill(entities[i])
        end
    end
end