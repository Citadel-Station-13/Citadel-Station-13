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
	var/used = FALSE

	if(isobj(target) && istype(target, /obj/item/clothing/under))
		var/obj/item/clothing/under/C = target
		if(C.damaged_clothes)
			to_chat(user,"<span class='warning'>You should repair the damage done to [C] first.</span>")
			return
		if(C.attached_accessory)
			to_chat(user,"<span class='warning'>Kind of hard to sew around [C.attached_accessory].</span>")
			return
		if(C.armor.getRating(MELEE) < 10)
			C.armor = C.armor.setRating(MELEE = 10)
			used = TRUE
		if(C.armor.getRating(LASER) < 10)
			C.armor = C.armor.setRating(LASER = 10)
			used = TRUE
		if(C.armor.getRating(FIRE) < 40)
			C.armor = C.armor.setRating(FIRE = 40)
			used = TRUE
		if(C.armor.getRating(ACID) < 10)
			C.armor = C.armor.setRating(ACID = 10)
			used = TRUE
		if(C.armor.getRating(BOMB) < 5)
			C.armor = C.armor.setRating(BOMB = 5)
			used = TRUE

		if(used)
			user.visible_message("<span class = 'notice'>[user] reinforces [C] with [src].</span>", \
			"<span class = 'notice'>You reinforce [C] with [src], making it as protective as a durathread jumpsuit.</span>")
			C.name = "durathread [C.name]"
			C.upgrade_prefix = "durathread" // god i hope this works
			qdel(src)
			return
		else
			to_chat(user, "<span class = 'notice'>You don't need to reinforce [C] any further.")
			return
	else
		return
