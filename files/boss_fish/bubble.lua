local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local player = EntityGetClosestWithTag(x, y, "player_unit") or EntityGetClosestWithTag(x, y, "polymorphed_player")
local px, py = 0, nil
if player then
    local x2, y2 = EntityGetTransform(player)
    if y2 > y + 20 then EntityKill(me) return end
    local characterdata = EntityGetFirstComponent(player, "CharacterDataComponent")
    if characterdata then
        px, py = ComponentGetValue2(characterdata, "mVelocity")
        py = math.min(0, py)
    end
end
local comp = EntityGetFirstComponent(me, "VariableStorageComponent")
local velco = EntityGetFirstComponent(me, "VelocityComponent")
if not (comp and velco) then return end
local target_vel = ComponentGetValue2(comp, "value_int")
local xv, yv = ComponentGetValue2(velco, "mVelocity")
local accel = 0
SetRandomSeed(GameGetFrameNum() + x + me, y + GetUpdatedComponentID())
if xv > target_vel then
    accel = -4
elseif xv < target_vel then
    accel = 4
end
local scale = 85
if target_vel == 0 then
    target_vel = Random(scale, scale * 2) * ((Random(1, 2) == 1 and -1) or 1)
elseif (xv < target_vel and (xv + accel) >= target_vel ) or (xv > target_vel and (xv + accel) <= target_vel ) then
    if target_vel > 0 then
        target_vel = Random(scale * -1, scale * -2)
    else
        target_vel = Random(scale, scale * 2)
    end
end
xv = xv + accel
yv = -55 + py * 0.35
ComponentSetValue2(comp, "value_int", target_vel)
ComponentSetValue2(velco, "mVelocity", xv, yv)
local toggle = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")
if toggle % 10 == 0 and false then
    EntityLoad("mods/boss_reworks/files/boss_fish/bubbletrail.xml", x, y)
end