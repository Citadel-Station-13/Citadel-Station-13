/datum/disease/crabcancer
	name = "Crab Cancer"
	form = "Skin Cancer"
	max_stages = 3
	cure_text = "Mutadone"
	spread_text = "Noncontagious"
	cures = list(/datum/reagent/medicine/mutadone)
	agent = "Carcinisoprojection Jelly"
	viable_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	permeability_mod = 1
	desc = "If left untreated, the patient will rapidly and painfully grow flesh that will fall off the subject. This can result in death if unmaintained."
	severity = DISEASE_SEVERITY_DANGEROUS
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	visibility_flags = HIDDEN_PANDEMIC
	bypasses_immunity = TRUE

/datum/disease/crabcancer/stage_act()
	..()
	switch(stage)
		if(1)
			if(prob(10))
				to_chat(affected_mob, "<span class='warning'>" + pick("You feel uncomfortable.",
				"You can feel your arms and legs throbbing.",
				"You feel... crabby.",
				"You're starting to smell like seafood.") + "</span>")
		if(2)
			if(prob(10))
				to_chat(affected_mob, "<span class='danger'>" + pick("Your flesh is starting to look deformed.",
				"You feel your flesh bubbling and swelling.",
				"You think you see pincers coming out of your flesh.",
				"It's time for crab...") + "</span>")
		if(3)
			if(prob(5))
				to_chat(affected_mob, "<span class='danger'>" + pick("Your skin forms black, rough patches!",
				"The pain is unbearable!",
				"Your skin is forming painful cysts!") + "</span>")
				affected_mob.take_bodypart_damage(rand(1,5))
			if(prob(5))
				affected_mob.visible_message("<span class='danger'>[affected_mob]'s own flesh swells and tears away from \him!</span>", \
				"<span class='userdanger'>" + pick("You feel your flesh swelling and tearing away from you!",
				"Your own flesh grows and falls beneath you!",
				"The pain... the crabby meat falls off you!",
				"Your flesh... it tears!",
				"It is now time for crab!") + "</span>",
				"<span class='italics'>You hear a disgusting squelch of flesh being torn.</span>")
				playsound(affected_mob, 'sound/items/poster_ripped.ogg', 50, TRUE)
				playsound(get_turf(affected_mob), 'sound/effects/splat.ogg', 20, TRUE)
				affected_mob.emote("scream")
				affected_mob.take_bodypart_damage(rand(15,25))
				var/humanmeatamount = rand(0,2)
				var/crabmeatamount = rand(1,2)
				var/meattype = /obj/item/reagent_containers/food/snacks/meat/slab/human
				if(ishuman(affected_mob))
					meattype = affected_mob.dna.species.meat
				else //grab the carbon's meat instead (usually this means monkey meat... though other disease-compatible carbon mobs might apply.)
					meattype = affected_mob.type_of_meat

				if(humanmeatamount)
					for(var/i=1 to humanmeatamount)
						var/obj/item/reagent_containers/food/snacks/meat/slab/newmeat = new meattype
						newmeat.name = "[affected_mob.real_name] [newmeat.name]"
						newmeat.forceMove(affected_mob.loc)
				if(crabmeatamount)
					for(var/i=1 to crabmeatamount)
						new /obj/item/reagent_containers/food/snacks/meat/rawcrab(affected_mob.loc)
				affected_mob.jitteriness += 3

