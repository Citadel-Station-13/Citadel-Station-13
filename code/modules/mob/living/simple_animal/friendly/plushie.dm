//simplemob plushie that can be controlled by players
/mob/living/simple_animal/pet/plushie
	name = "Plushie"
	desc = "A living plushie!"
	icon = 'icons/obj/plushes.dmi'
	icon_state = "debug"
	icon_living = "debug"
	speak_emote = list("squeaks")
	maxHealth = 100
	health = 100
	density = FALSE
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	mob_biotypes = MOB_ORGANIC
	verb_say = "squeaks"
	verb_ask = "squeaks inquisitively"
	verb_exclaim = "squeaks intensely"
	verb_yell = "squeaks intensely"
	deathmessage = "lets out a faint squeak as the glint in its eyes disappears"
	footstep_type = FOOTSTEP_MOB_BAREFOOT

/mob/living/simple_animal/pet/plushie/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/mob_holder, "plushie")

//shell that lets people turn into the plush or poll for ghosts
/obj/item/toy/plushie_shell
	name = "Plushie Shell"
	desc = "A plushie. Its eyes seem to be staring right back at you. Something isn't quite right."
	icon = 'icons/obj/plushes.dmi'
	icon_state = "debug"
	var/obj/item/toy/plush/stored_plush = null

//attacking yourself transfers your mind into the plush!
/obj/item/toy/plushie_shell/attack_self(mob/user)
	if(user.mind)
		var/safety = alert(user, "The plushie is staring back at you intensely, it seems cursed!", "Hugging this is a bad idea.", "Hug it!", "Cancel")
		if(safety == "Cancel" || !in_range(src, user))
			return
		to_chat(user, "<span class='userdanger'>You hug the strange plushie. You fool.</span>")

		//setup the mob
		var/mob/living/simple_animal/pet/plushie/new_plushie = new /mob/living/simple_animal/pet/plushie/(user.loc)
		new_plushie.icon = src.icon
		new_plushie.icon_dead = src.icon
		new_plushie.icon_state = src.icon_state
		new_plushie.name = src.name

		//make the mob sentient
		user.mind.transfer_to(new_plushie)

		//add sounds to mob
		new_plushie.AddComponent(/datum/component/squeak, stored_plush.squeak_override)

		//take care of the user's old body and the old shell
		user.dust(drop_items = TRUE)
		qdel(src)

//low regen over time
/mob/living/simple_animal/pet/plushie/Life()
	if(stat)
		return
	if(health < maxHealth)
		heal_overall_damage(5) //Decent life regen, they're not able to hurt anyone so this shouldn't be an issue (butterbear for reference has 10 regen)
