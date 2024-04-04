local comp = EntityGetFirstComponent(GetUpdatedEntityID(), "VariableStorageComponent")
local x, y = EntityGetTransform(GetUpdatedEntityID())
local mode = GlobalsGetValue("BR_MODE", "0")
if comp then
    local thing = ComponentGetValue2(comp, "value_string")
    local eid = EntityLoad(thing, x, y)
    local comps = EntityGetAllComponents(eid) or {}
    for i = 1, #comps do
        ComponentAddTag(comps[i], "boss_reworks_rush_remove")
        if ComponentGetTypeName(comps[i]) == "CellEaterComponent" then
            ComponentSetValue2(comps[i], "ignored_material", CellFactory_GetType("boss_reworks_templebrick_indestructible"))
            ComponentSetValue2(comps[i], "radius", 0)
            ComponentSetValue2(comps[i], "eat_probability", 0)
            ComponentSetValue2(comps[i], "only_stain", true)
        end
        if ComponentGetTypeName(comps[i]) == "DamageModelComponent" then
            ComponentSetValue2(comps[i], "blood_material", "plasma_fading")
            ComponentSetValue2(comps[i], "blood_multiplier", 0)
            ComponentSetValue2(comps[i], "ragdoll_material", "blood_fungi")
            ComponentSetValue2(comps[i], "materials_damage", false)

            local name = string.gsub(EntityGetName(eid), "%$", "") -- format like GameAddFlagRun("br_killed_animal_boss_pit")
            if not GameHasFlagRun("br_killed_" .. name) and not (mode == "Calamari" or mode == "Boss Rush") then
                ComponentSetValue2(comps[i], "hp", ComponentGetValue2(comps[i], "hp") * 1.2)
                ComponentSetValue2(comps[i], "max_hp", ComponentGetValue2(comps[i], "max_hp") * 1.2)
            end
        end
        if ComponentHasTag(comps[i], "magic_eye") then
            EntitySetComponentIsEnabled(eid, comps[i], true)
            ComponentRemoveTag(comps[i], "magic_eye")
        end
        -- put this at the bottom, else it errors after removed
        if ComponentGetTypeName(comps[i]) == "LuaComponent" and not mode == "Calamari" then
            if ComponentGetValue2(comps[i], "script_death") and string.len(ComponentGetValue2(comps[i], "script_death")) > 0 then
                EntityRemoveComponent(eid, comps[i])
            end
        end
        if ComponentGetTypeName(comps[i]) == "PhysicsBodyComponent" then
            ComponentSetValue2(comps[i], "on_death_leave_physics_body", false)
        end
    end
    EntityAddTag(eid, "boss_reworks_boss_rush")
    EntityAddTag(eid, "boss_reworks_this_is_boss")
    EntityAddComponent2(eid, "LuaComponent", {
        execute_every_n_frame=-1,
        script_death="mods/boss_reworks/files/boss_rush/boss_death.lua",
        script_shot="mods/boss_reworks/files/boss_rush/stop_breaking_everything.lua",
    })
end
EntityKill(GetUpdatedEntityID())