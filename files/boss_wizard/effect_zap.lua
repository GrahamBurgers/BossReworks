local me = GetUpdatedEntityID()
local parent = EntityGetRootEntity(me)
local comp = EntityGetFirstComponent(me, "ParticleEmitterComponent")
if comp then
    local cx, cy = ComponentGetValue2(comp, "area_circle_radius")
    cx = cx - 0.6
    ComponentSetValue2(comp, "area_circle_radius", cx, cx)
    if cx <= 5 then
        EntityAddTag(me, "br_effect_projectile")
        EntityAddComponent2(me, "LifetimeComponent", {
            lifetime=2
        })
        EntityRemoveComponent(me, GetUpdatedComponentID())
    end
end