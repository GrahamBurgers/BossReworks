dofile_once("mods/boss_reworks/files/projectile_utils.lua")
dofile_once("mods/boss_reworks/files/spells/forgotten/reward_list.lua")

local old = EntityGetWithTag("br_forgotten_flare") -- keeping things safe, try to reduce lag
for i = 1, #old do
	EntityKill(old[i])
end

local failed = true
local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
for _, item_data in ipairs(Items) do
	local target_entities = EntityGetInRadiusWithTag(x, y, 1600, item_data[1]) or {}
	for _, target in ipairs(target_entities) do
		if EntityGetRootEntity(target) == target then
			local x2, y2 = EntityGetTransform(target)
			SetRandomSeed(x + x2 + GetUpdatedEntityID(), y + y2 + GameGetFrameNum())
			local multiplier = Random(75, 150) / 100
			local eid = ShootProjectileAtEntity(me, "mods/boss_reworks/files/spells/forgotten_flare.xml", x2, y2, me, multiplier)
			local eid2 = ShootProjectileAtEntity(me, "mods/boss_reworks/files/spells/forgotten_flare2.xml", x, y, target, multiplier)
			if eid and eid2 then
				local proj = EntityGetFirstComponentIncludingDisabled(eid, "ProjectileComponent")
				local proj2 = EntityGetFirstComponentIncludingDisabled(eid2, "ProjectileComponent")
				local sprite = EntityGetFirstComponentIncludingDisabled(eid, "SpriteComponent")
				local particles = EntityGetFirstComponentIncludingDisabled(eid, "SpriteParticleEmitterComponent")
				if proj and sprite and particles and proj2 then
					local distance = math.sqrt((x2 - x) ^ 2 + (y2 - y) ^ 2)
					local thing = 10 + (60 * (distance / ComponentGetValue2(proj, "speed_max")) * (1 / multiplier))
					ComponentSetValue2(proj, "lifetime", thing)
					ComponentSetValue2(proj2, "lifetime", thing)
					ComponentSetValue2(sprite, "image_file", item_data[2])
					ComponentSetValue2(particles, "sprite_file", item_data[2])
					ComponentSetValue2(particles, "color", item_data[3] / 255, item_data[4] / 255, item_data[5] / 255, 1)
					ComponentSetValue2(proj, "mEntityThatShot", target)
					EntityRefreshSprite(eid, sprite)
				end
				failed = false
			end
		end
	end
end

if failed then
	GamePlaySound("data/audio/Desktop/ui.bank", "ui/button_denied", x, y)
end

EntityKill(me)

