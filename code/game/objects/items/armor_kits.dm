// Armor kits! Reinforcing uniforms to maintain fashion and also armor capabilities.

/obj/item/armorkit
	name = "durathread armor kit"
	desc = "A glorified sewing kit with durathread sheets, thread, and a titanium needle, for reinforcing jumpsuits and uniforms."
	icon = 'icons/obj/clothing/reinf_kits.dmi'
	w_class = WEIGHT_CLASS_SMALL
	icon_state = "durathread_kit" // shoutout to my guy Toriate for being good at sprites tho

/obj/item/armorkit/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	// yeah have fun making subtypes and modifying the afterattack if you want to make variants
	// idiot
	// - hatter
	var/used = FALSE

	if(isobj(target) && istype(target, /obj/item/clothing/under))
		var/obj/item/clothing/under/C = target
		if(C.armor.melee < 10)
			C.armor.melee = 10
			used = TRUE
		if(C.armor.laser < 10)
			C.armor.laser = 10
			used = TRUE
		if(C.armor.fire < 40)
			C.armor.fire = 40
			used = TRUE
		if(C.armor.acid < 10)
			C.armor.acid = 10
			used = TRUE
		if(C.armor.bomb < 5)
			C.armor.bomb = 5
			used = TRUE

		if(used)
			user.visible_message("<span class = 'notice'>[user] uses [src] on [C], reinforcing it and tossing the empty case away afterwards.</span>", \
			"<span class = 'notice'>You reinforce [C] with [src], making it a little more protective! You toss the empty casing away afterwards.</span>")
			C.name = "durathread [C.name]" // this disappears if it gets repaired, which is annoying
			qdel(src)
			return
		else
			to_chat(user, "<span class = 'notice'>You stare at [src] and [C], coming to the conclusion that you probably don't need to reinforce it any further.")
			return
	else
		return
