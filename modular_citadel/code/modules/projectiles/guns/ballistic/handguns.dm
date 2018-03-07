////////////Anti Tank Pistol////////////

/obj/item/gun/ballistic/automatic/pistol/antitank
	name = "Anti Tank Pistol"
	desc = "A massively impractical and silly monstrosity of a pistol that fires .50 calliber rounds. The recoil is likely to dislocate your wrist."
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "atp"
	item_state = "pistol"
	recoil = 4
	mag_type = /obj/item/ammo_box/magazine/sniper_rounds
	fire_delay = 50
	burst_size = 1
	can_suppress = 0
	w_class = WEIGHT_CLASS_NORMAL
	actions_types = list()
	fire_sound = 'sound/weapons/blastcannon.ogg'
	spread = 20		//damn thing has no rifling.

/obj/item/gun/ballistic/automatic/pistol/antitank/update_icon()
	..()
	if(magazine)
		cut_overlays()
		add_overlay("atp-mag")
	else
		cut_overlays()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"]"

/obj/item/gun/ballistic/automatic/pistol/antitank/syndicate
	name = "Syndicate Anti Tank Pistol"
	desc = "A massively impractical and silly monstrosity of a pistol that fires .50 calliber rounds. The recoil is likely to dislocate a variety of joints without proper bracing."
	pin = /obj/item/device/firing_pin/implant/pindicate

/*		made redundant by reskinnable stetchkins
//////Stealth Pistol//////

/obj/item/gun/ballistic/automatic/pistol/stealth
	name = "stealth pistol"
	desc = "A unique bullpup pistol with a compact frame. Has an integrated surpressor."
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "stealthpistol"
	w_class = WEIGHT_CLASS_SMALL
	mag_type = /obj/item/ammo_box/magazine/m10mm
	can_suppress = 0
	fire_sound = 'sound/weapons/gunshot_silenced.ogg'
	suppressed = 1
	burst_size = 1

/obj/item/gun/ballistic/automatic/pistol/stealth/update_icon()
	..()
	if(magazine)
		cut_overlays()
		add_overlay("stealthpistol-magazine")
	else
		cut_overlays()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"]"

*/

///foam stealth pistol///

/obj/item/gun/ballistic/automatic/toy/pistol/stealth
	name = "foam force stealth pistol"
	desc = "A small, easily concealable toy bullpup handgun. Ages 8 and up."
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "foamsp"
	w_class = WEIGHT_CLASS_SMALL
	mag_type = /obj/item/ammo_box/magazine/toy/pistol
	can_suppress = FALSE
	fire_sound = 'sound/weapons/gunshot_silenced.ogg'
	suppressed = TRUE
	burst_size = 1
	fire_delay = 0
	spread = 20
	actions_types = list()

/obj/item/gun/ballistic/automatic/toy/pistol/stealth/update_icon()
	..()
	if(magazine)
		cut_overlays()
		add_overlay("foamsp-magazine")
	else
		cut_overlays()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"]"

//////10mm soporific bullets//////

obj/item/projectile/bullet/c10mm/soporific
	name ="10mm soporific bullet"
	armour_penetration = 0
	nodamage = TRUE
	dismemberment = 0
	knockdown = 0

/obj/item/projectile/bullet/c10mm/soporific/on_hit(atom/target, blocked = FALSE)
	if((blocked != 100) && isliving(target))
		var/mob/living/L = target
		L.blur_eyes(6)
		if(L.getStaminaLoss() >= 60)
			L.Sleeping(300)
		else
			L.adjustStaminaLoss(25)
	return 1

/obj/item/ammo_casing/c10mm/soporific
	name = ".10mm soporific bullet casing"
	desc = "A 10mm soporific bullet casing."
	projectile_type = /obj/item/projectile/bullet/c10mm/soporific

/obj/item/ammo_box/magazine/m10mm/soporific
	name = "pistol magazine (10mm soporific)"
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "9x19pS"
	desc = "A gun magazine. Loaded with rounds which inject the target with a variety of illegal substances to induce sleep in the target."
	ammo_type = /obj/item/ammo_casing/c10mm/soporific

/obj/item/ammo_box/c10mm/soporific
	name = "ammo box (10mm soporific)"
	ammo_type = /obj/item/ammo_casing/c10mm/soporific
	max_ammo = 24

//////modular pistol////// (reskinnable stetchkins)

/obj/item/gun/ballistic/automatic/pistol/modular
	name = "modular pistol"
	desc = "A small, easily concealable 10mm handgun. Has a threaded barrel for suppressors."
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "cde"
	can_unsuppress = TRUE
	obj_flags = UNIQUE_RENAME
	unique_reskin = list("Default" = "cde",
						"NT-99" = "n99",
						"Stealth" = "stealthpistol",
						"HKVP-78" = "vp78",
						"Luger" = "p08b",
						"Mk.58" = "secguncomp",
						"PX4 Storm" = "px4"
						)

/obj/item/gun/ballistic/automatic/pistol/modular/update_icon()
	..()
	if(current_skin)
		icon_state = "[unique_reskin[current_skin]][chambered ? "" : "-e"][suppressed ? "-suppressed" : ""]"
	else
		icon_state = "[initial(icon_state)][chambered ? "" : "-e"][suppressed ? "-suppressed" : ""]"
	if(magazine && suppressed)
		cut_overlays()
		add_overlay("[unique_reskin[current_skin]]-magazine-sup")	//Yes, this means the default iconstate can't have a magazine overlay
	else if (magazine)
		cut_overlays()
		add_overlay("[unique_reskin[current_skin]]-magazine")
	else
		cut_overlays()

/////////RAYGUN MEMES/////////

/obj/item/projectile/beam/lasertag/ray		//the projectile, compatible with regular laser tag armor
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "ray"
	name = "ray bolt"
	eyeblur = 0

/obj/item/ammo_casing/energy/laser/raytag
	projectile_type = /obj/item/projectile/beam/lasertag/ray
	select_name = "raytag"
	fire_sound = 'sound/weapons/raygun.ogg'

/obj/item/gun/energy/laser/practice/raygun
	name = "toy ray gun"
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "raygun"
	desc = "A toy laser with a classic, retro feel and look. Compatible with existing laser tag systems."
	ammo_type = list(/obj/item/ammo_casing/energy/laser/raytag)
	selfcharge = TRUE

/*/////////////////////////////////////////////////////////////////////////////////////////////
							The Recolourable Gun
*//////////////////////////////////////////////////////////////////////////////////////////////

/obj/item/gun/ballistic/automatic/pistol/p37
	name = "\improper CX Mk.37P"
	desc = "A modern reimagining of an old legendary gun, the Mk.37 is a handgun with a toggle-locking mechanism manufactured by CX Armories. \
			This model is coated with a special polychromic material. \
			Has a small warning on the receiver that boldly states 'WARNING: WILL DETONATE UPON UNAUTHORIZED USE'. \
			Uses 9mm bullets loaded into proprietary magazines."
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "p37"
	w_class = WEIGHT_CLASS_NORMAL
	spawnwithmagazine = FALSE
	mag_type = /obj/item/ammo_box/magazine/m9mm/p37
	can_suppress = FALSE
	pin = /obj/item/device/firing_pin/dna/dredd		//goes boom if whoever isn't DNA locked to it tries to use it
	actions_types = list(/datum/action/item_action/pick_color)

	var/frame_color = "#808080" //RGB
	var/receiver_color = "#808080"
	var/body_color = "#0098FF"
	var/barrel_color = "#808080"
	var/tip_color = "#808080"
	var/arm_color = "#808080"
	var/grip_color = "#00FFCB"	//Does not actually colour the grip, just the lights surrounding it
	var/energy_color = "#00FFCB"

///Defining all the colourable bits and displaying them///

/obj/item/gun/ballistic/automatic/pistol/p37/update_icon()
	var/mutable_appearance/frame_overlay = mutable_appearance('icons/obj/guns/cit_guns.dmi', "p37_frame")
	var/mutable_appearance/receiver_overlay = mutable_appearance('icons/obj/guns/cit_guns.dmi', "p37_receiver")
	var/mutable_appearance/body_overlay = mutable_appearance('icons/obj/guns/cit_guns.dmi', "p37_body")
	var/mutable_appearance/barrel_overlay = mutable_appearance('icons/obj/guns/cit_guns.dmi', "p37_barrel")
	var/mutable_appearance/tip_overlay = mutable_appearance('icons/obj/guns/cit_guns.dmi', "p37_tip")
	var/mutable_appearance/grip_overlay = mutable_appearance('icons/obj/guns/cit_guns.dmi', "p37_grip")
	var/mutable_appearance/energy_overlay = mutable_appearance('icons/obj/guns/cit_guns.dmi', "p37_light")
	var/mutable_appearance/arm_overlay = mutable_appearance('icons/obj/guns/cit_guns.dmi', "p37_arm")
	var/mutable_appearance/arm_overlay_e = mutable_appearance('icons/obj/guns/cit_guns.dmi', "p37_arm-e")

	if(frame_color)
		frame_overlay.color = frame_color
	if(receiver_color)
		receiver_overlay.color = receiver_color
	if(body_color)
		body_overlay.color = body_color
	if(barrel_color)
		barrel_overlay.color = barrel_color
	if(tip_color)
		tip_overlay.color = tip_color
	if(grip_color)
		grip_overlay.color = grip_color
	if(energy_color)
		energy_overlay.color = energy_color
	if(arm_color)
		arm_overlay.color = arm_color
	if(arm_color)
		arm_overlay_e.color = arm_color

	cut_overlays()		//So that it doesn't keep stacking overlays non-stop on top of each other

	add_overlay(frame_overlay)
	add_overlay(receiver_overlay)
	add_overlay(body_overlay)
	add_overlay(barrel_overlay)
	add_overlay(tip_overlay)
	add_overlay(grip_overlay)
	add_overlay(energy_overlay)

	if(magazine)	//does not need a cut_overlays proc call here because it's already called further up
		add_overlay("p37_mag")

	if(chambered)
		cut_overlay(arm_overlay_e)
		add_overlay(arm_overlay)
	else
		cut_overlay(arm_overlay)
		add_overlay(arm_overlay_e)

///letting you actually recolor things///

/obj/item/gun/ballistic/automatic/pistol/p37/ui_action_click(mob/user, var/datum/action/A)
	if(istype(A, /datum/action/item_action/pick_color))

		var/choice = input(user,"Mk.37P polychrome options", "Gun Recolor") in list("Frame Color","Receiver Color","Body Color",
																"Barrel Color", "Barrel Tip Color", "Grip Light Color",
																"Light Color", "Arm Color", "*CANCEL*")

		switch(choice)

			if("Frame Color")
				var/frame_color_input = input(usr,"","Choose Frame Color",frame_color) as color|null
				if(frame_color_input)
					frame_color = sanitize_hexcolor(frame_color_input, desired_format=6, include_crunch=1)
				update_icon()

			if("Receiver Color")
				var/receiver_color_input = input(usr,"","Choose Receiver Color",receiver_color) as color|null
				if(receiver_color_input)
					receiver_color = sanitize_hexcolor(receiver_color_input, desired_format=6, include_crunch=1)
				update_icon()

			if("Body Color")
				var/body_color_input = input(usr,"","Choose Body Color",body_color) as color|null
				if(body_color_input)
					body_color = sanitize_hexcolor(body_color_input, desired_format=6, include_crunch=1)
				update_icon()

			if("Barrel Color")
				var/barrel_color_input = input(usr,"","Choose Barrel Color",barrel_color) as color|null
				if(barrel_color_input)
					barrel_color = sanitize_hexcolor(barrel_color_input, desired_format=6, include_crunch=1)
				update_icon()

			if("Barrel Tip Color")
				var/tip_color_input = input(usr,"","Choose Barrel Tip Color",tip_color) as color|null
				if(tip_color_input)
					tip_color = sanitize_hexcolor(tip_color_input, desired_format=6, include_crunch=1)
				update_icon()

			if("Grip Light Color")
				var/grip_color_input = input(usr,"","Choose Grip Light Color",grip_color) as color|null
				if(grip_color_input)
					grip_color = sanitize_hexcolor(grip_color_input, desired_format=6, include_crunch=1)
				update_icon()

			if("Light Color")
				var/energy_color_input = input(usr,"","Choose Light Color",energy_color) as color|null
				if(energy_color_input)
					energy_color = sanitize_hexcolor(energy_color_input, desired_format=6, include_crunch=1)
				update_icon()

			if("Arm Color")
				var/arm_color_input = input(usr,"","Choose Arm Color",arm_color) as color|null
				if(arm_color_input)
					arm_color = sanitize_hexcolor(arm_color_input, desired_format=6, include_crunch=1)
				update_icon()
				A.UpdateButtonIcon()

	else
		..()

///boolets///

/obj/item/projectile/bullet/c9mm/frangible
	name = "9mm frangible bullet"
	damage = 15
	stamina = 0
	speed = 1.0
	range = 20
	armour_penetration = -25

/obj/item/projectile/bullet/c9mm/rubber
	name = "9mm rubber bullet"
	damage = 5
	stamina = 30
	speed = 1.2
	range = 14
	knockdown = 0

/obj/item/ammo_casing/c9mm/frangible
	name = "9mm frangible bullet casing"
	desc = "A 9mm frangible bullet casing."
	projectile_type = /obj/item/projectile/bullet/c9mm/frangible

/obj/item/ammo_casing/c9mm/rubber
	name = "9mm rubber bullet casing"
	desc = "A 9mm rubber bullet casing."
	projectile_type = /obj/item/projectile/bullet/c9mm/rubber

/obj/item/ammo_box/magazine/m9mm/p37
	name = "\improper P37 magazine (9mm frangible)"
	desc = "A gun magazine. Loaded with plastic composite rounds which fragment upon impact to minimize collateral damage."
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "11mm"		//topkek
	ammo_type = /obj/item/ammo_casing/c9mm/frangible
	caliber = "9mm"
	max_ammo = 11
	multiple_sprites = 1

/obj/item/ammo_box/magazine/m9mm/p37/fmj
	name = "\improper P37 magazine (9mm)"
	ammo_type = /obj/item/ammo_casing/c9mm
	desc = "A gun magazine. Loaded with conventional full metal jacket rounds."

/obj/item/ammo_box/magazine/m9mm/p37/rubber
	name = "\improper P37 magazine (9mm Non-Lethal Rubbershot)"
	ammo_type = /obj/item/ammo_casing/c9mm/rubber
	desc = "A gun magazine. Loaded with less-than-lethal rubber bullets."

/obj/item/ammo_box/c9mm/frangible
	name = "ammo box (9mm frangible)"
	ammo_type = /obj/item/ammo_casing/c9mm/frangible

/obj/item/ammo_box/c9mm/rubber
	name = "ammo box (9mm non-lethal rubbershot)"
	ammo_type = /obj/item/ammo_casing/c9mm/rubber

/datum/design/c9mmfrag
	name = "Box of 9mm Frangible Bullets"
	id = "9mm_frag"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 25000)
	build_path = /obj/item/ammo_box/c9mm/frangible
	category = list("hacked", "Security")

/datum/design/c9mmrubber
	name = "Box of 9mm Rubber Bullets"
	id = "9mm_rubber"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 30000)
	build_path = /obj/item/ammo_box/c9mm/rubber
	category = list("initial", "Security")


///Security Variant///

/obj/item/gun/ballistic/automatic/pistol/p37/sec
	name = "\improper CX Mk.37S"
	desc = "A modern reimagining of an old legendary gun, the Mk.37 is a handgun with a toggle-locking mechanism manufactured by CX Armories. Uses 9mm bullets loaded into proprietary magazines."
	spawnwithmagazine = FALSE
	pin = /obj/item/device/firing_pin/implant/mindshield
	actions_types = list()	//so you can't recolor it

	frame_color = "#808080" //RGB
	receiver_color = "#808080"
	body_color = "#282828"
	barrel_color = "#808080"
	tip_color = "#808080"
	arm_color = "#800000"
	grip_color = "#FFFF00"	//Does not actually colour the grip, just the lights surrounding it
	energy_color = "#FFFF00"

///Foam Variant because WE NEED MEMES///

/obj/item/gun/ballistic/automatic/pistol/p37/foam
	name = "\improper Foam Force Mk.37F"
	desc = "A licensed foam-firing reproduction of a handgun with a toggle-locking mechanism manufactured by CX Armories. This model is coated with a special polychromic material. Uses standard foam pistol magazines."
	icon_state = "p37_foam"
	pin = /obj/item/device/firing_pin
	spawnwithmagazine = TRUE
	obj_flags = 0
	casing_ejector = FALSE
	mag_type = /obj/item/ammo_box/magazine/toy/pistol
	can_suppress = FALSE
	actions_types = list(/datum/action/item_action/pick_color)

/obj/item/ammo_box/magazine/toy/pistol	//forcing this might be a bad idea, but it'll fix the foam gun infinite material exploit
	materials = list(MAT_METAL = 200)
