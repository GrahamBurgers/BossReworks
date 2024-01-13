local eid = GetUpdatedEntityID()
local it = { "x", "y", "ring", "time" }
local ring = 1
local kappa = 1
local time = 0
local x, y = EntityGetTransform(eid)
local vscs = EntityGetComponent(eid, "VariableStorageComponent") or {}
for k, v in ipairs(vscs) do
	local alpha = ComponentGetValue2(v, "value_string")
	if alpha:find("/") then goto continue end
	({
		[""] = function()
			ComponentSetValue2(v, "value_string", it[kappa])
			ComponentSetValue2(v, "value_int", ({ x, y, ring, time })[kappa])
			kappa = kappa + 1
		end,
		["x"] = function()
			x = ComponentGetValue2(v, "value_int")
		end,
		["y"] = function()
			y = ComponentGetValue2(v, "value_int")
		end,
		["ring"] = function()
			ring = ComponentGetValue2(v, "value_int")
		end,
		["time"] = function()
			time = ComponentGetValue2(v, "value_int")
		end
	})[alpha]()
	::continue::
end

local tau = (ring + 0.5) * 32
local delta = (ring - 0.5) * 64
local theta = time / tau * 2 * math.pi
x, y = x + delta * math.sin(theta), y + delta * math.cos(theta)
EntitySetTransform(eid, x, y)
local iota = {}
time = (time + 1) % tau
if time == 0 then ring = ring + 1 end
for k, v in ipairs(it) do iota[v] = k end
for k, v in ipairs(vscs) do
	local alpha = ComponentGetValue2(v, "value_string");
	if alpha:find("/") or ({ ["x"] = true, ["y"] = true })[alpha] then goto continue2 end
	print(alpha)
	ComponentSetValue2(v, "value_int", ({ x, y, ring, time })[iota[alpha]])
	::continue2::
end
if ring >= 4 then EntityKill(eid) end
