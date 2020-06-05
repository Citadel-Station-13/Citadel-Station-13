//simplemob plushie that can be controlled by players
/mob/living/simple_animal/pet/plushie
	name = "Plushie"
	desc = "A living plushie!"
	icon = 'icons/obj/plushes.dmi'
	icon_state = "debug"
	icon_living = "debug"
	speak_emote = list("squeaks")
	maxHealth = 50
	health = 50
	density = FALSE
	movement_type = FLYING
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	mob_biotypes = MOB_ORGANIC
	gold_core_spawnable = FRIENDLY_SPAWN
	verb_say = "squeaks"
	verb_ask = "squeaks inquisitively"
	verb_exclaim = "squeaks intensely"
	verb_yell = "squeaks intensely"
	speak_chance = 1

//shell that lets people turn into the plush or poll for ghosts
/obj/item/toy/plushie/shell
	name = "Plushie Shell"
	desc = "A plushie. Its eyes seem to be staring right back at you. Something isn't quite right."
	icon = 'icons/obj/plushes.dmi'
	icon_state = "debug"

//attacking yourself transfers your mind into the plush!
/obj/item/toy/plushie/shell/attack_self(mob/user)
	to_chat(user, "<span class='userdanger'>You hug the strange plushie. You fool.</span>")
	var/mob/new_plushie = new /mob/living/simple_animal/pet/plushie/(user.loc)
	new_plushie.icon = src.icon
	new_plushie.icon_state = src.icon_state
	if(user.mind)
		user.mind.transfer_to(new_plushie)
	qdel(src)