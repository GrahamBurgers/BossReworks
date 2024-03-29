dofile_once("mods/boss_reworks/files/projectile_utils.lua")

local entity_id = EntityGetRootEntity(GetUpdatedEntityID())
local x, y = EntityGetTransform( entity_id )
local projectiles = EntityGetInRadiusWithTag( x, y, 48, "projectile" ) or {}

for i,projectile_id in ipairs(projectiles) do
    local px, py = EntityGetTransform( projectile_id )
    local who_shot, herd
    local projs = EntityGetComponentIncludingDisabled( projectile_id, "ProjectileComponent" ) or {}
    for j = 1, #projs do
        who_shot = ComponentGetValue2(projs[j], "mWhoShot") or who_shot
        herd = ComponentGetValue2(projs[j], "mShooterHerdId") or herd
    end

    if who_shot ~= entity_id and herd ~= StringToHerdId("mage") and not EntityHasTag( projectile_id, "boss_alchemist" ) then
        for j = 1, #projs do
            ComponentSetValue2(projs[j], "on_death_explode", false)
            ComponentSetValue2(projs[j], "on_lifetime_out_explode", false)
        end

        local projectile = "data/entities/projectiles/deck/rocket.xml"

        local varsto = EntityGetComponentIncludingDisabled( projectile_id, "VariableStorageComponent" ) or {}
        for j = 1, #varsto do
            if ( ComponentGetValue2( varsto[j], "name" ) == "projectile_file" ) then
                projectile = ComponentGetValue2( varsto[j], "value_string" )
                break
            end
        end

        local vel_x, vel_y = 0, 0
        local velco = EntityGetFirstComponent(projectile_id, "VelocityComponent")
        if velco then
            vel_x, vel_y = ComponentGetValue2(velco, "mVelocity")
        end
        local projcomps = EntityGetComponentIncludingDisabled(projectile_id, "ProjectileComponent") or {}
        for j = 1, #projcomps do
            local dmg = ComponentGetValue2( projcomps[j], "damage" )
            dmg = dmg + 0.4 -- from 0.6
            ComponentSetValue2( projcomps[j], "damage", dmg )

            local edmg = ComponentObjectGetValue( projcomps[j], "config_explosion", "damage" )
            if ( edmg ~= nil ) then
                edmg = edmg * 1.5 -- from 2.0
                ComponentObjectSetValue( projcomps[j], "config_explosion", "damage", edmg )
            end
        end

        if ( string.len(projectile) > 0 ) then -- how would this not be true?
        -- 2\vec{n}(\vec{v} \cdot \vec{n})-\vec{v}
            local nx, ny = px - x, py - y
            local mag = (nx * nx + ny * ny) ^ 0.5
            nx, ny = nx / mag, ny / mag
            -- print(nx, ny)
            local vmag = (vel_x * vel_x + vel_y * vel_y) ^ 0.5
            vel_x, vel_y = vel_x / vmag, vel_y / vmag
            -- print(vel_x, vel_y)
            local dot = nx * vel_x + ny * vel_y
            local rx, ry = 2 * nx * dot, 2 * ny * dot
            rx, ry = rx - vel_x, ry - vel_y
            rx, ry = rx * vmag, ry * vmag
            -- print(rx, ry)
            local eid = ShootProjectile( entity_id, projectile, px, py, -rx, -ry, 0.5 )
            EntityAddTag( eid, "boss_alchemist" )
            EntityLoadToEntity("data/entities/animals/boss_alchemist/countered_projectile_effect.xml", eid)
        end
        EntityKill( projectile_id )
    end
end