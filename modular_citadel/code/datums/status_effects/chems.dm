/datum/status_effect/chem/SGDF
	id = "SGDF"
	var/mob/living/carbon/human/fermi_Clone = null

/datum/status_effect/chem/SGDF/on_apply(mob/living/carbon/M)
	var/typepath = M.type
	fermi_Clone = new typepath(M.loc)
	//var/mob/living/carbon/M = owner
	//var/mob/living/carbon/C = fermi_Clone
	if(istype(fermi_Clone) && istype(M))
		fermi_Clone.real_name = M.real_name
		M.dna.transfer_identity(fermi_Clone, transfer_SE=1)
		fermi_Clone.updateappearance(mutcolor_update=1)
	return ..()

/datum/status_effect/chem/SGDF/tick(mob/living/M)
	if(M.stat == DEAD)
		if(fermi_Clone && fermi_Clone.stat != DEAD)
			if(M.mind)
				M.mind.transfer_to(fermi_Clone)
				M.visible_message("<span class='warning'>Lucidity shoots to your previously blank mind as your mind suddenly finishes the cloning process. You marvel for a moment at yourself, as your mind subconciously recollects all your memories up until the point when you cloned yourself. curiously, you find that you memories are blank after you ingested the sythetic serum, leaving you to wonder where the other you is.</span>")
			fermi_Clone = null
		//if(!clone || clone.stat == DEAD)
		//	to_chat(owner, "<span class='notice'>[linked_extract] desperately tries to move your soul to a living body, but can't find one!</span>")
	..()
