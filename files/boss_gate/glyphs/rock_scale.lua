local me = GetUpdatedEntityID()
local comp = EntityGetFirstComponent(me, "SpriteParticleEmitterComponent") or 0
if comp ~= nil then
    local x, y = ComponentGetValue2(comp, "scale")
    x = x + (1 - x) / 14
    ComponentSetValue2(comp, "scale", x, x)
end