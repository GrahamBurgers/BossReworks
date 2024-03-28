function damage_received( damage, desc, entity_who_caused, is_fatal )
    local damagemodel = EntityGetFirstComponent(GetUpdatedEntityID(), "DamageModelComponent")
    if damagemodel and damage > 0 then
        local max_hp = ComponentGetValue2(damagemodel, "max_hp")
        local hp = ComponentGetValue2(damagemodel, "hp")
        local threshold = 75

        for i = 1, threshold do
            if hp >= max_hp / (threshold / i) and hp - damage < max_hp / (threshold / i) then
                local entity_id = GetUpdatedEntityID()
                local x, y = EntityGetTransform( entity_id )
                dofile("mods/boss_reworks/files/projectile_utils.lua")
                ShootProjectileAtEntity( entity_id, "data/entities/animals/boss_fish/orb_big.xml", x, y + 48, entity_who_caused, 0.9, true )
            end
        end

        local c = EntityGetFirstComponent( GetUpdatedEntityID(), "SpriteComponent", "health_bar" )
        if c then ComponentSetValue2( c, "visible", true ) end
        c = EntityGetFirstComponent( GetUpdatedEntityID(), "SpriteComponent", "health_bar_back" )
        if c then ComponentSetValue2( c, "visible", true ) end
    end
end