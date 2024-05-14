function damage_about_to_be_received(damage, x, y, entity_thats_responsible, crit_chance)
    local comp2 = EntityGetFirstComponent(GetUpdatedEntityID(), "VariableStorageComponent", "boss_wizard_mode")
    local mode = 1
    if comp2 then mode = ComponentGetValue2(comp2, "value_int") + 1 end
    if mode == 2 then
        return damage * 0.75, crit_chance
    elseif mode == 3 then
        return damage * 0.25, crit_chance
    else
        return damage, crit_chance
    end
end