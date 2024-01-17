---@diagnostic disable-next-line: lowercase-global
function damage_about_to_be_received(damage, x, y, entity_thats_responsible, critical_hit_chance)
	local comp = EntityGetFirstComponent(GetUpdatedEntityID(), "VariableStorageComponent", "boss_reworks_armor") or 0
	local health = EntityGetFirstComponent(GetUpdatedEntityID(), "DamageModelComponent") or 0
	local max_hp = ComponentGetValue2(health, "max_hp")
	local boss_armor = ComponentGetValue2(comp, "value_float")
	local expected_damage = math.min(damage * (1 + critical_hit_chance / 100), max_hp)
	local new_damage = math.exp(-2 * (2 * boss_armor + expected_damage) / max_hp) *
	damage                                                                          -- todo calculus says this is sort of stupid, y' at x=m is 0 therefo i thin the function should be monotonically increasing
	ComponentSetValue2(comp, "value_float", ComponentGetValue2(comp, "value_float") + new_damage)
	return new_damage, critical_hit_chance
end
