/datum/preferences_collection/character/body
	save_key = PREFERENCES_SAVE_KEY_BODY
	sort_order = 2
	preview_mode = PREFERENCES_PREVIEW_MODE_BODY



	var/custom_species = null
	var/show_mismatched_markings = FALSE //determines whether or not the markings lists should show markings that don't match the currently selected species. Intentionally left unsaved.


	/// If we have persistent scars enabled
	var/persistent_scars = TRUE

	var/be_random_body = 0				//whether we'll have a random body every round
	var/gender = MALE					//gender of character (well duh)
	var/age = 30						//age of character
	var/underwear = "Nude"				//underwear type
	var/undie_color = "FFFFFF"
	var/undershirt = "Nude"				//undershirt type
	var/shirt_color = "FFFFFF"
	var/socks = "Nude"					//socks type
	var/socks_color = "FFFFFF"
	var/backbag = DBACKPACK				//backpack type
	var/jumpsuit_style = PREF_SUIT		//suit/skirt
	var/hair_style = "Bald"				//Hair type
	var/hair_color = "000000"				//Hair color
	var/facial_hair_style = "Shaved"	//Face hair type
	var/facial_hair_color = "000000"		//Facial hair color
	var/skin_tone = "caucasian1"		//Skin color
	var/use_custom_skin_tone = FALSE
	var/left_eye_color = "000000"		//Eye color
	var/right_eye_color = "000000"
	var/eye_type = DEFAULT_EYES_TYPE	//Eye type
	var/split_eye_colors = FALSE
	var/datum/species/pref_species = new /datum/species/human()	//Mutant race
	var/list/features = list("mcolor" = "FFFFFF", "mcolor2" = "FFFFFF", "mcolor3" = "FFFFFF", "tail_lizard" = "Smooth", "tail_human" = "None", "snout" = "Round", "horns" = "None", "horns_color" = "85615a", "ears" = "None", "wings" = "None", "wings_color" = "FFF", "frills" = "None", "deco_wings" = "None", "spines" = "None", "legs" = "Plantigrade", "insect_wings" = "Plain", "insect_fluff" = "None", "insect_markings" = "None", "arachnid_legs" = "Plain", "arachnid_spinneret" = "Plain", "arachnid_mandibles" = "Plain", "mam_body_markings" = list(), "mam_ears" = "None", "mam_snouts" = "None", "mam_tail" = "None", "mam_tail_animated" = "None", "xenodorsal" = "Standard", "xenohead" = "Standard", "xenotail" = "Xenomorph Tail", "taur" = "None", "ipc_screen" = "Sunburst", "ipc_antenna" = "None", "flavor_text" = "", "silicon_flavor_text" = "", "ooc_notes" = "", "meat_type" = "Mammalian", "body_model" = MALE, "body_size" = RESIZE_DEFAULT_SIZE, "color_scheme" = OLD_CHARACTER_COLORING)

	var/modified_limbs = list() //prosthetic/amputated limbs
	var/chosen_limb_id //body sprite selected to load for the users limbs, null means default, is sanitized when loaded

#define MAX_MUTANT_ROWS 5

			dat += "<table><tr><td width='340px' height='300px' valign='top'>"
			dat += "<h2>Flavor Text</h2>"
			dat += "<a href='?_src_=prefs;preference=flavor_text;task=input'><b>Set Examine Text</b></a><br>"
			if(length(features["flavor_text"]) <= 40)
				if(!length(features["flavor_text"]))
					dat += "\[...\]"
				else
					dat += "[features["flavor_text"]]"
			else
				dat += "[TextPreview(features["flavor_text"])]...<BR>"
			dat += "<h2>Silicon Flavor Text</h2>"
			dat += "<h2>OOC notes</h2>"
			dat += "<a href='?_src_=prefs;preference=ooc_notes;task=input'><b>Set OOC notes</b></a><br>"
			var/ooc_notes_len = length(features["ooc_notes"])
			if(ooc_notes_len <= 40)
				if(!ooc_notes_len)
					dat += "\[...\]"
				else
					dat += "[features["ooc_notes"]]"
			else
				dat += "[TextPreview(features["ooc_notes"])]...<BR>"


			dat += "<b>Gender:</b> <a href='?_src_=prefs;preference=gender;task=input'>[gender == MALE ? "Male" : (gender == FEMALE ? "Female" : (gender == PLURAL ? "Non-binary" : "Object"))]</a><BR>"
			dat += "<b>Age:</b> <a style='display:block;width:30px' href='?_src_=prefs;preference=age;task=input'>[age]</a><BR>"
			dat += "<h2>Body</h2>"
			dat += "<b>Gender:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=gender;task=input'>[gender == MALE ? "Male" : (gender == FEMALE ? "Female" : (gender == PLURAL ? "Non-binary" : "Object"))]</a><BR>"
			if(gender != NEUTER && pref_species.sexes)
				dat += "<b>Body Model:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=body_model'>[features["body_model"] == MALE ? "Masculine" : "Feminine"]</a><BR>"
			dat += "<b>Limb Modification:</b><BR>"
			dat += "<a href='?_src_=prefs;preference=modify_limbs;task=input'>Modify Limbs</a><BR>"
			for(var/modification in modified_limbs)
				if(modified_limbs[modification][1] == LOADOUT_LIMB_PROSTHETIC)
					dat += "<b>[modification]: [modified_limbs[modification][2]]</b><BR>"
				else
					dat += "<b>[modification]: [modified_limbs[modification][1]]</b><BR>"
			dat += "<BR>"
			dat += "<b>Species:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=species;task=input'>[pref_species.name]</a><BR>"
			dat += "<b>Custom Species Name:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=custom_species;task=input'>[custom_species ? custom_species : "None"]</a><BR>"
			dat += "<b>Random Body:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=all;task=random'>Randomize!</A><BR>"
			dat += "<b>Always Random Body:</b><a href='?_src_=prefs;preference=all'>[be_random_body ? "Yes" : "No"]</A><BR>"
			dat += "<br><b>Cycle background:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=cycle_bg;task=input'>[bgstate]</a><BR>"
			var/use_skintones = pref_species.use_skintones
			if(use_skintones)
				dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Skin Tone</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=s_tone;task=input'>[use_custom_skin_tone ? "custom: <span style='border:1px solid #161616; background-color: [skin_tone];'>&nbsp;&nbsp;&nbsp;</span>" : skin_tone]</a><BR>"

			var/mutant_colors
			if((MUTCOLORS in pref_species.species_traits) || (MUTCOLORS_PARTSONLY in pref_species.species_traits))
				if(!use_skintones)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Advanced Coloring</h3>"
				dat += "</b><a style='display:block;width:100px' href='?_src_=prefs;preference=color_scheme;task=input'>[(features["color_scheme"] == ADVANCED_CHARACTER_COLORING) ? "Enabled" : "Disabled"]</a>"

				dat += "<h2>Body Colors</h2>"

				dat += "<b>Primary Color:</b><BR>"
				dat += "<span style='border: 1px solid #161616; background-color: #[features["mcolor"]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=mutant_color;task=input'>Change</a><BR>"

				dat += "<b>Secondary Color:</b><BR>"
				dat += "<span style='border: 1px solid #161616; background-color: #[features["mcolor2"]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=mutant_color2;task=input'>Change</a><BR>"

				dat += "<b>Tertiary Color:</b><BR>"
				dat += "<span style='border: 1px solid #161616; background-color: #[features["mcolor3"]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=mutant_color3;task=input'>Change</a><BR>"
				mutant_colors = TRUE

				dat += "<b>Sprite Size:</b> <a href='?_src_=prefs;preference=body_size;task=input'>[features["body_size"]*100]%</a><br>"

			if(!(NOEYES in pref_species.species_traits))
				dat += "<h3>Eye Type</h3>"
				dat += "</b><a style='display:block;width:100px' href='?_src_=prefs;preference=eye_type;task=input'>[eye_type]</a><BR>"
				if((EYECOLOR in pref_species.species_traits))
					if(!use_skintones && !mutant_colors)
						dat += APPEARANCE_CATEGORY_COLUMN
					if(left_eye_color != right_eye_color)
						split_eye_colors = TRUE
					dat += "<h3>Heterochromia</h3>"
					dat += "</b><a style='display:block;width:100px' href='?_src_=prefs;preference=toggle_split_eyes;task=input'>[split_eye_colors ? "Enabled" : "Disabled"]</a>"
					if(!split_eye_colors)
						dat += "<h3>Eye Color</h3>"
						dat += "<span style='border: 1px solid #161616; background-color: #[left_eye_color];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=eyes;task=input'>Change</a>"
						dat += "</td>"
					else
						dat += "<h3>Left Eye Color</h3>"
						dat += "<span style='border: 1px solid #161616; background-color: #[left_eye_color];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=eye_left;task=input'>Change</a>"
						dat += "<h3>Right Eye Color</h3>"
						dat += "<span style='border: 1px solid #161616; background-color: #[right_eye_color];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=eye_right;task=input'>Change</a><BR>"
						dat += "</td>"
				else if(use_skintones || mutant_colors)
					dat += "</td>"

			if(HAIR in pref_species.species_traits)

				dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Hair Style</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=hair_style;task=input'>[hair_style]</a>"
				dat += "<a href='?_src_=prefs;preference=previous_hair_style;task=input'>&lt;</a> <a href='?_src_=prefs;preference=next_hair_style;task=input'>&gt;</a><BR>"
				dat += "<span style='border:1px solid #161616; background-color: #[hair_color];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=hair;task=input'>Change</a><BR>"

				dat += "<h3>Facial Hair Style</h3>"

				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=facial_hair_style;task=input'>[facial_hair_style]</a>"
				dat += "<a href='?_src_=prefs;preference=previous_facehair_style;task=input'>&lt;</a> <a href='?_src_=prefs;preference=next_facehair_style;task=input'>&gt;</a><BR>"
				dat += "<span style='border: 1px solid #161616; background-color: #[facial_hair_color];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=facial;task=input'>Change</a><BR>"

				dat += "</td>"
			//Mutant stuff
			var/mutant_category = 0

			dat += APPEARANCE_CATEGORY_COLUMN
			dat += "<h3>Show mismatched markings</h3>"
			dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=mismatched_markings;task=input'>[show_mismatched_markings ? "Yes" : "No"]</a>"
			mutant_category++
			if(mutant_category >= MAX_MUTANT_ROWS) //just in case someone sets the max rows to 1 or something dumb like that
				dat += "</td>"
				mutant_category = 0

			// rp marking selection
			// assume you can only have mam markings or regular markings or none, never both
			var/marking_type
			if(parent.can_have_part("mam_body_markings"))
				marking_type = "mam_body_markings"
			if(marking_type)
				dat += APPEARANCE_CATEGORY_COLUMN
				dat += "<h3>[GLOB.all_mutant_parts[marking_type]]</h3>" // give it the appropriate title for the type of marking
				dat += "<a href='?_src_=prefs;preference=marking_add;marking_type=[marking_type];task=input'>Add marking</a>"
				// list out the current markings you have
				if(length(features[marking_type]))
					dat += "<table>"
					var/list/markings = features[marking_type]
					if(!islist(markings))
						// something went terribly wrong
						markings = list()
					var/list/reverse_markings = reverseList(markings)
					for(var/list/marking_list in reverse_markings)
						var/marking_index = markings.Find(marking_list) // consider changing loop to go through indexes over lists instead of using Find here
						var/limb_value = marking_list[1]
						var/actual_name = GLOB.bodypart_names[num2text(limb_value)] // get the actual name from the bitflag representing the part the marking is applied to
						var/color_marking_dat = ""
						var/number_colors = 1
						var/datum/sprite_accessory/mam_body_markings/S = GLOB.mam_body_markings_list[marking_list[2]]
						var/matrixed_sections = S.covered_limbs[actual_name]
						if(S && matrixed_sections)
							// if it has nothing initialize it to white
							if(length(marking_list) == 2)
								var/first = "#FFFFFF"
								var/second = "#FFFFFF"
								var/third = "#FFFFFF"
								if(features["mcolor"])
									first = "#[features["mcolor"]]"
								if(features["mcolor2"])
									second = "#[features["mcolor2"]]"
								if(features["mcolor3"])
									third = "#[features["mcolor3"]]"
								marking_list += list(list(first, second, third)) // just assume its 3 colours if it isnt it doesnt matter we just wont use the other values
							// index magic
							var/primary_index = 1
							var/secondary_index = 2
							var/tertiary_index = 3
							switch(matrixed_sections)
								if(MATRIX_GREEN)
									primary_index = 2
								if(MATRIX_BLUE)
									primary_index = 3
								if(MATRIX_RED_BLUE)
									secondary_index = 2
								if(MATRIX_GREEN_BLUE)
									primary_index = 2
									secondary_index = 3

							// we know it has one matrixed section at minimum
							color_marking_dat += "<span style='border: 1px solid #161616; background-color: [marking_list[3][primary_index]];'>&nbsp;&nbsp;&nbsp;</span>"
							// if it has a second section, add it
							if(matrixed_sections == MATRIX_RED_BLUE || matrixed_sections == MATRIX_GREEN_BLUE || matrixed_sections == MATRIX_RED_GREEN || matrixed_sections == MATRIX_ALL)
								color_marking_dat += "<span style='border: 1px solid #161616; background-color: [marking_list[3][secondary_index]];'>&nbsp;&nbsp;&nbsp;</span>"
								number_colors = 2
							// if it has a third section, add it
							if(matrixed_sections == MATRIX_ALL)
								color_marking_dat += "<span style='border: 1px solid #161616; background-color: [marking_list[3][tertiary_index]];'>&nbsp;&nbsp;&nbsp;</span>"
								number_colors = 3
							color_marking_dat += " <a href='?_src_=prefs;preference=marking_color;marking_index=[marking_index];marking_type=[marking_type];number_colors=[number_colors];task=input'>Change</a><BR>"
						dat += "<tr><td>[marking_list[2]] - [actual_name]</td> <td><a href='?_src_=prefs;preference=marking_down;task=input;marking_index=[marking_index];marking_type=[marking_type];'>&#708;</a> <a href='?_src_=prefs;preference=marking_up;task=input;marking_index=[marking_index];marking_type=[marking_type]'>&#709;</a> <a href='?_src_=prefs;preference=marking_remove;task=input;marking_index=[marking_index];marking_type=[marking_type]'>X</a> [color_marking_dat]</td></tr>"
					dat += "</table>"

			for(var/mutant_part in GLOB.all_mutant_parts)
				if(mutant_part == "mam_body_markings")
					continue
				if(parent.can_have_part(mutant_part))
					if(!mutant_category)
						dat += APPEARANCE_CATEGORY_COLUMN
					dat += "<h3>[GLOB.all_mutant_parts[mutant_part]]</h3>"
					dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=[mutant_part];task=input'>[features[mutant_part]]</a>"
					var/color_type = GLOB.colored_mutant_parts[mutant_part] //if it can be coloured, show the appropriate button
					if(color_type)
						dat += "<span style='border:1px solid #161616; background-color: #[features[color_type]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=[color_type];task=input'>Change</a><BR>"
					else
						if(features["color_scheme"] == ADVANCED_CHARACTER_COLORING) //advanced individual part colouring system
							//is it matrixed or does it have extra parts to be coloured?
							var/find_part = features[mutant_part] || pref_species.mutant_bodyparts[mutant_part]
							var/find_part_list = GLOB.mutant_reference_list[mutant_part]
							if(find_part && find_part != "None" && find_part_list)
								var/datum/sprite_accessory/accessory = find_part_list[find_part]
								if(accessory)
									if(accessory.color_src == MATRIXED || accessory.color_src == MUTCOLORS || accessory.color_src == MUTCOLORS2 || accessory.color_src == MUTCOLORS3) //mutcolors1-3 are deprecated now, please don't rely on these in the future
										var/mutant_string = accessory.mutant_part_string
										var/primary_feature = "[mutant_string]_primary"
										var/secondary_feature = "[mutant_string]_secondary"
										var/tertiary_feature = "[mutant_string]_tertiary"
										if(!features[primary_feature])
											features[primary_feature] = features["mcolor"]
										if(!features[secondary_feature])
											features[secondary_feature] = features["mcolor2"]
										if(!features[tertiary_feature])
											features[tertiary_feature] = features["mcolor3"]

										var/matrixed_sections = accessory.matrixed_sections
										if(accessory.color_src == MATRIXED && !matrixed_sections)
											message_admins("Sprite Accessory Failure (customization): Accessory [accessory.type] is a matrixed item without any matrixed sections set!")
											continue
										else if(accessory.color_src == MATRIXED)
											switch(matrixed_sections)
												if(MATRIX_GREEN) //only composed of a green section
													primary_feature = secondary_feature //swap primary for secondary, so it properly assigns the second colour, reserved for the green section
												if(MATRIX_BLUE)
													primary_feature = tertiary_feature //same as above, but the tertiary feature is for the blue section
												if(MATRIX_RED_BLUE) //composed of a red and blue section
													secondary_feature = tertiary_feature //swap secondary for tertiary, as blue should always be tertiary
												if(MATRIX_GREEN_BLUE) //composed of a green and blue section
													primary_feature = secondary_feature //swap primary for secondary, as first option is green, which is linked to the secondary
													secondary_feature = tertiary_feature //swap secondary for tertiary, as second option is blue, which is linked to the tertiary
										dat += "<b>Primary Color</b><BR>"
										dat += "<span style='border:1px solid #161616; background-color: #[features[primary_feature]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=[primary_feature];task=input'>Change</a><BR>"
										if((accessory.color_src == MATRIXED && (matrixed_sections == MATRIX_RED_BLUE || matrixed_sections == MATRIX_GREEN_BLUE || matrixed_sections == MATRIX_RED_GREEN || matrixed_sections == MATRIX_ALL)) || (accessory.extra && (accessory.extra_color_src == MUTCOLORS || accessory.extra_color_src == MUTCOLORS2 || accessory.extra_color_src == MUTCOLORS3)))
											dat += "<b>Secondary Color</b><BR>"
											dat += "<span style='border:1px solid #161616; background-color: #[features[secondary_feature]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=[secondary_feature];task=input'>Change</a><BR>"
											if((accessory.color_src == MATRIXED && matrixed_sections == MATRIX_ALL) || (accessory.extra2 && (accessory.extra2_color_src == MUTCOLORS || accessory.extra2_color_src == MUTCOLORS2 || accessory.extra2_color_src == MUTCOLORS3)))
												dat += "<b>Tertiary Color</b><BR>"
												dat += "<span style='border:1px solid #161616; background-color: #[features[tertiary_feature]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=[tertiary_feature];task=input'>Change</a><BR>"

					mutant_category++
					if(mutant_category >= MAX_MUTANT_ROWS)
						dat += "</td>"
						mutant_category = 0

			if(length(pref_species.allowed_limb_ids))
				if(!chosen_limb_id || !(chosen_limb_id in pref_species.allowed_limb_ids))
					chosen_limb_id = pref_species.limbs_id || pref_species.id
				dat += "<h3>Body sprite</h3>"
				dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=bodysprite;task=input'>[chosen_limb_id]</a>"

			if(mutant_category)
				dat += "</td>"
				mutant_category = 0

			dat += "</tr></table>"

			dat += "</td>"
			dat += "<table><tr><td width='340px' height='300px' valign='top'>"
			dat += "<h2>Clothing & Equipment</h2>"
			dat += "<b>Underwear:</b><a style='display:block;width:100px' href ='?_src_=prefs;preference=underwear;task=input'>[underwear]</a>"
			if(GLOB.underwear_list[underwear]?.has_color)
				dat += "<b>Underwear Color:</b> <span style='border:1px solid #161616; background-color: #[undie_color];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=undie_color;task=input'>Change</a><BR>"
			dat += "<b>Undershirt:</b><a style='display:block;width:100px' href ='?_src_=prefs;preference=undershirt;task=input'>[undershirt]</a>"
			if(GLOB.undershirt_list[undershirt]?.has_color)
				dat += "<b>Undershirt Color:</b> <span style='border:1px solid #161616; background-color: #[shirt_color];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=shirt_color;task=input'>Change</a><BR>"
			dat += "<b>Socks:</b><a style='display:block;width:100px' href ='?_src_=prefs;preference=socks;task=input'>[socks]</a>"
			if(GLOB.socks_list[socks]?.has_color)
				dat += "<b>Socks Color:</b> <span style='border:1px solid #161616; background-color: #[socks_color];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=socks_color;task=input'>Change</a><BR>"
			dat += "<b>Backpack:</b><a style='display:block;width:100px' href ='?_src_=prefs;preference=bag;task=input'>[backbag]</a>"
			dat += "<b>Jumpsuit:</b><BR><a href ='?_src_=prefs;preference=suit;task=input'>[jumpsuit_style]</a><BR>"
			if((HAS_FLESH in pref_species.species_traits) || (HAS_BONE in pref_species.species_traits))
				dat += "<BR><b>Temporal Scarring:</b><BR><a href='?_src_=prefs;preference=persistent_scars'>[(persistent_scars) ? "Enabled" : "Disabled"]</A>"
				dat += "<a href='?_src_=prefs;preference=clear_scars'>Clear scar slots</A>"
			dat += "</td>"

			dat +="<td width='220px' height='300px' valign='top'>"


			dat += "</td><td width='300px' height='300px' valign='top'>"


	//Species
	var/species_id
	S["species"]			>> species_id
	if(species_id)
		if(species_id == "avian" || species_id == "aquatic")
			species_id = "mammal"
		else if(species_id == "moth")
			species_id = "insect"

		var/newtype = GLOB.species_list[species_id]
		if(newtype)
			pref_species = new newtype



	S["custom_species"]			>> custom_species
	S["body_is_always_random"]	>> be_random_body
	S["gender"]					>> gender
	S["body_model"]				>> features["body_model"]
	S["body_size"]				>> features["body_size"]
	S["age"]					>> age
	S["hair_color"]				>> hair_color
	S["facial_hair_color"]		>> facial_hair_color
	S["eye_type"]				>> eye_type
	S["left_eye_color"]			>> left_eye_color
	S["right_eye_color"]		>> right_eye_color
	S["use_custom_skin_tone"]	>> use_custom_skin_tone
	S["skin_tone"]				>> skin_tone
	S["hair_style_name"]		>> hair_style
	S["facial_style_name"]		>> facial_hair_style
	S["underwear"]				>> underwear
	S["undie_color"]			>> undie_color
	S["undershirt"]				>> undershirt
	S["shirt_color"]			>> shirt_color
	S["socks"]					>> socks
	S["socks_color"]			>> socks_color
	S["backbag"]				>> backbag
	S["jumpsuit_style"]			>> jumpsuit_style
	S["feature_mcolor"]					>> features["mcolor"]
	S["feature_lizard_tail"]			>> features["tail_lizard"]
	S["feature_lizard_snout"]			>> features["snout"]
	S["feature_lizard_horns"]			>> features["horns"]
	S["feature_lizard_frills"]			>> features["frills"]
	S["feature_lizard_spines"]			>> features["spines"]
	S["feature_lizard_legs"]			>> features["legs"]
	S["feature_human_tail"]				>> features["tail_human"]
	S["feature_human_ears"]				>> features["ears"]
	S["feature_deco_wings"]				>> features["deco_wings"]
	S["feature_insect_wings"]			>> features["insect_wings"]
	S["feature_insect_fluff"]			>> features["insect_fluff"]
	S["feature_insect_markings"]		>> features["insect_markings"]
	S["feature_arachnid_legs"]			>> features["arachnid_legs"]
	S["feature_arachnid_spinneret"]		>> features["arachnid_spinneret"]
	S["feature_arachnid_mandibles"]		>> features["arachnid_mandibles"]
	S["feature_horns_color"]			>> features["horns_color"]
	S["feature_wings_color"]			>> features["wings_color"]
	S["feature_color_scheme"]			>> features["color_scheme"]
	S["persistent_scars"] 				>> persistent_scars
	var/limbmodstr
	S["modified_limbs"] >> limbmodstr
	if(length(limbmodstr))
		modified_limbs = safe_json_decode(limbmodstr)
	else
		modified_limbs = list()
	S["chosen_limb_id"]					>> chosen_limb_id

	//Citadel code
	S["feature_mcolor2"]				>> features["mcolor2"]
	S["feature_mcolor3"]				>> features["mcolor3"]
	// note safe json decode will runtime the first time it migrates but this is fine and it solves itself don't worry about it if you see it error
	features["mam_body_markings"] = safe_json_decode(S["feature_mam_body_markings"])
	S["feature_mam_tail"]				>> features["mam_tail"]
	S["feature_mam_ears"]				>> features["mam_ears"]
	S["feature_mam_tail_animated"]		>> features["mam_tail_animated"]
	S["feature_taur"]					>> features["taur"]
	S["feature_mam_snouts"]				>> features["mam_snouts"]
	S["feature_meat"]					>> features["meat_type"]
	//Xeno features
	S["feature_xeno_tail"]				>> features["xenotail"]
	S["feature_xeno_dors"]				>> features["xenodorsal"]
	S["feature_xeno_head"]				>> features["xenohead"]

	//flavor text
	//Let's make our players NOT cry desperately as we wipe their savefiles of their special snowflake texts:
	if((S["flavor_text"] != "") && (S["flavor_text"] != null) && S["flavor_text"]) //If old text isn't null and isn't "" but still exists.
		S["flavor_text"]				>> features["flavor_text"] //Load old flavortext as current dna-based flavortext

		WRITE_FILE(S["feature_flavor_text"], features["flavor_text"]) //Save it in our new type of flavor-text
		WRITE_FILE(S["flavor_text"]	, "") //Remove old flavortext, completing the cut-and-paste into the new format.

	else //We have no old flavortext, default to new
		S["feature_flavor_text"]		>> features["flavor_text"]
	S["feature_ooc_notes"]				>> features["ooc_notes"]

	gender		= sanitize_gender(gender, TRUE, TRUE)
	features["body_model"] = sanitize_gender(features["body_model"], FALSE, FALSE, gender == FEMALE ? FEMALE : MALE)
	custom_species	= reject_bad_name(custom_species)

	be_random_body	= sanitize_integer(be_random_body, 0, 1, initial(be_random_body))

	hair_style					= sanitize_inlist(hair_style, GLOB.hair_styles_list)
	facial_hair_style			= sanitize_inlist(facial_hair_style, GLOB.facial_hair_styles_list)
	underwear					= sanitize_inlist(underwear, GLOB.underwear_list)
	undershirt 					= sanitize_inlist(undershirt, GLOB.undershirt_list)
	undie_color						= sanitize_hexcolor(undie_color, 6, FALSE, initial(undie_color))
	shirt_color						= sanitize_hexcolor(shirt_color, 6, FALSE, initial(shirt_color))
	socks							= sanitize_inlist(socks, GLOB.socks_list)
	socks_color						= sanitize_hexcolor(socks_color, 6, FALSE, initial(socks_color))
	age								= sanitize_integer(age, AGE_MIN, AGE_MAX, initial(age))
	hair_color						= sanitize_hexcolor(hair_color, 6, FALSE)
	facial_hair_color				= sanitize_hexcolor(facial_hair_color, 6, FALSE)
	eye_type						= sanitize_inlist(eye_type, GLOB.eye_types, DEFAULT_EYES_TYPE)
	left_eye_color					= sanitize_hexcolor(left_eye_color, 6, FALSE)
	right_eye_color					= sanitize_hexcolor(right_eye_color, 6, FALSE)

	var/static/allow_custom_skintones
	if(isnull(allow_custom_skintones))
		allow_custom_skintones = CONFIG_GET(flag/allow_custom_skintones)
	use_custom_skin_tone			= allow_custom_skintones ? sanitize_integer(use_custom_skin_tone, FALSE, TRUE, initial(use_custom_skin_tone)) : FALSE
	if(use_custom_skin_tone)
		skin_tone					= sanitize_hexcolor(skin_tone, 6, TRUE, "#FFFFFF")
	else
		skin_tone					= sanitize_inlist(skin_tone, GLOB.skin_tones - GLOB.nonstandard_skin_tones, initial(skin_tone))

	features["horns_color"]			= sanitize_hexcolor(features["horns_color"], 6, FALSE, "85615a")
	features["wings_color"]			= sanitize_hexcolor(features["wings_color"], 6, FALSE, "FFFFFF")
	backbag							= sanitize_inlist(backbag, GLOB.backbaglist, initial(backbag))
	jumpsuit_style					= sanitize_inlist(jumpsuit_style, GLOB.jumpsuitlist, initial(jumpsuit_style))
	features["mcolor"]				= sanitize_hexcolor(features["mcolor"], 6, FALSE)
	features["tail_lizard"]			= sanitize_inlist(features["tail_lizard"], GLOB.tails_list_lizard)
	features["tail_human"]			= sanitize_inlist(features["tail_human"], GLOB.tails_list_human)
	features["snout"]				= sanitize_inlist(features["snout"], GLOB.snouts_list)
	features["horns"]				= sanitize_inlist(features["horns"], GLOB.horns_list)
	features["ears"]				= sanitize_inlist(features["ears"], GLOB.ears_list)
	features["frills"]				= sanitize_inlist(features["frills"], GLOB.frills_list)
	features["spines"]				= sanitize_inlist(features["spines"], GLOB.spines_list)
	features["legs"]				= sanitize_inlist(features["legs"], GLOB.legs_list, "Plantigrade")
	features["deco_wings"] 			= sanitize_inlist(features["deco_wings"], GLOB.deco_wings_list, "None")
	features["insect_fluff"]		= sanitize_inlist(features["insect_fluff"], GLOB.insect_fluffs_list)
	features["insect_markings"] 	= sanitize_inlist(features["insect_markings"], GLOB.insect_markings_list, "None")
	features["insect_wings"] 		= sanitize_inlist(features["insect_wings"], GLOB.insect_wings_list)
	features["arachnid_legs"] 		= sanitize_inlist(features["arachnid_legs"], GLOB.arachnid_legs_list, "Plain")
	features["arachnid_spinneret"] 	= sanitize_inlist(features["arachnid_spinneret"], GLOB.arachnid_spinneret_list, "Plain")
	features["arachnid_mandibles"]	= sanitize_inlist(features["arachnid_mandibles"], GLOB.arachnid_mandibles_list, "Plain")

	var/static/size_min
	if(!size_min)
		size_min = CONFIG_GET(number/body_size_min)
	var/static/size_max
	if(!size_max)
		size_max = CONFIG_GET(number/body_size_max)
	features["body_size"]			= sanitize_num_clamp(features["body_size"], size_min, size_max, RESIZE_DEFAULT_SIZE, 0.01)

	security_records				= copytext(security_records, 1, MAX_FLAVOR_LEN)
	medical_records					= copytext(medical_records, 1, MAX_FLAVOR_LEN)

	features["flavor_text"]			= copytext(features["flavor_text"], 1, MAX_FLAVOR_LEN)
	features["ooc_notes"]			= copytext(features["ooc_notes"], 1, MAX_FLAVOR_LEN)

	//load every advanced coloring mode thing in one go
	//THIS MUST BE DONE AFTER ALL FEATURE SAVES OR IT WILL NOT WORK
	for(var/feature in features)
		var/feature_value = features[feature]
		if(feature_value)
			var/ref_list = GLOB.mutant_reference_list[feature]
			if(ref_list)
				var/datum/sprite_accessory/accessory = ref_list[feature_value]
				if(accessory)
					var/mutant_string = accessory.mutant_part_string
					if(!mutant_string)
						if(istype(accessory, /datum/sprite_accessory/mam_body_markings))
							mutant_string = "mam_body_markings"
					var/primary_string = "[mutant_string]_primary"
					var/secondary_string = "[mutant_string]_secondary"
					var/tertiary_string = "[mutant_string]_tertiary"
					if(accessory.color_src == MATRIXED && !accessory.matrixed_sections && feature_value != "None")
						message_admins("Sprite Accessory Failure (loading data): Accessory [accessory.type] is a matrixed item without any matrixed sections set!")
						continue
					if(S["feature_[primary_string]"])
						S["feature_[primary_string]"]		>> features[primary_string]
					if(S["feature_[secondary_string]"])
						S["feature_[secondary_string]"]		>> features[secondary_string]
					if(S["feature_[tertiary_string]"])
						S["feature_[tertiary_string]"]		>> features[tertiary_string]

	persistent_scars = sanitize_integer(persistent_scars)

	//save every advanced coloring mode thing in one go
	for(var/feature in features)
		var/feature_value = features[feature]
		if(feature_value)
			var/ref_list = GLOB.mutant_reference_list[feature]
			if(ref_list)
				var/datum/sprite_accessory/accessory = ref_list[feature_value]
				if(accessory)
					var/mutant_string = accessory.mutant_part_string
					if(!mutant_string)
						if(istype(accessory, /datum/sprite_accessory/mam_body_markings))
							mutant_string = "mam_body_markings"
					var/primary_string = "[mutant_string]_primary"
					var/secondary_string = "[mutant_string]_secondary"
					var/tertiary_string = "[mutant_string]_tertiary"
					if(accessory.color_src == MATRIXED && !accessory.matrixed_sections && feature_value != "None")
						message_admins("Sprite Accessory Failure (saving data): Accessory [accessory.type] is a matrixed item without any matrixed sections set!")
						continue
					if(features[primary_string])
						WRITE_FILE(S["feature_[primary_string]"], features[primary_string])
					if(features[secondary_string])
						WRITE_FILE(S["feature_[secondary_string]"], features[secondary_string])
					if(features[tertiary_string])
						WRITE_FILE(S["feature_[tertiary_string]"], features[tertiary_string])

	//ipcs
	WRITE_FILE(S["feature_ipc_screen"], features["ipc_screen"])
	WRITE_FILE(S["feature_ipc_antenna"], features["ipc_antenna"])
	//Citadel
	WRITE_FILE(S["feature_genitals_use_skintone"], features["genitals_use_skintone"])
	WRITE_FILE(S["feature_mcolor2"], features["mcolor2"])
	WRITE_FILE(S["feature_mcolor3"], features["mcolor3"])
	WRITE_FILE(S["feature_mam_body_markings"], safe_json_encode(features["mam_body_markings"]))
	WRITE_FILE(S["feature_mam_tail"], features["mam_tail"])
	WRITE_FILE(S["feature_mam_ears"], features["mam_ears"])
	WRITE_FILE(S["feature_mam_tail_animated"], features["mam_tail_animated"])
	WRITE_FILE(S["feature_taur"], features["taur"])
	WRITE_FILE(S["feature_mam_snouts"],	features["mam_snouts"])
	//Xeno features
	WRITE_FILE(S["feature_xeno_tail"], features["xenotail"])
	WRITE_FILE(S["feature_xeno_dors"], features["xenodorsal"])
	WRITE_FILE(S["feature_xeno_head"], features["xenohead"])
	//flavor text
	WRITE_FILE(S["feature_flavor_text"], features["flavor_text"])
	WRITE_FILE(S["silicon_feature_flavor_text"], features["silicon_flavor_text"])


	switch(href_list["task"])
		if("random")
			switch(href_list["preference"])
				if("age")
					age = rand(AGE_MIN, AGE_MAX)
				if("hair")
					hair_color = random_short_color()
				if("hair_style")
					hair_style = random_hair_style(gender)
				if("facial")
					facial_hair_color = random_short_color()
				if("facial_hair_style")
					facial_hair_style = random_facial_hair_style(gender)
				if("underwear")
					underwear = random_underwear(gender)
					undie_color = random_short_color()
				if("undershirt")
					undershirt = random_undershirt(gender)
					shirt_color = random_short_color()
				if("socks")
					socks = random_socks()
					socks_color = random_short_color()
				if(BODY_ZONE_PRECISE_EYES)
					var/random_eye_color = random_eye_color()
					left_eye_color = random_eye_color
					right_eye_color = random_eye_color
				if("s_tone")
					skin_tone = random_skin_tone()
					use_custom_skin_tone = null
				if("bag")
					backbag = pick(GLOB.backbaglist)
				if("suit")
					jumpsuit_style = pick(GLOB.jumpsuitlist)
				if("all")
					random_character()
				if("age")
					var/new_age = input(user, "Choose your character's age:\n([AGE_MIN]-[AGE_MAX])", "Character Preference") as num|null
					if(new_age)
						age = max(min( round(text2num(new_age)), AGE_MAX),AGE_MIN)
				if("flavor_text")
					var/msg = stripped_multiline_input(usr, "Set the flavor text in your 'examine' verb. This can also be used for OOC notes and preferences!", "Flavor Text", html_decode(features["flavor_text"]), MAX_FLAVOR_LEN, TRUE)
					if(!isnull(msg))
						features["flavor_text"] = msg

				if("ooc_notes")
					var/msg = stripped_multiline_input(usr, "Set always-visible OOC notes related to content preferences. THIS IS NOT FOR CHARACTER DESCRIPTIONS!", "OOC notes", html_decode(features["ooc_notes"]), MAX_FLAVOR_LEN, TRUE)
					if(!isnull(msg))
						features["ooc_notes"] = msg


				if("hair")
					var/new_hair = input(user, "Choose your character's hair colour:", "Character Preference","#"+hair_color) as color|null
					if(new_hair)
						hair_color = sanitize_hexcolor(new_hair, 6)

				if("hair_style")
					var/new_hair_style
					new_hair_style = input(user, "Choose your character's hair style:", "Character Preference")  as null|anything in GLOB.hair_styles_list
					if(new_hair_style)
						hair_style = new_hair_style

				if("next_hair_style")
					hair_style = next_list_item(hair_style, GLOB.hair_styles_list)

				if("previous_hair_style")
					hair_style = previous_list_item(hair_style, GLOB.hair_styles_list)

				if("facial")
					var/new_facial = input(user, "Choose your character's facial-hair colour:", "Character Preference","#"+facial_hair_color) as color|null
					if(new_facial)
						facial_hair_color = sanitize_hexcolor(new_facial, 6)

				if("facial_hair_style")
					var/new_facial_hair_style
					new_facial_hair_style = input(user, "Choose your character's facial-hair style:", "Character Preference")  as null|anything in GLOB.facial_hair_styles_list
					if(new_facial_hair_style)
						facial_hair_style = new_facial_hair_style

				if("next_facehair_style")
					facial_hair_style = next_list_item(facial_hair_style, GLOB.facial_hair_styles_list)

				if("previous_facehair_style")
					facial_hair_style = previous_list_item(facial_hair_style, GLOB.facial_hair_styles_list)
				if("modify_limbs")
					var/limb_type = input(user, "Choose the limb to modify:", "Character Preference") as null|anything in LOADOUT_ALLOWED_LIMB_TARGETS
					if(limb_type)
						var/modification_type = input(user, "Choose the modification to the limb:", "Character Preference") as null|anything in LOADOUT_LIMBS
						if(modification_type)
							if(modification_type == LOADOUT_LIMB_PROSTHETIC)
								var/prosthetic_type = input(user, "Choose the type of prosthetic", "Character Preference") as null|anything in (list("prosthetic") + GLOB.prosthetic_limb_types)
								if(prosthetic_type)
									var/number_of_prosthetics = 0
									for(var/modified_limb in modified_limbs)
										if(modified_limbs[modified_limb][1] == LOADOUT_LIMB_PROSTHETIC && modified_limb != limb_type)
											number_of_prosthetics += 1
									if(number_of_prosthetics == MAXIMUM_LOADOUT_PROSTHETICS)
										to_chat(user, "<span class='danger'>You can only have up to two prosthetic limbs!</span>")
									else
										//save the actual prosthetic data
										modified_limbs[limb_type] = list(modification_type, prosthetic_type)
							else
								if(modification_type == LOADOUT_LIMB_NORMAL)
									modified_limbs -= limb_type
								else
									modified_limbs[limb_type] = list(modification_type)

				if("underwear")
					var/new_underwear = input(user, "Choose your character's underwear:", "Character Preference")  as null|anything in GLOB.underwear_list
					if(new_underwear)
						underwear = new_underwear

				if("undie_color")
					var/n_undie_color = input(user, "Choose your underwear's color.", "Character Preference", "#[undie_color]") as color|null
					if(n_undie_color)
						undie_color = sanitize_hexcolor(n_undie_color, 6)

				if("undershirt")
					var/new_undershirt = input(user, "Choose your character's undershirt:", "Character Preference") as null|anything in GLOB.undershirt_list
					if(new_undershirt)
						undershirt = new_undershirt

				if("shirt_color")
					var/n_shirt_color = input(user, "Choose your undershirt's color.", "Character Preference", "#[shirt_color]") as color|null
					if(n_shirt_color)
						shirt_color = sanitize_hexcolor(n_shirt_color, 6)

				if("socks")
					var/new_socks = input(user, "Choose your character's socks:", "Character Preference") as null|anything in GLOB.socks_list
					if(new_socks)
						socks = new_socks

				if("socks_color")
					var/n_socks_color = input(user, "Choose your socks' color.", "Character Preference", "#[socks_color]") as color|null
					if(n_socks_color)
						socks_color = sanitize_hexcolor(n_socks_color, 6)

				if("eyes")
					var/new_eyes = input(user, "Choose your character's eye colour:", "Character Preference","#"+left_eye_color) as color|null
					if(new_eyes)
						left_eye_color = sanitize_hexcolor(new_eyes, 6)
						right_eye_color = sanitize_hexcolor(new_eyes, 6)

				if("eye_left")
					var/new_eyes = input(user, "Choose your character's left eye colour:", "Character Preference","#"+left_eye_color) as color|null
					if(new_eyes)
						left_eye_color = sanitize_hexcolor(new_eyes, 6)

				if("eye_right")
					var/new_eyes = input(user, "Choose your character's right eye colour:", "Character Preference","#"+right_eye_color) as color|null
					if(new_eyes)
						right_eye_color = sanitize_hexcolor(new_eyes, 6)

				if("eye_type")
					var/new_eye_type = input(user, "Choose your character's eye type.", "Character Preference") as null|anything in GLOB.eye_types
					if(new_eye_type)
						eye_type = new_eye_type

				if("toggle_split_eyes")
					split_eye_colors = !split_eye_colors
					right_eye_color = left_eye_color

				if("species")
					var/result = input(user, "Select a species", "Species Selection") as null|anything in GLOB.roundstart_race_names
					if(result)
						var/newtype = GLOB.species_list[GLOB.roundstart_race_names[result]]
						pref_species = new newtype()
						//let's ensure that no weird shit happens on species swapping.
						custom_species = null
						if(!parent.can_have_part("mam_body_markings"))
							features["mam_body_markings"] = list()
						if(parent.can_have_part("mam_body_markings"))
							if(features["mam_body_markings"] == "None")
								features["mam_body_markings"] = list()
						if(parent.can_have_part("tail_lizard"))
							features["tail_lizard"] = "Smooth"
						if(pref_species.id == "felinid")
							features["mam_tail"] = "Cat"
							features["mam_ears"] = "Cat"

						//Now that we changed our species, we must verify that the mutant colour is still allowed.
						var/temp_hsv = RGBtoHSV(features["mcolor"])
						if(features["mcolor"] == "#000000" || (!(MUTCOLORS_PARTSONLY in pref_species.species_traits) && ReadHSV(temp_hsv)[3] < ReadHSV("#202020")[3]))
							features["mcolor"] = pref_species.default_color
						if(features["mcolor2"] == "#000000" || (!(MUTCOLORS_PARTSONLY in pref_species.species_traits) && ReadHSV(temp_hsv)[3] < ReadHSV("#202020")[3]))
							features["mcolor2"] = pref_species.default_color
						if(features["mcolor3"] == "#000000" || (!(MUTCOLORS_PARTSONLY in pref_species.species_traits) && ReadHSV(temp_hsv)[3] < ReadHSV("#202020")[3]))
							features["mcolor3"] = pref_species.default_color

						//switch to the type of eyes the species uses
						eye_type = pref_species.eye_type

				if("custom_species")
					var/new_species = reject_bad_name(input(user, "Choose your species subtype, if unique. This will show up on examinations and health scans. Do not abuse this:", "Character Preference", custom_species) as null|text)
					if(new_species)
						custom_species = new_species
					else
						custom_species = null

				if("mutant_color")
					var/new_mutantcolor = input(user, "Choose your character's alien/mutant color:", "Character Preference","#"+features["mcolor"]) as color|null
					if(new_mutantcolor)
						var/temp_hsv = RGBtoHSV(new_mutantcolor)
						if(new_mutantcolor == "#000000")
							features["mcolor"] = pref_species.default_color
						else if((MUTCOLORS_PARTSONLY in pref_species.species_traits) || ReadHSV(temp_hsv)[3] >= ReadHSV(MINIMUM_MUTANT_COLOR)[3]) // mutantcolors must be bright, but only if they affect the skin
							features["mcolor"] = sanitize_hexcolor(new_mutantcolor, 6)
						else
							to_chat(user, "<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("mutant_color2")
					var/new_mutantcolor = input(user, "Choose your character's secondary alien/mutant color:", "Character Preference","#"+features["mcolor2"]) as color|null
					if(new_mutantcolor)
						var/temp_hsv = RGBtoHSV(new_mutantcolor)
						if(new_mutantcolor == "#000000")
							features["mcolor2"] = pref_species.default_color
						else if((MUTCOLORS_PARTSONLY in pref_species.species_traits) || ReadHSV(temp_hsv)[3] >= ReadHSV(MINIMUM_MUTANT_COLOR)[3]) // mutantcolors must be bright, but only if they affect the skin
							features["mcolor2"] = sanitize_hexcolor(new_mutantcolor, 6)
						else
							to_chat(user, "<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("mutant_color3")
					var/new_mutantcolor = input(user, "Choose your character's tertiary alien/mutant color:", "Character Preference","#"+features["mcolor3"]) as color|null
					if(new_mutantcolor)
						var/temp_hsv = RGBtoHSV(new_mutantcolor)
						if(new_mutantcolor == "#000000")
							features["mcolor3"] = pref_species.default_color
						else if((MUTCOLORS_PARTSONLY in pref_species.species_traits) || ReadHSV(temp_hsv)[3] >= ReadHSV(MINIMUM_MUTANT_COLOR)[3]) // mutantcolors must be bright, but only if they affect the skin
							features["mcolor3"] = sanitize_hexcolor(new_mutantcolor, 6)
						else
							to_chat(user, "<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("mismatched_markings")
					show_mismatched_markings = !show_mismatched_markings

				if("ipc_screen")
					var/new_ipc_screen
					new_ipc_screen = input(user, "Choose your character's screen:", "Character Preference") as null|anything in GLOB.ipc_screens_list
					if(new_ipc_screen)
						features["ipc_screen"] = new_ipc_screen

				if("ipc_antenna")
					var/list/snowflake_antenna_list = list()
					//Potential todo: turn all of THIS into a define to reduce copypasta.
					for(var/path in GLOB.ipc_antennas_list)
						var/datum/sprite_accessory/antenna/instance = GLOB.ipc_antennas_list[path]
						if(istype(instance, /datum/sprite_accessory))
							var/datum/sprite_accessory/S = instance
							if(!show_mismatched_markings && S.recommended_species && !S.recommended_species.Find(pref_species.id))
								continue
							if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(user.client.ckey)))
								snowflake_antenna_list[S.name] = path
					var/new_ipc_antenna
					new_ipc_antenna = input(user, "Choose your character's antenna:", "Character Preference") as null|anything in snowflake_antenna_list
					if(new_ipc_antenna)
						features["ipc_antenna"] = new_ipc_antenna

				if("arachnid_legs")
					var/new_arachnid_legs
					new_arachnid_legs = input(user, "Choose your character's variant of arachnid legs:", "Character Preference") as null|anything in GLOB.arachnid_legs_list
					if(new_arachnid_legs)
						features["arachnid_legs"] = new_arachnid_legs

				if("arachnid_spinneret")
					var/new_arachnid_spinneret
					new_arachnid_spinneret = input(user, "Choose your character's spinneret markings:", "Character Preference") as null|anything in GLOB.arachnid_spinneret_list
					if(new_arachnid_spinneret)
						features["arachnid_spinneret"] = new_arachnid_spinneret

				if("arachnid_mandibles")
					var/new_arachnid_mandibles
					new_arachnid_mandibles = input(user, "Choose your character's variant of mandibles:", "Character Preference") as null|anything in GLOB.arachnid_mandibles_list
					if (new_arachnid_mandibles)
						features["arachnid_mandibles"] = new_arachnid_mandibles

				if("tail_lizard")
					var/new_tail
					new_tail = input(user, "Choose your character's tail:", "Character Preference") as null|anything in GLOB.tails_list_lizard
					if(new_tail)
						features["tail_lizard"] = new_tail
						if(new_tail != "None")
							features["taur"] = "None"
							features["tail_human"] = "None"
							features["mam_tail"] = "None"

				if("tail_human")
					var/list/snowflake_tails_list = list()
					for(var/path in GLOB.tails_list_human)
						var/datum/sprite_accessory/tails/human/instance = GLOB.tails_list_human[path]
						if(istype(instance, /datum/sprite_accessory))
							var/datum/sprite_accessory/S = instance
							if(!show_mismatched_markings && S.recommended_species && !S.recommended_species.Find(pref_species.id))
								continue
							if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(user.client.ckey)))
								snowflake_tails_list[S.name] = path
					var/new_tail
					new_tail = input(user, "Choose your character's tail:", "Character Preference") as null|anything in snowflake_tails_list
					if(new_tail)
						features["tail_human"] = new_tail
						if(new_tail != "None")
							features["taur"] = "None"
							features["tail_lizard"] = "None"
							features["mam_tail"] = "None"

				if("mam_tail")
					var/list/snowflake_tails_list = list()
					for(var/path in GLOB.mam_tails_list)
						var/datum/sprite_accessory/tails/mam_tails/instance = GLOB.mam_tails_list[path]
						if(istype(instance, /datum/sprite_accessory))
							var/datum/sprite_accessory/S = instance
							if(!show_mismatched_markings && S.recommended_species && !S.recommended_species.Find(pref_species.id))
								continue
							if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(user.client.ckey)))
								snowflake_tails_list[S.name] = path
					var/new_tail
					new_tail = input(user, "Choose your character's tail:", "Character Preference") as null|anything in snowflake_tails_list
					if(new_tail)
						features["mam_tail"] = new_tail
						if(new_tail != "None")
							features["taur"] = "None"
							features["tail_human"] = "None"
							features["tail_lizard"] = "None"

				if("meat_type")
					var/new_meat
					new_meat = input(user, "Choose your character's meat type:", "Character Preference") as null|anything in GLOB.meat_types
					if(new_meat)
						features["meat_type"] = new_meat

				if("snout")
					var/list/snowflake_snouts_list = list()
					for(var/path in GLOB.snouts_list)
						var/datum/sprite_accessory/snouts/mam_snouts/instance = GLOB.snouts_list[path]
						if(istype(instance, /datum/sprite_accessory))
							var/datum/sprite_accessory/S = instance
							if(!show_mismatched_markings && S.recommended_species && !S.recommended_species.Find(pref_species.id))
								continue
							if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(user.client.ckey)))
								snowflake_snouts_list[S.name] = path
					var/new_snout
					new_snout = input(user, "Choose your character's snout:", "Character Preference") as null|anything in snowflake_snouts_list
					if(new_snout)
						features["snout"] = new_snout
						features["mam_snouts"] = "None"


				if("mam_snouts")
					var/list/snowflake_mam_snouts_list = list()
					for(var/path in GLOB.mam_snouts_list)
						var/datum/sprite_accessory/snouts/mam_snouts/instance = GLOB.mam_snouts_list[path]
						if(istype(instance, /datum/sprite_accessory))
							var/datum/sprite_accessory/S = instance
							if(!show_mismatched_markings && S.recommended_species && !S.recommended_species.Find(pref_species.id))
								continue
							if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(user.client.ckey)))
								snowflake_mam_snouts_list[S.name] = path
					var/new_mam_snouts
					new_mam_snouts = input(user, "Choose your character's snout:", "Character Preference") as null|anything in snowflake_mam_snouts_list
					if(new_mam_snouts)
						features["mam_snouts"] = new_mam_snouts
						features["snout"] = "None"

				if("horns")
					var/new_horns
					new_horns = input(user, "Choose your character's horns:", "Character Preference") as null|anything in GLOB.horns_list
					if(new_horns)
						features["horns"] = new_horns

				if("horns_color")
					var/new_horn_color = input(user, "Choose your character's horn colour:", "Character Preference","#"+features["horns_color"]) as color|null
					if(new_horn_color)
						if (new_horn_color == "#000000")
							features["horns_color"] = "85615A"
						else
							features["horns_color"] = sanitize_hexcolor(new_horn_color, 6)

				if("wings")
					var/new_wings
					new_wings = input(user, "Choose your character's wings:", "Character Preference") as null|anything in GLOB.r_wings_list
					if(new_wings)
						features["wings"] = new_wings

				if("wings_color")
					var/new_wing_color = input(user, "Choose your character's wing colour:", "Character Preference","#"+features["wings_color"]) as color|null
					if(new_wing_color)
						if (new_wing_color == "#000000")
							features["wings_color"] = "#FFFFFF"
						else
							features["wings_color"] = sanitize_hexcolor(new_wing_color, 6)

				if("frills")
					var/new_frills
					new_frills = input(user, "Choose your character's frills:", "Character Preference") as null|anything in GLOB.frills_list
					if(new_frills)
						features["frills"] = new_frills

				if("spines")
					var/new_spines
					new_spines = input(user, "Choose your character's spines:", "Character Preference") as null|anything in GLOB.spines_list
					if(new_spines)
						features["spines"] = new_spines

				if("legs")
					var/new_legs
					new_legs = input(user, "Choose your character's legs:", "Character Preference") as null|anything in GLOB.legs_list
					if(new_legs)
						features["legs"] = new_legs

				if("insect_wings")
					var/new_insect_wings
					new_insect_wings = input(user, "Choose your character's wings:", "Character Preference") as null|anything in GLOB.insect_wings_list
					if(new_insect_wings)
						features["insect_wings"] = new_insect_wings

				if("deco_wings")
					var/new_deco_wings
					new_deco_wings = input(user, "Choose your character's wings:", "Character Preference") as null|anything in GLOB.deco_wings_list
					if(new_deco_wings)
						features["deco_wings"] = new_deco_wings

				if("insect_fluff")
					var/new_insect_fluff
					new_insect_fluff = input(user, "Choose your character's wings:", "Character Preference") as null|anything in GLOB.insect_fluffs_list
					if(new_insect_fluff)
						features["insect_fluff"] = new_insect_fluff

				if("insect_markings")
					var/new_insect_markings
					new_insect_markings = input(user, "Choose your character's markings:", "Character Preference") as null|anything in GLOB.insect_markings_list
					if(new_insect_markings)
						features["insect_markings"] = new_insect_markings

				if("arachnid_legs")
					var/new_arachnid_legs
					new_arachnid_legs = input(user, "Choose your character's variant of arachnid legs:", "Character Preference") as null|anything in GLOB.arachnid_legs_list
					if(new_arachnid_legs)
						features["arachnid_legs"] = new_arachnid_legs

				if("arachnid_spinneret")
					var/new_arachnid_spinneret
					new_arachnid_spinneret = input(user, "Choose your character's spinneret markings:", "Character Preference") as null|anything in GLOB.arachnid_spinneret_list
					if(new_arachnid_spinneret)
						features["arachnid_spinneret"] = new_arachnid_spinneret

				if("arachnid_mandibles")
					var/new_arachnid_mandibles
					new_arachnid_mandibles = input(user, "Choose your character's variant of mandibles:", "Character Preference") as null|anything in GLOB.arachnid_mandibles_list
					if (new_arachnid_mandibles)
						features["arachnid_mandibles"] = new_arachnid_mandibles

				if("s_tone")
					var/list/choices = GLOB.skin_tones - GLOB.nonstandard_skin_tones
					if(CONFIG_GET(flag/allow_custom_skintones))
						choices += "custom"
					var/new_s_tone = input(user, "Choose your character's skin tone:", "Character Preference")  as null|anything in choices
					if(new_s_tone)
						if(new_s_tone == "custom")
							var/default = use_custom_skin_tone ? skin_tone : null
							var/custom_tone = input(user, "Choose your custom skin tone:", "Character Preference", default) as color|null
							if(custom_tone)
								var/temp_hsv = RGBtoHSV(custom_tone)
								if(ReadHSV(temp_hsv)[3] < ReadHSV("#333333")[3]) // rgb(50,50,50)
									to_chat(user,"<span class='danger'>Invalid color. Your color is not bright enough.</span>")
								else
									use_custom_skin_tone = TRUE
									skin_tone = custom_tone
						else
							use_custom_skin_tone = FALSE
							skin_tone = new_s_tone

				if("taur")
					var/list/snowflake_taur_list = list()
					for(var/path in GLOB.taur_list)
						var/datum/sprite_accessory/taur/instance = GLOB.taur_list[path]
						if(istype(instance, /datum/sprite_accessory))
							var/datum/sprite_accessory/S = instance
							if(!show_mismatched_markings && S.recommended_species && !S.recommended_species.Find(pref_species.id))
								continue
							if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(user.client.ckey)))
								snowflake_taur_list[S.name] = path
					var/new_taur
					new_taur = input(user, "Choose your character's tauric body:", "Character Preference") as null|anything in snowflake_taur_list
					if(new_taur)
						features["taur"] = new_taur
						if(new_taur != "None")
							features["mam_tail"] = "None"
							features["xenotail"] = "None"
							features["tail_human"] = "None"
							features["tail_lizard"] = "None"
							features["arachnid_spinneret"] = "None"

				if("ears")
					var/list/snowflake_ears_list = list()
					for(var/path in GLOB.ears_list)
						var/datum/sprite_accessory/ears/instance = GLOB.ears_list[path]
						if(istype(instance, /datum/sprite_accessory))
							var/datum/sprite_accessory/S = instance
							if(!show_mismatched_markings && S.recommended_species && !S.recommended_species.Find(pref_species.id))
								continue
							if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(user.client.ckey)))
								snowflake_ears_list[S.name] = path
					var/new_ears
					new_ears = input(user, "Choose your character's ears:", "Character Preference") as null|anything in snowflake_ears_list
					if(new_ears)
						features["ears"] = new_ears

				if("mam_ears")
					var/list/snowflake_ears_list = list()
					for(var/path in GLOB.mam_ears_list)
						var/datum/sprite_accessory/ears/mam_ears/instance = GLOB.mam_ears_list[path]
						if(istype(instance, /datum/sprite_accessory))
							var/datum/sprite_accessory/S = instance
							if(!show_mismatched_markings && S.recommended_species && !S.recommended_species.Find(pref_species.id))
								continue
							if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(user.client.ckey)))
								snowflake_ears_list[S.name] = path
					var/new_ears
					new_ears = input(user, "Choose your character's ears:", "Character Preference") as null|anything in snowflake_ears_list
					if(new_ears)
						features["mam_ears"] = new_ears

				//Xeno Bodyparts
				if("xenohead")//Head or caste type
					var/new_head
					new_head = input(user, "Choose your character's caste:", "Character Preference") as null|anything in GLOB.xeno_head_list
					if(new_head)
						features["xenohead"] = new_head

				if("xenotail")//Currently one one type, more maybe later if someone sprites them. Might include animated variants in the future.
					var/new_tail
					new_tail = input(user, "Choose your character's tail:", "Character Preference") as null|anything in GLOB.xeno_tail_list
					if(new_tail)
						features["xenotail"] = new_tail
						if(new_tail != "None")
							features["mam_tail"] = "None"
							features["taur"] = "None"
							features["tail_human"] = "None"
							features["tail_lizard"] = "None"

				if("xenodorsal")
					var/new_dors
					new_dors = input(user, "Choose your character's dorsal tube type:", "Character Preference") as null|anything in GLOB.xeno_dorsal_list
					if(new_dors)
						features["xenodorsal"] = new_dors

				//every single primary/secondary/tertiary colouring done at once
				if("xenodorsal_primary","xenodorsal_secondary","xenodorsal_tertiary","xhead_primary","xhead_secondary","xhead_tertiary","tail_primary","tail_secondary","tail_tertiary","insect_markings_primary","insect_markings_secondary","insect_markings_tertiary","insect_fluff_primary","insect_fluff_secondary","insect_fluff_tertiary","ears_primary","ears_secondary","ears_tertiary","frills_primary","frills_secondary","frills_tertiary","ipc_antenna_primary","ipc_antenna_secondary","ipc_antenna_tertiary","taur_primary","taur_secondary","taur_tertiary","snout_primary","snout_secondary","snout_tertiary","spines_primary","spines_secondary","spines_tertiary", "mam_body_markings_primary", "mam_body_markings_secondary", "mam_body_markings_tertiary")
					var/the_feature = features[href_list["preference"]]
					if(!the_feature)
						features[href_list["preference"]] = "FFFFFF"
						the_feature = "FFFFFF"
					var/new_feature_color = input(user, "Choose your character's mutant part colour:", "Character Preference","#"+features[href_list["preference"]]) as color|null
					if(new_feature_color)
						var/temp_hsv = RGBtoHSV(new_feature_color)
						if(new_feature_color == "#000000")
							features[href_list["preference"]] = pref_species.default_color
						else if(ReadHSV(temp_hsv)[3] >= ReadHSV(MINIMUM_MUTANT_COLOR)[3])
							features[href_list["preference"]] = sanitize_hexcolor(new_feature_color, 6)
						else
							to_chat(user,"<span class='danger'>Invalid color. Your color is not bright enough.</span>")


				//advanced color mode toggle
				if("color_scheme")
					if(features["color_scheme"] == ADVANCED_CHARACTER_COLORING)
						features["color_scheme"] = OLD_CHARACTER_COLORING
					else
						features["color_scheme"] = ADVANCED_CHARACTER_COLORING



				if("bag")
					var/new_backbag = input(user, "Choose your character's style of bag:", "Character Preference")  as null|anything in GLOB.backbaglist
					if(new_backbag)
						backbag = new_backbag

				if("suit")
					if(jumpsuit_style == PREF_SUIT)
						jumpsuit_style = PREF_SKIRT
					else
						jumpsuit_style = PREF_SUIT
				if("gender")
					var/chosengender = input(user, "Select your character's gender.", "Gender Selection", gender) as null|anything in list(MALE,FEMALE,"nonbinary","object")
					if(!chosengender)
						return
					switch(chosengender)
						if("nonbinary")
							chosengender = PLURAL
							features["body_model"] = pick(MALE, FEMALE)
						if("object")
							chosengender = NEUTER
							features["body_model"] = MALE
						else
							features["body_model"] = chosengender
					gender = chosengender

				if("body_size")
					var/new_body_size = input(user, "Choose your desired sprite size: (90-125%)\nWarning: This may make your character look distorted. Additionally, any size under 100% takes a 10% maximum health penalty", "Character Preference", features["body_size"]*100) as num|null
					if(new_body_size)
						features["body_size"] = clamp(new_body_size * 0.01, CONFIG_GET(number/body_size_min), CONFIG_GET(number/body_size_max))

				if("bodysprite")
					var/selected_body_sprite = input(user, "Choose your desired body sprite", "Character Preference") as null|anything in pref_species.allowed_limb_ids
					if(selected_body_sprite)
						chosen_limb_id = selected_body_sprite //this gets sanitized before loading

				if("marking_down")
					// move the specified marking down
					var/index = text2num(href_list["marking_index"])
					var/marking_type = href_list["marking_type"]
					if(index && marking_type && features[marking_type] && index != length(features[marking_type]))
						var/index_down = index + 1
						var/markings = features[marking_type]
						var/first_marking = markings[index]
						var/second_marking = markings[index_down]
						markings[index] = second_marking
						markings[index_down] = first_marking

				if("marking_up")
					// move the specified marking up
					var/index = text2num(href_list["marking_index"])
					var/marking_type = href_list["marking_type"]
					if(index && marking_type && features[marking_type] && index != 1)
						var/index_up = index - 1
						var/markings = features[marking_type]
						var/first_marking = markings[index]
						var/second_marking = markings[index_up]
						markings[index] = second_marking
						markings[index_up] = first_marking

				if("marking_remove")
					// move the specified marking up
					var/index = text2num(href_list["marking_index"])
					var/marking_type = href_list["marking_type"]
					if(index && marking_type && features[marking_type])
						// because linters are just absolutely awful:
						var/list/L = features[marking_type]
						L.Cut(index, index + 1)

				if("marking_add")
					// add a marking
					var/marking_type = href_list["marking_type"]
					if(marking_type && features[marking_type])
						var/selected_limb = input(user, "Choose the limb to apply to.", "Character Preference") as null|anything in list("Head", "Chest", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "All")
						if(selected_limb)
							var/list/marking_list = GLOB.mam_body_markings_list
							var/list/snowflake_markings_list = list()
							for(var/path in marking_list)
								var/datum/sprite_accessory/S = marking_list[path]
								if(istype(S))
									if(istype(S, /datum/sprite_accessory/mam_body_markings))
										var/datum/sprite_accessory/mam_body_markings/marking = S
										if(!(selected_limb in marking.covered_limbs) && selected_limb != "All")
											continue

									if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(user.client.ckey)))
										snowflake_markings_list[S.name] = path

							var/selected_marking = input(user, "Select the marking to apply to the limb.") as null|anything in snowflake_markings_list
							if(selected_marking)
								if(selected_limb != "All")
									var/limb_value = text2num(GLOB.bodypart_values[selected_limb])
									features[marking_type] += list(list(limb_value, selected_marking))
								else
									var/datum/sprite_accessory/mam_body_markings/S = marking_list[selected_marking]
									for(var/limb in S.covered_limbs)
										var/limb_value = text2num(GLOB.bodypart_values[limb])
										features[marking_type] += list(list(limb_value, selected_marking))

				if("marking_color")
					var/index = text2num(href_list["marking_index"])
					var/marking_type = href_list["marking_type"]
					if(index && marking_type && features[marking_type])
						// work out the input options to show the user
						var/list/options = list("Primary")
						var/number_colors = text2num(href_list["number_colors"])
						var/color_number = 1 // 1-3 which color are we editing
						if(number_colors >= 2)
							options += "Secondary"
						if(number_colors == 3)
							options += "Tertiary"
						var/color_option = input(user, "Select the colour you wish to edit") as null|anything in options
						if(color_option)
							if(color_option == "Secondary") color_number = 2
							if(color_option == "Tertiary") color_number = 3
							// perform some magic on the color number
							var/list/marking_list = features[marking_type][index]
							var/datum/sprite_accessory/mam_body_markings/S = GLOB.mam_body_markings_list[marking_list[2]]
							var/matrixed_sections = S.covered_limbs[GLOB.bodypart_names[num2text(marking_list[1])]]
							if(color_number == 1)
								switch(matrixed_sections)
									if(MATRIX_GREEN)
										color_number = 2
									if(MATRIX_BLUE)
										color_number = 3
							else if(color_number == 2)
								switch(matrixed_sections)
									if(MATRIX_RED_BLUE)
										color_number = 3
									if(MATRIX_GREEN_BLUE)
										color_number = 3

							var/color_list = features[marking_type][index][3]
							var/new_marking_color = input(user, "Choose your character's marking color:", "Character Preference","#"+color_list[color_number]) as color|null
							if(new_marking_color)
								var/temp_hsv = RGBtoHSV(new_marking_color)
								if((MUTCOLORS_PARTSONLY in pref_species.species_traits) || ReadHSV(temp_hsv)[3] >= ReadHSV(MINIMUM_MUTANT_COLOR)[3]) // mutantcolors must be bright, but only if they affect the skin
									color_list[color_number] = "#[sanitize_hexcolor(new_marking_color, 6)]"
								else
									to_chat(user, "<span class='danger'>Invalid color. Your color is not bright enough.</span>")
		else
			switch(href_list["preference"])



				//END CITADEL EDIT

				if("body_model")
					features["body_model"] = features["body_model"] == MALE ? FEMALE : MALE




				if("all")
					be_random_body = !be_random_body


				if("persistent_scars")
					persistent_scars = !persistent_scars

				if("clear_scars")
					to_chat(user, "<span class='notice'>All scar slots cleared. Please save character to confirm.</span>")
					scars_list["1"] = ""
					scars_list["2"] = ""
					scars_list["3"] = ""
					scars_list["4"] = ""
					scars_list["5"] = ""

	if(be_random_name)
		real_name = pref_species.random_name(gender)

	if(be_random_body)
		random_character(gender)

	if(roundstart_checks)
		if(CONFIG_GET(flag/humans_need_surnames) && (pref_species.id == "human"))
			var/firstspace = findtext(real_name, " ")
			var/name_length = length(real_name)
			if(!firstspace)	//we need a surname
				real_name += " [pick(GLOB.last_names)]"
			else if(firstspace == name_length)
				real_name += "[pick(GLOB.last_names)]"

	//reset size if applicable
	if(character.dna.features["body_size"])
		var/initial_old_size = character.dna.features["body_size"]
		character.dna.features["body_size"] = RESIZE_DEFAULT_SIZE
		character.dna.update_body_size(initial_old_size)

	character.real_name = nameless ? "[real_name] #[rand(10000, 99999)]" : real_name
	character.name = character.real_name
	character.nameless = nameless
	character.custom_species = custom_species

	character.gender = gender
	character.age = age

	character.left_eye_color = left_eye_color
	character.right_eye_color = right_eye_color
	var/obj/item/organ/eyes/organ_eyes = character.getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		if(!initial(organ_eyes.left_eye_color))
			organ_eyes.left_eye_color = left_eye_color
			organ_eyes.right_eye_color = right_eye_color
		organ_eyes.old_left_eye_color = left_eye_color
		organ_eyes.old_right_eye_color = right_eye_color
	character.hair_color = hair_color
	character.facial_hair_color = facial_hair_color
	character.skin_tone = skin_tone
	character.dna.skin_tone_override = use_custom_skin_tone ? skin_tone : null
	character.hair_style = hair_style
	character.facial_hair_style = facial_hair_style
	character.underwear = underwear

	character.saved_underwear = underwear
	character.undershirt = undershirt
	character.saved_undershirt = undershirt
	character.socks = socks
	character.saved_socks = socks
	character.undie_color = undie_color
	character.shirt_color = shirt_color
	character.socks_color = socks_color

	var/datum/species/chosen_species
	if(!roundstart_checks || (pref_species.id in GLOB.roundstart_races))
		chosen_species = pref_species.type
	else
		chosen_species = /datum/species/human
		pref_species = new /datum/species/human
		save_character()

	character.dna.features = features.Copy()
	character.set_species(chosen_species, icon_update = FALSE, pref_load = TRUE)
	character.dna.species.eye_type = eye_type
	if(chosen_limb_id && (chosen_limb_id in character.dna.species.allowed_limb_ids))
		character.dna.species.mutant_bodyparts["limbs_id"] = chosen_limb_id
	character.dna.real_name = character.real_name
	character.dna.nameless = character.nameless
	character.dna.custom_species = character.custom_species

	var/old_size = RESIZE_DEFAULT_SIZE
	if(isdwarf(character))
		character.dna.features["body_size"] = RESIZE_DEFAULT_SIZE

	if((parent && parent.can_have_part("meat_type")) || pref_species.mutant_bodyparts["meat_type"])
		character.type_of_meat = GLOB.meat_types[features["meat_type"]]

	if(((parent && parent.can_have_part("legs")) || pref_species.mutant_bodyparts["legs"])  && (character.dna.features["legs"] == "Digitigrade" || character.dna.features["legs"] == "Avian"))
		pref_species.species_traits |= DIGITIGRADE
	else
		pref_species.species_traits -= DIGITIGRADE

	if(DIGITIGRADE in pref_species.species_traits)
		character.Digitigrade_Leg_Swap(FALSE)
	else
		character.Digitigrade_Leg_Swap(TRUE)

	character.dna.update_body_size(old_size)

	//limb stuff, only done when initially spawning in
	if(initial_spawn)
		//delete any existing prosthetic limbs to make sure no remnant prosthetics are left over - But DO NOT delete those that are species-related
		for(var/obj/item/bodypart/part in character.bodyparts)
			if(part.is_robotic_limb(FALSE))
				qdel(part)
		character.regenerate_limbs() //regenerate limbs so now you only have normal limbs
		for(var/modified_limb in modified_limbs)
			var/modification = modified_limbs[modified_limb][1]
			var/obj/item/bodypart/old_part = character.get_bodypart(modified_limb)
			if(modification == LOADOUT_LIMB_PROSTHETIC)
				var/obj/item/bodypart/new_limb
				switch(modified_limb)
					if(BODY_ZONE_L_ARM)
						new_limb = new/obj/item/bodypart/l_arm/robot/surplus(character)
					if(BODY_ZONE_R_ARM)
						new_limb = new/obj/item/bodypart/r_arm/robot/surplus(character)
					if(BODY_ZONE_L_LEG)
						new_limb = new/obj/item/bodypart/l_leg/robot/surplus(character)
					if(BODY_ZONE_R_LEG)
						new_limb = new/obj/item/bodypart/r_leg/robot/surplus(character)
				var/prosthetic_type = modified_limbs[modified_limb][2]
				if(prosthetic_type != "prosthetic") //lets just leave the old sprites as they are
					new_limb.icon = file("icons/mob/augmentation/cosmetic_prosthetic/[prosthetic_type].dmi")
				new_limb.replace_limb(character)
			qdel(old_part)

	SEND_SIGNAL(character, COMSIG_HUMAN_PREFS_COPIED_TO, src, icon_updates, roundstart_checks)

	//let's be sure the character updates
	if(icon_updates)
		character.update_body()
		character.update_hair()

/datum/preferences/proc/post_copy_to(mob/living/carbon/human/character)
	//if no legs, and not a paraplegic or a slime, give them a free wheelchair
	if(modified_limbs[BODY_ZONE_L_LEG] == LOADOUT_LIMB_AMPUTATED && modified_limbs[BODY_ZONE_R_LEG] == LOADOUT_LIMB_AMPUTATED && !character.has_quirk(/datum/quirk/paraplegic) && !isjellyperson(character))
		if(character.buckled)
			character.buckled.unbuckle_mob(character)
		var/turf/T = get_turf(character)
		var/obj/structure/chair/spawn_chair = locate() in T
		var/obj/vehicle/ridden/wheelchair/wheels = new(T)
		if(spawn_chair) // Makes spawning on the arrivals shuttle more consistent looking
			wheels.setDir(spawn_chair.dir)
		wheels.buckle_mob(character)
