dofile( "data/scripts/perks/perk.lua" )

function item_pickup( entity_item, entity_who_picked, item_name )
    local x, y = EntityGetTransform(entity_who_picked)
	local components = EntityGetComponent(entity_item, "VariableStorageComponent", "br_boss_rush_storage") or {}
    for i = 1, #components do
        local id = ComponentGetValue2(components[i], "value_string")
        local entity = perk_spawn( x, y, id, true )
	    perk_pickup( entity, entity_who_picked, id, false, false, false)
    end
    local mode = GlobalsGetValue("BR_MODE", "0")
    if mode ~= "bossrush" then
        EntityLoad("mods/boss_reworks/files/boss_rush/portals/boss_rush_portal_out.xml", 6270, 49940 + 25)
    else
        EntityLoad("mods/boss_reworks/files/boss_rush/portals/boss_rush_portal_spawn.xml", 6270, 49940 + 25)
    end
    EntityKill(entity_item)
end