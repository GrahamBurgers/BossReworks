local comp = EntityGetFirstComponent(GetUpdatedEntityID(), "ParticleEmitterComponent")
local var = EntityGetFirstComponent(GetUpdatedEntityID(), "VariableStorageComponent")
local x, y = EntityGetTransform(GetUpdatedEntityID())
if not comp or not var then return end
local amount = ComponentGetValue2(var, "value_float") - 0.6
amount = math.min(360, math.max(0, amount))
ComponentSetValue2(comp, "area_circle_sector_degrees", amount)
ComponentSetValue2(comp, "count_min", math.ceil(amount * 1.8))
ComponentSetValue2(comp, "count_max", math.ceil(amount * 1.8))
ComponentSetValue2(var, "value_float", amount)
local turn = (math.pi / -2) + ((amount / 360) * math.pi)
EntitySetTransform(GetUpdatedEntityID(), x, y, turn)