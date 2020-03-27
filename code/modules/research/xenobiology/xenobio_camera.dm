//Xenobio control console
/mob/camera/aiEye/remote/xenobio
	visible_icon = TRUE
	icon = 'icons/mob/cameramob.dmi'
	icon_state = "generic_camera"
	var/allowed_area = null

/mob/camera/aiEye/remote/xenobio/Initialize()
	var/area/A = get_area(loc)
	allowed_area = A.name
	. = ..()

/mob/camera/aiEye/remote/xenobio/setLoc(var/t)
	var/area/new_area = get_area(t)
	if(new_area && new_area.name == allowed_area || new_area && new_area.xenobiology_compatible)
		return ..()
	else
		return

/obj/machinery/computer/camera_advanced/xenobio
	name = "Slime management console"
	desc = "A computer used for remotely handling slimes."
	networks = list("ss13")
	circuit = /obj/item/circuitboard/computer/xenobiology
	var/datum/action/innate/slime_place/slime_place_action
	var/datum/action/innate/slime_pick_up/slime_up_action
	var/datum/action/innate/feed_slime/feed_slime_action
	var/datum/action/innate/monkey_recycle/monkey_recycle_action
	var/datum/action/innate/slime_scan/scan_action
	var/datum/action/innate/feed_potion/potion_action
	var/datum/action/innate/hotkey_help/hotkey_help

	var/list/stored_slimes
	var/obj/item/slimepotion/slime/current_potion
	var/max_slimes = 1
	var/monkeys = 0
	var/upgradetier = 0

	icon_screen = "slime_comp"
	icon_keyboard = "rd_key"

	light_color = LIGHT_COLOR_PINK

/obj/machinery/computer/camera_advanced/xenobio/Initialize()
	. = ..()
	slime_place_action = new
	slime_up_action = new
	feed_slime_action = new
	monkey_recycle_action = new
	scan_action = new
	potion_action = new
	hotkey_help = new
	stored_slimes = list()
	RegisterSignal(src, COMSIG_ATOM_CONTENTS_DEL, .proc/on_contents_del)

/obj/machinery/computer/camera_advanced/xenobio/Destroy()
	stored_slimes = null
	QDEL_NULL(current_potion)
	for(var/i in contents)
		var/mob/living/simple_animal/slime/S = i
		if(istype(S))
			S.forceMove(drop_location())
	return ..()

/obj/machinery/computer/camera_advanced/xenobio/CreateEye()
	eyeobj = new /mob/camera/aiEye/remote/xenobio(get_turf(src))
	eyeobj.origin = src
	eyeobj.visible_icon = TRUE
	eyeobj.icon = 'icons/mob/cameramob.dmi'
	eyeobj.icon_state = "generic_camera"

/obj/machinery/computer/camera_advanced/xenobio/GrantActions(mob/living/user)
	..()

	if(slime_up_action && (upgradetier & XENOBIO_UPGRADE_SLIMEBASIC)) //CIT CHANGE - makes slime-related actions require XENOBIO_UPGRADE_SLIMEBASIC
		slime_up_action.target = src
		slime_up_action.Grant(user)
		actions += slime_up_action

	if(slime_place_action && (upgradetier & XENOBIO_UPGRADE_SLIMEBASIC)) //CIT CHANGE - makes slime-related actions require XENOBIO_UPGRADE_SLIMEBASIC
		slime_place_action.target = src
		slime_place_action.Grant(user)
		actions += slime_place_action

	if(feed_slime_action && (upgradetier & XENOBIO_UPGRADE_MONKEYS)) //CIT CHANGE - makes monkey-related actions require XENOBIO_UPGRADE_MONKEYS
		feed_slime_action.target = src
		feed_slime_action.Grant(user)
		actions += feed_slime_action

	if(monkey_recycle_action && (upgradetier & XENOBIO_UPGRADE_MONKEYS)) //CIT CHANGE - makes monkey-related actions require XENOBIO_UPGRADE_MONKEYS
		monkey_recycle_action.target = src
		monkey_recycle_action.Grant(user)
		actions += monkey_recycle_action

	if(scan_action)
		scan_action.target = src
		scan_action.Grant(user)
		actions += scan_action

	if(potion_action && (upgradetier & XENOBIO_UPGRADE_SLIMEADV)) // CIT CHANGE - makes giving slimes potions via console require XENOBIO_UPGRADE_SLIMEADV
		potion_action.target = src
		potion_action.Grant(user)
		actions += potion_action

	if(hotkey_help)
		hotkey_help.target = src
		hotkey_help.Grant(user)
		actions += hotkey_help

	RegisterSignal(user, COMSIG_XENO_SLIME_CLICK_CTRL, .proc/XenoSlimeClickCtrl)
	RegisterSignal(user, COMSIG_XENO_SLIME_CLICK_ALT, .proc/XenoSlimeClickAlt)
	RegisterSignal(user, COMSIG_XENO_SLIME_CLICK_SHIFT, .proc/XenoSlimeClickShift)
	RegisterSignal(user, COMSIG_XENO_TURF_CLICK_SHIFT, .proc/XenoTurfClickShift)
	RegisterSignal(user, COMSIG_XENO_TURF_CLICK_CTRL, .proc/XenoTurfClickCtrl)
	RegisterSignal(user, COMSIG_XENO_MONKEY_CLICK_CTRL, .proc/XenoMonkeyClickCtrl)

/obj/machinery/computer/camera_advanced/xenobio/remove_eye_control(mob/living/user)
	UnregisterSignal(user, COMSIG_XENO_SLIME_CLICK_CTRL)
	UnregisterSignal(user, COMSIG_XENO_SLIME_CLICK_ALT)
	UnregisterSignal(user, COMSIG_XENO_SLIME_CLICK_SHIFT)
	UnregisterSignal(user, COMSIG_XENO_TURF_CLICK_SHIFT)
	UnregisterSignal(user, COMSIG_XENO_TURF_CLICK_CTRL)
	UnregisterSignal(user, COMSIG_XENO_MONKEY_CLICK_CTRL)
	..()

/obj/machinery/computer/camera_advanced/xenobio/proc/on_contents_del(atom/deleted)
	if(current_potion == deleted)
		current_potion = null
	if(deleted in stored_slimes)
		stored_slimes -= deleted

/obj/machinery/computer/camera_advanced/xenobio/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/disk/xenobio_console_upgrade))
		var/obj/item/disk/xenobio_console_upgrade/diskthing = O
		var/successfulupgrade = FALSE
		for(var/I in diskthing.upgradetypes)
			if(upgradetier & I)
				continue
			else
				upgradetier |= I
				successfulupgrade = TRUE
			if(I == XENOBIO_UPGRADE_SLIMEADV)
				max_slimes = 10
		if(successfulupgrade)
			to_chat(user, "<span class='notice'>You have successfully upgraded [src] with [O].</span>")
		else
			to_chat(user, "<span class='warning'>[src] already has the contents of [O] installed!</span>")
		return
	if(istype(O, /obj/item/reagent_containers/food/snacks/monkeycube) && (upgradetier & XENOBIO_UPGRADE_MONKEYS)) //CIT CHANGE - makes monkey-related actions require XENOBIO_UPGRADE_MONKEYS
		monkeys++
		to_chat(user, "<span class='notice'>You feed [O] to [src]. It now has [monkeys] monkey cubes stored.</span>")
		qdel(O)
		return
	else if(istype(O, /obj/item/storage/bag) && (upgradetier & XENOBIO_UPGRADE_MONKEYS)) //CIT CHANGE - makes monkey-related actions require XENOBIO_UPGRADE_MONKEYS
		var/obj/item/storage/P = O
		var/loaded = FALSE
		for(var/obj/G in P.contents)
			if(istype(G, /obj/item/reagent_containers/food/snacks/monkeycube))
				loaded = TRUE
				monkeys++
				qdel(G)
		if(loaded)
			to_chat(user, "<span class='notice'>You fill [src] with the monkey cubes stored in [O]. [src] now has [monkeys] monkey cubes stored.</span>")
		return
	else if(istype(O, /obj/item/slimepotion/slime)  && (upgradetier & XENOBIO_UPGRADE_SLIMEADV)) // CIT CHANGE - makes giving slimes potions via console require XENOBIO_UPGRADE_SLIMEADV
		var/replaced = FALSE
		if(user && !user.transferItemToLoc(O, src))
			return
		if(!QDELETED(current_potion))
			current_potion.forceMove(drop_location())
			replaced = TRUE
		current_potion = O
		to_chat(user, "<span class='notice'>You load [O] in the console's potion slot[replaced ? ", replacing the one that was there before" : ""].</span>")
		return
	..()

/datum/action/innate/slime_place
	name = "Place Slimes"
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "slime_down"

/datum/action/innate/slime_place/Activate()
	if(!target || !isliving(owner))
		return
	var/mob/living/C = owner
	var/mob/camera/aiEye/remote/xenobio/remote_eye = C.remote_control
	var/obj/machinery/computer/camera_advanced/xenobio/X = target

	if(GLOB.cameranet.checkTurfVis(remote_eye.loc))
		for(var/mob/living/simple_animal/slime/S in X.stored_slimes)
			S.forceMove(remote_eye.loc)
			S.visible_message("[S] warps in!")
			X.stored_slimes -= S
	else
		to_chat(owner, "<span class='warning'>Target is not near a camera. Cannot proceed.</span>")

/datum/action/innate/slime_pick_up
	name = "Pick up Slime"
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "slime_up"

/datum/action/innate/slime_pick_up/Activate()
	if(!target || !isliving(owner))
		return
	var/mob/living/C = owner
	var/mob/camera/aiEye/remote/xenobio/remote_eye = C.remote_control
	var/obj/machinery/computer/camera_advanced/xenobio/X = target

	if(GLOB.cameranet.checkTurfVis(remote_eye.loc))
		for(var/mob/living/simple_animal/slime/S in remote_eye.loc)
			if(X.stored_slimes.len >= X.max_slimes)
				break
			if(!S.ckey)
				if(S.buckled)
					S.Feedstop(silent = TRUE)
				S.visible_message("[S] vanishes in a flash of light!")
				S.forceMove(X)
				X.stored_slimes += S
	else
		to_chat(owner, "<span class='warning'>Target is not near a camera. Cannot proceed.</span>")


/datum/action/innate/feed_slime
	name = "Feed Slimes"
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "monkey_down"

/datum/action/innate/feed_slime/Activate()
	if(!target || !isliving(owner))
		return
	var/mob/living/C = owner
	var/mob/camera/aiEye/remote/xenobio/remote_eye = C.remote_control
	var/obj/machinery/computer/camera_advanced/xenobio/X = target

	if(GLOB.cameranet.checkTurfVis(remote_eye.loc))
		if(X.monkeys >= 1)
			var/mob/living/carbon/monkey/food = new /mob/living/carbon/monkey(remote_eye.loc, TRUE, owner)
			if (!QDELETED(food))
				food.LAssailant = WEAKREF(C)
				X.monkeys --
				to_chat(owner, "<span class='notice'>[X] now has [X.monkeys] monkey(s) left.</span>")
		else
			to_chat(owner, "<span class='warning'>[X] needs to have at least 1 monkey stored. Currently has [X.monkeys] monkeys stored.</span>")
	else
		to_chat(owner, "<span class='warning'>Target is not near a camera. Cannot proceed.</span>")


/datum/action/innate/monkey_recycle
	name = "Recycle Monkeys"
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "monkey_up"

/datum/action/innate/monkey_recycle/Activate()
	if(!target || !isliving(owner))
		return
	var/mob/living/C = owner
	var/mob/camera/aiEye/remote/xenobio/remote_eye = C.remote_control
	var/obj/machinery/computer/camera_advanced/xenobio/X = target

	if(GLOB.cameranet.checkTurfVis(remote_eye.loc))
		for(var/mob/living/carbon/monkey/M in remote_eye.loc)
			if(M.stat)
				M.visible_message("[M] vanishes as [M.p_theyre()] reclaimed for recycling!")
				X.monkeys = round(X.monkeys + 0.2,0.1)
				qdel(M)
	else
		to_chat(owner, "<span class='warning'>Target is not near a camera. Cannot proceed.</span>")

/datum/action/innate/slime_scan
	name = "Scan Slime"
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "slime_scan"

/datum/action/innate/slime_scan/Activate()
	if(!target || !isliving(owner))
		return
	var/mob/living/C = owner
	var/mob/camera/aiEye/remote/xenobio/remote_eye = C.remote_control

	if(GLOB.cameranet.checkTurfVis(remote_eye.loc))
		for(var/mob/living/simple_animal/slime/S in remote_eye.loc)
			slime_scan(S, C)
	else
		to_chat(owner, "<span class='warning'>Target is not near a camera. Cannot proceed.</span>")

/datum/action/innate/feed_potion
	name = "Apply Potion"
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "slime_potion"

/datum/action/innate/feed_potion/Activate()
	if(!target || !isliving(owner))
		return

	var/mob/living/C = owner
	var/mob/camera/aiEye/remote/xenobio/remote_eye = C.remote_control
	var/obj/machinery/computer/camera_advanced/xenobio/X = target

	if(QDELETED(X.current_potion))
		to_chat(owner, "<span class='notice'>No potion loaded.</span>")
		return

	if(GLOB.cameranet.checkTurfVis(remote_eye.loc))
		for(var/mob/living/simple_animal/slime/S in remote_eye.loc)
			X.current_potion.attack(S, C)
			break
	else
		to_chat(owner, "<span class='warning'>Target is not near a camera. Cannot proceed.</span>")


//Demodularized Code

/obj/item/disk/xenobio_console_upgrade
	name = "Xenobiology console upgrade disk"
	desc = "Allan please add detail."
	icon_state = "datadisk5"
	var/list/upgradetypes = list()

/obj/item/disk/xenobio_console_upgrade/admin
	name = "Xenobio all access thing"
	desc = "'the consoles are literally useless!!!!!!!!!!!!!!!'"
	upgradetypes = list(XENOBIO_UPGRADE_SLIMEBASIC, XENOBIO_UPGRADE_SLIMEADV, XENOBIO_UPGRADE_MONKEYS)

/obj/item/disk/xenobio_console_upgrade/monkey
	name = "Xenobiology console monkey upgrade disk"
	desc = "This disk will add the ability to remotely recycle monkeys via the Xenobiology console."
	upgradetypes = list(XENOBIO_UPGRADE_MONKEYS)

/obj/item/disk/xenobio_console_upgrade/slimebasic
	name = "Xenobiology console basic slime upgrade disk"
	desc = "This disk will add the ability to remotely manipulate slimes via the Xenobiology console."
	upgradetypes = list(XENOBIO_UPGRADE_SLIMEBASIC)

/obj/item/disk/xenobio_console_upgrade/slimeadv
	name = "Xenobiology console advanced slime upgrade disk"
	desc = "This disk will add the ability to remotely feed slimes potions via the Xenobiology console, and lift the restrictions on the number of slimes that can be stored inside the Xenobiology console. This includes the contents of the basic slime upgrade disk."
	upgradetypes = list(XENOBIO_UPGRADE_SLIMEBASIC, XENOBIO_UPGRADE_SLIMEADV)


//Xenobio Hotkeys Port

/datum/action/innate/hotkey_help
	name = "Hotkey Help"
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "hotkey_help"

/datum/action/innate/hotkey_help/Activate()
	if(!target || !isliving(owner))
		return
	to_chat(owner, "<b>Click shortcuts:</b>")
	to_chat(owner, "Shift-click a slime to pick it up, or the floor to drop all held slimes. (Requires Basic Slime Console upgrade)")
	to_chat(owner, "Ctrl-click a slime to scan it.")
	to_chat(owner, "Alt-click a slime to feed it a potion. (Requires Advanced Slime Console upgrade)")
	to_chat(owner, "Ctrl-click on a dead monkey to recycle it, or the floor to place a new monkey. (Requires Monkey Console upgrade)")

//
// Alternate clicks for slime, monkey and open turf if using a xenobio console

// Scans slime
/mob/living/simple_animal/slime/CtrlClick(mob/user)
	SEND_SIGNAL(user, COMSIG_XENO_SLIME_CLICK_CTRL, src)
	..()

//Feeds a potion to slime
/mob/living/simple_animal/slime/AltClick(mob/user)
	SEND_SIGNAL(user, COMSIG_XENO_SLIME_CLICK_ALT, src)
	..()

//Picks up slime
/mob/living/simple_animal/slime/ShiftClick(mob/user)
	SEND_SIGNAL(user, COMSIG_XENO_SLIME_CLICK_SHIFT, src)
	..()

//Place slimes
/turf/open/ShiftClick(mob/user)
	SEND_SIGNAL(user, COMSIG_XENO_TURF_CLICK_SHIFT, src)
	..()

//Place monkey
/turf/open/CtrlClick(mob/user)
	SEND_SIGNAL(user, COMSIG_XENO_TURF_CLICK_CTRL, src)
	..()

//Pick up monkey
/mob/living/carbon/monkey/CtrlClick(mob/user)
	SEND_SIGNAL(user, COMSIG_XENO_MONKEY_CLICK_CTRL, src)
	..()

// Scans slime
/obj/machinery/computer/camera_advanced/xenobio/proc/XenoSlimeClickCtrl(mob/living/user, mob/living/simple_animal/slime/S)
	if(!GLOB.cameranet.checkTurfVis(S.loc))
		to_chat(user, "<span class='warning'>Target is not near a camera. Cannot proceed.</span>")
		return
	var/mob/living/C = user
	var/mob/camera/aiEye/remote/xenobio/E = C.remote_control
	var/area/mobarea = get_area(S.loc)
	if(mobarea.name == E.allowed_area || mobarea.xenobiology_compatible)
		slime_scan(S, C)

//Feeds a potion to slime
/obj/machinery/computer/camera_advanced/xenobio/proc/XenoSlimeClickAlt(mob/living/user, mob/living/simple_animal/slime/S)
	if(!(upgradetier & XENOBIO_UPGRADE_SLIMEADV)) //CIT CHANGE - makes slime-related actions require XENOBIO_UPGRADE_SLIMEADV
		to_chat(user, "<span class='warning'>This console does not have the advanced slime upgrade.</span>")
		return
	if(!GLOB.cameranet.checkTurfVis(S.loc))
		to_chat(user, "<span class='warning'>Target is not near a camera. Cannot proceed.</span>")
		return
	var/mob/living/C = user
	var/mob/camera/aiEye/remote/xenobio/E = C.remote_control
	var/obj/machinery/computer/camera_advanced/xenobio/X = E.origin
	var/area/mobarea = get_area(S.loc)
	if(QDELETED(X.current_potion))
		to_chat(C, "<span class='warning'>No potion loaded.</span>")
		return
	if(mobarea.name == E.allowed_area || mobarea.xenobiology_compatible)
		X.current_potion.attack(S, C)

//Picks up slime
/obj/machinery/computer/camera_advanced/xenobio/proc/XenoSlimeClickShift(mob/living/user, mob/living/simple_animal/slime/S)
	if(!(upgradetier & XENOBIO_UPGRADE_SLIMEBASIC)) //CIT CHANGE - makes slime-related actions require XENOBIO_UPGRADE_SLIMEBASIC
		to_chat(user, "<span class='warning'>This console does not have the basic slime upgrade.</span>")
		return
	if(!GLOB.cameranet.checkTurfVis(S.loc))
		to_chat(user, "<span class='warning'>Target is not near a camera. Cannot proceed.</span>")
		return
	var/mob/living/C = user
	var/mob/camera/aiEye/remote/xenobio/E = C.remote_control
	var/obj/machinery/computer/camera_advanced/xenobio/X = E.origin
	var/area/mobarea = get_area(S.loc)
	if(mobarea.name == E.allowed_area || mobarea.xenobiology_compatible)
		if(X.stored_slimes.len >= X.max_slimes)
			to_chat(C, "<span class='warning'>Slime storage is full.</span>")
			return
		if(S.ckey)
			to_chat(C, "<span class='warning'>The slime wiggled free!</span>")
			return
		if(S.buckled)
			S.Feedstop(silent = TRUE)
		S.visible_message("[S] vanishes in a flash of light!")
		S.forceMove(X)
		X.stored_slimes += S

//Place slimes
/obj/machinery/computer/camera_advanced/xenobio/proc/XenoTurfClickShift(mob/living/user, turf/open/T)
	if(!(upgradetier & XENOBIO_UPGRADE_SLIMEBASIC)) //CIT CHANGE - makes slime-related actions require XENOBIO_UPGRADE_SLIMEBASIC
		to_chat(user, "<span class='warning'>This console does not have the basic slime upgrade.</span>")
		return
	if(!GLOB.cameranet.checkTurfVis(T))
		to_chat(user, "<span class='warning'>Target is not near a camera. Cannot proceed.</span>")
		return
	var/mob/living/C = user
	var/mob/camera/aiEye/remote/xenobio/E = C.remote_control
	var/obj/machinery/computer/camera_advanced/xenobio/X = E.origin
	var/area/turfarea = get_area(T)
	if(turfarea.name == E.allowed_area || turfarea.xenobiology_compatible)
		for(var/mob/living/simple_animal/slime/S in X.stored_slimes)
			S.forceMove(T)
			S.visible_message("[S] warps in!")
			X.stored_slimes -= S

//Place monkey
/obj/machinery/computer/camera_advanced/xenobio/proc/XenoTurfClickCtrl(mob/living/user, turf/open/T)
	if(!(upgradetier & XENOBIO_UPGRADE_MONKEYS)) // CIT CHANGE - makes monkey-related actions require XENOBIO_UPGRADE_MONKEYS
		to_chat(user, "<span class='warning'>This console does not have the monkey upgrade.</span>")
		return
	if(!GLOB.cameranet.checkTurfVis(T))
		to_chat(user, "<span class='warning'>Target is not near a camera. Cannot proceed.</span>")
		return
	var/mob/living/C = user
	var/mob/camera/aiEye/remote/xenobio/E = C.remote_control
	var/obj/machinery/computer/camera_advanced/xenobio/X = E.origin
	var/area/turfarea = get_area(T)
	if(turfarea.name == E.allowed_area || turfarea.xenobiology_compatible)
		if(X.monkeys >= 1)
			var/mob/living/carbon/monkey/food = new /mob/living/carbon/monkey(T, TRUE, C)
			if (!QDELETED(food))
				food.LAssailant = WEAKREF(C)
				X.monkeys--
				X.monkeys = round(X.monkeys, 0.1)		//Prevents rounding errors
				to_chat(C, "<span class='notice'>[X] now has [X.monkeys] monkey(s) stored.</span>")
		else
			to_chat(C, "<span class='warning'>[X] needs to have at least 1 monkey stored. Currently has [X.monkeys] monkeys stored.</span>")

//Pick up monkey
/obj/machinery/computer/camera_advanced/xenobio/proc/XenoMonkeyClickCtrl(mob/living/user, mob/living/carbon/monkey/M)
	if(!(upgradetier & XENOBIO_UPGRADE_MONKEYS)) // CIT CHANGE - makes monkey-related actions require XENOBIO_UPGRADE_MONKEYS
		to_chat(user, "<span class='warning'>This console does not have the monkey upgrade.</span>")
		return
	if(!isturf(M.loc) || !GLOB.cameranet.checkTurfVis(M.loc))
		to_chat(user, "<span class='warning'>Target is not near a camera. Cannot proceed.</span>")
		return
	var/mob/living/C = user
	var/mob/camera/aiEye/remote/xenobio/E = C.remote_control
	var/obj/machinery/computer/camera_advanced/xenobio/X = E.origin
	var/area/mobarea = get_area(M.loc)
	if(mobarea.name == E.allowed_area || mobarea.xenobiology_compatible)
		if(!M.stat)
			return
		M.visible_message("[M] vanishes as [p_theyre()] reclaimed for recycling!")
		X.monkeys = round(X.monkeys + 0.2,0.1)
		qdel(M)
		if (X.monkeys == (round(X.monkeys,1)))
			to_chat(C, "<span class='notice'>[X] now has [X.monkeys] monkey(s) available.</span>")
