function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
    if #(EntityGetWithTag("boss_reworks_this_is_boss") or {}) <= 1 then -- hopefully works well for multi-bosses
        local x = tonumber(GlobalsGetValue("BR_BOSS_RUSH_PORTAL_X", "0")) or 0
        local y = tonumber(GlobalsGetValue("BR_BOSS_RUSH_PORTAL_Y", "0")) or 0
        local next = GlobalsGetValue("BR_BOSS_RUSH_PORTAL_NEXT", "") or ""
        local portal
        if GlobalsGetValue("BR_MODE", "0") == "Calamari" then
            portal = EntityLoad("mods/boss_reworks/files/boss_rush/portals/boss_rush_portal_spawn.xml", x, y)
        else
            portal = EntityLoad("mods/boss_reworks/files/boss_rush/portals/boss_rush_portal_base.xml", x, y)
            EntitySetName(portal, next)
            local ui = EntityGetFirstComponent(portal, "UIInfoComponent")
            if ui then
                ComponentSetValue2(ui, "name", next)
            end
        end
        if portal then
            local teleport = EntityGetFirstComponentIncludingDisabled(portal, "TeleportComponent")
            if teleport then EntitySetComponentIsEnabled(portal, teleport, false) end
            EntityAddComponent2(portal, "LuaComponent", {
                script_source_file="mods/boss_reworks/files/boss_rush/portals/portal_enable.lua",
                remove_after_executed=true,
                execute_every_n_frame=120,
            })
            local particles = EntityGetFirstComponentIncludingDisabled(portal, "ParticleEmitterComponent")
            if particles then EntitySetComponentIsEnabled(portal, particles, false) end
        end
        local projectiles = EntityGetWithTag("projectile") or {} -- this will cause no issues
        for i = 1, #projectiles do
            local x2, y2 = EntityGetTransform(projectiles[i])
            EntityLoad("data/entities/particles/poof_blue.xml", x2, y2)
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
        GamePlaySound( "data/audio/Desktop/misc.bank", "misc/beam_from_sky_kick", x, y )
    end
    EntityConvertToMaterial(GetUpdatedEntityID(), "spark_blue")
    GameScreenshake(50)
end