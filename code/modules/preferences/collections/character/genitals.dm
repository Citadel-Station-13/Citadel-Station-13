/datum/preferences_collection/character/genitals
	save_key = PREFERENCES_SAVE_KEY_GENITALS
	sort_order = 3
	preview_mode = PREFERENCES_PREVIEW_MODE_BODY

/datum/preferences_collection/character/genitals/content(datum/preferences/prefs)
	. = ..()


/datum/preferences_collection/character/genitals/sanitize_character(datum/preferences/prefs)
	. = ..()

/datum/preferences_collection/character/genitals/copy_to_mob(datum/preferences/prefs, mob/M, flags)
	. = ..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.give_genitals(TRUE)

/datum/preferences_collection/character/genitals/OnTopic(mob/user, datum/preferences/prefs, list/href_list)
	. = ..()

/datum/preferences_collection/character/genitals/savefile_full_overhaul_character(datum/preferences/prefs, list/data, savefile/S, list/errors, current_version)
	. = ..()

/datum/preferences_collection/character/genitals/randomize_character_stage_2(datum/preferences/prefs)
	. = ..()
"genitals_use_skintone" = FALSE, "has_cock" = FALSE, "cock_shape" = DEF_COCK_SHAPE, "cock_length" = COCK_SIZE_DEF, "cock_diameter_ratio" = COCK_DIAMETER_RATIO_DEF, "cock_color" = "ffffff", "cock_taur" = FALSE, "has_balls" = FALSE, "balls_color" = "ffffff", "balls_shape" = DEF_BALLS_SHAPE, "balls_size" = BALLS_SIZE_DEF, "balls_cum_rate" = CUM_RATE, "balls_cum_mult" = CUM_RATE_MULT, "balls_efficiency" = CUM_EFFICIENCY, "has_breasts" = FALSE, "breasts_color" = "ffffff", "breasts_size" = BREASTS_SIZE_DEF, "breasts_shape" = DEF_BREASTS_SHAPE, "breasts_producing" = FALSE, "has_vag" = FALSE, "vag_shape" = DEF_VAGINA_SHAPE, "vag_color" = "ffffff", "has_womb" = FALSE, "balls_visibility"	= GEN_VISIBLE_NO_UNDIES, "breasts_visibility"= GEN_VISIBLE_NO_UNDIES, "cock_visibility"	= GEN_VISIBLE_NO_UNDIES, "vag_visibility"	= GEN_VISIBLE_NO_UNDIES

			if(NOGENITALS in pref_species.species_traits)
				dat += "<b>Your species ([pref_species.name]) does not support genitals!</b><br>"
			else
				if(pref_species.use_skintones)
					dat += "<b>Genitals use skintone:</b><a href='?_src_=prefs;preference=genital_colour'>[features["genitals_use_skintone"] == TRUE ? "Yes" : "No"]</a>"
				dat += "<h3>Penis</h3>"
				dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=has_cock'>[features["has_cock"] == TRUE ? "Yes" : "No"]</a>"
				if(features["has_cock"])
					if(pref_species.use_skintones && features["genitals_use_skintone"] == TRUE)
						dat += "<b>Penis Color:</b></a><BR>"
						dat += "<span style='border: 1px solid #161616; background-color: [SKINTONE2HEX(skin_tone)];'>&nbsp;&nbsp;&nbsp;</span>(Skin tone overriding)</a><br>"
					else
						dat += "<b>Penis Color:</b></a><BR>"
						dat += "<span style='border: 1px solid #161616; background-color: #[features["cock_color"]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=cock_color;task=input'>Change</a><br>"
					var/tauric_shape = FALSE
					if(features["cock_taur"])
						var/datum/sprite_accessory/penis/P = GLOB.cock_shapes_list[features["cock_shape"]]
						if(P.taur_icon && parent.can_have_part("taur"))
							var/datum/sprite_accessory/taur/T = GLOB.taur_list[features["taur"]]
							if(T.taur_mode & P.accepted_taurs)
								tauric_shape = TRUE
					dat += "<b>Penis Shape:</b> <a style='display:block;width:120px' href='?_src_=prefs;preference=cock_shape;task=input'>[features["cock_shape"]][tauric_shape ? " (Taur)" : ""]</a>"
					dat += "<b>Penis Length:</b> <a style='display:block;width:120px' href='?_src_=prefs;preference=cock_length;task=input'>[features["cock_length"]] inch(es)</a>"
					dat += "<b>Penis Visibility:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=cock_visibility;task=input'>[features["cock_visibility"]]</a>"
					dat += "<b>Has Testicles:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=has_balls'>[features["has_balls"] == TRUE ? "Yes" : "No"]</a>"
					if(features["has_balls"])
						if(pref_species.use_skintones && features["genitals_use_skintone"] == TRUE)
							dat += "<b>Testicles Color:</b></a><BR>"
							dat += "<span style='border: 1px solid #161616; background-color: [SKINTONE2HEX(skin_tone)];'>&nbsp;&nbsp;&nbsp;</span>(Skin tone overriding)<br>"
						else
							dat += "<b>Testicles Color:</b></a><BR>"
							dat += "<span style='border: 1px solid #161616; background-color: #[features["balls_color"]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=balls_color;task=input'>Change</a><br>"
						dat += "<b>Testicles Visibility:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=balls_visibility;task=input'>[features["balls_visibility"]]</a>"
				dat += APPEARANCE_CATEGORY_COLUMN
				dat += "<h3>Vagina</h3>"
				dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=has_vag'>[features["has_vag"] == TRUE ? "Yes" : "No"]</a>"
				if(features["has_vag"])
					dat += "<b>Vagina Type:</b> <a style='display:block;width:100px' href='?_src_=prefs;preference=vag_shape;task=input'>[features["vag_shape"]]</a>"
					if(pref_species.use_skintones && features["genitals_use_skintone"] == TRUE)
						dat += "<b>Vagina Color:</b></a><BR>"
						dat += "<span style='border: 1px solid #161616; background-color: [SKINTONE2HEX(skin_tone)];'>&nbsp;&nbsp;&nbsp;</span>(Skin tone overriding)<br>"
					else
						dat += "<b>Vagina Color:</b></a><BR>"
						dat += "<span style='border: 1px solid #161616; background-color: #[features["vag_color"]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=vag_color;task=input'>Change</a><br>"
					dat += "<b>Vagina Visibility:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=vag_visibility;task=input'>[features["vag_visibility"]]</a>"
					dat += "<b>Has Womb:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=has_womb'>[features["has_womb"] == TRUE ? "Yes" : "No"]</a>"
				dat += "</td>"
				dat += APPEARANCE_CATEGORY_COLUMN
				dat += "<h3>Breasts</h3>"
				dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=has_breasts'>[features["has_breasts"] == TRUE ? "Yes" : "No"]</a>"
				if(features["has_breasts"])
					if(pref_species.use_skintones && features["genitals_use_skintone"] == TRUE)
						dat += "<b>Color:</b></a><BR>"
						dat += "<span style='border: 1px solid #161616; background-color: [SKINTONE2HEX(skin_tone)];'>&nbsp;&nbsp;&nbsp;</span>(Skin tone overriding)<br>"
					else
						dat += "<b>Color:</b></a><BR>"
						dat += "<span style='border: 1px solid #161616; background-color: #[features["breasts_color"]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=breasts_color;task=input'>Change</a><br>"
					dat += "<b>Cup Size:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=breasts_size;task=input'>[features["breasts_size"]]</a>"
					dat += "<b>Breasts Shape:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=breasts_shape;task=input'>[features["breasts_shape"]]</a>"
					dat += "<b>Breasts Visibility:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=breasts_visibility;task=input'>[features["breasts_visibility"]]</a>"
					dat += "<b>Lactates:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=breasts_producing'>[features["breasts_producing"] == TRUE ? "Yes" : "No"]</a>"
				dat += "</td>"
			dat += "</td>"
			dat += "</tr></table>"


				//Genital code
				if("cock_color")
					var/new_cockcolor = input(user, "Penis color:", "Character Preference","#"+features["cock_color"]) as color|null
					if(new_cockcolor)
						var/temp_hsv = RGBtoHSV(new_cockcolor)
						if(new_cockcolor == "#000000")
							features["cock_color"] = pref_species.default_color
						else if(ReadHSV(temp_hsv)[3] >= ReadHSV(MINIMUM_MUTANT_COLOR)[3])
							features["cock_color"] = sanitize_hexcolor(new_cockcolor, 6)
						else
							to_chat(user,"<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("cock_length")
					var/min_D = CONFIG_GET(number/penis_min_inches_prefs)
					var/max_D = CONFIG_GET(number/penis_max_inches_prefs)
					var/new_length = input(user, "Penis length in inches:\n([min_D]-[max_D])", "Character Preference") as num|null
					if(new_length)
						features["cock_length"] = clamp(round(new_length), min_D, max_D)

				if("cock_shape")
					var/new_shape
					var/list/hockeys = list()
					if(parent.can_have_part("taur"))
						var/datum/sprite_accessory/taur/T = GLOB.taur_list[features["taur"]]
						for(var/A in GLOB.cock_shapes_list)
							var/datum/sprite_accessory/penis/P = GLOB.cock_shapes_list[A]
							if(P.taur_icon && T.taur_mode & P.accepted_taurs)
								LAZYSET(hockeys, "[A] (Taur)", A)
					new_shape = input(user, "Penis shape:", "Character Preference") as null|anything in (GLOB.cock_shapes_list + hockeys)
					if(new_shape)
						features["cock_taur"] = FALSE
						if(hockeys[new_shape])
							new_shape = hockeys[new_shape]
							features["cock_taur"] = TRUE
						features["cock_shape"] = new_shape

				if("cock_visibility")
					var/n_vis = input(user, "Penis Visibility", "Character Preference") as null|anything in CONFIG_GET(keyed_list/safe_visibility_toggles)
					if(n_vis)
						features["cock_visibility"] = n_vis

				if("balls_color")
					var/new_ballscolor = input(user, "Testicles Color:", "Character Preference","#"+features["balls_color"]) as color|null
					if(new_ballscolor)
						var/temp_hsv = RGBtoHSV(new_ballscolor)
						if(new_ballscolor == "#000000")
							features["balls_color"] = pref_species.default_color
						else if(ReadHSV(temp_hsv)[3] >= ReadHSV(MINIMUM_MUTANT_COLOR)[3])
							features["balls_color"] = sanitize_hexcolor(new_ballscolor, 6)
						else
							to_chat(user,"<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("balls_visibility")
					var/n_vis = input(user, "Testicles Visibility", "Character Preference") as null|anything in CONFIG_GET(keyed_list/safe_visibility_toggles)
					if(n_vis)
						features["balls_visibility"] = n_vis

				if("breasts_size")
					var/new_size = input(user, "Breast Size", "Character Preference") as null|anything in CONFIG_GET(keyed_list/breasts_cups_prefs)
					if(new_size)
						features["breasts_size"] = new_size

				if("breasts_shape")
					var/new_shape
					new_shape = input(user, "Breast Shape", "Character Preference") as null|anything in GLOB.breasts_shapes_list
					if(new_shape)
						features["breasts_shape"] = new_shape

				if("breasts_color")
					var/new_breasts_color = input(user, "Breast Color:", "Character Preference","#"+features["breasts_color"]) as color|null
					if(new_breasts_color)
						var/temp_hsv = RGBtoHSV(new_breasts_color)
						if(new_breasts_color == "#000000")
							features["breasts_color"] = pref_species.default_color
						else if(ReadHSV(temp_hsv)[3] >= ReadHSV(MINIMUM_MUTANT_COLOR)[3])
							features["breasts_color"] = sanitize_hexcolor(new_breasts_color, 6)
						else
							to_chat(user,"<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("breasts_visibility")
					var/n_vis = input(user, "Breasts Visibility", "Character Preference") as null|anything in CONFIG_GET(keyed_list/safe_visibility_toggles)
					if(n_vis)
						features["breasts_visibility"] = n_vis

				if("vag_shape")
					var/new_shape
					new_shape = input(user, "Vagina Type", "Character Preference") as null|anything in GLOB.vagina_shapes_list
					if(new_shape)
						features["vag_shape"] = new_shape

				if("vag_color")
					var/new_vagcolor = input(user, "Vagina color:", "Character Preference","#"+features["vag_color"]) as color|null
					if(new_vagcolor)
						var/temp_hsv = RGBtoHSV(new_vagcolor)
						if(new_vagcolor == "#000000")
							features["vag_color"] = pref_species.default_color
						else if(ReadHSV(temp_hsv)[3] >= ReadHSV(MINIMUM_MUTANT_COLOR)[3])
							features["vag_color"] = sanitize_hexcolor(new_vagcolor, 6)
						else
							to_chat(user,"<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("vag_visibility")
					var/n_vis = input(user, "Vagina Visibility", "Character Preference") as null|anything in CONFIG_GET(keyed_list/safe_visibility_toggles)
					if(n_vis)
						features["vag_visibility"] = n_vis







				//CITADEL PREFERENCES EDIT - I can't figure out how to modularize these, so they have to go here. :c -Pooj
				if("genital_colour")
					features["genitals_use_skintone"] = !features["genitals_use_skintone"]
				if("has_cock")
					features["has_cock"] = !features["has_cock"]
					if(features["has_cock"] == FALSE)
						features["has_balls"] = FALSE
				if("has_balls")
					features["has_balls"] = !features["has_balls"]
				if("has_breasts")
					features["has_breasts"] = !features["has_breasts"]
					if(features["has_breasts"] == FALSE)
						features["breasts_producing"] = FALSE
				if("breasts_producing")
					features["breasts_producing"] = !features["breasts_producing"]
				if("has_vag")
					features["has_vag"] = !features["has_vag"]
					if(features["has_vag"] == FALSE)
						features["has_womb"] = FALSE
				if("has_womb")
					features["has_womb"] = !features["has_womb"]

	//cock features
	S["feature_has_cock"]				>> features["has_cock"]
	S["feature_cock_shape"]				>> features["cock_shape"]
	S["feature_cock_color"]				>> features["cock_color"]
	S["feature_cock_length"]			>> features["cock_length"]
	S["feature_cock_diameter"]			>> features["cock_diameter"]
	S["feature_cock_taur"]				>> features["cock_taur"]
	S["feature_cock_visibility"]		>> features["cock_visibility"]
	//balls features
	S["feature_has_balls"]				>> features["has_balls"]
	S["feature_balls_color"]			>> features["balls_color"]
	S["feature_balls_size"]				>> features["balls_size"]
	S["feature_balls_visibility"]		>> features["balls_visibility"]
	//breasts features
	S["feature_has_breasts"]			>> features["has_breasts"]
	S["feature_breasts_size"]			>> features["breasts_size"]
	S["feature_breasts_shape"]			>> features["breasts_shape"]
	S["feature_breasts_color"]			>> features["breasts_color"]
	S["feature_breasts_producing"]		>> features["breasts_producing"]
	S["feature_breasts_visibility"]		>> features["breasts_visibility"]
	//vagina features
	S["feature_has_vag"]				>> features["has_vag"]
	S["feature_vag_shape"]				>> features["vag_shape"]
	S["feature_vag_color"]				>> features["vag_color"]
	S["feature_vag_visibility"]			>> features["vag_visibility"]
	//womb features
	S["feature_has_womb"]				>> features["has_womb"]


	S["feature_genitals_use_skintone"]	>> features["genitals_use_skintone"]


	var/static/list/B_sizes
	if(!B_sizes)
		var/list/L = CONFIG_GET(keyed_list/breasts_cups_prefs)
		B_sizes = L.Copy()
	var/static/min_D
	if(!min_D)
		min_D = CONFIG_GET(number/penis_min_inches_prefs)
	var/static/max_D
	if(!max_D)
		max_D = CONFIG_GET(number/penis_max_inches_prefs)
	var/static/safe_visibilities
	if(!safe_visibilities)
		var/list/L = CONFIG_GET(keyed_list/safe_visibility_toggles)
		safe_visibilities = L.Copy()


	features["breasts_size"]		= sanitize_inlist(features["breasts_size"], B_sizes, BREASTS_SIZE_DEF)
	features["cock_length"]			= sanitize_integer(features["cock_length"], min_D, max_D, COCK_SIZE_DEF)
	features["breasts_shape"]		= sanitize_inlist(features["breasts_shape"], GLOB.breasts_shapes_list, DEF_BREASTS_SHAPE)
	features["cock_shape"]			= sanitize_inlist(features["cock_shape"], GLOB.cock_shapes_list, DEF_COCK_SHAPE)
	features["balls_shape"]			= sanitize_inlist(features["balls_shape"], GLOB.balls_shapes_list, DEF_BALLS_SHAPE)
	features["vag_shape"]			= sanitize_inlist(features["vag_shape"], GLOB.vagina_shapes_list, DEF_VAGINA_SHAPE)
	features["breasts_color"]		= sanitize_hexcolor(features["breasts_color"], 6, FALSE, "FFFFFF")
	features["cock_color"]			= sanitize_hexcolor(features["cock_color"], 6, FALSE, "FFFFFF")
	features["balls_color"]			= sanitize_hexcolor(features["balls_color"], 6, FALSE, "FFFFFF")
	features["vag_color"]			= sanitize_hexcolor(features["vag_color"], 6, FALSE, "FFFFFF")
	features["breasts_visibility"]	= sanitize_inlist(features["breasts_visibility"], safe_visibilities, GEN_VISIBLE_NO_UNDIES)
	features["cock_visibility"]		= sanitize_inlist(features["cock_visibility"], safe_visibilities, GEN_VISIBLE_NO_UNDIES)
	features["balls_visibility"]	= sanitize_inlist(features["balls_visibility"], safe_visibilities, GEN_VISIBLE_NO_UNDIES)
	features["vag_visibility"]		= sanitize_inlist(features["vag_visibility"], safe_visibilities, GEN_VISIBLE_NO_UNDIES)

