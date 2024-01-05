local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local x, y = EntityGetTransform(me)
local amount = #EntityGetWithTag("gate_monster")
ComponentSetValue2(this, "execute_every_n_frame", (amount * 14) - 9)
dofile_once("mods/boss_reworks/files/projectile_utils.lua")
local rocks = {"rock_a", "rock_b", "rock_c", "rock_d", "rock_b", "rock_e", "rock_f", "rock_g", "rock_h"}
local count = ((ComponentGetValue2(this, "mTimesExecuted") - 1) % #rocks) + 1
local spray = (math.sin((GameGetFrameNum() / 30) + GetUpdatedEntityID() * 20) * 200)
local entity = ShootProjectile( me, "mods/boss_reworks/files/boss_gate/glyph_shot.xml", x, y, spray, -135)
ComponentSetValue2(EntityGetFirstComponent(entity, "VelocityComponent") or 0, "mVelocity", spray, -135)
local comps = EntityGetComponent(entity, "SpriteComponent") or {}
for i = 1, #comps do
    if ComponentGetValue2(comps[i], "image_file") == "mods/boss_reworks/files/boss_gate/glyphs/rock_a.png" then
        ComponentSetValue2(comps[i], "image_file", "mods/boss_reworks/files/boss_gate/glyphs/" .. rocks[count] .. ".png")
    end
    if ComponentGetValue2(comps[i], "image_file") == "mods/boss_reworks/files/boss_gate/glyphs/rock_glow.png" then
        -- ComponentSetValue2(comps[i], "image_file", "mods/boss_reworks/files/boss_gate/glyphs/" .. rocks[count] .. "_glow.png")
        ComponentSetValue2(comps[i], "image_file", "mods/boss_reworks/files/boss_gate/glyphs/rock_glow.png")
    end
    EntityRefreshSprite(entity, comps[i])
end