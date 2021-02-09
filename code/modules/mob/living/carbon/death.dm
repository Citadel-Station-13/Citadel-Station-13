/mob/living/carbon/death(gibbed)
	if(stat == DEAD)
		return

	silent = FALSE
	losebreath = 0

	if(!gibbed && !HAS_TRAIT(src, TRAIT_DEATHCOMA))
		emote("deathgasp")

	. = ..()

	for(var/T in get_traumas())
		var/datum/brain_trauma/BT = T
		BT.on_death()

	if(SSticker.mode)
		SSticker.mode.check_win() //Calls the rounds wincheck, mainly for wizard, malf, and changeling now

/mob/living/carbon/gib(no_brain, no_organs, no_bodyparts, datum/explosion/was_explosion)
	var/atom/Tsec = drop_location()
	for(var/mob/M in src)
		if(M in stomach_contents)
			stomach_contents.Remove(M)
		M.forceMove(Tsec)
		M.visible_message("<span class='danger'>[M] bursts out of [src]!</span>",
			"<span class='danger'>You burst out of [src]!</span>")
	..()

/mob/living/carbon/spill_organs(no_brain, no_organs, no_bodyparts, datum/explosion/was_explosion)
	var/atom/Tsec = drop_location()
	if(!no_bodyparts)
		if(no_organs)//so the organs don't get transfered inside the bodyparts we'll drop.
			for(var/X in internal_organs)
				if(no_brain || !istype(X, /obj/item/organ/brain))
					qdel(X)
		else //we're going to drop all bodyparts except chest, so the only organs that needs spilling are those inside it.
			for(var/X in internal_organs)
				var/obj/item/organ/O = X
				if(no_brain && istype(O, /obj/item/organ/brain))
					qdel(O) //so the brain isn't transfered to the head when the head drops.
					continue
				if(!(O.organ_flags & ORGAN_NO_DISMEMBERMENT) && check_zone(O.zone) == BODY_ZONE_CHEST)
					if(was_explosion)
						LAZYADD(O.acted_explosions, was_explosion.explosion_id)
					O.Remove()
					O.forceMove(Tsec)
					O.throw_at(get_edge_target_turf(src,pick(GLOB.alldirs)),rand(1,3),5)
	else
		for(var/X in internal_organs)
			var/obj/item/organ/I = X
			if(I.organ_flags & ORGAN_NO_DISMEMBERMENT || (no_brain && istype(I, /obj/item/organ/brain)) || (no_organs && !istype(I, /obj/item/organ/brain)))
				qdel(I)
				continue
			if(was_explosion)
				LAZYADD(I.acted_explosions, was_explosion.explosion_id)
			I.Remove()
			I.forceMove(Tsec)
			I.throw_at(get_edge_target_turf(src,pick(GLOB.alldirs)),rand(1,3),5)

/mob/living/carbon/spread_bodyparts(no_brain, no_organs, datum/explosion/was_explosion)
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		if(was_explosion)
			LAZYADD(BP.acted_explosions, was_explosion.explosion_id)
		BP.drop_limb()
		BP.throw_at(get_edge_target_turf(src,pick(GLOB.alldirs)),rand(1,3),5)
