//Power armor
/obj/item/clothing/head/helmet/space/hardsuit/powerarmor
	name = "Power Armor Helmet MK. I"
	desc = "An advanced helmet attached to a powered exoskeleton suit. Protects well against most forms of harm, but struggles against exotic hazards."
	icon = 'modular_sand/icons/obj/clothing/hats.dmi'
	mob_overlay_icon = 'modular_sand/icons/mob/clothing/head.dmi'
	anthro_mob_worn_overlay = 'modular_sand/icons/mob/clothing/head_muzzled.dmi'
	icon_state = "hardsuit0-powerarmor-1"
	item_state = "hardsuit0-powerarmor-1"
	hardsuit_type = "powerarmor"
	clothing_flags = THICKMATERIAL //Ouchie oofie my bones
	armor = list("melee" = 40, "bullet" = 35, "laser" = 30, "energy" = 20, "bomb" = 40, "bio" = 100, "rad" = 5, "fire" = 75, "acid" = 100)
	resistance_flags = ACID_PROOF
	mutantrace_variation = STYLE_MUZZLE | STYLE_NO_ANTHRO_ICON

/obj/item/clothing/head/helmet/space/hardsuit/powerarmor/Initialize()
	. = ..()
	AddComponent(/datum/component/spraycan_paintable)
	update_icon()

/obj/item/clothing/head/helmet/space/hardsuit/powerarmor/update_overlays()
	. = ..()
	var/mutable_appearance/glass_overlay = mutable_appearance(icon, "hardsuit0-powerarmor-2")
	if(icon_state == "hardsuit1-powerarmor-1")
		glass_overlay = mutable_appearance(icon, "hardsuit1-powerarmor-2")
		var/mutable_appearance/flight_overlay = mutable_appearance(icon, "hardsuit1-powerarmor-3")
		flight_overlay.appearance_flags = RESET_COLOR
		. += flight_overlay
	glass_overlay.appearance_flags = RESET_COLOR
	. += glass_overlay

/obj/item/clothing/head/helmet/space/hardsuit/powerarmor/worn_overlays(isinhands, icon_file, used_state, style_flags = NONE)
	. = ..()
	if(!isinhands)
		var/mutable_appearance/M1 = mutable_appearance(icon_file, "hardsuit0-powerarmor-2")
		if(icon_state == "hardsuit1-powerarmor-1")
			M1 = mutable_appearance(icon_file, "hardsuit1-powerarmor-2")
			var/mutable_appearance/M2 = mutable_appearance(icon, "hardsuit1-powerarmor-3")
			M2.appearance_flags = RESET_COLOR
			. += M2
		M1.appearance_flags = RESET_COLOR
		. += M1

/obj/item/clothing/head/helmet/space/hardsuit/powerarmor/equipped(mob/living/carbon/human/user, slot)
	..()
	if (slot == SLOT_HEAD)
		var/datum/atom_hud/DHUD = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
		DHUD.add_hud_to(user)

/obj/item/clothing/head/helmet/space/hardsuit/powerarmor/dropped(mob/living/carbon/human/user)
	..()
	if (user.head == src)
		var/datum/atom_hud/DHUD = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
		DHUD.remove_hud_from(user)

/obj/item/clothing/suit/space/hardsuit/powerarmor
	name = "Power Armor MK. I"
	desc = "A self-powered exoskeleton suit comprised of flexible Plasteel sheets and advanced components, designed to offer excellent protection while still allowing mobility. Does not protect against Space, and struggles against more exotic hazards."
	icon = 'modular_sand/icons/obj/clothing/suits.dmi'
	mob_overlay_icon = 'modular_sand/icons/mob/clothing/suit.dmi'
	anthro_mob_worn_overlay = 'modular_sand/icons/mob/clothing/suit_digi.dmi'
	icon_state = "hardsuit-powerarmor-1"
	item_state = "hardsuit-powerarmor-1"
	slowdown = -0.1
	clothing_flags = THICKMATERIAL //Not spaceproof. No, it isn't Spaceproof in Rimworld either.
	armor = list("melee" = 40, "bullet" = 35, "laser" = 30, "energy" = 20, "bomb" = 40, "bio" = 100, "rad" = 5, "fire" = 75, "acid" = 100) //I was asked to buff this again. Here, fine.
	resistance_flags = ACID_PROOF
	var/explodioprobemp = 1
	var/stamdamageemp = 200
	var/brutedamageemp = 20
	var/rebootdelay
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/powerarmor
	mutantrace_variation = STYLE_DIGITIGRADE | STYLE_NO_ANTHRO_ICON

/obj/item/clothing/suit/space/hardsuit/powerarmor/Initialize()
	. = ..()
	AddComponent(/datum/component/spraycan_paintable)
	update_icon()

/obj/item/clothing/suit/space/hardsuit/powerarmor/update_overlays()
	. = ..()
	var/mutable_appearance/black_overlay = mutable_appearance(icon, "hardsuit-powerarmor-2")
	black_overlay.appearance_flags = RESET_COLOR
	var/mutable_appearance/bluecore_overlay = mutable_appearance(icon, "hardsuit-powerarmor-3")
	bluecore_overlay.appearance_flags = RESET_COLOR
	. += black_overlay
	. += bluecore_overlay

/obj/item/clothing/suit/space/hardsuit/powerarmor/worn_overlays(isinhands, icon_file, used_state, style_flags = NONE)
	. = ..()
	if(!isinhands)
		var/mutable_appearance/M1 = mutable_appearance(icon_file, "hardsuit-powerarmor-2")
		M1.appearance_flags = RESET_COLOR
		var/mutable_appearance/M2 = mutable_appearance(icon_file, "hardsuit-powerarmor-3")
		M2.appearance_flags = RESET_COLOR
		. += M1
		. += M2

/obj/item/clothing/suit/space/hardsuit/powerarmor/emp_act()
	. = ..()
	var/mob/living/carbon/human/user = src.loc
	playsound(src.loc, 'modular_sand/sound/misc/suitmalf.ogg', 60, 1, 10)
	if (ishuman(user) && (user.wear_suit == src))
		to_chat(user, "<span class='danger'>The motors on your armor cease to function, causing the full weight of the suit to weigh on you all at once!</span>")
		user.emote("scream")
		user.adjustStaminaLoss(stamdamageemp)
		user.adjustBruteLoss(brutedamageemp)
	if(prob(explodioprobemp))
		playsound(src.loc, 'sound/effects/fuse.ogg', 60, 1, 10)
		visible_message("<span class ='warning'>The power module on the [src] begins to smoke, glowing with an alarming warmth! Get away from it, now!")
		addtimer(CALLBACK(src, .proc/detonate),50)
	else
		addtimer(CALLBACK(src, .proc/revivemessage), rebootdelay)
		return

/obj/item/clothing/suit/space/hardsuit/powerarmor/proc/revivemessage() //we use this proc to add a timer, so we can have it take a while to boot
	visible_message("<span class ='warning'>The power module on the [src] briefly flickers, before humming to life once more.</span>") //without causing any problems
	return //that sleep() would

/obj/item/clothing/suit/space/hardsuit/powerarmor/proc/detonate()
	visible_message("<span class ='danger'>The power module of the [src] overheats, causing it to destabilize and explode!")
	explosion(src.loc,0,0,3,flame_range = 3)
	qdel(src)
	return
