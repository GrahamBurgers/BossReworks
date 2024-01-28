local me = GetUpdatedEntityID()
local comp = EntityGetFirstComponent(me, "ParticleEmitterComponent")
local var = EntityGetFirstComponent(me, "VariableStorageComponent")
local x, y = EntityGetTransform(me)
if not comp or not var then return end
local amount = ComponentGetValue2(var, "value_float")
local effect = ComponentGetValue2(var, "value_string")

local pips = 360 / 7
local entities = EntityGetInRadiusWithTag(x, y, 6, "br_effect_projectile") or {}
for i = 1, #entities do
    local proj = EntityGetFirstComponentIncludingDisabled(entities[i], "ProjectileComponent")
    local count = 0
    if proj then
        -- use damage value as the pips added since projectile can't hit directly
        count = ComponentGetValue2(proj, "damage")
    end
    if count > 0 then
        GamePlaySound( "data/audio/Desktop/animals.bank", "animals/mine/beep", x, y )
        amount = amount + pips * count
        EntityKill(entities[i])
        ComponentSetValue2(var, "value_int", GameGetFrameNum())
    end
end

local old_effect = effect
local length = 840
local go = false
local message, name
if amount >= 359 then
    amount = 0
    local material = "material_confusion"
    if effect == "CONFUSION" then
        name = "confusion_ui"
        length = 1200
        message = "$br_boss_wizard_1"
        effect = "MOVEMENT_SLOWER"
        material = "ice_slime_static"
    elseif effect == "MOVEMENT_SLOWER" then
        name = "movement_slower_ui"
        message = "$br_boss_wizard_2"
        effect = "DRUNK"
        -- TODO: alcohol seems too vibrant, is there anything we can replace it with? already tried alcohol_gas and sima
        material = "alcohol"
    elseif effect == "DRUNK" then
        name = "drunk_ui"
        message = "$br_boss_wizard_3"
        effect = "BLINDNESS"
        material = "skullrock"
    elseif effect == "BLINDNESS" then
        name = "blindness"
        message = "$br_boss_wizard_4"
        length = 480
        effect = "TELEPORTATION"
        material = "magic_liquid_unstable_teleportation"
    elseif effect == "TELEPORTATION" then
        name = "teleportation"
        message = "$br_boss_wizard_5"
        effect = "FROZEN"
        material = "snow"
    elseif effect == "FROZEN" then
        name = "br_frozen"
        message = "$br_boss_wizard_6"
        length = 240
        effect = "POLYMORPH"
        material = "magic_liquid_polymorph"
    elseif effect == "POLYMORPH" then
        name = "polymorph"
        -- message = "$br_boss_wizard_7"
        length = 480
        material = "material_confusion"
        effect = "CONFUSION"
    end
    ComponentSetValue2(comp, "emitted_material_name", material)
    ComponentSetValue2(var, "value_string", effect)
    go = true
end

ComponentSetValue2(comp, "custom_alpha", 1)
if GameGetFrameNum() > ComponentGetValue2(var, "value_int") + 300 then
    amount = amount - 0.5
    ComponentSetValue2(comp, "custom_alpha", 0.5)
end
amount = math.min(360, math.max(0, amount))
ComponentSetValue2(comp, "area_circle_sector_degrees", amount)
ComponentSetValue2(comp, "count_min", math.ceil(amount * 1.8))
ComponentSetValue2(comp, "count_max", math.ceil(amount * 1.8))
ComponentSetValue2(var, "value_float", amount)
local turn = (math.pi / -2) + ((amount / 360) * math.pi)
EntitySetTransform(me, x, y, turn)

if go then
    if message then GamePrint(message) end
    GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/blindness/create", x, y )
    local gameeffect, entity = GetGameEffectLoadTo(EntityGetRootEntity(me), old_effect, true)
    EntityAddComponent2(entity, "UIIconComponent", {
        display_above_head=false,
        name=GameTextGet("$status_" .. name),
        description=GameTextGet("$statusdesc_" .. name),
        display_in_hud=false,
        is_perk=false,
        icon_sprite_file="data/ui_gfx/status_indicators/" .. string.lower(old_effect) .. ".png"
    })
    ComponentSetValue2(gameeffect, "frames", length)
end