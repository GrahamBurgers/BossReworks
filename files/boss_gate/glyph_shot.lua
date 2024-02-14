local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local x, y = EntityGetTransform(me)
local amount = #EntityGetWithTag("gate_monster")
ComponentSetValue2(this, "execute_every_n_frame", (amount * 14) - 9)
dofile_once("mods/boss_reworks/files/projectile_utils.lua")
local rocks = {"rock_a", "rock_b", "rock_c", "rock_d", "rock_b", "rock_e", "rock_f", "rock_g", "rock_h"}
local count = ((ComponentGetValue2(this, "mTimesExecuted") - 1) % #rocks) + 1
local spray = (math.sin((GameGetFrameNum() / 30) + GetUpdatedEntityID() * 20) * 200)
local entity = ShootProjectile( me, "mods/boss_reworks/files/boss_gate/glyph_shot.xml", x, y, spray, -145)
ComponentSetValue2(EntityGetFirstComponent(entity, "VelocityComponent") or 0, "mVelocity", spray, -145)
local comp = EntityGetFirstComponent(entity, "LuaComponent") or 0
ComponentSetValue2(comp, "script_material_area_checker_failed", "mods/boss_reworks/files/boss_gate/glyphs/" .. rocks[count] .. ".png")