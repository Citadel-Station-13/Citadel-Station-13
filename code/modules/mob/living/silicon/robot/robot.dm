/mob/living/silicon/robot
	name = "Cyborg"
	real_name = "Cyborg"
	icon = 'icons/mob/robots.dmi'
	icon_state = "robot"
	bubble_icon = "robot"

/mob/living/silicon/robot/get_cell()
	return cell

/mob/living/silicon/robot/Initialize(mapload)
	spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

	wires = new /datum/wires/robot(src)
	AddElement(/datum/element/empprotection, EMP_PROTECT_WIRES)

	RegisterSignal(src, COMSIG_PROCESS_BORGCHARGER_OCCUPANT, .proc/charge)

	robot_modules_background = new()
	robot_modules_background.icon_state = "block"
	robot_modules_background.layer = HUD_LAYER	//Objects that appear on screen are on layer ABOVE_HUD_LAYER, UI should be just below it.
	robot_modules_background.plane = HUD_PLANE

	ident = rand(1, 999)

	if(!cell)
		cell = new /obj/item/stock_parts/cell/high(src)

	if(lawupdate)
		make_laws()
		if(!TryConnectToAI())
			lawupdate = FALSE

	radio = new /obj/item/radio/borg(src)
	if(!scrambledcodes && !builtInCamera)
		builtInCamera = new (src)
		builtInCamera.c_tag = real_name
		builtInCamera.network = list("ss13")
		builtInCamera.internal_light = FALSE
		if(wires.is_cut(WIRE_CAMERA))
			builtInCamera.status = 0
	module = new /obj/item/robot_module(src)
	module.rebuild_modules()
	update_icons()
	. = ..()

	//If this body is meant to be a borg controlled by the AI player
	if(shell)
		make_shell()

	//MMI stuff. Held togheter by magic. ~Miauw
	else if(!mmi || !mmi.brainmob)
		mmi = new (src)
		mmi.brain = new /obj/item/organ/brain(mmi)
		mmi.brain.organ_flags |= ORGAN_FROZEN
		mmi.brain.name = "[real_name]'s brain"
		mmi.icon_state = "mmi_full"
		mmi.name = "Man-Machine Interface: [real_name]"
		mmi.brainmob = new(mmi)
		mmi.brainmob.name = src.real_name
		mmi.brainmob.real_name = src.real_name
		mmi.brainmob.container = mmi

	updatename()

	equippable_hats = typecacheof(equippable_hats)

	playsound(loc, 'sound/voice/liveagain.ogg', 75, 1)
	aicamera = new/obj/item/camera/siliconcam/robot_camera(src)
	toner = tonermax
	diag_hud_set_borgcell()

	add_verb(src, /mob/living/proc/lay_down) //CITADEL EDIT gimmie rest verb kthx
	add_verb(src, /mob/living/silicon/robot/proc/rest_style)

//If there's an MMI in the robot, have it ejected when the mob goes away. --NEO
/mob/living/silicon/robot/Destroy()
	var/atom/T = drop_location()//To hopefully prevent run time errors.
	if(mmi && mind)//Safety for when a cyborg gets dust()ed. Or there is no MMI inside.
		if(T)
			mmi.forceMove(T)
		if(mmi.brainmob)
			if(mmi.brainmob.stat == DEAD)
				mmi.brainmob.stat = CONSCIOUS
				GLOB.dead_mob_list -= mmi.brainmob
				GLOB.alive_mob_list += mmi.brainmob
			mind.transfer_to(mmi.brainmob)
			mmi.update_icon()
		else
			to_chat(src, "<span class='boldannounce'>Oops! Something went very wrong, your MMI was unable to receive your mind. You have been ghosted. Please make a bug report so we can fix this bug.</span>")
			ghostize()
			stack_trace("Borg MMI lacked a brainmob")
		mmi = null
	//CITADEL EDIT: Cyborgs drop encryption keys on destroy
	if(istype(radio) && istype(radio.keyslot))
		radio.keyslot.forceMove(T)
		radio.keyslot = null
	//END CITADEL EDIT
	if(connected_ai)
		set_connected_ai(null)
	if(shell)
		GLOB.available_ai_shells -= src
	else
		if(T && istype(radio) && istype(radio.keyslot))
			radio.keyslot.forceMove(T)
			radio.keyslot = null
	qdel(wires)
	qdel(module)
	qdel(eye_lights)
	wires = null
	module = null
	eye_lights = null
	cell = null
	return ..()

/mob/living/silicon/robot/proc/pick_module()
	if(module.type != /obj/item/robot_module)
		return

	if(wires.is_cut(WIRE_RESET_MODULE))
		to_chat(src,"<span class='userdanger'>ERROR: Module installer reply timeout. Please check internal connections.</span>")
		return

	if(!CONFIG_GET(flag/disable_secborg) && GLOB.security_level < CONFIG_GET(number/minimum_secborg_alert))
		to_chat(src, "<span class='notice'>NOTICE: Due to local station regulations, the security cyborg module and its variants are only available during [NUM2SECLEVEL(CONFIG_GET(number/minimum_secborg_alert))] alert and greater.</span>")

	var/list/modulelist = list("Standard" = /obj/item/robot_module/standard, \
	"Engineering" = /obj/item/robot_module/engineering, \
	"Medical" = /obj/item/robot_module/medical, \
	"Miner" = /obj/item/robot_module/miner, \
	"Service" = /obj/item/robot_module/butler)
	if(!CONFIG_GET(flag/disable_peaceborg))
		modulelist["Peacekeeper"] = /obj/item/robot_module/peacekeeper
	if(BORG_SEC_AVAILABLE)
		modulelist["Security"] = /obj/item/robot_module/security

	var/input_module = input("Please, select a module!", "Robot", null, null) as null|anything in modulelist
	if(!input_module || module.type != /obj/item/robot_module)
		return

	module.transform_to(modulelist[input_module])


/mob/living/silicon/robot/proc/updatename(client/C)
	if(shell)
		return
	if(!C)
		C = client
	var/changed_name = ""
	if(custom_name)
		changed_name = custom_name
	if(changed_name == "" && C && C.prefs.custom_names["cyborg"] != DEFAULT_CYBORG_NAME)
		if(apply_pref_name("cyborg", C))
			return //built in camera handled in proc
	if(!changed_name)
		changed_name = get_standard_name()

	real_name = changed_name
	name = real_name
	if(!QDELETED(builtInCamera))
		builtInCamera.c_tag = real_name	//update the camera name too

/mob/living/silicon/robot/proc/get_standard_name()
	return "[(designation ? "[designation] " : "")][mmi.braintype]-[ident]"

/mob/living/silicon/robot/verb/cmd_robot_alerts()
	set category = "Robot Commands"
	set name = "Show Alerts"
	if(usr.stat == DEAD)
		to_chat(src, "<span class='userdanger'>Alert: You are dead.</span>")
		return //won't work if dead
	robot_alerts()

/mob/living/silicon/robot/proc/robot_alerts()
	var/dat = ""
	for (var/cat in alarms)
		dat += text("<B>[cat]</B><BR>\n")
		var/list/L = alarms[cat]
		if (L.len)
			for (var/alarm in L)
				var/list/alm = L[alarm]
				var/area/A = alm[1]
				dat += "<NOBR>"
				dat += text("-- [A.name]")
				dat += "</NOBR><BR>\n"
		else
			dat += "-- All Systems Nominal<BR>\n"
		dat += "<BR>\n"

	var/datum/browser/alerts = new(usr, "robotalerts", "Current Station Alerts", 400, 410)
	alerts.set_content(dat)
	alerts.open()

/mob/living/silicon/robot/proc/ionpulse()
	if(!ionpulse_on)
		return

	if(cell.charge <= 10)
		toggle_ionpulse()
		return

	cell.charge -= 10
	return TRUE

/mob/living/silicon/robot/proc/toggle_ionpulse()
	if(!ionpulse)
		to_chat(src, "<span class='notice'>No thrusters are installed!</span>")
		return

	if(!ion_trail)
		ion_trail = new
		ion_trail.set_up(src)

	ionpulse_on = !ionpulse_on
	to_chat(src, "<span class='notice'>You [ionpulse_on ? null :"de"]activate your ion thrusters.</span>")
	if(ionpulse_on)
		ion_trail.start()
	else
		ion_trail.stop()
	if(thruster_button)
		thruster_button.icon_state = "ionpulse[ionpulse_on]"

/mob/living/silicon/robot/get_status_tab_items()
	. = ..()
	. += ""
	if(cell)
		. += "Charge Left: [cell.charge]/[cell.maxcharge]"
	else
		. += text("No Cell Inserted!")

	if(module)
		for(var/datum/robot_energy_storage/st in module.storages)
			. += "[st.name]: [st.energy]/[st.max_energy]"
	if(connected_ai)
		. += "Master AI: [connected_ai.name]"

/mob/living/silicon/robot/restrained(ignore_grab)
	. = 0

/mob/living/silicon/robot/triggerAlarm(class, area/A, O, obj/alarmsource)
	if(alarmsource.z != z)
		return
	if(stat == DEAD)
		return 1
	var/list/L = alarms[class]
	for (var/I in L)
		if (I == A.name)
			var/list/alarm = L[I]
			var/list/sources = alarm[3]
			if (!(alarmsource in sources))
				sources += alarmsource
			return 1
	var/obj/machinery/camera/C = null
	var/list/CL = null
	if (O && istype(O, /list))
		CL = O
		if (CL.len == 1)
			C = CL[1]
	else if (O && istype(O, /obj/machinery/camera))
		C = O
	L[A.name] = list(A, (C) ? C : O, list(alarmsource))
	queueAlarm(text("--- [class] alarm detected in [A.name]!"), class)
	return 1

/mob/living/silicon/robot/cancelAlarm(class, area/A, obj/origin)
	var/list/L = alarms[class]
	var/cleared = 0
	for (var/I in L)
		if (I == A.name)
			var/list/alarm = L[I]
			var/list/srcs  = alarm[3]
			if (origin in srcs)
				srcs -= origin
			if (srcs.len == 0)
				cleared = 1
				L -= I
	if (cleared)
		queueAlarm("--- [class] alarm in [A.name] has been cleared.", class, 0)
	return !cleared

/mob/living/silicon/robot/can_interact_with(atom/A)
	if (low_power_mode)
		return FALSE
	var/turf/T0 = get_turf(src)
	var/turf/T1 = get_turf(A)
	if (!T0 || ! T1)
		return FALSE
	return ISINRANGE(T1.x, T0.x - interaction_range, T0.x + interaction_range) && ISINRANGE(T1.y, T0.y - interaction_range, T0.y + interaction_range)

/mob/living/silicon/robot/proc/attempt_welder_repair(obj/item/weldingtool/W, mob/user)
	if (!getBruteLoss())
		to_chat(user, "<span class='warning'>[src] is already in good condition!</span>")
		return
	if (!W.tool_start_check(user, amount=0)) //The welder has 1u of fuel consumed by it's afterattack, so we don't need to worry about taking any away.
		return
	user.DelayNextAction(CLICK_CD_MELEE)
	if(src == user)
		to_chat(user, "<span class='notice'>You start fixing yourself...</span>")
		if(!W.use_tool(src, user, 50))
			return
		adjustBruteLoss(-10)
	else
		to_chat(user, "<span class='notice'>You start fixing [src]...</span>")
		if(!do_after(user, 30, target = src))
			return
		adjustBruteLoss(-30)
	updatehealth()
	add_fingerprint(user)
	visible_message("<span class='notice'>[user] has fixed some of the dents on [src].</span>")

/mob/living/silicon/robot/proc/attempt_cable_repair(obj/item/stack/cable_coil/W, mob/user)
	if (getFireLoss() > 0 || getToxLoss() > 0)
		user.DelayNextAction(CLICK_CD_MELEE)
		if(src == user)
			to_chat(user, "<span class='notice'>You start fixing yourself...</span>")
			if(!W.use_tool(src, user, 50, 1, skill_gain_mult = TRIVIAL_USE_TOOL_MULT))
				to_chat(user, "<span class='warning'>You need more cable to repair [src]!</span>")
				return
			adjustFireLoss(-10)
			adjustToxLoss(-10)
		else
			to_chat(user, "<span class='notice'>You start fixing [src]...</span>")
			if(!W.use_tool(src, user, 30, 1))
				to_chat(user, "<span class='warning'>You need more cable to repair [src]!</span>")
				return
			adjustFireLoss(-30)
			adjustToxLoss(-30)
			updatehealth()
			user.visible_message("[user] has fixed some of the burnt wires on [src].", "<span class='notice'>You fix some of the burnt wires on [src].</span>")
	else
		to_chat(user, "The wires seem fine, there's no need to fix them.")

/mob/living/silicon/robot/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/weldingtool) && (user.a_intent != INTENT_HARM || user == src))
		INVOKE_ASYNC(src, .proc/attempt_welder_repair, W, user)
		return

	else if(istype(W, /obj/item/stack/cable_coil) && wiresexposed)
		INVOKE_ASYNC(src, .proc/attempt_cable_repair, W, user)
		return

	else if(istype(W, /obj/item/crowbar))	// crowbar means open or close the cover
		if(opened)
			to_chat(user, "<span class='notice'>You close the cover.</span>")
			opened = 0
			update_icons()
		else
			if(locked)
				to_chat(user, "<span class='warning'>The cover is locked and cannot be opened!</span>")
			else
				to_chat(user, "<span class='notice'>You open the cover.</span>")
				opened = 1
				update_icons()

	else if(istype(W, /obj/item/stock_parts/cell) && opened)	// trying to put a cell inside
		if(wiresexposed)
			to_chat(user, "<span class='warning'>Close the cover first!</span>")
		else if(cell)
			to_chat(user, "<span class='warning'>There is a power cell already installed!</span>")
		else
			if(!user.transferItemToLoc(W, src))
				return
			cell = W
			to_chat(user, "<span class='notice'>You insert the power cell.</span>")
		update_icons()
		diag_hud_set_borgcell()

	else if(is_wire_tool(W))
		if (wiresexposed)
			wires.interact(user)
		else
			to_chat(user, "<span class='warning'>You can't reach the wiring!</span>")

	else if(istype(W, /obj/item/screwdriver) && opened && !cell)	// haxing
		wiresexposed = !wiresexposed
		to_chat(user, "The wires have been [wiresexposed ? "exposed" : "unexposed"]")
		update_icons()

	else if(istype(W, /obj/item/screwdriver) && opened && cell)	// radio
		if(shell)
			to_chat(user, "You cannot seem to open the radio compartment")	//Prevent AI radio key theft
		else if(radio)
			radio.attackby(W,user)//Push it to the radio to let it handle everything
		else
			to_chat(user, "<span class='warning'>Unable to locate a radio!</span>")
		update_icons()

	else if(istype(W, /obj/item/wrench) && opened && !cell) //Deconstruction. The flashes break from the fall, to prevent this from being a ghetto reset module.
		if(!locked_down)
			to_chat(user, "<span class='boldannounce'>[src]'s bolts spark! Maybe you should lock them down first!</span>")
			spark_system.start()
			return
		else
			to_chat(user, "<span class='notice'>You start to unfasten [src]'s securing bolts...</span>")
			if(W.use_tool(src, user, 50, volume=50) && !cell)
				user.visible_message("[user] deconstructs [src]!", "<span class='notice'>You unfasten the securing bolts, and [src] falls to pieces!</span>")
				deconstruct()

	else if(istype(W, /obj/item/aiModule))
		var/obj/item/aiModule/MOD = W
		if(!opened)
			to_chat(user, "<span class='warning'>You need access to the robot's insides to do that!</span>")
			return
		if(wiresexposed)
			to_chat(user, "<span class='warning'>You need to close the wire panel to do that!</span>")
			return
		if(!cell)
			to_chat(user, "<span class='warning'>You need to install a power cell to do that!</span>")
			return
		if(shell) //AI shells always have the laws of the AI
			to_chat(user, "<span class='warning'>[src] is controlled remotely! You cannot upload new laws this way!</span>")
			return
		if(emagged || (connected_ai && lawupdate)) //Can't be sure which, metagamers
			emote("buzz-[user.name]")
			return
		if(!mind) //A player mind is required for law procs to run antag checks.
			to_chat(user, "<span class='warning'>[src] is entirely unresponsive!</span>")
			return
		MOD.install(laws, user) //Proc includes a success mesage so we don't need another one
		return

	else if(istype(W, /obj/item/encryptionkey/) && opened)
		if(radio)//sanityyyyyy
			radio.attackby(W,user)//GTFO, you have your own procs
		else
			to_chat(user, "<span class='warning'>Unable to locate a radio!</span>")

	else if (istype(W, /obj/item/card/id)||istype(W, /obj/item/pda))			// trying to unlock the interface with an ID card
		if(emagged)//still allow them to open the cover
			to_chat(user, "<span class='notice'>The interface seems slightly damaged.</span>")
		if(opened)
			to_chat(user, "<span class='warning'>You must close the cover to swipe an ID card!</span>")
		else
			if(allowed(usr))
				locked = !locked
				to_chat(user, "<span class='notice'>You [ locked ? "lock" : "unlock"] [src]'s cover.</span>")
				update_icons()
			else
				to_chat(user, "<span class='danger'>Access denied.</span>")

	else if(istype(W, /obj/item/borg/upgrade/))
		var/obj/item/borg/upgrade/U = W
		if(!opened)
			to_chat(user, "<span class='warning'>You must access the borg's internals!</span>")
		else if(!src.module && U.require_module)
			to_chat(user, "<span class='warning'>The borg must choose a module before it can be upgraded!</span>")
		else if(U.locked)
			to_chat(user, "<span class='warning'>The upgrade is locked and cannot be used yet!</span>")
		else
			if(!user.temporarilyRemoveItemFromInventory(U))
				return
			if(U.action(src))
				to_chat(user, "<span class='notice'>You apply the upgrade to [src].</span>")
				if(U.one_use)
					U.afterInstall(src)
					qdel(U)
				else
					U.forceMove(src)
					upgrades += U
					U.afterInstall(src)
			else
				to_chat(user, "<span class='danger'>Upgrade error.</span>")
				U.forceMove(drop_location())

	else if(istype(W, /obj/item/toner))
		if(toner >= tonermax)
			to_chat(user, "<span class='warning'>The toner level of [src] is at its highest level possible!</span>")
		else
			if(!user.temporarilyRemoveItemFromInventory(W))
				return
			toner = tonermax
			qdel(W)
			to_chat(user, "<span class='notice'>You fill the toner level of [src] to its max capacity.</span>")

	else if(istype(W, /obj/item/flashlight))
		if(!opened)
			to_chat(user, "<span class='warning'>You need to open the panel to repair the headlamp!</span>")
		else if(lamp_cooldown <= world.time)
			to_chat(user, "<span class='warning'>The headlamp is already functional!</span>")
		else
			if(!user.temporarilyRemoveItemFromInventory(W))
				to_chat(user, "<span class='warning'>[W] seems to be stuck to your hand. You'll have to find a different light.</span>")
				return
			lamp_cooldown = 0
			qdel(W)
			to_chat(user, "<span class='notice'>You replace the headlamp bulbs.</span>")
	else
		return ..()

/mob/living/silicon/robot/crowbar_act(mob/living/user, obj/item/I) //TODO: make fucking everything up there in that attackby() proc use the proper tool_act() procs. But honestly, who has time for that? 'cause I know for sure that you, the person reading this, sure as hell doesn't.
	var/validbreakout = FALSE
	for(var/obj/item/dogborg/sleeper/S in held_items)
		if(!LAZYLEN(S.contents))
			continue
		if(!validbreakout)
			visible_message("<span class='notice'>[user] wedges [I] into the crevice separating [S] from [src]'s chassis, and begins to pry...</span>", "<span class='notice'>You wedge [I] into the crevice separating [S] from [src]'s chassis, and begin to pry...</span>")
		validbreakout = TRUE
		S.go_out()
	if(validbreakout)
		return TRUE
	return ..()

/mob/living/silicon/robot/verb/unlock_own_cover()
	set category = "Robot Commands"
	set name = "Unlock Cover"
	set desc = "Unlocks your own cover if it is locked. You can not lock it again. A human will have to lock it for you."
	if(stat == DEAD)
		return //won't work if dead
	if(locked)
		switch(alert("You cannot lock your cover again, are you sure?\n      (You can still ask for a human to lock it)", "Unlock Own Cover", "Yes", "No"))
			if("Yes")
				locked = FALSE
				update_icons()
				to_chat(usr, "<span class='notice'>You unlock your cover.</span>")

/mob/living/silicon/robot/proc/allowed(mob/M)
	//check if it doesn't require any access at all
	if(check_access(null))
		return 1
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		//if they are holding or wearing a card that has access, that works
		if(check_access(H.get_active_held_item()) || check_access(H.wear_id))
			return 1
	else if(ismonkey(M))
		var/mob/living/carbon/monkey/george = M
		//they can only hold things :(
		if(isitem(george.get_active_held_item()))
			return check_access(george.get_active_held_item())
	return 0

/mob/living/silicon/robot/proc/check_access(obj/item/card/id/I)
	if(!istype(req_access, /list)) //something's very wrong
		return 1

	var/list/L = req_access
	if(!L.len) //no requirements
		return 1

	if(!istype(I, /obj/item/card/id) && isitem(I))
		I = I.GetID()

	if(!I || !I.access) //not ID or no access
		return 0
	for(var/req in req_access)
		if(!(req in I.access)) //doesn't have this access
			return 0
	return 1

/mob/living/silicon/robot/regenerate_icons()
	return update_icons()

/mob/living/silicon/robot/proc/self_destruct()
	if(emagged)
		if(mmi)
			qdel(mmi)
		explosion(src.loc,1,2,4,flame_range = 2)
	else
		explosion(src.loc,-1,0,2)
	gib()

/mob/living/silicon/robot/proc/UnlinkSelf()
	set_connected_ai(null)
	lawupdate = FALSE
	locked_down = FALSE
	scrambledcodes = TRUE
	//Disconnect it's camera so it's not so easily tracked.
	if(!QDELETED(builtInCamera))
		QDEL_NULL(builtInCamera)
		// I'm trying to get the Cyborg to not be listed in the camera list
		// Instead of being listed as "deactivated". The downside is that I'm going
		// to have to check if every camera is null or not before doing anything, to prevent runtime errors.
		// I could change the network to null but I don't know what would happen, and it seems too hacky for me.
	update_mobility()

/mob/living/silicon/robot/mode()
	set name = "Activate Held Object"
	set category = "IC"
	set src = usr

	if(incapacitated())
		return
	var/obj/item/W = get_active_held_item()
	if(W)
		W.attack_self(src)


/mob/living/silicon/robot/proc/SetLockdown(state = TRUE)
	// They stay locked down if their wire is cut.
	if(wires.is_cut(WIRE_LOCKDOWN))
		state = TRUE
	if(state)
		throw_alert("locked", /obj/screen/alert/locked)
	else
		clear_alert("locked")
	locked_down = state
	update_mobility()

/mob/living/silicon/robot/proc/SetEmagged(new_state)
	emagged = new_state
	module.rebuild_modules()
	update_icons()
	if(emagged)
		throw_alert("hacked", /obj/screen/alert/hacked)
	else
		clear_alert("hacked")

/mob/living/silicon/robot/verb/outputlaws()
	set category = "Robot Commands"
	set name = "State Laws"

	if(usr.stat == DEAD)
		return //won't work if dead
	checklaws()

/mob/living/silicon/robot/verb/set_automatic_say_channel() //Borg version of setting the radio for autosay messages.
	set name = "Set Auto Announce Mode"
	set desc = "Modify the default radio setting for stating your laws."
	set category = "Robot Commands"

	if(usr.stat == DEAD)
		return //won't work if dead
	set_autosay()

/mob/living/silicon/robot/proc/control_headlamp()
	if(stat || lamp_cooldown > world.time || low_power_mode)
		to_chat(src, "<span class='danger'>This function is currently offline.</span>")
		return

//Some sort of magical "modulo" thing which somehow increments lamp power by 2, until it hits the max and resets to 0.
	lamp_intensity = (lamp_intensity+2) % (lamp_max+2)
	to_chat(src, "[lamp_intensity ? "Headlamp power set to Level [lamp_intensity/2]" : "Headlamp disabled."]")
	update_headlamp()

/mob/living/silicon/robot/proc/update_headlamp(var/turn_off = 0, var/cooldown = 100)
	set_light(0)

	if(lamp_intensity && (turn_off || stat || low_power_mode))
		to_chat(src, "<span class='danger'>Your headlamp has been deactivated.</span>")
		lamp_intensity = 0
		lamp_cooldown = world.time + cooldown
	else
		set_light(lamp_intensity)

	if(lamp_button)
		lamp_button.icon_state = "lamp[lamp_intensity]"

	update_icons()

/mob/living/silicon/robot/proc/deconstruct()
	var/turf/T = get_turf(src)
	if (robot_suit)
		robot_suit.forceMove(T)
		robot_suit.l_leg.forceMove(T)
		robot_suit.l_leg = null
		robot_suit.r_leg.forceMove(T)
		robot_suit.r_leg = null
		new /obj/item/stack/cable_coil(T, robot_suit.chest.wired)
		robot_suit.chest.forceMove(T)
		robot_suit.chest.wired = 0
		robot_suit.chest = null
		robot_suit.l_arm.forceMove(T)
		robot_suit.l_arm = null
		robot_suit.r_arm.forceMove(T)
		robot_suit.r_arm = null
		robot_suit.head.forceMove(T)
		robot_suit.head.flash1.forceMove(T)
		robot_suit.head.flash1.burn_out()
		robot_suit.head.flash1 = null
		robot_suit.head.flash2.forceMove(T)
		robot_suit.head.flash2.burn_out()
		robot_suit.head.flash2 = null
		robot_suit.head = null
		robot_suit.update_icon()
	else
		new /obj/item/robot_suit(T)
		new /obj/item/bodypart/l_leg/robot(T)
		new /obj/item/bodypart/r_leg/robot(T)
		new /obj/item/stack/cable_coil(T, 1)
		new /obj/item/bodypart/chest/robot(T)
		new /obj/item/bodypart/l_arm/robot(T)
		new /obj/item/bodypart/r_arm/robot(T)
		new /obj/item/bodypart/head/robot(T)
		var/b
		for(b=0, b!=2, b++)
			var/obj/item/assembly/flash/handheld/F = new /obj/item/assembly/flash/handheld(T)
			F.burn_out()
	if (cell) //Sanity check.
		cell.forceMove(T)
		cell = null
	qdel(src)

/mob/living/silicon/robot/modules
	var/set_module = null

/mob/living/silicon/robot/modules/Initialize()
	. = ..()
	module.transform_to(set_module)

/mob/living/silicon/robot/modules/standard
	set_module = /obj/item/robot_module/standard

/mob/living/silicon/robot/modules/medical
	set_module = /obj/item/robot_module/medical

/mob/living/silicon/robot/modules/engineering
	set_module = /obj/item/robot_module/engineering

/mob/living/silicon/robot/modules/security
	set_module = /obj/item/robot_module/security

/mob/living/silicon/robot/modules/clown
	set_module = /obj/item/robot_module/clown

/mob/living/silicon/robot/modules/peacekeeper
	set_module = /obj/item/robot_module/peacekeeper

/mob/living/silicon/robot/modules/miner
	set_module = /obj/item/robot_module/miner

/mob/living/silicon/robot/modules/syndicate
	icon_state = "synd_sec"
	faction = list(ROLE_SYNDICATE)
	bubble_icon = "syndibot"
	req_access = list(ACCESS_SYNDICATE)
	lawupdate = FALSE
	scrambledcodes = TRUE // These are rogue borgs.
	ionpulse = TRUE
	var/playstyle_string = "<span class='big bold'>You are a Syndicate assault cyborg!</span><br>\
							<b>You are armed with powerful offensive tools to aid you in your mission: help the operatives secure the nuclear authentication disk. \
							Your cyborg LMG will slowly produce ammunition from your power supply, and your operative pinpointer will find and locate fellow nuclear operatives. \
							<i>Help the operatives secure the disk at all costs!</i></b>"
	set_module = /obj/item/robot_module/syndicate

/mob/living/silicon/robot/modules/syndicate/Initialize()
	. = ..()
	cell = new /obj/item/stock_parts/cell/hyper(src, 25000)
	radio = new /obj/item/radio/borg/syndicate(src)
	laws = new /datum/ai_laws/syndicate_override()
	addtimer(CALLBACK(src, .proc/show_playstyle), 5)

/mob/living/silicon/robot/modules/syndicate/proc/show_playstyle()
	if(playstyle_string)
		to_chat(src, playstyle_string)

/mob/living/silicon/robot/modules/syndicate/ResetModule()
	return

/mob/living/silicon/robot/modules/syndicate/medical
	icon_state = "synd_medical"
	playstyle_string = "<span class='big bold'>You are a Syndicate medical cyborg!</span><br>\
						<b>You are armed with powerful medical tools to aid you in your mission: help the operatives secure the nuclear authentication disk. \
						Your hypospray will produce Restorative Nanites, a wonder-drug that will heal most types of bodily damages, including clone and brain damage. It also produces morphine for offense. \
						Your defibrillator paddles can revive operatives through their hardsuits, or can be used on harm intent to shock enemies! \
						Your energy saw functions as a circular saw, but can be activated to deal more damage, and your operative pinpointer will find and locate fellow nuclear operatives. \
						<i>Help the operatives secure the disk at all costs!</i></b>"
	set_module = /obj/item/robot_module/syndicate_medical

/mob/living/silicon/robot/modules/syndicate/saboteur
	icon_state = "synd_engi"
	playstyle_string = "<span class='big bold'>You are a Syndicate saboteur cyborg!</span><br>\
						<b>You are armed with robust engineering tools to aid you in your mission: help the operatives secure the nuclear authentication disk. \
						Your destination tagger will allow you to stealthily traverse the disposal network across the station \
						Your welder will allow you to repair the operatives' exosuits, but also yourself and your fellow cyborgs \
						Your cyborg chameleon projector allows you to assume the appearance and registered name of a Nanotrasen engineering borg, and undertake covert actions on the station \
						Be aware that almost any physical contact or incidental damage will break your camouflage \
						<i>Help the operatives secure the disk at all costs!</i></b>"
	set_module = /obj/item/robot_module/saboteur

/mob/living/silicon/robot/proc/notify_ai(notifytype, oldname, newname)
	if(!connected_ai)
		return
	switch(notifytype)
		if(NEW_BORG) //New Cyborg
			to_chat(connected_ai, "<br><br><span class='notice'>NOTICE - New cyborg connection detected: <a href='?src=[REF(connected_ai)];track=[html_encode(name)]'>[name]</a></span><br>")
		if(NEW_MODULE) //New Module
			to_chat(connected_ai, "<br><br><span class='notice'>NOTICE - Cyborg module change detected: [name] has loaded the [designation] module.</span><br>")
		if(RENAME) //New Name
			to_chat(connected_ai, "<br><br><span class='notice'>NOTICE - Cyborg reclassification detected: [oldname] is now designated as [newname].</span><br>")
		if(AI_SHELL) //New Shell
			to_chat(connected_ai, "<br><br><span class='notice'>NOTICE - New cyborg shell detected: <a href='?src=[REF(connected_ai)];track=[html_encode(name)]'>[name]</a></span><br>")
		if(DISCONNECT) //Tampering with the wires
			to_chat(connected_ai, "<br><br><span class='notice'>NOTICE - Remote telemetry lost with [name].</span><br>")

/mob/living/silicon/robot/canUseTopic(atom/movable/M, be_close=FALSE, no_dextery=FALSE, no_tk=FALSE)
	if(stat || locked_down || low_power_mode)
		to_chat(src, "<span class='warning'>You can't do that right now!</span>")
		return FALSE
	if(be_close && !in_range(M, src))
		to_chat(src, "<span class='warning'>You are too far away!</span>")
		return FALSE
	return TRUE

/mob/living/silicon/robot/updatehealth()
	..()
	if(health < maxHealth*0.5) //Gradual break down of modules as more damage is sustained
		if(uneq_module(held_items[3]))
			playsound(loc, 'sound/machines/warning-buzzer.ogg', 50, 1, 1)
			audible_message("<span class='warning'>[src] sounds an alarm! \"SYSTEM ERROR: Module 3 OFFLINE.\"</span>")
			to_chat(src, "<span class='userdanger'>SYSTEM ERROR: Module 3 OFFLINE.</span>")
		if(health < 0)
			if(uneq_module(held_items[2]))
				audible_message("<span class='warning'>[src] sounds an alarm! \"SYSTEM ERROR: Module 2 OFFLINE.\"</span>")
				to_chat(src, "<span class='userdanger'>SYSTEM ERROR: Module 2 OFFLINE.</span>")
				playsound(loc, 'sound/machines/warning-buzzer.ogg', 60, 1, 1)
			if(health < -maxHealth*0.5)
				if(uneq_module(held_items[1]))
					audible_message("<span class='warning'>[src] sounds an alarm! \"CRITICAL ERROR: All modules OFFLINE.\"</span>")
					to_chat(src, "<span class='userdanger'>CRITICAL ERROR: All modules OFFLINE.</span>")
					playsound(loc, 'sound/machines/warning-buzzer.ogg', 75, 1, 1)

/mob/living/silicon/robot/update_sight()
	if(!client)
		return
	if(stat == DEAD)
		sight = (SEE_TURFS|SEE_MOBS|SEE_OBJS)
		see_in_dark = 8
		see_invisible = SEE_INVISIBLE_OBSERVER
		return

	see_invisible = initial(see_invisible)
	see_in_dark = initial(see_in_dark)
	sight = initial(sight)
	lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE

	if(client.eye != src)
		var/atom/A = client.eye
		if(A.update_remote_sight(src)) //returns 1 if we override all other sight updates.
			return

	if(sight_mode & BORGMESON)
		sight |= SEE_TURFS
		lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
		see_in_dark = 1

	if(sight_mode & BORGMATERIAL)
		sight |= SEE_OBJS
		lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
		see_in_dark = 1

	if(sight_mode & BORGXRAY)
		sight |= (SEE_TURFS|SEE_MOBS|SEE_OBJS)
		see_invisible = SEE_INVISIBLE_LIVING
		see_in_dark = 8

	if(sight_mode & BORGTHERM)
		sight |= SEE_MOBS
		see_invisible = min(see_invisible, SEE_INVISIBLE_LIVING)
		see_in_dark = 8

	if(see_override)
		see_invisible = see_override
	sync_lighting_plane_alpha()

/mob/living/silicon/robot/update_stat()
	if(status_flags & GODMODE)
		return
	if(stat != DEAD)
		if(health <= -maxHealth) //die only once
			death()
			return
		if(IsUnconscious() || IsStun() || IsParalyzed() || getOxyLoss() > maxHealth*0.5)
			if(stat == CONSCIOUS)
				stat = UNCONSCIOUS
				if(!eye_blind)
					blind_eyes(1)
				update_mobility()
				update_headlamp()
		else
			if(stat == UNCONSCIOUS)
				stat = CONSCIOUS
				adjust_blindness(-1)
				update_mobility()
				update_headlamp()
	diag_hud_set_status()
	diag_hud_set_health()
	diag_hud_set_aishell()
	update_health_hud()

/mob/living/silicon/robot/revive(full_heal = 0, admin_revive = 0)
	if(..()) //successfully ressuscitated from death
		if(!QDELETED(builtInCamera) && !wires.is_cut(WIRE_CAMERA))
			builtInCamera.toggle_cam(src,0)
		update_headlamp()
		if(admin_revive)
			locked = TRUE
		notify_ai(NEW_BORG)
		. = 1

/mob/living/silicon/robot/fully_replace_character_name(oldname, newname)
	..()
	if(oldname != real_name)
		notify_ai(RENAME, oldname, newname)
	if(!QDELETED(builtInCamera))
		builtInCamera.c_tag = real_name
	custom_name = newname


/mob/living/silicon/robot/proc/ResetModule()
	uneq_all()
	shown_robot_modules = FALSE
	if(hud_used)
		hud_used.update_robot_modules_display()

	if (hasExpanded)
		resize = 0.5
		hasExpanded = FALSE
		update_transform()
	module.transform_to(/obj/item/robot_module)

	// Remove upgrades.
	for(var/obj/item/borg/upgrade/I in upgrades)
		I.deactivate(src)
		I.forceMove(get_turf(src))

	upgrades.Cut()

	speed = 0
	ionpulse = FALSE
	revert_shell()

	return 1

/mob/living/silicon/robot/proc/has_module()
	if(!module || module.type == /obj/item/robot_module)
		. = FALSE
	else
		. = TRUE

/mob/living/silicon/robot/proc/update_module_innate()
	designation = module.name
	if(hands)
		hands.icon_state = module.moduleselect_icon
		hands.icon = (module.moduleselect_alternate_icon ? module.moduleselect_alternate_icon : initial(hands.icon)) //CITADEL CHANGE - allows module select icons to use a different icon file
	if(module.can_be_pushed)
		status_flags |= CANPUSH
	else
		status_flags &= ~CANPUSH

	if(module.clean_on_move)
		AddElement(/datum/element/cleaning)
	else
		RemoveElement(/datum/element/cleaning)

	hat_offset = module.hat_offset

	magpulse = module.magpulsing
	updatename()


/mob/living/silicon/robot/proc/place_on_head(obj/item/new_hat)
	if(hat)
		hat.forceMove(get_turf(src))
	hat = new_hat
	new_hat.forceMove(src)
	update_icons()

/mob/living/silicon/robot/proc/make_shell(var/obj/item/borg/upgrade/ai/board)
	if(!board)
		upgrades |= new /obj/item/borg/upgrade/ai(src)
	shell = TRUE
	braintype = "AI Shell"
	name = "[designation] AI Shell [rand(100,999)]"
	real_name = name
	GLOB.available_ai_shells |= src
	if(!QDELETED(builtInCamera))
		builtInCamera.c_tag = real_name	//update the camera name too
	diag_hud_set_aishell()
	notify_ai(AI_SHELL)

/mob/living/silicon/robot/proc/revert_shell()
	if(!shell)
		return
	undeploy()
	for(var/obj/item/borg/upgrade/ai/boris in src)
	//A player forced reset of a borg would drop the module before this is called, so this is for catching edge cases
		qdel(boris)
	shell = FALSE
	GLOB.available_ai_shells -= src
	name = "Unformatted Cyborg [rand(100,999)]"
	real_name = name
	if(!QDELETED(builtInCamera))
		builtInCamera.c_tag = real_name
	diag_hud_set_aishell()

/mob/living/silicon/robot/proc/deploy_init(var/mob/living/silicon/ai/AI)
	real_name = "[AI.real_name] shell [rand(100, 999)] - [designation]"	//Randomizing the name so it shows up separately in the shells list
	name = real_name
	if(!QDELETED(builtInCamera))
		builtInCamera.c_tag = real_name	//update the camera name too
	mainframe = AI
	deployed = TRUE
	set_connected_ai(mainframe)
	mainframe.connected_robots |= src
	lawupdate = TRUE
	lawsync()
	if(radio && AI.radio) //AI keeps all channels, including Syndie if it is a Traitor
		if(AI.radio.syndie)
			radio.make_syndie()
		radio.subspace_transmission = TRUE
		radio.channels = AI.radio.channels
		for(var/chan in radio.channels)
			radio.secure_radio_connections[chan] = add_radio(radio, GLOB.radiochannels[chan])

	diag_hud_set_aishell()
	undeployment_action.Grant(src)

/datum/action/innate/undeployment
	name = "Disconnect from shell"
	desc = "Stop controlling your shell and resume normal core operations."
	icon_icon = 'icons/mob/actions/actions_AI.dmi'
	button_icon_state = "ai_core"
	required_mobility_flags = NONE

/datum/action/innate/undeployment/Trigger()
	if(!..())
		return FALSE
	var/mob/living/silicon/robot/R = owner

	R.undeploy()
	return TRUE

/datum/action/innate/custom_holoform
	name = "Select Custom Holoform"
	desc = "Select one of your existing avatars to use as a holoform."
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "custom_holoform"
	required_mobility_flags = NONE

/datum/action/innate/custom_holoform/Trigger()
	if(!..())
		return FALSE
	var/mob/living/silicon/S = owner

	//if setting the holoform succeeds, attempt to set it as the current holoform for the pAI or AI
	if(S.attempt_set_custom_holoform())
		if(istype(S, /mob/living/silicon/pai))
			var/mob/living/silicon/pai/P = S
			P.chassis = "custom"
		else if(istype(S, /mob/living/silicon/ai))
			var/mob/living/silicon/ai/A = S
			if(A.client?.prefs?.custom_holoform_icon)
				A.holo_icon = A.client.prefs.get_filtered_holoform(HOLOFORM_FILTER_AI)
			else
				A.holo_icon = getHologramIcon(icon('icons/mob/ai.dmi', "female"))

	return TRUE


/mob/living/silicon/robot/proc/undeploy()

	if(!deployed || !mind || !mainframe)
		return
	mainframe.redeploy_action.Grant(mainframe)
	mainframe.redeploy_action.last_used_shell = src
	mind.transfer_to(mainframe)
	deployed = FALSE
	mainframe.deployed_shell = null
	undeployment_action.Remove(src)
	if(radio) //Return radio to normal
		radio.recalculateChannels()
	if(!QDELETED(builtInCamera))
		builtInCamera.c_tag = real_name	//update the camera name too
	diag_hud_set_aishell()
	mainframe.diag_hud_set_deployed()
	if(mainframe.laws)
		mainframe.laws.show_laws(mainframe) //Always remind the AI when switching
	mainframe = null



/mob/living/silicon/robot/attack_ai(mob/user)
	if(shell && (!connected_ai || connected_ai == user))
		var/mob/living/silicon/ai/AI = user
		AI.deploy_to_shell(src)

/mob/living/silicon/robot/shell
	shell = TRUE

/mob/living/silicon/robot/MouseDrop_T(mob/living/M, mob/living/user)
	. = ..()
	if(!(M in buckled_mobs) && isliving(M))
		buckle_mob(M)

/mob/living/silicon/robot/buckle_mob(mob/living/M, force = FALSE, check_loc = TRUE)
	if(!is_type_in_typecache(M, can_ride_typecache))
		M.visible_message("<span class='warning'>[M] really can't seem to mount [src]...</span>")
		return
	var/datum/component/riding/riding_datum = LoadComponent(/datum/component/riding/cyborg)
	if(buckled_mobs)
		if(buckled_mobs.len >= max_buckled_mobs)
			return
		if(M in buckled_mobs)
			return
	if(stat)
		return
	if(incapacitated())
		return
	if(module)
		if(!module.allow_riding)
			M.visible_message("<span class='boldwarning'>Unfortunately, [M] just can't seem to hold onto [src]!</span>")
			return
	if(iscarbon(M) && !M.incapacitated() && !riding_datum.equip_buckle_inhands(M, 1))
		if(M.get_num_arms() <= 0)
			M.visible_message("<span class='boldwarning'>[M] can't climb onto [src] because [M.p_they()] don't have any usable arms!</span>")
		else
			M.visible_message("<span class='boldwarning'>[M] can't climb onto [src] because [M.p_their()] hands are full!</span>")
		return
	. = ..(M, force, check_loc)

/mob/living/silicon/robot/unbuckle_mob(mob/user, force=FALSE)
	if(iscarbon(user))
		var/datum/component/riding/riding_datum = GetComponent(/datum/component/riding)
		if(istype(riding_datum))
			riding_datum.unequip_buckle_inhands(user)
			riding_datum.restore_position(user)
	. = ..(user)

/mob/living/silicon/robot/proc/TryConnectToAI()
	set_connected_ai(select_active_ai_with_fewest_borgs(z))
	if(connected_ai)
		lawsync()
		lawupdate = 1
		return TRUE
	picturesync()
	return FALSE

/mob/living/silicon/robot/proc/picturesync()
	if(connected_ai && connected_ai.aicamera && aicamera)
		for(var/i in aicamera.stored)
			connected_ai.aicamera.stored[i] = TRUE
		for(var/i in connected_ai.aicamera.stored)
			aicamera.stored[i] = TRUE

/mob/living/silicon/robot/proc/charge(datum/source, amount, repairs)
	if(module)
		var/coeff = amount * 0.005
		module.respawn_consumable(src, coeff)
	if(repairs)
		heal_bodypart_damage(repairs, repairs - 1)
	if(cell)
		cell.charge = min(cell.charge + amount, cell.maxcharge)

/mob/living/silicon/robot/proc/rest_style()
	set name = "Switch Rest Style"
	set category = "Robot Commands"
	set desc = "Select your resting pose."
	sitting = 0
	bellyup = 0
	var/choice = alert(src, "Select resting pose", "", "Resting", "Sitting", "Belly up")
	switch(choice)
		if("Resting")
			update_icons()
			return 0
		if("Sitting")
			sitting = 1
		if("Belly up")
			bellyup = 1
	update_icons()

/mob/living/silicon/robot/verb/viewmanifest()
	set category = "Robot Commands"
	set name = "View Crew Manifest"

	if(usr.stat == DEAD)
		return //won't work if dead
	ai_roster()

/mob/living/silicon/robot/proc/set_connected_ai(new_ai)
	if(connected_ai == new_ai)
		return
	. = connected_ai
	connected_ai = new_ai
	if(.)
		var/mob/living/silicon/ai/old_ai = .
		old_ai.connected_robots -= src
	if(connected_ai)
		connected_ai.connected_robots |= src
