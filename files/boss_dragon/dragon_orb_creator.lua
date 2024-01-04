local me = GetUpdatedEntityID()
local comp = EntityGetFirstComponent(me, "SpriteParticleEmitterComponent")
local player = EntityGetClosestWithTag(x, y, "player_unit") or EntityGetClosestWithTag(x, y, "polymorphed_player")
local x, y = EntityGetTransform(me)
if comp ~= nil then
    local xs, ys = ComponentGetValue2(comp, "scale")
    xs = xs + (0.5 - xs) / 5
    ys = ys + (0.5 - ys) / 5
    ComponentSetValue2(comp, "scale", xs, ys)
end
local vel = EntityGetFirstComponent(me, "VelocityComponent")
if vel and ComponentGetValue2(vel, "mVelocity") == 0 and player ~= nil then
    local x2, y2 = EntityGetTransform(player)
    local newx, newy
    if x2 > x then newx = 90 else newx = -90 end
    if y2 > y then newy = -90 else newy = 90 end
    ComponentSetValue2(vel, "mVelocity", newx, newy)
end

function rotate_radians(x, y, radians)
    SetRandomSeed(x + 425909, y + GameGetFrameNum())
    if Random(1, 2) == 1 then
        radians = radians + 0.25
    else
        radians = radians - 0.25
    end
	local ca = math.cos(radians)
	local sa = math.sin(radians)
	local out_x = ca * x - sa * y
	local out_y = sa * x + ca * y
	return out_x, out_y
end

function shoot_at_entity(self_entity, target_entity, speed, projectile)
	local rad_offset = 0
	local x, y = EntityGetTransform(self_entity)
	
	if(target_entity ~= nil)then
		local entityX, entityY = EntityGetTransform( target_entity )

		local headingX = entityX - (x)
		local headingY = (entityY-5) - (y)
		local len = math.sqrt((headingX*headingX) + (headingY*headingY))

		local directionX = headingX / len
		local directionY = headingY / len
		local pos_x, pos_y, currentRotation = EntityGetTransform( self_entity )

		if(directionX < 0)then
			EntitySetTransform(self_entity,pos_x,pos_y,currentRotation,-1,1)
		else
			EntitySetTransform(self_entity,pos_x,pos_y,currentRotation,1,1)
		end
        directionX, directionY = rotate_radians(directionX, directionY, math.rad(rad_offset))

        ---@diagnostic disable-next-line: undefined-global
        shoot_projectile( EntityGetClosestWithTag(x, y, "boss_dragon"), projectile, x + (directionX), y + (directionY), directionX * speed, directionY * speed )
    end
end

if GameGetFrameNum() % 25 == 0 then
    dofile_once("data/scripts/lib/utilities.lua")
    if player ~= nil then
        shoot_at_entity(me, EntityGetClosestWithTag(x, y, "player_unit"), 300, "mods/boss_reworks/files/boss_dragon/dragon_orb.xml")
    end
end