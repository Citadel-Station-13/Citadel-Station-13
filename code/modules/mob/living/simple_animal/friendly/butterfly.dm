/mob/living/simple_animal/butterfly
	name = "butterfly"
	desc = "A colorful butterfly, how'd it get up here?"
	icon_state = "butterfly"
	icon_living = "butterfly"
	icon_dead = "butterfly_dead"
	turns_per_move = 1
	response_help = "shoos"
	response_disarm = "brushes aside"
	response_harm = "squashes"
	speak_emote = list("flutters")
	maxHealth = 2
	health = 2
	harm_intent_damage = 1
	friendly = "nudges"
	density = 0
	flying = 1
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	ventcrawler = 2
	mob_size = MOB_SIZE_TINY
	gold_core_spawnable = 2
	verb_say = "flutters"
	verb_ask = "flutters inquisitively"
	verb_exclaim = "flutters intensely"
	verb_yell = "flutters intensely"

/mob/living/simple_animal/butterfly/New()
	..()
	color = rgb(rand(0, 255), rand(0, 255), rand(0, 255))
