/*
 * Cryogenic refrigeration unit. Basically a despawner.
 * Stealing a lot of concepts/code from sleepers due to massive laziness.
 * The despawn tick will only fire if it's been more than time_till_despawned ticks
 * since time_entered, which is world.time when the occupant moves in.
 * ~ Zuhayr
 */

//Main cryopod console.

/obj/machinery/computer/cryopod
	name = "cryogenic oversight console"
	desc = "An interface between crew and the cryogenic storage oversight systems."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "cellconsole_1"
	circuit = /obj/item/circuitboard/cryopodcontrol
	density = FALSE
	interaction_flags_machine = INTERACT_MACHINE_OFFLINE
	req_one_access = list(ACCESS_HEADS, ACCESS_ARMORY) //Heads of staff or the warden can go here to claim recover items from their department that people went were cryodormed with.

	var/menu = 1 //Which menu screen to display

	//Used for logging people entering cryosleep and important items they are carrying.
	var/list/frozen_crew = list()
	var/list/obj/stored_packages = list()

	var/allow_items = TRUE

/obj/machinery/computer/cryopod/deconstruct()
	. = ..()
	for(var/i in stored_packages)
		var/obj/O = i
		O.forceMove(drop_location())

/obj/machinery/computer/cryopod/attack_ai()
	attack_hand()

/obj/machinery/computer/cryopod/ui_interact(mob/user = usr)
	if(!is_operational())
		return

	user.set_machine(src)
	add_fingerprint(user)

	var/dat = ""

	dat += "<h2>Welcome, [user.real_name].</h2><hr/>"
	dat += "<br><br>"

	switch(src.menu)
		if(1)
			dat += "<a href='byond://?src=[REF(src)];menu=2'>View crew storage log</a><br><br>"
			if(allow_items)
				dat += "<a href='byond://?src=[REF(src)];menu=3'>View objects storage log</a><br><br>"
				dat += "<a href='byond://?src=[REF(src)];item=1'>Recover object</a><br><br>"
				dat += "<a href='byond://?src=[REF(src)];allitems=1'>Recover all objects</a><br>"
		if(2)
			dat += "<a href='byond://?src=[REF(src)];menu=1'><< Back</a><br><br>"
			dat += "<h3>Recently stored Crew</h3><br/><hr/><br/>"
			if(!frozen_crew.len)
				dat += "There has been no storage usage at this terminal.<br/>"
			else
				for(var/person in frozen_crew)
					dat += "[person]<br/>"
			dat += "<hr/>"
		if(3)
			dat += "<a href='byond://?src=[REF(src)];menu=1'><< Back</a><br><br>"
			dat += "<h3>Recently stored objects</h3><br/><hr/><br/>"
			if(!stored_packages.len)
				dat += "There has been no storage usage at this terminal.<br/>"
			else
				for(var/obj/O in stored_packages)
					dat += "[O.name]<br/>"
			dat += "<hr/>"

	var/datum/browser/popup = new(user, "cryopod_console", "Cryogenic System Control")
	popup.set_content(dat)
	popup.open()

/obj/machinery/computer/cryopod/Topic(href, href_list)
	if(..())
		return TRUE

	var/mob/user = usr

	add_fingerprint(user)

	if(href_list["item"])
		if(!allowed(user) && !(obj_flags & EMAGGED))
			to_chat(user, "<span class='warning'>Access Denied.</span>")
			playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)
			updateUsrDialog()
			return

		if(!allow_items)
			return

		if(stored_packages.len == 0)
			to_chat(user, "<span class='notice'>There is nothing to recover from storage.</span>")
			playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)
			updateUsrDialog()
			return

		var/obj/I = input(user, "Please choose which object to retrieve.","Object recovery",null) as null|anything in stored_packages
		playsound(src, "terminal_type", 25, 0)
		if(!I)
			return

		if(!(I in stored_packages))
			to_chat(user, "<span class='notice'>\The [I] is no longer in storage.</span>")
			playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)
			updateUsrDialog()
			return

		visible_message("<span class='notice'>The console beeps happily as it disgorges \the [I].</span>")
		playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, 0)

		I.forceMove(drop_location())
		if(user && Adjacent(user) && user.can_hold_items())
			user.put_in_hands(I)
		stored_packages -= I
		updateUsrDialog()

	else if(href_list["allitems"])
		playsound(src, "terminal_type", 25, 0)
		if(!allowed(user) && !(obj_flags & EMAGGED))
			to_chat(user, "<span class='warning'>Access Denied.</span>")
			playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)
			updateUsrDialog()
			return

		if(!allow_items)
			return

		if(stored_packages.len == 0)
			to_chat(user, "<span class='notice'>There is nothing to recover from storage.</span>")
			playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)
			return

		visible_message("<span class='notice'>The console beeps happily as it disgorges the desired objects.</span>")
		playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, 0)

		for(var/obj/O in stored_packages)
			O.forceMove(get_turf(src))
		stored_packages.Cut()
		updateUsrDialog()

	else if (href_list["menu"])
		src.menu = text2num(href_list["menu"])
		playsound(src, "terminal_type", 25, 0)
		updateUsrDialog()

	ui_interact(usr)
	updateUsrDialog()
	return

/obj/item/circuitboard/cryopodcontrol
	name = "Circuit board (Cryogenic Oversight Console)"
	build_path = "/obj/machinery/computer/cryopod"

/obj/machinery/computer/cryopod/contents_explosion()
	return

/obj/machinery/computer/cryopod/contents_explosion()
	return			//don't blow everyone's shit up.

/// The box
/obj/item/storage/box/blue/cryostorage_items
	w_class = WEIGHT_CLASS_HUGE

//Cryopods themselves.
/obj/machinery/cryopod
	name = "cryogenic freezer"
	desc = "Suited for Cyborgs and Humanoids, the pod is a safe place for personnel affected by the Space Sleep Disorder to get some rest."
	icon = 'icons/obj/cryogenic2.dmi'
	icon_state = "cryopod-open"
	density = TRUE
	anchored = TRUE
	state_open = TRUE

	var/on_store_message = "has entered long-term storage."
	var/on_store_name = "Cryogenic Oversight"

	// 15 minutes-ish safe period before being despawned.
	var/time_till_despawn = 15 * 600 // This is reduced by 90% if a player manually enters cryo
	var/despawn_world_time = null          // Used to keep track of the safe period.

	var/obj/machinery/computer/cryopod/control_computer
	var/item_storage_type = /obj/item/storage/box/blue/cryostorage_items		//with how storage components work this can be anything the player can open or anything with a storage component.
	var/last_no_computer_message = 0

/obj/machinery/cryopod/Initialize(mapload)
	. = ..()
	update_icon()
	find_control_computer(mapload)

/obj/machinery/cryopod/proc/find_control_computer(urgent = FALSE)
	for(var/obj/machinery/computer/cryopod/C in get_area(src))
		control_computer = C
		if(C)
			return C
		break

	// Don't send messages unless we *need* the computer, and less than five minutes have passed since last time we messaged
	if(!control_computer && urgent && last_no_computer_message + 5*60*10 < world.time)
		log_admin("Cryopod in [get_area(src)] could not find control computer!")
		message_admins("Cryopod in [get_area(src)] could not find control computer!")
		last_no_computer_message = world.time

	return control_computer != null

/obj/machinery/cryopod/close_machine(mob/user)
	if(!control_computer)
		find_control_computer(TRUE)
	if((isnull(user) || istype(user)) && state_open && !panel_open)
		..(user)
		var/mob/living/mob_occupant = occupant
		investigate_log("Cryogenics machine closed with occupant [key_name(occupant)] by user [key_name(user)].", INVESTIGATE_CRYOGENICS)
		if(mob_occupant && mob_occupant.stat != DEAD)
			to_chat(occupant, "<span class='boldnotice'>You feel cool air surround you. You go numb as your senses turn inward.</span>")
		if(mob_occupant.client)//if they're logged in
			despawn_world_time = world.time + (time_till_despawn * 0.1)
		else
			despawn_world_time = world.time + time_till_despawn
	icon_state = "cryopod"

/obj/machinery/cryopod/open_machine()
	if(occupant)
		investigate_log("Cryogenics machine opened with occupant [key_name(occupant)] inside.", INVESTIGATE_CRYOGENICS)
	..()
	icon_state = "cryopod-open"
	density = TRUE
	name = initial(name)

/obj/machinery/cryopod/container_resist(mob/living/user)
	investigate_log("Cryogenics machine container resisted by [key_name(user)] with occupant [key_name(occupant)].", INVESTIGATE_CRYOGENICS)
	visible_message("<span class='notice'>[occupant] emerges from [src]!</span>",
		"<span class='notice'>You climb out of [src]!</span>")
	open_machine()

/obj/machinery/cryopod/relaymove(mob/user)
	container_resist(user)

/obj/machinery/cryopod/process()
	if(!occupant)
		return

	var/mob/living/mob_occupant = occupant
	if(mob_occupant)
		// Eject dead people
		if(mob_occupant.stat == DEAD)
			open_machine()

		if(!(world.time > despawn_world_time + 100))//+ 10 seconds
			return

		if(!mob_occupant.client && mob_occupant.stat < 2) //Occupant is living and has no client.
			if(!control_computer)
				find_control_computer(urgent = TRUE)//better hope you found it this time

			despawn_occupant()

// This function can not be undone; do not call this unless you are sure
/obj/machinery/cryopod/proc/despawn_occupant()
	if(!control_computer)
		find_control_computer()

	var/mob/living/mob_occupant = occupant

	var/list/obj/item/storing = list()
	var/list/obj/item/destroying = list()
	var/list/obj/item/destroy_later = list()

	investigate_log("Despawning [key_name(mob_occupant)].", INVESTIGATE_CRYOGENICS)

	var/atom/target_store = (control_computer?.allow_items && control_computer) || src		//the double control computer check makes it return the control computer.
	var/drop_to_ground = !istype(target_store, /obj/machinery/computer/cryopod)

	var/mind_identity = mob_occupant.mind?.name
	var/occupant_identity = mob_occupant.real_name

	if(iscyborg(mob_occupant))
		var/mob/living/silicon/robot/R = mob_occupant
		if(R.mmi?.brain)
			destroy_later += R.mmi
			destroy_later += R.mmi.brain
		for(var/i in R.module)
			if(!isitem(i))
				destroying += i
				continue
			var/obj/item/I = i
			// let's be honest we only care about the trash bag don't beat around the bush
			if(SEND_SIGNAL(I, COMSIG_CONTAINS_STORAGE))
				storing += I.contents
				for(var/atom/movable/AM in I.contents)
					AM.forceMove(src)
			R.module.remove_module(I, TRUE)
	else

		if(ishuman(mob_occupant))
			var/mob/living/carbon/human/H = mob_occupant
			if(H.mind && H.client && H.client.prefs && H == H.mind.original_character)
				H.SaveTCGCards()

		var/list/gear = list()
		if(iscarbon(mob_occupant))		// sorry simp-le-mobs deserve no mercy
			var/mob/living/carbon/C = mob_occupant
			gear = C.get_all_gear()
		for(var/i in gear)
			var/obj/item/I = i
			I.forceMove(src)
			if(!istype(I))
				destroying += I
				continue
			if(I.item_flags & (DROPDEL | ABSTRACT))
				destroying += I
				continue
			if(HAS_TRAIT(I, TRAIT_NODROP))
				destroying += I
				continue
			// WEE WOO SNOWFLAKE TIME
			if(istype(I, /obj/item/pda))
				var/obj/item/pda/P = I
				if((P.owner == mind_identity) || (P.owner == occupant_identity))
					destroying += P
				else
					storing += P
			else if(istype(I, /obj/item/card/id))
				var/obj/item/card/id/idcard = I
				if((idcard.registered_name == mind_identity) || (idcard.registered_name == occupant_identity))
					destroying += idcard
				else
					storing += idcard
			else
				storing += I

	// get rid of mobs
	for(var/mob/living/L in mob_occupant.GetAllContents() - mob_occupant)
		L.forceMove(drop_location())

	if(storing.len)
		var/obj/O = new item_storage_type
		O.name = "cryogenic retrieval package: [mob_occupant.real_name]"
		for(var/i in storing)
			var/obj/item/I = i
			I.forceMove(O)
		O.forceMove(drop_to_ground? target_store.drop_location() : target_store)
		if((target_store == control_computer) && !drop_to_ground)
			control_computer.stored_packages += O

	QDEL_LIST(destroying)

	//Update any existing objectives involving this mob.
	for(var/i in GLOB.objectives)
		var/datum/objective/O = i
		// We don't want revs to get objectives that aren't for heads of staff. Letting
		// them win or lose based on cryo is silly so we remove the objective.
		if(istype(O,/datum/objective/mutiny) && O.target == mob_occupant.mind)
			qdel(O)
		else if(O.target && istype(O.target, /datum/mind))
			if(O.target != mob_occupant.mind)
				continue
			if(O.check_midround_completion())
				continue
			if(O.owner && O.owner.current)
				to_chat(O.owner.current, "<BR><span class='userdanger'>You get the feeling your target is no longer within reach. Time for Plan [pick("A","B","C","D","X","Y","Z")]. Objectives updated!</span>")
			O.target = null
			spawn(10) //This should ideally fire after the occupant is deleted.
				if(!O)
					return
				O.find_target()
				O.update_explanation_text()
				if(!(O.target))
					qdel(O)

	if(mob_occupant.mind)
		//Handle job slot/tater cleanup.
		if(mob_occupant.mind.assigned_role)
			var/job = mob_occupant.mind.assigned_role
			SSjob.FreeRole(job)
		mob_occupant.mind.special_role = null

	// Delete them from datacore.

	var/announce_rank = null
	for(var/datum/data/record/R in GLOB.data_core.medical)
		if((R.fields["name"] == mob_occupant.real_name))
			qdel(R)
	for(var/datum/data/record/T in GLOB.data_core.security)
		if((T.fields["name"] == mob_occupant.real_name))
			qdel(T)
	for(var/datum/data/record/G in GLOB.data_core.general)
		if((G.fields["name"] == mob_occupant.real_name))
			announce_rank = G.fields["rank"]
			qdel(G)

	for(var/obj/machinery/computer/cloning/cloner in world)
		for(var/datum/data/record/R in cloner.records)
			if(R.fields["name"] == mob_occupant.real_name)
				cloner.records.Remove(R)

	//Make an announcement and log the person entering storage.
	if(control_computer)
		control_computer.frozen_crew += "[mob_occupant.real_name]"

	if(GLOB.announcement_systems.len)
		var/obj/machinery/announcement_system/announcer = pick(GLOB.announcement_systems)
		announcer.announce("CRYOSTORAGE", mob_occupant.real_name, announce_rank, list())
		visible_message("<span class='notice'>\The [src] hums and hisses as it moves [mob_occupant.real_name] into storage.</span>")

	// Ghost and delete the mob.
	var/mob/dead/observer/G = mob_occupant.get_ghost(TRUE)
	if(G)
		G.voluntary_ghosted = TRUE
	else
		mob_occupant.ghostize(FALSE, penalize = TRUE, voluntary = TRUE, cryo = TRUE)

	QDEL_NULL(occupant)
	QDEL_LIST(destroy_later)
	open_machine()
	name = initial(name)

/obj/machinery/cryopod/MouseDrop_T(mob/living/target, mob/user)
	if(!istype(target) || user.incapacitated() || !target.Adjacent(user) || !Adjacent(user) || !ismob(target) || (!ishuman(user) && !iscyborg(user)) || !istype(user.loc, /turf) || target.buckled)
		return

	if(occupant)
		to_chat(user, "<span class='boldnotice'>The cryo pod is already occupied!</span>")
		return

	if(target.stat == DEAD)
		to_chat(user, "<span class='notice'>Dead people can not be put into cryo.</span>")
		return

	if(target.client && user != target)
		if(iscyborg(target))
			to_chat(user, "<span class='danger'>You can't put [target] into [src]. They're online.</span>")
		else
			to_chat(user, "<span class='danger'>You can't put [target] into [src]. They're conscious.</span>")
		return
	else if(target.client)
		if(alert(target,"Would you like to enter cryosleep?",,"Yes","No") == "No")
			return

	var/generic_plsnoleave_message = " Please adminhelp before leaving the round, even if there are no administrators online!"

	if(target == user && world.time - target.client.cryo_warned > 5 MINUTES)//if we haven't warned them in the last 5 minutes
		var/list/caught_string
		var/addendum = ""
		if(target.mind.assigned_role in GLOB.command_positions)
			LAZYADD(caught_string, "Head of Staff")
			addendum = " Be sure to put your locker items back into your locker!"
		if(iscultist(target) || is_servant_of_ratvar(target))
			LAZYADD(caught_string, "Cultist")
		if(is_devil(target))
			LAZYADD(caught_string, "Devil")
		if(target.mind.has_antag_datum(/datum/antagonist/gang))
			LAZYADD(caught_string, "Gangster")
		if(target.mind.has_antag_datum(/datum/antagonist/rev/head))
			LAZYADD(caught_string, "Head Revolutionary")
		if(target.mind.has_antag_datum(/datum/antagonist/rev))
			LAZYADD(caught_string, "Revolutionary")

		if(caught_string)
			alert(target, "You're a [english_list(caught_string)]![generic_plsnoleave_message][addendum]")
			target.client.cryo_warned = world.time
			return

	if(!target || user.incapacitated() || !target.Adjacent(user) || !Adjacent(user) || (!ishuman(user) && !iscyborg(user)) || !istype(user.loc, /turf) || target.buckled)
		return
		//rerun the checks in case of shenanigans

	if(target == user)
		visible_message("[user] starts climbing into the cryo pod.")
	else
		visible_message("[user] starts putting [target] into the cryo pod.")

	if(occupant)
		to_chat(user, "<span class='boldnotice'>\The [src] is in use.</span>")
		return
	close_machine(target)

	to_chat(target, "<span class='boldnotice'>If you ghost, log out or close your client now, your character will shortly be permanently removed from the round.</span>")
	name = "[name] ([occupant.name])"
	log_admin("<span class='notice'>[key_name(target)] entered a stasis pod.</span>")
	message_admins("[key_name_admin(target)] entered a stasis pod. (<A HREF='?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")
	add_fingerprint(target)

//Attacks/effects.
/obj/machinery/cryopod/blob_act()
	return //Sorta gamey, but we don't really want these to be destroyed.
