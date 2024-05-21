#ifdef AI_VOX
/mob/living/silicon/ai/verb/announcement_help()

	set name = "Announcement Help"
	set desc = "Display a list of vocal words to announce to the crew."
	set category = "AI Commands"

	if(incapacitated())
		return

	if(!announcement_help)
		announcement_help = new(src)

	announcement_help.ui_interact(src)

/datum/announcement_help
	var/mob/living/silicon/ai/owner

/datum/announcement_help/New(mob/living/silicon/ai/new_owner)
	if(!istype(new_owner))
		qdel(src)
	owner = new_owner

/datum/announcement_help/ui_status(mob/living/silicon/ai/user)
	if(owner == user && !owner.incapacitated())
		return ..()
	return UI_CLOSE

/datum/announcement_help/ui_state(mob/user)
	return GLOB.always_state

/datum/announcement_help/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AnnouncementHelp")
		ui.open()

/datum/announcement_help/ui_static_data(mob/user)
	var/list/data = ..()
	data["vox_types"] = GLOB.vox_types
	return data

/datum/announcement_help/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("say_word")
			var/vox_type = params["vox_type"]
			if(!vox_type)
				return
			var/to_speak = params["to_speak"]
			if(!to_speak)
				return
			play_vox_word(to_speak, null, owner, vox_type)
#endif
