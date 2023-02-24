/obj/machinery/computer/aifixer
	name = "\improper AI system integrity restorer"
	desc = "Used with intelliCards containing nonfunctional AIs to restore them to working order."
	req_access = list(ACCESS_CAPTAIN, ACCESS_ROBOTICS, ACCESS_HEADS)
	icon_keyboard = "tech_key"
	icon_screen = "ai-fixer"
	light_color = LIGHT_COLOR_PINK
	circuit = /obj/item/circuitboard/computer/aifixer

	var/mob/living/silicon/ai/occupier = null
	var/active = FALSE

/obj/machinery/computer/aifixer/attackby(obj/item/I, mob/user, params)
	if(occupier && I.tool_behaviour == TOOL_SCREWDRIVER)
		if(stat & (NOPOWER|BROKEN))
			to_chat(user, "<span class='warning'>The screws on [name]'s screen won't budge.</span>")
		else
			to_chat(user, "<span class='warning'>The screws on [name]'s screen won't budge and it emits a warning beep.</span>")
	else
		return ..()


/obj/machinery/computer/aifixer/ui_interact(mob/user, datum/tgui/ui) //artur didn't port this correctly
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AiRestorer", name)
		ui.open()

/obj/machinery/computer/aifixer/ui_data(mob/user)
	var/list/data = list()

	data["ejectable"] = FALSE
	data["AI_present"] = FALSE
	data["error"] = null
	if(!occupier)
		data["error"] = "Please transfer an AI unit."
	else
		data["AI_present"] = TRUE
		data["name"] = occupier.name
		data["restoring"] = active
		data["health"] = (occupier.health + 100) / 2
		data["isDead"] = occupier.stat == DEAD
		data["laws"] = occupier.laws.get_law_list(include_zeroth = TRUE, render_html = FALSE)

	return data

/obj/machinery/computer/aifixer/ui_act(action, params)
	if(..())
		return
	if(!occupier)
		active = FALSE

	switch(action)
		if("PRG_beginReconstruction")
			if(occupier?.health < 100)
				to_chat(usr, "<span class='notice'>Reconstruction in progress. This will take several minutes.</span>")
				playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 25, FALSE)
				active = TRUE
				occupier.notify_ghost_cloning("Your core files are being restored!", source = src)
				. = TRUE

/obj/machinery/computer/aifixer/proc/Fix()
	use_power(1000)
	occupier.adjustOxyLoss(-1, FALSE, FALSE)
	occupier.adjustFireLoss(-1, FALSE, FALSE)
	occupier.adjustBruteLoss(-5, FALSE)

	occupier.updatehealth()
	if(occupier.health >= 0 && occupier.stat == DEAD)
		occupier.revive(full_heal = FALSE, admin_revive = FALSE)
		if(!occupier.radio_enabled)
			occupier.radio_enabled = TRUE
			to_chat(occupier, span_warning("Your Subspace Transceiver has been enabled!"))
	return occupier.health < 100

/obj/machinery/computer/aifixer/process()
	if(..())
		if(active)
			var/oldstat = occupier.stat
			active = Fix()
			if(oldstat != occupier.stat)
				update_icon()

/obj/machinery/computer/aifixer/update_overlays()
	. = ..()
	if(stat & (NOPOWER|BROKEN))
		return
	if(active)
		. += "ai-fixer-on"
	if (occupier)
		switch (occupier.stat)
			if (0)
				. += "ai-fixer-full"
			if (2)
				. += "ai-fixer-404"
	else
		. += "ai-fixer-empty"

/obj/machinery/computer/aifixer/transfer_ai(interaction, mob/user, mob/living/silicon/ai/AI, obj/item/aicard/card)
	if(!..())
		return
	//Downloading AI from card to terminal.
	if(interaction == AI_TRANS_FROM_CARD)
		if(stat & (NOPOWER|BROKEN))
			to_chat(user, "[src] is offline and cannot take an AI at this time!")
			return
		AI.forceMove(src)
		occupier = AI
		AI.control_disabled = 1
		AI.radio_enabled = 0
		to_chat(AI, "You have been uploaded to a stationary terminal. Sadly, there is no remote access from here.")
		to_chat(user, "<span class='boldnotice'>Transfer successful</span>: [AI.name] ([rand(1000,9999)].exe) installed and executed successfully. Local copy has been removed.")
		card.AI = null
		update_icon()

	else //Uploading AI from terminal to card
		if(occupier && !active)
			to_chat(occupier, "You have been downloaded to a mobile storage device. Still no remote access.")
			to_chat(user, "<span class='boldnotice'>Transfer successful</span>: [occupier.name] ([rand(1000,9999)].exe) removed from host terminal and stored within local memory.")
			occupier.forceMove(card)
			card.AI = occupier
			occupier = null
			update_icon()
		else if (active)
			to_chat(user, "<span class='boldannounce'>ERROR</span>: Reconstruction in progress.")
		else if (!occupier)
			to_chat(user, "<span class='boldannounce'>ERROR</span>: Unable to locate artificial intelligence.")
