function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
    local x = GlobalsGetValue("BR_BOSS_RUSH_PORTAL_X", "0")
    local y = GlobalsGetValue("BR_BOSS_RUSH_PORTAL_Y", "0")
    local next = string.lower(GlobalsGetValue("BR_BOSS_RUSH_PORTAL_NEXT", "0") or "")
    local entity = "mods/boss_reworks/files/boss_rush/portals/boss_rush_portal_" .. next .. ".xml"
    if ModDoesFileExist(entity) then
        EntityLoad(entity, x, y)
    end
end