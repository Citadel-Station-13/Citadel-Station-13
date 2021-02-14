/obj/item/clothing/under
	icon = 'icons/obj/clothing/uniforms.dmi'
	name = "under"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	permeability_coefficient = 0.9
	block_priority = BLOCK_PRIORITY_UNIFORM
	slot_flags = ITEM_SLOT_ICLOTHING
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0, "wound" = 5)
	mutantrace_variation = STYLE_DIGITIGRADE|USE_TAUR_CLIP_MASK
	limb_integrity = 30
	var/fitted = FEMALE_UNIFORM_FULL // For use in alternate clothing styles for women
	var/has_sensor = HAS_SENSORS // For the crew computer
	var/random_sensor = TRUE
	var/sensor_mode = NO_SENSORS
	var/can_adjust = TRUE
	var/adjusted = NORMAL_STYLE
	var/alt_covers_chest = FALSE // for adjusted/rolled-down jumpsuits, FALSE = exposes chest and arms, TRUE = exposes arms only
	var/dummy_thick = FALSE // is able to hold accessories on its item
	//SKYRAT EDIT - Removed the old attached accessory system. We use a list of accessories instead.
	var/list/obj/item/clothing/accessory/attached_accessories = list()
	var/max_accessories = 3
	//SKYRAT EDIT END
	var/mutable_appearance/accessory_overlay

/obj/item/clothing/under/worn_overlays(isinhands = FALSE, icon_file, used_state, style_flags = NONE)
	. = ..()
	if(isinhands)
		return
	if(damaged_clothes)
		. += mutable_appearance('icons/effects/item_damage.dmi', "damageduniform")
	if(blood_DNA)
		. += mutable_appearance('icons/effects/blood.dmi', "uniformblood", color = blood_DNA_to_color())
	if(accessory_overlay)
		. += accessory_overlay

/obj/item/clothing/under/attackby(obj/item/I, mob/user, params)
	if((has_sensor == BROKEN_SENSORS) && istype(I, /obj/item/stack/cable_coil))
		if(damaged_clothes)
			to_chat(user,"<span class='warning'>You should repair the damage done to [src] first.</span>")
			return 0
		var/obj/item/stack/cable_coil/C = I
		I.use_tool(src, user, 0, 1)
		has_sensor = HAS_SENSORS
		to_chat(user,"<span class='notice'>You repair the suit sensors on [src] with [C].</span>")
		return 1
	if(!attach_accessory(I, user))
		return ..()

/obj/item/clothing/under/update_clothes_damaged_state()
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_w_uniform()
	if(has_sensor > NO_SENSORS)
		has_sensor = BROKEN_SENSORS

/obj/item/clothing/under/New()
	if(random_sensor)
		//make the sensor mode favor higher levels, except coords.
		sensor_mode = pick(SENSOR_OFF, SENSOR_LIVING, SENSOR_LIVING, SENSOR_VITALS, SENSOR_VITALS, SENSOR_VITALS, SENSOR_COORDS, SENSOR_COORDS)
	..()

/obj/item/clothing/under/equipped(mob/user, slot)
	..()
	if(adjusted)
		adjusted = NORMAL_STYLE
		fitted = initial(fitted)
		if(!alt_covers_chest)
			body_parts_covered |= CHEST

	//SKYRAT EDIT
	for(var/obj/item/clothing/accessory/attached_accessory in attached_accessories)
		if(attached_accessory && slot != SLOT_HANDS && ishuman(user))
			var/mob/living/carbon/human/H = user
			attached_accessory.on_uniform_equip(src, user)
			if(attached_accessory.above_suit)
				H.update_inv_wear_suit()
	//SKYRAT EDIT END

/obj/item/clothing/under/dropped(mob/user)
	//SKYRAT EDIT
	for(var/obj/item/clothing/accessory/attached_accessory in attached_accessories)
		attached_accessory.on_uniform_dropped(src, user)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(attached_accessory.above_suit)
				H.update_inv_wear_suit()
	//SKYRAT EDIT END
	..()

/obj/item/clothing/under/proc/attach_accessory(obj/item/I, mob/user, notifyAttach = 1)
	. = FALSE
	if(istype(I, /obj/item/clothing/accessory))
		var/obj/item/clothing/accessory/A = I
		if(length(attached_accessories) >= max_accessories)
			if(user)
				to_chat(user, "<span class='warning'>[src] already has [length(attached_accessories)] accessories.</span>")
			return
		if(dummy_thick)
			if(user)
				to_chat(user, "<span class='warning'>[src] is too bulky and cannot have accessories attached to it!</span>")
			return
		else
			if(user && !user.temporarilyRemoveItemFromInventory(I))
				return
			if(!A.attach(src, user))
				return

			if(user && notifyAttach)
				to_chat(user, "<span class='notice'>You attach [I] to [src].</span>")

			if((flags_inv & HIDEACCESSORY) || (A.flags_inv & HIDEACCESSORY))
				return TRUE

			//SKYRAT EDIT
			accessory_overlay = mutable_appearance('icons/mob/clothing/accessories.dmi', "blank")
			for(var/obj/item/clothing/accessory/attached_accessory in attached_accessories)
				var/mutable_appearance/Y = mutable_appearance(attached_accessory.mob_overlay_icon, attached_accessory.icon_state, ABOVE_HUD_LAYER)
				Y.alpha = attached_accessory.alpha
				Y.color = attached_accessory.color
				accessory_overlay.add_overlay(Y)
			//SKYRAT EDIT END

			if(ishuman(loc))
				var/mob/living/carbon/human/H = loc
				H.update_inv_w_uniform()
				H.update_inv_wear_suit()

			return TRUE

/obj/item/clothing/under/proc/remove_accessory(mob/user)
	if(!isliving(user))
		return
	if(!can_use(user))
		return

	//SKYRAT EDIT
	if(length(attached_accessories))
		var/obj/item/clothing/accessory/A = attached_accessories[length(attached_accessories)]
	//SKYRAT EDIT END
		A.detach(src, user)
		if(user.put_in_hands(A))
			to_chat(user, "<span class='notice'>You detach [A] from [src].</span>")
		else
			to_chat(user, "<span class='notice'>You detach [A] from [src] and it falls on the floor.</span>")

		if(ishuman(loc))
			var/mob/living/carbon/human/H = loc
			H.update_inv_w_uniform()
			H.update_inv_wear_suit()


/obj/item/clothing/under/examine(mob/user)
	. = ..()
	if(can_adjust)
		if(adjusted == ALT_STYLE)
			. += "Alt-click on [src] to wear it normally."
		else
			. += "Alt-click on [src] to wear it casually."
	if (has_sensor == BROKEN_SENSORS)
		. += "Its sensors appear to be shorted out."
	else if(has_sensor > NO_SENSORS)
		switch(sensor_mode)
			if(SENSOR_OFF)
				. += "Its sensors appear to be disabled."
			if(SENSOR_LIVING)
				. += "Its binary life sensors appear to be enabled."
			if(SENSOR_VITALS)
				. += "Its vital tracker appears to be enabled."
			if(SENSOR_COORDS)
				. += "Its vital tracker and tracking beacon appear to be enabled."
	if(length(attached_accessories))
		for(var/obj/item/clothing/accessory/attached_accessory in attached_accessories)
			. += "\A [attached_accessory] is attached to it."
	//SKYRAT EDIT END

/obj/item/clothing/under/verb/toggle()
	set name = "Adjust Suit Sensors"
	set category = "Object"
	set src in usr
	var/mob/M = usr
	if (istype(M, /mob/dead/))
		return
	if (!can_use(M))
		return
	if(src.has_sensor == LOCKED_SENSORS)
		to_chat(usr, "The controls are locked.")
		return 0
	if(src.has_sensor == BROKEN_SENSORS)
		to_chat(usr, "The sensors have shorted out!")
		return 0
	if(src.has_sensor <= NO_SENSORS)
		to_chat(usr, "This suit does not have any sensors.")
		return 0

	var/list/modes = list("Off", "Binary vitals", "Exact vitals", "Tracking beacon")
	var/switchMode = input("Select a sensor mode:", "Suit Sensor Mode", modes[sensor_mode + 1]) in modes
	if(get_dist(usr, src) > 1)
		to_chat(usr, "<span class='warning'>You have moved too far away!</span>")
		return
	sensor_mode = modes.Find(switchMode) - 1

	if (src.loc == usr)
		switch(sensor_mode)
			if(0)
				to_chat(usr, "<span class='notice'>You disable your suit's remote sensing equipment.</span>")
			if(1)
				to_chat(usr, "<span class='notice'>Your suit will now only report whether you are alive or dead.</span>")
			if(2)
				to_chat(usr, "<span class='notice'>Your suit will now only report your exact vital lifesigns.</span>")
			if(3)
				to_chat(usr, "<span class='notice'>Your suit will now report your exact vital lifesigns as well as your coordinate position.</span>")

	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(H.w_uniform == src)
			H.update_suit_sensors()


/obj/item/clothing/under/CtrlClick(mob/user)
	. = ..()

	if (!(item_flags & IN_INVENTORY))
		return

	if(!isliving(user) || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return

	if(has_sensor == LOCKED_SENSORS)
		to_chat(user, "The controls are locked.")
		return
	if(has_sensor == BROKEN_SENSORS)
		to_chat(user, "The sensors have shorted out!")
		return
	if(has_sensor <= NO_SENSORS)
		to_chat(user, "This suit does not have any sensors.")
		return

	sensor_mode = SENSOR_COORDS

	to_chat(user, "<span class='notice'>Your suit will now report your exact vital lifesigns as well as your coordinate position.</span>")

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.w_uniform == src)
			H.update_suit_sensors()

/obj/item/clothing/under/AltClick(mob/user)
	. = ..()
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	if(length(attached_accessories)) //SKYRAT EDIT
		remove_accessory(user)
	else
		rolldown()

/obj/item/clothing/under/verb/jumpsuit_adjust()
	set name = "Adjust Jumpsuit Style"
	set category = null
	set src in usr
	rolldown()

/obj/item/clothing/under/proc/rolldown()
	if(!can_use(usr))
		return
	if(toggle_jumpsuit_adjust() && ishuman(usr))
		var/mob/living/carbon/human/H = usr
		H.update_inv_w_uniform()
		H.update_body()

/obj/item/clothing/under/proc/toggle_jumpsuit_adjust()
	if(!can_adjust)
		to_chat(usr, "<span class='warning'>You cannot wear this suit any differently!</span>")
		return FALSE
	adjusted = !adjusted

	if(adjusted)
		to_chat(usr, "<span class='notice'>You adjust the suit to wear it more casually.</span>")
		if(fitted != FEMALE_UNIFORM_TOP)
			fitted = NO_FEMALE_UNIFORM
		if(!alt_covers_chest) // for the special snowflake suits that expose the chest when adjusted
			body_parts_covered &= ~CHEST
			mutantrace_variation &= ~USE_TAUR_CLIP_MASK //How are we supposed to see the uniform otherwise?
	else
		to_chat(usr, "<span class='notice'>You adjust the suit back to normal.</span>")
		fitted = initial(fitted)
		if(!alt_covers_chest)
			body_parts_covered |= CHEST
			if(initial(mutantrace_variation) & USE_TAUR_CLIP_MASK)
				mutantrace_variation |= USE_TAUR_CLIP_MASK

	return TRUE

/obj/item/clothing/under/rank
	dying_key = DYE_REGISTRY_UNDER
