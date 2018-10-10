#define DEFAULT_SLOT_AMT	2
#define HANDS_SLOT_AMT		2
#define BACKPACK_SLOT_AMT	4

/datum/preferences
	//gear
	var/gear_points = 10
	var/list/gear_categories
	var/list/chosen_gear
	var/gear_tab

	//pref vars
	var/screenshake = 100
	var/damagescreenshake = 2
	var/arousable = TRUE
	var/widescreenpref = TRUE
	var/autostand = TRUE

	//vore prefs
	var/toggleeatingnoise = TRUE
	var/toggledigestionnoise = TRUE
	var/hound_sleeper = TRUE
	var/cit_toggles = TOGGLES_CITADEL

	// stuff that was in base
	max_save_slots = 10
	features = list("mcolor" = "FFF",
		"tail_lizard" = "Smooth",
		"tail_human" = "None",
		"snout" = "Round",
		"horns" = "None",
		"ears" = "None",
		"wings" = "None",
		"frills" = "None",
		"spines" = "None",
		"body_markings" = "None",
		"legs" = "Normal Legs",
		"moth_wings" = "Plain",
		"mcolor2" = "FFF",
		"mcolor3" = "FFF",
		"mam_body_markings" = "None",
		"mam_ears" = "None",
		"mam_tail" = "None",
		"mam_tail_animated" = "None",
		"xenodorsal" = "Standard",
		"xenohead" = "Standard",
		"xenotail" = "Xenomorph Tail",
		"taur" = "None",
		"exhibitionist" = FALSE,
		"genitals_use_skintone" = FALSE,
		"has_cock" = FALSE,
		"cock_shape" = "Human",
		"cock_length" = 6,
		"cock_girth_ratio" = COCK_GIRTH_RATIO_DEF,
		"cock_color" = "fff",
		"has_sheath" = FALSE,
		"sheath_color" = "fff",
		"has_balls" = FALSE,
		"balls_internal" = FALSE,
		"balls_color" = "fff",
		"balls_amount" = 2,
		"balls_sack_size" = BALLS_SACK_SIZE_DEF,
		"balls_size" = BALLS_SIZE_DEF,
		"balls_cum_rate" = CUM_RATE,
		"balls_cum_mult" = CUM_RATE_MULT,
		"balls_efficiency" = CUM_EFFICIENCY,
		"balls_fluid" = "semen",
		"has_ovi" = FALSE,
		"ovi_shape" = "knotted",
		"ovi_length" = 6,
		"ovi_color" = "fff",
		"has_eggsack" = FALSE,
		"eggsack_internal" = TRUE,
		"eggsack_color" = "fff",
		"eggsack_size" = BALLS_SACK_SIZE_DEF,
		"eggsack_egg_color" = "fff",
		"eggsack_egg_size" = EGG_GIRTH_DEF,
		"has_breasts" = FALSE,
		"breasts_color" = "fff",
		"breasts_size" = "C",
		"breasts_shape" = "Pair",
		"breasts_fluid" = "milk",
		"has_vag" = FALSE,
		"vag_shape" = "Human",
		"vag_color" = "fff",
		"vag_clits" = 1,
		"vag_clit_diam" = 0.25,
		"has_womb" = FALSE,
		"womb_cum_rate" = CUM_RATE,
		"womb_cum_mult" = CUM_RATE_MULT,
		"womb_efficiency" = CUM_EFFICIENCY,
		"womb_fluid" = "femcum",
		"ipc_screen" = "Sunburst",
		"ipc_antenna" = "None",
		"flavor_text" = ""
		)

/datum/preferences/New(client/C)
	..()
	LAZYINITLIST(chosen_gear)

/datum/preferences/proc/is_loadout_slot_available(slot)
	var/list/L
	LAZYINITLIST(L)
	for(var/i in chosen_gear)
		var/datum/gear/G = i
		var/occupied_slots = L[slot_to_string(initial(G.category))] ? L[slot_to_string(initial(G.category))] + 1 : 1
		LAZYSET(L, slot_to_string(initial(G.category)), occupied_slots)
	switch(slot)
		if(SLOT_IN_BACKPACK)
			if(L[slot_to_string(SLOT_IN_BACKPACK)] < BACKPACK_SLOT_AMT)
				return TRUE
		if(SLOT_HANDS)
			if(L[slot_to_string(SLOT_HANDS)] < HANDS_SLOT_AMT)
				return TRUE
		else
			if(L[slot_to_string(slot)] < DEFAULT_SLOT_AMT)
				return TRUE

datum/preferences/copy_to(mob/living/carbon/human/character, icon_updates = 1)
	..()
	character.give_genitals(TRUE)
	character.flavor_text = features["flavor_text"] //Let's update their flavor_text at least initially
	character.canbearoused = arousable
	if(icon_updates)
		character.update_genitals()
