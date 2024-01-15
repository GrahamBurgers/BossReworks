local function steal_player_stuff()

end

local function load_scene(x, y, size_x, size_y, room_name, amount)
    local y2 = y + size_y * -0.5
    for i = 1, amount do
        LoadPixelScene(table.concat({"mods/boss_reworks/files/boss_rush/rooms/", room_name, "_", i, ".png"}), "", x + size_x * -0.5, y2, "", true, false, {}, 50, true)
        y2 = y2 + size_y
    end
end

function portal_teleport_used( entity_that_was_teleported, from_x, from_y, to_x, to_y )
    local funcs = {
        ["$br_boss_rush_portal_in"] = function()
            load_scene(to_x, to_y, 346, 232, "intro_room", 1)
            if not GameHasFlagRun("br_boss_rush_intro") then
                GameAddFlagRun("br_boss_rush_intro")
                EntityLoad("mods/boss_reworks/files/boss_rush/boss_rush_book.xml", to_x, to_y + 20)
                EntityLoad("mods/boss_reworks/files/boss_rush/portals/boss_rush_portal_01.xml", to_x + 130, to_y - 60)
                EntityLoad("mods/boss_reworks/files/boss_rush/portals/boss_rush_portal_out.xml", to_x - 130, to_y - 60)
            end
        end,
        ["$br_boss_rush_portal_01"] = function()
            GlobalsSetValue("BR_BOSS_RUSH_HP_LEFT", "200")
            load_scene(to_x, to_y, 432, 264, "boss_limbs", 1)
        end,
    }

    local name = EntityGetName(GetUpdatedEntityID())
    if funcs[name] and EntityHasTag(entity_that_was_teleported, "player_unit") then funcs[name]() end
    GlobalsSetValue("BR_BOSS_RUSH_PORTAL_X", tostring(to_x))
    GlobalsSetValue("BR_BOSS_RUSH_PORTAL_Y", tostring(to_y))
end