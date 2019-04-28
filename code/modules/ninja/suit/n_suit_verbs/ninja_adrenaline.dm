//Wakes the user so they are able to do their thing. Also injects a decent dose of radium.
//Movement impairing would indicate drugs and the like.
/obj/item/clothing/suit/space/space_ninja/proc/ninjaboost()

	if(!ninjacost(0,N_ADRENALINE))
		var/mob/living/carbon/human/H = affecting
		H.SetSleeping(0)
		H.SetStun(0)
		H.SetKnockdown(0)
		H.SetUnconscious(0)
		H.adjustStaminaLoss(-150)
		H.stuttering = 0
		H.updatehealth()
		H.update_stamina()
		H.resting = 0
		H.lying = 0
		H.update_canmove()

		H.reagents.add_reagent("inaprovaline", 3) //let's give another chance to dumb fucks who forget to breathe
		H.reagents.add_reagent("synaptizine", 10)
		H.reagents.add_reagent("omnizine", 10)
		H.reagents.add_reagent("stimulants", 10)

		H.say(pick("A CORNERED FOX IS MORE DANGEROUS THAN A JACKAL!","HURT ME MOOORRREEE!","IMPRESSIVE!"), forced = "ninjaboost")

		a_boost--
		to_chat(H, "<span class='notice'>There are <B>[a_boost]</B> adrenaline boosts remaining.</span>")
		s_coold = 3
		addtimer(CALLBACK(src, .proc/ninjaboost_after), 70)

/obj/item/clothing/suit/space/space_ninja/proc/ninjaboost_after()
	var/mob/living/carbon/human/H = affecting
	H.reagents.add_reagent("radium", a_transfer)
	to_chat(H, "<span class='danger'>You are beginning to feel the after-effect of the injection.</span>")
