#define ECSTATIC_SANITY_PEN -1
#define SLIGHT_INSANITY_PEN 1
#define MINOR_INSANITY_PEN 5
#define MAJOR_INSANITY_PEN 10
#define MOOD_INSANITY_MALUS 0.13 // 13% debuff per sanity_level above the default of 4 (higher is worser), overall a 39% debuff to skills at rock bottom depression.

/datum/component/mood
	var/mood //Real happiness
	var/sanity = 100 //Current sanity
	var/shown_mood //Shown happiness, this is what others can see when they try to examine you, prevents antag checking by noticing traitors are always very happy.
	var/mood_level = 5 //To track what stage of moodies they're on
	var/sanity_level = 3 //To track what stage of sanity they're on
	var/mood_modifier = 1 //Modifier to allow certain mobs to be less affected by moodlets
	var/list/datum/mood_event/mood_events = list()
	var/insanity_effect = 0 //is the owner being punished for low mood? If so, how much?
	var/obj/screen/mood/screen_obj
	var/datum/skill_modifier/bad_mood/malus
	var/datum/skill_modifier/great_mood/bonus
	var/static/malus_id = 0
	var/static/list/free_maluses = list()

/datum/component/mood/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	var/mob/living/owner = parent
	if(owner.stat != DEAD)
		START_PROCESSING(SSobj, src)

	RegisterSignal(parent, COMSIG_ADD_MOOD_EVENT, .proc/add_event)
	RegisterSignal(parent, COMSIG_CLEAR_MOOD_EVENT, .proc/clear_event)
	RegisterSignal(parent, COMSIG_MODIFY_SANITY, .proc/modify_sanity)
	RegisterSignal(parent, COMSIG_LIVING_REVIVE, .proc/on_revive)
	RegisterSignal(parent, COMSIG_MOB_HUD_CREATED, .proc/modify_hud)
	RegisterSignal(parent, COMSIG_MOB_DEATH, .proc/stop_processing)
	RegisterSignal(parent, COMSIG_VOID_MASK_ACT, .proc/direct_sanity_drain)


	if(owner.hud_used)
		modify_hud()
		var/datum/hud/hud = owner.hud_used
		hud.show_hud(hud.hud_version)

/datum/component/mood/Destroy()
	STOP_PROCESSING(SSobj, src)
	unmodify_hud()
	return ..()

/datum/component/mood/proc/stop_processing()
	STOP_PROCESSING(SSobj, src)

/datum/component/mood/proc/print_mood(mob/user)
	var/msg = "<span class='info'>*---------*\n<EM>Your current mood</EM>\n"
	msg += "<span class='notice'>My mental status: </span>" //Long term
	switch(sanity)
		if(SANITY_GREAT to INFINITY)
			msg += "<span class='nicegreen'>My mind feels like a temple!<span>\n"
		if(SANITY_NEUTRAL to SANITY_GREAT)
			msg += "<span class='nicegreen'>I have been feeling great lately!<span>\n"
		if(SANITY_DISTURBED to SANITY_NEUTRAL)
			msg += "<span class='nicegreen'>I have felt quite decent lately.<span>\n"
		if(SANITY_UNSTABLE to SANITY_DISTURBED)
			msg += "<span class='warning'>I'm feeling a little bit unhinged...</span>\n"
		if(SANITY_CRAZY to SANITY_UNSTABLE)
			msg += "<span class='boldwarning'>I'm freaking out!!</span>\n"
		if(SANITY_INSANE to SANITY_CRAZY)
			msg += "<span class='boldwarning'>AHAHAHAHAHAHAHAHAHAH!!</span>\n"

	msg += "<span class='notice'>My current mood: </span>" //Short term
	switch(mood_level)
		if(1)
			msg += "<span class='boldwarning'>I wish I was dead!<span>\n"
		if(2)
			msg += "<span class='boldwarning'>I feel terrible...<span>\n"
		if(3)
			msg += "<span class='boldwarning'>I feel very upset.<span>\n"
		if(4)
			msg += "<span class='boldwarning'>I'm a bit sad.<span>\n"
		if(5)
			msg += "<span class='nicegreen'>I'm alright.<span>\n"
		if(6)
			msg += "<span class='nicegreen'>I feel pretty okay.<span>\n"
		if(7)
			msg += "<span class='nicegreen'>I feel pretty good.<span>\n"
		if(8)
			msg += "<span class='nicegreen'>I feel amazing!<span>\n"
		if(9)
			msg += "<span class='nicegreen'>I love life!<span>\n"

	msg += "<span class='notice'>Moodlets:\n</span>"//All moodlets
	if(mood_events.len)
		for(var/i in mood_events)
			var/datum/mood_event/event = mood_events[i]
			msg += event.description
	else
		msg += "<span class='nicegreen'>I don't have much of a reaction to anything right now.<span>\n"
	to_chat(user || parent, msg)

///Called after moodevent/s have been added/removed.
/datum/component/mood/proc/update_mood()
	mood = 0
	shown_mood = 0
	for(var/i in mood_events)
		var/datum/mood_event/event = mood_events[i]
		mood += event.mood_change
		if(!event.hidden)
			shown_mood += event.mood_change
		mood *= mood_modifier
		shown_mood *= mood_modifier

	switch(mood)
		if(-INFINITY to MOOD_LEVEL_SAD4)
			mood_level = 1
		if(MOOD_LEVEL_SAD4 to MOOD_LEVEL_SAD3)
			mood_level = 2
		if(MOOD_LEVEL_SAD3 to MOOD_LEVEL_SAD2)
			mood_level = 3
		if(MOOD_LEVEL_SAD2 to MOOD_LEVEL_SAD1)
			mood_level = 4
		if(MOOD_LEVEL_SAD1 to MOOD_LEVEL_HAPPY1)
			mood_level = 5
		if(MOOD_LEVEL_HAPPY1 to MOOD_LEVEL_HAPPY2)
			mood_level = 6
		if(MOOD_LEVEL_HAPPY2 to MOOD_LEVEL_HAPPY3)
			mood_level = 7
		if(MOOD_LEVEL_HAPPY3 to MOOD_LEVEL_HAPPY4)
			mood_level = 8
		if(MOOD_LEVEL_HAPPY4 to INFINITY)
			mood_level = 9
	update_mood_icon()


/datum/component/mood/proc/update_mood_icon()
	var/mob/living/owner = parent
	if(owner.client && owner.hud_used)
		if(sanity < 25)
			screen_obj.icon_state = "mood_insane"
		else if (owner.has_status_effect(/datum/status_effect/chem/enthrall))//Fermichem enthral chem, maybe change?
			screen_obj.icon_state = "mood_entrance"
		else
			screen_obj.icon_state = "mood[mood_level]"

/datum/component/mood/process() //Called on SSobj process
	if(QDELETED(parent)) // workaround to an obnoxious sneaky periodical runtime.
		qdel(src)
		return
	var/mob/living/owner = parent

	switch(mood_level)
		if(1)
			setSanity(sanity-0.2)
		if(2)
			setSanity(sanity-0.125, minimum=SANITY_CRAZY)
		if(3)
			setSanity(sanity-0.075, minimum=SANITY_UNSTABLE)
		if(4)
			setSanity(sanity-0.025, minimum=SANITY_DISTURBED)
		if(5)
			setSanity(sanity+0.1)
		if(6)
			setSanity(sanity+0.15)
		if(7)
			setSanity(sanity+0.20)
		if(8)
			setSanity(sanity+0.25, maximum=SANITY_GREAT)
		if(9)
			setSanity(sanity+0.4, maximum=SANITY_AMAZING)

	HandleNutrition(owner)

/datum/component/mood/proc/setSanity(amount, minimum=SANITY_INSANE, maximum=SANITY_NEUTRAL)//I'm sure bunging this in here will have no negative repercussions.
	var/mob/living/master = parent

	if(amount == sanity)
		return
	// If we're out of the acceptable minimum-maximum range move back towards it in steps of 0.5
	// If the new amount would move towards the acceptable range faster then use it instead
	if(sanity < minimum && amount < sanity + 0.5)
		amount = sanity + 0.5
	else if(sanity > maximum && amount > sanity - 0.5)
		amount = sanity - 0.5

	// Disturbed stops you from getting any more sane
	if(HAS_TRAIT(master, TRAIT_UNSTABLE))
		sanity = min(amount,sanity)
	else
		sanity = amount

	var/old_sanity_level = sanity_level
	switch(sanity)
		if(-INFINITY to SANITY_CRAZY)
			setInsanityEffect(MAJOR_INSANITY_PEN)
			master.add_movespeed_modifier(/datum/movespeed_modifier/sanity/insane)
			master.add_actionspeed_modifier(/datum/actionspeed_modifier/low_sanity)
			sanity_level = 6
		if(SANITY_CRAZY to SANITY_UNSTABLE)
			setInsanityEffect(MINOR_INSANITY_PEN)
			master.add_movespeed_modifier(/datum/movespeed_modifier/sanity/crazy)
			master.add_actionspeed_modifier(/datum/actionspeed_modifier/low_sanity)
			sanity_level = 5
		if(SANITY_UNSTABLE to SANITY_DISTURBED)
			setInsanityEffect(SLIGHT_INSANITY_PEN)
			master.add_movespeed_modifier(/datum/movespeed_modifier/sanity/disturbed)
			master.add_actionspeed_modifier(/datum/actionspeed_modifier/low_sanity)
			sanity_level = 4
		if(SANITY_DISTURBED to SANITY_NEUTRAL)
			setInsanityEffect(0)
			master.remove_movespeed_modifier(MOVESPEED_ID_SANITY)
			master.remove_actionspeed_modifier(ACTIONSPEED_ID_SANITY)
			sanity_level = 3
		if(SANITY_NEUTRAL+1 to SANITY_GREAT+1) //shitty hack but +1 to prevent it from responding to super small differences
			setInsanityEffect(0)
			master.remove_movespeed_modifier(MOVESPEED_ID_SANITY)
			master.add_actionspeed_modifier(/datum/actionspeed_modifier/high_sanity)
			sanity_level = 2
		if(SANITY_GREAT+1 to INFINITY)
			setInsanityEffect(ECSTATIC_SANITY_PEN) //It's not a penalty but w/e
			master.remove_movespeed_modifier(MOVESPEED_ID_SANITY)
			master.add_actionspeed_modifier(/datum/actionspeed_modifier/high_sanity)
			sanity_level = 1

	if(sanity_level != old_sanity_level)
		if(sanity_level >= 4)
			if(!malus)
				if(!length(free_maluses))
					ADD_SKILL_MODIFIER_BODY(/datum/skill_modifier/bad_mood, malus_id++, master, malus)
				else
					malus = pick_n_take(free_maluses)
					if(master.mind)
						master.mind.add_skill_modifier(malus.identifier)
					else
						malus.RegisterSignal(master, COMSIG_MOB_ON_NEW_MIND, /datum/skill_modifier.proc/on_mob_new_mind, TRUE)
			malus.value_mod = malus.level_mod = 1 - (sanity_level - 3) * MOOD_INSANITY_MALUS
		else if(malus)
			if(master.mind)
				master.mind.remove_skill_modifier(malus.identifier)
			else
				malus.UnregisterSignal(master, COMSIG_MOB_ON_NEW_MIND)
			free_maluses += malus
			malus = null

	//update_mood_icon()

/datum/component/mood/proc/setInsanityEffect(newval)//More code so that the previous proc works
	if(newval == insanity_effect)
		return

	var/mob/living/L = parent
	if(newval == ECSTATIC_SANITY_PEN && !bonus)
		ADD_SKILL_MODIFIER_BODY(/datum/skill_modifier/great_mood, null, L, bonus)
	else if(bonus)
		REMOVE_SKILL_MODIFIER_BODY(/datum/skill_modifier/great_mood, null, L)
		bonus = null

	insanity_effect = newval

/datum/component/mood/proc/modify_sanity(datum/source, amount, minimum = SANITY_INSANE, maximum = SANITY_AMAZING)
	setSanity(sanity + amount, minimum, maximum)

/datum/component/mood/proc/add_event(datum/source, category, type, param) //Category will override any events in the same category, should be unique unless the event is based on the same thing like hunger.
	var/datum/mood_event/the_event
	if(mood_events[category])
		the_event = mood_events[category]
		if(the_event.type != type)
			clear_event(null, category)
		else
			if(the_event.timeout)
				addtimer(CALLBACK(src, .proc/clear_event, null, category), the_event.timeout, TIMER_UNIQUE|TIMER_OVERRIDE)
			return 0 //Don't have to update the event.
	the_event = new type(src, param)//This causes a runtime for some reason, was this me? No - there's an event floating around missing a definition.

	mood_events[category] = the_event
	update_mood()

	if(the_event.timeout)
		addtimer(CALLBACK(src, .proc/clear_event, null, category), the_event.timeout, TIMER_UNIQUE|TIMER_OVERRIDE)

/datum/component/mood/proc/clear_event(datum/source, category)
	var/datum/mood_event/event = mood_events[category]
	if(!event)
		return 0

	mood_events -= category
	qdel(event)
	update_mood()

/datum/component/mood/proc/remove_temp_moods() //Removes all temp moodsfor(var/i in mood_events)
	for(var/i in mood_events)
		var/datum/mood_event/moodlet = mood_events[i]
		if(!moodlet || !moodlet.timeout)
			continue
		mood_events -= i
		qdel(moodlet)
	update_mood()

/datum/component/mood/proc/modify_hud(datum/source)
	var/mob/living/owner = parent
	var/datum/hud/hud = owner.hud_used
	screen_obj = new
	hud.infodisplay += screen_obj
	RegisterSignal(hud, COMSIG_PARENT_QDELETING, .proc/unmodify_hud)
	RegisterSignal(screen_obj, COMSIG_CLICK, .proc/hud_click)

/datum/component/mood/proc/unmodify_hud(datum/source)
	if(!screen_obj || !parent)
		return
	var/mob/living/owner = parent
	var/datum/hud/hud = owner.hud_used
	if(hud && hud.infodisplay)
		hud.infodisplay -= screen_obj
	QDEL_NULL(screen_obj)

/datum/component/mood/proc/hud_click(datum/source, location, control, params, mob/user)
	print_mood(user)


/datum/component/mood/proc/HandleNutrition(mob/living/L)
	if(isethereal(L))
		HandleCharge(L)
	if(HAS_TRAIT(L, TRAIT_NOHUNGER))
		return FALSE //no mood events for nutrition
	switch(L.nutrition)
		if(NUTRITION_LEVEL_FULL to INFINITY)
			add_event(null, "nutrition", /datum/mood_event/fat)
		if(NUTRITION_LEVEL_WELL_FED to NUTRITION_LEVEL_FULL)
			add_event(null, "nutrition", /datum/mood_event/wellfed)
		if( NUTRITION_LEVEL_FED to NUTRITION_LEVEL_WELL_FED)
			add_event(null, "nutrition", /datum/mood_event/fed)
		if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FED)
			clear_event(null, "nutrition")
		if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
			add_event(null, "nutrition", /datum/mood_event/hungry)
		if(0 to NUTRITION_LEVEL_STARVING)
			add_event(null, "nutrition", /datum/mood_event/starving)

/datum/component/mood/proc/HandleCharge(mob/living/carbon/human/H)
	var/datum/species/ethereal/E = H.dna.species
	switch(E.get_charge(H))
		if(ETHEREAL_CHARGE_NONE to ETHEREAL_CHARGE_LOWPOWER)
			add_event(null, "charge", /datum/mood_event/decharged)
		if(ETHEREAL_CHARGE_LOWPOWER to ETHEREAL_CHARGE_NORMAL)
			add_event(null, "charge", /datum/mood_event/lowpower)
		if(ETHEREAL_CHARGE_NORMAL to ETHEREAL_CHARGE_ALMOSTFULL)
			clear_event(null, "charge")
		if(ETHEREAL_CHARGE_ALMOSTFULL to ETHEREAL_CHARGE_FULL)
			add_event(null, "charge", /datum/mood_event/charged)
		if(ETHEREAL_CHARGE_FULL to ETHEREAL_CHARGE_OVERLOAD)
			add_event(null, "charge", /datum/mood_event/overcharged)
		if(ETHEREAL_CHARGE_OVERLOAD to ETHEREAL_CHARGE_DANGEROUS)
			add_event(null, "charge", /datum/mood_event/supercharged)

/datum/component/mood/proc/update_beauty(area/A)
	if(A.outdoors) //if we're outside, we don't care.
		clear_event(null, "area_beauty")
		return FALSE
	if(HAS_TRAIT(parent, TRAIT_SNOB))
		switch(A.beauty)
			if(-INFINITY to BEAUTY_LEVEL_HORRID)
				add_event(null, "area_beauty", /datum/mood_event/horridroom)
				return
			if(BEAUTY_LEVEL_HORRID to BEAUTY_LEVEL_BAD)
				add_event(null, "area_beauty", /datum/mood_event/badroom)
				return
	switch(A.beauty)
		if(-INFINITY to BEAUTY_LEVEL_DECENT)
			clear_event(null, "area_beauty")
		if(BEAUTY_LEVEL_DECENT to BEAUTY_LEVEL_GOOD)
			add_event(null, "area_beauty", /datum/mood_event/decentroom)
		if(BEAUTY_LEVEL_GOOD to BEAUTY_LEVEL_GREAT)
			add_event(null, "area_beauty", /datum/mood_event/goodroom)
		if(BEAUTY_LEVEL_GREAT to INFINITY)
			add_event(null, "area_beauty", /datum/mood_event/greatroom)

///Called when parent is revived.
/datum/component/mood/proc/on_revive(datum/source, full_heal)
	START_PROCESSING(SSobj, src)
	if(!full_heal)
		return
	remove_temp_moods()
	setSanity(initial(sanity))

///Causes direct drain of someone's sanity, call it with a numerical value corresponding how badly you want to hurt their sanity
/datum/component/mood/proc/direct_sanity_drain(datum/source, amount)
	setSanity(sanity + amount)

#undef ECSTATIC_SANITY_PEN
#undef SLIGHT_INSANITY_PEN
#undef MINOR_INSANITY_PEN
#undef MAJOR_INSANITY_PEN
#undef MOOD_INSANITY_MALUS
