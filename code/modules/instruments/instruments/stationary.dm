







/obj/structure/synthesized_instrument/synthesizer/piano
	name = "space piano"
	desc = "A surprisingly high-tech piano with a digital display for modifying sound output"
	icon_state = "piano"
	path = /datum/instrument/piano


//Synthesizer and minimoog. They work the same

/datum/sound_player/synthesizer
	volume = 40

/obj/structure/synthesized_instrument/synthesizer
	name = "The Synthesizer 3.0"
	desc = "This thing emits shockwaves as it plays. This is not good for your hearing."
	icon_state = "synthesizer"
	anchored = 1
	density = 1
	path = /datum/instrument
	sound_player = /datum/sound_player/synthesizer

/obj/structure/synthesized_instrument/synthesizer/attackby(obj/item/O, mob/user, params)
	if (istype(O, /obj/item/weapon/wrench))
		if (!anchored && !isinspace())
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			to_chat(usr, "<span class='notice'> You begin to tighten \the [src] to the floor...</span>")
			if (do_after(user, 20))
				if(!anchored && !isinspace())
					user.visible_message( \
						"[user] tightens \the [src]'s casters.", \
						"<span class='notice'> You tighten \the [src]'s casters. Now it can be played again.</span>", \
						"<span class='italics'>You hear ratchet.</span>")
					src.anchored = 1
		else if(anchored)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			to_chat(usr, "<span class='notice'> You begin to loosen \the [src]'s casters...</span>")
			if (do_after(user, 40))
				if(anchored)
					user.visible_message( \
						"[user] loosens \the [src]'s casters.", \
						"<span class='notice'> You loosen \the [src]. Now it can be pulled somewhere else.</span>", \
						"<span class='italics'>You hear ratchet.</span>")
					src.anchored = 0
	else
		..()

/obj/structure/synthesized_instrument/synthesizer/shouldStopPlaying(mob/user)
	return !((src && in_range(src, user) && src.anchored) || src.real_instrument.player.song.autorepeat)



/obj/structure/synthesized_instrument/synthesizer/minimoog
	name = "space minimoog"
	desc = "This is a minimoog, like a space piano, but more spacey!"
	icon_state = "minimoog"




//////////////////////////////////////////////////////////////////////////


/obj/structure/piano
	name = "space minimoog"
	icon = 'icons/obj/musician.dmi'
	icon_state = "minimoog"
	anchored = TRUE
	density = TRUE
	var/datum/song/song

/obj/structure/piano/unanchored
	anchored = FALSE

/obj/structure/piano/New()
	..()
	song = new("piano", src)

	if(prob(50) && icon_state == initial(icon_state))
		name = "space minimoog"
		desc = "This is a minimoog, like a space piano, but more spacey!"
		icon_state = "minimoog"
	else
		name = "space piano"
		desc = "This is a space piano, like a regular piano, but always in tune! Even if the musician isn't."
		icon_state = "piano"

/obj/structure/piano/Destroy()
	qdel(song)
	song = null
	return ..()

/obj/structure/piano/Initialize(mapload)
	. = ..()
	if(mapload)
		song.tempo = song.sanitize_tempo(song.tempo) // tick_lag isn't set when the map is loaded

/obj/structure/piano/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	interact(user)

/obj/structure/piano/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/piano/interact(mob/user)
	ui_interact(user)

/obj/structure/piano/ui_interact(mob/user)
	if(!user || !anchored)
		return

	if(!user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return 1
	user.set_machine(src)
	song.ui_interact(user)

/obj/structure/piano/wrench_act(mob/living/user, obj/item/I)
	default_unfasten_wrench(user, I, 40)
	return TRUE




/obj/structure/musician
	name = "Not A Piano"
	desc = "Something broke, contact coderbus."
	var/can_play_unanchored = FALSE

/obj/structure/musician/proc/should_stop_playing(mob/user)
	if(!(anchored || can_play_unanchored))
		return TRUE
	if(!user)
		return FALSE
	return !user.canUseTopic(src, FALSE, TRUE, FALSE, FALSE)		//can play with TK and while resting because fun.






