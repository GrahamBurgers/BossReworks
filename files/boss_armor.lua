---@diagnostic disable-next-line: lowercase-global
function damage_about_to_be_received(damage, x, y, entity_thats_responsible, critical_hit_chance)
	if damage < 0 then return damage, critical_hit_chance end
	if entity_thats_responsible == GetUpdatedEntityID() then damage = damage * 0.2 end
	local crit = (1 + (4 * (math.max(0, critical_hit_chance) / 100)))
	damage = damage * crit
	local comp = EntityGetFirstComponent(GetUpdatedEntityID(), "VariableStorageComponent", "boss_reworks_armor") or 0
	local health = EntityGetFirstComponent(GetUpdatedEntityID(), "DamageModelComponent") or 0
	local max_hp = ComponentGetValue2(health, "max_hp")
	local boss_armor = ComponentGetValue2(comp, "value_float") ^ 3
	local new_damage = 1 / ((boss_armor + damage) / max_hp + 1) * damage
	ComponentSetValue2(comp, "value_float", ComponentGetValue2(comp, "value_float") + new_damage)
	GamePrint(tostring(100 * (new_damage / damage)) .. "%")
	return new_damage, critical_hit_chance
end
