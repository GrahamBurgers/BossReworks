local function steal_player_stuff()

end

local function boss_portal(to_x, to_y, entity, x_off, y_off)
    local eid = EntityLoad("mods/boss_reworks/files/boss_rush/boss_in_portal.xml", to_x + x_off, to_y + y_off)
    EntityAddComponent2(eid, "VariableStorageComponent", {
        value_string=entity
    })
end

local function load_scene(x, y, size_x, size_y, room_name, amount)
    local y2 = y + size_y * -0.5
    if amount == 1 then
        LoadPixelScene(table.concat({"mods/boss_reworks/files/boss_rush/rooms/", room_name, ".png"}), "", x + size_x * -0.5, y2, "", true, false, {}, 50, true)
    else
        for i = 1, amount do
            LoadPixelScene(table.concat({"mods/boss_reworks/files/boss_rush/rooms/", room_name, "_", i, ".png"}), "", x + size_x * -0.5, y2, "", true, false, {}, 50, true)
            y2 = y2 + size_y
        end
    end
end

function portal_teleport_used( entity_that_was_teleported, from_x, from_y, to_x, to_y )
    local funcs = {
        ["$br_boss_rush_portal_in"] = function()
            if not GameHasFlagRun("br_boss_rush_intro") then
                load_scene(to_x, to_y, 346, 232, "intro_room", 1)
                GameAddFlagRun("br_boss_rush_intro")
                EntityLoad("mods/boss_reworks/files/boss_rush/boss_rush_book.xml", to_x, to_y + 30)
                EntityLoad("mods/boss_reworks/files/boss_rush/portals/boss_rush_portal_pyramid.xml", to_x + 130, to_y - 60)
                EntityLoad("mods/boss_reworks/files/boss_rush/portals/boss_rush_portal_out.xml", to_x - 130, to_y - 60)
            end
        end,
        ["$br_boss_rush_portal_pyramid"] = function()
            GlobalsSetValue("BR_BOSS_RUSH_ACTIVE", "1")
            GlobalsSetValue("BR_BOSS_RUSH_HP_LEFT", tostring(200 * 100))
            GlobalsSetValue("BR_BOSS_RUSH_PORTAL_NEXT", "dragon")
            load_scene(to_x, to_y, 408, 264, "arena_pyramid", 1)
            boss_portal(to_x, to_y, "data/entities/animals/boss_limbs/boss_limbs.xml", 130, -60)
        end,
        ["$br_boss_rush_portal_dragon"] = function()
            EntityKill(GetUpdatedEntityID())
            GlobalsSetValue("BR_BOSS_RUSH_PORTAL_NEXT", "forgotten")
            load_scene(to_x, to_y, 432, 432, "arena_dragon", 1)
            boss_portal(to_x, to_y, "data/entities/animals/boss_dragon.xml", 0, 80)
        end,
        ["$br_boss_rush_portal_forgotten"] = function()
            EntityKill(GetUpdatedEntityID())
            EntityLoad("data/entities/items/pickup/evil_eye.xml", to_x, to_y)
            GlobalsSetValue("BR_BOSS_RUSH_PORTAL_NEXT", "forgotten")
            load_scene(to_x, to_y, 460, 337, "arena_forgotten", 1)
            boss_portal(to_x, to_y, "data/entities/animals/boss_ghost/boss_ghost.xml", 0, -80)
        end,
    }

    local name = EntityGetName(GetUpdatedEntityID())
    if funcs[name] and EntityHasTag(entity_that_was_teleported, "player_unit") then funcs[name]() end
    GlobalsSetValue("BR_BOSS_RUSH_PORTAL_X", tostring(to_x))
    GlobalsSetValue("BR_BOSS_RUSH_PORTAL_Y", tostring(to_y))
end