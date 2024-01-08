local x, y = EntityGetTransform(GetUpdatedEntityID())
y = y + 35
SetRandomSeed(x + 4280, y + GetUpdatedComponentID())
dofile_once("mods/boss_reworks/files/projectile_utils.lua")
for i = 1, Random(30, 40) do
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