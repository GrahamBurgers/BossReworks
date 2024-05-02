local teleport = EntityGetFirstComponentIncludingDisabled(GetUpdatedEntityID(), "TeleportComponent")
if teleport then EntitySetComponentIsEnabled(GetUpdatedEntityID(), teleport, true) end
local particles = EntityGetFirstComponentIncludingDisabled(GetUpdatedEntityID(), "ParticleEmitterComponent")
if particles then EntitySetComponentIsEnabled(GetUpdatedEntityID(), particles, true) end