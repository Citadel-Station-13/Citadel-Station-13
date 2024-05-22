#ifdef AI_VOX
/mob/living/silicon/ai/verb/ai_announcement()
	set name = "Vox Announcement"
	set desc = "Make an audible announcement!"
	set category = "AI Commands"

	if(incapacitated())
		return

	if(!ai_announcement)
		ai_announcement = new(src)

	ai_announcement.ui_interact(src)

/datum/ai_announcement
	var/mob/living/silicon/ai/owner

/datum/ai_announcement/New(mob/living/silicon/ai/new_owner)
	if(!istype(new_owner))
		qdel(src)
	owner = new_owner

/datum/ai_announcement/ui_status(mob/living/silicon/ai/user)
	if(owner == user && !owner.incapacitated())
		return ..()
	return UI_CLOSE

/datum/ai_announcement/ui_state(mob/user)
	return GLOB.always_state

/datum/ai_announcement/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AIAnnouncement")
		ui.open()

/datum/ai_announcement/ui_data(mob/user)
	var/list/data = ..()
	data["last_announcement"] = owner.last_announcement
	return data

/datum/ai_announcement/ui_static_data(mob/user)
	var/list/data = ..()
	data["vox_types"] = GLOB.vox_types
	return data

/datum/ai_announcement/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("announce")
			var/vox_type = params["vox_type"]
			if(!vox_type)
				return
			var/to_speak = params["to_speak"]
			if(!to_speak)
				return
			owner.announcement(vox_type, to_speak)
			ui.close()
#endif
