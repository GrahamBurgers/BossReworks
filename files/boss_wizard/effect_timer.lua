local me = GetUpdatedEntityID()
local comp = EntityGetFirstComponent(me, "ParticleEmitterComponent")
local var = EntityGetFirstComponent(me, "VariableStorageComponent")
local x, y = EntityGetTransform(me)
if not comp or not var then return end
local amount = ComponentGetValue2(var, "value_float")
local effect = ComponentGetValue2(var, "value_string")

local entities = EntityGetInRadiusWithTag(x, y, 6, "br_effect_projectile") or {}
for i = 1, #entities do
    GamePlaySound( "data/audio/Desktop/animals.bank", "animals/mine/beep", x, y )
    amount = amount + 60
    EntityKill(entities[i])
    ComponentSetValue2(var, "value_int", GameGetFrameNum())
end

local old_effect = effect
local length = 840
local go = false
local message
if amount >= 360 then
    amount = 0
    local material = "material_confusion"
    if effect == "CONFUSION" then
        length = 1200
        message = "$br_boss_wizard_1"
        effect = "MOVEMENT_SLOWER"
        material = "ice_slime_static"
    elseif effect == "MOVEMENT_SLOWER" then
        message = "$br_boss_wizard_2"
        effect = "BLINDNESS"
        material = "skullrock"
    elseif effect == "BLINDNESS" then
        message = "$br_boss_wizard_3"
        length = 480
        effect = "TELEPORTATION"
        material = "magic_liquid_teleportation"
    elseif effect == "TELEPORTATION" then
        message = "$br_boss_wizard_4"
        effect = "POLYMORPH"
        material = "magic_liquid_polymorph"
    elseif effect == "POLYMORPH" then
        -- should we cycle back to confusion or stay on poly?
        length = 480
        material = "material_confusion"
        effect = "CONFUSION"
    end
    ComponentSetValue2(comp, "emitted_material_name", material)
    ComponentSetValue2(var, "value_string", effect)
    go = true
end

if GameGetFrameNum() > ComponentGetValue2(var, "value_int") + 300 then
    amount = amount - 0.5
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
    ComponentSetValue2(gameeffect, "frames", length)
end