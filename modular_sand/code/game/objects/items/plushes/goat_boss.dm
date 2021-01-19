//i hate these fucking goats but i can't murder them, for i know they will haunt me in my sleep if i do so. so i nerf them instead.
/obj/item/toy/plush/goatplushie
	name = "strange goat plushie"
	icon = 'modular_sand/icons/obj/plushes.dmi'
	icon_state = "goat"
	desc = "Despite its cuddly appearance and plush nature, it will beat you up all the same. Goats never change."
	squeak_override = list('modular_sand/sound/items/goatsound.ogg'=1)

/obj/item/toy/plush/goatplushie/angry
	icon = 'modular_sand/icons/obj/plushes.dmi'
	var/mob/living/carbon/target
	throwforce = 5
	var/cooldown = 0
	var/cooldown_modifier = 20

/obj/item/toy/plush/goatplushie/angry/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/item/toy/plush/goatplushie/angry/process()
	if (prob(25) && !target)
		var/list/targets_to_pick_from = list()
		for(var/mob/living/carbon/C in view(7, src))
			if(considered_alive(C.mind) && !faction_check(list("goat"), C.faction, FALSE))
				targets_to_pick_from += C
		if (!targets_to_pick_from.len)
			return
		target = pick(targets_to_pick_from)
		visible_message("<span class='notice'>[src] stares at [target].</span>")
	if (world.time > cooldown && target)
		ram()

/obj/item/toy/plush/goatplushie/angry/proc/ram()
	if(prob((obj_flags & EMAGGED) ? 98:90) && isturf(loc) && considered_alive(target.mind) && !faction_check(list("goat"), target.faction, FALSE))
		throw_at(target, 10, 10)
		visible_message("<span class='danger'>[src] rams [target]!</span>")
		cooldown = world.time + cooldown_modifier
	target = null
	visible_message("<span class='notice'>[src] looks disinterested.</span>")

/obj/item/toy/plush/goatplushie/angry/emag_act(mob/user)
	if (obj_flags&EMAGGED)
		visible_message("<span class='notice'>[src] already looks angry enough, you shouldn't anger it more.</span>")
		return
	cooldown_modifier = cooldown_modifier/2 * 0.75
	throwforce = 12.5
	force = 10
	obj_flags |= EMAGGED
	visible_message("<span class='danger'>[src] stares at [user] angrily before going docile.</span>")

/obj/item/toy/plush/goatplushie/angry/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/toy/plush/goatplushie/angry/realgoat
	name = "goat plushie"
	icon = 'modular_sand/icons/obj/plushes.dmi'
	icon_state = "realgoat"

/obj/item/toy/plush/realgoat
	name = "goat plushie"
	icon = 'modular_sand/icons/obj/plushes.dmi'
	desc = "Despite its cuddly appearance and plush nature, it will beat you up all the same... or at least it would if it wasn't a normal plushie."
	icon_state = "realgoat"
	squeak_override = list('modular_sand/sound/items/goatsound.ogg'=1)

/obj/item/toy/plush/goatplushie/angry/kinggoat
	name = "King Goat Plushie"
	desc = "A plushie depicting the king of all goats."
	icon = 'modular_sand/icons/obj/plushes.dmi'
	icon_state = "kinggoat"
	throwforce = 8
	force = 8
	attack_verb = list("chomped")
	gender = MALE

/obj/item/toy/plush/goatplushie/angry/kinggoat/ascendedkinggoat
	name = "Ascended King Goat Plushie"
	desc = "A plushie depicting the god of all goats."
	icon = 'modular_sand/icons/obj/plushes.dmi'
	icon_state = "ascendedkinggoat"
	throwforce = 10
	force = 10
	var/divine = TRUE

/obj/item/toy/plush/goatplushie/angry/kinggoat/ascendedkinggoat/attackby(obj/item/I,mob/living/user,params)
	if(I.get_sharpness())
		user.visible_message("<span class='notice'>[user] attempts to destroy [src]!</span>", "<span class='suicide'>[I] bounces off [src]'s back before breaking into millions of pieces... [src] glares at [user]!</span>") // You fucked up now son
		I.play_tool_sound(src)
		qdel(I)
		user.gib()

/obj/item/toy/plush/goatplushie/angry/kinggoat/attackby(obj/item/I,mob/living/user,params)
	if(I.get_sharpness())
		user.visible_message("<span class='notice'>[user] rips [src] to shreds!</span>", "<span class='notice'>[src]'s death has attracted the attention of the king goat plushie guards!</span>")
		I.play_tool_sound(src)
		qdel(src)
		var/turf/location = get_turf(user)
		new/obj/item/toy/plush/goatplushie/angry/guardgoat/masterguardgoat(location)
		new/obj/item/toy/plush/goatplushie/angry/guardgoat/masterguardgoat(location)
		new/obj/item/toy/plush/goatplushie/angry/guardgoat/masterguardgoat(location)
		new/obj/item/toy/plush/goatplushie/angry/guardgoat/masterguardgoat(location)
		new/obj/item/toy/plush/goatplushie/angry/guardgoat(location)
		new/obj/item/toy/plush/goatplushie/angry/guardgoat(location)
		new/obj/item/toy/plush/goatplushie/angry/guardgoat(location)
		new/obj/item/toy/plush/goatplushie/angry/guardgoat(location)
		new/obj/item/toy/plush/goatplushie/angry/guardgoat(location)
		new/obj/item/toy/plush/goatplushie/angry/guardgoat(location)
		new/obj/item/toy/plush/goatplushie/angry/guardgoat(location)
		new/obj/item/toy/plush/goatplushie/angry/guardgoat(location)
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/cabbage))
		user.visible_message("<span class='notice'>[user] watches as [src] takes a bite out of the cabbage!</span>", "<span class='notice'>[src]'s fur starts glowing. It seems they have ascended!</span>")
		playsound(src, 'sound/items/eatfood.ogg', 50, 1)
		qdel(I)
		qdel(src)
		var/turf/location = get_turf(user)
		new/obj/item/toy/plush/goatplushie/angry/kinggoat/ascendedkinggoat(location)


/obj/item/toy/plush/goatplushie/angry/guardgoat
	name = "guard goat plushie"
	desc = "A plushie depicting one of the King Goat's guards, tasked to protect the king at all costs."
	icon = 'modular_sand/icons/obj/plushes.dmi'
	icon_state = "guardgoat"
	throwforce = 6

/obj/item/toy/plush/goatplushie/angry/guardgoat/masterguardgoat
	name = "royal guard goat plushie"
	desc = "A plushie depicting one of the royal King Goat's guards, tasked to protecting the king at all costs and training new goat guards."
	icon = 'modular_sand/icons/obj/plushes.dmi'
	icon_state = "royalguardgoat"
	throwforce = 7
