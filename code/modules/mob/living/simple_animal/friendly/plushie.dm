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
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	mob_biotypes = MOB_ORGANIC
	verb_say = "squeaks"
	verb_ask = "squeaks inquisitively"
	verb_exclaim = "squeaks intensely"
	verb_yell = "squeaks intensely"
	deathmessage = "lets out a faint squeak as the glint in its eyes disappears"
	del_on_death = TRUE
	var/obj/item/toy/plush/corpse_plush = null
	attacked_sound = 'sound/items/toysqueak1.ogg'
	death_sound = 'sound/items/toysqueak2.ogg'

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
		new_plushie.icon_state = src.icon_state
		new_plushie.name = user.name
		if(length(stored_plush.squeak_override) > 0) //theres plush sounds set for the stored plush, so grab the first one and use it
			new_plushie.attacked_sound = stored_plush.squeak_override[1]
			new_plushie.death_sound = stored_plush.squeak_override[1]

		//setup what the mob drops when it dies (the original plushie, with the brain of the user inside)
		var/obj/item/organ/brain/stored_brain = user.getorganslot(ORGAN_SLOT_BRAIN)
		stored_brain.Remove()
		stored_plush.stored_item = stored_brain
		stored_brain.forceMove(stored_plush)
		new_plushie.corpse_plush = stored_plush
		stored_plush.forceMove(new_plushie)

		//take care of the user's mind, old body and the old shell
		stored_brain.brainmob.mind.transfer_to(new_plushie)
		user.dust(drop_items = TRUE)
		qdel(src)

//drop the plushie on death and then delete the mob (the stored plushie contains the user's brain!)
/mob/living/simple_animal/pet/plushie/death()
	corpse_plush.forceMove(src.loc)
	..()

//low regen over time
/mob/living/simple_animal/pet/plush/Life()
	if(stat)
		return
	if(health < maxHealth)
		heal_overall_damage(2) //Slow life regen, they're not able to hurt anyone so this shouldn't be an issue (butterbear for reference has 10 regen)

//play plushie noise whenever it attacks
/mob/living/simple_animal/pet/plushie/attack_animal(mob/living/simple_animal/M)
	playsound(attacked_sound,50,1,1)
	..(M)


