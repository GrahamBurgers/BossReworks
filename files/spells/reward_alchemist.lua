local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
-- should homing_target or destruction_target be used here?
local targets = EntityGetInRadiusWithTag(x, y, 12, "homing_target") or {}
local players = EntityGetInRadiusWithTag(x, y, 12, "player_unit") or {}
for i = 1, #players do
    targets[#targets+1] = players[i]
end
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
if not proj then return end

local valid = {}
for i = 1, #targets do
    local x2, y2 = EntityGetTransform(targets[i])
    local distance = (x2 - x)^2 + (y2 - y)^2
    if targets[i] ~= ComponentGetValue2(proj, "mWhoShot") then
        if #valid == 0 then
            table.insert(valid, {targets[i], distance})
            table.insert(valid, {targets[i], distance})
        else
            for k = 1, #valid do
                if (valid[k][2] > distance or k == #valid) then
                    table.insert(valid, k, {targets[i], distance})
                    break
                end
            end
        end
    end
end
table.remove(valid, #valid) -- hax?
if #valid > 0 then
    local entity = valid[1][1]
    local x2, y2 = EntityGetTransform(entity)
    local existing = EntityGetAllChildren(entity, "alchemist_soul") or {}
    local current = nil
    for i = 1, #existing do
        local comp = EntityGetFirstComponent(existing[i], "GameEffectComponent")
        if comp then
            current = ComponentGetValue2(comp, "effect")
        end
        EntityKill(existing[i])
    end

    local frames = -1
    local statuses = {
        "BERSERK", "CHARM", "DRUNK", "FOOD_POISONING", "REGENERATION",
        "MOVEMENT_FASTER", "POISON", "PROTECTION_ALL", "JARATE",
        "TELEPORTATION", "NONE", "MOVEMENT_SLOWER", "INVISIBILITY"
    }
    local no_player = {
        "REGENERATION", "PROTECTION_ALL"
    }
    local new_statuses = {}
    for i = 1, #statuses do
        local insert = true
        if statuses[i] == current then
            insert = false
        end
        if EntityHasTag(entity, "player_unit") then
            frames = 36000 -- applying status effect to yourself is a neat tech but should not be permanent
            for j = 1, #no_player do
                if statuses[i] == no_player[j] then
                    insert = false
                    break
                end
            end
        end
        if insert then new_statuses[#new_statuses+1] = statuses[i] end
    end
    SetRandomSeed(GameGetFrameNum() + entity, 203458 + frames + GameGetFrameNum())
    local choice = new_statuses[Random(1, #new_statuses)]
    local effect = EntityCreateNew()
    EntityAddTag(effect, "alchemist_soul")
    EntityAddComponent2(effect, "GameEffectComponent", {
        effect=choice,
        frames=frames,
        teleportation_probability=200,
		teleportation_delay_min_frames=600,
    })
    EntityAddComponent2(effect, "UIIconComponent", {
		icon_sprite_file="mods/boss_reworks/files/spells/alchemist/" .. string.lower(choice) .. ".png",
		is_perk=false,
		display_above_head=true,
		display_in_hud=true,
        name="$br_alchstatus_name",
        description="$br_alchstatus_desc",
    })
    EntityAddChild(entity, effect)
    EntityLoad("data/entities/particles/poof_blue.xml", x2, y2)
    EntityApplyTransform(me, x2, y2)
    EntityKill(me)
end