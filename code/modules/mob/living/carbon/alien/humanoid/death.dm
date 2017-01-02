/mob/living/carbon/alien/humanoid/death(gibbed)
	if(stat == DEAD)
		return
	stat = DEAD

	if(!deathNotified) //Did we message the other aliens that we died?
		deathNotice()  //If not, do so now. This proc will change the deathNotified var to 1 so it never happens again.

	if(!gibbed)
		playsound(loc, 'sound/voice/hiss6.ogg', 80, 1, 1)
		visible_message("<span class='name'>[src]</span> lets out a waning guttural screech, green blood bubbling from its maw...")
		update_canmove()
		update_icons()
		status_flags |= CANPUSH
		if(fireloss >= (maxHealth/2))
			spawn(10)
			visible_message("<span class='warning'>[src] starts shaking...</span>")
			spawn(30)
				src.gib()

	return ..()

//When the alien queen dies, all others must pay the price for letting her die.
/mob/living/carbon/alien/humanoid/royal/queen/death(gibbed)
	if(stat == DEAD)
		return

	for(var/mob/living/carbon/C in living_mob_list)
		if(C == src) //Make sure not to proc it on ourselves.
			continue
		var/obj/item/organ/alien/hivenode/node = C.getorgan(/obj/item/organ/alien/hivenode)
		if(istype(node)) // just in case someone would ever add a diffirent node to hivenode slot
			node.queen_death()

	return ..(gibbed)

/mob/living/carbon/alien/humanoid/gib()
	visible_message("<span class='danger'>[src] explodes in a shower of acid blood and gibs!</span>")
	for(var/mob/living/M in viewers(2, src))
		if(ishuman(M))
			M << "<span class='userdanger'>You're sprayed with acid blood!</span>"
			M.adjustFireLoss(15)
			M.reagents.add_reagent("xblood",5)
		else if(ismonkey(M))
			M << "<span class='userdanger'>You're sprayed with acid blood!</span>"
			M.adjustFireLoss(15)
			M.reagents.add_reagent("xblood",5)
		else if(!isalien(M))
			M << "<span class='userdanger'>You're sprayed with acid blood!</span>"
			M.adjustFireLoss(15)
	..()
