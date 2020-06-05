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

/mob/living/simple_animal/pet/plushie/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/mob_holder, "plushie")

//shell that lets people turn into the plush or poll for ghosts
/obj/item/toy/plushie/shell
	name = "Plushie Shell"
	desc = "A plushie. Its eyes seem to be staring right back at you. Something isn't quite right."
	icon = 'icons/obj/plushes.dmi'
	icon_state = "debug"
	var/next_ask //When you can next poll for ghosts to take over the plush
	var/askDelay = 600 //1 minute cooldown on polling for ghosts
	var/mob/living/brain/brainmob = null

/obj/item/toy/plushie/shell/Initialize()
	next_ask = world.time

//attacking yourself transfers your mind into the plush!
/obj/item/toy/plushie/shell/attack(mob/user, mob/M)
	if(user == M) // make sure they're using it on themselves
		var/safety = alert(user, "The plushie is staring back at you. This seems like a terrible idea.", "Are you sure about this?", "Hug the plushie", "Abort")
		if(safety == "Abort" || !in_range(src, user))
			return
		to_chat(user, "<span class='userdanger'>You hug the strange plushie. You fool.</span>")
		var/mob/new_plushie = new /mob/living/simple_animal/pet/plushie/(user.loc)
		new_plushie.icon = src.icon
		new_plushie.icon_state = src.icon_state
		new_plushie.name = user.name
		if(user.mind)
			user.mind.transfer_to(new_plushie)
			var/new_name = stripped_input(src, "Enter your name, or press \"Cancel\" to stick with Plushie.", "Name Change")
			if(new_name)
				to_chat(src, "<span class='notice'>Your name is now <b>\"new_name\"</b>!</span>")
				name = new_name
			qdel(src)
	else
		return ..()

//using it in your hand polls ghosts to take over the plush instead!
/obj/item/toy/plushie/shell/attack_self(mob/user)
	if(next_ask > world.time)
		return ..()
	to_chat(user, "You feel tense energy radiating from the plushie!")
	next_ask = world.time + askDelay
	notify_ghosts("Sentient plushie in [get_area(src)]!", ghost_sound = null, enter_link = "<a href=?src=[REF(src)];activate=1>(Click to enter)</a>", source = src, action = NOTIFY_ATTACK, flashwindow = FALSE, ignore_key = POLL_IGNORE_POSIBRAIN, ignore_dnr_observers = TRUE)
