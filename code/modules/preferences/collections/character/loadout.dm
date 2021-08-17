/datum/preferences_collection/character/loadout
	save_key = PREFERENCES_SAVE_KEY_LOADOUT
	sort_order = 8
	preview_mode = PREFERENCES_PREVIEW_MODE_LOADOUT_ONLY

/datum/preferences_collection/character/loadout/content(datum/preferences/prefs)
	. = ..()

/datum/preferences_collection/character/loadout/copy_to_mob(datum/preferences/prefs, mob/M, flags)
	. = ..()

/datum/preferences_collection/character/loadout/savefile_full_overhaul_character(datum/preferences/prefs, list/data, savefile/S, list/errors, current_version)
	. = ..()

/datum/preferences_collection/character/loadout/sanitize_character(datum/preferences/prefs)
	. = ..()

/datum/preferences_collection/character/loadout/OnTopic(mob/user, datum/preferences/prefs, list/href_list)
	. = ..()




			//calculate your gear points from the chosen item
			gear_points = CONFIG_GET(number/initial_gear_points)
			var/list/chosen_gear = loadout_data["SAVE_[loadout_slot]"]
			if(chosen_gear)
				for(var/loadout_item in chosen_gear)
					var/loadout_item_path = loadout_item[LOADOUT_ITEM]
					if(loadout_item_path)
						var/datum/gear/loadout_gear = text2path(loadout_item_path)
						if(loadout_gear)
							gear_points -= initial(loadout_gear.cost)
			else
				chosen_gear = list()

			dat += "<table align='center' width='100%'>"
			dat += "<tr><td colspan=4><center><b><font color='[gear_points == 0 ? "#E62100" : "#CCDDFF"]'>[gear_points]</font> loadout points remaining.</b> \[<a href='?_src_=prefs;preference=gear;clear_loadout=1'>Clear Loadout</a>\]</center></td></tr>"
			dat += "<tr><td colspan=4><center>You can only choose one item per category, unless it's an item that spawns in your backpack or hands.</center></td></tr>"
			dat += "<tr><td colspan=4><center><b>"

			if(!length(GLOB.loadout_items))
				dat += "<center>ERROR: No loadout categories - something is horribly wrong!"
			else
				if(!GLOB.loadout_categories[gear_category])
					gear_category = GLOB.loadout_categories[1]
				var/firstcat = TRUE
				for(var/category in GLOB.loadout_categories)
					if(firstcat)
						firstcat = FALSE
					else
						dat += " |"
					if(category == gear_category)
						dat += " <span class='linkOn'>[category]</span> "
					else
						dat += " <a href='?_src_=prefs;preference=gear;select_category=[html_encode(category)]'>[category]</a> "

				dat += "</b></center></td></tr>"
				dat += "<tr><td colspan=4><hr></td></tr>"

				dat += "<tr><td colspan=4><center><b>"

				if(!length(GLOB.loadout_categories[gear_category]))
					dat += "No subcategories detected. Something is horribly wrong!"
				else
					var/list/subcategories = GLOB.loadout_categories[gear_category]
					if(!subcategories.Find(gear_subcategory))
						gear_subcategory = subcategories[1]

					var/firstsubcat = TRUE
					for(var/subcategory in subcategories)
						if(firstsubcat)
							firstsubcat = FALSE
						else
							dat += " |"
						if(gear_subcategory == subcategory)
							dat += " <span class='linkOn'>[subcategory]</span> "
						else
							dat += " <a href='?_src_=prefs;preference=gear;select_subcategory=[html_encode(subcategory)]'>[subcategory]</a> "
					dat += "</b></center></td></tr>"

					dat += "<tr width=10% style='vertical-align:top;'><td width=15%><b>Name</b></td>"
					dat += "<td style='vertical-align:top'><b>Cost</b></td>"
					dat += "<td width=10%><font size=2><b>Restrictions</b></font></td>"
					dat += "<td width=80%><font size=2><b>Description</b></font></td></tr>"
					for(var/name in GLOB.loadout_items[gear_category][gear_subcategory])
						var/datum/gear/gear = GLOB.loadout_items[gear_category][gear_subcategory][name]
						var/donoritem = gear.donoritem
						if(donoritem && !gear.donator_ckey_check(user.ckey))
							continue
						var/class_link = ""
						var/list/loadout_item = has_loadout_gear(loadout_slot, "[gear.type]")
						var/extra_loadout_data = ""
						if(loadout_item)
							class_link = "style='white-space:normal;' class='linkOn' href='?_src_=prefs;preference=gear;toggle_gear_path=[html_encode(name)];toggle_gear=0'"
							if(gear.loadout_flags & LOADOUT_CAN_COLOR_POLYCHROMIC)
								extra_loadout_data += "<BR><a href='?_src_=prefs;preference=gear;loadout_color_polychromic=1;loadout_gear_name=[html_encode(gear.name)];'>Color</a>"
								for(var/loadout_color in loadout_item[LOADOUT_COLOR])
									extra_loadout_data += "<span style='border: 1px solid #161616; background-color: [loadout_color];'>&nbsp;&nbsp;&nbsp;</span>"
							else
								var/loadout_color_non_poly = "#FFFFFF"
								if(length(loadout_item[LOADOUT_COLOR]))
									loadout_color_non_poly = loadout_item[LOADOUT_COLOR][1]
								extra_loadout_data += "<BR><a href='?_src_=prefs;preference=gear;loadout_color=1;loadout_gear_name=[html_encode(gear.name)];'>Color</a>"
								extra_loadout_data += "<span style='border: 1px solid #161616; background-color: [loadout_color_non_poly];'>&nbsp;&nbsp;&nbsp;</span>"
							if(gear.loadout_flags & LOADOUT_CAN_NAME)
								extra_loadout_data += "<BR><a href='?_src_=prefs;preference=gear;loadout_rename=1;loadout_gear_name=[html_encode(gear.name)];'>Name</a> [loadout_item[LOADOUT_CUSTOM_NAME] ? loadout_item[LOADOUT_CUSTOM_NAME] : "N/A"]"
							if(gear.loadout_flags & LOADOUT_CAN_DESCRIPTION)
								extra_loadout_data += "<BR><a href='?_src_=prefs;preference=gear;loadout_redescribe=1;loadout_gear_name=[html_encode(gear.name)];'>Description</a>"
						else if((gear_points - gear.cost) < 0)
							class_link = "style='white-space:normal;' class='linkOff'"
						else if(donoritem)
							class_link = "style='white-space:normal;background:#ebc42e;' href='?_src_=prefs;preference=gear;toggle_gear_path=[html_encode(name)];toggle_gear=1'"
						else if(!istype(gear, /datum/gear/unlockable) || can_use_unlockable(gear))
							class_link = "style='white-space:normal;' href='?_src_=prefs;preference=gear;toggle_gear_path=[html_encode(name)];toggle_gear=1'"
						else
							class_link = "style='white-space:normal;background:#eb2e2e;' class='linkOff'"
						dat += "<tr style='vertical-align:top;'><td width=15%><a [class_link]>[name]</a>[extra_loadout_data]</td>"
						dat += "<td width = 5% style='vertical-align:top'>[gear.cost]</td><td>"
						if(islist(gear.restricted_roles))
							if(gear.restricted_roles.len)
								if(gear.restricted_desc)
									dat += "<font size=2>"
									dat += gear.restricted_desc
									dat += "</font>"
								else
									dat += "<font size=2>"
									dat += gear.restricted_roles.Join(";")
									dat += "</font>"
						if(!istype(gear, /datum/gear/unlockable))
							// the below line essentially means "if the loadout item is picked by the user and has a custom description, give it the custom description, otherwise give it the default description"
							dat += "</td><td><font size=2><i>[loadout_item ? (loadout_item[LOADOUT_CUSTOM_DESCRIPTION] ? loadout_item[LOADOUT_CUSTOM_DESCRIPTION] : gear.description) : gear.description]</i></font></td></tr>"
						else
							//we add the user's progress to the description assuming they have progress
							var/datum/gear/unlockable/unlockable = gear
							var/progress_made = unlockable_loadout_data[unlockable.progress_key]
							if(!progress_made)
								progress_made = 0
							dat += "</td><td><font size=2><i>[loadout_item ? (loadout_item[LOADOUT_CUSTOM_DESCRIPTION] ? loadout_item[LOADOUT_CUSTOM_DESCRIPTION] : gear.description) : gear.description] Progress: [min(progress_made, unlockable.progress_required)]/[unlockable.progress_required]</i></font></td></tr>"

					dat += "</table>"




	if(href_list["preference"] == "gear")
		if(href_list["clear_loadout"])
			loadout_data["SAVE_[loadout_slot]"] = list()
			save_preferences()
		if(href_list["select_category"])
			gear_category = html_decode(href_list["select_category"])
			gear_subcategory = GLOB.loadout_categories[gear_category][1]
		if(href_list["select_subcategory"])
			gear_subcategory = html_decode(href_list["select_subcategory"])
		if(href_list["toggle_gear_path"])
			var/name = html_decode(href_list["toggle_gear_path"])
			var/datum/gear/G = GLOB.loadout_items[gear_category][gear_subcategory][name]
			if(!G)
				return
			var/toggle = text2num(href_list["toggle_gear"])
			if(!toggle && has_loadout_gear(loadout_slot, "[G.type]"))//toggling off and the item effectively is in chosen gear)
				remove_gear_from_loadout(loadout_slot, "[G.type]")
			else if(toggle && !(has_loadout_gear(loadout_slot, "[G.type]")))
				if(!is_loadout_slot_available(G.category))
					to_chat(user, "<span class='danger'>You cannot take this loadout, as you've already chosen too many of the same category!</span>")
					return
				if(G.donoritem && !G.donator_ckey_check(user.ckey))
					to_chat(user, "<span class='danger'>This is an item intended for donator use only. You are not authorized to use this item.</span>")
					return
				if(istype(G, /datum/gear/unlockable) && !can_use_unlockable(G))
					to_chat(user, "<span class='danger'>To use this item, you need to meet the defined requirements!</span>")
					return
				if(gear_points >= initial(G.cost))
					var/list/new_loadout_data = list(LOADOUT_ITEM = "[G.type]")
					if(length(G.loadout_initial_colors))
						new_loadout_data[LOADOUT_COLOR] = G.loadout_initial_colors
					else
						new_loadout_data[LOADOUT_COLOR] = list("#FFFFFF")
					if(loadout_data["SAVE_[loadout_slot]"])
						loadout_data["SAVE_[loadout_slot]"] += list(new_loadout_data) //double packed because it does the union of the CONTENTS of the lists
					else
						loadout_data["SAVE_[loadout_slot]"] = list(new_loadout_data) //double packed because you somehow had no save slot in your loadout?

		if(href_list["loadout_color"] || href_list["loadout_color_polychromic"] || href_list["loadout_rename"] || href_list["loadout_redescribe"])
			//if the gear doesn't exist, or they don't have it, ignore the request
			var/name = html_decode(href_list["loadout_gear_name"])
			var/datum/gear/G = GLOB.loadout_items[gear_category][gear_subcategory][name]
			if(!G)
				return
			var/user_gear = has_loadout_gear(loadout_slot, "[G.type]")
			if(!user_gear)
				return

			//possible requests: recolor, recolor (polychromic), rename, redescribe
			//always make sure the gear allows said request before proceeding

			//non-poly coloring can only be done by non-poly items
			if(href_list["loadout_color"] && !(G.loadout_flags & LOADOUT_CAN_COLOR_POLYCHROMIC))
				if(!length(user_gear[LOADOUT_COLOR]))
					user_gear[LOADOUT_COLOR] = list("#FFFFFF")
				var/current_color = user_gear[LOADOUT_COLOR][1]
				var/new_color = input(user, "Polychromic options", "Choose Color", current_color) as color|null
				user_gear[LOADOUT_COLOR][1] = sanitize_hexcolor(new_color, 6, TRUE, current_color)

			//poly coloring can only be done by poly items
			if(href_list["loadout_color_polychromic"] && (G.loadout_flags & LOADOUT_CAN_COLOR_POLYCHROMIC))
				var/list/color_options = list()
				for(var/i=1, i<=length(G.loadout_initial_colors), i++)
					color_options += "Color [i]"
				var/color_to_change = input(user, "Polychromic options", "Recolor [name]") as null|anything in color_options
				if(color_to_change)
					var/color_index = text2num(copytext(color_to_change, 7))
					var/current_color = user_gear[LOADOUT_COLOR][color_index]
					var/new_color = input(user, "Polychromic options", "Choose [color_to_change] Color", current_color) as color|null
					if(new_color)
						user_gear[LOADOUT_COLOR][color_index] = sanitize_hexcolor(new_color, 6, TRUE, current_color)

			//both renaming and redescribing strip the input to stop html injection

			//renaming is only allowed if it has the flag for it
			if(href_list["loadout_rename"] && (G.loadout_flags & LOADOUT_CAN_NAME))
				var/new_name = stripped_input(user, "Enter new name for item. Maximum [MAX_NAME_LEN] characters.", "Loadout Item Naming", null,  MAX_NAME_LEN)
				if(new_name)
					user_gear[LOADOUT_CUSTOM_NAME] = new_name

			//redescribing is only allowed if it has the flag for it
			if(href_list["loadout_redescribe"] && (G.loadout_flags & LOADOUT_CAN_DESCRIPTION)) //redescribe isnt a real word but i can't think of the right term to use
				var/new_description = stripped_input(user, "Enter new description for item. Maximum 500 characters.", "Loadout Item Redescribing", null, 500)
				if(new_description)
					user_gear[LOADOUT_CUSTOM_DESCRIPTION] = new_description


/datum/preferences/proc/is_loadout_slot_available(slot)
	var/list/L
	LAZYINITLIST(L)
	for(var/i in loadout_data["SAVE_[loadout_slot]"])
		var/datum/gear/G = i[LOADOUT_ITEM]
		var/occupied_slots = L[initial(G.category)] ? L[initial(G.category)] + 1 : 1
		LAZYSET(L, initial(G.category), occupied_slots)
	switch(slot)
		if(SLOT_IN_BACKPACK)
			if(L[LOADOUT_CATEGORY_BACKPACK] < BACKPACK_SLOT_AMT)
				return TRUE
		if(SLOT_HANDS)
			if(L[LOADOUT_CATEGORY_HANDS] < HANDS_SLOT_AMT)
				return TRUE
		else
			if(L[slot] < DEFAULT_SLOT_AMT)
				return TRUE

/datum/preferences/proc/has_loadout_gear(save_slot, gear_type)
	var/list/gear_list = loadout_data["SAVE_[save_slot]"]
	for(var/loadout_gear in gear_list)
		if(loadout_gear[LOADOUT_ITEM] == gear_type)
			return loadout_gear
	return FALSE

/datum/preferences/proc/remove_gear_from_loadout(save_slot, gear_type)
	var/find_gear = has_loadout_gear(save_slot, gear_type)
	if(find_gear)
		loadout_data["SAVE_[save_slot]"] -= list(find_gear)

/datum/preferences/proc/can_use_unlockable(datum/gear/unlockable/unlockable_gear)
	if(unlockable_loadout_data[unlockable_gear.progress_key] >= unlockable_gear.progress_required)
		return TRUE
	return FALSE


		///loadout stuff
	var/gear_points = 10
	var/list/gear_categories
	var/list/loadout_data = list()
	var/list/unlockable_loadout_data = list()
	var/loadout_slot = 1 //goes from 1 to MAXIMUM_LOADOUT_SAVES
	var/gear_category
	var/gear_subcategory



	//gear loadout
	if(S["loadout"])
		loadout_data = safe_json_decode(S["loadout"])
	else
		loadout_data = list()

	if(S["unlockable_loadout"])
		unlockable_loadout_data = safe_json_decode(S["unlockable_loadout"])
	else
		unlockable_loadout_data = list()
