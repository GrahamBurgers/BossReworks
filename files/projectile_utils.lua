function ShootProjectile(who_shot, entity_file, x, y, vel_x, vel_y, velocity_multiplier)
	velocity_multiplier = velocity_multiplier or 1
	local entity_id = EntityLoad(entity_file, x, y)
	local herd = 2
	local genome = EntityGetFirstComponentIncludingDisabled(who_shot, "GenomeDataComponent")
	if genome then
		herd = ComponentGetValue2(genome, "herd_id")
	else
		local comp = EntityGetFirstComponentIncludingDisabled(GetUpdatedEntityID(), "ProjectileComponent")
		if comp then
			who_shot = ComponentGetValue2(comp, "mWhoShot")
			herd = ComponentGetValue2(comp, "mShooterHerdId")
		end
	end
	GameShootProjectile(who_shot, x, y, x + vel_x, y + vel_y, entity_id, true, who_shot)
	local comp = EntityGetFirstComponentIncludingDisabled(entity_id, "VelocityComponent") or 0
	local vx, vy = ComponentGetValue2(comp, "mVelocity")
	vx = vx * velocity_multiplier
	vy = vy * velocity_multiplier
	ComponentSetValue2(comp, "mVelocity", vx, vy)
	local comps = EntityGetComponentIncludingDisabled(entity_id, "ProjectileComponent") or {}
	for i = 1, #comps do
		ComponentSetValue2(comps[i], "mShooterHerdId", herd)
		ComponentSetValue2(comps[i], "mWhoShot", who_shot)
	end

	return entity_id
end

function ShootProjectileAtEntity(who_shot, entity_file, x, y, to_entity, velocity_multiplier)
	local ex, ey = EntityGetTransform(to_entity)
	ShootProjectile(who_shot, entity_file, x, y, ex - x, ey - y, velocity_multiplier)
end

function CircleShot(who_shot, entity_file, how_many, x, y, speed, starting_rot)
	local angle_inc = (2 * math.pi) / how_many
	local theta = starting_rot or 0
	local returns = {}

	for q = 1, how_many do
		local vel_x = math.cos(theta) * speed
		local vel_y = math.sin(theta) * speed
		theta = theta + angle_inc
		local eid = ShootProjectile(who_shot, entity_file, x + vel_x * 0.1, y + vel_y * 0.1, vel_x, vel_y)
		returns[#returns+1] = eid
	end

	return returns or {}
end