function turn_off_the_thingy()
    -- hopefully prevents double-taps from dealing actual damage on your way out
    GlobalsSetValue("BR_BOSS_RUSH_ACTIVE", "0")
end

function damage_received( damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible )
    local me = GetUpdatedEntityID()
    if GlobalsGetValue("BR_BOSS_RUSH_ACTIVE", "0") == "1" and GameGetGameEffectCount(me, "PROTECTION_ALL") <= 0 then
        ---@diagnostic disable-next-line: undefined-global
        -- EntityInflictDamage(me, 0 - damage, "DAMAGE_HEALING", "$br_boss_rush_test", "NONE", 0, 0)
        local health = EntityGetFirstComponent(me, "DamageModelComponent") or 0
        ComponentSetValue2(health, "hp", ComponentGetValue2(health, "hp") + damage)
        local max = tonumber(GlobalsGetValue("BR_BOSS_RUSH_HP_MAX") or "0") or 0
        local multiplier = tonumber(GlobalsGetValue("BR_BOSS_RUSH_HP_MULTIPLIER") or "0")

        local old_fake_hp = tonumber(GlobalsGetValue("BR_BOSS_RUSH_HP_LEFT", "0"))
        damage = damage * 25
        old_fake_hp = old_fake_hp / multiplier
        local fake_hp = old_fake_hp - damage
        GlobalsSetValue("BR_BOSS_RUSH_HP_LEFT", tostring(math.min(max, fake_hp * multiplier)))
        if fake_hp <= 0 then
            local x, y = 6400, 50025
            EntityAddRandomStains(me, CellFactory_GetType("boss_reworks_unstainer"), 2000)
            EntitySetTransform(me, x, y)
            EntityApplyTransform(me, x, y)
            GameSetCameraPos(x, y)
            SetTimeOut(0.08, "mods/boss_reworks/files/damage_taken.lua", "turn_off_the_thingy")
            SetRandomSeed(GameGetFrameNum() + damage, GameGetFrameNum() + 24085)
            GamePrintImportant("$br_boss_rush_death_0", "$br_boss_rush_death_1")
            ComponentSetValue2(health, "mFireFramesLeft", 0)
            local effect, entity = GetGameEffectLoadTo(me, "PROTECTION_ALL", true)
            EntityAddComponent2(entity, "LifetimeComponent", {
                lifetime=600,
            })
            local entities = EntityGetWithTag("boss_reworks_boss_rush") or {}
            for i = 1, #entities do
                EntitySetComponentsWithTagEnabled(entities[i], "boss_reworks_rush_remove", false)
                local children = EntityGetAllChildren(entities[i]) or {}
                for j = 1, #children do
                    EntityKill(children[j])
                end
                EntityKill(entities[i])
            end
            local effect = EntityCreateNew()
            EntityAddComponent2(effect, "GameEffectComponent", {
                effect="BLINDNESS",
                frames=180,
            })
            EntityAddChild(me, effect)

            dofile_once("data/scripts/perks/perk.lua")
            IMPL_remove_all_perks(me)
            local projectiles = EntityGetWithTag("projectile") or {} -- this will cause no issues
            for i = 1, #projectiles do
                local comps = EntityGetComponent(projectiles[i], "ProjectileComponent") or {}
                for j = 1, #comps do
                    ComponentSetValue2(comps[j], "on_death_explode", false)
                    ComponentSetValue2(comps[j], "on_lifetime_out_explode", false)
                    ComponentObjectSetValue2(comps[j], "config_explosion", "damage", 0)
                    ComponentObjectSetValue2(comps[j], "config_explosion", "hole_enabled", false)
                    ComponentObjectSetValue2(comps[j], "config_explosion", "explosion_radius", 0)
                end
                local what = EntityGetComponent(projectiles[i], "ExplodeOnDamageComponent") or {}
                for j = 1, #what do
                    ComponentSetValue2(what[j], "explode_on_death_percent", 0)
                    ComponentObjectSetValue2(what[j], "config_explosion", "damage", 0)
                    ComponentObjectSetValue2(what[j], "config_explosion", "hole_enabled", false)
                    ComponentObjectSetValue2(what[j], "config_explosion", "explosion_radius", 0)
                end
                local why = EntityGetComponent(projectiles[i], "ExplosionComponent") or {}
                for j = 1, #why do
                    ComponentObjectSetValue2(why[j], "config_explosion", "damage", 0)
                    ComponentObjectSetValue2(why[j], "config_explosion", "hole_enabled", false)
                    ComponentObjectSetValue2(why[j], "config_explosion", "explosion_radius", 0)
                end
                EntitySetTransform(projectiles[i], x, y)
                EntityApplyTransform(projectiles[i], x, y)
                EntityKill(projectiles[i])
            end
            return
        end
        if damage > 0 then
            GlobalsSetValue("BR_BOSS_RUSH_NOHIT", "0")
        end
    end
end