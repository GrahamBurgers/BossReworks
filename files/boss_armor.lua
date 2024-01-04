---@diagnostic disable-next-line: lowercase-global
function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
    local comp = EntityGetFirstComponent(GetUpdatedEntityID(), "VariableStorageComponent", "boss_reworks_armor") or 0
    local max_hp = ComponentGetValue2(comp, "value_int")
    local boss_armor = ComponentGetValue2(comp, "value_float")
    local new_damage = math.max(damage * (1 - (4 * (boss_armor + damage / 2)) / max_hp), damage * 0.1)
    ComponentSetValue2(comp, "value_float", ComponentGetValue2(comp, "value_float") + new_damage)
    return new_damage, critical_hit_chance
end