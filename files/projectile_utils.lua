function ShootProjectile(who_shot, entity_file, x, y, vel_x, vel_y, velocity_multiplier, set_velocity_directly)
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
	local comp = EntityGetFirstComponentIncludingDisabled(entity_id, "VelocityComponent")
	if comp then
		if set_velocity_directly then
			ComponentSetValue2(comp, "mVelocity", vel_x * velocity_multiplier, vel_y * velocity_multiplier)
		else
			local vx, vy = ComponentGetValue2(comp, "mVelocity")
			vx = vx * velocity_multiplier
			vy = vy * velocity_multiplier
			ComponentSetValue2(comp, "mVelocity", vx, vy)
		end
	end
	local comps = EntityGetComponentIncludingDisabled(entity_id, "ProjectileComponent") or {}
	for i = 1, #comps do
		ComponentSetValue2(comps[i], "mShooterHerdId", herd)
		ComponentSetValue2(comps[i], "mWhoShot", who_shot)
		ComponentSetValue2(comps[i], "mEntityThatShot", GetUpdatedEntityID())
	end

	return entity_id
end

function ShootProjectileAtEntity(who_shot, entity_file, x, y, to_entity, velocity_multiplier, set_velocity_directly)
	local ex, ey = EntityGetTransform(to_entity)
	return ShootProjectile(who_shot, entity_file, x, y, ex - x, ey - y, velocity_multiplier, set_velocity_directly)
end

function CircleShot(who_shot, entity_file, how_many, x, y, speed, starting_rot, set_velocity_directly)
	local angle_inc = (2 * math.pi) / how_many
	local theta = starting_rot or 0
	local returns = {}

	for q = 1, how_many do
		local vel_x = math.cos(theta) * speed
		local vel_y = math.sin(theta) * speed
		theta = theta + angle_inc
		local eid = ShootProjectile(who_shot, entity_file, x, y, vel_x, vel_y, 1, set_velocity_directly)
		returns[#returns+1] = eid
	end

	return returns or {}
end

function VelocityFromComponent(entity)
	local velocity = EntityGetFirstComponent(entity, "VelocityComponent")
	local storage = EntityGetComponent(entity, "VariableStorageComponent")
	if velocity and storage then
		local x, y = ComponentGetValue2(velocity, "mVelocity")
		for i = 1, #storage do
			if ComponentGetValue2(storage[i], "name") == "velocity_add_x" then
				x = x + ComponentGetValue2(storage[i], "value_float")
			end
			if ComponentGetValue2(storage[i], "name") == "velocity_add_y" then
				y = y + ComponentGetValue2(storage[i], "value_float")
			end
		end
		ComponentSetValue2(velocity, "mVelocity", x, y)
	end
end