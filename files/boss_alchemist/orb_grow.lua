local eid = GetUpdatedEntityID()
local gae = EntityGetComponent(eid, "GameAreaEffectComponent") or {}
local radius
for k, v in ipairs(gae) do
	radius = ComponentGetValue2(v, "radius") + 0.05
	ComponentSetValue2(v, "radius", radius)
end
local x, y, theta = EntityGetTransform(eid)
EntitySetTransform(eid, x, y, theta, radius / 4, radius / 4)
