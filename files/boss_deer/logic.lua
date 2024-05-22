local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local players = EntityGetWithTag("player_unit") or {}
local anger = math.min(30, tonumber( GlobalsGetValue( "HELPLESS_KILLS", "1" ) ) or 1)

function damage_received( damage, msg, source )
	local dmg = EntityGetFirstComponent(me, "DamageModelComponent")
	if dmg then
		local hp = ComponentGetValue2(dmg, "hp")
		local max_hp = ComponentGetValue2(dmg, "max_hp")
		if hp - damage <= 0 then
			local ghost = EntityGetClosestWithTag(x, y, "spiritghost") or 0
			if ghost > 0 then
				local x2, y2 = EntityGetTransform(ghost)
				EntityLoad("data/entities/particles/poof_blue.xml", x2, y2)
				EntityKill(ghost)
				EntityInflictDamage(me, max_hp * -1, "DAMAGE_HEALING", "$damage_healing", "NORMAL", 0, 0, me)
				GameScreenshake(50)
			else

			end
		end
	end
end

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	CreateItemActionEntity( "MASS_POLYMORPH", x, y )
	AddFlagPersistent( "card_unlocked_polymorph" )
	AddFlagPersistent( "miniboss_islandspirit" )
	GlobalsSetValue( "BOSS_SPIRIT_DEAD", "1" )

	if ( anger >= 300 ) then
		AddFlagPersistent("miniboss_threelk")
	end
end

-- only remove ambrosia if player has murdered more than 60 helpless animals
if( anger >= 60 ) then
	for i = 1, #players do
		EntityRemoveStainStatusEffect( players[i], "PROTECTION_ALL", 5 )
	end
end

VerletApplyCircularForce(x, y, 80, 0.14) -- does this even work??