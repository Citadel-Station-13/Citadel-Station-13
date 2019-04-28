/datum/status_effect/chem/SGDF
	id = "SGDF"
	var/mob/living/fermi_Clone


/datum/status_effect/chem/SGDF/on_apply()
	message_admins("SGDF status appied")
	var/typepath = owner.type
	fermi_Clone = new typepath(owner.loc)
	var/mob/living/carbon/M = owner
	var/mob/living/carbon/C = fermi_Clone

	//fermi_Clone = new typepath(get_turf(M))
	//var/mob/living/carbon/C = fermi_Clone
	//var/mob/living/carbon/SM = fermi_Gclone

	if(istype(C) && istype(M))
		C.real_name = M.real_name
		M.dna.transfer_identity(C, transfer_SE=1)
		C.updateappearance(mutcolor_update=1)
	return ..()

/datum/status_effect/chem/SGDF/tick()
	message_admins("SDGF ticking")
	if(owner.stat == DEAD)
		message_admins("SGDF status swapping")
		if(fermi_Clone && fermi_Clone.stat != DEAD)
			if(owner.mind)
				owner.mind.transfer_to(fermi_Clone)
				owner.visible_message("<span class='warning'>Lucidity shoots to your previously blank mind as your mind suddenly finishes the cloning process. You marvel for a moment at yourself, as your mind subconciously recollects all your memories up until the point when you cloned yourself. curiously, you find that you memories are blank after you ingested the sythetic serum, leaving you to wonder where the other you is.</span>")
				fermi_Clone.visible_message("<span class='warning'>Lucidity shoots to your previously blank mind as your mind suddenly finishes the cloning process. You marvel for a moment at yourself, as your mind subconciously recollects all your memories up until the point when you cloned yourself. curiously, you find that you memories are blank after you ingested the sythetic serum, leaving you to wonder where the other you is.</span>")
				fermi_Clone = null
				owner.remove_status_effect(src)
		//	to_chat(owner, "<span class='notice'>[linked_extract] desperately tries to move your soul to a living body, but can't find one!</span>")
	..()

/datum/status_effect/chem/BElarger
	id = "BElarger"
	var/list/items = list()

/datum/status_effect/chem/BElarger/on_apply(mob/living/carbon/M)//Removes clothes, they're too small to contain you. You belong to space now.
	message_admins("BElarge started!")
	var/mob/living/carbon/human/H = M
	var/items = M.get_contents()
	for(W in items)
		if(W == H.w_uniform || W == H.wear_suit)
			M.dropItemToGround(W, TRUE)
			message_admins("Dropping [W]")
	playsound(owner.loc, 'sound/items/poster_ripped.ogg', 50, 1)
	//items |= owner.get_equipped_items(TRUE)
	owner.visible_message("<span class='boldnotice'>[M]'s chest suddenly bursts forth, ripping their clothes off!'</span>")
	to_chat(owner, "<span class='warning'>Your clothes give, ripping into peices under the strain of your swelling breasts! Unless you manage to reduce the size of your breasts, there's no way you're going to be able to put anything on over these melons..!</b></span>")
	//owner.dropItemToGround(owner.wear_suit)
	//owner.dropItemToGround(owner.w_uniform)

/datum/status_effect/chem/BElarger/tick(mob/living/carbon/M)//If you try to wear clothes, you fail. Slows you down if you're comically huge
	message_admins("BElarge tick!")
	var/obj/item/organ/genital/breasts/B = M.getorganslot("breasts")
	var/mob/living/carbon/human/H = M
	message_admins("M: [M]")
	message_admins("H: [H]")
	message_admins("owner: [owner]")
	for(var/obj/item/W in H)
		if(W == H.w_uniform || W == H.wear_suit)
			H.dropItemToGround(W)
		//items |= owner.get_equipped_items(TRUE)
			to_chat(owner, "<span class='warning'>Your enormous breasts are way to large to fit anything over!</b></span>")
		//owner.dropItemToGround(owner.wear_suit)
		//owner.dropItemToGround(owner.w_uniform)
	switch(round(B.cached_size))
		if(9)
			if (!(B.breast_sizes[B.prev_size] == B.size))
				owner.remove_movespeed_modifier("megamilk")
				owner.next_move_modifier = 1
		if(10 to INFINITY)
			if (!(B.breast_sizes[B.prev_size] == B.size))
				to_chat(M, "<span class='warning'>Your indulgent busom is so substantial, it's affecting your movements!</b></span>")
				owner.add_movespeed_modifier("megamilk", TRUE, 100, NONE, override = TRUE, multiplicative_slowdown = (round(B.cached_size) - 8))
				owner.next_move_modifier = (round(B.cached_size) - 8)

/datum/status_effect/chem/BElarger/on_remove(mob/living/carbon/M)
	owner.remove_movespeed_modifier("megamilk")
	owner.next_move_modifier = 1

/datum/status_effect/chem/PElarger
	id = "PElarger"
	//var/list/items = list()


/datum/status_effect/chem/PElarger/on_apply(mob/living/carbon/M)
	var/mob/living/carbon/human/H = M
	for(var/obj/item/W in H)
		if(W == H.w_uniform || W == H.wear_suit)
			H.dropItemToGround(W)
		playsound(M.loc, 'sound/items/poster_ripped.ogg', 50, 1)
		//items |= M.get_equipped_items(TRUE)
		owner.visible_message("<span class='boldnotice'>[M]'s penis suddenly bursts forth, ripping their clothes off!'</span>")
		to_chat(M, "<span class='warning'>Your clothes give, ripping into peices under the strain of your swelling penis! Unless you manage to reduce the size of your emancipated trouser snake, there's no way you're going to be able to put anything on over this girth..!</b></span>")
		//owner.dropItemToGround(owner.wear_suit)
		//owner.dropItemToGround(owner.w_uniform)

/datum/status_effect/chem/PElarger/tick(mob/living/carbon/M)
	var/mob/living/carbon/human/H = M
	for(var/obj/item/W in H)
		if(W == H.w_uniform || W == H.wear_suit)
			H.dropItemToGround(W)
		//items |= M.get_equipped_items(TRUE)
		to_chat(owner, "<span class='warning'>Your enormous package is way to large to fit anything over!</b></span>")
		//owner.dropItemToGround(owner.wear_suit)
		//owner.dropItemToGround(owner.w_uniform)


/*Doesn't work
/datum/status_effect/chem/SDGF/candidates
	id = "SGDFCandi"
	var/mob/living/fermi_Clone
	var/list/candies = list()

/datum/status_effect/chem/SDGF/candidates/on_apply()
	candies = pollGhostCandidates("Do you want to play as a clone and do you agree to respect their character and act in a similar manner to them? I swear to god if you diddle them I will be very disapointed in you. ", "FermiClone", null, ROLE_SENTIENCE, 300) // see poll_ignore.dm, should allow admins to ban greifers or bullies
	return ..()
*/
