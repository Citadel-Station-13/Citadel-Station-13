/*
	Cuts
*/

/datum/wound/slash
	sound_effect = 'sound/weapons/slice.ogg'
	processes = TRUE
	wound_type = WOUND_SLASH
	treatable_by = list(/obj/item/stack/medical/suture)
	treatable_by_grabbed = list(/obj/item/gun/energy/laser)
	treatable_tool = TOOL_CAUTERY
	base_treat_time = 3 SECONDS
	wound_flags = (FLESH_WOUND | ACCEPTS_GAUZE)

	/// How much blood we start losing when this wound is first applied
	var/initial_flow
	/// When we have less than this amount of flow, either from treatment or clotting, we demote to a lower cut or are healed of the wound
	var/minimum_flow
	/// How fast our blood flow will naturally decrease per tick, not only do larger cuts bleed more faster, they clot slower
	var/clot_rate

	/// Once the blood flow drops below minimum_flow, we demote it to this type of wound. If there's none, we're all better
	var/demotes_to

	/// How much staunching per type (cautery, suturing, bandaging) you can have before that type is no longer effective for this cut NOT IMPLEMENTED
	var/max_per_type
	/// The maximum flow we've had so far
	var/highest_flow

	/// A bad system I'm using to track the worst scar we earned (since we can demote, we want the biggest our wound has been, not what it was when it was cured (probably moderate))
	var/datum/scar/highest_scar

/datum/wound/slash/wound_injury(datum/wound/slash/old_wound = null)
	blood_flow = initial_flow
	if(old_wound)
		blood_flow = max(old_wound.blood_flow, initial_flow)
		if(old_wound.severity > severity && old_wound.highest_scar)
			highest_scar = old_wound.highest_scar
			old_wound.highest_scar = null

	if(!highest_scar)
		highest_scar = new
		highest_scar.generate(limb, src, add_to_scars=FALSE)

/datum/wound/slash/remove_wound(ignore_limb, replaced)
	if(!replaced && highest_scar)
		already_scarred = TRUE
		highest_scar.lazy_attach(limb)
	return ..()

/datum/wound/slash/get_examine_description(mob/user)
	if(!limb.current_gauze)
		return ..()

	var/list/msg = list("The cuts on [victim.p_their()] [limb.name] are wrapped with")
	// how much life we have left in these bandages
	switch(limb.current_gauze.absorption_capacity)
		if(0 to 1.25)
			msg += "nearly ruined "
		if(1.25 to 2.75)
			msg += "badly worn "
		if(2.75 to 4)
			msg += "slightly bloodied "
		if(4 to INFINITY)
			msg += "clean "
	msg += "[limb.current_gauze.name]!"

	return "<B>[msg.Join()]</B>"

/datum/wound/slash/receive_damage(wounding_type, wounding_dmg, wound_bonus)
	if(victim.stat != DEAD && wounding_type == WOUND_SLASH) // can't stab dead bodies to make it bleed faster this way
		blood_flow += 0.05 * wounding_dmg

/datum/wound/slash/drag_bleed_amount()
	// say we have 3 severe cuts with 3 blood flow each, pretty reasonable
	// compare with being at 100 brute damage before, where you bled (brute/100 * 2), = 2 blood per tile
	var/bleed_amt = min(blood_flow * 0.1, 1) // 3 * 3 * 0.1 = 0.9 blood total, less than before! the share here is .3 blood of course.

	if(limb.current_gauze) // gauze stops all bleeding from dragging on this limb, but wears the gauze out quicker
		limb.seep_gauze(bleed_amt * 0.33)
		return

	return bleed_amt

/datum/wound/slash/handle_process()
	if(victim.stat == DEAD)
		blood_flow -= max(clot_rate, WOUND_SLASH_DEAD_CLOT_MIN)
		if(blood_flow < minimum_flow)
			if(demotes_to)
				replace_wound(demotes_to)
				return
			qdel(src)
			return

	blood_flow = min(blood_flow, WOUND_SLASH_MAX_BLOODFLOW)

	if(victim.reagents?.has_reagent(/datum/reagent/toxin/heparin))
		blood_flow += 0.5 // old herapin used to just add +2 bleed stacks per tick, this adds 0.5 bleed flow to all open cuts which is probably even stronger as long as you can cut them first

	if(limb.current_gauze)
		if(clot_rate > 0)
			blood_flow -= clot_rate
		blood_flow -= limb.current_gauze.absorption_rate
		limb.seep_gauze(limb.current_gauze.absorption_rate)
	else
		blood_flow -= clot_rate

	if(blood_flow > highest_flow)
		highest_flow = blood_flow

	if(blood_flow < minimum_flow)
		if(demotes_to)
			replace_wound(demotes_to)
		else
			to_chat(victim, "<span class='green'>The cut on your [limb.name] has stopped bleeding!</span>")
			qdel(src)


/datum/wound/slash/on_stasis()
	if(blood_flow >= minimum_flow)
		return
	if(demotes_to)
		replace_wound(demotes_to)
		return
	qdel(src)

/* BEWARE, THE BELOW NONSENSE IS MADNESS. bones.dm looks more like what I have in mind and is sufficiently clean, don't pay attention to this messiness */

/datum/wound/slash/check_grab_treatments(obj/item/I, mob/user)
	if(istype(I, /obj/item/gun/energy/laser))
		return TRUE

/datum/wound/slash/treat(obj/item/I, mob/user)
	if(istype(I, /obj/item/gun/energy/laser))
		las_cauterize(I, user)
	else if(I.tool_behaviour == TOOL_CAUTERY || I.get_temperature() > 300)
		tool_cauterize(I, user)
	else if(istype(I, /obj/item/stack/medical/suture))
		suture(I, user)

/datum/wound/slash/try_handling(mob/living/carbon/human/user)
	if(user.pulling != victim || user.zone_selected != limb.body_zone || user.a_intent == INTENT_GRAB)
		return FALSE

	if(!iscatperson(user))
		return FALSE

	lick_wounds(user)
	return TRUE

/// if a felinid is licking this cut to reduce bleeding
/datum/wound/slash/proc/lick_wounds(mob/living/carbon/human/user)
	if(INTERACTING_WITH(user, victim))
		to_chat(user, "<span class='warning'>You're already interacting with [victim]!</span>")
		return

	if(user.is_mouth_covered())
		to_chat(user, "<span class='warning'>Your mouth is covered, you can't lick [victim]'s wounds!</span>")
		return

	if(!user.getorganslot(ORGAN_SLOT_TONGUE))
		to_chat(user, "<span class='warning'>You can't lick wounds without a tongue!</span>") // f in chat
		return

	// transmission is one way patient -> felinid since google said cat saliva is antiseptic or whatever, and also because felinids are already risking getting beaten for this even without people suspecting they're spreading a deathvirus
	for(var/datum/disease/D in victim.diseases)
		user.ForceContractDisease(D)

	user.visible_message("<span class='notice'>[user] begins licking the wounds on [victim]'s [limb.name].</span>", "<span class='notice'>You begin licking the wounds on [victim]'s [limb.name]...</span>", ignored_mobs=victim)
	to_chat(victim, "<span class='notice'>[user] begins to lick the wounds on your [limb.name].</span")
	if(!do_after(user, base_treat_time, target=victim, extra_checks = CALLBACK(src, .proc/still_exists)))
		return

	user.visible_message("<span class='notice'>[user] licks the wounds on [victim]'s [limb.name].</span>", "<span class='notice'>You lick some of the wounds on [victim]'s [limb.name]</span>", ignored_mobs=victim)
	to_chat(victim, "<span class='green'>[user] licks the wounds on your [limb.name]!</span")
	blood_flow -= 0.5
	if(isinsect(victim) || iscatperson(victim) || ismammal(victim) || isdwarf(victim) || ismonkey(victim)) // Yep you can lick monkeys.
		user.reagents.add_reagent(/datum/reagent/hairball, 2)

	else if(ishumanbasic(victim) || isflyperson(victim) || islizard(victim) || isdullahan(victim))
		user.reagents.add_reagent(/datum/reagent/hairball, 1)

	if(blood_flow > minimum_flow)
		try_handling(user)
	else if(demotes_to)
		to_chat(user, "<span class='green'>You successfully lower the severity of [victim]'s cuts.</span>")

/datum/wound/slash/on_xadone(power)
	. = ..()
	blood_flow -= 0.03 * power // i think it's like a minimum of 3 power, so .09 blood_flow reduction per tick is pretty good for 0 effort

/datum/wound/slash/on_synthflesh(power)
	. = ..()
	blood_flow -= 0.075 * power // 20u * 0.075 = -1.5 blood flow, pretty good for how little effort it is

/// If someone's putting a laser gun up to our cut to cauterize it
/datum/wound/slash/proc/las_cauterize(obj/item/gun/energy/laser/lasgun, mob/user)
	var/self_penalty_mult = (user == victim ? 1.25 : 1)
	user.visible_message("<span class='warning'>[user] begins aiming [lasgun] directly at [victim]'s [limb.name]...</span>", "<span class='userdanger'>You begin aiming [lasgun] directly at [user == victim ? "your" : "[victim]'s"] [limb.name]...</span>")
	if(!do_after(user, base_treat_time  * self_penalty_mult, target=victim, extra_checks = CALLBACK(src, .proc/still_exists)))
		return
	var/damage = lasgun.chambered.BB.damage
	lasgun.chambered.BB.wound_bonus -= 30
	lasgun.chambered.BB.damage *= self_penalty_mult
	if(!lasgun.process_fire(victim, victim, TRUE, null, limb.body_zone))
		return
	victim.emote("scream")
	blood_flow -= damage / (5 * self_penalty_mult) // 20 / 5 = 4 bloodflow removed, p good
	victim.visible_message("<span class='warning'>The cuts on [victim]'s [limb.name] scar over!</span>")

/// If someone is using either a cautery tool or something with heat to cauterize this cut
/datum/wound/slash/proc/tool_cauterize(obj/item/I, mob/user)
	var/self_penalty_mult = (user == victim ? 1.5 : 1)
	user.visible_message("<span class='danger'>[user] begins cauterizing [victim]'s [limb.name] with [I]...</span>", "<span class='danger'>You begin cauterizing [user == victim ? "your" : "[victim]'s"] [limb.name] with [I]...</span>")
	if(!do_after(user, base_treat_time * self_penalty_mult, target=victim, extra_checks = CALLBACK(src, .proc/still_exists)))
		return

	user.visible_message("<span class='green'>[user] cauterizes some of the bleeding on [victim].</span>", "<span class='green'>You cauterize some of the bleeding on [victim].</span>")
	limb.receive_damage(burn = 2 + severity, wound_bonus = CANT_WOUND)
	if(prob(30))
		victim.emote("scream")
	var/blood_cauterized = (0.6 / self_penalty_mult)
	blood_flow -= blood_cauterized

	if(blood_flow > minimum_flow)
		try_treating(I, user)
	else if(demotes_to)
		to_chat(user, "<span class='green'>You successfully lower the severity of [user == victim ? "your" : "[victim]'s"] cuts.</span>")

/// If someone is using a suture to close this cut
/datum/wound/slash/proc/suture(obj/item/stack/medical/suture/I, mob/user)
	var/self_penalty_mult = (user == victim ? 1.4 : 1)
	user.visible_message("<span class='notice'>[user] begins stitching [victim]'s [limb.name] with [I]...</span>", "<span class='notice'>You begin stitching [user == victim ? "your" : "[victim]'s"] [limb.name] with [I]...</span>")

	if(!do_after(user, base_treat_time * self_penalty_mult, target=victim, extra_checks = CALLBACK(src, .proc/still_exists)))
		return
	user.visible_message("<span class='green'>[user] stitches up some of the bleeding on [victim].</span>", "<span class='green'>You stitch up some of the bleeding on [user == victim ? "yourself" : "[victim]"].</span>")
	var/blood_sutured = I.stop_bleeding / self_penalty_mult
	blood_flow -= blood_sutured
	limb.heal_damage(I.heal_brute, I.heal_burn)

	if(blood_flow > minimum_flow)
		try_treating(I, user)
	else if(demotes_to)
		to_chat(user, "<span class='green'>You successfully lower the severity of [user == victim ? "your" : "[victim]'s"] cuts.</span>")


/datum/wound/slash/moderate
	name = "Rough Abrasion"
	desc = "Patient's skin has been badly scraped, generating moderate blood loss."
	treat_text = "Application of clean bandages or first-aid grade sutures, followed by food and rest."
	examine_desc = "has an open cut"
	occur_text = "is cut open, slowly leaking blood"
	sound_effect = 'sound/effects/wounds/blood1.ogg'
	severity = WOUND_SEVERITY_MODERATE
	initial_flow = 1.5
	minimum_flow = 0.375
	max_per_type = 3
	clot_rate = 0.12
	threshold_minimum = 30
	threshold_penalty = 10
	status_effect_type = /datum/status_effect/wound/slash/moderate
	scar_keyword = "slashmoderate"

/datum/wound/slash/severe
	name = "Open Laceration"
	desc = "Patient's skin is ripped clean open, allowing significant blood loss."
	treat_text = "Speedy application of first-aid grade sutures and clean bandages, followed by vitals monitoring to ensure recovery."
	examine_desc = "has a severe cut"
	occur_text = "is ripped open, veins spurting blood"
	sound_effect = 'sound/effects/wounds/blood2.ogg'
	severity = WOUND_SEVERITY_SEVERE
	initial_flow = 2.4375
	minimum_flow = 2.0625
	clot_rate = 0.07
	max_per_type = 4
	threshold_minimum = 60
	threshold_penalty = 25
	demotes_to = /datum/wound/slash/moderate
	status_effect_type = /datum/status_effect/wound/slash/severe
	scar_keyword = "slashsevere"

/datum/wound/slash/critical
	name = "Weeping Avulsion"
	desc = "Patient's skin is completely torn open, along with significant loss of tissue. Extreme blood loss will lead to quick death without intervention."
	treat_text = "Immediate bandaging and either suturing or cauterization, followed by supervised resanguination."
	examine_desc = "is carved down to the bone, spraying blood wildly"
	occur_text = "is torn open, spraying blood wildly"
	sound_effect = 'sound/effects/wounds/blood3.ogg'
	severity = WOUND_SEVERITY_CRITICAL
	initial_flow = 3.1875
	minimum_flow = 3
	clot_rate = -0.05 // critical cuts actively get worse instead of better
	max_per_type = 5
	threshold_minimum = 90
	threshold_penalty = 40
	demotes_to = /datum/wound/slash/severe
	status_effect_type = /datum/status_effect/wound/slash/critical
	scar_keyword = "slashcritical"
	wound_flags = (FLESH_WOUND | ACCEPTS_GAUZE | MANGLES_FLESH)
