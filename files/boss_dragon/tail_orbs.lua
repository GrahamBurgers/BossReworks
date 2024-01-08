local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform(entity_id)

dofile_once("mods/boss_reworks/files/projectile_utils.lua")
CircleShot(entity_id, "mods/boss_reworks/files/boss_dragon/tail_orbs.xml", 6, pos_x, pos_y, 110)

GamePlaySound("data/audio/Desktop/projectiles.bank", "projectiles/orb_dragon/create", pos_x, pos_y)
