local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local radius = 18

local variants = dofile_once("mods/boss_reworks/files/spells/master_spell_list.lua")

local spells = EntityGetInRadiusWithTag(x, y, radius, "card_action") or {}
local valid = {}
for i = 1, #spells do
    if EntityGetRootEntity(spells[i]) == spells[i] and EntityGetFirstComponent(spells[i], "ItemCostComponent") == nil then
        local x2, y2 = EntityGetTransform(spells[i])
        local distance = (x2 - x)^2 + (y2 - y)^2
        local itemcomp = EntityGetFirstComponent(spells[i], "ItemActionComponent")
        local name = ""
        if itemcomp then name = ComponentGetValue2(itemcomp, "action_id") end
        if #valid == 0 then
            table.insert(valid, {spells[i], distance, name})
            table.insert(valid, {spells[i], distance, name})
        else
            for j = 1, #valid do
                -- if name == valid[j][3] then break end -- no duplicate spells
                if (valid[j][2] > distance or j == #valid) then
                    table.insert(valid, j, {spells[i], distance, name})
                    break
                end
            end
        end
    end
end
table.remove(valid, #valid) -- hax?
if #valid >= 1 then
    local entity = valid[1][1]
    local x2, y2 = EntityGetTransform(entity)
    GamePlaySound("data/audio/Desktop/items.bank", "magic_wand/mana_fully_recharged", x2, y2)
else
    GamePlaySound("data/audio/Desktop/ui.bank", "ui/button_denied", x, y)
end

EntityKill(me)