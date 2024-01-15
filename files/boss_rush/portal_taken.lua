local function steal_player_stuff()

end

function portal_teleport_used( entity_that_was_teleported, from_x, from_y, to_x, to_y )
    local funcs = {
        ["$br_boss_rush_portal_in"] = function()
            EntityLoad("mods/boss_reworks/files/boss_rush/rooms/intro_room.xml", to_x, to_y)
            if not GameHasFlagRun("br_boss_rush_intro") then
                GameAddFlagRun("br_boss_rush_intro")
                EntityLoad("mods/boss_reworks/files/boss_rush/boss_rush_book.xml", to_x, to_y + 20)
                EntityLoad("mods/boss_reworks/files/boss_rush/portals/boss_rush_portal_01.xml", to_x + 130, to_y - 60)
                EntityLoad("mods/boss_reworks/files/boss_rush/portals/boss_rush_portal_out.xml", to_x - 130, to_y - 60)
            end
        end,
        ["$br_boss_rush_portal_01"] = function()
            GlobalsSetValue("BR_BOSS_RUSH_HP_LEFT", "200")
            EntityLoad("mods/boss_reworks/files/boss_rush/rooms/boss_limbs.xml", to_x, to_y)
        end,
    }

    local name = EntityGetName(GetUpdatedEntityID())
    if funcs[name] and EntityHasTag(entity_that_was_teleported, "player_unit") then funcs[name]() end
    GlobalsSetValue("BR_BOSS_RUSH_PORTAL_X", tostring(to_x))
    GlobalsSetValue("BR_BOSS_RUSH_PORTAL_Y", tostring(to_y))
end