dofile_once("data/scripts/gun/procedural/gun_procedural.lua")
dofile("data/scripts/gun/procedural/gun_action_utils.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
SetRandomSeed(x + 24589, y + 24859)
local gun = get_gun_data( 80, 4, true )
make_wand_from_gun_data( gun, entity_id, 4 )

-- if it's possible for the wand to generate with less than 2 slots then I will be very sad
AddGunAction(entity_id, "BR_LONGTELETRIGGER")
AddGunAction(entity_id, "BR_REWARD_LIMBS")