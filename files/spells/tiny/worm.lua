local me = GetUpdatedEntityID()
local worm = EntityGetRootEntity(me)
local comp = GetUpdatedComponentID()
local dmg = EntityGetFirstComponent(worm, "DamageModelComponent")
local wormcomp = EntityGetFirstComponent(worm, "WormComponent")
if ComponentGetValue2(comp, "mTimesExecuted") == 1 then
    EntityAddTag(worm, "br_worm_combo_entity")
    GlobalsSetValue("BR_WORM_COMBO", "600")
    GlobalsSetValue("BR_WORM_COMBO_MAX", "600")
    local eid = EntityCreateNew()
    EntityAddComponent2(eid, "LuaComponent", {
        script_source_file="data/scripts/perks/radar.lua"
    })
    EntityAddComponent2(eid, "InheritTransformComponent")
    EntityAddTag(eid, "boss_reworks_boss_rush")
    EntityAddChild(worm, eid)
    EntityRemoveTag(worm, "enemy")
    GlobalsSetValue("BR_WORM_SCORE", "0")
    if dmg then
        ComponentSetValue2(dmg, "wait_for_kill_flag_on_death", true)
    end
    if wormcomp then
        ComponentSetValue2(wormcomp, "bite_damage", 0)
        ComponentSetValue2(wormcomp, "target_kill_radius", 0)
        ComponentSetValue2(wormcomp, "gravity", 0.5 * ComponentGetValue2(wormcomp, "gravity"))
        ComponentSetValue2(wormcomp, "tail_gravity", 0.5 * ComponentGetValue2(wormcomp, "tail_gravity"))
        EntityAddComponent2(worm, "DamageNearbyEntitiesComponent", {
            radius=18,
            time_between_damaging=1,
            target_tag="mortal",
            damage_type="DAMAGE_MELEE",
            ragdoll_fx="NONE",
            damage_min=0.6,
            damage_max=0.6,
        })
    end
    local hp1 = EntityGetFirstComponent(worm, "HealthBarComponent")
    if hp1 then EntityRemoveComponent(worm, hp1) end
    local hp2 = EntityGetFirstComponent(worm, "SpriteComponent", "health_bar")
    if hp2 then EntityRemoveComponent(worm, hp2) end
    local hp3 = EntityGetFirstComponent(worm, "SpriteComponent", "health_bar_back")
    if hp3 then EntityRemoveComponent(worm, hp3) end
else
    local amount = tonumber(GlobalsGetValue("BR_WORM_COMBO", "0")) or 0
    local max = tonumber(GlobalsGetValue("BR_WORM_COMBO_MAX", "0"))
    amount = amount - 1.2
    max = max - 0.5
    if dmg then
        local hp = ComponentGetValue2(dmg, "hp")
        local max_hp = ComponentGetValue2(dmg, "max_hp")
        local diff = (max_hp - hp) * 25
        if diff >= 5 then
            ComponentSetValue2(dmg, "hp", max_hp)
            amount = amount - diff
            max = max - diff
            diff = diff * 2.5
            GamePrint(GameTextGet("$br_wormpoints_damage_taken", tostring(math.ceil(diff))))
            GlobalsSetValue("BR_WORM_SCORE", tostring(0 - math.ceil(diff) + tonumber(GlobalsGetValue("BR_WORM_SCORE", "0"))))
        end
    end
    GlobalsSetValue("BR_WORM_COMBO", tostring(amount))
    GlobalsSetValue("BR_WORM_COMBO_MAX", tostring(max))
    local cid = GameGetGameEffect(worm, "POLYMORPH")
    if cid and amount > 0 then
        ComponentSetValue2(cid, "frames", 2)
    end
end