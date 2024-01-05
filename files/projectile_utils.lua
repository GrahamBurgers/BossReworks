function Shoot_projectile(who_shot, entity_file, x, y, vel_x, vel_y, velocity_multiplier)
	local entity_id = EntityLoad(entity_file, x, y)
	local herd = 2
	local genome = EntityGetFirstComponent(who_shot, "GenomeDataComponent")
	if genome then
		herd = ComponentGetValue2(genome, "herd_id")
	else
		local comp = EntityGetFirstComponent(GetUpdatedEntityID(), "ProjectileComponent")
		if comp then
			who_shot = ComponentGetValue2(comp, "mWhoShot")
			herd = ComponentGetValue2(comp, "mShooterHerdId")
		end
	end
	GameShootProjectile(who_shot, x, y, x + vel_x, y + vel_y, entity_id, true, who_shot)
	if velocity_multiplier then
		local comp = EntityGetFirstComponent(entity_id, "VelocityComponent") or 0
		local vx, vy = ComponentGetValue2(comp, "mVelocity")
		vx = vx * velocity_multiplier
		vy = vy * velocity_multiplier
		ComponentSetValue2(comp, "mVelocity", vx, vy)
	end
	local comps = EntityGetComponent(entity_id, "ProjectileComponent") or {}
	for i = 1, #comps do
		ComponentSetValue2(comps[i], "mShooterHerdId", herd)
		ComponentSetValue2(comps[i], "mWhoShot", who_shot)
	end

	return entity_id
end
