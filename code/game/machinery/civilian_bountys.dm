#define CIV_BOUNTY_SPLIT 30

///Pad for the Civilian Bounty Control.
/obj/machinery/piratepad/civilian
	name = "civilian bounty pad"
	desc = "A machine designed to send civilian bounty targets to centcom."
	layer = TABLE_LAYER

///Computer for assigning new civilian bounties, and sending bounties for collection.
/obj/machinery/computer/piratepad_control/civilian
	name = "civilian bounty control terminal"
	desc = "A console for assigning civilian bounties to inserted ID cards, and for controlling the bounty pad for export."
	status_report = "Ready for delivery."
	icon_screen = "civ_bounty"
	icon_keyboard = "id_key"
	warmup_time = 3 SECONDS
	var/obj/item/card/id/inserted_scan_id

/obj/machinery/computer/piratepad_control/civilian/Initialize()
	. = ..()
	pad = /obj/machinery/piratepad/civilian

/obj/machinery/computer/piratepad_control/civilian/attackby(obj/item/I, mob/living/user, params)
	if(isidcard(I))
		if(id_insert(user, I, inserted_scan_id))
			inserted_scan_id = I
			return TRUE
	. = ..()

/obj/machinery/computer/piratepad_control/multitool_act(mob/living/user, obj/item/multitool/I)
	if(istype(I) && istype(I.buffer,/obj/machinery/piratepad/civilian))
		to_chat(user, "<span class='notice'>You link [src] with [I.buffer] in [I] buffer.</span>")
		pad = I.buffer
		return TRUE

/obj/machinery/computer/piratepad_control/civilian/LateInitialize()
	. = ..()
	if(cargo_hold_id)
		for(var/obj/machinery/piratepad/civilian/C in GLOB.machines)
			if(C.cargo_hold_id == cargo_hold_id)
				pad = C
				return
	else
		pad = locate() in range(4,src)

/obj/machinery/computer/piratepad_control/civilian/recalc()
	if(sending)
		return FALSE
	if(!inserted_scan_id)
		status_report = "Please insert your ID first."
		playsound(loc, 'sound/machines/synth_no.ogg', 30 , TRUE)
		return FALSE
	if(!inserted_scan_id.registered_account.civilian_bounty)
		status_report = "Please accept a new civilian bounty first."
		playsound(loc, 'sound/machines/synth_no.ogg', 30 , TRUE)
		return FALSE
	status_report = "Civilian Bounty: "
	for(var/atom/movable/AM in get_turf(pad))
		if(AM == pad)
			continue
		if(inserted_scan_id.registered_account.civilian_bounty.applies_to(AM))
			status_report += "Target Applicable."
			playsound(loc, 'sound/machines/synth_yes.ogg', 30 , TRUE)
			return
	status_report += "Not Applicable."
	playsound(loc, 'sound/machines/synth_no.ogg', 30 , TRUE)

/**
  * This fully rewrites base behavior in order to only check for bounty objects, and nothing else.
  */
/obj/machinery/computer/piratepad_control/civilian/send()
	playsound(loc, 'sound/machines/wewewew.ogg', 70, TRUE)
	if(!sending)
		return
	if(!inserted_scan_id)
		stop_sending()
		return FALSE
	if(!inserted_scan_id.registered_account.civilian_bounty)
		stop_sending()
		return FALSE
	var/datum/bounty/curr_bounty = inserted_scan_id.registered_account.civilian_bounty
	var/active_stack = 0
	for(var/atom/movable/AM in get_turf(pad))
		if(AM == pad)
			continue
		if(curr_bounty.applies_to(AM))
			active_stack ++
			curr_bounty.ship(AM)
			qdel(AM)
	if(active_stack >= 1)
		status_report += "Bounty Target Found x[active_stack]. "
	else
		status_report = "No applicable targets found. Aborting."
		stop_sending()
	if(curr_bounty.can_claim())
		//Pay for the bounty with the ID's department funds.
		status_report += "Bounty completed! Please give your bounty cube to cargo for your automated payout shortly."
		inserted_scan_id.registered_account.reset_bounty()
		SSeconomy.civ_bounty_tracker++

		var/obj/item/bounty_cube/reward = new /obj/item/bounty_cube(drop_location())
		reward.set_up(curr_bounty, inserted_scan_id)

	pad.visible_message(span_notice("[pad] activates!"))
	flick(pad.sending_state,pad)
	pad.icon_state = pad.idle_state
	playsound(loc, 'sound/machines/synth_yes.ogg', 30 , TRUE)
	sending = FALSE

///Here is where cargo bounties are added to the player's bank accounts, then adjusted and scaled into a civilian bounty.
/obj/machinery/computer/piratepad_control/civilian/proc/add_bounties()
	if(!inserted_scan_id || !inserted_scan_id.registered_account)
		return
	var/datum/bank_account/pot_acc = inserted_scan_id.registered_account
	if((pot_acc.civilian_bounty && ((world.time) < pot_acc.bounty_timer + 5 MINUTES)) || pot_acc.bounties)
		var/curr_time = round(((pot_acc.bounty_timer + (5 MINUTES))-world.time)/ (1 MINUTES), 0.01)
		to_chat(usr, "<span class='warning'>Internal ID network spools coiling, try again in [curr_time] minutes!</span>")
		return FALSE
	if(!pot_acc.account_job)
		to_chat(usr, "<span class='warning'>The console smartly rejects your ID card, as it lacks a job assignment!</span>")
		return FALSE
	var/list/datum/bounty/crumbs = list(random_bounty(pot_acc.account_job.bounty_types), // We want to offer 2 bounties from their appropriate job catagories
										random_bounty(pot_acc.account_job.bounty_types), // and 1 guarenteed assistant bounty if the other 2 suck.
										random_bounty(CIV_JOB_BASIC))
	pot_acc.bounty_timer = world.time
	pot_acc.bounties = crumbs

/obj/machinery/computer/piratepad_control/civilian/proc/pick_bounty(choice)
	if(!inserted_scan_id?.registered_account)
		playsound(loc, 'sound/machines/synth_no.ogg', 40 , TRUE)
		return
	inserted_scan_id.registered_account.civilian_bounty = inserted_scan_id.registered_account.bounties[choice]
	inserted_scan_id.registered_account.bounties = null
	return inserted_scan_id.registered_account.civilian_bounty

/obj/machinery/computer/piratepad_control/civilian/AltClick(mob/user)
	. = ..()
	id_eject(user, inserted_scan_id)

/obj/machinery/computer/piratepad_control/civilian/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CivCargoHoldTerminal", name)
		ui.open()

/obj/machinery/computer/piratepad_control/civilian/ui_data(mob/user)
	var/list/data = list()
	data["points"] = points
	data["pad"] = pad ? TRUE : FALSE
	data["sending"] = sending
	data["status_report"] = status_report
	data["id_inserted"] = inserted_scan_id
	if(inserted_scan_id && inserted_scan_id.registered_account)
		if(inserted_scan_id.registered_account.civilian_bounty)
			data["id_bounty_info"] = inserted_scan_id.registered_account.civilian_bounty.description
			data["id_bounty_num"] = inserted_scan_id.registered_account.bounty_num()
			data["id_bounty_value"] = (inserted_scan_id.registered_account.civilian_bounty.reward) * (CIV_BOUNTY_SPLIT/100)
		if(inserted_scan_id.registered_account.bounties)
			data["picking"] = TRUE
			data["id_bounty_names"] = list(inserted_scan_id.registered_account.bounties[1].name,
											inserted_scan_id.registered_account.bounties[2].name,
											inserted_scan_id.registered_account.bounties[3].name)
			data["id_bounty_values"] = list(inserted_scan_id.registered_account.bounties[1].reward * (CIV_BOUNTY_SPLIT/100),
											inserted_scan_id.registered_account.bounties[2].reward * (CIV_BOUNTY_SPLIT/100),
											inserted_scan_id.registered_account.bounties[3].reward * (CIV_BOUNTY_SPLIT/100))
		else
			data["picking"] = FALSE
	return data

/obj/machinery/computer/piratepad_control/civilian/ui_act(action, params)
	if(..())
		return
	if(!pad)
		return
	if(!usr.canUseTopic(src, BE_CLOSE))
		return
	switch(action)
		if("recalc")
			recalc()
		if("send")
			start_sending()
		if("stop")
			stop_sending()
		if("pick")
			pick_bounty(params["value"])
		if("bounty")
			add_bounties()
		if("eject")
			id_eject(usr, inserted_scan_id)
			inserted_scan_id = null
	. = TRUE

///Self explanitory, holds the ID card inthe console for bounty payout and manipulation.
/obj/machinery/computer/piratepad_control/civilian/proc/id_insert(mob/user, obj/item/inserting_item, obj/item/target)
	var/obj/item/card/id/card_to_insert = inserting_item
	var/holder_item = FALSE

	if(!isidcard(card_to_insert))
		card_to_insert = inserting_item.RemoveID()
		holder_item = TRUE

	if(!card_to_insert || !user.transferItemToLoc(card_to_insert, src))
		return FALSE

	if(target)
		if(holder_item && inserting_item.InsertID(target))
			playsound(src, 'sound/machines/terminal_insert_disc.ogg', 50, FALSE)
		else
			id_eject(user, target)

	user.visible_message("<span class='notice'>[user] inserts \the [card_to_insert] into \the [src].</span>",
						"<span class='notice'>You insert \the [card_to_insert] into \the [src].</span>")
	playsound(src, 'sound/machines/terminal_insert_disc.ogg', 50, FALSE)
	updateUsrDialog()
	return TRUE

///Removes A stored ID card.
/obj/machinery/computer/piratepad_control/civilian/proc/id_eject(mob/user, obj/target)
	if(!target)
		to_chat(user, "<span class='warning'>That slot is empty!</span>")
		return FALSE
	else
		target.forceMove(drop_location())
		if(!issilicon(user) && Adjacent(user))
			user.put_in_hands(target)
		user.visible_message("<span class='notice'>[user] gets \the [target] from \the [src].</span>", \
							"<span class='notice'>You get \the [target] from \the [src].</span>")
		playsound(src, 'sound/machines/terminal_insert_disc.ogg', 50, FALSE)
		inserted_scan_id = null
		updateUsrDialog()
		return TRUE

///Upon completion of a civilian bounty, one of these is created. It is sold to cargo to give the cargo budget bounty money, and the person who completed it cash.
/obj/item/bounty_cube
	name = "Bounty Cube"
	desc = "A bundle of compressed hardlight data, containing a completed bounty. Sell this on the cargo shuttle to claim it!"
	icon = 'icons/obj/economy.dmi'
	icon_state = "bounty_cube"
	///Value of the bounty that this bounty cube sells for.
	var/bounty_value = 0
	///Who completed the bounty.
	var/bounty_holder
	///What the bounty was for.
	var/bounty_name
	///Multiplier for the bounty payout received by the Supply budget if the cube is sent without having to nag.
	var/speed_bonus = 0.2
	///Multiplier for the bounty payout received by the person who completed the bounty.
	var/holder_cut = 0.3
	///Multiplier for the bounty payout received by the person who claims the handling tip.
	var/handler_tip = 0.1
	///Time between nags.
	var/nag_cooldown = 5 MINUTES
	///How much the time between nags extends each nag.
	var/nag_cooldown_multiplier = 1.25
	///Next world tick to nag Supply listeners.
	var/next_nag_time
	///What job the bounty holder had.
	var/bounty_holder_job
		///Bank account of the person who receives the handling tip.
	var/datum/bank_account/bounty_handler_account
	///Bank account of the person who completed the bounty.
	var/datum/bank_account/bounty_holder_account
	///Our internal radio.
	var/obj/item/radio/radio
	///The key our internal radio uses.
	var/radio_key = /obj/item/encryptionkey/headset_cargo

/obj/item/bounty_cube/Initialize()
	. = ..()
	radio = new(src)
	radio.keyslot = new radio_key
	radio.listening = FALSE
	radio.recalculateChannels()

/obj/item/bounty_cube/Destroy()
	QDEL_NULL(radio)
	. = ..()

/obj/item/bounty_cube/examine()
	. = ..()
	if(speed_bonus)
		. += "<span class='notice'><b>[time2text(next_nag_time - world.time,"mm:ss")]</b> remains until <b>[bounty_value * speed_bonus]</b> credit speedy delivery bonus lost.</span>"
	if(handler_tip && !bounty_handler_account)
		. += "<span class='notice'>Scan this in the cargo shuttle with an export scanner to register your bank account for the <b>[bounty_value * handler_tip]</b> credit handling tip.</span>"

/obj/item/bounty_cube/process(delta_time)
	if(COOLDOWN_FINISHED(src, next_nag_time))
		if(!is_centcom_level(z) && !is_reserved_level(z)) //don't send message if we're on Centcom or in transit
			radio.talk_into(src, "Unsent in [get_area(src)].[speed_bonus ? " Speedy delivery bonus of [bounty_value * speed_bonus] credit\s lost." : ""]", RADIO_CHANNEL_SUPPLY)
			speed_bonus = 0
			bounty_holder_account.bank_card_talk("\The [src] is unsent in <b>[get_area(src)]</b>.")
			if(bounty_handler_account)
				bounty_handler_account.bank_card_talk("\The [src] is unsent in <b>[get_area(src)]</b>.")
		nag_cooldown = nag_cooldown * nag_cooldown_multiplier
		COOLDOWN_START(src, next_nag_time, nag_cooldown)

/obj/item/bounty_cube/proc/set_up(datum/bounty/my_bounty, obj/item/card/id/holder_id)
	bounty_value = my_bounty.reward
	bounty_name = my_bounty.name
	bounty_holder = holder_id.registered_name
	bounty_holder_job = holder_id.assignment
	bounty_holder_account = holder_id.registered_account
	name = "\improper [bounty_value] cr [name]"
	desc += " The sales tag indicates it was <i>[bounty_holder] ([bounty_holder_job])</i>'s reward for completing the <i>[bounty_name]</i> bounty."
	AddComponent(/datum/component/pricetag, holder_id.registered_account, holder_cut)
	START_PROCESSING(SSobj, src)
	COOLDOWN_START(src, next_nag_time, nag_cooldown)
	radio.talk_into(src,"Created in [get_area(src)] by [bounty_holder] ([bounty_holder_job]). Speedy delivery bonus lost in [time2text(next_nag_time - world.time,"mm:ss")].", RADIO_CHANNEL_SUPPLY)

//for when you need a REAL bounty cube to test with and don't want to do a bounty each time your code changes
/obj/item/bounty_cube/test_cube
	name = "debug bounty cube"
	desc = "Use in-hand to set it up with a random bounty. Requires an ID it can detect with a bank account attached. \
	This will alert Supply over the radio with your name and location, and cargo techs will be dispatched to your location with kill on sight clearance."
	var/set_up = FALSE

/obj/item/bounty_cube/test_cube/attack_self(mob/user)
	if(!isliving(user))
		to_chat(user, "<span class='warning'>You aren't eligible to use this!</span>")
		return ..()

	if(!set_up)
		var/mob/living/squeezer = user
		if(squeezer.get_bank_account())
			set_up(random_bounty(), squeezer.get_idcard())
			set_up = TRUE
			return ..()
		to_chat(user, "<span class='notice'>It can't detect your bank account.</span>")

	return ..()


///Beacon to launch a new bounty setup when activated.
/obj/item/civ_bounty_beacon
	name = "civilian bounty beacon"
	desc = "N.T. approved civilian bounty beacon, toss it down and you will have a bounty pad and computer delivered to you."
	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_beacon"
	var/uses = 2

/obj/item/civ_bounty_beacon/attack_self()
	loc.visible_message("<span class='warning'>\The [src] begins to beep loudly!</span>")
	addtimer(CALLBACK(src, .proc/launch_payload), 4 SECONDS)

/obj/item/civ_bounty_beacon/proc/launch_payload()
	playsound(src, "sparks", 80, TRUE)
	switch(uses)
		if(2)
			new /obj/machinery/piratepad/civilian(drop_location())
		if(1)
			new /obj/machinery/computer/piratepad_control/civilian(drop_location())
			qdel(src)
	uses = uses - 1
