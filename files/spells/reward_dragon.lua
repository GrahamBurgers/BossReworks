local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local targets = EntityGetInRadiusWithTag(x, y, 16, "homing_target")
local worldstate = EntityGetAllChildren(GameGetWorldStateEntity())
local child = nil
for i = 1, #worldstate do
    if EntityGetName(worldstate[i]) == "br_soul_storage" then
        child = worldstate[i]
        break
    end
end
if not child or not targets then return end
local vscs = EntityGetComponent(child, "VariableStorageComponent", "dragon_soul") or {}
local valid = {}
for i = 1, #targets do
    local x2, y2 = EntityGetTransform(targets[i])
    local distance = (x2 - x)^2 + (y2 - y)^2
    local name = GameTextGetTranslatedOrNot(EntityGetName(targets[i]))
    local insert = true
    for j = 1, #vscs do
        if ComponentGetValue2(vscs[j], "value_string") == name then
            insert = false
        end
    end
    if insert and not (EntityHasTag(targets[i], "boss") or EntityHasTag(targets[i], "miniboss")) then
        if #valid == 0 then
            table.insert(valid, {targets[i], distance, name})
            table.insert(valid, {targets[i], distance, name})
        else
            for k = 1, #valid do
                if (valid[k][2] > distance or k == #valid) then
                    table.insert(valid, k, {targets[i], distance, name})
                    break
                end
            end
        end
    end
end
table.remove(valid, #valid) -- hax?
local amount = 5 + (math.floor(#vscs / 5) * 2)
if #valid > 0 and string.len(valid[1][3]) > 0 then
    EntityConvertToMaterial(valid[1][1], "spark_white_bright")
    EntityKill(valid[1][1])
    EntityAddComponent2(child, "VariableStorageComponent", {
        _tags="dragon_soul",
        value_string=valid[1][3]
    })
    local players = EntityGetWithTag("player_unit") or {}
    for i = 1, #players do
        local dmg = EntityGetFirstComponent(players[i], "DamageModelComponent")
        if dmg then
            ComponentSetValue2(dmg, "max_hp", ComponentGetValue2(dmg, "max_hp") + amount / 25)
            local x2, y2 = EntityGetTransform(players[i])
            EntityLoad("data/entities/particles/poof_green.xml", x2, y2)
            GameScreenshake(50)
            GamePrint(GameTextGet("$br_max_hp_increased", tostring(amount)))
        end
    end
    GamePlaySound("data/audio/Desktop/items.bank", "magic_wand/mana_fully_recharged", x, y)
elseif #targets > 0 then
    GamePlaySound("data/audio/Desktop/ui.bank", "ui/button_denied", x, y)
end

EntityKill(me)