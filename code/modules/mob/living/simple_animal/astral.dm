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
	friendly = "touches"
	loot = null
	maxHealth = 5
	health = 5
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
			to_chat(A, "<b>[src] speaks into your mind,</b><i> \"[message]\"</i>")
			log_game("FERMICHEM: [src] has astrally transmitted [message] into [A]")
