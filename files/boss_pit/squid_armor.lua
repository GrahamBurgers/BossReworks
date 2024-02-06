function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
    local me = GetUpdatedEntityID()
    local damagemodel = EntityGetFirstComponent(me, "DamageModelComponent")
    local varsto = EntityGetFirstComponentIncludingDisabled(me, "VariableStorageComponent", "squid_shield_trigger")
    if not damagemodel or not varsto then return end
    local max_hp = ComponentGetValue2(damagemodel, "max_hp")
    local hp = ComponentGetValue2(damagemodel, "hp")
    local phase = ComponentGetValue2(varsto, "value_int")
    if phase == 1 then damage = damage * 2.5 end
    if phase == -1 then return damage, critical_hit_chance end
    local allowance = 2 -- how much more you're able to damage him in each phase: 1 = 10%

    local acceptable_hp = max_hp * ((10 - phase * allowance) / 10)
    if acceptable_hp < 0.04 then
        acceptable_hp = 0.04
    end
    local new_damage = math.min(damage, hp - acceptable_hp)
    if (acceptable_hp > 0 and hp - damage <= acceptable_hp) then
        local children = EntityGetAllChildren(me) or {}
        for i = 1, #children do
            if EntityGetName(children[i]) == "squid_shield" then
                return new_damage, critical_hit_chance
            end
        end
        ComponentSetValue2(damagemodel, "hp", acceptable_hp)
        local eid = EntityLoad("mods/boss_reworks/files/boss_pit/squid_shield.xml", x, y)
        EntityAddChild(me, eid)
        local duration = 10 + 5 * (phase - 1) -- X seconds + Y more for each time squid has been shielded previously; tweak numbers as needed
        EntityAddComponent2(eid, "GameEffectComponent", {
            frames = duration * 60,
            effect = "PROTECTION_ALL",
            teleportation_radius_max = duration * 60, -- use teleportation_radius_max as dummy variable (for dummies)
        })
        ComponentSetValue2(varsto, "value_int", phase + 1)
        if acceptable_hp <= 0.04 then ComponentSetValue2(varsto, "value_int", -1) end
    end
    return new_damage, critical_hit_chance
end