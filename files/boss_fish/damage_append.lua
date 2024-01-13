damage_received_but_cooler = damage_received

function damage_received( damage, desc, entity_who_caused, is_fatal )
    local damagemodel = EntityGetFirstComponent(GetUpdatedEntityID(), "DamageModelComponent")
    if damagemodel then
        local max_hp = ComponentGetValue2(damagemodel, "max_hp")
        local hp = ComponentGetValue2(damagemodel, "hp")
        local threshold = 100

        for i = 1, threshold do
            if hp >= max_hp / (threshold / i) and hp - damage < max_hp / (threshold / i) then
                damage_received_but_cooler( damage, desc, entity_who_caused, is_fatal )
            end
        end

        local c = EntityGetFirstComponent( GetUpdatedEntityID(), "SpriteComponent", "health_bar" )
        if c then ComponentSetValue2( c, "visible", true ) end
        c = EntityGetFirstComponent( GetUpdatedEntityID(), "SpriteComponent", "health_bar_back" )
        if c then ComponentSetValue2( c, "visible", true ) end
    end
end