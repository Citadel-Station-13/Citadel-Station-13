/mob/living/simple_animal/astral
	name = "Astral projection"
	desc = "A soul of someone projecting their mind."
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost"
	icon_living = "ghost"
	mob_biotypes = MOB_SPIRIT
	has_field_of_vision = FALSE //we are a spoopy ghost
	attacktext = "raises the hairs on the neck of"
	response_harm = "disrupts the concentration of"
	response_disarm = "wafts"
	friendly = "communes with"
	loot = null
	maxHealth = 10
	health = 10
	melee_damage_lower = 0
	melee_damage_upper = 0
	obj_damage = 0
	deathmessage = "disappears as if it was never really there to begin with"
	incorporeal_move = 1
	alpha = 50
	attacktext = "touches the mind of"
	speak_emote = list("echos")
	movement_type = FLYING
	var/pseudo_death = FALSE
	var/posses_safe = FALSE
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 0
	minbodytemp = 0
	maxbodytemp = 100000
	blood_volume = 0

/mob/living/simple_animal/astral/death()
	icon_state = "shade_dead"
	Stun(1000)
	friendly = "deads at"
	pseudo_death = TRUE
	incorporeal_move = 0
	to_chat(src, "<span class='notice'>Your astral projection is interrupted and your mind is sent back to your body with a shock!</span>")

/mob/living/simple_animal/astral/ClickOn(var/atom/A, var/params)
	..()
	if(pseudo_death == FALSE)
		if(isliving(A))
			if(ishuman(A))
				var/mob/living/carbon/human/H = A
				if(H.reagents.has_reagent(/datum/reagent/fermi/astral) && !H.mind)
					var/datum/reagent/fermi/astral/As = locate(/datum/reagent/fermi/astral) in H.reagents.reagent_list
					if(As.originalmind == src.mind && As.current_cycle < 10 && H.stat != DEAD) //So you can return to your body.
						to_chat(src, "<span class='warning'><b><i>The intensity of the astrogen in your body is too much allow you to return to yourself yet!</b></i></span>")
						return
					to_chat(src, "<b><i>You astrally possess [H]!</b></i>")
					log_game("FERMICHEM: [src] has astrally possessed [A]!")
					src.mind.transfer_to(H)
					qdel(src)
			var/message = html_decode(stripped_input(src, "Enter a message to send to [A]", MAX_MESSAGE_LEN))
			if(!message)
				return
			to_chat(A, "[src] projects into your mind, <b><i> \"[message]\"</b></i>")
			log_game("FERMICHEM: [src] has astrally transmitted [message] into [A]")

//Delete the mob if there's no mind! Pay that mob no mind.
/mob/living/simple_animal/astral/Life()
	if(!mind)
		qdel(src)
	. = ..()
