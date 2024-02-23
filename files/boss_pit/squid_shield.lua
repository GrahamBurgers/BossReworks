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
local player = EntityGetInRadiusWithTag(x, y, 300, "player_unit") or {}
if #player <= 0 then
    amount = amount + 1
    ComponentSetValue2(var, "frames", amount)
end
local maxamount = ComponentGetValue2(var, "teleportation_radius_max")

amount = math.min(maxamount, math.max(0, amount))
ComponentSetValue2(comp, "area_circle_sector_degrees", 360 * (amount / maxamount))
ComponentSetValue2(comp, "count_min", math.ceil(120 * (amount / maxamount)))
ComponentSetValue2(comp, "count_max", math.ceil(150 * (amount / maxamount)))
local turn = (math.pi / -2) - ((amount / maxamount) * math.pi)
EntitySetTransform(me, x, y, turn)

ComponentSetValue2(comp, "is_emitting", true)

local toggle = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")
if (toggle + 1) % 50 == 0 then
    local varsto = EntityGetFirstComponentIncludingDisabled(parent, "VariableStorageComponent", "squid_shield_trigger")
    local phase = 1
    if varsto then
        phase = ComponentGetValue2(varsto, "value_int")
    end
    dofile_once("mods/boss_reworks/files/projectile_utils.lua")
    SetRandomSeed(me + x, y + GameGetFrameNum())
    local count = 6 + phase
    local angle_inc = (2 * math.pi) / count
	local theta = 0
    local speed = Random(2, 3)
    if Random(1, 2) == 1 then speed = speed * -1 end

	for q = 1, count do
		theta = theta + angle_inc
		local eid = ShootProjectile(parent, "mods/boss_reworks/files/boss_pit/bubble.xml", x, y, 0, 0)
		local store = EntityGetFirstComponent(eid, "VariableStorageComponent")
        if store then
            ComponentSetValue2(store, "value_string", theta)
            ComponentSetValue2(store, "value_float", speed)
        end
        local proj = EntityGetFirstComponent(eid, "ProjectileComponent")
        if proj then
            ComponentSetValue2(proj, "bounce_energy", x)
            ComponentSetValue2(proj, "die_on_low_velocity_limit", y)
        end
	end
end