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

/datum/status_effect/chem/BElarger/on_apply(mob/living/carbon/M)
	var/mob/living/carbon/human/H
	if(H.w_uniform || H.wear_suit)
		playsound(M.loc, 'sound/items/poster_ripped.ogg', 50, 1)
		items |= M.get_equipped_items(TRUE)
		M.visible_message("<span class='boldnotice'>[M]'s chest suddenly bursts forth, ripping their clothes off!'</span>")
		to_chat(M, "<span class='warning'>Your clothes give, ripping into peices under the strain of your swelling breasts! Unless you manage to reduce the size of your breasts, there's no way you're going to be able to put anything on over these melons..!</b></span>")
		M.dropItemToGround(H.wear_suit)
		M.dropItemToGround(H.w_uniform)

/datum/status_effect/chem/BElarger/tick(mob/living/carbon/M)
	var/mob/living/carbon/human/H
	if(H.w_uniform || H.wear_suit)
		items |= M.get_equipped_items(TRUE)
		to_chat(M, "<span class='warning'>Your enormous breasts are way to large to fit anything over!</b></span>")
		M.dropItemToGround(H.wear_suit)
		M.dropItemToGround(H.w_uniform)

/datum/status_effect/chem/PElarger
	id = "PElarger"
	var/list/items = list()

/datum/status_effect/chem/PElarger/on_apply(mob/living/carbon/M)
	var/mob/living/carbon/human/H
	if(H.w_uniform || H.wear_suit)
		playsound(M.loc, 'sound/items/poster_ripped.ogg', 50, 1)
		items |= M.get_equipped_items(TRUE)
		M.visible_message("<span class='boldnotice'>[M]'s penis suddenly bursts forth, ripping their clothes off!'</span>")
		to_chat(M, "<span class='warning'>Your clothes give, ripping into peices under the strain of your swelling penis! Unless you manage to reduce the size of your emancipated trouser snake, there's no way you're going to be able to put anything on over this girth..!</b></span>")
		M.dropItemToGround(H.wear_suit)
		M.dropItemToGround(H.w_uniform)

/datum/status_effect/chem/PElarger/tick(mob/living/carbon/M)
	var/mob/living/carbon/human/H
	if(H.w_uniform || H.wear_suit)
		items |= M.get_equipped_items(TRUE)
		to_chat(M, "<span class='warning'>Your enormous package is way to large to fit anything over!</b></span>")
		M.dropItemToGround(H.wear_suit)
		M.dropItemToGround(H.w_uniform)


/*Doesn't work
/datum/status_effect/chem/SDGF/candidates
	id = "SGDFCandi"
	var/mob/living/fermi_Clone
	var/list/candies = list()

/datum/status_effect/chem/SDGF/candidates/on_apply()
	candies = pollGhostCandidates("Do you want to play as a clone and do you agree to respect their character and act in a similar manner to them? I swear to god if you diddle them I will be very disapointed in you. ", "FermiClone", null, ROLE_SENTIENCE, 300) // see poll_ignore.dm, should allow admins to ban greifers or bullies
	return ..()
*/
