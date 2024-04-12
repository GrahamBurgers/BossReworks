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
		if not EntityHasTag(EntityGetRootEntity(target), "player_unit") then
			local eid =
				ShootProjectileAtEntity(me, "mods/boss_reworks/files/spells/forgotten_flare.xml", x, y, target, 1)
			if eid then
				local proj = EntityGetFirstComponentIncludingDisabled(eid, "ProjectileComponent")
				local homing = EntityGetFirstComponentIncludingDisabled(eid, "HomingComponent")
				local sprite = EntityGetFirstComponentIncludingDisabled(eid, "SpriteComponent")
				local particles = EntityGetFirstComponentIncludingDisabled(eid, "SpriteParticleEmitterComponent")
				if proj and homing and sprite and particles then
					local x2, y2 = EntityGetTransform(target)
					local distance = math.sqrt((x2 - x) ^ 2 + (y2 - y) ^ 2)
					ComponentSetValue2(
						proj,
						"lifetime",
						math.min(300, 60 * (distance / ComponentGetValue2(proj, "speed_max")))
					)
					ComponentSetValue2(sprite, "image_file", item_data[2])
					ComponentSetValue2(particles, "sprite_file", item_data[2])
					ComponentSetValue2(
						particles,
						"color",
						item_data[3] / 255,
						item_data[4] / 255,
						item_data[5] / 255,
						1
					)
					ComponentSetValue2(homing, "predefined_target", target)
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

