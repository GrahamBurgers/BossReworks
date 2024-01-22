function shot( entity_id )
    if #EntityGetWithTag("boss_fish") > 0 then
        local comps = EntityGetComponent(entity_id, "VelocityComponent") or {}
        for i = 1, #comps do
            ComponentSetValue2(comps[i], "displace_liquid", false)
        end
    end
end