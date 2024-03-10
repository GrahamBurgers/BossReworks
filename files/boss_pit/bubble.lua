local me = GetUpdatedEntityID()
local comp = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local var = EntityGetFirstComponentIncludingDisabled(me, "VariableStorageComponent")
if not var or not comp then return end
local x2 = ComponentGetValue2(comp, "bounce_energy")
local y2 = ComponentGetValue2(comp, "die_on_low_velocity_limit")
local distance = ComponentGetValue2(var, "value_int")
local theta = tonumber(ComponentGetValue2(var, "value_string")) or 0
---@cast theta number
local rotate = ComponentGetValue2(var, "value_float")

local off_x = math.cos(theta) * distance
local off_y = math.sin(theta) * distance
ComponentSetValue2(var, "value_int", distance + 1)
ComponentSetValue2(var, "value_string", theta + rotate / distance)
EntitySetTransform(me, x2 + off_x, y2 + off_y, 0)