local proj = EntityGetFirstComponent(GetUpdatedEntityID(), "ProjectileComponent")
local comp, who, platforming
if proj then
    who = ComponentGetValue2(proj, "mWhoShot")
    comp = EntityGetFirstComponent(who, "CharacterDataComponent")
    platforming = EntityGetFirstComponent(who, "CharacterPlatformingComponent")
end
if comp and proj and platforming then
    local gravity = ComponentGetValue2(platforming, "pixel_gravity") / -60.0106489103
    local x, y = EntityGetTransform(who)
    local xv, yv = ComponentGetValue2(comp, "mVelocity")
    ComponentSetValue2(comp, "mVelocity", xv, gravity)
    EntitySetTransform(GetUpdatedEntityID(), x, y - 3.5)
end
local toggle = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")
if toggle == 0 then
    local entities = EntityGetWithTag("br_spellname_limbs") or {}
    for i = 1, #entities do
        local proj2 = EntityGetFirstComponent(entities[i], "ProjectileComponent")
        if proj2 and ComponentGetValue2(proj2, "mWhoShot") == who and entities[i] ~= GetUpdatedEntityID() then
            EntityKill(entities[i])
        end
    end
end