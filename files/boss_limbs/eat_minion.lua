local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(GetUpdatedEntityID())
local eid = EntityGetInRadiusWithTag(x, y, 250, "boss_limbs_minion") or {}
local damagemodel = EntityGetFirstComponent(me, "DamageModelComponent")
if #eid <= 0 then return end
if not damagemodel then return end
SetRandomSeed(damagemodel + #eid, me + GameGetFrameNum())
if Random(1, 5) > #eid then return end
local target = eid[Random(1, #eid)]

local hp = ComponentGetValue2(damagemodel, "hp")
local max_hp = ComponentGetValue2(damagemodel, "max_hp")

local circle
if Random(1, 100) > (hp / max_hp) * 80 then
	circle = EntityLoad("mods/boss_reworks/files/boss_limbs/circle_heal.xml", x, y)
elseif #EntityGetInRadiusWithTag(x, y, 150, "boss_limbs_minion") > Random(2, 5) then
	circle = EntityLoad("mods/boss_reworks/files/boss_limbs/circle_necro.xml", x, y)
else
	circle = EntityLoad("mods/boss_reworks/files/boss_limbs/circle_fire.xml", x, y)
end
if circle then EntityAddChild(target, circle) end
EntityRemoveTag(target, "boss_limbs_minion")