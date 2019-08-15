/*/////////////////////////////////////////////////////////////////////////
/////////////		The TRUE Energy Sword		///////////////////////////
*//////////////////////////////////////////////////////////////////////////

/obj/item/melee/transforming/energy/sword/cx
	name = "non-eutactic blade"
	desc = "The Non-Eutactic Blade utilizes a hardlight blade that is dynamically 'forged' on demand to create a deadly sharp edge that is unbreakable."
	icon_state = "cxsword_hilt"
	icon = 'modular_citadel/icons/eutactic/item/noneutactic.dmi'
	item_state = "cxsword"
	lefthand_file = 'modular_citadel/icons/eutactic/mob/noneutactic_left.dmi'
	righthand_file = 'modular_citadel/icons/eutactic/mob/noneutactic_right.dmi'
	force = 3
	force_on = 21
	throwforce = 5
	throwforce_on = 20
	hitsound = "swing_hit" //it starts deactivated
	hitsound_on = 'sound/weapons/nebhit.ogg'
	attack_verb_off = list("tapped", "poked")
	throw_speed = 3
	throw_range = 5
	sharpness = IS_SHARP
	embedding = list("embedded_pain_multiplier" = 6, "embed_chance" = 20, "embedded_fall_chance" = 60)
	armour_penetration = 10
	block_chance = 35
	light_color = "#37FFF7"
	actions_types = list()

/obj/item/melee/transforming/energy/sword/cx/pre_altattackby(atom/A, mob/living/user, params)	//checks if it can do right click memes
	altafterattack(A, user, TRUE, params)
	return TRUE

/obj/item/melee/transforming/energy/sword/cx/altafterattack(atom/target, mob/living/carbon/user, proximity_flag, click_parameters)	//does right click memes
	if(istype(user))
		user.visible_message("<span class='notice'>[user] points the tip of [src] at [target].</span>", "<span class='notice'>You point the tip of [src] at [target].</span>")
	return TRUE

/obj/item/melee/transforming/energy/sword/cx/transform_weapon(mob/living/user, supress_message_text)
	active = !active				//I'd use a ..() here but it'd inherit from the regular esword's proc instead, so SPAGHETTI CODE
	if(active)						//also I'd need to rip out the iconstate changing bits
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

/obj/item/melee/transforming/energy/sword/cx/transform_messages(mob/living/user, supress_message_text)
	playsound(user, active ? 'sound/weapons/nebon.ogg' : 'sound/weapons/neboff.ogg', 65, 1)
	if(!supress_message_text)
		to_chat(user, "<span class='notice'>[src] [active ? "is now active":"can now be concealed"].</span>")

/obj/item/melee/transforming/energy/sword/cx/update_icon()
	var/mutable_appearance/blade_overlay = mutable_appearance('modular_citadel/icons/eutactic/item/noneutactic.dmi', "cxsword_blade")
	var/mutable_appearance/gem_overlay = mutable_appearance('modular_citadel/icons/eutactic/item/noneutactic.dmi', "cxsword_gem")

	if(light_color)
		blade_overlay.color = light_color
		gem_overlay.color = light_color

	cut_overlays()		//So that it doesn't keep stacking overlays non-stop on top of each other

	add_overlay(gem_overlay)

	if(active)
		add_overlay(blade_overlay)
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()

/obj/item/melee/transforming/energy/sword/cx/AltClick(mob/living/user)
	if(!in_range(src, user))	//Basic checks to prevent abuse
		return
	if(user.incapacitated() || !istype(user))
		to_chat(user, "<span class='warning'>You can't do that right now!</span>")
		return

	if(alert("Are you sure you want to recolor your blade?", "Confirm Repaint", "Yes", "No") == "Yes")
		var/energy_color_input = input(usr,"","Choose Energy Color",light_color) as color|null
		if(energy_color_input)
			light_color = sanitize_hexcolor(energy_color_input, desired_format=6, include_crunch=1)
		update_icon()
		update_light()

/obj/item/melee/transforming/energy/sword/cx/examine(mob/user)
	..()
	to_chat(user, "<span class='notice'>Alt-click to recolor it.</span>")

/obj/item/melee/transforming/energy/sword/cx/worn_overlays(isinhands, icon_file)
	. = ..()
	if(active)
		if(isinhands)
			var/mutable_appearance/blade_inhand = mutable_appearance(icon_file, "cxsword_blade")
			blade_inhand.color = light_color
			. += blade_inhand
//Broken version. Not a toy, but not as strong.
/obj/item/melee/transforming/energy/sword/cx/broken
	name = "misaligned non-eutactic blade"
	desc = "The Non-Eutactic Blade utilizes a hardlight blade that is dynamically 'forged' on demand to create a deadly sharp edge that is unbreakable. This one seems to have a damaged handle and misaligned components, causing the blade to be unstable at best"
	force_on = 15 //As strong a survival knife/bone dagger

/obj/item/melee/transforming/energy/sword/cx/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/melee/transforming/energy/sword/cx))
		if(HAS_TRAIT(W, TRAIT_NODROP) || HAS_TRAIT(src, TRAIT_NODROP))
			to_chat(user, "<span class='warning'>\the [HAS_TRAIT(src, TRAIT_NODROP) ? src : W] is stuck to your hand, you can't attach it to \the [HAS_TRAIT(src, TRAIT_NODROP) ? W : src]!</span>")
			return
		else
			to_chat(user, "<span class='notice'>You combine the two light swords, making a single supermassive blade! You're cool.</span>")
			new /obj/item/twohanded/dualsaber/hypereutactic(user.drop_location())
			qdel(W)
			qdel(src)
	else
		return ..()

/obj/item/melee/transforming/energy/sword/cx/chaplain
	name = "divine lightblade"
	force_on = 20		//haha i'll regret this
	block_chance = 50

/obj/item/melee/transforming/energy/sword/cx/chaplain/Initialize()
	. = ..()
	AddComponent(/datum/component/anti_magic, TRUE, TRUE)

//OBLIGATORY TOY MEMES	/////////////////////////////////////

/obj/item/toy/sword/cx
	name = "\improper DX Non-Euplastic LightSword"
	desc = "A deluxe toy replica of an energy sword. Realistic visuals and sounds! Ages 8 and up."
	icon = 'modular_citadel/icons/eutactic/item/noneutactic.dmi'
	icon_state = "cxsword_hilt"
	item_state = "cxsword"
	lefthand_file = 'modular_citadel/icons/eutactic/mob/noneutactic_left.dmi'
	righthand_file = 'modular_citadel/icons/eutactic/mob/noneutactic_right.dmi'
	active = FALSE
	w_class = WEIGHT_CLASS_SMALL
	attack_verb = list("poked", "jabbed", "hit")
	light_color = "#37FFF7"
	var/light_brightness = 3
	actions_types = list()

/obj/item/toy/sword/cx/pre_altattackby(atom/A, mob/living/user, params)	//checks if it can do right click memes
	altafterattack(A, user, TRUE, params)
	return TRUE

/obj/item/toy/sword/cx/altafterattack(atom/target, mob/living/carbon/user, proximity_flag, click_parameters)	//does right click memes
	if(istype(user))
		user.visible_message("<span class='notice'>[user] points the tip of [src] at [target].</span>", "<span class='notice'>You point the tip of [src] at [target].</span>")
	return TRUE

/obj/item/toy/sword/cx/attack_self(mob/user)
	active = !( active )

	if (active)
		to_chat(user, "<span class='notice'>You activate the holographic blade with a press of a button.</span>")
		playsound(user, 'sound/weapons/nebon.ogg', 50, 1)
		w_class = WEIGHT_CLASS_BULKY
		attack_verb = list("slashed", "stabbed", "ravaged")
		set_light(light_brightness)
		update_icon()

	else
		to_chat(user, "<span class='notice'>You deactivate the holographic blade with a press of a button.</span>")
		playsound(user, 'sound/weapons/neboff.ogg', 50, 1)
		w_class = WEIGHT_CLASS_SMALL
		attack_verb = list("poked", "jabbed", "hit")
		set_light(0)
		update_icon()

	add_fingerprint(user)

/obj/item/toy/sword/cx/update_icon()
	var/mutable_appearance/blade_overlay = mutable_appearance('modular_citadel/icons/eutactic/item/noneutactic.dmi', "cxsword_blade")
	var/mutable_appearance/gem_overlay = mutable_appearance('modular_citadel/icons/eutactic/item/noneutactic.dmi', "cxsword_gem")

	if(light_color)
		blade_overlay.color = light_color
		gem_overlay.color = light_color

	cut_overlays()		//So that it doesn't keep stacking overlays non-stop on top of each other

	add_overlay(gem_overlay)

	if(active)
		add_overlay(blade_overlay)
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()

/obj/item/toy/sword/cx/AltClick(mob/living/user)
	if(!in_range(src, user))	//Basic checks to prevent abuse
		return
	if(user.incapacitated() || !istype(user))
		to_chat(user, "<span class='warning'>You can't do that right now!</span>")
		return

	if(alert("Are you sure you want to recolor your blade?", "Confirm Repaint", "Yes", "No") == "Yes")
		var/energy_color_input = input(usr,"","Choose Energy Color",light_color) as color|null
		if(energy_color_input)
			light_color = sanitize_hexcolor(energy_color_input, desired_format=6, include_crunch=1)
		update_icon()
		update_light()

/obj/item/toy/sword/cx/worn_overlays(isinhands, icon_file)
	. = ..()
	if(active)
		if(isinhands)
			var/mutable_appearance/blade_inhand = mutable_appearance(icon_file, "cxsword_blade")
			blade_inhand.color = light_color
			. += blade_inhand

/obj/item/toy/sword/cx/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/toy/sword/cx))
		if(HAS_TRAIT(W, TRAIT_NODROP) || HAS_TRAIT(src, TRAIT_NODROP))
			to_chat(user, "<span class='warning'>\the [HAS_TRAIT(src, TRAIT_NODROP) ? src : W] is stuck to your hand, you can't attach it to \the [HAS_TRAIT(src, TRAIT_NODROP) ? W : src]!</span>")
			return
		else
			to_chat(user, "<span class='notice'>You combine the two plastic swords, making a single supermassive toy! You're fake-cool.</span>")
			new /obj/item/twohanded/dualsaber/hypereutactic/toy(user.loc)
			qdel(W)
			qdel(src)
	else
		return ..()

/obj/item/toy/sword/cx/examine(mob/user)
	..()
	to_chat(user, "<span class='notice'>Alt-click to recolor it.</span>")

/////////////////////////////////////////////////////
//	HYPEREUTACTIC Blades	/////////////////////////
/////////////////////////////////////////////////////

/obj/item/twohanded/dualsaber/hypereutactic
	icon = 'modular_citadel/icons/eutactic/item/hypereutactic.dmi'
	icon_state = "hypereutactic"
	lefthand_file = 'modular_citadel/icons/eutactic/mob/hypereutactic_left.dmi'
	righthand_file = 'modular_citadel/icons/eutactic/mob/hypereutactic_right.dmi'
	item_state = "hypereutactic"
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	name = "hypereutactic blade"
	desc = "A supermassive weapon envisioned to cleave the very fabric of space and time itself in twain, the hypereutactic blade dynamically flash-forges a hypereutactic crystaline nanostructure capable of passing through most known forms of matter like a hot knife through butter."
	force = 7
	force_unwielded = 7
	force_wielded = 40
	wieldsound = 'sound/weapons/nebon.ogg'
	unwieldsound = 'sound/weapons/neboff.ogg'
	hitsound_on = 'sound/weapons/nebhit.ogg'
	slowdown_wielded = 1
	armour_penetration = 60
	light_color = "#37FFF7"
	rainbow_colors = list("#FF0000", "#FFFF00", "#00FF00", "#00FFFF", "#0000FF","#FF00FF", "#3399ff", "#ff9900", "#fb008b", "#9800ff", "#00ffa3", "#ccff00")
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "destroyed", "ripped", "devastated", "shredded")
	spinnable = FALSE
	total_mass_on = 4

/obj/item/twohanded/dualsaber/hypereutactic/pre_altattackby(atom/A, mob/living/user, params)	//checks if it can do right click memes
	altafterattack(A, user, TRUE, params)
	return TRUE

/obj/item/twohanded/dualsaber/hypereutactic/altafterattack(atom/target, mob/living/user, proximity_flag, click_parameters)	//does right click memes
	if(istype(user))
		user.visible_message("<span class='notice'>[user] points the tip of [src] at [target].</span>", "<span class='notice'>You point the tip of [src] at [target].</span>")
	return TRUE

/obj/item/twohanded/dualsaber/hypereutactic/update_icon()
	var/mutable_appearance/blade_overlay = mutable_appearance('modular_citadel/icons/eutactic/item/hypereutactic.dmi', "hypereutactic_blade")
	var/mutable_appearance/gem_overlay = mutable_appearance('modular_citadel/icons/eutactic/item/hypereutactic.dmi', "hypereutactic_gem")

	if(light_color)
		blade_overlay.color = light_color
		gem_overlay.color = light_color

	cut_overlays()		//So that it doesn't keep stacking overlays non-stop on top of each other

	add_overlay(gem_overlay)

	if(wielded)
		add_overlay(blade_overlay)
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()

	SEND_SIGNAL(src, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_STRENGTH_BLOOD)//blood overlays get weird otherwise, because the sprite changes. (retained from original desword because I have no idea what this is)

/obj/item/twohanded/dualsaber/hypereutactic/AltClick(mob/living/user)
	if(!user.canUseTopic(src, BE_CLOSE, FALSE) || hacked)
		return
	if(user.incapacitated() || !istype(user))
		to_chat(user, "<span class='warning'>You can't do that right now!</span>")
		return
	if(alert("Are you sure you want to recolor your blade?", "Confirm Repaint", "Yes", "No") == "Yes")
		var/energy_color_input = input(usr,"","Choose Energy Color",light_color) as color|null
		if(!energy_color_input || !user.canUseTopic(src, BE_CLOSE, FALSE) || hacked)
			return
		light_color = sanitize_hexcolor(energy_color_input, desired_format=6, include_crunch=1)
		update_icon()
		update_light()

/obj/item/twohanded/dualsaber/hypereutactic/worn_overlays(isinhands, icon_file)
	. = ..()
	if(isinhands)
		var/mutable_appearance/gem_inhand = mutable_appearance(icon_file, "hypereutactic_gem")
		gem_inhand.color = light_color
		. += gem_inhand
		if(wielded)
			var/mutable_appearance/blade_inhand = mutable_appearance(icon_file, "hypereutactic_blade")
			blade_inhand.color = light_color
			. += blade_inhand

/obj/item/twohanded/dualsaber/hypereutactic/examine(mob/user)
	..()
	if(!hacked)
		to_chat(user, "<span class='notice'>Alt-click to recolor it.</span>")

/obj/item/twohanded/dualsaber/hypereutactic/rainbow_process()
	. = ..()
	update_icon()
	update_light()

//////////////////	TOY VERSION	/////////////////////////////

/obj/item/twohanded/dualsaber/hypereutactic/toy
	name = "\improper DX Hyper-Euplastic LightSword"
	desc = "A supermassive toy envisioned to cleave the very fabric of space and time itself in twain. Realistic visuals and sounds! Ages 8 and up."
	force = 0
	throwforce = 0
	throw_speed = 3
	throw_range = 5
	force_unwielded = 0
	force_wielded = 0
	attack_verb = list("attacked", "struck", "hit")
	total_mass_on = TOTAL_MASS_TOY_SWORD
	slowdown_wielded = 0

/obj/item/twohanded/dualsaber/hypereutactic/toy/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	return FALSE

/obj/item/twohanded/dualsaber/hypereutactic/toy/IsReflect()//Stops it from reflecting energy projectiles
	return FALSE

////////		Tatortot NEB		/////////////// (same stats as regular esword)
/obj/item/melee/transforming/energy/sword/cx/traitor
	name = "\improper Dragon's Tooth Sword"
	desc = "The Dragon's Tooth sword is a blackmarket modification of a Non-Eutactic Blade, \
			which utilizes a hardlight blade that is dynamically 'forged' on demand to create a deadly sharp edge that is unbreakable. \
			It appears to have a wooden grip and a shaved down guard."
	icon_state = "cxsword_hilt_traitor"
	force_on = 30
	armour_penetration = 50
	embedding = list("embedded_pain_multiplier" = 10, "embed_chance" = 75, "embedded_fall_chance" = 0, "embedded_impact_pain_multiplier" = 10)
	block_chance = 50
	hitsound_on = 'sound/weapons/blade1.ogg'
	light_color = "#37F0FF"

/obj/item/melee/transforming/energy/sword/cx/traitor/transform_messages(mob/living/user, supress_message_text)
	playsound(user, active ? 'sound/weapons/saberon.ogg' : 'sound/weapons/saberoff.ogg', 35, 1)
	if(!supress_message_text)
		to_chat(user, "<span class='notice'>[src] [active ? "is now active":"can now be concealed"].</span>")

//RAINBOW MEMES

/obj/item/twohanded/dualsaber/hypereutactic/toy/rainbow
	name = "\improper Hyper-Euclidean Reciprocating Trigonometric Zweihander"
	desc = "A custom-built toy with fancy rainbow lights built-in."
	hacked = TRUE