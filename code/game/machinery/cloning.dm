//Cloning revival method.
//The pod handles the actual cloning while the computer manages the clone profiles

//Potential replacement for genetics revives or something I dunno (?)

#define CLONE_INITIAL_DAMAGE     150    //Clones in clonepods start with 150 cloneloss damage and 150 brainloss damage, thats just logical
#define MINIMUM_HEAL_LEVEL 20

#define SPEAK(message) radio.talk_into(src, message, radio_channel)

/obj/machinery/clonepod
	name = "cloning pod"
	desc = "An electronically-lockable pod for growing organic tissue."
	density = TRUE
	icon = 'icons/obj/machines/cloning.dmi'
	icon_state = "pod_0"
	req_access = list(ACCESS_CLONING) //FOR PREMATURE UNLOCKING.
	verb_say = "states"
	circuit = /obj/item/circuitboard/machine/clonepod

	var/heal_level //The clone is released once its health reaches this level.
	var/obj/machinery/computer/cloning/connected = null //So we remember the connected clone machine.
	var/mess = FALSE //Need to clean out it if it's full of exploded clone.
	var/attempting = FALSE //One clone attempt at a time thanks
	var/speed_coeff
	var/efficiency

	var/datum/mind/clonemind
	var/grab_ghost_when = CLONER_MATURE_CLONE

	var/internal_radio = TRUE
	var/obj/item/radio/radio
	var/radio_key = /obj/item/encryptionkey/headset_med
	var/radio_channel = RADIO_CHANNEL_MEDICAL

	var/obj/effect/countdown/clonepod/countdown

	var/list/unattached_flesh
	var/flesh_number = 0
	var/datum/bank_account/current_insurance
	fair_market_price = 5 // He nodded, because he knew I was right. Then he swiped his credit card to pay me for arresting him.
	payment_department = ACCOUNT_MED

/obj/machinery/clonepod/Initialize()
	. = ..()

	countdown = new(src)

	if(internal_radio)
		radio = new(src)
		radio.keyslot = new radio_key
		radio.subspace_transmission = TRUE
		radio.canhear_range = 0
		radio.recalculateChannels()

	update_icon()

/obj/machinery/clonepod/Destroy()
	go_out()
	QDEL_NULL(radio)
	QDEL_NULL(countdown)
	if(connected)
		connected.DetachCloner(src)
	QDEL_LIST(unattached_flesh)
	. = ..()

/obj/machinery/clonepod/RefreshParts()
	speed_coeff = 0
	efficiency = 0
	for(var/obj/item/stock_parts/scanning_module/S in component_parts)
		efficiency += S.rating
	for(var/obj/item/stock_parts/manipulator/P in component_parts)
		speed_coeff += (P.rating / 2)
	speed_coeff = max(1, speed_coeff)
	heal_level = clamp((efficiency * 10) + 10, MINIMUM_HEAL_LEVEL, 100)

//The return of data disks?? Just for transferring between genetics machine/cloning machine.
//TO-DO: Make the genetics machine accept them.
/obj/item/disk/data
	name = "cloning data disk"
	icon_state = "datadisk0" //Gosh I hope syndies don't mistake them for the nuke disk.
	var/list/fields = list()
	var/list/mutations = list()
	var/max_mutations = 6
	var/read_only = 0 //Well,it's still a floppy disk

//Disk stuff.
/obj/item/disk/data/Initialize()
	. = ..()
	icon_state = "datadisk[rand(0,6)]"
	add_overlay("datadisk_gene")

/obj/item/disk/data/attack_self(mob/user)
	read_only = !read_only
	to_chat(user, "<span class='notice'>You flip the write-protect tab to [read_only ? "protected" : "unprotected"].</span>")

/obj/item/disk/data/examine(mob/user)
	. = ..()
	. += "The write-protect tab is set to [read_only ? "protected" : "unprotected"]."


//Clonepod

/obj/machinery/clonepod/examine(mob/user)
	. = ..()
	var/mob/living/mob_occupant = occupant
	. += "<span class='notice'>The <i>linking</i> device can be <i>scanned<i> with a multitool.</span>"
	if(mess)
		. += "It's filled with blood and viscera. You swear you can see it moving..."
	if(in_range(user, src) || isobserver(user))
		. += "<span class='notice'>The status display reads: Cloning speed at <b>[speed_coeff*50]%</b>.<br>Predicted amount of cellular damage: <b>[100-heal_level]%</b>.</span>"
		if(efficiency > 5)
			to_chat(user, "<span class='notice'>Pod has been upgraded to support autoprocessing.<span>")
	if(is_operational() && mob_occupant)
		if(mob_occupant.stat != DEAD)
			. += "Current clone cycle is [round(get_completion())]% complete."

/obj/machinery/clonepod/return_air()
	// We want to simulate the clone not being in contact with
	// the atmosphere, so we'll put them in a constant pressure
	// nitrogen. They don't need to breathe while cloning anyway.
	var/static/datum/gas_mixture/immutable/cloner/GM //global so that there's only one instance made for all cloning pods
	if(!GM)
		GM = new
	return GM

/obj/machinery/clonepod/proc/get_completion()
	. = FALSE
	var/mob/living/mob_occupant = occupant
	if(mob_occupant)
		. = (100 * ((mob_occupant.health + 100) / (heal_level + 100)))

/obj/machinery/clonepod/attack_ai(mob/user)
	return examine(user)

//Start growing a human clone in the pod!
/obj/machinery/clonepod/proc/growclone(ckey, clonename, ui, mutation_index, mindref, datum/species/mrace, list/features, factions, list/quirks, datum/bank_account/insurance)
	if(panel_open)
		return FALSE
	if(mess || attempting)
		return FALSE
	clonemind = locate(mindref) in SSticker.minds
	if(!istype(clonemind))	//not a mind
		return FALSE
	if(!QDELETED(clonemind.current))
		if(clonemind.current.stat != DEAD)	//mind is associated with a non-dead body
			return FALSE
		if(clonemind.current.suiciding) // Mind is associated with a body that is suiciding.
			return FALSE
		if(AmBloodsucker(clonemind.current)) //If the mind is a bloodsucker
			return FALSE
	if(clonemind.active)	//somebody is using that mind
		if( ckey(clonemind.key)!=ckey )
			return FALSE
	else
		// get_ghost() will fail if they're unable to reenter their body
		var/mob/dead/observer/G = clonemind.get_ghost()
		if(!G)
			return FALSE
		if(G.suiciding) // The ghost came from a body that is suiciding.
			return FALSE
	if(clonemind.damnation_type) //Can't clone the damned.
		INVOKE_ASYNC(src, .proc/horrifyingsound)
		mess = TRUE
		update_icon()
		return FALSE
	current_insurance = insurance
	attempting = TRUE //One at a time!!
	countdown.start()

	var/mob/living/carbon/human/H = new /mob/living/carbon/human(src)

	H.hardset_dna(ui, mutation_index, H.real_name, null, mrace, features)

	H.easy_randmut(NEGATIVE+MINOR_NEGATIVE) //100% bad mutation. Can be cured with mutadone.

	H.silent = 20 //Prevents an extreme edge case where clones could speak if they said something at exactly the right moment.
	occupant = H

	if(!clonename)	//to prevent null names
		clonename = "clone ([rand(1,999)])"
	H.real_name = clonename

	//Get the clone body ready
	maim_clone(H)
	ADD_TRAIT(H, TRAIT_MUTATION_STASIS, CLONING_POD_TRAIT)
	ADD_TRAIT(H, TRAIT_STABLEHEART, CLONING_POD_TRAIT)
	ADD_TRAIT(H, TRAIT_STABLELIVER, CLONING_POD_TRAIT)
	ADD_TRAIT(H, TRAIT_EMOTEMUTE, CLONING_POD_TRAIT)
	ADD_TRAIT(H, TRAIT_MUTE, CLONING_POD_TRAIT)
	ADD_TRAIT(H, TRAIT_NOBREATH, CLONING_POD_TRAIT)
	ADD_TRAIT(H, TRAIT_NOCRITDAMAGE, CLONING_POD_TRAIT)
	H.Unconscious(80)

	clonemind.transfer_to(H)

	if(grab_ghost_when == CLONER_FRESH_CLONE)
		H.grab_ghost()
		to_chat(H, "<span class='notice'><b>Consciousness slowly creeps over you as your body regenerates.</b><br><i>So this is what cloning feels like?</i></span>")

	if(grab_ghost_when == CLONER_MATURE_CLONE)
		H.ghostize(TRUE)	//Only does anything if they were still in their old body and not already a ghost
		to_chat(H.get_ghost(TRUE), "<span class='notice'>Your body is beginning to regenerate in a cloning pod. You will become conscious when it is complete.</span>")

	if(H)
		H.faction |= factions

		for(var/V in quirks)
			var/datum/quirk/Q = new V(H)
			Q.on_clone(quirks[V])

		H.set_cloned_appearance()
		H.give_genitals(TRUE)

		H.suiciding = FALSE
	attempting = FALSE
	return TRUE

//Grow clones to maturity then kick them out.  FREELOADERS
/obj/machinery/clonepod/process()
	var/mob/living/mob_occupant = occupant

	if(!is_operational()) //Autoeject if power is lost
		if(mob_occupant)
			go_out()
			mob_occupant.copy_from_prefs_vr()
			connected_message("Clone Ejected: Loss of power.")

	else if(mob_occupant && (mob_occupant.loc == src))
		if(SSeconomy.full_ancap)
			if(!current_insurance)
				go_out()
				connected_message("Clone Ejected: No bank account.")
				if(internal_radio)
					SPEAK("The cloning of [mob_occupant.real_name] has been terminated due to no bank account to draw payment from.")
			else if(!current_insurance.adjust_money(-fair_market_price))
				go_out()
				connected_message("Clone Ejected: Out of Money.")
				if(internal_radio)
					SPEAK("The cloning of [mob_occupant.real_name] has been ended prematurely due to being unable to pay.")
			else
				var/datum/bank_account/D = SSeconomy.get_dep_account(payment_department)
				if(D)
					D.adjust_money(fair_market_price)
		if(mob_occupant && (mob_occupant.stat == DEAD) || (mob_occupant.suiciding) || mob_occupant.hellbound)  //Autoeject corpses and suiciding dudes.			connected_message("Clone Rejected: Deceased.")
			if(internal_radio)
				SPEAK("The cloning has been \
					aborted due to unrecoverable tissue failure.")
			go_out()
			mob_occupant.copy_from_prefs_vr()

		else if(mob_occupant && mob_occupant.cloneloss > (100 - heal_level))
			mob_occupant.Unconscious(80)
			var/dmg_mult = CONFIG_GET(number/damage_multiplier)
			 //Slowly get that clone healed and finished.
			mob_occupant.adjustCloneLoss(-((speed_coeff / 2) * dmg_mult))
			var/progress = CLONE_INITIAL_DAMAGE - mob_occupant.getCloneLoss()
			// To avoid the default cloner making incomplete clones
			progress += (100 - MINIMUM_HEAL_LEVEL)
			var/milestone = CLONE_INITIAL_DAMAGE / flesh_number
			var/installed = flesh_number - unattached_flesh.len

			if((progress / milestone) >= installed)
				// attach some flesh
				var/obj/item/I = pick_n_take(unattached_flesh)
				if(isorgan(I))
					var/obj/item/organ/O = I
					O.organ_flags &= ~ORGAN_FROZEN
					O.Insert(mob_occupant)
				else if(isbodypart(I))
					var/obj/item/bodypart/BP = I
					BP.attach_limb(mob_occupant)

			//Premature clones may have brain damage.
			mob_occupant.adjustOrganLoss(ORGAN_SLOT_BRAIN, -((speed_coeff / 2) * dmg_mult))

			use_power(7500) //This might need tweaking.

		else if((mob_occupant && mob_occupant.cloneloss <= (100 - heal_level)))
			connected_message("Cloning Process Complete.")
			if(internal_radio)
				SPEAK("The cloning cycle is complete.")

			// If the cloner is upgraded to debugging high levels, sometimes
			// organs and limbs can be missing.
			for(var/i in unattached_flesh)
				if(isorgan(i))
					var/obj/item/organ/O = i
					O.organ_flags &= ~ORGAN_FROZEN
					O.Insert(mob_occupant)
				else if(isbodypart(i))
					var/obj/item/bodypart/BP = i
					BP.attach_limb(mob_occupant)

			go_out()
			mob_occupant.copy_from_prefs_vr()

	else if (!mob_occupant || mob_occupant.loc != src)
		occupant = null
		use_power(200)

	update_icon()

//Let's unlock this early I guess.  Might be too early, needs tweaking.
/obj/machinery/clonepod/attackby(obj/item/W, mob/user, params)
	if(!(occupant || mess))
		if(default_deconstruction_screwdriver(user, "[icon_state]_maintenance", "[initial(icon_state)]",W))
			return

	if(default_deconstruction_crowbar(W))
		return

	if(istype(W, /obj/item/multitool))
		var/obj/item/multitool/P = W

		if(istype(P.buffer, /obj/machinery/computer/cloning))
			if(get_area(P.buffer) != get_area(src))
				to_chat(user, "<font color = #666633>-% Cannot link machines across power zones. Buffer cleared %-</font color>")
				P.buffer = null
				return
			to_chat(user, "<font color = #666633>-% Successfully linked [P.buffer] with [src] %-</font color>")
			var/obj/machinery/computer/cloning/comp = P.buffer
			if(connected)
				connected.DetachCloner(src)
			comp.AttachCloner(src)
		else
			P.buffer = src
			to_chat(user, "<font color = #666633>-% Successfully stored [REF(P.buffer)] [P.buffer.name] in buffer %-</font color>")
		return

	var/mob/living/mob_occupant = occupant
	if(W.GetID())
		if(!check_access(W))
			to_chat(user, "<span class='danger'>Access Denied.</span>")
			return
		if(!(mob_occupant || mess))
			to_chat(user, "<span class='danger'>Error: Pod has no occupant.</span>")
			return
		else
			connected_message("Emergency Ejection")
			SPEAK("An emergency ejection of the current clone has occurred. Survival not guaranteed.")
			to_chat(user, "<span class='notice'>You force an emergency ejection. </span>")
			go_out()
			mob_occupant.copy_from_prefs_vr()
	else
		return ..()

/obj/machinery/clonepod/emag_act(mob/user)
	. = ..()
	if(!occupant)
		return
	to_chat(user, "<span class='warning'>You corrupt the genetic compiler.</span>")
	malfunction()
	return TRUE

//Put messages in the connected computer's temp var for display.
/obj/machinery/clonepod/proc/connected_message(message)
	if ((isnull(connected)) || (!istype(connected, /obj/machinery/computer/cloning)))
		return FALSE
	if (!message)
		return FALSE

	connected.temp = message
	connected.updateUsrDialog()
	return TRUE

/obj/machinery/clonepod/proc/go_out()
	countdown.stop()
	var/mob/living/mob_occupant = occupant
	var/turf/T = get_turf(src)

	if(mess) //Clean that mess and dump those gibs!
		for(var/obj/fl in unattached_flesh)
			fl.forceMove(T)
			if(istype(fl, /obj/item/organ))
				var/obj/item/organ/O = fl
				O.organ_flags &= ~ORGAN_FROZEN
		unattached_flesh.Cut()
		mess = FALSE
		if(mob_occupant)
			mob_occupant.spawn_gibs()
		audible_message("<span class='italics'>You hear a splat.</span>")
		update_icon()
		return

	if(!mob_occupant)
		return
	current_insurance = null
	REMOVE_TRAIT(mob_occupant, TRAIT_STABLEHEART, CLONING_POD_TRAIT)
	REMOVE_TRAIT(mob_occupant, TRAIT_MUTATION_STASIS, CLONING_POD_TRAIT)
	REMOVE_TRAIT(mob_occupant, TRAIT_STABLELIVER, CLONING_POD_TRAIT)
	REMOVE_TRAIT(mob_occupant, TRAIT_EMOTEMUTE, CLONING_POD_TRAIT)
	REMOVE_TRAIT(mob_occupant, TRAIT_MUTE, CLONING_POD_TRAIT)
	REMOVE_TRAIT(mob_occupant, TRAIT_NOCRITDAMAGE, CLONING_POD_TRAIT)
	REMOVE_TRAIT(mob_occupant, TRAIT_NOBREATH, CLONING_POD_TRAIT)

	if(grab_ghost_when == CLONER_MATURE_CLONE)
		mob_occupant.grab_ghost()
		to_chat(occupant, "<span class='notice'><b>There is a bright flash!</b><br><i>You feel like a new being.</i></span>")
		mob_occupant.flash_act()

	occupant.forceMove(T)
	update_icon()
	mob_occupant.domutcheck(1) //Waiting until they're out before possible monkeyizing. The 1 argument forces powers to manifest.
	for(var/fl in unattached_flesh)
		qdel(fl)
	unattached_flesh.Cut()

	occupant = null

/obj/machinery/clonepod/proc/malfunction()
	var/mob/living/mob_occupant = occupant
	if(mob_occupant)
		connected_message("Critical Error!")
		SPEAK("Critical error! Please contact a Thinktronic Systems \
			technician, as your warranty may be affected.")
		mess = TRUE
		maim_clone(mob_occupant)	//Remove every bit that's grown back so far to drop later, also destroys bits that haven't grown yet
		update_icon()
		if(mob_occupant.mind != clonemind)
			clonemind.transfer_to(mob_occupant)
		mob_occupant.grab_ghost() // We really just want to make you suffer.
		flash_color(mob_occupant, flash_color="#960000", flash_time=100)
		to_chat(mob_occupant, "<span class='warning'><b>Agony blazes across your consciousness as your body is torn apart.</b><br><i>Is this what dying is like? Yes it is.</i></span>")
		playsound(src.loc, 'sound/machines/warning-buzzer.ogg', 50, 0)
		SEND_SOUND(mob_occupant, sound('sound/hallucinations/veryfar_noise.ogg',0,1,50))
		QDEL_IN(mob_occupant, 40)

/obj/machinery/clonepod/relaymove(mob/user)
	container_resist(user)

/obj/machinery/clonepod/container_resist(mob/living/user)
	if(user.stat == CONSCIOUS)
		go_out()

/obj/machinery/clonepod/emp_act(severity)
	. = ..()
	if (!(. & EMP_PROTECT_SELF))
		var/mob/living/mob_occupant = occupant
		if(mob_occupant && prob(100/(severity*efficiency)))
			connected_message(Gibberish("EMP-caused Accidental Ejection", 0))
			SPEAK(Gibberish("Exposure to electromagnetic fields has caused the ejection of, ERROR: John Doe, prematurely." ,0))
			mob_occupant.copy_from_prefs_vr()
			go_out()

/obj/machinery/clonepod/ex_act(severity, target)
	..()
	if(!QDELETED(src))
		go_out()

/obj/machinery/clonepod/handle_atom_del(atom/A)
	if(A == occupant)
		occupant = null
		countdown.stop()

/obj/machinery/clonepod/proc/horrifyingsound()
	for(var/i in 1 to 5)
		playsound(loc,pick('sound/hallucinations/growl1.ogg','sound/hallucinations/growl2.ogg','sound/hallucinations/growl3.ogg'), 100, rand(0.95,1.05))
		sleep(1)
	sleep(10)
	playsound(loc,'sound/hallucinations/wail.ogg',100,1)

/obj/machinery/clonepod/deconstruct(disassembled = TRUE)
	if(occupant)
		go_out()
	..()

/obj/machinery/clonepod/proc/maim_clone(mob/living/carbon/human/H)
	if(!unattached_flesh)
		unattached_flesh = list()
	else
		for(var/fl in unattached_flesh)
			qdel(fl)
		unattached_flesh.Cut()

	H.setCloneLoss(CLONE_INITIAL_DAMAGE)     //Yeah, clones start with very low health, not with random, because why would they start with random health
	//H.setOrganLoss(ORGAN_SLOT_BRAIN, CLONE_INITIAL_DAMAGE)
	// In addition to being cellularly damaged and having barely any

	// brain function, they also have no limbs or internal organs.

	if(!HAS_TRAIT(H, TRAIT_NODISMEMBER))
		var/static/list/zones = list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)
		for(var/zone in zones)
			var/obj/item/bodypart/BP = H.get_bodypart(zone)
			if(BP)
				BP.drop_limb()
				BP.forceMove(src)
				unattached_flesh += BP

	for(var/o in H.internal_organs)
		var/obj/item/organ/organ = o
		if(!istype(organ) || (organ.organ_flags & ORGAN_VITAL))
			continue
		organ.organ_flags |= ORGAN_FROZEN
		organ.Remove(TRUE)
		organ.forceMove(src)
		unattached_flesh += organ

	flesh_number = unattached_flesh.len

/obj/machinery/clonepod/update_icon_state()
	if(mess)
		icon_state = "pod_g"
	else if(occupant)
		icon_state = "pod_1"
	else
		icon_state = "pod_0"

	if(panel_open)
		icon_state = "pod_0_maintenance"

/obj/machinery/clonepod/update_overlays()
	. = ..()
	if(mess)
		var/mutable_appearance/gib1 = mutable_appearance(CRYOMOBS, "gibup")
		var/mutable_appearance/gib2 = mutable_appearance(CRYOMOBS, "gibdown")
		gib1.pixel_y = 27 + round(sin(world.time) * 3)
		gib1.pixel_x = round(sin(world.time * 3))
		gib2.pixel_y = 27 + round(cos(world.time) * 3)
		gib2.pixel_x = round(cos(world.time * 3))
		. += gib2
		. += gib1
	else if(occupant)
		var/mutable_appearance/occupant_overlay
		var/completion = (flesh_number - unattached_flesh.len) / flesh_number

		if(unattached_flesh.len <= 0)
			occupant_overlay = mutable_appearance(occupant.icon, occupant.icon_state)
			occupant_overlay.copy_overlays(occupant)
			. += "cover-on"
		else
			occupant_overlay = mutable_appearance(CRYOMOBS, "clone_meat")
			var/matrix/tform = matrix()
			tform.Scale(completion)
			tform.Turn(cos(world.time * 2) * 3)
			occupant_overlay.transform = tform
			occupant_overlay.appearance_flags = NONE

		occupant_overlay.dir = SOUTH
		occupant_overlay.pixel_y = 27 + round(sin(world.time) * 3)
		occupant_overlay.pixel_x = round(sin(world.time * 3))

		. += occupant_overlay
		. += "cover-on"
	. += "panel"

/*
 *	Manual -- A big ol' manual.
 */

/obj/item/paper/guides/jobs/medical/cloning
	name = "paper - 'H-87 Cloning Apparatus Manual"
	info = {"<h4>Getting Started</h4>
	Congratulations, your station has purchased the H-87 industrial cloning device!<br>
	Using the H-87 is almost as simple as brain surgery! Simply insert the target humanoid into the scanning chamber and select the scan option to create a new profile!<br>
	<b>That's all there is to it!</b><br>
	<i>Notice, cloning system cannot scan inorganic life or small primates.  Scan may fail if subject has suffered extreme brain damage.</i><br>
	<p>Clone profiles may be viewed through the profiles menu. Scanning implants a complementary HEALTH MONITOR IMPLANT into the subject, which may be viewed from each profile.
	Profile Deletion has been restricted to \[Station Head\] level access.</p>
	<h4>Cloning from a profile</h4>
	Cloning is as simple as pressing the CLONE option at the bottom of the desired profile.<br>
	Per your company's EMPLOYEE PRIVACY RIGHTS agreement, the H-87 has been blocked from cloning crewmembers while they are still alive.<br>
	<br>
	<p>The provided CLONEPOD SYSTEM will produce the desired clone.  Standard clone maturation times (With SPEEDCLONE technology) are roughly 90 seconds.
	The cloning pod may be unlocked early with any \[Medical Researcher\] ID after initial maturation is complete.</p><br>
	<i>Please note that resulting clones may have a small DEVELOPMENTAL DEFECT as a result of genetic drift.</i><br>
	<h4>Profile Management</h4>
	<p>The H-87 (as well as your station's standard genetics machine) can accept STANDARD DATA DISKETTES.
	These diskettes are used to transfer genetic information between machines and profiles.
	A load/save dialog will become available in each profile if a disk is inserted.</p><br>
	<i>A good diskette is a great way to counter aforementioned genetic drift!</i><br>
	<br>
	<font size=1>This technology produced under license from Thinktronic Systems, LTD.</font>"}

#undef CLONE_INITIAL_DAMAGE
#undef SPEAK
#undef MINIMUM_HEAL_LEVEL
