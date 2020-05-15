//entirely neutral or internal status effects go here

/datum/status_effect/sigil_mark //allows the affected target to always trigger sigils while mindless
	id = "sigil_mark"
	duration = -1
	alert_type = null
	var/stat_allowed = DEAD //if owner's stat is below this, will remove itself

/datum/status_effect/sigil_mark/tick()
	if(owner.stat < stat_allowed)
		qdel(src)

/datum/status_effect/crusher_damage //tracks the damage dealt to this mob by kinetic crushers
	id = "crusher_damage"
	duration = -1
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	var/total_damage = 0

/datum/status_effect/syphon_mark
	id = "syphon_mark"
	duration = 50
	status_type = STATUS_EFFECT_MULTIPLE
	alert_type = null
	on_remove_on_mob_delete = TRUE
	var/obj/item/borg/upgrade/modkit/bounty/reward_target

/datum/status_effect/syphon_mark/on_creation(mob/living/new_owner, obj/item/borg/upgrade/modkit/bounty/new_reward_target)
	. = ..()
	if(.)
		reward_target = new_reward_target

/datum/status_effect/syphon_mark/on_apply()
	if(owner.stat == DEAD)
		return FALSE
	return ..()

/datum/status_effect/syphon_mark/proc/get_kill()
	if(!QDELETED(reward_target))
		reward_target.get_kill(owner)

/datum/status_effect/syphon_mark/tick()
	if(owner.stat == DEAD)
		get_kill()
		qdel(src)

/datum/status_effect/syphon_mark/on_remove()
	get_kill()
	return ..()

/obj/screen/alert/status_effect/in_love
	name = "In Love"
	desc = "You feel so wonderfully in love!"
	icon_state = "in_love"

/datum/status_effect/in_love
	id = "in_love"
	duration = -1
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /obj/screen/alert/status_effect/in_love
	var/mob/living/date

/datum/status_effect/in_love/on_creation(mob/living/new_owner, mob/living/love_interest)
	. = ..()
	if(.)
		date = love_interest
	linked_alert.desc = "You're in love with [date.real_name]! How lovely."

/datum/status_effect/in_love/tick()
	if(date)
		new /obj/effect/temp_visual/love_heart/invisible(get_turf(date.loc), owner)

/datum/status_effect/throat_soothed
	id = "throat_soothed"
	duration = 60 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null

/datum/status_effect/throat_soothed/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_SOOTHED_THROAT, "[STATUS_EFFECT_TRAIT]_[id]")

/datum/status_effect/throat_soothed/on_remove()
	REMOVE_TRAIT(owner, TRAIT_SOOTHED_THROAT, "[STATUS_EFFECT_TRAIT]_[id]")
	return ..()

/datum/status_effect/chem/SGDF
	id = "SGDF"
	var/mob/living/fermi_Clone
	var/mob/living/original
	var/datum/mind/originalmind
	var/status_set = FALSE
	alert_type = null

/datum/status_effect/chem/SGDF/on_apply()
	log_game("FERMICHEM: SGDF status appied on [owner], ID: [owner.key]")
	fermi_Clone = owner
	return ..()

/datum/status_effect/chem/SGDF/tick()
	if(!status_set)
		return ..()
	if(original.stat == DEAD || original == null || !original)
		if((fermi_Clone && fermi_Clone.stat != DEAD) || (fermi_Clone == null))
			if(originalmind)
				owner.remove_status_effect(src)
	..()

/datum/status_effect/chem/SGDF/on_remove()
	log_game("FERMICHEM: SGDF mind shift applied. [owner] is now playing as their clone and should not have memories after their clone split (look up SGDF status applied). ID: [owner.key]")
	originalmind.transfer_to(fermi_Clone)
	to_chat(owner, "<span class='warning'>Lucidity shoots to your previously blank mind as your mind suddenly finishes the cloning process. You marvel for a moment at yourself, as your mind subconciously recollects all your memories up until the point when you cloned yourself. Curiously, you find that you memories are blank after you ingested the synthetic serum, leaving you to wonder where the other you is.</span>")
	fermi_Clone = null
	return ..()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/status_effect/chem/breast_enlarger
	id = "breast_enlarger"
	alert_type = null
	var/moveCalc = 1
	var/cachedmoveCalc = 1
	var/last_checked_size //used to prevent potential cpu waste from happening every tick.

/datum/status_effect/chem/breast_enlarger/on_apply()//Removes clothes, they're too small to contain you. You belong to space now.
	log_game("FERMICHEM: [owner]'s breasts has reached comical sizes. ID: [owner.key]")
	var/mob/living/carbon/human/H = owner
	var/message = FALSE
	if(H.w_uniform)
		H.dropItemToGround(H.w_uniform, TRUE)
		message = TRUE
	if(H.wear_suit)
		H.dropItemToGround(H.wear_suit, TRUE)
		message = TRUE
	if(message)
		playsound(H.loc, 'sound/items/poster_ripped.ogg', 50, 1)
		H.visible_message("<span class='boldnotice'>[H]'s chest suddenly bursts forth, ripping their clothes off!'</span>", \
		"<span class='warning'>Your clothes give, ripping into peices under the strain of your swelling breasts! Unless you manage to reduce the size of your breasts, there's no way you're going to be able to put anything on over these melons..!</b></span>")
	else
		to_chat(H, "<span class='notice'>Your bountiful bosom is so rich with mass, you seriously doubt you'll be able to fit any clothes over it.</b></span>")
	return ..()

/datum/status_effect/chem/breast_enlarger/tick()//If you try to wear clothes, you fail. Slows you down if you're comically huge
	var/mob/living/carbon/human/H = owner
	var/obj/item/organ/genital/breasts/B = H.getorganslot(ORGAN_SLOT_BREASTS)
	if(!B)
		H.remove_status_effect(src)
		return
	moveCalc = 1+((round(B.cached_size) - 9)/3) //Afffects how fast you move, and how often you can click.
	var/message = FALSE
	if(H.w_uniform)
		H.dropItemToGround(H.w_uniform, TRUE)
		message = TRUE
	if(H.wear_suit)
		H.dropItemToGround(H.wear_suit, TRUE)
		message = TRUE
	if(message)
		playsound(H.loc, 'sound/items/poster_ripped.ogg', 50, 1)
		to_chat(H, "<span class='warning'>Your enormous breasts are way too large to fit anything over them!</b></span>")

	if(last_checked_size != B.cached_size)
		H.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/status_effect/breast_hypertrophy, multiplicative_slowdown = moveCalc)
		sizeMoveMod(moveCalc)

	if (B.size == "huge")
		if(prob(1))
			to_chat(owner, "<span class='notice'>Your back is feeling sore.</span>")
			var/target = H.get_bodypart(BODY_ZONE_CHEST)
			H.apply_damage(0.1, BRUTE, target)
	else
		if(prob(1))
			to_chat(H, "<span class='notice'>Your back is feeling a little sore.</span>")
	last_checked_size = B.cached_size
	..()

/datum/status_effect/chem/breast_enlarger/on_remove()
	log_game("FERMICHEM: [owner]'s breasts has reduced to an acceptable size. ID: [owner.key]")
	to_chat(owner, "<span class='notice'>Your expansive chest has become a more managable size, liberating your movements.</b></span>")
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/status_effect/breast_hypertrophy)
	sizeMoveMod(1)
	return ..()

/datum/status_effect/chem/breast_enlarger/proc/sizeMoveMod(var/value)
	if(cachedmoveCalc == value)
		return
	owner.next_move_modifier /= cachedmoveCalc
	owner.next_move_modifier *= value
	cachedmoveCalc = value

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/status_effect/chem/penis_enlarger
	id = "penis_enlarger"
	alert_type = null
	var/bloodCalc
	var/moveCalc
	var/last_checked_size //used to prevent potential cpu waste, just like the above.

/datum/status_effect/chem/penis_enlarger/on_apply()//Removes clothes, they're too small to contain you. You belong to space now.
	log_game("FERMICHEM: [owner]'s dick has reached comical sizes. ID: [owner.key]")
	var/mob/living/carbon/human/H = owner
	var/message = FALSE
	if(H.w_uniform)
		H.dropItemToGround(H.w_uniform, TRUE)
		message = TRUE
	if(H.wear_suit)
		H.dropItemToGround(H.wear_suit, TRUE)
		message = TRUE
	if(message)
		playsound(H.loc, 'sound/items/poster_ripped.ogg', 50, 1)
		H.visible_message("<span class='boldnotice'>[H]'s schlong suddenly bursts forth, ripping their clothes off!'</span>", \
		"<span class='warning'>Your clothes give, ripping into peices under the strain of your swelling pecker! Unless you manage to reduce the size of your emancipated trouser snake, there's no way you're going to be able to put anything on over this girth..!</b></span>")
	else
		to_chat(H, "<span class='notice'>Your emancipated trouser snake is so ripe with girth, you seriously doubt you'll be able to fit any clothes over it.</b></span>")
	return ..()


/datum/status_effect/chem/penis_enlarger/tick()
	var/mob/living/carbon/human/H = owner
	var/obj/item/organ/genital/penis/P = H.getorganslot(ORGAN_SLOT_PENIS)
	if(!P)
		owner.remove_status_effect(src)
		return
	moveCalc = 1+((round(P.length) - 21)/3) //effects how fast you can move
	bloodCalc = 1+((round(P.length) - 21)/15) //effects how much blood you need (I didn' bother adding an arousal check because I'm spending too much time on this organ already.)

	var/message = FALSE
	if(H.w_uniform)
		H.dropItemToGround(H.w_uniform, TRUE)
		message = TRUE
	if(H.wear_suit)
		H.dropItemToGround(H.wear_suit, TRUE)
		message = TRUE
	if(message)
		playsound(H.loc, 'sound/items/poster_ripped.ogg', 50, 1)
		to_chat(H, "<span class='warning'>Your enormous package is way to large to fit anything over!</b></span>")

	if(P.length < 22 && H.has_movespeed_modifier(/datum/movespeed_modifier/status_effect/penis_hypertrophy))
		to_chat(owner, "<span class='notice'>Your rascally willy has become a more managable size, liberating your movements.</b></span>")
		H.remove_movespeed_modifier(/datum/movespeed_modifier/status_effect/penis_hypertrophy)
	else if(P.length >= 22 && !H.has_movespeed_modifier(/datum/movespeed_modifier/status_effect/penis_hypertrophy))
		to_chat(H, "<span class='warning'>Your indulgent johnson is so substantial, it's taking all your blood and affecting your movements!</b></span>")
		H.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/status_effect/penis_hypertrophy, multiplicative_slowdown = moveCalc)
	H.AdjustBloodVol(bloodCalc)
	..()

/datum/status_effect/chem/penis_enlarger/on_remove()
	log_game("FERMICHEM: [owner]'s dick has reduced to an acceptable size. ID: [owner.key]")
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/status_effect/penis_hypertrophy)
	owner.ResetBloodVol()
	return ..()

///////////////////////////////////////////////
//			Astral INSURANCE
///////////////////////////////////////////////
//Makes sure people can't get trapped in each other's bodies if lag causes a deync between proc calls.

/datum/status_effect/chem/astral_insurance
	id = "astral_insurance"
	var/mob/living/original
	var/datum/mind/originalmind
	alert_type = null

/datum/status_effect/chem/astral_insurance/tick(mob/living/carbon/M)
	. = ..()
	if(owner.reagents.has_reagent(/datum/reagent/fermi/astral))
		return
	if(owner.mind == originalmind) //If they're home, let the chem deal with deletion.
		return
	if(owner.mind)
		var/mob/living/simple_animal/astral/G = new(get_turf(M.loc))
		owner.mind.transfer_to(G)//Just in case someone else is inside of you, it makes them a ghost and should hopefully bring them home at the end.
		to_chat(G, "<span class='warning'>[M]'s conciousness snaps back to them as their astrogen runs out, kicking your projected mind out!'</b></span>")
		log_game("FERMICHEM: [M]'s possesser has been booted out into a astral ghost!")
	originalmind.transfer_to(original)

/datum/status_effect/chem/astral_insurance/on_remove() //God damnit get them home!
	if(owner.mind != originalmind) //If they're home, HOORAY
		if(owner.mind)
			var/mob/living/simple_animal/astral/G = new(get_turf(owner))
			owner.mind.transfer_to(G)//Just in case someone else is inside of you, it makes them a ghost and should hopefully bring them home at the end.
			to_chat(G, "<span class='warning'>[owner]'s conciousness snaps back to them as their astrogen runs out, kicking your projected mind out!'</b></span>")
			log_game("FERMICHEM: [owner]'s possesser has been booted out into a astral ghost!")
		originalmind.transfer_to(original)
	return ..()
