dofile_once("mods/boss_reworks/files/projectile_utils.lua")
local me = GetUpdatedEntityID()
local amount = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted") or 0
local players = EntityGetWithTag("player_unit") or EntityGetWithTag("polymorphed_player")
if not players then return end
for i = 1, #players do
    local x, y = EntityGetTransform(players[i])
    GamePlaySound( "data/audio/Desktop/projectiles.bank", "projectiles/orb_c/create", x, y )
    local vx, vy
    local velco = EntityGetFirstComponent(players[i], "CharacterDataComponent")
    if velco then
        vx, vy = ComponentGetValue2(velco, "mVelocity")
        if ComponentGetValue2(velco, "is_on_ground") then vy = 0 end
    end
    x = x + 0.65 * (vx or 0)
    y = y + 0.65 * (vy or 0)
    local xc, yc, x2, y2
    local count = 11
    if amount % 2 == 0 then
        xc = 12
        yc = 0
    else
        xc = 9.89949
        yc = 9.89949
    end
    x2 = xc * (0.5 + (count * -0.5))
    y2 = yc * (0.5 + (count * -0.5))
    for j = 1, count do
        EntityLoad("mods/boss_reworks/files/boss_wizard/effect_zap.xml", x + x2, y + y2)
        x2 = x2 + xc
        y2 = y2 + yc
    end
    xc, yc = -yc, xc
    x2 = xc * (0.5 + (count * -0.5))
    y2 = yc * (0.5 + (count * -0.5))
    for j = 1, count do
        if not (x2 == 0 and y2 == 0) then EntityLoad("mods/boss_reworks/files/boss_wizard/effect_zap.xml", x + x2, y + y2) end
        x2 = x2 + xc
        y2 = y2 + yc
    end
end

if amount >= 4 then EntityKill(me) end