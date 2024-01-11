local x, y = EntityGetTransform(GetUpdatedEntityID())
local player = EntityGetClosestWithTag(x, y, "player_unit") or EntityGetClosestWithTag(x, y, "polymorphed_player")
if not player then return end
x, y = EntityGetTransform(player)
SetRandomSeed(x + GameGetFrameNum(), y + 42985)
dofile_once("mods/boss_reworks/files/projectile_utils.lua")
for i = 1, 2 do
    local x2 = x + Random(180, -180)
    local y2 = y + Random(140, 180)
    ShootProjectile(GetUpdatedEntityID(), "mods/boss_reworks/files/boss_fish/bubble.xml", x2, y2, 0, 0, 1)
end