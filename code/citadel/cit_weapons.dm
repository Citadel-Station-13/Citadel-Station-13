/obj/item/toy/sword/cx
	name = "\improper DX Non-Euplastic LightSword"
	desc = "A deluxe toy replica of an energy sword. Realistic visuals and sounds! Ages 8 and up."
	icon = 'icons/obj/cit_weapons.dmi'
	icon_state = "cxsword_hilt"
	item_state = "cxsword"
	lefthand_file = 'icons/mob/citadel/melee_lefthand.dmi'
	righthand_file = 'icons/mob/citadel/melee_righthand.dmi'
	active = FALSE
	w_class = WEIGHT_CLASS_SMALL
	attack_verb = list("poked", "jabbed", "hit")
	light_color = "#37FFF7"
	var/light_brightness = 3
	actions_types = list(/datum/action/item_action/pick_color)

/obj/item/toy/sword/cx/attack_self(mob/user)
	active = !( active )

	if (active)
		to_chat(user, "<span class='notice'>You activate the holographic blade with a press of a button.</span>")
		playsound(user, 'sound/weapons/saberon.ogg', 20, 1)
		w_class = WEIGHT_CLASS_BULKY
		attack_verb = list("slashed", "stabbed", "ravaged")
		set_light(light_brightness)
		update_icon()

	else
		to_chat(user, "<span class='notice'>You deactivate the holographic blade with a press of a button.</span>")
		playsound(user, 'sound/weapons/saberoff.ogg', 20, 1)
		w_class = WEIGHT_CLASS_SMALL
		attack_verb = list("poked", "jabbed", "hit")
		set_light(0)
		update_icon()

	add_fingerprint(user)

/obj/item/toy/sword/cx/update_icon()
	var/mutable_appearance/blade_overlay = mutable_appearance('icons/obj/cit_weapons.dmi', "cxsword_blade")
	var/mutable_appearance/gem_overlay = mutable_appearance('icons/obj/cit_weapons.dmi', "cxsword_gem")

	if(light_color)
		blade_overlay.color = light_color
		gem_overlay.color = light_color

	cut_overlays()		//So that it doesn't keep stacking overlays non-stop on top of each other

	add_overlay(gem_overlay)

	if(active)
		add_overlay(blade_overlay)

/obj/item/toy/sword/cx/ui_action_click(mob/user, var/datum/action/A)
	if(istype(A, /datum/action/item_action/pick_color))
		if(alert("Are you sure you want to recolor your blade?", "Confirm Repaint", "Yes", "No") == "Yes")
			var/energy_color_input = input(usr,"Choose Energy Color") as color|null
			if(energy_color_input)
				light_color = sanitize_hexcolor(energy_color_input, desired_format=6, include_crunch=1)
			update_icon()
			if(ismob(loc))
				var/mob/M = loc
				M.update_inv_hands()
			update_light()

	else
		..()

/obj/item/toy/sword/cx/worn_overlays(isinhands, icon_file)
	. = ..()
	if(active)
		if(isinhands)
			var/mutable_appearance/blade_inhand = mutable_appearance(icon_file, "cxsword_blade")
			blade_inhand.color = light_color
			. += blade_inhand

///autolathe memes/// I really need to stop doing this and find a proper way of adding in my toys

/datum/design/toyneb
	name = "Non-Euplastic Blade"
	id = "toyneb"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 10000, MAT_GLASS = 1000)
	build_path = /obj/item/toy/sword/cx
	category = list("hacked", "Misc")

/*/////////////////////////////////////////////////////////////////////////
/////////////		The TRUE Energy Sword		///////////////////////////
*//////////////////////////////////////////////////////////////////////////

/obj/item/melee/transforming/energy/sword/cx
	name = "non-eutactic blade"
	desc = "The CX Armories Type-69 Non-Eutactic Blade utilizes a hardlight blade that is dynamically 'forged' on demand to create a deadly sharp edge that is unbreakable."
	icon_state = "cxsword_hilt"
	icon = 'icons/obj/cit_weapons.dmi'
	item_state = "cxsword"
	lefthand_file = 'icons/mob/citadel/melee_lefthand.dmi'
	righthand_file = 'icons/mob/citadel/melee_righthand.dmi'
	force = 3
	throwforce = 5
	hitsound = "swing_hit" //it starts deactivated
	attack_verb_off = list("tapped", "poked")
	throw_speed = 3
	throw_range = 5
	sharpness = IS_SHARP
	embed_chance = 75
	embedded_impact_pain_multiplier = 10
	armour_penetration = 35
	origin_tech = "combat=3;magnets=4;syndicate=4"
	block_chance = 50
	light_color = "#37FFF7"
	actions_types = list(/datum/action/item_action/pick_color)

/obj/item/melee/transforming/energy/sword/cx/transform_weapon(mob/living/user, supress_message_text)
	active = !active				//I'd use a ..() here but it'd inherit from the regular esword's proc instead, so SPAGHETTI CODE
	if(active)						//also I need to rip out the iconstate changing bits
		force = force_on
		throwforce = throwforce_on
		hitsound = hitsound_on
		throw_speed = 4
		if(attack_verb_on.len)
			attack_verb = attack_verb_on
		w_class = w_class_on
		START_PROCESSING(SSobj, src)
		set_light(brightness_on)
		update_icon()
	else
		force = initial(force)
		throwforce = initial(throwforce)
		hitsound = initial(hitsound)
		throw_speed = initial(throw_speed)
		if(attack_verb_off.len)
			attack_verb = attack_verb_off
		w_class = initial(w_class)
		STOP_PROCESSING(SSobj, src)
		set_light(0)
		update_icon()
	transform_messages(user, supress_message_text)
	add_fingerprint(user)
	return TRUE

/obj/item/melee/transforming/energy/sword/cx/update_icon()
	var/mutable_appearance/blade_overlay = mutable_appearance('icons/obj/cit_weapons.dmi', "cxsword_blade")
	var/mutable_appearance/gem_overlay = mutable_appearance('icons/obj/cit_weapons.dmi', "cxsword_gem")

	if(light_color)
		blade_overlay.color = light_color
		gem_overlay.color = light_color

	cut_overlays()		//So that it doesn't keep stacking overlays non-stop on top of each other

	add_overlay(gem_overlay)

	if(active)
		add_overlay(blade_overlay)

/obj/item/melee/transforming/energy/sword/cx/ui_action_click(mob/user, var/datum/action/A)
	if(istype(A, /datum/action/item_action/pick_color))
		if(alert("Are you sure you want to recolor your blade?", "Confirm Repaint", "Yes", "No") == "Yes")
			var/energy_color_input = input(usr,"Choose Energy Color") as color|null
			if(energy_color_input)
				light_color = sanitize_hexcolor(energy_color_input, desired_format=6, include_crunch=1)
			update_icon()
			if(ismob(loc))
				var/mob/M = loc
				M.update_inv_hands()
			update_light()

	else
		..()

/obj/item/melee/transforming/energy/sword/cx/worn_overlays(isinhands, icon_file)
	. = ..()
	if(active)
		if(isinhands)
			var/mutable_appearance/blade_inhand = mutable_appearance(icon_file, "cxsword_blade")
			blade_inhand.color = light_color
			. += blade_inhand