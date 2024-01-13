local me = GetUpdatedEntityID()
local parent = EntityGetRootEntity(me)
local comp = EntityGetFirstComponent(me, "ParticleEmitterComponent")
if comp then
    local cx, cy = ComponentGetValue2(comp, "area_circle_radius")
    cx = cx - 1
    ComponentSetValue2(comp, "area_circle_radius", cx, cx)
    if cx < 1 then
        EntityConvertToMaterial(parent, "bone")
        EntityKill(parent)
        EntityKill(me)
        dofile("mods/boss_reworks/files/boss_limbs/necrobot_modified.lua")
    end
end