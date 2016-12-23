/mob/living/carbon/death(gibbed)
	silent = 0
	losebreath = 0
	..()

/mob/living/carbon/gib(no_brain, no_organs, no_bodyparts)
	for(var/mob/M in src)
		if(M in stomach_contents)
			stomach_contents.Remove(M)
		M.forceMove(loc)
		visible_message("<span class='danger'>[M] bursts out of [src]!</span>")
	..()

/mob/living/carbon/spill_organs(no_brain, no_organs, no_bodyparts)
	if(!no_bodyparts)
		if(no_organs)//so the organs don't get transfered inside the bodyparts we'll drop.
			for(var/X in internal_organs)
				qdel(X)
		else //we're going to drop all bodyparts except chest, so the only organs that needs spilling are those inside it.
			for(var/X in internal_organs)
				var/obj/item/organ/O = X
				if(no_brain && istype(O, /obj/item/organ/brain))
					qdel(O) //so the brain isn't transfered to the head when the head drops.
					continue
				var/org_zone = check_zone(O.zone) //both groin and chest organs.
				if(org_zone == "chest")
					O.Remove(src)
					O.forceMove(get_turf(src))
					O.throw_at_fast(get_edge_target_turf(src,pick(alldirs)),rand(1,3),5)
	else
		for(var/X in internal_organs)
			var/obj/item/organ/I = X
			if(no_brain && istype(I, /obj/item/organ/brain))
				qdel(I)
				continue
			I.Remove(src)
			I.forceMove(get_turf(src))
			I.throw_at_fast(get_edge_target_turf(src,pick(alldirs)),rand(1,3),5)


/mob/living/carbon/spread_bodyparts()
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		BP.drop_limb()
		BP.throw_at_fast(get_edge_target_turf(src,pick(alldirs)),rand(1,3),5)