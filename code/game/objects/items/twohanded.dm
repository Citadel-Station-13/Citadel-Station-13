/* Two-handed Weapons
 * Contains:
 * 		Twohanded
 *		Fireaxe
 *		Double-Bladed Energy Swords
 *		Spears
 *		CHAINSAWS
 *		Bone Axe and Spear
 *		And more
 */

/*##################################################################
##################### TWO HANDED WEAPONS BE HERE~ -Agouri :3 ########
####################################################################*/

//Rewrote TwoHanded weapons stuff and put it all here. Just copypasta fireaxe to make new ones ~Carn
//This rewrite means we don't have two variables for EVERY item which are used only by a few weapons.
//It also tidies stuff up elsewhere.




/*
 * Twohanded
 */
/obj/item/twohanded
	var/wielded = FALSE
	var/force_unwielded // default to null, the number force will be set to on unwield()
	var/force_wielded // same as above but for wield()
	var/wieldsound = null
	var/unwieldsound = null
	var/slowdown_wielded = 0
	item_flags = SLOWS_WHILE_IN_HAND

/obj/item/twohanded/proc/unwield(mob/living/carbon/user, show_message = TRUE)
	if(!wielded || !user)
		return
	wielded = 0
	if(!isnull(force_unwielded))
		force = force_unwielded
	var/sf = findtext(name, " (Wielded)", -10)//10 == length(" (Wielded)")
	if(sf)
		name = copytext(name, 1, sf)
	else //something wrong
		name = "[initial(name)]"
	update_icon()
	if(user.get_item_by_slot(SLOT_BACK) == src)
		user.update_inv_back()
	else
		user.update_inv_hands()
	if(show_message)
		if(iscyborg(user))
			to_chat(user, "<span class='notice'>You free up your module.</span>")
		else
			to_chat(user, "<span class='notice'>You are now carrying [src] with one hand.</span>")
	if(unwieldsound)
		playsound(loc, unwieldsound, 50, 1)
	var/obj/item/twohanded/offhand/O = user.get_inactive_held_item()
	if(O && istype(O))
		O.unwield()
	set_slowdown(slowdown - slowdown_wielded)

/obj/item/twohanded/proc/wield(mob/living/carbon/user)
	if(wielded)
		return
	if(ismonkey(user))
		to_chat(user, "<span class='warning'>It's too heavy for you to wield fully.</span>")
		return
	if(user.get_inactive_held_item())
		to_chat(user, "<span class='warning'>You need your other hand to be empty!</span>")
		return
	if(user.get_num_arms() < 2)
		to_chat(user, "<span class='warning'>You don't have enough intact hands.</span>")
		return
	wielded = 1
	if(!isnull(force_wielded))
		force = force_wielded
	name = "[name] (Wielded)"
	update_icon()
	if(iscyborg(user))
		to_chat(user, "<span class='notice'>You dedicate your module to [src].</span>")
	else
		to_chat(user, "<span class='notice'>You grab [src] with both hands.</span>")
	if (wieldsound)
		playsound(loc, wieldsound, 50, 1)
	var/obj/item/twohanded/offhand/O = new(user) ////Let's reserve his other hand~
	O.name = "[name] - offhand"
	O.desc = "Your second grip on [src]."
	O.wielded = TRUE
	user.put_in_inactive_hand(O)
	set_slowdown(slowdown + slowdown_wielded)

/obj/item/twohanded/dropped(mob/user)
	. = ..()
	//handles unwielding a twohanded weapon when dropped as well as clearing up the offhand
	if(!wielded)
		return
	unwield(user)

/obj/item/twohanded/attack_self(mob/user)
	. = ..()
	if(wielded) //Trying to unwield it
		unwield(user)
	else //Trying to wield it
		wield(user)

/obj/item/twohanded/equip_to_best_slot(mob/M)
	if(..())
		if(istype(src, /obj/item/twohanded/required))
			return // unwield forces twohanded-required items to be dropped.
		unwield(M)
		return

/obj/item/twohanded/equipped(mob/user, slot)
	..()
	if(!user.is_holding(src) && wielded && !istype(src, /obj/item/twohanded/required))
		unwield(user)

///////////OFFHAND///////////////
/obj/item/twohanded/offhand
	name = "offhand"
	icon_state = "offhand"
	w_class = WEIGHT_CLASS_HUGE
	item_flags = ABSTRACT
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/item/twohanded/offhand/Destroy()
	wielded = FALSE
	return ..()

/obj/item/twohanded/offhand/dropped(mob/living/user, show_message = TRUE) //Only utilized by dismemberment since you can't normally switch to the offhand to drop it.
	var/obj/I = user.get_active_held_item()
	if(I && istype(I, /obj/item/twohanded))
		var/obj/item/twohanded/thw = I
		thw.unwield(user, show_message)
		if(istype(thw, /obj/item/twohanded/required))
			user.dropItemToGround(thw)
	if(!QDELETED(src))
		qdel(src)

/obj/item/twohanded/offhand/unwield()
	if(wielded)//Only delete if we're wielded
		wielded = FALSE
		qdel(src)

/obj/item/twohanded/offhand/wield()
	if(wielded)//Only delete if we're wielded
		wielded = FALSE
		qdel(src)

/obj/item/twohanded/offhand/attack_self(mob/living/carbon/user)		//You should never be able to do this in standard use of two handed items. This is a backup for lingering offhands.
	var/obj/item/twohanded/O = user.get_inactive_held_item()
	if (istype(O) && !istype(O, /obj/item/twohanded/offhand/))		//If you have a proper item in your other hand that the offhand is for, do nothing. This should never happen.
		return
	if (QDELETED(src))
		return
	qdel(src)																//If it's another offhand, or literally anything else, qdel. If I knew how to add logging messages I'd put one here.

///////////Two hand required objects///////////////
//This is for objects that require two hands to even pick up
/obj/item/twohanded/required
	w_class = WEIGHT_CLASS_HUGE

/obj/item/twohanded/required/attack_self()
	return

/obj/item/twohanded/required/mob_can_equip(mob/M, mob/equipper, slot, disable_warning = 0)
	if(wielded && !slot_flags)
		if(!disable_warning)
			to_chat(M, "<span class='warning'>[src] is too cumbersome to carry with anything but your hands!</span>")
		return 0
	return ..()

/obj/item/twohanded/required/attack_hand(mob/user)//Can't even pick it up without both hands empty
	var/obj/item/twohanded/required/H = user.get_inactive_held_item()
	if(get_dist(src,user) > 1)
		return
	if(H != null)
		to_chat(user, "<span class='notice'>[src] is too cumbersome to carry in one hand!</span>")
		return
	if(loc != user)
		wield(user)
	. = ..()

/obj/item/twohanded/required/equipped(mob/user, slot)
	..()
	var/slotbit = slotdefine2slotbit(slot)
	if(slot_flags & slotbit)
		var/datum/O = user.is_holding_item_of_type(/obj/item/twohanded/offhand)
		if(!O || QDELETED(O))
			return
		qdel(O)
		return
	if(slot == SLOT_HANDS)
		wield(user)
	else
		unwield(user)

/obj/item/twohanded/required/dropped(mob/living/user, show_message = TRUE)
	unwield(user, show_message)
	..()

/obj/item/twohanded/required/wield(mob/living/carbon/user)
	..()
	if(!wielded)
		user.dropItemToGround(src)

/obj/item/twohanded/required/unwield(mob/living/carbon/user, show_message = TRUE)
	if(!wielded)
		return
	if(show_message)
		to_chat(user, "<span class='notice'>You drop [src].</span>")
	..(user, FALSE)

/*
 * Fireaxe
 */
/obj/item/twohanded/fireaxe  // DEM AXES MAN, marker -Agouri
	icon_state = "fireaxe0"
	lefthand_file = 'icons/mob/inhands/weapons/axes_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/axes_righthand.dmi'
	name = "fire axe"
	desc = "Truly, the weapon of a madman. Who would think to fight fire with an axe?"
	force = 5
	throwforce = 15
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	force_unwielded = 5
	force_wielded = 24
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = IS_SHARP
	max_integrity = 200
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 30)
	resistance_flags = FIRE_PROOF

/obj/item/twohanded/fireaxe/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 100, 80, 0 , hitsound) //axes are not known for being precision butchering tools

/obj/item/twohanded/fireaxe/update_icon_state()  //Currently only here to fuck with the on-mob icons.
	icon_state = "fireaxe[wielded]"
	return

/obj/item/twohanded/fireaxe/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] axes [user.p_them()]self from head to toe! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return (BRUTELOSS)

/obj/item/twohanded/fireaxe/afterattack(atom/A, mob/living/user, proximity)
	. = ..()
	if(!proximity || IS_STAMCRIT(user))		//don't make stamcrit message they'll already have gotten one from the primary attack.
		return
	if(wielded) //destroys windows and grilles in one hit (or more if it has a ton of health like plasmaglass)
		if(istype(A, /obj/structure/window))
			var/obj/structure/window/W = A
			W.take_damage(200, BRUTE, "melee", 0)
		else if(istype(A, /obj/structure/grille))
			var/obj/structure/grille/G = A
			G.take_damage(40, BRUTE, "melee", 0)


/*
 * Double-Bladed Energy Swords - Cheridan
 */
/obj/item/twohanded/dualsaber
	icon_state = "dualsaber0"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	name = "double-bladed energy sword"
	desc = "Handle with care."
	force = 3
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	var/w_class_on = WEIGHT_CLASS_BULKY
	force_unwielded = 3
	force_wielded = 34
	wieldsound = 'sound/weapons/saberon.ogg'
	unwieldsound = 'sound/weapons/saberoff.ogg'
	hitsound = "swing_hit"
	var/hitsound_on = 'sound/weapons/blade1.ogg'
	armour_penetration = 35
	item_color = "green"
	light_color = "#00ff00"//green
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	block_chance = 75
	max_integrity = 200
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 70)
	resistance_flags = FIRE_PROOF
	var/hacked = FALSE
	/// Can this reflect all energy projectiles?
	var/can_reflect = TRUE
	var/brightness_on = 6 //TWICE AS BRIGHT AS A REGULAR ESWORD
	var/list/possible_colors = list("red", "blue", "green", "purple")
	var/list/rainbow_colors = list(LIGHT_COLOR_RED, LIGHT_COLOR_GREEN, LIGHT_COLOR_LIGHT_CYAN, LIGHT_COLOR_LAVENDER)
	var/spinnable = TRUE
	total_mass = 0.4 //Survival flashlights typically weigh around 5 ounces.
	var/total_mass_on = 3.4

/obj/item/twohanded/dualsaber/suicide_act(mob/living/carbon/user)
	if(wielded)
		user.visible_message("<span class='suicide'>[user] begins spinning way too fast! It looks like [user.p_theyre()] trying to commit suicide!</span>")

		var/obj/item/bodypart/head/myhead = user.get_bodypart(BODY_ZONE_HEAD)//stole from chainsaw code
		var/obj/item/organ/brain/B = user.getorganslot(ORGAN_SLOT_BRAIN)
		B.organ_flags &= ~ORGAN_VITAL	//this cant possibly be a good idea
		var/randdir
		for(var/i in 1 to 24)//like a headless chicken!
			if(user.is_holding(src))
				randdir = pick(GLOB.alldirs)
				user.Move(get_step(user, randdir),randdir)
				user.emote("spin")
				if (i == 3 && myhead)
					myhead.drop_limb()
				sleep(3)
			else
				user.visible_message("<span class='suicide'>[user] panics and starts choking to death!</span>")
				return OXYLOSS


	else
		user.visible_message("<span class='suicide'>[user] begins beating [user.p_them()]self to death with \the [src]'s handle! It probably would've been cooler if [user.p_they()] turned it on first!</span>")
	return BRUTELOSS

/obj/item/twohanded/dualsaber/Initialize()
	. = ..()
	if(LAZYLEN(possible_colors))
		item_color = pick(possible_colors)
		switch(item_color)
			if("red")
				light_color = LIGHT_COLOR_RED
			if("green")
				light_color = LIGHT_COLOR_GREEN
			if("blue")
				light_color = LIGHT_COLOR_LIGHT_CYAN
			if("purple")
				light_color = LIGHT_COLOR_LAVENDER

/obj/item/twohanded/dualsaber/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/twohanded/dualsaber/update_icon_state()
	if(wielded)
		icon_state = "dualsaber[item_color][wielded]"
	else
		icon_state = "dualsaber0"
	clean_blood()

/obj/item/twohanded/dualsaber/attack(mob/target, mob/living/carbon/human/user)
	if(user.has_dna())
		if(user.dna.check_mutation(HULK))
			to_chat(user, "<span class='warning'>You grip the blade too hard and accidentally close it!</span>")
			unwield()
			return
	..()
	if(HAS_TRAIT(user, TRAIT_CLUMSY) && (wielded) && prob(40))
		impale(user)
		return
	if(spinnable && (wielded) && prob(50))
		INVOKE_ASYNC(src, .proc/jedi_spin, user)

/obj/item/twohanded/dualsaber/proc/jedi_spin(mob/living/user)
	for(var/i in list(NORTH,SOUTH,EAST,WEST,EAST,SOUTH,NORTH,SOUTH,EAST,WEST,EAST,SOUTH))
		user.setDir(i)
		if(i == WEST)
			user.emote("flip")
		sleep(1)

/obj/item/twohanded/dualsaber/proc/impale(mob/living/user)
	to_chat(user, "<span class='warning'>You twirl around a bit before losing your balance and impaling yourself on [src].</span>")
	if (force_wielded)
		user.take_bodypart_damage(20,25)
	else
		user.adjustStaminaLoss(25)

/obj/item/twohanded/dualsaber/run_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(!wielded)
		return NONE
	if(can_reflect && is_energy_reflectable_projectile(object) && (attack_type & ATTACK_TYPE_PROJECTILE))
		block_return[BLOCK_RETURN_REDIRECT_METHOD] = REDIRECT_METHOD_RETURN_TO_SENDER			//no you
		return BLOCK_SHOULD_REDIRECT | BLOCK_SUCCESS | BLOCK_REDIRECTED
	return ..()

/obj/item/twohanded/dualsaber/attack_hulk(mob/living/carbon/human/user, does_attack_animation = 0)  //In case thats just so happens that it is still activated on the groud, prevents hulk from picking it up
	if(wielded)
		to_chat(user, "<span class='warning'>You can't pick up such dangerous item with your meaty hands without losing fingers, better not to!</span>")
		return 1

/obj/item/twohanded/dualsaber/wield(mob/living/carbon/M) //Specific wield () hulk checks due to reflection chance for balance issues and switches hitsounds.
	if(M.has_dna())
		if(M.dna.check_mutation(HULK))
			to_chat(M, "<span class='warning'>You lack the grace to wield this!</span>")
			return
	..()
	if(wielded)
		sharpness = IS_SHARP
		w_class = w_class_on
		total_mass = total_mass_on
		hitsound = 'sound/weapons/blade1.ogg'
		START_PROCESSING(SSobj, src)
		set_light(brightness_on)
		AddElement(/datum/element/sword_point)

/obj/item/twohanded/dualsaber/unwield() //Specific unwield () to switch hitsounds.
	sharpness = initial(sharpness)
	w_class = initial(w_class)
	total_mass = initial(total_mass)
	..()
	hitsound = "swing_hit"
	STOP_PROCESSING(SSobj, src)
	set_light(0)
	RemoveElement(/datum/element/sword_point)

/obj/item/twohanded/dualsaber/process()
	if(wielded)
		if(hacked)
			rainbow_process()
		open_flame()
	else
		STOP_PROCESSING(SSobj, src)

/obj/item/twohanded/dualsaber/proc/rainbow_process()
	light_color = pick(rainbow_colors)

/obj/item/twohanded/dualsaber/ignition_effect(atom/A, mob/user)
	// same as /obj/item/melee/transforming/energy, mostly
	if(!wielded)
		return ""
	var/in_mouth = ""
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.wear_mask)
			in_mouth = ", barely missing [user.p_their()] nose"
	. = "<span class='warning'>[user] swings [user.p_their()] [name][in_mouth]. [user.p_they(TRUE)] light[user.p_s()] [user.p_their()] [A.name] in the process.</span>"
	playsound(loc, hitsound, get_clamped_volume(), 1, -1)
	add_fingerprint(user)
	// Light your candles while spinning around the room
	if(spinnable)
		INVOKE_ASYNC(src, .proc/jedi_spin, user)

/obj/item/twohanded/dualsaber/green
	possible_colors = list("green")

/obj/item/twohanded/dualsaber/red
	possible_colors = list("red")

/obj/item/twohanded/dualsaber/blue
	possible_colors = list("blue")

/obj/item/twohanded/dualsaber/purple
	possible_colors = list("purple")

/obj/item/twohanded/dualsaber/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/multitool))
		if(!hacked)
			hacked = TRUE
			to_chat(user, "<span class='warning'>2XRNBW_ENGAGE</span>")
			item_color = "rainbow"
			update_icon()
		else
			to_chat(user, "<span class='warning'>It's starting to look like a triple rainbow - no, nevermind.</span>")
	else
		return ..()

/////////////////////////////////////////////////////
//	HYPEREUTACTIC Blades	/////////////////////////
/////////////////////////////////////////////////////

/obj/item/twohanded/dualsaber/hypereutactic
	icon = 'icons/obj/1x2.dmi'
	icon_state = "hypereutactic"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
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

/obj/item/twohanded/dualsaber/hypereutactic/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/twohanded/dualsaber/hypereutactic/update_icon_state()
	return

/obj/item/twohanded/dualsaber/hypereutactic/update_overlays()
	. = ..()
	var/mutable_appearance/blade_overlay = mutable_appearance(icon, "hypereutactic_blade")
	var/mutable_appearance/gem_overlay = mutable_appearance(icon, "hypereutactic_gem")

	if(light_color)
		blade_overlay.color = light_color
		gem_overlay.color = light_color

	. += gem_overlay

	if(wielded)
		. += blade_overlay

	clean_blood()

/obj/item/twohanded/dualsaber/hypereutactic/AltClick(mob/living/user)
	. = ..()
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
	return TRUE

/obj/item/twohanded/dualsaber/hypereutactic/worn_overlays(isinhands, icon_file, style_flags = NONE)
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
	. = ..()
	if(!hacked)
		. += "<span class='notice'>Alt-click to recolor it.</span>"

/obj/item/twohanded/dualsaber/hypereutactic/rainbow_process()
	. = ..()
	update_icon()
	update_light()

/obj/item/twohanded/dualsaber/hypereutactic/chaplain
	name = "divine lightblade"
	desc = "A giant blade of bright and holy light, said to cut down the wicked with ease."
	force = 5
	force_unwielded = 5
	force_wielded = 20
	block_chance = 50
	armour_penetration = 0
	var/chaplain_spawnable = TRUE
	can_reflect = FALSE
	obj_flags = UNIQUE_RENAME

/obj/item/twohanded/dualsaber/hypereutactic/chaplain/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/anti_magic, TRUE, TRUE, FALSE, null, null, FALSE)

//spears
/obj/item/twohanded/spear
	icon_state = "spearglass0"
	lefthand_file = 'icons/mob/inhands/weapons/polearms_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/polearms_righthand.dmi'
	name = "spear"
	desc = "A haphazardly-constructed yet still deadly weapon of ancient design."
	force = 10
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	force_unwielded = 10
	force_wielded = 18
	throwforce = 20
	throw_speed = 4
	embedding = list("embedded_impact_pain_multiplier" = 3, "embed_chance" = 90)
	armour_penetration = 10
	custom_materials = list(/datum/material/iron=1150, /datum/material/glass=2075)
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")
	sharpness = IS_SHARP
	max_integrity = 200
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 30)
	var/obj/item/grenade/explosive = null
	var/war_cry = "AAAAARGH!!!"
	var/icon_prefix = "spearglass"

/obj/item/twohanded/spear/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 100, 70) //decent in a pinch, but pretty bad.
	AddComponent(/datum/component/jousting)
	AddElement(/datum/element/sword_point)

/obj/item/twohanded/spear/attack_self(mob/user)
	if(explosive)
		explosive.attack_self(user)
		return
	. = ..()

//Citadel additions : attack_self and rightclick_attack_self

/obj/item/twohanded/rightclick_attack_self(mob/user)
	if(wielded) //Trying to unwield it
		unwield(user)
	else //Trying to wield it
		wield(user)
	return TRUE

/obj/item/twohanded/spear/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user] begins to sword-swallow \the [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	if(explosive) //Citadel Edit removes qdel and explosive.forcemove(AM)
		user.say("[war_cry]", forced="spear warcry")
		explosive.prime()
		user.gib()
		return BRUTELOSS
	return BRUTELOSS

/obj/item/twohanded/spear/examine(mob/user)
	. = ..()
	if(explosive)
		. += "<span class='notice'>Use in your hands to activate the attached explosive.</span><br><span class='notice'>Alt-click to set your war cry.</span><br><span class='notice'>Right-click in combat mode to wield</span>"

/obj/item/twohanded/spear/update_icon_state()
	if(explosive)
		icon_state = "spearbomb[wielded]"
	else
		icon_state = "[icon_prefix][wielded]"

/obj/item/twohanded/spear/afterattack(atom/movable/AM, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(isopenturf(AM)) //So you can actually melee with it
		return
	if(explosive && wielded) //Citadel edit removes qdel and explosive.forcemove(AM)
		user.say("[war_cry]", forced="spear warcry")
		explosive.prime()

/obj/item/twohanded/spear/grenade_prime_react(obj/item/grenade/nade) //Citadel edit, removes throw_impact because memes
	nade.forceMove(get_turf(src))
	qdel(src)

/obj/item/twohanded/spear/AltClick(mob/user)
	. = ..()
	if(user.canUseTopic(src, BE_CLOSE))
		..()
		if(!explosive)
			return
		if(istype(user) && loc == user)
			var/input = stripped_input(user,"What do you want your war cry to be? You will shout it when you hit someone in melee.", ,"", 50)
			if(input)
				src.war_cry = input
		return TRUE

/obj/item/twohanded/spear/CheckParts(list/parts_list)
	var/obj/item/shard/tip = locate() in parts_list
	if (istype(tip, /obj/item/shard/plasma))
		force_wielded = 19
		force_unwielded = 11
		throwforce = 21
		icon_prefix = "spearplasma"
	qdel(tip)
	var/obj/item/twohanded/spear/S = locate() in parts_list
	if(S)
		if(S.explosive)
			S.explosive.forceMove(get_turf(src))
			S.explosive = null
		parts_list -= S
		qdel(S)
	..()
	var/obj/item/grenade/G = locate() in contents
	if(G)
		explosive = G
		name = "explosive lance"
		desc = "A makeshift spear with [G] attached to it."
	update_icon()

// CHAINSAW
/obj/item/twohanded/required/chainsaw
	name = "chainsaw"
	desc = "A versatile power tool. Useful for limbing trees and delimbing humans."
	icon_state = "chainsaw_off"
	lefthand_file = 'icons/mob/inhands/weapons/chainsaw_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/chainsaw_righthand.dmi'
	flags_1 = CONDUCT_1
	force = 13
	var/force_on = 24
	w_class = WEIGHT_CLASS_HUGE
	throwforce = 13
	throw_speed = 2
	throw_range = 4
	custom_materials = list(/datum/material/iron=13000)
	attack_verb = list("sawed", "torn", "cut", "chopped", "diced")
	hitsound = "swing_hit"
	sharpness = IS_SHARP
	actions_types = list(/datum/action/item_action/startchainsaw)
	var/on = FALSE
	tool_behaviour = TOOL_SAW
	toolspeed = 0.5

/obj/item/twohanded/required/chainsaw/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/butchering, 30, 100, 0, 'sound/weapons/chainsawhit.ogg', TRUE)
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/twohanded/required/chainsaw/suicide_act(mob/living/carbon/user)
	if(on)
		user.visible_message("<span class='suicide'>[user] begins to tear [user.p_their()] head off with [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
		playsound(src, 'sound/weapons/chainsawhit.ogg', 100, 1)
		var/obj/item/bodypart/head/myhead = user.get_bodypart(BODY_ZONE_HEAD)
		if(myhead)
			myhead.dismember()
	else
		user.visible_message("<span class='suicide'>[user] smashes [src] into [user.p_their()] neck, destroying [user.p_their()] esophagus! It looks like [user.p_theyre()] trying to commit suicide!</span>")
		playsound(src, 'sound/weapons/genhit1.ogg', 100, 1)
	return(BRUTELOSS)

/obj/item/twohanded/required/chainsaw/attack_self(mob/user)
	on = !on
	to_chat(user, "As you pull the starting cord dangling from [src], [on ? "it begins to whirr." : "the chain stops moving."]")
	force = on ? force_on : initial(force)
	throwforce = on ? force_on : force
	update_icon()
	var/datum/component/butchering/butchering = src.GetComponent(/datum/component/butchering)
	butchering.butchering_enabled = on

	if(on)
		hitsound = 'sound/weapons/chainsawhit.ogg'
	else
		hitsound = "swing_hit"

/obj/item/twohanded/required/chainsaw/update_icon_state()
	icon_state = "chainsaw_[on ? "on" : "off"]"

/obj/item/twohanded/required/chainsaw/get_dismemberment_chance()
	if(wielded)
		. = ..()

/obj/item/twohanded/required/chainsaw/doomslayer
	name = "THE GREAT COMMUNICATOR"
	desc = "<span class='warning'>VRRRRRRR!!!</span>"
	armour_penetration = 100
	force_on = 30

/obj/item/twohanded/required/chainsaw/doomslayer/check_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	block_return[BLOCK_RETURN_REFLECT_PROJECTILE_CHANCE] = 100
	return ..()

/obj/item/twohanded/required/chainsaw/doomslayer/run_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(attack_type & ATTACK_TYPE_PROJECTILE)
		owner.visible_message("<span class='danger'>Ranged attacks just make [owner] angrier!</span>")
		playsound(src, pick('sound/weapons/bulletflyby.ogg', 'sound/weapons/bulletflyby2.ogg', 'sound/weapons/bulletflyby3.ogg'), 75, 1)
		return BLOCK_SUCCESS | BLOCK_PHYSICAL_EXTERNAL
	return ..()

//GREY TIDE
/obj/item/twohanded/spear/grey_tide
	icon_state = "spearglass0"
	name = "\improper Grey Tide"
	desc = "Recovered from the aftermath of a revolt aboard Defense Outpost Theta Aegis, in which a seemingly endless tide of Assistants caused heavy casualities among Nanotrasen military forces."
	force_unwielded = 15
	force_wielded = 25
	throwforce = 20
	throw_speed = 4
	attack_verb = list("gored")
	var/clonechance = 50
	var/clonedamage = 12
	var/clonespeed = 0
	var/clone_replication_chance = 30
	var/clone_lifespan = 100

/obj/item/twohanded/spear/grey_tide/afterattack(atom/movable/AM, mob/living/user, proximity)
	. = ..()
	if(!proximity)
		return
	user.faction |= "greytide([REF(user)])"
	if(isliving(AM))
		var/mob/living/L = AM
		if(istype (L, /mob/living/simple_animal/hostile/illusion))
			return
		if(!L.stat && prob(clonechance))
			var/mob/living/simple_animal/hostile/illusion/M = new(user.loc)
			M.faction = user.faction.Copy()
			M.set_varspeed(clonespeed)
			M.Copy_Parent(user, clone_lifespan, user.health/2.5, clonedamage, clone_replication_chance)
			M.GiveTarget(L)

/obj/item/twohanded/pitchfork
	icon_state = "pitchfork0"
	lefthand_file = 'icons/mob/inhands/weapons/polearms_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/polearms_righthand.dmi'
	name = "pitchfork"
	desc = "A simple tool used for moving hay."
	force = 7
	throwforce = 15
	w_class = WEIGHT_CLASS_BULKY
	force_unwielded = 7
	force_wielded = 15
	attack_verb = list("attacked", "impaled", "pierced")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = IS_SHARP
	max_integrity = 200
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 30)
	resistance_flags = FIRE_PROOF

/obj/item/twohanded/pitchfork/Initialize(mapload)
	AddElement(/datum/element/sword_point)

/obj/item/twohanded/pitchfork/demonic
	name = "demonic pitchfork"
	desc = "A red pitchfork, it looks like the work of the devil."
	force = 19
	throwforce = 24
	force_unwielded = 19
	force_wielded = 25

/obj/item/twohanded/pitchfork/demonic/Initialize()
	. = ..()
	set_light(3,6,LIGHT_COLOR_RED)

/obj/item/twohanded/pitchfork/demonic/greater
	force = 24
	throwforce = 50
	force_unwielded = 24
	force_wielded = 34

/obj/item/twohanded/pitchfork/demonic/ascended
	force = 100
	throwforce = 100
	force_unwielded = 100
	force_wielded = 500000 // Kills you DEAD.

/obj/item/twohanded/pitchfork/update_icon_state()
	icon_state = "pitchfork[wielded]"

/obj/item/twohanded/pitchfork/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] impales [user.p_them()]self in [user.p_their()] abdomen with [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return (BRUTELOSS)

/obj/item/twohanded/pitchfork/demonic/pickup(mob/living/user)
	if(isliving(user) && user.mind && user.owns_soul() && !is_devil(user))
		var/mob/living/U = user
		U.visible_message("<span class='warning'>As [U] picks [src] up, [U]'s arms briefly catch fire.</span>", \
			"<span class='warning'>\"As you pick up [src] your arms ignite, reminding you of all your past sins.\"</span>")
		if(ishuman(U))
			var/mob/living/carbon/human/H = U
			H.apply_damage(rand(force/2, force), BURN, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		else
			U.adjustFireLoss(rand(force/2,force))

/obj/item/twohanded/pitchfork/demonic/attack(mob/target, mob/living/carbon/human/user)
	if(user.mind && user.owns_soul() && !is_devil(user))
		to_chat(user, "<span class ='warning'>[src] burns in your hands.</span>")
		user.apply_damage(rand(force/2, force), BURN, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
	..()

/obj/item/twohanded/pitchfork/demonic/ascended/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity || !wielded)
		return
	if(iswallturf(target))
		var/turf/closed/wall/W = target
		user.visible_message("<span class='danger'>[user] blasts \the [target] with \the [src]!</span>")
		playsound(target, 'sound/magic/disintegrate.ogg', 100, 1)
		W.break_wall()
		W.ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
		return

//HF blade

/obj/item/twohanded/vibro_weapon
	icon_state = "hfrequency0"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	name = "vibro sword"
	desc = "A potent weapon capable of cutting through nearly anything. Wielding it in two hands will allow you to deflect gunfire."
	force_unwielded = 20
	force_wielded = 40
	armour_penetration = 100
	block_chance = 40
	throwforce = 20
	throw_speed = 4
	sharpness = IS_SHARP
	attack_verb = list("cut", "sliced", "diced")
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/twohanded/vibro_weapon/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 20, 105)
	AddElement(/datum/element/sword_point)

/obj/item/twohanded/vibro_weapon/run_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(wielded)
		final_block_chance *= 2
	if(wielded || !(attack_type & ATTACK_TYPE_PROJECTILE))
		if(prob(final_block_chance))
			if(attack_type & ATTACK_TYPE_PROJECTILE)
				owner.visible_message("<span class='danger'>[owner] deflects [attack_text] with [src]!</span>")
				playsound(src, pick('sound/weapons/bulletflyby.ogg', 'sound/weapons/bulletflyby2.ogg', 'sound/weapons/bulletflyby3.ogg'), 75, 1)
				block_return[BLOCK_RETURN_REDIRECT_METHOD] = REDIRECT_METHOD_DEFLECT
				return BLOCK_SUCCESS | BLOCK_REDIRECTED | BLOCK_SHOULD_REDIRECT | BLOCK_PHYSICAL_EXTERNAL
			else
				owner.visible_message("<span class='danger'>[owner] parries [attack_text] with [src]!</span>")
				return BLOCK_SUCCESS | BLOCK_PHYSICAL_EXTERNAL
	return NONE

/obj/item/twohanded/vibro_weapon/update_icon_state()
	icon_state = "hfrequency[wielded]"

/*
 * Bone Axe
 */
/obj/item/twohanded/fireaxe/boneaxe  // Blatant imitation of the fireaxe, but made out of bone.
	icon_state = "bone_axe0"
	name = "bone axe"
	desc = "A large, vicious axe crafted out of several sharpened bone plates and crudely tied together. Made of monsters, by killing monsters, for killing monsters."
	force_wielded = 23

/obj/item/twohanded/fireaxe/boneaxe/update_icon_state()
	icon_state = "bone_axe[wielded]"

/*
 * Bone Spear
 */
/obj/item/twohanded/bonespear	//Blatant imitation of spear, but made out of bone. Not valid for explosive modification.
	icon_state = "bone_spear0"
	lefthand_file = 'icons/mob/inhands/weapons/polearms_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/polearms_righthand.dmi'
	name = "bone spear"
	desc = "A haphazardly-constructed yet still deadly weapon. The pinnacle of modern technology."
	force = 11
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	force_unwielded = 11
	force_wielded = 20					//I have no idea how to balance
	reach = 2
	throwforce = 22
	throw_speed = 4
	embedding = list("embedded_impact_pain_multiplier" = 3)
	armour_penetration = 15				//Enhanced armor piercing
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")
	sharpness = IS_SHARP

/obj/item/twohanded/bonespear/update_icon_state()
	icon_state = "bone_spear[wielded]"

/obj/item/twohanded/binoculars
	name = "binoculars"
	desc = "Used for long-distance surveillance."
	item_state = "binoculars"
	icon_state = "binoculars"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	var/mob/listeningTo
	var/zoom_out_amt = 6
	var/zoom_amt = 10

/obj/item/twohanded/binoculars/Destroy()
	listeningTo = null
	return ..()

/obj/item/twohanded/binoculars/wield(mob/user)
	. = ..()
	if(!wielded)
		return
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, .proc/unwield)
	listeningTo = user
	user.visible_message("[user] holds [src] up to [user.p_their()] eyes.","You hold [src] up to your eyes.")
	item_state = "binoculars_wielded"
	user.regenerate_icons()
	if(!user?.client)
		return
	var/client/C = user.client
	var/_x = 0
	var/_y = 0
	switch(user.dir)
		if(NORTH)
			_y = zoom_amt
		if(EAST)
			_x = zoom_amt
		if(SOUTH)
			_y = -zoom_amt
		if(WEST)
			_x = -zoom_amt
	C.change_view(world.view + zoom_out_amt)
	C.pixel_x = world.icon_size*_x
	C.pixel_y = world.icon_size*_y

/obj/item/twohanded/binoculars/unwield(mob/user)
	. = ..()
	UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)
	listeningTo = null
	user.visible_message("[user] lowers [src].","You lower [src].")
	item_state = "binoculars"
	user.regenerate_icons()
	if(user && user.client)
		user.regenerate_icons()
		var/client/C = user.client
		C.change_view(CONFIG_GET(string/default_view))
		user.client.pixel_x = 0
		user.client.pixel_y = 0

/obj/item/twohanded/electrostaff
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "electrostaff"
	item_state = "electrostaff"
	lefthand_file = 'icons/mob/inhands/weapons/staves_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/staves_righthand.dmi'
	name = "riot suppression electrostaff"
	desc = "A large quarterstaff, with massive silver electrodes mounted at the end."
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_OCLOTHING
	force_unwielded = 5
	force_wielded = 10
	throwforce = 15			//if you are a madman and finish someone off with this, power to you.
	throw_speed = 1
	item_flags = NO_MAT_REDEMPTION | SLOWS_WHILE_IN_HAND
	block_chance = 30
	attack_verb = list("struck", "beaten", "thwacked", "pulped")
	total_mass = 5		//yeah this is a heavy thing, beating people with it while it's off is not going to do you any favors. (to curb stun-kill rampaging without it being on)
	var/obj/item/stock_parts/cell/cell = /obj/item/stock_parts/cell/high
	var/on = FALSE
	var/can_block_projectiles = FALSE		//can't block guns
	var/lethal_cost = 400			//10000/400*20 = 500. decent enough?
	var/lethal_damage = 20
	var/lethal_stam_cost = 4
	var/stun_cost = 333				//10000/333*25 = 750. stunbatons are at time of writing 10000/1000*49 = 490.
	var/stun_status_effect = STATUS_EFFECT_ELECTROSTAFF			//a small slowdown effect
	var/stun_stamdmg = 40
	var/stun_status_duration = 25
	var/stun_stam_cost = 3.5

/obj/item/twohanded/electrostaff/Initialize(mapload)
	. = ..()
	if(ispath(cell))
		cell = new cell

/obj/item/twohanded/electrostaff/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/twohanded/electrostaff/get_cell()
	. = cell
	if(iscyborg(loc))
		var/mob/living/silicon/robot/R = loc
		. = R.get_cell()

/obj/item/twohanded/electrostaff/run_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(!on || (!can_block_projectiles && (attack_type & ATTACK_TYPE_PROJECTILE)))
		return BLOCK_NONE
	return ..()

/obj/item/twohanded/electrostaff/proc/min_hitcost()
	return min(stun_cost, lethal_cost)

/obj/item/twohanded/electrostaff/proc/turn_on(mob/user, silent = FALSE)
	if(on)
		return
	if(!cell)
		if(user)
			to_chat(user, "<span class='warning'>[src] has no cell.</span>")
		return
	if(cell.charge < min_hitcost())
		if(user)
			to_chat(user, "<span class='warning'>[src] is out of charge.</span>")
		return
	on = TRUE
	START_PROCESSING(SSobj, src)
	if(user)
		to_chat(user, "<span class='warning'>You turn [src] on.</span>")
	update_icon()
	if(!silent)
		playsound(src, "sparks", 75, 1, -1)

/obj/item/twohanded/electrostaff/proc/turn_off(mob/user, silent = FALSE)
	if(!on)
		return
	if(user)
		to_chat(user, "<span class='warning'>You turn [src] off.</span>")
	on = FALSE
	STOP_PROCESSING(SSobj, src)
	update_icon()
	if(!silent)
		playsound(src, "sparks", 75, 1, -1)

/obj/item/twohanded/electrostaff/proc/toggle(mob/user, silent = FALSE)
	if(on)
		turn_off(user, silent)
	else
		turn_on(user, silent)

/obj/item/twohanded/electrostaff/wield(mob/user)
	. = ..()
	if(wielded)
		turn_on(user)
	add_fingerprint(user)

/obj/item/twohanded/electrostaff/unwield(mob/user)
	. = ..()
	if(!wielded)
		turn_off(user)
	add_fingerprint(user)

/obj/item/twohanded/electrostaff/update_icon_state()
	. = ..()
	if(!wielded)
		icon_state = "electrostaff"
		item_state = "electrostaff"
	else
		icon_state = item_state = (on? "electrostaff_1" : "electrostaff_0")
	set_light(7, on? 1 : 0, LIGHT_COLOR_CYAN)

/obj/item/twohanded/electrostaff/examine(mob/living/user)
	. = ..()
	if(cell)
		. += "<span class='notice'>The cell charge is [round(cell.percent())]%.</span>"
	else
		. += "<span class='warning'>There is no cell installed!</span>"

/obj/item/twohanded/electrostaff/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stock_parts/cell))
		var/obj/item/stock_parts/cell/C = W
		if(cell)
			to_chat(user, "<span class='warning'>[src] already has a cell!</span>")
		else
			if(C.maxcharge < min_hit_cost())
				to_chat(user, "<span class='notice'>[src] requires a higher capacity cell.</span>")
				return
			if(!user.transferItemToLoc(W, src))
				return
			cell = C
			to_chat(user, "<span class='notice'>You install a cell in [src].</span>")

	else if(W.tool_behaviour == TOOL_SCREWDRIVER)
		if(cell)
			cell.update_icon()
			cell.forceMove(get_turf(src))
			cell = null
			to_chat(user, "<span class='notice'>You remove the cell from [src].</span>")
			turn_off(user, TRUE)
	else
		return ..()

/obj/item/twohanded/electrostaff/process()
	deductcharge(50)			//Wasteful!

/obj/item/twohanded/electrostaff/proc/min_hit_cost()
	return min(lethal_cost, stun_cost)

/obj/item/twohanded/electrostaff/proc/deductcharge(amount)
	var/obj/item/stock_parts/cell/C = get_cell()
	if(!C)
		turn_off()
		return FALSE
	C.use(min(amount, C.charge))
	if(QDELETED(src))
		return FALSE
	if(C.charge < min_hit_cost())
		turn_off()

/obj/item/twohanded/electrostaff/attack(mob/living/target, mob/living/user)
	if(IS_STAMCRIT(user))//CIT CHANGE - makes it impossible to baton in stamina softcrit
		to_chat(user, "<span class='danger'>You're too exhausted for that.</span>")//CIT CHANGE - ditto
		return //CIT CHANGE - ditto
	if(on && HAS_TRAIT(user, TRAIT_CLUMSY) && prob(50))
		clowning_around(user)			//ouch!
		return
	if(iscyborg(target))
		..()
		return
	if(target.run_block(src, 0, "[user]'s [name]", ATTACK_TYPE_MELEE, 0, user) & BLOCK_SUCCESS) //No message; run_block() handles that
		playsound(target, 'sound/weapons/genhit.ogg', 50, 1)
		return FALSE
	if(user.a_intent != INTENT_HARM)
		if(stun_act(target, user))
			user.do_attack_animation(target)
			user.adjustStaminaLossBuffered(stun_stam_cost)
		return
	else if(!harm_act(target, user))
		return ..()		//if you can't fry them just beat them with it
	else		//we did harm act them
		user.do_attack_animation(target)
		user.adjustStaminaLossBuffered(lethal_stam_cost)

/obj/item/twohanded/electrostaff/proc/stun_act(mob/living/target, mob/living/user, no_charge_and_force = FALSE)
	var/stunforce = stun_stamdmg
	if(!no_charge_and_force)
		if(!on)
			target.visible_message("<span class='warning'>[user] has bapped [target] with [src]. Luckily it was off.</span>", \
							"<span class='warning'>[user] has bapped you with [src]. Luckily it was off</span>")
			turn_off()			//if it wasn't already off
			return FALSE
		var/obj/item/stock_parts/cell/C = get_cell()
		var/chargeleft = C.charge
		deductcharge(stun_cost)
		if(QDELETED(src) || QDELETED(C))		//boom
			return FALSE
		if(chargeleft < stun_cost)
			stunforce *= round(chargeleft/stun_cost, 0.1)
	target.adjustStaminaLoss(stunforce)
	target.apply_effect(EFFECT_STUTTER, stunforce)
	SEND_SIGNAL(target, COMSIG_LIVING_MINOR_SHOCK)
	if(user)
		target.lastattacker = user.real_name
		target.lastattackerckey = user.ckey
		target.visible_message("<span class='danger'>[user] has shocked [target] with [src]!</span>", \
								"<span class='userdanger'>[user] has shocked you with [src]!</span>")
		log_combat(user, target, "stunned with an electrostaff")
	playsound(src, 'sound/weapons/staff.ogg', 50, 1, -1)
	target.apply_status_effect(stun_status_effect, stun_status_duration)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.forcesay(GLOB.hit_appends)
	return TRUE

/obj/item/twohanded/electrostaff/proc/harm_act(mob/living/target, mob/living/user, no_charge_and_force = FALSE)
	var/lethal_force = lethal_damage
	if(!no_charge_and_force)
		if(!on)
			return FALSE		//standard item attack
		var/obj/item/stock_parts/cell/C = get_cell()
		var/chargeleft = C.charge
		deductcharge(lethal_cost)
		if(QDELETED(src) || QDELETED(C))		//boom
			return FALSE
		if(chargeleft < stun_cost)
			lethal_force *= round(chargeleft/lethal_cost, 0.1)
	target.adjustFireLoss(lethal_force)		//good against ointment spam
	SEND_SIGNAL(target, COMSIG_LIVING_MINOR_SHOCK)
	if(user)
		target.lastattacker = user.real_name
		target.lastattackerckey = user.ckey
		target.visible_message("<span class='danger'>[user] has seared [target] with [src]!</span>", \
								"<span class='userdanger'>[user] has seared you with [src]!</span>")
		log_combat(user, target, "burned with an electrostaff")
	playsound(src, 'sound/weapons/sear.ogg', 50, 1, -1)
	return TRUE

/obj/item/twohanded/electrostaff/proc/clowning_around(mob/living/user)
	user.visible_message("<span class='danger'>[user] accidentally hits [user.p_them()]self with [src]!</span>", \
						"<span class='userdanger'>You accidentally hit yourself with [src]!</span>")
	SEND_SIGNAL(user, COMSIG_LIVING_MINOR_SHOCK)
	harm_act(user, user, TRUE)
	stun_act(user, user, TRUE)
	deductcharge(lethal_cost)

/obj/item/twohanded/electrostaff/emp_act(severity)
	. = ..()
	if (!(. & EMP_PROTECT_SELF))
		turn_off()
		if(!iscyborg(loc))
			deductcharge(1000 / severity, TRUE, FALSE)

/obj/item/twohanded/broom
	name = "broom"
	desc = "This is my BROOMSTICK! It can be used manually or braced with two hands to sweep items as you move. It has a telescopic handle for compact storage." //LIES
	icon = 'icons/obj/janitor.dmi'
	icon_state = "broom0"
	lefthand_file = 'icons/mob/inhands/equipment/custodial_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/custodial_righthand.dmi'
	force = 8
	throwforce = 10
	throw_speed = 3
	throw_range = 7
	w_class = WEIGHT_CLASS_NORMAL
	force_unwielded = 8
	force_wielded = 12
	attack_verb = list("swept", "brushed off", "bludgeoned", "whacked")
	resistance_flags = FLAMMABLE

/obj/item/twohanded/broom/update_icon_state()
	icon_state = "broom[wielded]"

/obj/item/twohanded/broom/wield(mob/user)
	. = ..()
	if(!wielded)
		return
	to_chat(user, "<span class='notice'>You brace the [src] against the ground in a firm sweeping stance.</span>")
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, .proc/sweep)

/obj/item/twohanded/broom/unwield(mob/user)
	. = ..()
	UnregisterSignal(user, COMSIG_MOVABLE_MOVED)

/obj/item/twohanded/broom/afterattack(atom/A, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	sweep(user, A, FALSE)

/obj/item/twohanded/broom/proc/sweep(mob/user, atom/A, moving = TRUE)
	var/turf/target
	if (!moving)
		if (isturf(A))
			target = A
		else
			target = A.loc
			if(!isturf(target)) //read: Mob inventories.
				return
	else
		target = user.loc
	if (locate(/obj/structure/table) in target.contents)
		return
	var/i = 0
	for(var/obj/item/garbage in target.contents)
		if(!garbage.anchored)
			garbage.Move(get_step(target, user.dir), user.dir)
		i++
		if(i >= 20)
			break
	if(i >= 1)
		playsound(loc, 'sound/weapons/thudswoosh.ogg', 5, TRUE, -1)

/obj/item/twohanded/broom/proc/janicart_insert(mob/user, obj/structure/janitorialcart/J) //bless you whoever fixes this copypasta
	J.put_in_cart(src, user)
	J.mybroom=src
	J.update_icon()
