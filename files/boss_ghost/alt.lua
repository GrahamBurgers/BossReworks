local x, y = EntityGetTransform(GetUpdatedEntityID())
SetRandomSeed(GameGetFrameNum() + 24058 + x, y + GetUpdatedComponentID() + 42985)
if Random(1, 500) < 500 then return end
local entity = EntityGetAllChildren(GetUpdatedEntityID())[1]
local comp = EntityGetFirstComponent(entity, "SpriteComponent")
if comp then
    ComponentSetValue2(comp, "alpha", 0)
    EntityRefreshSprite(entity, comp)
end
local sprites = EntityGetComponent(GetUpdatedEntityID(), "SpriteComponent") or {}
for i = 1, #sprites do
    if ComponentGetValue2(sprites[i], "image_file") == "data/entities/animals/boss_ghost/body.xml" then
        ComponentSetValue2(sprites[i], "image_file", "mods/boss_reworks/files/boss_ghost/alt_body.xml")
        EntityRefreshSprite(entity, sprites[i])
    end
    if ComponentGetValue2(sprites[i], "image_file") == "data/entities/animals/boss_ghost/eye.xml" then
        ComponentSetValue2(sprites[i], "image_file", "mods/boss_reworks/files/boss_ghost/alt_eye.xml")
        EntityRefreshSprite(entity, sprites[i])
    end
end