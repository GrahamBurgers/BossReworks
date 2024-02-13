local multiplier = 100 -- multiply it before storing cause shoving a float into an int scares me
local max = 800 * multiplier -- make this very high for now until we know how long/hard boss rush will be

local function aaaaaa(entity)
    if EntityGetComponentIncludingDisabled(entity, "ItemComponent") ~= nil and not EntityHasTag(entity, "card_action") then
        EntityRemoveFromParent(entity)
        EntitySetComponentsWithTagEnabled(entity, "enabled_in_hand", false)
        EntitySetComponentsWithTagEnabled(entity, "enabled_in_inventory", false)
        EntitySetComponentsWithTagEnabled(entity, "enabled_in_world", true)
        local vel = EntityGetFirstComponentIncludingDisabled(entity, "VelocityComponent")
        if vel then EntitySetComponentIsEnabled(entity, vel, false) end
        local isphysics = false
        local phys = EntityGetFirstComponentIncludingDisabled(entity, "PhysicsBodyComponent")
        if phys then
            isphysics = true
            EntitySetComponentIsEnabled(entity, phys, false)
        end
        local phys2 = EntityGetFirstComponentIncludingDisabled(entity, "PhysicsBody2Component")
        if phys2 then
            isphysics = true
            EntitySetComponentIsEnabled(entity, phys2, false)
        end
        local what = EntityGetFirstComponentIncludingDisabled(entity, "SpriteOffsetAnimatorComponent")
        if what then EntityRemoveComponent(entity, what) end
        local item = EntityGetFirstComponentIncludingDisabled(entity, "ItemComponent")
        local sprite = EntityGetFirstComponentIncludingDisabled(entity, "SpriteComponent", "enabled_in_hand")
        if sprite then EntitySetComponentIsEnabled(entity, sprite, true) end
        if isphysics then
            EntitySetTransform(entity, Shelf2, 50084, 0)
            EntityApplyTransform(entity, Shelf2, 50084, 0)
            Shelf2 = Shelf2 + 18
            if item then
                ComponentSetValue2(item, "play_hover_animation", false)
                ComponentSetValue2(item, "play_spinning_animation", false)
            end
        else
            EntitySetTransform(entity, Shelf1, 50055, math.pi / -2)
            EntityApplyTransform(entity, Shelf1, 50055, math.pi / -2)
            Shelf1 = Shelf1 + 18
            if item then
                ComponentSetValue2(item, "play_hover_animation", true)
                ComponentSetValue2(item, "play_spinning_animation", false)
            end
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
    dofile_once("data/scripts/perks/perk.lua")
    local perks_to_spawn = {}

	for i,perk_data in ipairs(perk_list) do
		local perk_id = perk_data.id
		if ( perk_data.one_off_effect == nil ) or ( perk_data.one_off_effect == false ) then
			local flag_name = get_perk_picked_flag_name( perk_id )
			local pickup_count = tonumber( GlobalsGetValue( flag_name .. "_PICKUP_COUNT", "0" ) ) or 0
			
			if GameHasFlagRun( flag_name ) or ( pickup_count > 0 ) then
                for j = 1, pickup_count do
				    perks_to_spawn[#perks_to_spawn+1] = perk_id
                end
			end
		end
	end

    if #perks_to_spawn > 0 then
        local storage = EntityCreateNew()
        EntitySetTransform(storage, 6482.5, 50065)
        EntityAddComponent2(storage, "SpriteComponent", {
            image_file="mods/boss_reworks/files/boss_rush/perks/perk_storage.png",
            offset_x=7,
            offset_y=7,
            z_index=2,
            update_transform_rotation=false,
        })
        local thing = tostring(#perks_to_spawn)
        local offset = 2.5
        if string.len(thing) > 1 then offset = 5.5 end
        for i = 1, string.len(thing) do
            EntityAddComponent2(storage, "SpriteComponent", {
                image_file="mods/boss_reworks/files/boss_rush/perks/" .. string.sub(thing, i, i) .. ".png",
                offset_x=offset,
                offset_y=3,
                update_transform_rotation=false,
            })
            offset = offset - 6
        end
        EntityAddComponent2( storage, "ItemComponent",
        {
            item_name = "$br_boss_rush_perks_name",
            ui_description = "$br_boss_rush_perks_desc",
            ui_display_description_on_pick_up_hint = true,
            play_spinning_animation = false,
            play_hover_animation = true,
            play_pick_sound = true,
            ui_sprite = "mods/boss_reworks/files/boss_rush/perks/eye_spook.png" -- just in case sprite appears for a frame or two
        } )
        EntityAddComponent2(storage, "LuaComponent", {
            execute_every_n_frame=-1,
            script_item_picked_up="mods/boss_reworks/files/boss_rush/perks/perkful_pickup.lua"
        })
        for i = 1, #perks_to_spawn do
            EntityAddComponent2(storage, "VariableStorageComponent", {
                _tags="br_boss_rush_storage",
                value_string=perks_to_spawn[i]
            })
        end
        local exits = EntityGetWithName("$br_boss_rush_portal_out")
        if exits ~= nil then EntityKill(exits) end
    end
    remove_all_perks()
end

local function boss_portal(to_x, to_y, entity, x_off, y_off)
    local eid = EntityLoad("mods/boss_reworks/files/boss_rush/boss_in_portal.xml", to_x + x_off, to_y + y_off)
    EntityAddComponent2(eid, "VariableStorageComponent", {
        value_string=entity
    })
    return eid
end

local function load_scene(x, y, size_x, size_y, room_name, amount)
    local y2 = y + size_y * -0.5
    if amount == 1 then
        LoadPixelScene(table.concat({room_name, ".png"}), "", x + size_x * -0.5, y2, "", true, false, {}, 50, true)
    else
        for i = 1, amount do
            LoadPixelScene(table.concat({room_name, "_", i, ".png"}), "", x + size_x * -0.5, y2, "", true, false, {}, 50, true)
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

    -- maybe a good idea?
    local entities = EntityGetWithTag("boss_reworks_boss_rush") or {}
    for i = 1, #entities do
        EntitySetComponentsWithTagEnabled(entities[i], "boss_reworks_rush_remove", false)
        local children = EntityGetAllChildren(entities[i]) or {}
        for j = 1, #children do
            EntityKill(children[j])
        end
        EntityKill(entities[i])
    end
end

local function spawn_wands(name, entity)
    local inv2 = EntityGetFirstComponent(entity, "Inventory2Component")
    if inv2 then
        ComponentSetValue2(inv2, "mActiveItem", 0)
        ComponentSetValue2(inv2, "mActualActiveItem", 0)
        ComponentSetValue2(inv2, "mForceRefresh", true)
    end
    local x, y = EntityGetTransform(entity)
    local children = EntityGetAllChildren(entity) or {}
    for i = 1, #children do
        if EntityGetName(children[i]) == "inventory_quick" then
            local items = EntityGetAllChildren(children[i]) or {}
            for j = 1, #items do
                EntityKill(items[j])
            end
        end
    end
    EntityLoad(name .. "_01.xml", x - 12, y)
    EntityLoad(name .. "_02.xml", x + 12, y)
end

Bosses = {
    {"$br_boss_rush_portal_in", function(x, y, player)
        if not GameHasFlagRun("br_boss_rush_intro") then
            load_scene(x, y, 346, 262, "mods/boss_reworks/files/boss_rush/rooms/intro_room", 1)
            GameAddFlagRun("br_boss_rush_intro")
            EntityLoad("mods/boss_reworks/files/boss_rush/boss_rush_book.xml", x, y + 30)
            local entity = EntityLoad("mods/boss_reworks/files/boss_rush/portals/boss_rush_portal_base.xml", x + 130, y - 60)
            local name = "$br_boss_rush_portal_pyramid"
            EntitySetName(entity, name)
            EntityRemoveTag(entity, "boss_reworks_boss_rush")
            local ui = EntityGetFirstComponent(entity, "UIInfoComponent")
            if ui then
                ComponentSetValue2(ui, "name", name)
            end
            EntityLoad("mods/boss_reworks/files/boss_rush/portals/boss_rush_portal_out.xml", x - 130, y - 60)
        end
    end},
    {"$br_boss_rush_portal_pyramid", function(x, y, player)
        GlobalsSetValue("BR_BOSS_RUSH_HP_MAX", tostring(max))
        GlobalsSetValue("BR_BOSS_RUSH_HP_MULTIPLIER", tostring(multiplier))
        GlobalsSetValue("BR_BOSS_RUSH_NOHIT", "1")
        GlobalsSetValue("BR_BOSS_RUSH_ACTIVE", "1")
        GlobalsSetValue("BR_BOSS_RUSH_HP_LEFT", tostring(max))
        GlobalsSetValue("BR_BOSS_RUSH_HP_TWEEN", tostring(max))
        load_scene(x, y, 408, 264, "mods/boss_reworks/files/boss_rush/rooms/arena_pyramid", 1)
        boss_portal(x, y, "data/entities/animals/boss_limbs/boss_limbs.xml", 130, -60)
        steal_player_stuff(player)
        spawn_wands("mods/boss_reworks/files/boss_rush/wands/limbs", player)
    end},
    {"$br_boss_rush_portal_dragon", function(x, y, player)
        nohit()
        load_scene(x, y, 432, 432, "mods/boss_reworks/files/boss_rush/rooms/arena_dragon", 1)
        boss_portal(x, y, "data/entities/animals/boss_dragon.xml", 0, 80)
        spawn_wands("mods/boss_reworks/files/boss_rush/wands/dragon", player)
    end},
    {"$br_boss_rush_portal_forgotten", function(x, y, player)
        nohit()
        GlobalsSetValue("BR_BOSS_RUSH_PORTAL_NEXT", "forgotten")
        load_scene(x, y, 460, 337, "mods/boss_reworks/files/boss_rush/rooms/arena_forgotten", 1)
        boss_portal(x, y, "data/entities/animals/boss_ghost/boss_ghost.xml", 0, -80)
        local eid = EntityLoad("data/entities/items/pickup/evil_eye.xml", x, y)
        EntityAddTag(eid, "boss_reworks_boss_rush")
        spawn_wands("mods/boss_reworks/files/boss_rush/wands/forgotten", player)
    end},
}

function portal_teleport_used( entity_that_was_teleported, from_x, from_y, to_x, to_y )
    local name = EntityGetName(GetUpdatedEntityID())
    if (EntityHasTag(entity_that_was_teleported, "player_unit") or EntityHasTag(entity_that_was_teleported, "polymorphed_player")) then
        EntityAddRandomStains(entity_that_was_teleported, CellFactory_GetType("boss_reworks_unstainer"), 2000)
        for i = 1, #Bosses do
            if Bosses[i][1] == name then
                Bosses[i][2](to_x, to_y, entity_that_was_teleported)
                GlobalsSetValue("BR_BOSS_RUSH_PORTAL_NEXT", Bosses[i + 1][1] or "")
            end
        end
    end
    local projectiles = EntityGetWithTag("projectile") or {} -- this will cause no issues
    for i = 1, #projectiles do
        local comps = EntityGetComponent(projectiles[i], "ProjectileComponent") or {}
        for j = 1, #comps do
            ComponentSetValue2(comps[j], "on_death_explode", false)
            ComponentSetValue2(comps[j], "on_lifetime_out_explode", false)
            ComponentObjectSetValue2(comps[j], "config_explosion", "damage", 0)
            ComponentObjectSetValue2(comps[j], "config_explosion", "hole_enabled", false)
            ComponentObjectSetValue2(comps[j], "config_explosion", "explosion_radius", 0)
        end
        local what = EntityGetComponent(projectiles[i], "ExplodeOnDamageComponent") or {}
        for j = 1, #what do
            ComponentSetValue2(what[j], "explode_on_death_percent", 0)
            ComponentObjectSetValue2(what[j], "config_explosion", "damage", 0)
            ComponentObjectSetValue2(what[j], "config_explosion", "hole_enabled", false)
            ComponentObjectSetValue2(what[j], "config_explosion", "explosion_radius", 0)
        end
        local why = EntityGetComponent(projectiles[i], "ExplosionComponent") or {}
        for j = 1, #why do
            ComponentObjectSetValue2(why[j], "config_explosion", "damage", 0)
            ComponentObjectSetValue2(why[j], "config_explosion", "hole_enabled", false)
            ComponentObjectSetValue2(why[j], "config_explosion", "explosion_radius", 0)
        end
        EntitySetTransform(projectiles[i], to_x, to_y)
        EntityApplyTransform(projectiles[i], to_x, to_y)
        EntityKill(projectiles[i])
    end
    GlobalsSetValue("BR_BOSS_RUSH_PORTAL_X", tostring(to_x))
    GlobalsSetValue("BR_BOSS_RUSH_PORTAL_Y", tostring(to_y))
end

function Insert_boss(after_who, name, func)
    for i = 1, #Bosses do
        if Bosses[i][1] == after_who then
            table.insert(Bosses, i + 1, {name, func})
        end
    end
end
-- TODO: write instructions on how to add a modded boss to boss rush (blehhhhhh)