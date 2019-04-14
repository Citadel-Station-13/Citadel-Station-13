/datum/status_effect/chem/SGDF
	id = "SGDF"
	var/mob/living/clone

/datum/status_effect/chem/SGDF/on_apply()
	var/typepath = owner.type
	clone = new typepath(owner.loc)
	var/mob/living/carbon/O = owner
	var/mob/living/carbon/C = clone
	if(istype(C) && istype(O))
		C.real_name = O.real_name
		O.dna.transfer_identity(C)
		C.updateappearance(mutcolor_update=1)
	return ..()

/datum/status_effect/chem/SGDF/tick()
	if(owner.stat == DEAD)
		if(clone && clone.stat != DEAD)
			if(owner.mind)
				owner.mind.transfer_to(clone)
				owner.visible_message("<span class='warning'>Lucidity shoots to your previously blank mind as your mind suddenly finishes the cloning process. You marvel for a moment at yourself, as your mind subconciously recollects all your memories up until the point when you cloned yourself. curiously, you find that you memories are blank after you ingested the sythetic serum, leaving you to wonder where the other you is.</span>")
			clone = null
		if(!clone || clone.stat == DEAD)
			to_chat(owner, "<span class='notice'>[linked_extract] desperately tries to move your soul to a living body, but can't find one!</span>")
	..()
