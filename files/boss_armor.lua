---@diagnostic disable-next-line: lowercase-global
function damage_about_to_be_received(damage, x, y, entity_thats_responsible, critical_hit_chance)
	if damage < 0 then return damage, critical_hit_chance end
	local comp = EntityGetFirstComponent(GetUpdatedEntityID(), "VariableStorageComponent", "boss_reworks_armor") or 0
	local max_hp = ComponentGetValue2(comp, "value_int")
	local boss_armor = ComponentGetValue2(comp, "value_float")
	local new_damage = 1 / ((2 * boss_armor + 0.99 * damage) / max_hp + 1) * damage
	ComponentSetValue2(comp, "value_float", ComponentGetValue2(comp, "value_float") + new_damage)
	return new_damage, critical_hit_chance
end
