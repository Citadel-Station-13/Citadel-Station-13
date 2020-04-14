/*
It will teleport people to a holding facility after 30 seconds. (Check the process() proc to change where teleport goes)
It is possible to destroy the net by the occupant or someone else.
*/

/obj/structure/energy_net
	name = "energy net"
	desc = "It's a net made of green energy."
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"

	density = TRUE//Can't pass through.
	opacity = 0//Can see through.
	mouse_opacity = MOUSE_OPACITY_ICON//So you can hit it with stuff.
	anchored = TRUE//Can't drag/grab the net.
	layer = ABOVE_ALL_MOB_LAYER
	max_integrity = 50 //How much health it has.
	can_buckle = 1
	buckle_lying = 0
	buckle_prevents_pull = TRUE
	var/mob/living/carbon/affecting //Who it is currently affecting, if anyone.
	var/mob/living/carbon/master //Who shot web. Will let this person know if the net was successful or failed.
	var/check = 15//30 seconds before teleportation. Could be extended I guess.
	var/success = FALSE


/obj/structure/energy_net/play_attack_sound(damage, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			playsound(src, 'sound/weapons/slash.ogg', 80, 1)
		if(BURN)
			playsound(src, 'sound/weapons/slash.ogg', 80, 1)

/obj/structure/energy_net/Destroy()
	if(!success)
		if(!QDELETED(affecting))
			affecting.visible_message("[affecting.name] was recovered from the energy net!", "You were recovered from the energy net!", "<span class='italics'>You hear a grunt.</span>")
		if(!QDELETED(master))//As long as they still exist.
			to_chat(master, "<span class='userdanger'>ERROR</span>: unable to initiate transport protocol. Procedure terminated.")
	return ..()

/obj/structure/energy_net/process()
	if(QDELETED(affecting)||affecting.loc!=loc)
		qdel(src)//Get rid of the net.
		return

	if(check>0)
		check--
		return

	success = TRUE
	qdel(src)
	if(ishuman(affecting))
		var/mob/living/carbon/human/H = affecting
		for(var/obj/item/W in H)
			if(W == H.w_uniform || W == H.shoes)
				continue//So all they're left with are shoes and uniform.
			H.dropItemToGround(W)
		H.dna.species.give_important_for_life(H)	// After we remove items, at least give them what they need to live.
/*
	var/datum/antagonist/antag_datum
	for(var/datum/antagonist/ninja/AD in GLOB.antagonists) //Because only ninjas get capture objectives; They're not doable without the suit.
		if(AD.owner == master)
			antag_datum = AD
			break
	for(var/datum/objective/capture/capture in antag_datum)
		if(istype(affecting, /mob/living/carbon/human)) //Humans.
			if(affecting.stat == DEAD)//Dead folks are worth less.
				capture.captured_amount+=0.5
				continue
			capture.captured_amount+=1
		if(istype(affecting, /mob/living/carbon/monkey)) //Monkeys are almost worthless, you failure.
			capture.captured_amount+=0.1
		if(istype(affecting, /mob/living/carbon/alien/larva)) //Larva are important for research.
			if(affecting.stat == DEAD)
				capture.captured_amount+=0.5
				continue
			capture.captured_amount+=1
		if(istype(affecting, /mob/living/carbon/alien/humanoid)) //Aliens are worth twice as much as humans.
			if(istype(affecting, /mob/living/carbon/alien/humanoid/royal/queen)) //Queens are worth three times as much as humans.
				if(affecting.stat == DEAD)
					capture.captured_amount+=1.5
				else
					capture.captured_amount+=3
				continue
			if(affecting.stat == DEAD)
				capture.captured_amount+=1
				continue
			capture.captured_amount+=2
*/

	affecting.revive(1, 1)	//Basically a revive and full heal, including limbs/organs
							//In case people who have been captured dead want to hang out at the holding area

	playsound(affecting, 'sound/effects/sparks4.ogg', 50, 1)
	new /obj/effect/temp_visual/dir_setting/ninja/phase/out(affecting.drop_location(), affecting.dir)

	visible_message("[affecting] suddenly vanishes!")
	affecting.forceMove(pick(GLOB.holdingfacility)) //Throw mob in to the holding facility.
	to_chat(affecting, "<span class='danger'>You appear in a strange place!</span>")

	if(!QDELETED(master))//As long as they still exist.
		to_chat(master, "<span class='notice'><b>SUCCESS</b>: transport procedure of [affecting] complete.</span>")
	do_sparks(5, FALSE, affecting)
	playsound(affecting, 'sound/effects/phasein.ogg', 25, 1)
	playsound(affecting, 'sound/effects/sparks2.ogg', 50, 1)
	new /obj/effect/temp_visual/dir_setting/ninja/phase(affecting.drop_location(), affecting.dir)

/obj/structure/energy_net/attack_alien(mob/living/carbon/alien/humanoid/user)
	if(attack_generic(user, 15, BRUTE, "melee", 0)) //Aliens normally deal 60 damage to structures. They'd one-shot nets without this.
		playsound(src.loc, 'sound/weapons/slash.ogg', 100, 1)

/obj/structure/energy_net/user_buckle_mob(mob/living/M, mob/living/user)
	return//We only want our target to be buckled

/obj/structure/energy_net/user_unbuckle_mob(mob/living/buckled_mob, mob/living/user)
	return//The net must be destroyed to free the target
