local nxml = dofile("mods/boss_reworks/files/lib/nxml.lua")
local path = "data/entities/animals/boss_gate/gate_monster_a.xml"
local tree = nxml.parse(ModTextFileGetContent(path))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/boss_armor_init.lua"> </LuaComponent>'))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/boss_gate/glyph_shot.lua"> </LuaComponent>'))
table.insert(tree.children,
	nxml.parse('<LuaComponent script_source_file="mods/boss_reworks/files/boss_gate/damage_scale.lua"> </LuaComponent>'))
table.insert(tree.children,
    nxml.parse('<HealthBarComponent></HealthBarComponent>'))
table.insert(tree.children,
    nxml.parse('<SpriteComponent _tags="health_bar_back,ui,no_hitbox" has_special_scale="1" image_file="data/ui_gfx/health_slider_back.png" offset_x="12" offset_y="42" emissive="1" never_ragdollify_on_death="1" z_index="-9000" update_transform_rotation="0" > </SpriteComponent>'))
table.insert(tree.children,
    nxml.parse('<SpriteComponent _tags="health_bar,ui,no_hitbox" has_special_scale="1" image_file="data/ui_gfx/health_slider_front.png" offset_x="12" offset_y="42" emissive="1" never_ragdollify_on_death="1" z_index="-9000" update_transform_rotation="0" > </SpriteComponent>'))
for k, v in ipairs(tree.children) do
    if v.name == "Base" then
        for k2,v2 in ipairs(v.children) do
          if v2.name == "DamageModelComponent" then v2.children[1].attr.projectile = 0.3 end
        end
    end
end
ModTextFileSetContent(path, tostring(tree))