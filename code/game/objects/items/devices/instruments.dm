//copy pasta of the space piano, don't hurt me -Pete
/obj/item/device/instrument
	name = "generic instrument"
	burn_state = FLAMMABLE
	burntime = 20
	var/datum/song/handheld/song
	var/instrumentId = "generic"
	var/instrumentExt = "ogg"

/obj/item/device/instrument/New()
	song = new(instrumentId, src)
	song.instrumentExt = instrumentExt

/obj/item/device/instrument/Destroy()
	qdel(song)
	song = null
	return ..()

/obj/item/device/instrument/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] begins to play 'Gloomy Sunday'! It looks like \he's trying to commit suicide..</span>")
	return (BRUTELOSS)

/obj/item/device/instrument/initialize()
	song.tempo = song.sanitize_tempo(song.tempo) // tick_lag isn't set when the map is loaded
	..()

/obj/item/device/instrument/attack_self(mob/user)
	if(!user.IsAdvancedToolUser())
		user << "<span class='warning'>You don't have the dexterity to do this!</span>"
		return 1
	interact(user)

/obj/item/device/instrument/interact(mob/user)
	if(!user)
		return

	if(!isliving(user) || user.stat || user.restrained() || user.lying)
		return

	user.set_machine(src)
	song.interact(user)

/obj/item/device/instrument/violin
	name = "space violin"
	desc = "A wooden musical instrument with four strings and a bow. \"The devil went down to space, he was looking for an assistant to grief.\""
	icon = 'icons/obj/musician.dmi'
	icon_state = "violin"
	item_state = "violin"
	force = 10
	hitsound = "swing_hit"
	instrumentId = "violin"

/obj/item/device/instrument/guitar
	name = "guitar"
	desc = "It's made of wood and has bronze strings."
	icon = 'icons/obj/musician.dmi'
	icon_state = "guitar"
	item_state = "guitar"
	force = 10
	attack_verb = list("played metal on", "serenaded", "crashed", "smashed")
	hitsound = 'sound/weapons/stringsmash.ogg'
	instrumentId = "guitar"

/obj/item/device/instrument/eguitar
	name = "eletric guitar"
	desc = "Makes all your shredding needs possible."
	icon = 'icons/obj/musician.dmi'
	icon_state = "eguitar"
	item_state = "eguitar"
	force = 12
	attack_verb = list("played metal on", "shredded", "crashed", "smashed")
	hitsound = 'sound/weapons/stringsmash.ogg'
	instrumentId = "eguitar"