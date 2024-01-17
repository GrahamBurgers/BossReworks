local comp = EntityGetFirstComponent(GetUpdatedEntityID(), "VariableStorageComponent")
local x, y = EntityGetTransform(GetUpdatedEntityID())
if comp then
    local string = ComponentGetValue2(comp, "value_string")
    local eid = EntityLoad(string, x, y)
    local comps = EntityGetAllComponents(eid) or {}
    for i = 1, #comps do
        ComponentAddTag(comps[i], "boss_reworks_rush_remove")
        if ComponentGetTypeName(comps[i]) == "CellEaterComponent" then
            ComponentSetValue2(comps[i], "ignored_material", CellFactory_GetType("boss_reworks_templebrick_indestructible"))
        end
        if ComponentGetTypeName(comps[i]) == "DamageModelComponent" then
            ComponentSetValue2(comps[i], "blood_material", "plasma_fading")
            ComponentSetValue2(comps[i], "blood_multiplier", 0)
            ComponentSetValue2(comps[i], "ragdoll_material", "blood_fungi")
            ComponentSetValue2(comps[i], "materials_damage", false)
        end
        if ComponentGetTypeName(comps[i]) == "LuaComponent" then
            if ComponentGetValue2(comps[i], "script_death") and string.len(ComponentGetValue2(comps[i], "script_death")) > 0 then
                EntityRemoveComponent(eid, comps[i])
            end
        end
    end
    EntityAddTag(eid, "boss_reworks_boss_rush")
    EntityAddComponent2(eid, "LuaComponent", {
        execute_every_n_frame=-1,
        script_death="mods/boss_reworks/files/boss_rush/boss_death.lua"
    })
end
EntityKill(GetUpdatedEntityID())