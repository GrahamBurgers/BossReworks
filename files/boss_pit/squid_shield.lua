local me = GetUpdatedEntityID()
local comp = EntityGetFirstComponentIncludingDisabled(me, "ParticleEmitterComponent")
local var = EntityGetFirstComponentIncludingDisabled(me, "GameEffectComponent")
if not comp or not var then return end
local x, y = EntityGetTransform(me)
local parent = EntityGetRootEntity(me)
if parent ~= me then
    x, y = EntityGetTransform(parent)
    x = x - 1
    y = y - 1
end
local amount = ComponentGetValue2(var, "frames")
local maxamount = ComponentGetValue2(var, "teleportation_radius_max")

amount = math.min(maxamount, math.max(0, amount))
ComponentSetValue2(comp, "area_circle_sector_degrees", 360 * (amount / maxamount))
ComponentSetValue2(comp, "count_min", math.ceil(120 * (amount / maxamount)))
ComponentSetValue2(comp, "count_max", math.ceil(150 * (amount / maxamount)))
local turn = (math.pi / -2) - ((amount / maxamount) * math.pi)
EntitySetTransform(me, x, y, turn)

ComponentSetValue2(comp, "is_emitting", true)

if GameGetFrameNum() % 30 == 0 then
    dofile_once("mods/boss_reworks/files/projectile_utils.lua")
    SetRandomSeed(me + x, y + GameGetFrameNum())
    local count = 6 + Random(0, 4) * 2
    local angle_inc = math.pi / count
	local theta = 0
    local speed = Random(-10, 10)

	for q = 1, count do
		theta = theta + angle_inc / 2
		local eid = ShootProjectile(parent, "mods/boss_reworks/files/boss_pit/bubble.xml", x or 0, y or 0, 0, 0)
		local store = EntityGetFirstComponent(eid, "VariableStorageComponent")
        if store then
            ComponentSetValue2(store, "value_string", theta * 100)
            ComponentSetValue2(store, "value_int", speed)
        end
	end
    GamePrint("circle: " .. tostring(count))
end