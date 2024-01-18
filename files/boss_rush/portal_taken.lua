local multiplier = 100 -- multiply it before storing cause shoving a float into an int scares me
local max = 400 * multiplier

local function aaaaaa(entity)
    if EntityGetComponentIncludingDisabled(entity, "ItemComponent") ~= nil then
        EntityRemoveFromParent(entity)
        EntitySetComponentsWithTagEnabled(entity, "enabled_in_hand", false)
        EntitySetComponentsWithTagEnabled(entity, "enabled_in_inventory", false)
        EntitySetComponentsWithTagEnabled(entity, "enabled_in_world", true)
        local vel = EntityGetFirstComponentIncludingDisabled(entity, "VelocityComponent")
        if vel then EntitySetComponentIsEnabled(entity, vel, false) end
        local isphysics = false
        local phys = EntityGetFirstComponentIncludingDisabled(entity, "PhysicsBodyComponent")
        if phys and ComponentGetValue2(phys, "is_static") == false then
            ComponentSetValue2(phys, "is_static", true)
            EntityAddComponent2(entity, "LuaComponent", {
                execute_every_n_frame=-1,
                script_item_picked_up="mods/boss_reworks/files/phys.lua"
            })
            isphysics = true
        end
        local phys2 = EntityGetFirstComponentIncludingDisabled(entity, "PhysicsBody2Component")
        if phys2 and ComponentGetValue2(phys2, "is_static") == false then
            ComponentSetValue2(phys2, "is_static", true)
            EntityAddComponent2(entity, "LuaComponent", {
                execute_every_n_frame=-1,
                script_item_picked_up="mods/boss_reworks/files/phys2.lua"
            })
            isphysics = true
        end
        local item = EntityGetFirstComponentIncludingDisabled(entity, "ItemComponent")
        if isphysics then
            EntitySetTransform(entity, Shelf2, 50082, 0)
            EntityApplyTransform(entity, Shelf2, 50082, 0)
            if item and ComponentGetValue2(item, "play_spinning_animation") then
                ComponentSetValue2(item, "play_spinning_animation", false)
            end
            Shelf2 = Shelf2 + 14
        else
            EntitySetTransform(entity, Shelf1, 50055, math.pi / -2)
            EntityApplyTransform(entity, Shelf1, 50055, math.pi / -2)
            if item and ComponentGetValue2(item, "play_spinning_animation") then
                ComponentSetValue2(item, "play_hover_animation", true)
                ComponentSetValue2(item, "play_spinning_animation", false)
            end
            Shelf1 = Shelf1 + 14
        end
    end
end

function steal_player_stuff(player)
    local inv2 = EntityGetFirstComponent(player, "Inventory2Component")
    if inv2 then
        ComponentSetValue2(inv2, "mActiveItem", 0)
        ComponentSetValue2(inv2, "mActualActiveItem", 0)
        ComponentSetValue2(inv2, "mForceRefresh", true)
    end
    Shelf1 = 6280
    Shelf2 = 6280
    local children = EntityGetAllChildren(player) or {}
    for i = 1, #children do
        if EntityGetName(children[i]) == "inventory_quick" then
            local items = EntityGetAllChildren(children[i]) or {}
            for j = 1, #items do
                aaaaaa(items[j])
            end
        end
        if EntityGetName(children[i]) == "inventory_full" then
            local items = EntityGetAllChildren(children[i]) or {}
            for j = 1, #items do
                aaaaaa(items[j])
            end
        end
    end
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

local function nohit()
    local hpmax = tonumber(GlobalsGetValue("BR_BOSS_RUSH_HP_MAX", "0")) or 0
    if GlobalsGetValue("BR_BOSS_RUSH_NOHIT", "0") == "1" then
        GamePrint("$br_boss_rush_nohit")
        GlobalsSetValue("BR_BOSS_RUSH_HP_MAX", tostring(multiplier * 40 + hpmax))
    end
    GamePrint("$br_boss_rush_healed")
    GlobalsSetValue("BR_BOSS_RUSH_HP_LEFT", tostring(math.min(hpmax + multiplier * 40, multiplier * 40 + tonumber(GlobalsGetValue("BR_BOSS_RUSH_HP_LEFT", "0")))))
    GlobalsSetValue("BR_BOSS_RUSH_NOHIT", "1")
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
            GlobalsSetValue("BR_BOSS_RUSH_HP_MAX", tostring(max))
            GlobalsSetValue("BR_BOSS_RUSH_HP_MULTIPLIER", tostring(multiplier))
            GlobalsSetValue("BR_BOSS_RUSH_NOHIT", "1")
            GlobalsSetValue("BR_BOSS_RUSH_ACTIVE", "1")
            GlobalsSetValue("BR_BOSS_RUSH_HP_LEFT", tostring(max))
            GlobalsSetValue("BR_BOSS_RUSH_HP_TWEEN", tostring(max))
            GlobalsSetValue("BR_BOSS_RUSH_PORTAL_NEXT", "dragon")
            load_scene(to_x, to_y, 408, 264, "arena_pyramid", 1)
            boss_portal(to_x, to_y, "data/entities/animals/boss_limbs/boss_limbs.xml", 130, -60)
            steal_player_stuff(entity_that_was_teleported)
        end,
        ["$br_boss_rush_portal_dragon"] = function()
            nohit()
            EntityKill(GetUpdatedEntityID())
            GlobalsSetValue("BR_BOSS_RUSH_PORTAL_NEXT", "forgotten")
            load_scene(to_x, to_y, 432, 432, "arena_dragon", 1)
            boss_portal(to_x, to_y, "data/entities/animals/boss_dragon.xml", 0, 80)
        end,
        ["$br_boss_rush_portal_forgotten"] = function()
            nohit()
            EntityKill(GetUpdatedEntityID())
            GlobalsSetValue("BR_BOSS_RUSH_PORTAL_NEXT", "forgotten")
            load_scene(to_x, to_y, 460, 337, "arena_forgotten", 1)
            boss_portal(to_x, to_y, "data/entities/animals/boss_ghost/boss_ghost.xml", 0, -80)
            EntityLoad("data/entities/items/pickup/evil_eye.xml", to_x, to_y)
        end,
    }

    local name = EntityGetName(GetUpdatedEntityID())
    if funcs[name] and EntityHasTag(entity_that_was_teleported, "player_unit") then funcs[name]() end
    local players = EntityGetWithTag("player_unit")
    for i = 1, #players do
        EntityAddRandomStains(players[i], CellFactory_GetType("boss_reworks_unstainer"), 2000)
    end
    GlobalsSetValue("BR_BOSS_RUSH_PORTAL_X", tostring(to_x))
    GlobalsSetValue("BR_BOSS_RUSH_PORTAL_Y", tostring(to_y))
end