function shot( entity_id )
    local proj = EntityGetComponentIncludingDisabled(entity_id, "ProjectileComponent") or {}
    for i = 1, #proj do
        local crumblies = ComponentObjectGetValue2(proj[i], "config_explosion", "load_this_entity")
        crumblies = crumblies:gsub("data/entities/misc/loose_ground.xml", "")
        ComponentObjectSetValue2(proj[i], "config_explosion", "load_this_entity", crumblies)
        ComponentObjectSetValue2(proj[i], "config_explosion", "stains_enabled", false)
        ComponentObjectSetValue2(proj[i], "config_explosion", "hole_enabled", false)
        ComponentObjectSetValue2(proj[i], "config_explosion", "max_durability_to_destroy", -1)
    end
end