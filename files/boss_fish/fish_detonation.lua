local me = GetUpdatedEntityID()
local sprites = EntityGetComponent(me, "SpriteComponent") or {}
local x, y = EntityGetTransform(me)
for i = 1, #sprites do
    if ComponentGetValue2(sprites[i], "image_file") == "mods/boss_reworks/files/boss_fish/fish_warn.xml" then
        EntityRemoveComponent(me, sprites[i])
    end
end
local amount = 3
if EntityGetName(me) == "$animal_fish_large" then amount = 5 end
dofile_once("mods/boss_reworks/files/projectile_utils.lua")
CircleShot(me, "mods/boss_reworks/files/boss_fish/swirl.xml", amount, x, y, 45, math.pi * 2)
GameScreenshake(amount)
EntityKill(me)