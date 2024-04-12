function death()
    dofile_once( "data/scripts/perks/perk.lua" )
    local x, y = EntityGetTransform(GetUpdatedEntityID())
    perk_spawn( x, y - 20, "EDIT_WANDS_EVERYWHERE", true )
end