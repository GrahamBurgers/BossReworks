local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local player = EntityGetClosestWithTag(x, y, "player_unit") or EntityGetClosestWithTag(x, y, "polymorphed_player")
local sprite = EntityGetFirstComponent(me, "SpriteComponent")
if not player or not sprite then return end
local px,py = EntityGetTransform( player )
local dir = math.atan((py - y) / (px - x))
if px < x then
    dir = dir + math.pi
    ComponentSetValue2(sprite, "has_special_scale", false)
else
    ComponentSetValue2(sprite, "has_special_scale", true)
end
EntitySetTransform(me, x, y, dir)
if string.match(ComponentGetValue2(sprite, "image_file"), "^.+(%..+)$") ~= ".xml" then -- totally didn't have to look this up
    EntityRefreshSprite(me, sprite)
end