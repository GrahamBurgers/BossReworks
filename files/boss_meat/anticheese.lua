function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
    local comp = EntityGetFirstComponentIncludingDisabled(GetUpdatedEntityID(), "HitboxComponent", "hitbox_default")
    if comp and ComponentGetValue2(comp, "damage_multiplier") <= 0 then
        return 0, 0
    end
    return damage, critical_hit_chance
end