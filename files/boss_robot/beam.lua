local tick = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")
if tick % 300 == 0 or tick % 350 == 0 or tick % 400 == 0 then
    local me = GetUpdatedEntityID()
    dofile_once("mods/boss_reworks/files/projectile_utils.lua")
    local x, y = EntityGetTransform(me)
    local player = EntityGetClosestWithTag(x, y, "player_unit") or EntityGetClosestWithTag(x, y, "polymorphed_player")
    local x2, y2 = EntityGetTransform(player)
    local minimum = 140
    local distance = (x2 - x)^2 + (y2 - y)^2
    local power = -0.14
    if distance < minimum ^ 2 then return end
    local move = 20
    if x2 > x then move = -20 end
    for i = 1, 20 do
        local dir = 0 - math.atan((y2-y)/(x2-x))
        if i < 3 then move = move * -1 end
        local vel_x = math.cos( dir ) * move
        local vel_y = 0 - math.sin( dir ) * move
        x2 = x2 + vel_x
        y2 = y2 + vel_y
        ShootProjectileAtEntity(me, "mods/boss_reworks/files/boss_robot/succ.xml", x2, y2, me, power)
        distance = (x2 - x)^2 + (y2 - y)^2
        if distance < minimum ^ 2 then break end
    end
end