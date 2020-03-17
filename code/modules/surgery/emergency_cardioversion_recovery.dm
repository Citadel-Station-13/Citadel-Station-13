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

/datum/surgery_step/ventricular_electrotherapy/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(istype(tool, /obj/item/twohanded/shockpaddles))
		var/obj/item/twohanded/shockpaddles/pads = tool
		if(!pads.wielded)
			to_chat(user, "<span class='warning'>You need to wield the paddles in both hands before you can use them!</span>")
			return FALSE
	display_results(user, target, "<span class='notice'>You begin to apply the [tool] onto the heart directly...</span>",
		"[user] begin to prepare the heart for contact with the [tool].",
		"[user] begin to prepare the heart for contact with the [tool].	")
	target.notify_ghost_cloning("Your heart is undergoing Emergency Cardioversion Induction Surgery!")
	playsound(src, 'sound/machines/defib_charge.ogg', 75, 0)

/datum/surgery_step/ventricular_electrotherapy/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(istype(tool, /obj/item/twohanded/shockpaddles))
		var/obj/item/twohanded/shockpaddles/pads = tool
		if(!pads.wielded)
			return FALSE
	var/mob/living/carbon/human/H = target
	playsound(src, 'sound/machines/defib_zap.ogg', 75, 1, -1)
	playsound(src, "bodyfall", 50, 1)
	if(H.stat != DEAD)
		display_results(user, target, "<span class='warning'>You can't use this procedure on the living! [H]'s body flops madly like a wild fish on the table from the current, and your crazed surgical methods.</span>",
			"<span class='warning'>[user] screws up, causing [H] to flop around violently as they're zapped!</span>",
			"<span class='warning'>[user] screws up, causing [H] to flop around violently as they're zapped!</span>")
		H.emote("scream")
		H.electrocute_act(25, (tool), 1, SHOCK_ILLUSION)
		H.adjustFireLoss(10)
		H.emote("flip")
		H.Jitter(100)
		return FALSE
	display_results(user, target, "<span class='notice'>You attach the [tool] to [target]'s heart and prepare to pulse.</span>",
		"[user] attaches the [tool] to [H]'s heart and prepares to pulse.",
		"")
	H.adjustBruteLoss(10)
	var/obj/item/organ/heart = H.getorgan(/obj/item/organ/heart)
	if(heart.organ_flags & ORGAN_FAILING)
		H.adjustOrganLoss(ORGAN_SLOT_HEART, -15)
	var/obj/item/organ/brain/BR = H.getorgan(/obj/item/organ/brain)
	if(BR.organ_flags & ORGAN_FAILING)
		H.adjustOrganLoss(ORGAN_SLOT_BRAIN, -5)
	H.electrocute_act(0, (tool), 1, SHOCK_ILLUSION)
	//If we're using a defib, let the defib handle the revive.
	if(istype(tool, /obj/item/twohanded/shockpaddles))
		return
	//Otherwise, we're ad hocing it
	if(!(do_after(user, 50, target = target)))
		return FALSE
	if(!ghetto_defib(user, H, tool))
		playsound(src, 'sound/machines/defib_failed.ogg', 50, 0)
		return FALSE
	log_combat(user, H, "revived", "Emergency Cardioversion Induction")
	return TRUE

/datum/surgery_step/ventricular_electrotherapy/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	playsound(src, 'sound/machines/defib_zap.ogg', 75, 1, -1)
	playsound(src, "bodyfall", 50, 1)
	var/mob/living/carbon/human/H = target
	display_results(user, target, "<span class='warning'>You screw up, sending a current through their body!</span>",
		"<span class='warning'>[user] screws up, causing [H] to flop around violently as they're zapped!</span>",
		"<span class='warning'>[user] screws up, causing [H] to flop around violently as they're zapped!</span>")
	H.electrocute_act(25, (tool), 1, SHOCK_ILLUSION)
	H.adjustFireLoss(10)
	H.emote("flip")
	H.adjustOrganLoss(ORGAN_SLOT_HEART, 10)

/datum/surgery_step/ventricular_electrotherapy/proc/ghetto_defib(mob/user, mob/living/carbon/human/H, obj/item/tool)
	H.visible_message("<span class='warning'>[H]'s body convulses a bit.</span>")
	var/total_brute	= H.getBruteLoss()
	var/total_burn	= H.getFireLoss()
	var/failed
	var/tdelta = round(world.time - H.timeofdeath)

	if (H.suiciding || (HAS_TRAIT(H, TRAIT_NOCLONE)))
		failed = "<span class='warning'>The heart is zapped by the [tool], but nothing happens. You feel like the spark of life has fully left [H].</span>"
	else if (H.hellbound)
		failed = "<span class='warning'>The heart is zapped by the [tool], but nothing happens. You notice a small tatoo with the words \"Property of Satan\" branded just above the right ventricle.</span>"
	else if(tdelta > (DEFIB_TIME_LIMIT * 10))
		failed = "<span class='warning'>The heart is zapped by the [tool], but nothing happens. It appears their body decomposed beyond repair.</span>"
	else if(total_burn >= 180 || total_brute >= 180)
		failed = "<span class='warning'>The [tool] zaps the heart, inducing a sudden contraction, but it appears [H]'s body is too damaged to revive presently.</span>"
	else if(H.get_ghost())
		failed = "<span class='warning'>The [tool] zaps the heart, inducing several contractions before dying down, but there's no spark of life in [H]'s eyes. It may be worth it to try again, however.</span>"
	else
		var/obj/item/organ/brain/BR = H.getorgan(/obj/item/organ/brain)
		if(BR)
			if(H.suiciding || BR.brainmob?.suiciding)
				failed = "<span class='warning'>The heart is zapped by the [tool], but nothing happens. You feel like the spark of life has fully left [H].</span>"
		else
			failed = "<span class='warning'>The [tool] zaps the heart, restarting the heart, but without a brain the contractions quickly die out.</span>"


	if(failed)
		to_chat(user, failed)
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
		H.visible_message("<span class='notice'>The [tool] zaps the heart, inducing several contractions before speeding up into a regular rhythm, [H]'s eyes snapping open with a loud gasp!</span>")
		playsound(src, 'sound/machines/defib_success.ogg', 50, 0)
		H.set_heartattack(FALSE)
		H.revive()
		H.emote("gasp")
		H.Jitter(100)
		SEND_SIGNAL(H, COMSIG_LIVING_MINOR_SHOCK)
