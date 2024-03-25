local tick = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")
if tick > 1200 and (tick % 700 == 0 or (240 + tick) % 700 == 0) then
    local me = GetUpdatedEntityID()
    dofile_once("mods/boss_reworks/files/projectile_utils.lua")
    local x, y = EntityGetTransform(me)
    local player = EntityGetClosestWithTag(x, y, "player_unit") or EntityGetClosestWithTag(x, y, "polymorphed_player")
    local x2, y2 = EntityGetTransform(player)
    local distance = math.sqrt((x2 - x)^2 + (y2 - y)^2)
    local speed = 20
    local how_many = 10
    local angle_inc = (2 * math.pi) / how_many
    local theta = 0
    if (240 + tick) % 800 == 0 then theta = angle_inc / 2 end
    for i = 1, how_many do
        local vel_x = math.cos(theta) * speed
        local vel_y = math.sin(theta) * speed
        theta = theta + angle_inc
        for j = 3, math.max(4, (distance / speed) + 2) do
            local eid = ShootProjectile(me, "mods/boss_reworks/files/boss_robot/succ.xml", x + vel_x * j, x + vel_y * j, vel_x, vel_y, 0.175)
            local proj = EntityGetFirstComponent(eid, "ProjectileComponent")
            if proj then
                ComponentSetValue2(proj, "ragdoll_force_multiplier", vel_x * j)
                ComponentSetValue2(proj, "hit_particle_force_multiplier", vel_y * j)
            end
        end
    end
end