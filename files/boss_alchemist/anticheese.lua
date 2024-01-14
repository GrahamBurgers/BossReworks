function damage_about_to_be_received(damage, x, y, entity_thats_responsible, critical_hit_chance)
	local comp = EntityGetFirstComponent(GetUpdatedEntityID(), "HitboxComponent")
	if comp and ComponentGetValue2(comp, "damage_multiplier") <= 0.01 then
		return 0, 0
	end
	return damage, critical_hit_chance
end
