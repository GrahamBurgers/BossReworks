function shot( entity_id )
    if EntityGetWithTag("boss_reworks_fish") then
        local comps = EntityGetComponent(entity_id, "VelocityComponent") or {}
        for i = 1, #comps do
            ComponentSetValue2(comps[i], "displace_liquid", false)
        end
    end
end