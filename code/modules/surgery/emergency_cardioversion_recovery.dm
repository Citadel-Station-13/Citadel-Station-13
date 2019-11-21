/datum/surgery/cardioversion
	name = "Emergency Cardioversion Induction"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/saw, /datum/surgery_step/clamp_bleeders,
				 /datum/surgery_step/incise_heart, /datum/surgery_step/ventricular_electrotherapy, /datum/surgery_step/close)
	possible_locs = list(BODY_ZONE_CHEST)

/datum/surgery_step/ventricular_electrotherapy
	name = "ventricular electrotherapy"
	implements = list(/obj/item/twohanded/shockpaddles = 90, /obj/item/defibrillator = 75, /obj/item/inducer = 55, /obj/item/stock_parts/cell = 25) //Just because the idea of a new player using the whole magine to defib is hillarious to me
	time = 50
	repeatable = TRUE //So you can retry

/datum/surgery_step/incise_heart/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>You begin apply an electrical charge directly to the heart and across the body...</span>",
		"[user] begins to make an incision in [target]'s heart.",
		"[user] begins to make an incision in [target]'s heart.")
	target.notify_ghost_cloning("Your heart is undergoing Emergency Cardioversion Induction!")
	playsound(src, 'sound/machines/defib_charge.ogg', 75, 0)

/datum/surgery_step/incise_heart/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/mob/living/carbon/human/H = target
	playsound(src, 'sound/machines/defib_zap.ogg', 75, 1, -1)
	playsound(src, "bodyfall", 50, 1)
	if(H.stat != DEAD)
		display_results(user, target, "<span class='warning'>You can't use this procedure on the living! [H]'s body flops madly like a wild fish on the table from the current, and your crazed surgical methods.</span>",
			"<span class='warning'>[user] screws up, causing [H] to flop around violently as they're zapped!</span>",
			"<span class='warning'>[user] screws up, causing [H] to flop around violently as they're zapped!</span>")
		M.emote("scream")
		H.electrocute_act(25, (get_turf(C)), 1, FALSE, FALSE, FALSE, TRUE)
		H.emote("flip")
		H.Jitter(100)
		return FALSE
	display_results(user, target, "<span class='notice'>induces a stable rythum in [H]'s heart.</span>",
		"[H]'s heart is shocked, attemping to bring them back to a stable rythum!.",
		"")
	if (!(NOBLOOD in H.dna.species.species_traits))
		H.bleed_rate += 10
	H.adjustBruteLoss(10)
	H.adjustOrganLoss(ORGAN_SLOT_HEART, -10)
	H.adjustOrganLoss(ORGAN_SLOT_BRAIN, -5)
	H.electrocute_act(0, (get_turf(C)), 1, FALSE, FALSE, FALSE, TRUE)
	if(!do_they_live(H))
		playsound(src, 'sound/machines/defib_failed.ogg', 50, 0)
	return TRUE

/datum/surgery_step/incise_heart/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	playsound(src, 'sound/machines/defib_zap.ogg', 75, 1, -1)
	playsound(src, "bodyfall", 50, 1)
	var/mob/living/carbon/human/H = target
	display_results(user, target, "<span class='warning'>You screw up, sending current racing though their body!</span>",
		"<span class='warning'>[user] screws up, causing [H] to flop around violently as they're zapped!</span>",
		"<span class='warning'>[user] screws up, causing [H] to flop around violently as they're zapped!</span>")
	H.electrocute_act(25, (get_turf(C)), 1, FALSE, FALSE, FALSE, TRUE)
	H.emote("flip")
	H.adjustOrganLoss(ORGAN_SLOT_HEART, 10)

/datum/surgery_step/incise_heart/do_they_live(mob/living/carbon/human/H)

	var/obj/item/organ/heart = H.getorgan(/obj/item/organ/heart)
	H.visible_message("<span class='warning'>[H]'s body convulses a bit.</span>")
	total_brute	= H.getBruteLoss()
	total_burn	= H.getFireLoss()
	shock_touching(30, H)
	var/failed
	var/tdelta = round(world.time - timeofdeath)


	if (H.suiciding || (HAS_TRAIT(H, TRAIT_NOCLONE)))
		failed = "<span class='warning'>The [src] equipment buzzes: Resuscitation failed - Recovery of patient impossible. Further attempts futile.</span>"
	else if (H.hellbound)
		failed = "<span class='warning'>The [src] equipment buzzes: Resuscitation failed - Patient's soul appears to be on another plane of existence.  Further attempts futile.</span>"
	else if(tdelta < (DEFIB_TIME_LIMIT * 10))
		failed = "<span class='warning'>The [src] equipment buzzes: Resuscitation failed - Body has decayed for too long. Further attempts futile.</span>"
	else if (!heart)
		failed = "<span class='warning'>The [src] equipment buzzes: Resuscitation failed - Patient's heart is missing.</span>"
	else if (heart.organ_flags & ORGAN_FAILING)
		failed = "<span class='warning'>The [src] equipment buzzes: Resuscitation failed - Patient's heart too damaged.</span>"
	else if(total_burn >= 180 || total_brute >= 180)
		failed = "<span class='warning'>The [src] equipment buzzes: Resuscitation failed - Severe tissue damage makes recovery of patient impossible via surgery. Further attempts futile.</span>"
	else if(H.get_ghost())
		failed = "<span class='warning'>The [src] equipment buzzes: Resuscitation failed - No activity in patient's brain. Further attempts may be successful.</span>"
	else
		var/obj/item/organ/brain/BR = H.getorgan(/obj/item/organ/brain)
		if(BR)
			if(BR.organ_flags & ORGAN_FAILING)
				failed = "<span class='warning'>The [src] equipment buzzes: Resuscitation failed - Patient's brain tissue is damaged making recovery of patient impossible via surgery. Further attempts futile.</span>"
			if(BR.brain_death)
				failed = "<span class='warning'>The [src] equipment buzzes: Resuscitation failed - Patient's brain damaged beyond point of no return. Further attempts futile.</span>"
			if(H.suiciding || BR.brainmob?.suiciding)
				failed = "<span class='warning'>The [src] equipment buzzes: Resuscitation failed - No intelligence pattern can be detected in patient's brain. Further attempts futile.</span>"
		else
			failed = "<span class='warning'>The [src] equipment buzzes: Resuscitation failed - Patient's brain is missing. Further attempts futile.</span>"


	if(failed)
		user.visible_message(failed)
		playsound(src, 'sound/machines/defib_failed.ogg', 50, 0)
	else
		//If the body has been fixed so that they would not be in crit when defibbed, give them oxyloss to put them back into crit
		if (H.health > HALFWAYCRITDEATH)
			H.adjustOxyLoss(H.health - HALFWAYCRITDEATH, 0)
		else
			var/overall_damage = total_brute + total_burn + H.getToxLoss() + H.getOxyLoss()
			var/mobhealth = H.health
			H.adjustOxyLoss((mobhealth - HALFWAYCRITDEATH) * (H.getOxyLoss() / overall_damage), 0)
			H.adjustToxLoss((mobhealth - HALFWAYCRITDEATH) * (H.getToxLoss() / overall_damage), 0)
			H.adjustFireLoss((mobhealth - HALFWAYCRITDEATH) * (total_burn / overall_damage), 0)
			H.adjustBruteLoss((mobhealth - HALFWAYCRITDEATH) * (total_brute / overall_damage), 0)
		H.updatehealth() // Previous "adjust" procs don't update health, so we do it manually.
		user.visible_message("<span class='notice'>The [src] equipment pings: Resuscitation successful.</span>")
		playsound(src, 'sound/machines/defib_success.ogg', 50, 0)
		H.set_heartattack(FALSE)
		H.revive()
		H.emote("gasp")
		H.Jitter(100)
		SEND_SIGNAL(H, COMSIG_LIVING_MINOR_SHOCK)
		log_combat(user, H, "revived", "Emergency Cardioversion Induction")
