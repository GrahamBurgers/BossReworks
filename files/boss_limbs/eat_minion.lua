local me = GetUpdatedEntityID()
local eid = EntityGetWithTag("boss_limbs_minion")[1]
local damagemodel = EntityGetFirstComponent(me, "DamageModelComponent")
if not (eid and damagemodel) then return end
local x, y = EntityGetTransform(eid)
SetRandomSeed(x + eid, y + GameGetFrameNum())
local hp = ComponentGetValue2(damagemodel, "hp")
local max_hp = ComponentGetValue2(damagemodel, "max_hp")

local circle
if Random(1, 100) > (hp / max_hp) * 100 then
	circle = EntityLoad("mods/boss_reworks/files/boss_limbs/circle_heal.xml", x, y)
elseif Random(1, 2) == 1 then
	circle = EntityLoad("mods/boss_reworks/files/boss_limbs/circle_fire.xml", x, y)
else
	circle = EntityLoad("mods/boss_reworks/files/boss_limbs/circle_slime.xml", x, y)
end
if circle then EntityAddChild(eid, circle) end