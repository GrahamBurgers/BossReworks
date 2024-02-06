local me = GetUpdatedEntityID()
local comp = EntityGetFirstComponentIncludingDisabled(me, "ParticleEmitterComponent")
local var = EntityGetFirstComponentIncludingDisabled(me, "GameEffectComponent")
if not comp or not var then return end
local x, y = EntityGetTransform(me)
local parent = EntityGetRootEntity(me)
if parent ~= me then
    x, y = EntityGetTransform(parent)
    x = x - 1
    y = y - 1
end
local amount = ComponentGetValue2(var, "frames")
local maxamount = ComponentGetValue2(var, "teleportation_radius_max")

amount = math.min(maxamount, math.max(0, amount))
ComponentSetValue2(comp, "area_circle_sector_degrees", 360 * (amount / maxamount))
ComponentSetValue2(comp, "count_min", math.ceil(120 * (amount / maxamount)))
ComponentSetValue2(comp, "count_max", math.ceil(150 * (amount / maxamount)))
local turn = (math.pi / -2) - ((amount / maxamount) * math.pi)
EntitySetTransform(me, x, y, turn)

ComponentSetValue2(comp, "is_emitting", true)