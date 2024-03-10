local comp = EntityGetComponentIncludingDisabled(GetUpdatedEntityID(), "LaserEmitterComponent") or {}
for i = 1, #comp do
    ComponentObjectSetValue2(comp[i], "laser", "beam_particle_type", CellFactory_GetType("spark_white_bright"))
    ComponentObjectSetValue2(comp[i], "laser", "beam_particle_chance", 100)
end