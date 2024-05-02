local comps = EntityGetAllComponents(GetUpdatedEntityID())
for i = 1, #comps do
    EntitySetComponentIsEnabled(GetUpdatedEntityID(), comps[i], true)
    if ComponentGetTypeName(comps[i]) == "SpriteComponent" then
        ComponentSetValue2(comps[i], "alpha", 1.0)
    end
    if ComponentGetTypeName(comps[i]) == "VelocityComponent" then
        local vx, vy = ComponentGetValue2(comps[i], "mVelocity")
        ComponentSetValue2(comps[i], "mVelocity", vx * 20, vy * 20)
    end
    if ComponentGetTypeName(comps[i]) == "ParticleEmitterComponent" and ComponentGetValue2(comps[i], "emitted_material_name") == "fire" then
        ComponentSetValue2(comps[i], "is_emitting", false)
    end
end