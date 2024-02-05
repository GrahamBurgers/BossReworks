dofile_once("mods/boss_reworks/files/projectile_utils.lua")
-- mode 1: rotating, accelerating (+)
-- mode 2: decelerating to 0 after mode 1 (-)
-- mode 3: rotating, accelerating (-)
-- mode 4: decelerating to 0 after mode 3 (+)
local varsto = EntityGetFirstComponentIncludingDisabled(GetUpdatedEntityID(), "VariableStorageComponent", "boss_wizard_rotato")
if not varsto then return end
local accel_speed = 0.03
local mode = ComponentGetValue2(varsto, "value_string")
local speed = ComponentGetValue2(varsto, "value_int") / 1000
local theta = ComponentGetValue2(varsto, "value_float")

local vel_x = math.cos(theta) * 90
local vel_y = math.sin(theta) * 90
local x, y = EntityGetTransform(GetUpdatedEntityID())
local eid = ShootProjectile(GetUpdatedEntityID(), "mods/boss_reworks/files/boss_wizard/bloodtentacle_warn.xml", x, y, vel_x, vel_y)
EntityAddChild(GetUpdatedEntityID(), eid)

SetRandomSeed(varsto + speed, theta + GameGetFrameNum())
if mode == "1" then
    speed = speed + accel_speed
    if Random(1, 8) == 1 and speed > accel_speed * 20 then
        ComponentSetValue2(varsto, "value_string", "2")
    end
elseif mode == "2" then
    speed = speed - accel_speed
    if speed < 0 then
        ComponentSetValue2(varsto, "value_string", "3")
    end
elseif mode == "3" then
    speed = speed - accel_speed
    if Random(1, 8) == 1 and speed < accel_speed * -20 then
        ComponentSetValue2(varsto, "value_string", "4")
    end
elseif mode == "4" then
    speed = speed + accel_speed
    if speed > 0 then
        ComponentSetValue2(varsto, "value_string", "1")
    end
end
-- GamePrint("mode: " .. mode .. ", speed: " .. tostring(speed))
theta = theta + speed
ComponentSetValue2(varsto, "value_float", theta)
ComponentSetValue2(varsto, "value_int", speed * 1000)