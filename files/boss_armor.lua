---@diagnostic disable-next-line: lowercase-global
function damage_about_to_be_received(damage, x, y, entity_thats_responsible, critical_hit_chance)
	if damage < 0 then return damage, critical_hit_chance end
	local comp = EntityGetFirstComponent(GetUpdatedEntityID(), "VariableStorageComponent", "boss_reworks_armor") or 0
	local health = EntityGetFirstComponent(GetUpdatedEntityID(), "DamageModelComponent") or 0
	local max_hp = ComponentGetValue2(health, "max_hp")
	local recent_relative_damage = ComponentGetValue2(comp, "value_float")
	local expected_damage = damage *
		((critical_hit_chance < 100) and (5 * critical_hit_chance / 100 + (1 - critical_hit_chance / 100)) or (critical_hit_chance * 0.05))
	local relative_damage = expected_damage / max_hp
	local temp_armor = math.min((recent_relative_damage + relative_damage / 2) ^ 4, 0.999)
	-- print(temp_armor)
	local new_damage = (1 - temp_armor) * damage
	local negated = damage - new_damage
	GlobalsSetValue("boss_reworks_armor_dbg",
		tostring(tonumber(GlobalsGetValue("boss_reworks_armor_dbg", "0")) + negated))
	ComponentSetValue2(comp, "value_float", recent_relative_damage + relative_damage)
	return new_damage, critical_hit_chance
end
