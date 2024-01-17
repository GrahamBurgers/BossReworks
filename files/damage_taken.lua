function turn_off_the_thingy()
    -- hopefully prevents double-taps from dealing actual damage on your way out
    GlobalsSetValue("BR_BOSS_RUSH_ACTIVE", "0")
end

function damage_received( damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible )
    if GlobalsGetValue("BR_BOSS_RUSH_ACTIVE", "0") == "1" and message ~= "$br_boss_rush_test" then
        ---@diagnostic disable-next-line: undefined-global
        EntityInflictDamage(GetUpdatedEntityID(), 0 - damage, "DAMAGE_HEALING", "$br_boss_rush_test", "NONE", 0, 0)

        local old_fake_hp = tonumber(GlobalsGetValue("BR_BOSS_RUSH_HP_LEFT", "0"))
        damage = damage * 25
        old_fake_hp = old_fake_hp / 100
        local fake_hp = old_fake_hp - damage
        GlobalsSetValue("BR_BOSS_RUSH_HP_LEFT", tostring(fake_hp * 100))
        GamePrint(fake_hp .. ", " .. tostring(damage))
        if fake_hp <= 0 and old_fake_hp > 0 then
            EntitySetTransform(GetUpdatedEntityID(), 6400, 50000)
            EntityApplyTransform(GetUpdatedEntityID(), 6400, 50000)
            SetTimeOut(0.08, "mods/boss_reworks/files/damage_taken.lua", "turn_off_the_thingy")
            SetRandomSeed(GameGetFrameNum() + damage, GameGetFrameNum() + 24085)
            GamePrintImportant("$br_boss_rush_death_0", "$br_boss_rush_death_" .. Random(1, 9))
            local entities = EntityGetWithTag("boss_reworks_boss_rush") or {}
            for i = 1, #entities do
                EntitySetComponentsWithTagEnabled(entities[i], "boss_reworks_rush_remove", false)
                EntityKill(entities[i])
            end
        end
    end
end