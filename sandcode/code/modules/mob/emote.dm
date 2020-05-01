/* /datum/emote/living/howl
	if(!ishuman(user))
		key = "howl"
		key_third_person = "howls"
		message = "howls!"
		emote_type = EMOTE_AUDIBLE
		mob_type_allowed_typecache = list(/mob/living/carbon)

/datum/emote/living/howl/run_emote(mob/living/user, params)
	if(ishuman(user))
		if(is_species(user, /datum/species/mammal))
			if(user.nextsoundemote >= world.time)
				return
			user.nextsoundemote = world.time + 7
			playsound(user, 'sandcode/sound/voice/howl.ogg', 50, 1, -1)
		. = ..()

someone fix this shit plz :(
*/

/datum/emote/living/blep
	key = "blep"
	key_third_person = "bleps"
	message = "bleps!"
	emote_type = EMOTE_AUDIBLE
	mob_type_allowed_typecache = list(/mob/living/carbon)
