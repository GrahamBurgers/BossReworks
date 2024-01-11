function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
    local comp = EntityGetFirstComponentIncludingDisabled(GetUpdatedEntityID(), "HitboxComponent", "hitbox_weak_spot")
    if comp and ComponentGetIsEnabled(comp) == false and damage > 0 then
        return 0, 0
    end
    return damage, critical_hit_chance
end