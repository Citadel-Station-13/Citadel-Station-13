/mob/living/simple_animal/astral
	name = "Astral projection"
	desc = "A soul of someone projecting their mind."
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost"
	icon_living = "ghost"
	mob_biotypes = list(MOB_SPIRIT)
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
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 0
	minbodytemp = 0
	maxbodytemp = 100000

/mob/living/simple_animal/astral/death()
	icon_state = "shade_dead"
	Stun(1000)
	canmove = 0
	friendly = "deads at"
	pseudo_death = TRUE
	incorporeal_move = 0
	to_chat(src, "<span class='notice'>Your astral projection is interrupted and your mind is sent back to your body with a shock!</span>")

/mob/living/simple_animal/astral/ClickOn(var/atom/A, var/params)
	..()
	if(pseudo_death == FALSE)
		if(isliving(A))
			var/message = html_decode(stripped_input(src, "Enter a message to send to [A]", MAX_MESSAGE_LEN))
			if(!message)
				return
			to_chat(A, "[src] projects into your mind, <b><i> \"[message]\"</b></i>")
			log_game("FERMICHEM: [src] has astrally transmitted [message] into [A]")
