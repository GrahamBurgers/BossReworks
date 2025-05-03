local particles = EntityGetFirstComponentIncludingDisabled(GetUpdatedEntityID(), "ParticleEmitterComponent")
if particles then EntitySetComponentIsEnabled(GetUpdatedEntityID(), particles, false) end