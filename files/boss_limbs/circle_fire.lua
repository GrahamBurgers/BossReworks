local me = GetUpdatedEntityID()
local parent = EntityGetRootEntity(me)
local comp = EntityGetFirstComponent(me, "ParticleEmitterComponent")
if comp then
    local cx, cy = ComponentGetValue2(comp, "area_circle_radius")
    cx = cx - 1
    ComponentSetValue2(comp, "area_circle_radius", cx, cx)
    if cx < 1 then
        local x, y = EntityGetTransform(parent)
        EntityLoad("mods/boss_reworks/files/boss_limbs/fireball.xml", x, y)
        EntityConvertToMaterial(parent, "smoke")
        EntityKill(parent)
        EntityKill(me)
    end
end