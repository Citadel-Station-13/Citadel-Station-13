/*
Overview:
   Used to create objects that need a per step proc call.  Default definition of 'New()'
   stores a reference to src machine in global 'machines list'.  Default definition
   of 'Del' removes reference to src machine in global 'machines list'.

Class Variables:
   use_power (num)
      current state of auto power use.
      Possible Values:
         0 -- no auto power use
         1 -- machine is using power at its idle power level
         2 -- machine is using power at its active power level

   active_power_usage (num)
      Value for the amount of power to use when in active power mode

   idle_power_usage (num)
      Value for the amount of power to use when in idle power mode

   power_channel (num)
      What channel to draw from when drawing power for power mode
      Possible Values:
         EQUIP:0 -- Equipment Channel
         LIGHT:2 -- Lighting Channel
         ENVIRON:3 -- Environment Channel

   component_parts (list)
      A list of component parts of machine used by frame based machines.

   uid (num)
      Unique id of machine across all machines.

   gl_uid (global num)
      Next uid value in sequence

   stat (bitflag)
      Machine status bit flags.
      Possible bit flags:
         BROKEN:1 -- Machine is broken
         NOPOWER:2 -- No power is being supplied to machine.
         POWEROFF:4 -- tbd
         MAINT:8 -- machine is currently under going maintenance.
         EMPED:16 -- temporary broken by EMP pulse

Class Procs:
   New()                     'game/machinery/machine.dm'

   Destroy()                   'game/machinery/machine.dm'

   auto_use_power()            'game/machinery/machine.dm'
      This proc determines how power mode power is deducted by the machine.
      'auto_use_power()' is called by the 'master_controller' game_controller every
      tick.

      Return Value:
         return:1 -- if object is powered
         return:0 -- if object is not powered.

      Default definition uses 'use_power', 'power_channel', 'active_power_usage',
      'idle_power_usage', 'powered()', and 'use_power()' implement behavior.

   powered(chan = EQUIP)         'modules/power/power.dm'
      Checks to see if area that contains the object has power available for power
      channel given in 'chan'.

   use_power(amount, chan=EQUIP)   'modules/power/power.dm'
      Deducts 'amount' from the power channel 'chan' of the area that contains the object.

   power_change()               'modules/power/power.dm'
      Called by the area that contains the object when ever that area under goes a
      power state change (area runs out of power, or area channel is turned off).

   RefreshParts()               'game/machinery/machine.dm'
      Called to refresh the variables in the machine that are contributed to by parts
      contained in the component_parts list. (example: glass and material amounts for
      the autolathe)

      Default definition does nothing.

   assign_uid()               'game/machinery/machine.dm'
      Called by machine to assign a value to the uid variable.

   process()                  'game/machinery/machine.dm'
      Called by the 'machinery subsystem' once per machinery tick for each machine that is listed in its 'machines' list.

   process_atmos()
      Called by the 'air subsystem' once per atmos tick for each machine that is listed in its 'atmos_machines' list.

   is_operational()
		Returns 0 if the machine is unpowered, broken or undergoing maintenance, something else if not

	Compiled by Aygar
*/

/obj/machinery
	name = "machinery"
	icon = 'icons/obj/stationobjs.dmi'
	verb_say = "beeps"
	verb_yell = "blares"
	pressure_resistance = 10
	var/stat = 0
	var/emagged = 0
	var/use_power = 1
		//0 = dont run the auto
		//1 = run auto, use idle
		//2 = run auto, use active
	var/idle_power_usage = 0
	var/active_power_usage = 0
	var/power_channel = EQUIP
		//EQUIP,ENVIRON or LIGHT
	var/list/component_parts = null //list of all the parts used to build it, if made from certain kinds of frames.
	var/uid
	var/global/gl_uid = 1
	var/panel_open = 0
	var/state_open = 0
	var/mob/living/occupant = null
	var/unsecuring_tool = /obj/item/weapon/wrench
	var/interact_open = 0 // Can the machine be interacted with when in maint/when the panel is open.
	var/interact_offline = 0 // Can the machine be interacted with while de-powered.
	var/speed_process = 0 // Process as fast as possible?

/obj/machinery/New()
	..()
	machines += src
	if(!speed_process)
		START_PROCESSING(SSmachine, src)
	else
		START_PROCESSING(SSfastprocess, src)
	power_change()

/obj/machinery/Destroy()
	machines.Remove(src)
	if(!speed_process)
		STOP_PROCESSING(SSmachine, src)
	else
		STOP_PROCESSING(SSfastprocess, src)
	dropContents()
	return ..()

/obj/machinery/proc/locate_machinery()
	return

/obj/machinery/process()//If you dont use process or power why are you here
	return PROCESS_KILL

/obj/machinery/proc/process_atmos()//If you dont use process why are you here
	return PROCESS_KILL

/obj/machinery/emp_act(severity)
	if(use_power && stat == 0)
		use_power(7500/severity)

		PoolOrNew(/obj/effect/overlay/temp/emp, loc)
	..()

/obj/machinery/proc/open_machine(drop = 1)
	state_open = 1
	density = 0
	if(drop)
		dropContents()
	update_icon()
	updateUsrDialog()

/obj/machinery/proc/dropContents()
	var/turf/T = get_turf(src)
	for(var/mob/living/L in src)
		L.loc = T
		L.reset_perspective(null)
		L.update_canmove() //so the mob falls if he became unconscious inside the machine.
		. += L

	T.contents += contents
	occupant = null

/obj/machinery/proc/close_machine(mob/living/target = null)
	state_open = 0
	density = 1
	if(!target)
		for(var/mob/living/carbon/C in loc)
			if(C.buckled || C.has_buckled_mobs())
				continue
			else
				target = C
	if(target && !target.buckled && !target.has_buckled_mobs())
		occupant = target
		target.forceMove(src)
	updateUsrDialog()
	update_icon()

/obj/machinery/blob_act(obj/effect/blob/B)
	if(!density)
		qdel(src)
	if(prob(75))
		qdel(src)

/obj/machinery/proc/auto_use_power()
	if(!powered(power_channel))
		return 0
	if(use_power == 1)
		use_power(idle_power_usage,power_channel)
	else if(use_power >= 2)
		use_power(active_power_usage,power_channel)
	return 1

/obj/machinery/proc/is_operational()
	return !(stat & (NOPOWER|BROKEN|MAINT))

/obj/machinery/proc/is_interactable()
	if((stat & (NOPOWER|BROKEN)) && !interact_offline)
		return FALSE
	if(panel_open && !interact_open)
		return FALSE
	return TRUE


////////////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/interact(mob/user)
	add_fingerprint(user)
	ui_interact(user)

/obj/machinery/ui_status(mob/user)
	if(is_interactable())
		return ..()
	return UI_CLOSE

/obj/machinery/ui_act(action, params)
	add_fingerprint(usr)
	return ..()

/obj/machinery/Topic(href, href_list)
	..()
	if(!is_interactable())
		return 1
	if(!usr.canUseTopic(src))
		return 1
	add_fingerprint(usr)
	return 0


////////////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/mech_melee_attack(obj/mecha/M)
	M.do_attack_animation(src)
	if(M.damtype == BRUTE || M.damtype == BURN)
		visible_message("<span class='danger'>[M.name] has hit [src].</span>")
		take_damage(M.force*2, M.damtype) // multiplied by 2 so we can hit machines hard but not be overpowered against mobs.
		return 1
	return 0

/obj/machinery/attacked_by(obj/item/I, mob/living/user)
	..()
	take_damage(I.force, I.damtype, 1)

/obj/machinery/proc/take_damage(damage, damage_type = BRUTE, sound_effect = 1)
	switch(damage_type)
		if(BRUTE)
			if(sound_effect)
				if(damage)
					playsound(loc, 'sound/weapons/smash.ogg', 50, 1)
				else
					playsound(loc, 'sound/weapons/tap.ogg', 50, 1)
		if(BURN)
			if(sound_effect)
				playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)

/obj/machinery/attack_alien(mob/living/carbon/alien/humanoid/user)
	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(src)
	add_hiddenprint(user)
	visible_message("<span class='warning'>\The [user] slashes at [src]!</span>")
	playsound(src.loc, 'sound/weapons/slash.ogg', 100, 1)
	take_damage(20, BRUTE, 0)

/obj/machinery/attack_animal(mob/living/simple_animal/M)
	M.changeNext_move(CLICK_CD_MELEE)
	M.do_attack_animation(src)
	if(M.melee_damage_upper > 0)
		M.visible_message("<span class='danger'>[M.name] smashes against \the [src.name].</span>",\
		"<span class='danger'>You smash against the [src.name].</span>")
		take_damage(M.melee_damage_upper, M.melee_damage_type, 1)


/obj/machinery/attack_paw(mob/living/user)
	if(user.a_intent != "harm")
		return attack_hand(user)
	else
		user.changeNext_move(CLICK_CD_MELEE)
		user.do_attack_animation(src)
		user.visible_message("<span class='danger'>[user.name] smashes against \the [src.name] with its paws.</span>",\
		"<span class='danger'>You smash against the [src.name] with your paws.</span>")
		take_damage(4, BRUTE, 1)


/obj/machinery/attack_ai(mob/user)
	if(isrobot(user))// For some reason attack_robot doesn't work
		var/mob/living/silicon/robot/R = user
		if(R.client && R.client.eye == R && !R.low_power_mode)// This is to stop robots from using cameras to remotely control machines; and from using machines when the borg has no power.
			return attack_hand(user)
	else
		return attack_hand(user)


//set_machine must be 0 if clicking the machinery doesn't bring up a dialog
/obj/machinery/attack_hand(mob/user, check_power = 1, set_machine = 1)
	if(..())// unbuckling etc
		return 1
	if((user.lying || user.stat) && !IsAdminGhost(user))
		return 1
	if(!user.IsAdvancedToolUser() && !IsAdminGhost(user))
		usr << "<span class='warning'>You don't have the dexterity to do this!</span>"
		return 1
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(prob(H.getBrainLoss()))
			user << "<span class='warning'>You momentarily forget how to use [src]!</span>"
			return 1
	if(!is_interactable())
		return 1
	if(set_machine)
		user.set_machine(src)
	interact(user)
	add_fingerprint(user)
	return 0

/obj/machinery/CheckParts(list/parts_list)
	..()
	RefreshParts()

/obj/machinery/proc/RefreshParts() //Placeholder proc for machines that are built using frames.
	return

/obj/machinery/proc/assign_uid()
	uid = gl_uid
	gl_uid++

/obj/machinery/proc/default_pry_open(obj/item/weapon/crowbar/C)
	. = !(state_open || panel_open || is_operational() || (flags & NODECONSTRUCT)) && istype(C)
	if(.)
		playsound(loc, C.usesound, 50, 1)
		visible_message("<span class='notice'>[usr] pries open \the [src].</span>", "<span class='notice'>You pry open \the [src].</span>")
		open_machine()
		return 1

/obj/machinery/proc/default_deconstruction_crowbar(obj/item/weapon/crowbar/C, ignore_panel = 0)
	. = istype(C) && (panel_open || ignore_panel) &&  !(flags & NODECONSTRUCT)
	if(.)
		deconstruction()
		playsound(loc, C.usesound, 50, 1)
		var/obj/structure/frame/machine/M = new /obj/structure/frame/machine(loc)
		transfer_fingerprints_to(M)
		M.state = 2
		M.icon_state = "box_1"
		for(var/obj/item/I in component_parts)
			I.loc = loc
		qdel(src)

/obj/machinery/proc/default_deconstruction_screwdriver(mob/user, icon_state_open, icon_state_closed, obj/item/weapon/screwdriver/S)
	if(istype(S) &&  !(flags & NODECONSTRUCT))
		playsound(loc, S.usesound, 50, 1)
		if(!panel_open)
			panel_open = 1
			icon_state = icon_state_open
			user << "<span class='notice'>You open the maintenance hatch of [src].</span>"
		else
			panel_open = 0
			icon_state = icon_state_closed
			user << "<span class='notice'>You close the maintenance hatch of [src].</span>"
		return 1
	return 0

/obj/machinery/proc/default_change_direction_wrench(mob/user, obj/item/weapon/wrench/W)
	if(panel_open && istype(W))
		playsound(loc, W.usesound, 50, 1)
		setDir(turn(dir,-90))
		user << "<span class='notice'>You rotate [src].</span>"
		return 1
	return 0

/obj/proc/default_unfasten_wrench(mob/user, obj/item/weapon/wrench/W, time = 20)
	if(istype(W) &&  !(flags & NODECONSTRUCT))
		user << "<span class='notice'>You begin [anchored ? "un" : ""]securing [name]...</span>"
		playsound(loc, W.usesound, 50, 1)
		if(do_after(user, time/W.toolspeed, target = src))
			user << "<span class='notice'>You [anchored ? "un" : ""]secure [name].</span>"
			anchored = !anchored
			playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
		return 1
	return 0

/obj/machinery/proc/exchange_parts(mob/user, obj/item/weapon/storage/part_replacer/W)
	if(!istype(W))
		return
	if((flags & NODECONSTRUCT) && !W.works_from_distance)
		return
	var/shouldplaysound = 0
	if(component_parts)
		if(panel_open || W.works_from_distance)
			var/obj/item/weapon/circuitboard/machine/CB = locate(/obj/item/weapon/circuitboard/machine) in component_parts
			var/P
			if(W.works_from_distance)
				display_parts(user)
			for(var/obj/item/weapon/stock_parts/A in component_parts)
				for(var/D in CB.req_components)
					if(ispath(A.type, D))
						P = D
						break
				for(var/obj/item/weapon/stock_parts/B in W.contents)
					if(istype(B, P) && istype(A, P))
						if(B.rating > A.rating)
							W.remove_from_storage(B, src)
							W.handle_item_insertion(A, 1)
							component_parts -= A
							component_parts += B
							B.loc = null
							user << "<span class='notice'>[A.name] replaced with [B.name].</span>"
							shouldplaysound = 1 //Only play the sound when parts are actually replaced!
							break
			RefreshParts()
		else
			display_parts(user)
		if(shouldplaysound)
			W.play_rped_sound()
		return 1
	return 0

/obj/machinery/proc/display_parts(mob/user)
	user << "<span class='notice'>Following parts detected in the machine:</span>"
	for(var/obj/item/C in component_parts)
		user << "<span class='notice'>\icon[C] [C.name]</span>"

/obj/machinery/examine(mob/user)
	..()
	if(user.research_scanner && component_parts)
		display_parts(user)

//called on machinery construction (i.e from frame to machinery) but not on initialization
/obj/machinery/proc/construction()
	return

//called on deconstruction before the final deletion
/obj/machinery/proc/deconstruction()
	return

/obj/machinery/allow_drop()
	return 0

// Hook for html_interface module to prevent updates to clients who don't have this as their active machine.
/obj/machinery/proc/hiIsValidClient(datum/html_interface_client/hclient, datum/html_interface/hi)
	if (hclient.client.mob && (hclient.client.mob.stat == 0 || IsAdminGhost(hclient.client.mob)))
		if (isAI(hclient.client.mob) || IsAdminGhost(hclient.client.mob)) return TRUE
		else                          return hclient.client.mob.machine == src && Adjacent(hclient.client.mob)
	else
		return FALSE

// Hook for html_interface module to unset the active machine when the window is closed by the player.
/obj/machinery/proc/hiOnHide(datum/html_interface_client/hclient)
	if (hclient.client.mob && hclient.client.mob.machine == src) hclient.client.mob.unset_machine()

/obj/machinery/proc/can_be_overridden()
	. = 1


/obj/machinery/tesla_act(var/power)
	..()
	if(prob(85))
		emp_act(2)
	else if(prob(50))
		ex_act(3)
	else if(prob(90))
		ex_act(2)
	else
		ex_act(1)
