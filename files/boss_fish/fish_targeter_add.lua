local x, y = EntityGetTransform(GetUpdatedEntityID())
SetRandomSeed(x + 4280, y + GetUpdatedComponentID())
local toggle = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")
if toggle % 2 == 0 then
    y = y + 35
    dofile_once("mods/boss_reworks/files/projectile_utils.lua")
    for i = 1, Random(20, 25) do
        local fish
        if Random(1, 3) < 3 then
            fish = EntityLoad("data/entities/animals/fish.xml", x + Random(-20, 20), y + Random(-20, 20))
        else
            fish = EntityLoad("data/entities/animals/fish_large.xml", x + Random(-20, 20), y + Random(-20, 20))
        end
        local comp = EntityGetFirstComponent(fish, "DamageModelComponent")
        if comp then
            ComponentSetValue2(comp, "create_ragdoll", false)
        end
    end
    local eid = EntityLoad("mods/boss_reworks/files/boss_fish/fish_targeter.xml", x, y)
    EntityAddChild(GetUpdatedEntityID(), eid)
else
    SetRandomSeed(GameGetFrameNum(), GameGetFrameNum())
    dofile_once("mods/boss_reworks/files/projectile_utils.lua")
    local player = EntityGetClosestWithTag(x, y, "player_unit") or EntityGetClosestWithTag(x, y, "polymorphed_player")
    x, y = EntityGetTransform(player)
    local lists = {{5, 5}, {5, -5}, {-5, 5}, {-5, -5}, {0, 5}, {0, -5}, {-5, 0}, {5, 0}}
    for j = 1, #lists do
        local x2 = lists[j][1]
        local y2 = lists[j][2]
        for i = 3, 8 do ShootProjectile(GetUpdatedEntityID(), "mods/boss_reworks/files/boss_fish/water.xml", x + 1.4 * x2 * i, y + 1.4 * y2 * i, x2 / 5, y2 / 5) end
    end
end