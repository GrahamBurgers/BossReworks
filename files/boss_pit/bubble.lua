local me = GetUpdatedEntityID()
local comp = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local who_shot = 0
if comp then
    who_shot = ComponentGetValue2(comp, "mWhoShot")
end
local var = EntityGetFirstComponentIncludingDisabled(me, "VariableStorageComponent")
if who_shot == 0 or not var then EntityKill(me) return end
local distance = ComponentGetValue2(var, "value_float")
local theta = ComponentGetValue2(var, "value_string")
local rotate = tonumber(ComponentGetValue2(var, "value_int")) / 100

local off_x = math.cos(theta) * distance
local off_y = math.sin(theta) * distance
local x2, y2 = EntityGetTransform(who_shot)
ComponentSetValue2(var, "value_float", distance + 1)
ComponentSetValue2(var, "value_string", theta + rotate)
EntitySetTransform(me, x2 + off_x, y2 + off_y, theta)