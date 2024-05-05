local nxml = dofile("mods/boss_reworks/files/lib/nxml.lua")
dofile("mods/boss_reworks/files/lib/injection.lua")
local path = "data/entities/animals/boss_ghost/boss_ghost.xml"
local tree = nxml.parse(ModTextFileGetContent(path))
tree.attr.tags = tree.attr.tags .. ",boss_ghost"
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/boss_armor_init.lua"> </LuaComponent>'))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/healthbar_counter.lua" </LuaComponent>'))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/boss_ghost/alt.lua" remove_after_executed="1"> </LuaComponent>'))
table.insert(tree.children,
	nxml.parse('<LuaComponent _tags="magic_eye" script_source_file="mods/boss_reworks/files/boss_ghost/teleport_create.lua" execute_every_n_frame="480"> </LuaComponent>'))
--[[
table.insert(tree.children,
	nxml.parse('<CellEaterComponent radius="4" eat_probability="100" eat_dynamic_physics_bodies="0" ignored_material_tag="[box2d]"> </CellEaterComponent>'))
]]--
for k, v in ipairs(tree.children) do
    if v.name == "AnimalAIComponent" then
        v.attr.attack_ranged_frames_between = 40
	end
    if v.name == "SpriteComponent" then
        if v.attr.image_file == "data/ui_gfx/health_slider_back.png" or v.attr.image_file == "data/ui_gfx/health_slider_front.png" then
            v.attr.offset_y = 14
        end
    end
    if v.name == "Entity" then
        table.insert(v.children,
            nxml.parse('<LuaComponent remove_after_executed="1" script_source_file="mods/boss_reworks/files/boss_ghost/stinky_laser.lua"> </LuaComponent>'))
        for k2, v2 in ipairs(v.children) do
			if v2.name == "LaserEmitterComponent" then
				v2.children[1].attr.max_cell_durability_to_destroy = 1
                v2.children[1].attr.damage_to_cells = 0
			end
		end
    end
    if v.name == "DamageModelComponent" then
        v.attr.materials_damage = "0"
    end
end
ModTextFileSetContent(path, tostring(tree))

path = "data/entities/animals/boss_ghost/boss_ghost_polyp.xml"
tree = nxml.parse(ModTextFileGetContent(path))
for k, v in ipairs(tree.children) do
    if v.name == "ProjectileComponent" then
        v.attr.collide_with_tag = "player_unit"
        v.children[1].attr.holy = "1.0"
        v.children[2].attr.damage = "0"
    end
    if v.name == "VariableStorageComponent" and v.attr.name == "projectile_file" then
        v.attr.value_string = "data/entities/animals/boss_ghost/boss_ghost_polyp.xml"
    end
    if v.name == "LuaComponent" and v.attr.script_source_file == "data/entities/animals/boss_ghost/polyp_trajectory.lua" then
        v.attr.execute_every_n_frame = "-1"
    end
end
ModTextFileSetContent(path, tostring(tree))

inject(args.SS,modes.R,"data/entities/animals/boss_ghost/death.lua", 'EntityLoad( "data/entities/items/pickup/heart_fullhp.xml",  x, y )', [[
    EntityLoad( "data/entities/items/pickup/heart_fullhp.xml", x + 8, y )
    if not GameHasFlagRun("br_killed_animal_boss_ghost") then
		GameAddFlagRun("br_killed_animal_boss_ghost")
        dofile_once("mods/boss_reworks/files/soul_things.lua")
		CreateItemActionEntity(Soul("BR_REWARD_FORGOTTEN"), x - 8, y)
    end
]])
inject(args.SS,modes.R,"data/entities/animals/boss_ghost/lasers.lua", '0, status - 0.02', '0, status - 0.05')
inject(args.SS,modes.R,"data/entities/animals/boss_ghost/damage.lua", 'status = status + 1.0', 'status = status + damage * 4\nstatus = math.min( 60, status )')