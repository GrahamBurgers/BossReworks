local me = GetUpdatedEntityID()
local parent = EntityGetRootEntity(me)
local comp = EntityGetFirstComponent(me, "ParticleEmitterComponent")
if comp then
    local cx, cy = ComponentGetValue2(comp, "area_circle_radius")
    cx = cx - 1
    ComponentSetValue2(comp, "area_circle_radius", cx, cx)
    if cx < 1 then
        local x, y = EntityGetTransform(parent)
        local boss = EntityGetClosestWithTag(x, y, "boss_limbs")
        if boss then
            local damagemodel = EntityGetFirstComponent(boss, "DamageModelComponent")
            if not damagemodel then return end
            local max_hp = ComponentGetValue2(damagemodel, "max_hp")
            EntityInflictDamage(boss, max_hp / -6, "DAMAGE_HEALING", "$damage_healing", "NORMAL", 0, 0, parent)
            EntityConvertToMaterial(parent, "radioactive_gas")
            EntityKill(parent)
        end
        EntityKill(me)
    end
end