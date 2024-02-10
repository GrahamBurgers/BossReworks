local me = GetUpdatedEntityID()
local comp = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local who_shot = 0
if comp then
    who_shot = ComponentGetValue2(comp, "mWhoShot") or 0
end
local var = EntityGetFirstComponentIncludingDisabled(me, "VariableStorageComponent")
if who_shot == 0 or not var then return end
local x2, y2 = EntityGetTransform(who_shot)
if x2 == nil or y2 == nil then return end
local distance = ComponentGetValue2(var, "value_int")
local theta = tonumber(ComponentGetValue2(var, "value_string")) or 0
local rotate = ComponentGetValue2(var, "value_float")

local off_x = math.cos(theta) * distance
local off_y = math.sin(theta) * distance
ComponentSetValue2(var, "value_int", distance + 1)
ComponentSetValue2(var, "value_string", theta + rotate / distance)
EntitySetTransform(me, x2 + off_x, y2 + off_y, 0)