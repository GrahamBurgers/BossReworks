local me = GetUpdatedEntityID()
local vel = EntityGetFirstComponent(me, "VelocityComponent")
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
if not vel or not proj then return end
local vel_x, vel_y = ComponentGetValue2(vel, "mVelocity")
local target_x = ComponentGetValue2(proj, "ragdoll_force_multiplier")
local target_y = ComponentGetValue2(proj, "hit_particle_force_multiplier")
vel_x = vel_x + (target_x - vel_x) / 40
vel_y = vel_y + (target_y - vel_y) / 40
ComponentSetValue2(vel, "mVelocity", vel_x, vel_y)