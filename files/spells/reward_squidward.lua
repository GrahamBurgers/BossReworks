local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local spells_needed = 3
local radius = 40

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
if #valid >= spells_needed then
    local totalx, totaly = 0, 0
    for i = 1, #valid do
        local entity = valid[i][1]
        local x2, y2 = EntityGetTransform(entity)
        totalx = totalx + (x2 / spells_needed)
        totaly = totaly + (y2 / spells_needed)
        EntityLoad("data/entities/particles/poof_blue.xml", x2, y2)
        EntityKill(entity)
        if i >= spells_needed then break end
    end
    dofile_once("data/scripts/items/chest_random.lua")
    EntityLoad("data/entities/particles/poof_green.xml", totalx, totaly)
    SetRandomSeed(x + totalx, y + totaly)
    -- GamePrint("1: " .. valid[1][3])
    -- GamePrint("2: " .. valid[2][3])
    -- GamePrint("3: " .. valid[3][3])
    local redo = true
    local newid = ""
    while redo do
        local eid = make_random_card(totalx, totaly)
        local idc = EntityGetFirstComponent(eid, "ItemActionComponent")
        if idc then
            newid = ComponentGetValue2(idc, "action_id")
        end
        --  GamePrint("try: " .. newid)
        redo = false
        if newid == valid[1][3] or newid == valid[2][3] or newid == valid[3][3] then
            EntityKill(eid)
            redo = true
        end
    end
    GamePlaySound("data/audio/Desktop/items.bank", "magic_wand/mana_fully_recharged", totalx, totaly)
else
    GamePlaySound("data/audio/Desktop/ui.bank", "ui/button_denied", x, y)
end

EntityKill(me)