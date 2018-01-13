#define DEFAULT_SLOT_AMT	1
#define HANDS_SLOT_AMT		2
#define BACKPACK_SLOT_AMT	3

/datum/preferences
	var/gear_points = 5
	var/list/gear_categories
	var/list/chosen_gear
	var/gear_tab

/datum/preferences/New(client/C)
	..()
	LAZYINITLIST(chosen_gear)



/datum/preferences/proc/hippie_dat_replace(current_tab)
	//This proc is for menus other than game pref and char pref
	. = "<center>"

	. += "<a href='?_src_=prefs;preference=tab;tab=0' [current_tab == 0 ? "class='linkOn'" : ""]>Character Settings</a> "
	. += "<a href='?_src_=prefs;preference=tab;tab=1' [current_tab == 1 ? "class='linkOn'" : ""]>Game Preferences</a>"
	. += "<a href='?_src_=prefs;preference=tab;tab=2' [current_tab == 2 ? "class='linkOn'" : ""]>Loadout</a>"

	if(!path)
		. += "<div class='notice'>Please create an account to save your preferences</div>"

	. += "</center>"

	. += "<HR>"
	if(current_tab == 2)
		if(!gear_tab)
			gear_tab = GLOB.loadout_items[1]
		. += "<table align='center' width='100%'>"
		. += "<tr><td colspan=4><center><b><font color='[gear_points == 0 ? "#E67300" : "#3366CC"]'>[gear_points]</font> loadout points remaining.</b> \[<a href='?_src_=prefs;preference=gear;clear_loadout=1'>Clear Loadout</a>\]</center></td></tr>"
		. += "<tr><td colspan=4><center>You can only choose one item per category, unless it's an item that spawns in your backpack or hands.</center></td></tr>"
		. += "<tr><td colspan=4><center><b>"
		var/firstcat = TRUE
		for(var/i in GLOB.loadout_items)
			if(firstcat)
				firstcat = FALSE
			else
				. += " |"
			if(i == gear_tab)
				. += " <span class='linkOn'>[i]</span> "
			else
				. += " <a href='?_src_=prefs;preference=gear;select_category=[i]'>[i]</a> "
		. += "</b></center></td></tr>"
		. += "<tr><td colspan=4><hr></td></tr>"
		. += "<tr><td colspan=4><b><center>[gear_tab]</center></b></td></tr>"
		. += "<tr><td colspan=4><hr></td></tr>"
		. += "<tr style='vertical-align:top;'><td width=15%><b>Name</b></td>"
		. += "<td width=5% style='vertical-align:top'><b>Cost</b></td>"
		. += "<td><font size=2><b>Restrictions</b></font></td>"
		. += "<td><font size=2><b>Description</b></font></td></tr>"
		for(var/j in GLOB.loadout_items[gear_tab])
			var/datum/gear/gear = GLOB.loadout_items[gear_tab][j]
			var/class_link = ""
			if(gear.type in chosen_gear)
				class_link = "class='linkOn' href='?_src_=prefs;preference=gear;toggle_gear_path=[j];toggle_gear=0'"
			else if(gear_points <= 0)
				class_link = "class='linkOff'"
			else
				class_link = "href='?_src_=prefs;preference=gear;toggle_gear_path=[j];toggle_gear=1'"
			. += "<tr style='vertical-align:top;'><td width=15%><a style='white-space:normal;' [class_link]>[j]</a></td>"
			. += "<td width = 5% style='vertical-align:top'>[gear.cost]</td><td>"
			if(islist(gear.restricted_roles))
				if(gear.restricted_roles.len)
					. += "<font size=2>"
					. += gear.restricted_roles.Join(";")
					. += "</font>"
			. += "</td><td><font size=2><i>[gear.description]</i></font></td></tr>"
		. += "</table>"

/datum/preferences/proc/is_loadout_slot_available(slot)
	var/list/L
	LAZYINITLIST(L)
	for(var/i in chosen_gear)
		var/datum/gear/G = i
		var/occupied_slots = L[slot_to_string(initial(G.category))] ? L[slot_to_string(initial(G.category))] + 1 : 1
		LAZYSET(L, slot_to_string(initial(G.category)), occupied_slots)
	switch(slot)
		if(slot_in_backpack)
			if(L[slot_to_string(slot_in_backpack)] < BACKPACK_SLOT_AMT)
				return TRUE
		if(slot_hands)
			if(L[slot_to_string(slot_hands)] < HANDS_SLOT_AMT)
				return TRUE
		else
			if(L[slot_to_string(slot)] < DEFAULT_SLOT_AMT)
				return TRUE
