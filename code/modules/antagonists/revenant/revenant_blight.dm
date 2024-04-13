/datum/disease/revblight
	name = "Unnatural Wasting"
	max_stages = 5
	stage_prob = 10
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	cure_text = "Holy water or extensive rest."
	spread_text = "A burst of unholy energy"
	cures = list("holywater")
	cure_chance = 50 //higher chance to cure, because revenants are assholes
	agent = "Unholy Forces"
	viable_mobtypes = list(/mob/living/carbon/human)
	disease_flags = CURABLE
	permeability_mod = 1
	severity = DISEASE_SEVERITY_DANGEROUS
	var/finalstage = FALSE //Because we're spawning off the cure in the final stage, we need to check if we've done the final stage's effects.
	var/depression = FALSE

/datum/disease/revblight/cure()
	if(affected_mob)
		affected_mob.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, "#1d2953")
		if(affected_mob.dna && affected_mob.dna.species)
			affected_mob.dna.species.handle_mutant_bodyparts(affected_mob)
			affected_mob.dna.species.handle_hair(affected_mob)
		SEND_SIGNAL(affected_mob, COMSIG_CLEAR_MOOD_EVENT, "rev_blight")
	..()

/datum/disease/revblight/stage_act()
	if(!finalstage)
		if(affected_mob.lying && prob(stage*4))
			to_chat(affected_mob, "<span class='notice'>You feel better.</span>")
			cure()
			return
		if(prob(stage*3))
			to_chat(affected_mob, "<span class='revennotice'>You suddenly feel [pick("sick and tired", "disoriented", "tired and confused", "nauseated", "faint", "dizzy")]...</span>")
			affected_mob.confused += 8
			affected_mob.adjustStaminaLoss(8)
			new /obj/effect/temp_visual/revenant(affected_mob.loc)
		if(prob(45))
			affected_mob.adjustStaminaLoss(stage)
	..() //So we don't increase a stage before applying the stage damage.
	switch(stage)
		if(2)
			if(prob(5))
				affected_mob.emote("pale")
		if(3)
			if(!depression)
				SEND_SIGNAL(affected_mob, COMSIG_ADD_MOOD_EVENT, "rev_blight", /datum/mood_event/revenant_blight)
				depression = TRUE
			SEND_SIGNAL(affected_mob, COMSIG_MODIFY_SANITY, -0.12, SANITY_CRAZY)
			if(prob(10))
				affected_mob.emote(pick("pale","shiver"))
		if(4)
			SEND_SIGNAL(affected_mob, COMSIG_MODIFY_SANITY, -0.18, SANITY_CRAZY)
			if(prob(15))
				affected_mob.emote(pick("pale","shiver","cries"))
		if(5)
			if(!finalstage)
				finalstage = TRUE
				to_chat(affected_mob, "<span class='revenbignotice'>You feel like [pick("nothing's worth it anymore", "nobody ever needed your help", "nothing you did mattered", "everything you tried to do was worthless")].</span>")
				affected_mob.adjustStaminaLoss(45)
				if(affected_mob.dna?.species)
					affected_mob.dna.species.handle_mutant_bodyparts(affected_mob,"#1d2953")
					affected_mob.dna.species.handle_hair(affected_mob,"#1d2953")
				affected_mob.visible_message("<span class='warning'>[affected_mob] looks terrifyingly gaunt...</span>", "<span class='revennotice'>You suddenly feel like your skin is <i>wrong</i>...</span>")
				affected_mob.add_atom_colour("#1d2953", TEMPORARY_COLOUR_PRIORITY)
				new /obj/effect/temp_visual/revenant(affected_mob.loc)
				addtimer(CALLBACK(src, PROC_REF(curses)), 150)

/datum/disease/revblight/proc/curses()
	if(QDELETED(affected_mob))
		return
	affected_mob.playsound_local(affected_mob, 'sound/effects/curse5.ogg', 40, 1, -1)
	to_chat(affected_mob, "<span class='revendanger'>You sense the terrific curse of a vengeful ghost befall upon you...</span>")
	affected_mob.apply_necropolis_curse(null, 7 MINUTES) //Once the blight has done its course without being cured beforehand, it will cast a necrocurse to compensate how underpowered it's.
	cure()
