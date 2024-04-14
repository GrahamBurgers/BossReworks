dofile_once("mods/boss_reworks/files/lib/injection.lua")
local list = { "dragon", "gate", "limbs", "fish", "alchemist", "ghost", "robot", "wizard", "pit", "tiny" }
for i = 1, #list do
	if ModSettingGet("boss_reworks.rework_" .. list[i]) then
		dofile_once("mods/boss_reworks/files/boss_" .. list[i] .. "/edit.lua")
	end
end
ModMaterialsFileAdd("mods/boss_reworks/files/materials.xml")
ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/boss_reworks/files/spells/actions.lua")
inject(args.SS, modes.R, "data/entities/items/pickup/test/pouch.xml", 'item_physics', 'item_physics,br_pouch')
inject(args.SS, modes.R, "data/entities/items/pickup/powder_stash.xml", 'item_physics', 'item_physics,br_pouch')
inject(args.SS, modes.R, "data/entities/items/orbs/orb_base.xml", 'polymorphable_NOT', 'polymorphable_NOT,br_orb')
inject(args.SS, modes.R, "data/entities/animals/longleg.xml", '<Entity', '<Entity tags="br_hamis"')
inject(args.SS, modes.R, "data/entities/items/pickup/musicstone.xml", 'moon_energy', 'moon_energy,br_musicstone')
inject(args.SS, modes.R, "data/entities/items/pickup/moon.xml", 'moon_energy', 'moon_energy,br_moon')
inject(args.SS, modes.R, "data/entities/items/pickup/wandstone.xml", 'item_pickup', 'item_pickup,br_wandcore')

local translations = ModTextFileGetContent("data/translations/common.csv")
local new_translations = ModTextFileGetContent("mods/boss_reworks/translations.csv")
translations = translations .. new_translations
translations = translations:gsub("\r", ""):gsub("\n\n", "\n")
ModTextFileSetContent("data/translations/common.csv", translations)

local mode = tostring(ModSettingGet("boss_reworks.mode"))
if mode ~= "Calamari" then
	local content = ModTextFileGetContent("data/biome/_pixel_scenes.xml")
	content = content:gsub("<mBufferedPixelScenes>", [[<mBufferedPixelScenes>
	<PixelScene pos_x="10496" pos_y="4352" just_load_an_entity="mods/boss_reworks/files/boss_rush/rooms/portal_space.xml" />
	<PixelScene pos_x="10496" pos_y="4352" just_load_an_entity="mods/boss_reworks/files/boss_rush/portals/boss_rush_portal_in.xml" />
	]])
	ModTextFileSetContent("data/biome/_pixel_scenes.xml", content) -- mostly functional
end

function OnPlayerSpawned(player)
	if not GameHasFlagRun("boss_reworks_init") then
		GameAddFlagRun("boss_reworks_init")
		EntityAddComponent2(player, "LuaComponent", {
			execute_every_n_frame = -1,
			script_shot = "mods/boss_reworks/files/shot.lua",
			script_damage_received = "mods/boss_reworks/files/damage_taken.lua",
		})
		local eid = EntityLoad("mods/boss_reworks/files/boss_wizard/effect_timer.xml")
		EntityAddChild(player, eid)
		local worldstate = GameGetWorldStateEntity()
		local child = EntityCreateNew("br_soul_storage")
		EntityAddChild(worldstate, child)

		GlobalsSetValue("BR_MODE", mode)
		if mode == "Calamari" or mode == "Boss Rush" then
			local x, y = EntityGetTransform(player)
			local portal = EntityLoad("mods/boss_reworks/files/boss_rush/portals/boss_rush_portal_in.xml", x, y)
			EntityAddComponent(portal, "LifetimeComponent", {lifetime=120})
		end
		if mode == "Powerful" then
			EntityAddComponent2(player, "LuaComponent", {
				script_source_file="mods/boss_reworks/files/boss_armor_init.lua"
			})
		end
		if mode == "Wormy" then
			LoadGameEffectEntityTo(player, "mods/boss_reworks/files/spells/tiny/worm.xml")
		end
	end
end

function OnWorldPreUpdate()
	if mode == "Regular Armor" then
		local enemies = EntityGetWithTag("mortal")
		for i = 1, #enemies do
			if not EntityHasTag(enemies[i], "br_funny_mode_thing") then
				EntityAddTag(enemies[i], "br_funny_mode_thing")
				EntityAddComponent2(enemies[i], "LuaComponent", {
					script_source_file="mods/boss_reworks/files/boss_armor_init.lua"
				})
			end
		end
	end
	if #EntityGetWithTag("br_worm_combo_entity") > 0 then
		Gui = Gui or GuiCreate()
		GuiIdPushString(Gui, "br_worm_combo")
		GuiStartFrame(Gui)

		local amount = tonumber(GlobalsGetValue("BR_WORM_COMBO", "0")) or 0
		local max = tonumber(GlobalsGetValue("BR_WORM_COMBO_MAX", "0")) or 0
		local score = GlobalsGetValue("BR_WORM_SCORE", "0")
		score = tostring(math.floor(tonumber(score) or 0))
		GlobalsSetValue("BR_WORM_SCORE", score)

		local screen_w, screen_h = GuiGetScreenDimensions(Gui)
		local combo_bar = "mods/boss_reworks/files/spells/tiny/combo_bar.png"
		local combo_box = "mods/boss_reworks/files/spells/tiny/combo_frame.png"
		local box_w, box_h = GuiGetImageDimensions(Gui, combo_box)
		local score_box = "mods/boss_reworks/files/spells/tiny/score_frame.png"
		local num_w, num_h = GuiGetImageDimensions(Gui, "mods/boss_reworks/files/spells/tiny/score_dummy.png")

		local x, y = screen_w / 2 - box_w / 2, screen_h / 8 - box_h / 2
		local box_offset = 3 / 4 * box_w

		GuiOptionsAdd(Gui, 2) -- Make non interactive
		GuiZSetForNextWidget(Gui, -1001)
		GuiImage(Gui, 1, x - box_offset, y, combo_bar, 1, box_w * math.max(0, (amount / max)), 1)

		GuiZSetForNextWidget(Gui, -1002)
		GuiImage(Gui, 2, x - box_offset, y, combo_box, 1, 1, 1)

		GuiZSetForNextWidget(Gui, -1002)
		GuiImage(Gui, 3, x + box_offset, y, score_box, 1, 1, 1)

		local length = string.len(score)
		GuiZSet(Gui, -1003)
		for i = 1, length do
			local number_sprite = "mods/boss_reworks/files/spells/tiny/score_" .. string.sub(score, i, i) .. ".png"
			GuiImage(Gui, 3 + i, x + box_offset - length * num_w / 2 + (i - 1) * num_w + num_w / 2, y, number_sprite, 1, 1)
			--  + (i - 1) * num_w - num_w * length - num_w / 2
		end

		GuiIdPop(Gui)

		local enemies = EntityGetWithTag("mortal")
		for i = 1, #enemies do
			if not EntityHasTag(enemies[i], "br_worm_combo_added") then
				EntityAddTag(enemies[i], "br_worm_combo_added")
				EntityAddComponent2(enemies[i], "LuaComponent", {
					execute_every_n_frame = -1,
					script_death = "mods/boss_reworks/files/spells/tiny/combo_death.lua"
				})
			end
		end
	elseif #EntityGetWithTag("player_unit") > 0 then
		local score = math.floor(tonumber(GlobalsGetValue("BR_WORM_SCORE", "0")) or 0)
		if score ~= 0 then
			local players = EntityGetWithTag("player_unit")
			local converted = math.max(0, math.floor(math.log((score + 4000) / 5000) * 1000))
			GamePrintImportant(GameTextGet("$br_wormpoints_end_1", tostring(score)), GameTextGet("$br_wormpoints_end_2", tostring(converted)))
			GlobalsSetValue("BR_WORM_SCORE", "0")
			local existing = EntityGetWithTag("br_spellname_tiny") or {}
			for j = 1, #existing do
				EntityKill(existing[j])
			end
			for j = 1, #players do
				local eid = EntityLoad("mods/boss_reworks/files/spells/tiny/buff.xml")
				local comps = EntityGetComponent(eid, "GameEffectComponent") or {}
				for i = 1, #comps do
					ComponentSetValue2(comps[i], "frames", converted * 60)
				end
				EntityAddChild(players[j], eid)
			end
		end
	end
	if GlobalsGetValue("BR_BOSS_RUSH_ACTIVE", "0") == "1" then
		-- i stole this code from lap 2 and modified it
		Gui = Gui or GuiCreate()
		GuiIdPushString(Gui, "br_healthbar")
		GuiStartFrame(Gui)

		local amount = tonumber(GlobalsGetValue("BR_BOSS_RUSH_HP_LEFT", "0")) or 0
		local max = tonumber(GlobalsGetValue("BR_BOSS_RUSH_HP_MAX", "0")) or 0
		local multiplier = tonumber(GlobalsGetValue("BR_BOSS_RUSH_HP_MULTIPLIER", "0")) or 0
		local thing = tonumber(GlobalsGetValue("BR_BOSS_RUSH_HP_TWEEN", "0")) or 0
		amount = math.min(max, math.max(multiplier, amount))
		thing = math.min(max, math.max(multiplier, thing))
		GlobalsSetValue("BR_BOSS_RUSH_HP_LEFT", tostring(amount))
		if thing <= amount then
			thing = amount
		else
			thing = thing - (thing - amount) / 20
		end
		GlobalsSetValue("BR_BOSS_RUSH_HP_TWEEN", tostring(thing))

		local text = math.floor(0.5 + math.max(0, amount)) / multiplier ..
			" / " .. math.floor(0.5 + math.max(0, max)) / multiplier
		local screen_w, screen_h = GuiGetScreenDimensions(Gui)
		local text_w, text_h = GuiGetTextDimensions(Gui, text)
		local bar = "mods/boss_reworks/files/boss_rush/health_bar.png"
		local bar_w, bar_h = GuiGetImageDimensions(Gui, bar)
		local tween = "mods/boss_reworks/files/boss_rush/health_tween.png"
		local tween_w, tween_h = GuiGetImageDimensions(Gui, bar)
		local frame = "mods/boss_reworks/files/boss_rush/health_frame.png"
		local frame_w, frame_h = GuiGetImageDimensions(Gui, frame)
		local back = "mods/boss_reworks/files/boss_rush/health_back.png"

		-- these overlap with the pickup prompt but there's not much I can do without making the healthbar very obtrusive
		-- Back
		GuiOptionsAdd(Gui, 2) -- Make non interactive
		GuiZSetForNextWidget(Gui, -999)
		GuiImage(Gui, 0, (screen_w - frame_w) / 2, screen_h / 1.1 - frame_h / 2, back, 1, 1, 1)
		-- Red bar
		GuiZSetForNextWidget(Gui, -1000)
		GuiImage(Gui, 1, (screen_w - frame_w) / 2, screen_h / 1.1 - tween_h / 2, tween, 1, frame_w * thing / max, 1)
		-- Bar
		GuiZSetForNextWidget(Gui, -1001)
		GuiImage(Gui, 2, (screen_w - frame_w) / 2, screen_h / 1.1 - bar_h / 2, bar, 1, frame_w * amount / max, 1)
		-- Frame
		GuiZSetForNextWidget(Gui, -1002)
		GuiImage(Gui, 3, (screen_w - frame_w) / 2, screen_h / 1.1 - frame_h / 2, frame, 1, 1, 1)
		-- Countdown
		GuiZSetForNextWidget(Gui, -1003)
		GuiColorSetForNextWidget(Gui, 0, 0, 0, 1)
		GuiText(Gui, (screen_w - text_w) / 2, screen_h / 1.1 - text_h / 2, text)

		GuiIdPop(Gui)

		local players = EntityGetWithTag("player_unit") or {}
		for i = 1, #players do
			-- disable % based damage effects since those use the player's real HP
			local comp = GameGetGameEffect(players[i], "POISON")
			local comp2 = GameGetGameEffect(players[i], "RADIOACTIVE")
			local comp3 = EntityGetFirstComponent(players[i], "DamageModelComponent")
			if comp and comp ~= 0 then
				ComponentSetValue2(comp, "effect", "NONE")
				ComponentSetValue2(comp, "frames", 0)
			end
			if comp2 and comp2 ~= 0 then
				ComponentSetValue2(comp2, "effect", "NONE")
				ComponentSetValue2(comp2, "frames", 0)
			end
			if comp3 and comp3 ~= 0 then
				ComponentSetValue2(comp3, "mFireDamageBufferedNextDeliveryFrame", GameGetFrameNum() + 3)
				ComponentSetValue2(comp3, "mFireDamageBuffered", 0)
			end
			if GameGetGameEffectCount(players[i], "ON_FIRE") > 0 then
				local dmg = max / multiplier / 50 / 60 / 25
				EntityInflictDamage(players[i], dmg, "DAMAGE_FIRE", "$damage_fire", "NONE", 0, 0)
			end
		end
		local poly = EntityGetWithTag("polymorphed_player") or {}
		for i = 1, #poly do
			local comp_poly = GameGetGameEffect(poly[i], "POLYMORPH")
			if (comp_poly == 0 or comp_poly == nil) then comp_poly = GameGetGameEffect(poly[i], "POLYMORPH_RANDOM") end
			if (comp_poly == 0 or comp_poly == nil) then comp_poly = GameGetGameEffect(poly[i], "POLYMORPH_UNSTABLE") end

			-- forever polymorph!
			if comp_poly then
				ComponentSetValue2(comp_poly, "frames", 1)
				GamePrint("$br_boss_rush_polymorphed")
				local hp = tostring(0.5 * tonumber(GlobalsGetValue("BR_BOSS_RUSH_HP_LEFT", "0")))
				GlobalsSetValue("BR_BOSS_RUSH_HP_LEFT", hp)
			end
		end
	end
end
