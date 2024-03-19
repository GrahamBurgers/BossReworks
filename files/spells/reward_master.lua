local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local radius = 12

Variants = dofile_once("mods/boss_reworks/files/spells/master_spell_list.lua")
dofile_once("data/scripts/gun/gun_actions.lua")
Actions = actions or {}

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

local bonk = false
if #valid >= 1 and #Actions > 0 then
    local entity = valid[1][1]
    local id = valid[1][3]
    local pool = {}
    bonk = true
    for i = 1, #Variants do
        for j = 1, #Variants[i] do
            if Variants[i][j] == id then
                pool = Variants[i]
                break
            end
        end
    end
    if #pool > 0 then
        local new_pool = {}
        local which = 0
        for i = 1, #pool do
            for j = 1, #Actions do
                if Actions[j].id == pool[i] and not (Actions[j].spawn_requires_flag and not HasFlagPersistent(Actions[j].spawn_requires_flag)) then
                    new_pool[#new_pool+1] = pool[i]
                    if pool[i] == id then
                        which = #new_pool
                    end
                    break
                end
            end
        end
        if #new_pool > 1 then
            local x2, y2 = EntityGetTransform(entity)
            bonk = false
            EntityKill(entity)
            SetRandomSeed(GameGetFrameNum() + entity, 203458 + #new_pool + GameGetFrameNum())
            GamePlaySound("data/audio/Desktop/items.bank", "magic_wand/mana_fully_recharged", x2, y2)
            EntityLoad("data/entities/particles/poof_green.xml", x2, y2)
            CreateItemActionEntity(new_pool[(which % #new_pool) + 1], x2, y2)
        end
    end
end

if bonk then
    GamePlaySound("data/audio/Desktop/ui.bank", "ui/button_denied", x, y)
end

EntityKill(me)