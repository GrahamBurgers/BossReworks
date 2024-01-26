function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
    local x = GlobalsGetValue("BR_BOSS_RUSH_PORTAL_X", "0")
    local y = GlobalsGetValue("BR_BOSS_RUSH_PORTAL_Y", "0")
    local next = GlobalsGetValue("BR_BOSS_RUSH_PORTAL_NEXT", "") or ""
    local entity = EntityLoad("mods/boss_reworks/files/boss_rush/portals/boss_rush_portal_base.xml", x, y)
    EntitySetName(entity, next)
    local ui = EntityGetFirstComponent(entity, "UIInfoComponent")
    if ui then
        ComponentSetValue2(ui, "name", next)
    end
end