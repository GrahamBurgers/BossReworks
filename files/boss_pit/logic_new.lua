local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local varsto = EntityGetFirstComponentIncludingDisabled(me, "VariableStorageComponent", "squid_shield_trigger")
local clock = EntityGetFirstComponentIncludingDisabled(me, "VariableStorageComponent", "squid_last_attack_frame")
local player = EntityGetClosestWithTag(x, y, "player_unit") or EntityGetClosestWithTag(x, y, "polymorphed_player")
if not varsto or not clock or not player then return end
local phase = ComponentGetValue2(varsto, "value_int")
local last = ComponentGetValue2(clock, "value_int")
if last == 0 then
	last = GameGetFrameNum()
	ComponentSetValue2(clock, "value_int", GameGetFrameNum())
end
local children = EntityGetAllChildren(me) or {}
local shield_is_up = false
for i = 1, #children do
	if EntityGetName(children[i]) == "squid_shield" then
		shield_is_up = true
	end
end
local wait = {6, 6, 5, 4, 4, 3} -- how long he waits between attacks for each phase
wait = wait[phase] * 60
if shield_is_up then wait = wait * (2/3) end
if GameGetFrameNum() <= last + wait then return end
ComponentSetValue2(clock, "value_int", GameGetFrameNum())
-- GamePrint("ATTACKING, WAITED " .. tostring(wait))

dofile_once("mods/boss_reworks/files/projectile_utils.lua")
SetRandomSeed(GameGetFrameNum() + player + x, y + phase + 24598)

local function modify_wand(entity_id, projectile_file, delay_frames, sprite_file, lifetime, air_friction, shot_speed_multiplier)
	local var = EntityGetFirstComponent(entity_id, "VariableStorageComponent") or 0
	ComponentSetValue2(var, "value_string", projectile_file)
	local lua = EntityGetFirstComponent(entity_id, "LuaComponent")
	if lua then ComponentSetValue2(lua, "execute_every_n_frame", delay_frames) end
	local sprite = EntityGetFirstComponent(entity_id, "SpriteComponent")
	if sprite then
		local gui = GuiCreate()
		local img_x, img_y = GuiGetImageDimensions(gui, sprite_file)
		GuiDestroy(gui)
		ComponentSetValue2(sprite, "offset_x", img_x / 2)
		ComponentSetValue2(sprite, "offset_y", img_y / 2)
		ComponentSetValue2(sprite, "image_file", sprite_file)
		EntityRefreshSprite(entity_id, sprite)
	end
	if lifetime then
		local proj = EntityGetFirstComponent(entity_id, "ProjectileComponent") or 0
		ComponentSetValue2(proj, "lifetime", lifetime)
	end
	if air_friction then
		local vel = EntityGetFirstComponent(entity_id, "VelocityComponent") or 0
		ComponentSetValue2(vel, "air_friction", air_friction)
	end
	ComponentSetValue2(var, "value_float", shot_speed_multiplier or 1)
end

local function spheres()
	local px, py = EntityGetTransform(player)
	local theta = math.atan((py - y) / (px - x))
	local theta1 = theta + math.pi / 4
	local theta2 = theta + math.pi / -4
	if px < x then
		theta1 = theta1 + math.pi
		theta2 = theta2 + math.pi
	end
	local wand1 = ShootProjectile(me, "mods/boss_reworks/files/boss_pit/wand.xml", x, y, math.cos(theta1), math.sin(theta1), 0.9)
	local wand2 = ShootProjectile(me, "mods/boss_reworks/files/boss_pit/wand.xml", x, y, math.cos(theta2), math.sin(theta2), 0.9)
	modify_wand(wand1, "data/entities/projectiles/orb_expanding.xml", 35, "data/items_gfx/wands/wand_0320.png", 200, 0.3, 1.5)
	modify_wand(wand2, "data/entities/projectiles/orb_expanding.xml", 35, "data/items_gfx/wands/wand_0320.png", 200, 0.3, 1.5)
end

local function chaingun()
	local px, py = EntityGetTransform(player)
	local theta = math.atan((py - y) / (px - x))
	if px < x then theta = theta + math.pi end
	local wand = ShootProjectile(me, "mods/boss_reworks/files/boss_pit/wand.xml", x, y, math.cos(theta), math.sin(theta), 7)
	modify_wand(wand, "data/entities/projectiles/deck/machinegun_bullet.xml", 3, "data/items_gfx/wands/custom/actual_wand.xml", 100, 7, 1)
end

local function bb()
	local px, py = EntityGetTransform(player)
	local theta = math.atan((py - y) / (px - x))
	if px < x then theta = theta + math.pi end
	local wand = ShootProjectile(me, "mods/boss_reworks/files/boss_pit/wand.xml", x, y, math.cos(theta), math.sin(theta), 2)
	modify_wand(wand, "data/entities/projectiles/deck/rubber_ball.xml", 40, "data/entities/animals/boss_pit/wand_07.png", 180, 4, 0.4)
end

local function thundercharge()
	local wand = ShootProjectile(me, "mods/boss_reworks/files/boss_pit/wand.xml", x, y, 0, 20, 1)
	modify_wand(wand, "data/entities/projectiles/thunderball.xml", 60, "data/items_gfx/wands/wand_0521.png", 200, 0.6, 0.8)
end

local function gigasaws()
	local px, py = EntityGetTransform(player)
	local theta = math.atan((py - y) / (px - x))
	if px < x then theta = theta + math.pi end
	local wand = ShootProjectile(me, "mods/boss_reworks/files/boss_pit/wand.xml", x, y, math.cos(theta), math.sin(theta), 0.8)
	modify_wand(wand, "data/entities/projectiles/deck/disc_bullet_big.xml", 100, "data/items_gfx/wands/wand_0141.png", 300, 0, 0.6)
end

local function effectorbs()
	local px, py = EntityGetTransform(player)
	local theta = math.atan((py - y) / (px - x))
	local theta1 = theta + math.pi / 2
	local theta2 = theta + math.pi / -2
	if px < x then
		theta1 = theta1 + math.pi
		theta2 = theta2 + math.pi
	end
	local wand1 = ShootProjectile(me, "mods/boss_reworks/files/boss_pit/wand.xml", x, y, math.cos(theta2), math.sin(theta2), -2)
	modify_wand(wand1, "mods/boss_reworks/files/boss_wizard/effect_orb.xml", 1, "data/items_gfx/wands/wand_0447.png", 55, 3, 0.4)
	local wand2 = ShootProjectile(me, "mods/boss_reworks/files/boss_pit/wand.xml", x, y, math.cos(theta1), math.sin(theta1), -1)
	modify_wand(wand2, "mods/boss_reworks/files/boss_wizard/effect_orb.xml", 10, "data/items_gfx/wands/wand_0447.png", 120, 1, 0.4)
end

local function chainsaw()
	local wand = ShootProjectile(me, "mods/boss_reworks/files/boss_pit/wand.xml", x, y, 0, 40, 0.8)
	modify_wand(wand, "data/entities/projectiles/deck/chainsaw.xml", 2, "data/items_gfx/wands/custom/chainsaw.xml", 500, 0, 3)
	EntityAddComponent2(wand, "HomingComponent", {
		target_tag="player_unit",
		detect_distance=500,
		homing_targeting_coeff=9,
		homing_velocity_multiplier=0.98
	})
end

-- how many attacks is reasonable to have? some should probably not involve wands
local attacks = {}
if phase == 1 then attacks = {bb} end
if phase == 2 then attacks = {spheres, thundercharge} end
if phase == 3 then attacks = {gigasaws, effectorbs, chainsaw} end
if phase == 4 then attacks = {thundercharge, effectorbs, gigasaws, chainsaw} end
if phase == 5 then attacks = {spheres, thundercharge, gigasaws, chainsaw} end
if phase == 6 then attacks = {effectorbs, chaingun, spheres, thundercharge, gigasaws, chainsaw} end
attacks[Random(1, #attacks)]()