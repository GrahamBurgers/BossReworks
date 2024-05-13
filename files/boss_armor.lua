local setting = ModSettingGet("boss_reworks.boss_armor_intensity")
local values = {
	["Default"] = 0.5,
	["Weak"] = 0.2,
	["Off"] = 0,
	["Strong"] = 0.8,
}
local _DAMAGERESISTANCEAT100 = values[setting] or 0.2 --damage to resist when you would deal 100% damage. this should be less than or equal to 1

function damage_about_to_be_received(damage, x, y, entity_thats_responsible, critical_hit_chance)
    if damage < 0 or GameGetGameEffectCount(GetUpdatedEntityID(), "PROTECTION_ALL") > 0 then return damage, critical_hit_chance end
    local comp = EntityGetFirstComponent(GetUpdatedEntityID(), "VariableStorageComponent", "boss_reworks_armor") or 0
    local health_component = EntityGetFirstComponent(GetUpdatedEntityID(), "DamageModelComponent") or 0
    local max_hp = ComponentGetValue2(health_component, "max_hp")
    local crit_res = ComponentGetValue2(health_component, "critical_damage_resistance")
    local recent_relative_damage = ComponentGetValue2(comp, "value_float")
    
    local expected_damage = damage + damage*(1-crit_res)*(critical_hit_chance*5-1)
    local relative_damage= expected_damage/max_hp
    recent_relative_damage=recent_relative_damage+relative_damage
    ComponentSetValue2(comp, "value_float", recent_relative_damage)
    
    local armor_multipler = -_DAMAGERESISTANCEAT100/(_DAMAGERESISTANCEAT100-1) --intermediate step to make it easier to read.
    local armor= 1-(1/(armor_multipler*recent_relative_damage+1))
	-- GamePrint(tostring(armor))
    
    local new_damage=(1 - armor) * damage
    
    return new_damage, critical_hit_chance
end