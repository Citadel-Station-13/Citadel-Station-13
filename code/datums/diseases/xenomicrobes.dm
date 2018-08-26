/datum/disease/xenomicrobes
	name = "Xenomorph Cytogenetic Transformation Vector"
	max_stages = 5
	spread_text = "Acute"
	spread_flags = DISEASE_SPREAD_SPECIAL
	cure_text = "Spaceacillin & Glycerol"
	cures = list("spaceacillin", "glycerol")
	agent = "Rip-LEY Alien Microbes"
	viable_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	cure_chance = 5
	desc = "A cellular infection that transforms the victim into a Xenomorph."
	severity = DISEASE_SEVERITY_BIOHAZARD
	stage_prob = 10

/datum/disease/xenomicrobes/stage_act()
	..()
	switch(stage)
		if(2)
			if (prob(8))
				to_chat(affected_mob, "Your throat feels scratchy.")
			if (prob(8))
				to_chat(affected_mob, "<span class='danger'>Kill...</span>")
		if(3)
			if (prob(4))
				to_chat(affected_mob, "<span class='danger'>You feel a stabbing pain in your head.</span>")
				affected_mob.Unconscious(40)
			if (prob(8))
				to_chat(affected_mob, "<span class='danger'>Your throat feels very scratchy.</span>")
			if (prob(8))
				to_chat(affected_mob, "Your skin feels tight.")
			if (prob(8))
				to_chat(affected_mob, "<span class='danger'>You can feel something shift from...within.</span>")
		if(4)
			if (prob(20))
				affected_mob.say(pick("You look delicious.", "Going to... devour you...", "SSssSssss!", "You will... serve as... a host... for the hive..."))
			if (prob(8))
				to_chat(affected_mob, "<span class='danger'>Your skin feels very tight.</span>")
			if (prob(8))
				to_chat(affected_mob, "<span class='danger'>Your blood boils!</span>")
			if (prob(8))
				to_chat(affected_mob, "<span class='danger'>You can feel... something shifting... within you.</span>")
		if(5)
			to_chat(affected_mob, "<span class='danger'>Your skin feels as though it's about to burst off!</span>")
			if (prob(50))
				var/mob/living/new_mob

				for(var/obj/item/W in affected_mob.get_equipped_items(TRUE))
					affected_mob.dropItemToGround(W)
				for(var/obj/item/I in affected_mob.held_items)
					affected_mob.dropItemToGround(I)

				var/randomize = pick("sentinel","hunter","drone")
				switch(randomize)
					if("sentinel")
						to_chat(affected_mob, "<span class='danger'>You burst from your old body, being reborn. You feel a tingling sensation within your throat.</span>")
						new_mob = new /mob/living/carbon/alien/humanoid/sentinel(affected_mob.loc)

					if("hunter")
						to_chat(affected_mob, "<span class='danger'>You burst from your old body, being reborn. You feel... stronger.</span>")
						new_mob = new /mob/living/carbon/alien/humanoid/hunter(affected_mob.loc)

					if("drone")
						to_chat(affected_mob, "<span class='danger'>You burst from your old body, being reborn. An incessant desire to expand the hive reverberates within you.</span>")
						new_mob = new /mob/living/carbon/alien/humanoid/drone(affected_mob.loc)

				if(affected_mob.mind)
					affected_mob.mind.transfer_to(new_mob)
				else
					new_mob.key = affected_mob.key
				qdel(affected_mob)
				return new_mob
	return
