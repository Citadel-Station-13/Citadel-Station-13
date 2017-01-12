#define MECHA_INT_FIRE 1
#define MECHA_INT_TEMP_CONTROL 2
#define MECHA_INT_SHORT_CIRCUIT 4
#define MECHA_INT_TANK_BREACH 8
#define MECHA_INT_CONTROL_LOST 16

#define MELEE 1
#define RANGED 2

#define FRONT_ARMOUR 1
#define SIDE_ARMOUR 2
#define BACK_ARMOUR 3


/obj/mecha
	name = "mecha"
	desc = "Exosuit"
	icon = 'icons/mecha/mecha.dmi'
	density = 1 //Dense. To raise the heat.
	opacity = 1 ///opaque. Menacing.
	anchored = 1 //no pulling around.
	unacidable = 1 //and no deleting hoomans inside
	layer = BELOW_MOB_LAYER//icon draw layer
	infra_luminosity = 15 //byond implementation is bugged.
	force = 5
	flags = HEAR
	var/can_move = 1
	var/mob/living/carbon/occupant = null
	var/step_in = 10 //make a step in step_in/10 sec.
	var/dir_in = 2//What direction will the mech face when entered/powered on? Defaults to South.
	var/step_energy_drain = 10
	var/health = 300 //health is health
	var/deflect_chance = 10 //chance to deflect the incoming projectiles, hits, or lesser the effect of ex_act.
	//the values in this list show how much damage will pass through, not how much will be absorbed.
	var/list/damage_absorption = list("brute"=0.8,"fire"=1.2,"bullet"=0.9,"laser"=1,"energy"=1,"bomb"=1)
	var/list/facing_modifiers = list(FRONT_ARMOUR = 1.5, SIDE_ARMOUR = 1, BACK_ARMOUR = 0.5)
	var/obj/item/weapon/stock_parts/cell/cell
	var/state = 0
	var/cell_power_remaining = 1 // 0 - no power, 1 - 100% power in cell. Starts as 1 so putting any cell into empty mech doesn't deplete charge from it
	var/list/log = new
	var/last_message = 0
	var/add_req_access = 1
	var/maint_access = 0
	var/dna_lock//dna-locking the mech
	var/list/proc_res = list() //stores proc owners, like proc_res["functionname"] = owner reference
	var/datum/effect_system/spark_spread/spark_system = new
	var/lights = 0
	var/lights_power = 6
	var/last_user_hud = 1 // used to show/hide the mecha hud while preserving previous preference


	var/bumpsmash = 0 //Whether or not the mech destroys walls by running into it.
	//inner atmos
	var/use_internal_tank = 0
	var/internal_tank_valve = ONE_ATMOSPHERE
	var/obj/machinery/portable_atmospherics/canister/internal_tank
	var/datum/gas_mixture/cabin_air
	var/obj/machinery/atmospherics/components/unary/portables_connector/connected_port = null

	var/obj/item/device/radio/radio = null

	var/max_temperature = 25000
	var/internal_damage_threshold = 50 //health percentage below which internal damage is possible
	var/internal_damage = 0 //contains bitflags

	var/list/operation_req_access = list()//required access level for mecha operation
	var/list/internals_req_access = list(access_engine,access_robotics)//required access level to open cell compartment

	var/wreckage

	var/list/equipment = new
	var/obj/item/mecha_parts/mecha_equipment/selected
	var/max_equip = 3
	var/datum/events/events

	var/stepsound = 'sound/mecha/mechstep.ogg'
	var/turnsound = 'sound/mecha/mechturn.ogg'

	var/melee_cooldown = 10
	var/melee_can_hit = 1

	//Action datums
	var/datum/action/innate/mecha/mech_eject/eject_action = new
	var/datum/action/innate/mecha/mech_toggle_internals/internals_action = new
	var/datum/action/innate/mecha/mech_cycle_equip/cycle_action = new
	var/datum/action/innate/mecha/mech_toggle_lights/lights_action = new
	var/datum/action/innate/mecha/mech_view_stats/stats_action = new
	var/datum/action/innate/mecha/mech_toggle_thrusters/thrusters_action = new
	var/datum/action/innate/mecha/mech_defence_mode/defense_action = new
	var/datum/action/innate/mecha/mech_overload_mode/overload_action = new
	var/datum/effect_system/smoke_spread/smoke_system = new //not an action, but trigged by one
	var/datum/action/innate/mecha/mech_smoke/smoke_action = new
	var/datum/action/innate/mecha/mech_zoom/zoom_action = new
	var/datum/action/innate/mecha/mech_switch_damtype/switch_damtype_action = new
	var/datum/action/innate/mecha/mech_toggle_phasing/phasing_action = new
	var/datum/action/innate/mecha/strafe/strafing_action = new

	//Action vars
	var/thrusters_active = FALSE
	var/defence_mode = FALSE
	var/defence_mode_deflect_chance = 35
	var/leg_overload_mode = FALSE
	var/leg_overload_coeff = 100
	var/zoom_mode = FALSE
	var/smoke = 5
	var/smoke_ready = 1
	var/smoke_cooldown = 100
	var/phasing = FALSE
	var/phasing_energy_drain = 200
	var/phase_state = "" //icon_state when phasing
	var/strafe = FALSE //If we are strafing

	var/occupant_sight_flags = 0 //sight flags to give to the occupant (e.g. mech mining scanner gives meson-like vision)

	hud_possible = list (DIAG_STAT_HUD, DIAG_BATT_HUD, DIAG_MECH_HUD)


/obj/mecha/New()
	..()
	events = new
	icon_state += "-open"
	add_radio()
	add_cabin()
	add_airtank()
	spark_system.set_up(2, 0, src)
	spark_system.attach(src)
	smoke_system.set_up(3, src)
	smoke_system.attach(src)
	add_cell()
	START_PROCESSING(SSobj, src)
	poi_list |= src
	log_message("[src.name] created.")
	mechas_list += src //global mech list
	prepare_huds()
	var/datum/atom_hud/data/diagnostic/diag_hud = huds[DATA_HUD_DIAGNOSTIC]
	diag_hud.add_to_hud(src)
	diag_hud_set_mechhealth()
	diag_hud_set_mechcell()
	diag_hud_set_mechstat()

	return

/obj/mecha/Destroy()
	go_out()
	for(var/mob/M in src) //Let's just be ultra sure
		if(isAI(M))
			M.gib() //AIs are loaded into the mech computer itself. When the mech dies, so does the AI. Forever.
		else
			M.forceMove(loc)

	if(prob(30))
		explosion(get_turf(loc), 0, 0, 1, 3)

	if(wreckage)
		var/obj/structure/mecha_wreckage/WR = new wreckage(loc)
		for(var/obj/item/mecha_parts/mecha_equipment/E in equipment)
			if(E.salvageable && prob(30))
				WR.crowbar_salvage += E
				E.detach(WR) //detaches from src into WR
				E.equip_ready = 1
			else
				E.detach(loc)
				qdel(E)
		if(cell)
			WR.crowbar_salvage += cell
			cell.forceMove(WR)
			cell.charge = rand(0, cell.charge)
		if(internal_tank)
			WR.crowbar_salvage += internal_tank
			internal_tank.forceMove(WR)
	else
		for(var/obj/item/mecha_parts/mecha_equipment/E in equipment)
			E.detach(loc)
			qdel(E)
		if(cell)
			qdel(cell)
		if(internal_tank)
			qdel(internal_tank)
	STOP_PROCESSING(SSobj, src)
	poi_list.Remove(src)
	equipment.Cut()
	cell = null
	internal_tank = null
	if(loc)
		loc.assume_air(cabin_air)
		air_update_turf()
	else
		qdel(cabin_air)
	cabin_air = null
	qdel(spark_system)
	spark_system = null
	qdel(smoke_system)
	smoke_system = null

	mechas_list -= src //global mech list
	return ..()

////////////////////////
////// Helpers /////////
////////////////////////

/obj/mecha/proc/add_airtank()
	internal_tank = new /obj/machinery/portable_atmospherics/canister/air(src)
	return internal_tank

/obj/mecha/proc/add_cell(var/obj/item/weapon/stock_parts/cell/C=null)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new(src)
	cell.charge = 15000
	cell.maxcharge = 15000

/obj/mecha/proc/add_cabin()
	cabin_air = new
	cabin_air.temperature = T20C
	cabin_air.volume = 200
	cabin_air.assert_gases("o2","n2")
	cabin_air.gases["o2"][MOLES] = O2STANDARD*cabin_air.volume/(R_IDEAL_GAS_EQUATION*cabin_air.temperature)
	cabin_air.gases["n2"][MOLES] = N2STANDARD*cabin_air.volume/(R_IDEAL_GAS_EQUATION*cabin_air.temperature)
	return cabin_air

/obj/mecha/proc/add_radio()
	radio = new(src)
	radio.name = "[src] radio"
	radio.icon = icon
	radio.icon_state = icon_state
	radio.subspace_transmission = 1

/obj/mecha/proc/can_use(mob/user)
	if(user != occupant)
		return 0
	if(user && ismob(user))
		if(!user.incapacitated())
			return 1
	return 0

////////////////////////////////////////////////////////////////////////////////

/obj/mecha/examine(mob/user)
	..()
	var/integrity = health/initial(health)*100
	switch(integrity)
		if(85 to 100)
			user << "It's fully intact."
		if(65 to 85)
			user << "It's slightly damaged."
		if(45 to 65)
			user << "It's badly damaged."
		if(25 to 45)
			user << "It's heavily damaged."
		else
			user << "It's falling apart."
	if(equipment && equipment.len)
		user << "It's equipped with:"
		for(var/obj/item/mecha_parts/mecha_equipment/ME in equipment)
			user << "\icon[ME] [ME]"
	return


//processing internal damage, temperature, air regulation, alert updates, lights power use.
/obj/mecha/process()
	var/internal_temp_regulation = 1

	if(internal_damage)
		if(internal_damage & MECHA_INT_FIRE)
			if(!(internal_damage & MECHA_INT_TEMP_CONTROL) && prob(5))
				clearInternalDamage(MECHA_INT_FIRE)
			if(internal_tank)
				var/datum/gas_mixture/int_tank_air = internal_tank.return_air()
				if(int_tank_air.return_pressure() > internal_tank.maximum_pressure && !(internal_damage & MECHA_INT_TANK_BREACH))
					setInternalDamage(MECHA_INT_TANK_BREACH)
				if(int_tank_air && int_tank_air.return_volume() > 0) //heat the air_contents
					int_tank_air.temperature = min(6000+T0C, int_tank_air.temperature+rand(10,15))
			if(cabin_air && cabin_air.return_volume()>0)
				cabin_air.temperature = min(6000+T0C, cabin_air.return_temperature()+rand(10,15))
				if(cabin_air.return_temperature() > max_temperature/2)
					take_damage(4/round(max_temperature/cabin_air.return_temperature(),0.1),"fire")

		if(internal_damage & MECHA_INT_TEMP_CONTROL)
			internal_temp_regulation = 0

		if(internal_damage & MECHA_INT_TANK_BREACH) //remove some air from internal tank
			if(internal_tank)
				var/datum/gas_mixture/int_tank_air = internal_tank.return_air()
				var/datum/gas_mixture/leaked_gas = int_tank_air.remove_ratio(0.10)
				if(loc)
					loc.assume_air(leaked_gas)
					air_update_turf()
				else
					qdel(leaked_gas)

		if(internal_damage & MECHA_INT_SHORT_CIRCUIT)
			if(get_charge())
				spark_system.start()
				cell.charge -= min(20,cell.charge)
				cell.maxcharge -= min(20,cell.maxcharge)

	if(internal_temp_regulation)
		if(cabin_air && cabin_air.return_volume() > 0)
			var/delta = cabin_air.temperature - T20C
			cabin_air.temperature -= max(-10, min(10, round(delta/4,0.1)))

	if(internal_tank)
		var/datum/gas_mixture/tank_air = internal_tank.return_air()

		var/release_pressure = internal_tank_valve
		var/cabin_pressure = cabin_air.return_pressure()
		var/pressure_delta = min(release_pressure - cabin_pressure, (tank_air.return_pressure() - cabin_pressure)/2)
		var/transfer_moles = 0
		if(pressure_delta > 0) //cabin pressure lower than release pressure
			if(tank_air.return_temperature() > 0)
				transfer_moles = pressure_delta*cabin_air.return_volume()/(cabin_air.return_temperature() * R_IDEAL_GAS_EQUATION)
				var/datum/gas_mixture/removed = tank_air.remove(transfer_moles)
				cabin_air.merge(removed)
		else if(pressure_delta < 0) //cabin pressure higher than release pressure
			var/datum/gas_mixture/t_air = return_air()
			pressure_delta = cabin_pressure - release_pressure
			if(t_air)
				pressure_delta = min(cabin_pressure - t_air.return_pressure(), pressure_delta)
			if(pressure_delta > 0) //if location pressure is lower than cabin pressure
				transfer_moles = pressure_delta*cabin_air.return_volume()/(cabin_air.return_temperature() * R_IDEAL_GAS_EQUATION)
				var/datum/gas_mixture/removed = cabin_air.remove(transfer_moles)
				if(t_air)
					t_air.merge(removed)
				else //just delete the cabin gas, we're in space or some shit
					qdel(removed)

	if(occupant)
		if(cell)
			var/cellcharge = cell.charge/cell.maxcharge
			switch(cellcharge)
				if(0.75 to INFINITY)
					occupant.clear_alert("charge")
				if(0.5 to 0.75)
					occupant.throw_alert("charge",/obj/screen/alert/lowcell, 1)
				if(0.25 to 0.5)
					occupant.throw_alert("charge",/obj/screen/alert/lowcell, 2)
				if(0.01 to 0.25)
					occupant.throw_alert("charge",/obj/screen/alert/lowcell, 3)
				else
					occupant.throw_alert("charge",/obj/screen/alert/emptycell)

		var/integrity = health/initial(health)*100
		switch(integrity)
			if(30 to 45)
				occupant.throw_alert("mech damage", /obj/screen/alert/low_mech_integrity, 1)
			if(15 to 35)
				occupant.throw_alert("mech damage", /obj/screen/alert/low_mech_integrity, 2)
			if(-INFINITY to 15)
				occupant.throw_alert("mech damage", /obj/screen/alert/low_mech_integrity, 3)
			else
				occupant.clear_alert("mech damage")

		if(occupant.loc != src) //something went wrong
			occupant.clear_alert("charge")
			occupant.clear_alert("mech damage")
			RemoveActions(occupant, human_occupant=1)
			occupant = null

	if(lights)
		var/lights_energy_drain = 2
		use_power(lights_energy_drain)

//Diagnostic HUD updates
	diag_hud_set_mechhealth()
	diag_hud_set_mechcell()
	diag_hud_set_mechstat()


/obj/mecha/proc/drop_item()//Derpfix, but may be useful in future for engineering exosuits.
	return

/obj/mecha/Hear(message, atom/movable/speaker, message_langs, raw_message, radio_freq, list/spans)
	if(speaker == occupant)
		if(radio.broadcasting)
			radio.talk_into(speaker, text, , spans)
		//flick speech bubble
		var/list/speech_bubble_recipients = list()
		for(var/mob/M in get_hearers_in_view(7,src))
			if(M.client)
				speech_bubble_recipients.Add(M.client)
		spawn(0)
			flick_overlay(image('icons/mob/talk.dmi', src, "machine[say_test(raw_message)]",MOB_LAYER+1), speech_bubble_recipients, 30)

////////////////////////////
///// Action processing ////
////////////////////////////


/obj/mecha/proc/click_action(atom/target,mob/user,params)
	if(!occupant || occupant != user )
		return
	if(!locate(/turf) in list(target,target.loc)) // Prevents inventory from being drilled
		return
	if(phasing)
		occupant_message("Unable to interact with objects while phasing")
		return
	if(user.incapacitated())
		return
	if(state)
		occupant_message("<span class='warning'>Maintenance protocols in effect.</span>")
		return
	if(!get_charge())
		return
	if(src == target)
		return
	var/dir_to_target = get_dir(src,target)
	if(dir_to_target && !(dir_to_target & dir))//wrong direction
		return
	if(internal_damage & MECHA_INT_CONTROL_LOST)
		target = safepick(view(3,target))
		if(!target)
			return
	if(!target.Adjacent(src))
		if(selected && selected.is_ranged())
			if(selected.action(target,params))
				selected.start_cooldown()
	else if(selected && selected.is_melee())
		if(selected.action(target,params))
			selected.start_cooldown()
	else
		if(internal_damage & MECHA_INT_CONTROL_LOST)
			target = safepick(oview(1,src))
		if(!melee_can_hit || !istype(target, /atom))
			return
		target.mech_melee_attack(src)
		melee_can_hit = 0
		spawn(melee_cooldown)
			melee_can_hit = 1


/obj/mecha/proc/range_action(atom/target)
	return


//////////////////////////////////
////////  Movement procs  ////////
//////////////////////////////////

/obj/mecha/Move(atom/newloc, direct)
	. = ..()
	if(.)
		events.fireEvent("onMove",get_turf(src))

/obj/mecha/Process_Spacemove(var/movement_dir = 0)
	. = ..()
	if(.)
		return 1
	if(thrusters_active && movement_dir && use_power(step_energy_drain))
		return 1

	var/atom/movable/backup = get_spacemove_backup()
	if(backup)
		if(istype(backup) && movement_dir && !backup.anchored)
			if(backup.newtonian_move(turn(movement_dir, 180)))
				if(occupant)
					occupant << "<span class='info'>You push off of [backup] to propel yourself.</span>"
		return 1

/obj/mecha/relaymove(mob/user,direction)
	if(!direction)
		return
	if(user != occupant) //While not "realistic", this piece is player friendly.
		user.forceMove(get_turf(src))
		user << "<span class='notice'>You climb out from [src].</span>"
		return 0
	if(connected_port)
		if(world.time - last_message > 20)
			occupant_message("<span class='warning'>Unable to move while connected to the air system port!</span>")
			last_message = world.time
		return 0
	if(state)
		occupant_message("<span class='danger'>Maintenance protocols in effect.</span>")
		return
	return domove(direction)

/obj/mecha/proc/domove(direction)
	if(!can_move)
		return 0
	if(!Process_Spacemove(direction))
		return 0
	if(!has_charge(step_energy_drain))
		return 0
	if(defence_mode)
		if(world.time - last_message > 20)
			occupant_message("<span class='danger'>Unable to move while in defence mode</span>")
			last_message = world.time
		return 0
	if(zoom_mode)
		if(world.time - last_message > 20)
			occupant_message("Unable to move while in zoom mode.")
			last_message = world.time
		return 0

	var/move_result = 0
	if(internal_damage & MECHA_INT_CONTROL_LOST)
		move_result = mechsteprand()
	else if(dir != direction && !strafe)
		move_result = mechturn(direction)
	else
		move_result = mechstep(direction)
	if(move_result)
		use_power(step_energy_drain)
		can_move = 0
		spawn(step_in)
			can_move = 1
		return 1
	return 0


/obj/mecha/proc/mechturn(direction)
	setDir(direction)
	if(turnsound)
		playsound(src,turnsound,40,1)
	return 1

/obj/mecha/proc/mechstep(direction)
	var/current_dir = dir
	var/result = step(src,direction)
	if(strafe)
		setDir(current_dir)
	if(result && stepsound)
		playsound(src,stepsound,40,1)
	return result

/obj/mecha/proc/mechsteprand()
	var/result = step_rand(src)
	if(result && stepsound)
		playsound(src,stepsound,40,1)
	return result

/obj/mecha/Bump(var/atom/obstacle, yes)
	if(phasing && get_charge() >= phasing_energy_drain && !throwing)
		spawn()
			if(can_move)
				can_move = 0
				if(phase_state)
					flick(phase_state, src)
				forceMove(get_step(src,dir))
				use_power(phasing_energy_drain)
				sleep(step_in*3)
				can_move = 1
	else
		if(yes)
			if(..()) //mech was thrown
				return
			if(bumpsmash && occupant) //Need a pilot to push the PUNCH button.
				obstacle.mech_melee_attack(src)
				if(!obstacle || (obstacle && !obstacle.density))
					step(src,dir)
			if(istype(obstacle, /obj))
				var/obj/O = obstacle
				if(!O.anchored)
					step(obstacle, dir)
			else if(istype(obstacle, /mob))
				step(obstacle, dir)





///////////////////////////////////
////////  Internal damage  ////////
///////////////////////////////////

/obj/mecha/proc/check_for_internal_damage(list/possible_int_damage,ignore_threshold=null)
	if(!islist(possible_int_damage) || isemptylist(possible_int_damage)) return
	if(prob(20))
		if(ignore_threshold || health*100/initial(health) < internal_damage_threshold)
			for(var/T in possible_int_damage)
				if(internal_damage & T)
					possible_int_damage -= T
			var/int_dam_flag = safepick(possible_int_damage)
			if(int_dam_flag)
				setInternalDamage(int_dam_flag)
	if(prob(5))
		if(ignore_threshold || health*100/initial(health)<internal_damage_threshold)
			var/obj/item/mecha_parts/mecha_equipment/ME = safepick(equipment)
			if(ME)
				qdel(ME)
	return

/obj/mecha/proc/setInternalDamage(int_dam_flag)
	internal_damage |= int_dam_flag
	log_append_to_last("Internal damage of type [int_dam_flag].",1)
	occupant << sound('sound/machines/warning-buzzer.ogg',wait=0)
	diag_hud_set_mechstat()
	return

/obj/mecha/proc/clearInternalDamage(int_dam_flag)
	if(internal_damage & int_dam_flag)
		switch(int_dam_flag)
			if(MECHA_INT_TEMP_CONTROL)
				occupant_message("<span class='boldnotice'>Life support system reactivated.</span>")
			if(MECHA_INT_FIRE)
				occupant_message("<span class='boldnotice'>Internal fire extinquished.</span>")
			if(MECHA_INT_TANK_BREACH)
				occupant_message("<span class='boldnotice'>Damaged internal tank has been sealed.</span>")
	internal_damage &= ~int_dam_flag
	diag_hud_set_mechstat()

/////////////////////////////////////
//////////// AI piloting ////////////
/////////////////////////////////////

/obj/mecha/attack_ai(mob/living/silicon/ai/user)
	if(!isAI(user))
		return
	//Allows the Malf to scan a mech's status and loadout, helping it to decide if it is a worthy chariot.
	if(user.can_dominate_mechs)
		examine(user) //Get diagnostic information!
		var/obj/item/mecha_parts/mecha_tracking/B = locate(/obj/item/mecha_parts/mecha_tracking) in src
		if(B) //Beacons give the AI more detailed mech information.
			user << "<span class='danger'>Warning: Tracking Beacon detected. Enter at your own risk. Beacon Data:"
			user << "[B.get_mecha_info()]"
		//Nothing like a big, red link to make the player feel powerful!
		user << "<a href='?src=\ref[user];ai_take_control=\ref[src]'><span class='userdanger'>ASSUME DIRECT CONTROL?</span></a><br>"

/obj/mecha/transfer_ai(interaction, mob/user, mob/living/silicon/ai/AI, obj/item/device/aicard/card)
	if(!..())
		return

 //Transfer from core or card to mech. Proc is called by mech.
	switch(interaction)
		if(AI_TRANS_TO_CARD) //Upload AI from mech to AI card.
			if(!state) //Mech must be in maint mode to allow carding.
				user << "<span class='warning'>[name] must have maintenance protocols active in order to allow a transfer.</span>"
				return
			AI = occupant
			if(!AI || !isAI(occupant)) //Mech does not have an AI for a pilot
				user << "<span class='warning'>No AI detected in the [name] onboard computer.</span>"
				return
			if(AI.mind.special_role) //Malf AIs cannot leave mechs. Except through death.
				user << "<span class='boldannounce'>ACCESS DENIED.</span>"
				return
			AI.ai_restore_power()//So the AI initially has power.
			AI.control_disabled = 1
			AI.radio_enabled = 0
			AI.loc = card
			card.AI = AI
			occupant = null
			AI.controlled_mech = null
			AI.remote_control = null
			icon_state = initial(icon_state)+"-open"
			AI << "You have been downloaded to a mobile storage device. Wireless connection offline."
			user << "<span class='boldnotice'>Transfer successful</span>: [AI.name] ([rand(1000,9999)].exe) removed from [name] and stored within local memory."

		if(AI_MECH_HACK) //Called by Malf AI mob on the mech.
			new /obj/structure/AIcore/deactivated(AI.loc)
			if(occupant) //Oh, I am sorry, were you using that?
				AI << "<span class='warning'>Pilot detected! Forced ejection initiated!"
				occupant << "<span class='danger'>You have been forcibly ejected!</span>"
				go_out(1) //IT IS MINE, NOW. SUCK IT, RD!
			ai_enter_mech(AI, interaction)

		if(AI_TRANS_FROM_CARD) //Using an AI card to upload to a mech.
			AI = card.AI
			if(!AI)
				user << "<span class='warning'>There is no AI currently installed on this device.</span>"
				return
			else if(AI.stat || !AI.client)
				user << "<span class='warning'>[AI.name] is currently unresponsive, and cannot be uploaded.</span>"
				return
			else if(occupant || dna_lock) //Normal AIs cannot steal mechs!
				user << "<span class='warning'>Access denied. [name] is [occupant ? "currently occupied" : "secured with a DNA lock"]."
				return
			AI.control_disabled = 0
			AI.radio_enabled = 1
			user << "<span class='boldnotice'>Transfer successful</span>: [AI.name] ([rand(1000,9999)].exe) installed and executed successfully. Local copy has been removed."
			card.AI = null
			ai_enter_mech(AI, interaction)

//Hack and From Card interactions share some code, so leave that here for both to use.
/obj/mecha/proc/ai_enter_mech(mob/living/silicon/ai/AI, interaction)
	AI.ai_restore_power()
	AI.loc = src
	occupant = AI
	icon_state = initial(icon_state)
	playsound(src, 'sound/machines/windowdoor.ogg', 50, 1)
	if(!internal_damage)
		occupant << sound('sound/mecha/nominal.ogg',volume=50)
	AI.cancel_camera()
	AI.controlled_mech = src
	AI.remote_control = src
	AI.canmove = 1 //Much easier than adding AI checks! Be sure to set this back to 0 if you decide to allow an AI to leave a mech somehow.
	AI.can_shunt = 0 //ONE AI ENTERS. NO AI LEAVES.
	AI << "[interaction == AI_MECH_HACK ? "<span class='announce'>Takeover of [name] complete! You are now permanently loaded onto the onboard computer. Do not attempt to leave the station sector!</span>" \
	: "<span class='notice'>You have been uploaded to a mech's onboard computer."]"
	AI << "<span class='boldnotice'>Use Middle-Mouse to activate mech functions and equipment. Click normally for AI interactions.</span>"
	GrantActions(AI)


//An actual AI (simple_animal mecha pilot) entering the mech
/obj/mecha/proc/aimob_enter_mech(mob/living/simple_animal/hostile/syndicate/mecha_pilot/pilot_mob)
	if(pilot_mob && pilot_mob.Adjacent(src))
		if(occupant)
			return
		icon_state = initial(icon_state)
		occupant = pilot_mob
		pilot_mob.mecha = src
		pilot_mob.loc = src
		GrantActions(pilot_mob)//needed for checks, and incase a badmin puts somebody in the mob

/obj/mecha/proc/aimob_exit_mech(mob/living/simple_animal/hostile/syndicate/mecha_pilot/pilot_mob)
	if(occupant == pilot_mob)
		occupant = null
	if(pilot_mob.mecha == src)
		pilot_mob.mecha = null
	icon_state = "[initial(icon_state)]-open"
	pilot_mob.forceMove(get_turf(src))
	RemoveActions(pilot_mob)


/////////////////////////////////////
////////  Atmospheric stuff  ////////
/////////////////////////////////////

/obj/mecha/remove_air(amount)
	if(use_internal_tank)
		return cabin_air.remove(amount)
	return ..()

/obj/mecha/return_air()
	if(use_internal_tank)
		return cabin_air
	return ..()

/obj/mecha/proc/return_pressure()
	var/datum/gas_mixture/t_air = return_air()
	if(t_air)
		. = t_air.return_pressure()
	return


/obj/mecha/proc/return_temperature()
	var/datum/gas_mixture/t_air = return_air()
	if(t_air)
		. = t_air.return_temperature()
	return

/obj/mecha/proc/connect(obj/machinery/atmospherics/components/unary/portables_connector/new_port)
	//Make sure not already connected to something else
	if(connected_port || !new_port || new_port.connected_device)
		return 0

	//Make sure are close enough for a valid connection
	if(new_port.loc != loc)
		return 0

	//Perform the connection
	connected_port = new_port
	connected_port.connected_device = src
	var/datum/pipeline/connected_port_parent = connected_port.PARENT1
	connected_port_parent.reconcile_air()

	log_message("Connected to gas port.")
	return 1

/obj/mecha/proc/disconnect()
	if(!connected_port)
		return 0

	connected_port.connected_device = null
	connected_port = null
	log_message("Disconnected from gas port.")
	return 1

/obj/mecha/portableConnectorReturnAir()
	return internal_tank.return_air()


/obj/mecha/MouseDrop_T(mob/M, mob/user)
	if (!user.canUseTopic(src) || (user != M))
		return
	if(!ishuman(user)) // no silicons or drones in mechas.
		return
	log_message("[user] tries to move in.")
	if (occupant)
		usr << "<span class='warning'>The [name] is already occupied!</span>"
		log_append_to_last("Permission denied.")
		return
	var/passed
	if(dna_lock)
		if(user.has_dna())
			var/mob/living/carbon/C = user
			if(C.dna.unique_enzymes==dna_lock)
				passed = 1
	else if(operation_allowed(user))
		passed = 1
	if(!passed)
		user << "<span class='warning'>Access denied.</span>"
		log_append_to_last("Permission denied.")
		return
	if(user.buckled)
		user << "<span class='warning'>You are currently buckled and cannot move.</span>"
		log_append_to_last("Permission denied.")
		return
	if(user.has_buckled_mobs()) //mob attached to us
		user << "<span class='warning'>You can't enter the exosuit with other creatures attached to you!</span>"
		return

	visible_message("[user] starts to climb into [name].")

	if(do_after(user, 40, target = src))
		if(health <= 0)
			user << "<span class='warning'>You cannot get in the [name], it has been destroyed!</span>"
		else if(occupant)
			user << "<span class='danger'>[occupant] was faster! Try better next time, loser.</span>"
		else if(user.buckled)
			user << "<span class='warning'>You can't enter the exosuit while buckled.</span>"
		else if(user.has_buckled_mobs())
			user << "<span class='warning'>You can't enter the exosuit with other creatures attached to you!</span>"
		else
			moved_inside(user)
	else
		user << "<span class='warning'>You stop entering the exosuit!</span>"
	return

/obj/mecha/proc/moved_inside(mob/living/carbon/human/H)
	if(H && H.client && H in range(1))
		occupant = H
		H.forceMove(src)
		add_fingerprint(H)
		GrantActions(H, human_occupant=1)
		forceMove(loc)
		log_append_to_last("[H] moved in as pilot.")
		icon_state = initial(icon_state)
		setDir(dir_in)
		playsound(src, 'sound/machines/windowdoor.ogg', 50, 1)
		if(!internal_damage)
			occupant << sound('sound/mecha/nominal.ogg',volume=50)
		return 1
	else
		return 0

/obj/mecha/proc/mmi_move_inside(obj/item/device/mmi/mmi_as_oc,mob/user)
	if(!mmi_as_oc.brainmob || !mmi_as_oc.brainmob.client)
		user << "<span class='warning'>Consciousness matrix not detected!</span>"
		return 0
	else if(mmi_as_oc.brainmob.stat)
		user << "<span class='warning'>Beta-rhythm below acceptable level!</span>"
		return 0
	else if(occupant)
		user << "<span class='warning'>Occupant detected!</span>"
		return 0
	else if(dna_lock && (!mmi_as_oc.brainmob.dna || dna_lock!=mmi_as_oc.brainmob.dna.unique_enzymes))
		user << "<span class='warning'>Access denied. [name] is secured with a DNA lock.</span>"
		return 0

	visible_message("<span class='notice'>[user] starts to insert an MMI into [name].</span>")

	if(do_after(user, 40, target = src))
		if(!occupant)
			return mmi_moved_inside(mmi_as_oc,user)
		else
			user << "<span class='warning'>Occupant detected!</span>"
	else
		user << "<span class='notice'>You stop inserting the MMI.</span>"
	return 0

/obj/mecha/proc/mmi_moved_inside(obj/item/device/mmi/mmi_as_oc,mob/user)
	if(mmi_as_oc && user in range(1))
		if(!mmi_as_oc.brainmob || !mmi_as_oc.brainmob.client)
			user << "<span class='notice'>Consciousness matrix not detected!</span>"
			return 0
		else if(mmi_as_oc.brainmob.stat)
			user << "<span class='warning'>Beta-rhythm below acceptable level!</span>"
			return 0
		if(!user.unEquip(mmi_as_oc))
			user << "<span class='warning'>\the [mmi_as_oc] is stuck to your hand, you cannot put it in \the [src]!</span>"
			return
		var/mob/brainmob = mmi_as_oc.brainmob
		occupant = brainmob
		brainmob.loc = src //should allow relaymove
		brainmob.reset_perspective(src)
		brainmob.canmove = 1
		mmi_as_oc.loc = src
		mmi_as_oc.mecha = src
		icon_state = initial(icon_state)
		setDir(dir_in)
		log_message("[mmi_as_oc] moved in as pilot.")
		if(!internal_damage)
			occupant << sound('sound/mecha/nominal.ogg',volume=50)
		GrantActions(brainmob)
		return 1
	else
		return 0

/obj/mecha/container_resist()
	go_out()


/obj/mecha/Exited(atom/movable/M, atom/newloc)
	if(occupant && occupant == M) // The occupant exited the mech without calling go_out()
		go_out(1, newloc)

/obj/mecha/proc/go_out(var/forced, var/atom/newloc = loc)
	if(!occupant)
		return
	var/atom/movable/mob_container
	occupant.clear_alert("charge")
	occupant.clear_alert("mech damage")
	if(ishuman(occupant))
		mob_container = occupant
		RemoveActions(occupant, human_occupant=1)
	else if(istype(occupant, /mob/living/carbon/brain))
		var/mob/living/carbon/brain/brain = occupant
		RemoveActions(brain)
		mob_container = brain.container
	else if(isAI(occupant) && forced) //This should only happen if there are multiple AIs in a round, and at least one is Malf.
		RemoveActions(occupant)
		occupant.gib()  //If one Malf decides to steal a mech from another AI (even other Malfs!), they are destroyed, as they have nowhere to go when replaced.
		occupant = null
		return
	else
		return
	var/mob/living/L = occupant
	occupant = null //we need it null when forceMove calls Exited().
	if(mob_container.forceMove(newloc))//ejecting mob container
		log_message("[mob_container] moved out.")
		L << browse(null, "window=exosuit")

		if(istype(mob_container, /obj/item/device/mmi))
			var/obj/item/device/mmi/mmi = mob_container
			if(mmi.brainmob)
				L.loc = mmi
				L.reset_perspective()
			mmi.mecha = null
			mmi.update_icon()
			L.canmove = 0
		icon_state = initial(icon_state)+"-open"
		setDir(dir_in)

	if(L && L.client)
		L.client.view = world.view
		zoom_mode = 0

/////////////////////////
////// Access stuff /////
/////////////////////////

/obj/mecha/proc/operation_allowed(mob/M)
	req_access = operation_req_access
	req_one_access = list()
	return allowed(M)

/obj/mecha/proc/internals_access_allowed(mob/M)
	req_one_access = internals_req_access
	req_access = list()
	return allowed(M)



////////////////////////////////
/////// Messages and Log ///////
////////////////////////////////

/obj/mecha/proc/occupant_message(message as text)
	if(message)
		if(occupant && occupant.client)
			occupant << "\icon[src] [message]"
	return

/obj/mecha/proc/log_message(message as text,red=null)
	log.len++
	log[log.len] = list("time"="[worldtime2text()]","date","year"="[year_integer+540]","message"="[red?"<font color='red'>":null][message][red?"</font>":null]")
	return log.len

/obj/mecha/proc/log_append_to_last(message as text,red=null)
	var/list/last_entry = log[log.len]
	last_entry["message"] += "<br>[red?"<font color='red'>":null][message][red?"</font>":null]"
	return

var/year = time2text(world.realtime,"YYYY")
var/year_integer = text2num(year) // = 2013???

///////////////////////
///// Power stuff /////
///////////////////////

/obj/mecha/proc/has_charge(amount)
	return (get_charge()>=amount)

/obj/mecha/proc/get_charge()
	for(var/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay/R in equipment)
		var/relay_charge = R.get_charge()
		if(relay_charge)
			return relay_charge
	if(cell)
		return max(0, cell.charge)

/obj/mecha/proc/use_power(amount)
	if(get_charge())
		cell.use(amount)
		return 1
	return 0

/obj/mecha/proc/give_power(amount)
	if(!isnull(get_charge()))
		cell.give(amount)
		return 1
	return 0

/obj/mecha/allow_drop()
	return 0

/obj/mecha/update_remote_sight(mob/living/user)
	if(occupant_sight_flags)
		if(user == occupant)
			user.sight |= occupant_sight_flags
