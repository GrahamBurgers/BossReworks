local me = GetUpdatedEntityID()
local comp = EntityGetFirstComponent(me, "ParticleEmitterComponent")
local var = EntityGetFirstComponent(me, "VariableStorageComponent")
local x, y = EntityGetTransform(me)
if not comp or not var then return end
local amount = ComponentGetValue2(var, "value_float")
local effect = ComponentGetValue2(var, "value_string")

local pips = 360 / 6
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
        ComponentSetValue2(var, "value_int", GameGetFrameNum() + 300)
    end
end
local effects = {
    {
        name = "confusion_ui",
        length = 1200,
        message = "$br_boss_wizard_1",
        effect = "CONFUSION",
        material = "material_confusion",
    },
    {
        name = "movement_slower_ui",
        message = "$br_boss_wizard_2",
        effect = "MOVEMENT_SLOWER",
        material = "ice_slime_static",
    },
    {
        name = "drunk_ui",
        message = "$br_boss_wizard_3",
        effect = "DRUNK",
        material = "alcohol",
    },
    {
        name = "blindness",
        message = "$br_boss_wizard_4",
        length = 240,
        effect = "BLINDNESS",
        material = "skullrock",
    },
    {
        name = "br_frozen",
        message = "$br_boss_wizard_6",
        length = 240,
        effect = "FROZEN",
        material = "snow",
    },
    {
        name = "polymorph",
        length = 480,
        effect = "POLYMORPH",
        material = "magic_liquid_polymorph",
    },
}

local old_effect = effect
local number = nil
if amount >= 359 then
    amount = 0
    local material = "material_confusion"
    for i = 1, #effects do
        if effect == effects[i].effect then
            number = i
            break
        end
    end
    ComponentSetValue2(comp, "emitted_material_name", effects[math.min(#effects, number + 1)].material or material)
    ComponentSetValue2(var, "value_string", effects[math.min(#effects, number + 1)].effect or effect)
    amount = 0
end

ComponentSetValue2(comp, "custom_alpha", 1)
if GameGetFrameNum() > ComponentGetValue2(var, "value_int") then
    amount = amount - 0.35
    ComponentSetValue2(comp, "custom_alpha", 0.5)
end
if amount < 0 and old_effect ~= effects[1].effect then
    amount = 300
    local material = "material_confusion"
    for i = 1, #effects do
        if effect == effects[i].effect then
            number = i
            break
        end
    end
    ComponentSetValue2(comp, "emitted_material_name", effects[math.max(1, number - 1)].material or material)
    ComponentSetValue2(var, "value_string", effects[math.max(1, number - 1)].effect or effect)
    number = nil
end
amount = math.min(360, math.max(0, amount))
ComponentSetValue2(comp, "area_circle_sector_degrees", amount)
ComponentSetValue2(comp, "count_min", math.ceil(amount * 0.6))
ComponentSetValue2(comp, "count_max", math.ceil(amount * 0.6))
ComponentSetValue2(var, "value_float", amount)
local turn = (math.pi / -2) + ((amount / 360) * math.pi)
EntitySetTransform(me, x, y, turn)

if number ~= nil then
    if effects[number].message then GamePrint(effects[number].message) end
    GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/blindness/create", x, y )
    local gameeffect, entity = GetGameEffectLoadTo(EntityGetRootEntity(me), old_effect, true)
    EntityAddComponent2(entity, "UIIconComponent", {
        display_above_head=false,
        name=GameTextGet("$status_" .. effects[number].name),
        description=GameTextGet("$statusdesc_" .. effects[number].name),
        display_in_hud=false,
        is_perk=false,
        icon_sprite_file="data/ui_gfx/status_indicators/" .. string.lower(old_effect) .. ".png"
    })
    ComponentSetValue2(gameeffect, "frames", effects[number].length or 840)
end