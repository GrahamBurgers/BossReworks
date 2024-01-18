local nxml = dofile("mods/boss_reworks/files/lib/nxml.lua")
dofile("mods/boss_reworks/files/lib/injection.lua")
local path = "data/entities/animals/boss_ghost/boss_ghost.xml"
local tree = nxml.parse(ModTextFileGetContent(path))
tree.attr.tags = tree.attr.tags .. ",boss_ghost"
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/boss_armor_init.lua"> </LuaComponent>'))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/boss_ghost/alt.lua" remove_after_executed="1"> </LuaComponent>'))
table.insert(tree.children,
	nxml.parse('<LuaComponent _tags="magic_eye" script_source_file="mods/boss_reworks/files/boss_ghost/teleport_create.lua" execute_every_n_frame="480"> </LuaComponent>'))
table.insert(tree.children,
	nxml.parse('<CellEaterComponent radius="4" eat_probability="100" eat_dynamic_physics_bodies="0" ignored_material_tag="[box2d]"> </CellEaterComponent>'))
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
        for k2, v2 in ipairs(v.children) do
			if v2.name == "LaserEmitterComponent" then
				v2.children[1].attr.max_cell_durability_to_destroy = 1
                v2.children[1].attr.damage_to_cells = 0
			end
		end
    end
end
ModTextFileSetContent(path, tostring(tree))

inject(args.SS,modes.R,"data/entities/animals/boss_ghost/boss_ghost_polyp.xml", 'polyp_shot.xml', 'boss_ghost_polyp.xml')
inject(args.SS,modes.R,"data/entities/animals/boss_ghost/boss_ghost_polyp.xml", 'damage="3"', 'damage="0"')
inject(args.SS,modes.R,"data/entities/animals/boss_ghost/boss_ghost_polyp.xml", 'holy="3.0"', 'holy="1.6"')
inject(args.SS,modes.A,"data/entities/animals/boss_ghost/boss_ghost_polyp.xml", 'penetrate_world="1"', 'collide_with_tag="player_unit"')
inject(args.SS,modes.R,"data/entities/animals/boss_ghost/damage.lua", 'status = status + 1.0', 'status = status + damage * 3\nstatus = math.min( 100, status )')