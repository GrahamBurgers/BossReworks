dofile_once("mods/boss_reworks/files/lib/injection.lua")
local list = {"dragon", "gate", "limbs", "fish", "alchemist", "ghost", "robot", "wizard", "pit"}
for i = 1, #list do
	if ModSettingGet("boss_reworks.rework_" .. list[i]) then
		dofile_once("mods/boss_reworks/files/boss_" .. list[i] .. "/edit.lua")
	end
end
ModMaterialsFileAdd("mods/boss_reworks/files/materials.xml")
ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/boss_reworks/files/spells/actions.lua")
inject(args.SS,modes.R,"data/entities/items/pickup/test/pouch.xml", 'item_physics', 'item_physics,br_pouch')
inject(args.SS,modes.R,"data/entities/items/pickup/powder_stash.xml", 'item_physics', 'item_physics,br_pouch')
inject(args.SS,modes.R,"data/entities/items/orbs/orb_base.xml", 'polymorphable_NOT', 'polymorphable_NOT,br_orb')
inject(args.SS,modes.R,"data/entities/animals/longleg.xml", '<Entity', '<Entity tags="br_hamis"')
inject(args.SS,modes.R,"data/entities/items/pickup/musicstone.xml", 'moon_energy', 'moon_energy,br_musicstone')
inject(args.SS,modes.R,"data/entities/items/pickup/moon.xml", 'moon_energy', 'moon_energy,br_moon')
inject(args.SS,modes.R,"data/entities/items/pickup/wandstone.xml", 'item_pickup', 'item_pickup,br_wandcore')

local translations = ModTextFileGetContent("data/translations/common.csv")
local new_translations = ModTextFileGetContent("mods/boss_reworks/translations.csv")
translations = translations .. new_translations
translations = translations:gsub("\r", ""):gsub("\n\n", "\n")
ModTextFileSetContent("data/translations/common.csv", translations)

local content = ModTextFileGetContent("data/biome/_pixel_scenes.xml")
content = content:gsub("<mBufferedPixelScenes>", [[<mBufferedPixelScenes>
  <PixelScene pos_x="10496" pos_y="4352" just_load_an_entity="mods/boss_reworks/files/boss_rush/rooms/portal_space.xml" />
  <PixelScene pos_x="10496" pos_y="4352" just_load_an_entity="mods/boss_reworks/files/boss_rush/portals/boss_rush_portal_in.xml" />
]])
ModTextFileSetContent("data/biome/_pixel_scenes.xml", content) -- mostly functional

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
	end
end

function OnWorldPreUpdate()
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

		local text = math.floor(0.5 + math.max(0, amount)) / multiplier .. " / " .. math.floor(0.5 + math.max(0, max)) / multiplier
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
		GuiOptionsAddForNextWidget(Gui, 2) -- Make non interactive
		GuiZSetForNextWidget(Gui, -999)
		GuiImage(Gui, 0, (screen_w - frame_w) / 2, screen_h / 1.1 - frame_h / 2, back, 1, 1, 1)
		-- Red bar
		GuiOptionsAddForNextWidget(Gui, 2) -- Make non interactive
		GuiZSetForNextWidget(Gui, -1000)
		GuiImage(Gui, 1, (screen_w - frame_w) / 2, screen_h / 1.1 - tween_h / 2, tween, 1, frame_w * thing / max, 1)
		-- Bar
		GuiOptionsAddForNextWidget(Gui, 2) -- Make non interactive
		GuiZSetForNextWidget(Gui, -1001)
		GuiImage(Gui, 2, (screen_w - frame_w) / 2, screen_h / 1.1 - bar_h / 2, bar, 1, frame_w * amount / max, 1)
		-- Frame
		GuiOptionsAddForNextWidget(Gui, 2) -- Make non interactive
		GuiZSetForNextWidget(Gui, -1002)
		GuiImage(Gui, 3, (screen_w - frame_w) / 2, screen_h / 1.1 - frame_h / 2, frame, 1, 1, 1)
		-- Countdown
		GuiOptionsAddForNextWidget(Gui, 2) -- Make non interactive
		GuiZSetForNextWidget(Gui, -1003)
		GuiColorSetForNextWidget(Gui, 0, 0, 0, 1)
		GuiText(Gui, (screen_w - text_w) / 2, screen_h / 1.1 - text_h / 2, text)

		GuiIdPop(Gui)

		local players = EntityGetWithTag("player_unit") or {}
		for i = 1, #players do
			-- disable % based damage effects since those use the player's real HP
			local comp = GameGetGameEffect( players[i], "POISON" )
			local comp2 = GameGetGameEffect( players[i], "RADIOACTIVE" )
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
			if( comp_poly == 0 or comp_poly == nil ) then comp_poly = GameGetGameEffect(poly[i], "POLYMORPH_RANDOM") end
			if( comp_poly == 0 or comp_poly == nil ) then comp_poly = GameGetGameEffect(poly[i], "POLYMORPH_UNSTABLE") end

			-- forever polymorph!
			if comp_poly then
				ComponentSetValue2(comp_poly, "frames", 1)
				GamePrint("$br_boss_rush_polymorphed")
				GlobalsSetValue("BR_BOSS_RUSH_HP_MAX", tostring(math.max(multiplier, multiplier * -80 + max)))
			end
		end
	end
end