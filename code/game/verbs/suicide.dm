/mob/var/suiciding = 0

/mob/living/carbon/human/verb/suicide()
	set hidden = 1
	if(!canSuicide())
		return
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
	if(!canSuicide())
		return
	if(confirm == "Yes")
		suiciding = 1
		log_game("[key_name(src)] (job: [job ? "[job]" : "None"]) commited suicide at [get_area(src)].")
		message_admins("[key_name(src)] (job: [job ? "[job]" : "None"]) commited suicide at [get_area(src)].")
		var/obj/item/held_item = get_active_hand()
		if(held_item)
			var/damagetype = held_item.suicide_act(src)
			if(damagetype)
				if(damagetype & SHAME)
					adjustStaminaLoss(200)
					suiciding = 0
					return
				var/damage_mod = 0
				for(var/T in list(BRUTELOSS, FIRELOSS, TOXLOSS, OXYLOSS))
					damage_mod += (T & damagetype) ? 1 : 0
				damage_mod = max(1, damage_mod)

				//Do 200 damage divided by the number of damage types applied.
				if(damagetype & BRUTELOSS)
					adjustBruteLoss(200/damage_mod)

				if(damagetype & FIRELOSS)
					adjustFireLoss(200/damage_mod)

				if(damagetype & TOXLOSS)
					adjustToxLoss(200/damage_mod)

				if(damagetype & OXYLOSS)
					adjustOxyLoss(200/damage_mod)

				//If something went wrong, just do normal oxyloss
				if(!(damagetype & (BRUTELOSS | FIRELOSS | TOXLOSS | OXYLOSS) ))
					adjustOxyLoss(max(200 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))

				death(0)
				return

		var/suicide_message = pick("[src] is attempting to bite \his tongue off! It looks like \he's trying to commit suicide.", \
							"[src] is jamming \his thumbs into \his eye sockets! It looks like \he's trying to commit suicide.", \
							"[src] is twisting \his own neck! It looks like \he's trying to commit suicide.", \
							"[src] is holding \his breath! It looks like \he's trying to commit suicide.")

		visible_message("<span class='danger'>[suicide_message]</span>", "<span class='userdanger'>[suicide_message]</span>")

		adjustOxyLoss(max(200 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		death(0)

/mob/living/carbon/brain/verb/suicide()
	set hidden = 1
	if(!canSuicide())
		return
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
	if(!canSuicide())
		return
	if(confirm == "Yes")
		suiciding = 1
		visible_message("<span class='danger'>[src]'s brain is growing dull and lifeless. It looks like it's lost the will to live.</span>", \
						"<span class='userdanger'>[src]'s brain is growing dull and lifeless. It looks like it's lost the will to live.</span>")
		spawn(50)
			death(0)

/mob/living/carbon/monkey/verb/suicide()
	set hidden = 1
	if(!canSuicide())
		return
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
	if(!canSuicide())
		return
	if(confirm == "Yes")
		suiciding = 1
		//instead of killing them instantly, just put them at -175 health and let 'em gasp for a while
		visible_message("<span class='danger'>[src] is attempting to bite \his tongue. It looks like \he's trying to commit suicide.</span>", \
				"<span class='userdanger'>[src] is attempting to bite \his tongue. It looks like \he's trying to commit suicide.</span>")
		adjustOxyLoss(max(200- getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		death(0)

/mob/living/silicon/ai/verb/suicide()
	set hidden = 1
	if(!canSuicide())
		return
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
	if(!canSuicide())
		return
	if(confirm == "Yes")
		suiciding = 1
		visible_message("<span class='danger'>[src] is powering down. It looks like \he's trying to commit suicide.</span>", \
				"<span class='userdanger'>[src] is powering down. It looks like \he's trying to commit suicide.</span>")
		//put em at -175
		adjustOxyLoss(max(maxHealth * 2 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		death(0)

/mob/living/silicon/robot/verb/suicide()
	set hidden = 1
	if(!canSuicide())
		return
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
	if(!canSuicide())
		return
	if(confirm == "Yes")
		suiciding = 1
		visible_message("<span class='danger'>[src] is powering down. It looks like \he's trying to commit suicide.</span>", \
				"<span class='userdanger'>[src] is powering down. It looks like \he's trying to commit suicide.</span>")
		//put em at -175
		adjustOxyLoss(max(maxHealth * 2 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		death(0)

/mob/living/silicon/pai/verb/suicide()
	set category = "pAI Commands"
	set desc = "Kill yourself and become a ghost (You will receive a confirmation prompt)"
	set name = "pAI Suicide"
	var/answer = input("REALLY kill yourself? This action can't be undone.", "Suicide", "No") in list ("Yes", "No")
	if(answer == "Yes")
		card.removePersonality()
		var/turf/T = get_turf(src.loc)
		T.visible_message("<span class='notice'>[src] flashes a message across its screen, \"Wiping core files. Please acquire a new personality to continue using pAI device functions.\"</span>", "<span class='notice'>[src] bleeps electronically.</span>")
		death(0)
	else
		src << "Aborting suicide attempt."

/mob/living/carbon/alien/humanoid/verb/suicide()
	set hidden = 1
	if(!canSuicide())
		return
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
	if(!canSuicide())
		return
	if(confirm == "Yes")
		suiciding = 1
		visible_message("<span class='danger'>[src] is thrashing wildly! It looks like \he's trying to commit suicide.</span>", \
				"<span class='userdanger'>[src] is thrashing wildly! It looks like \he's trying to commit suicide.</span>", \
				"<span class='italics'>You hear thrashing.</span>")
		//put em at -175
		adjustOxyLoss(max(200 - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		death(0)

/mob/living/simple_animal/verb/suicide()
	set hidden = 1
	if(!canSuicide())
		return
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
	if(!canSuicide())
		return
	if(confirm == "Yes")
		suiciding = 1
		visible_message("<span class='danger'>[src] begins to fall down. It looks like \he's lost the will to live.</span>", \
						"<span class='userdanger'>[src] begins to fall down. It looks like \he's lost the will to live.</span>")
		death(0)


/mob/living/proc/canSuicide()
	if(stat == CONSCIOUS)
		if(mental_dominator)
			src << "<span class='warning'>This body's force of will is too strong! You can't break it enough to murder them.</span>"
			if(mind_control_holder)
				mind_control_holder << "<span class='userdanger'>Through tremendous force of will, you stop a suicide attempt!</span>"
			return 0
		return 1
	else if(stat == DEAD)
		src << "You're already dead!"
	else if(stat == UNCONSCIOUS)
		src << "You need to be conscious to suicide!"
	return

/mob/living/carbon/canSuicide()
	if(!..())
		return
	if(!canmove || restrained())	//just while I finish up the new 'fun' suiciding verb. This is to prevent metagaming via suicide
		src << "You can't commit suicide whilst restrained! ((You can type Ghost instead however.))"
		return
	return 1
