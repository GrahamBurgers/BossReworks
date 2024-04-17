local function aargh(who, image)
    return EntityAddComponent2(who, "ParticleEmitterComponent", {
        image_animation_file=image,
        emitted_material_name="spark",
        custom_alpha=0.06,
        fade_based_on_lifetime=false,
        emission_interval_min_frames=1,
        emission_interval_max_frames=1,
        emit_cosmetic_particles=true,
        emit_only_if_there_is_space=false,
        emit_real_particles=false,
        cosmetic_force_create=true,
        count_min=1,
        count_max=1,
        image_animation_speed=1000,
        lifetime_min=0.03,
        lifetime_max=0.03,
        render_on_grid=false,
        render_back=true,
        image_animation_use_entity_rotation=true,
    })
end

local function the_other_one(who, image)
    return EntityAddComponent2(who, "ParticleEmitterComponent", {
        _tags="enabled_in_world,enabled_in_hand,enabled_in_inventory",
        image_animation_file=image,
        emitted_material_name="steel_static",
        create_real_particles=true,
        emission_interval_min_frames=1,
        emission_interval_max_frames=1,
        emit_cosmetic_particles=true,
        emit_only_if_there_is_space=false,
        emit_real_particles=false,
        cosmetic_force_create=true,
        count_min=1,
        count_max=1,
        image_animation_speed=8,
        lifetime_min=0.03,
        lifetime_max=0.03,
        render_on_grid=false,
        render_back=true,
        image_animation_use_entity_rotation=true,
        image_animation_loop=false,
        set_magic_creation=true,
    })
end

local function hax_add_the_comps(who, image)
    -- i hate having to do this
    local c
    local ps = EntityGetComponentIncludingDisabled(who, "ParticleEmitterComponent") or {}
    for i = 1, #ps do
        EntityRemoveComponent(who, ps[i])
    end
    c = EntityAddComponent2(who, "ParticleEmitterComponent", {
        image_animation_file=image,
        emitted_material_name="spark_yellow",
        emission_interval_min_frames=1,
        emission_interval_max_frames=1,
        emit_cosmetic_particles=true,
        emit_only_if_there_is_space=false,
        emit_real_particles=false,
        cosmetic_force_create=false,
        count_min=1,
        count_max=1,
        image_animation_speed=4,
        fade_based_on_lifetime=true,
        lifetime_min=0.5,
        lifetime_max=0.5,
        render_on_grid=false,
        image_animation_use_entity_rotation=true,
    })
    ComponentSetValue2(c, "gravity", 0, 0)

    c = aargh(who, image)
    ComponentSetValue2(c, "offset", -0.1, 0.2)
    ComponentSetValue2(c, "gravity", 0, 0)

    c = aargh(who, image)
    ComponentSetValue2(c, "offset", 0.3, 0.2)
    ComponentSetValue2(c, "gravity", 0, 0)

    c = aargh(who, image)
    ComponentSetValue2(c, "offset", -0.1, 0.25)
    ComponentSetValue2(c, "gravity", 0, 0)

    c = aargh(who, image)
    ComponentSetValue2(c, "offset", 0.3, 0.25)
    ComponentSetValue2(c, "gravity", 0, 0)
end

local shape_list = {
    {"shape_square.png",       250},
    {"shape_circle.png",       250},
    {"shape_line.png",         300},
    {"shape_box.png",          100},
    {"shape_anvil.png",        1000},
    -- {"shape_hamis.png", 5},
    {"shape_chest.png",        1200},
    {"shape_utilitybox.png",   4000},
    {"shape_pillar.png",       2500},
    {"shape_saw.png",          150},
    {"shape_bump.png",         150},
    {"shape_drain.png",        200},
    {"shape_kammi.png",        500},
    -- {"shape_triangle.png", 20000},
    -- {"shape_egg.png", 20000},
}

---@diagnostic disable: cast-local-type, param-type-mismatch
local mx, my = DEBUG_GetMouseWorld()
local me = GetUpdatedEntityID()
local x, y, rot = EntityGetTransform(me)
local spell = EntityGetParent(me)
local player = EntityGetRootEntity(me)
local controls = EntityGetFirstComponentIncludingDisabled(player, "ControlsComponent")
local gui = EntityGetComponentIncludingDisabled(me, "SpriteComponent")[1]
local text = EntityGetComponentIncludingDisabled(me, "SpriteComponent")[2]
local on = false
local particles = EntityGetComponentIncludingDisabled(me, "ParticleEmitterComponent") or {}
local file = ComponentGetValue2(particles[1], "image_animation_file")
if file == "" then
    file = "mods/boss_reworks/files/spells/robot/shape_square.png"
    hax_add_the_comps(me, file)
end
local children = EntityGetAllChildren(me) or {}
if #children >= 1 then
    on = true
    if EntityGetFirstComponent(children[1], "ParticleEmitterComponent") == nil then
        local price = string.gsub(ComponentGetValue2(text, "text"), "%$", "")
        price = tonumber(price)
        local wallet = EntityGetFirstComponent(player, "WalletComponent")
        local money = 0
        if wallet then money = ComponentGetValue2(wallet, "money") end
        if money >= price then
            GamePlaySound("data/audio/Desktop/event_cues.bank", "event_cues/shop_item/create", x, y)
            ComponentSetValue2(wallet, "money", money - price)
            local c1 = the_other_one(children[1], file)
            local c2 = the_other_one(children[1], file)
            local c3 = the_other_one(children[1], file)
            local c4 = the_other_one(children[1], file)

            ComponentSetValue2(c1, "gravity", 0, 0)
            ComponentSetValue2(c2, "gravity", 0, 0)
            ComponentSetValue2(c3, "gravity", 0, 0)
            ComponentSetValue2(c4, "gravity", 0, 0)
            if (rot + 1.58) % 1.571 > 0.1 then
                ComponentSetValue2(c1, "offset", 0, -0.5)
                ComponentSetValue2(c2, "offset", 0.2, -0.5)
                ComponentSetValue2(c3, "offset", -0.2, -0.1)
                ComponentSetValue2(c4, "offset", 0.2, -0.1)
            end
            EntitySetTransform(children[1], x, y, rot)
            EntityAddComponent2(children[1], "ParticleEmitterComponent", {
                _tags="enabled_in_world,enabled_in_hand,enabled_in_inventory",
                image_animation_file=file,
                emitted_material_name="steel_static",
                create_real_particles=true,
                emission_interval_min_frames=1,
                emission_interval_max_frames=1,
                emit_cosmetic_particles=true,
                emit_only_if_there_is_space=false,
                emit_real_particles=false,
                cosmetic_force_create=true,
                count_min=1,
                count_max=1,
                image_animation_speed=50,
                delay_frames=33,
                lifetime_min=0.03,
                lifetime_max=0.03,
                render_on_grid=false,
                render_back=true,
                image_animation_use_entity_rotation=true,
                image_animation_loop=false,
                set_magic_creation=true,
            })
        else
            EntityKill(children[1])
            GamePlaySound("data/audio/Desktop/ui.bank", "ui/button_denied", x, y)
        end
        if children[2] then EntityKill(children[2]) end -- idk what this does
        if children[3] then EntityKill(children[3]) end
    end
else
    if EntityHasTag(player, "player_unit") and EntityGetFirstComponentIncludingDisabled(spell, "VariableStorageComponent") ==
    EntityGetFirstComponent(spell, "VariableStorageComponent") then
        on = true
    end
    if controls and gui and on then
        if GameGetIsGamepadConnected() and EntityHasTag(player, "player_unit") then
            if controls then
                mx, my = ComponentGetValue2(controls, "mGamePadCursorInWorld")
            end
        end
        mx = math.floor(mx + 0.5)
        my = math.floor(my + 0.5)
        if ComponentGetValue2(controls, "mButtonDownThrow") then
            local image = "mods/boss_reworks/files/spells/robot/gui.png"
            if mx < x - 18 and mx > x - 34 and my > y - 8 and my < y + 8 then
                image = "mods/boss_reworks/files/spells/robot/gui_left.png"
            elseif mx > x + 18 and mx < x + 34 and my > y - 8 and my < y + 8 then
                image = "mods/boss_reworks/files/spells/robot/gui_right.png"
            elseif mx > x - 8 and mx < x + 8 and my > y + 18 and my < y + 28 then
                image = "mods/boss_reworks/files/spells/robot/gui_down.png"
            elseif mx > x - 8 and mx < x + 8 and my < y - 18 and my > y - 28 then
                image = "mods/boss_reworks/files/spells/robot/gui_up.png"
            end
            EntitySetComponentIsEnabled(me, gui, true)
            EntitySetComponentIsEnabled(me, text, true)
            ComponentSetValue2(gui, "image_file", image)
            EntityRefreshSprite(me, gui)
        else
            local image = ComponentGetValue2(gui, "image_file")
            local count = 0
            if image == "mods/boss_reworks/files/spells/robot/gui_left.png" then
                EntitySetTransform(me, x, y, rot + -22.5 * (math.pi / 180))
            elseif image == "mods/boss_reworks/files/spells/robot/gui_right.png" then
                EntitySetTransform(me, x, y, rot + 22.5 * (math.pi / 180))
            elseif image == "mods/boss_reworks/files/spells/robot/gui_down.png" then
                for i = 1, #shape_list do
                    if "mods/boss_reworks/files/spells/robot/" .. shape_list[i][1] == file then
                        count = (i % #shape_list) + 1
                        break
                    end
                end
            elseif image == "mods/boss_reworks/files/spells/robot/gui_up.png" then
                for i = 1, #shape_list do
                    if "mods/boss_reworks/files/spells/robot/" .. shape_list[i][1] == file then
                        count = ((i - 2) % #shape_list) + 1
                        break
                    end
                end
            end
            if count ~= 0 then
                EntitySetTransform(me, x, y, 0)
                for i = 1, #particles do
                    hax_add_the_comps(me, "mods/boss_reworks/files/spells/robot/" .. shape_list[count][1])
                end
                ComponentSetValue2(text, "text", "$" .. shape_list[count][2])
                EntityRefreshSprite(me, text)
            end
            ComponentSetValue2(gui, "image_file", "mods/boss_reworks/files/spells/robot/gui.png")
            EntitySetComponentIsEnabled(me, gui, false)
            EntitySetComponentIsEnabled(me, text, false)
            EntitySetTransform(GetUpdatedEntityID(), mx, my)
        end
    end
end
-- for some reason enabled_in_hand gets disabled on children but not reenabled
local comps = EntityGetComponentIncludingDisabled(me, "ParticleEmitterComponent") or {}
for i = 1, #comps do
    if comps[i] ~= GetUpdatedComponentID() then
        EntitySetComponentIsEnabled(me, comps[i], on)
    end
end