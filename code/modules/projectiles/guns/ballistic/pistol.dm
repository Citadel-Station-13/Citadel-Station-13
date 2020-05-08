/obj/item/gun/ballistic/automatic/pistol
	name = "stechkin pistol"
	desc = "A small, easily concealable 10mm handgun. Has a threaded barrel for suppressors."
	icon_state = "pistol"
	w_class = WEIGHT_CLASS_SMALL
	mag_type = /obj/item/ammo_box/magazine/m10mm
	can_suppress = TRUE
	burst_size = 1
	fire_delay = 0
	actions_types = list()

/obj/item/gun/ballistic/automatic/pistol/no_mag
	spawnwithmagazine = FALSE

/obj/item/gun/ballistic/automatic/pistol/update_icon()
	..()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"][suppressed ? "-suppressed" : ""]"

/obj/item/gun/ballistic/automatic/pistol/suppressed/Initialize(mapload)
	. = ..()
	var/obj/item/suppressor/S = new(src)
	install_suppressor(S)

//(reskinnable stetchkin)
/obj/item/gun/ballistic/automatic/pistol/modular
	name = "modular pistol"
	desc = "A small, easily concealable 10mm handgun. Has a threaded barrel for suppressors."
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "cde"
	can_unsuppress = TRUE
	obj_flags = UNIQUE_RENAME
	unique_reskin = list("Default" = "cde",
						"N-99" = "n99",
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

/obj/item/gun/ballistic/automatic/pistol/m1911
	name = "\improper M1911"
	desc = "A classic .45 handgun with a small magazine capacity."
	icon_state = "m1911"
	w_class = WEIGHT_CLASS_NORMAL
	mag_type = /obj/item/ammo_box/magazine/m45
	can_suppress = FALSE

/obj/item/gun/ballistic/automatic/pistol/m1911/no_mag
	spawnwithmagazine = FALSE

/obj/item/gun/ballistic/automatic/pistol/m1911/kitchengun
	name = "\improper Kitchen Gun (TM)"
	desc = "Say goodbye to dirt with Kitchen Gun (TM)! Laser sight and night vision accessories sold separately."
	icon_state = "kitchengun"
	mag_type = /obj/item/ammo_box/magazine/m45/kitchengun

/obj/item/gun/ballistic/automatic/pistol/deagle
	name = "\improper Desert Eagle"
	desc = "A robust .50 AE handgun."
	icon_state = "deagle"
	force = 14
	mag_type = /obj/item/ammo_box/magazine/m50
	can_suppress = FALSE

/obj/item/gun/ballistic/automatic/pistol/deagle/update_icon()
	..()
	if(magazine)
		cut_overlays()
		add_overlay("deagle_magazine")
	else
		cut_overlays()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"]"

/obj/item/gun/ballistic/automatic/pistol/deagle/gold
	desc = "A gold plated Desert Eagle folded over a million times by superior martian gunsmiths. Uses .50 AE ammo."
	icon_state = "deagleg"
	item_state = "deagleg"

/obj/item/gun/ballistic/automatic/pistol/deagle/camo
	desc = "A Deagle brand Deagle for operators operating operationally. Uses .50 AE ammo."
	icon_state = "deaglecamo"
	item_state = "deagleg"

/obj/item/gun/ballistic/automatic/pistol/APS
	name = "stechkin APS pistol"
	desc = "The original Russian version of a widely used Syndicate sidearm. Uses 9mm ammo."
	icon_state = "aps"
	w_class = WEIGHT_CLASS_SMALL
	mag_type = /obj/item/ammo_box/magazine/pistolm9mm
	can_suppress = FALSE
	burst_size = 3
	fire_delay = 2
	actions_types = list(/datum/action/item_action/toggle_firemode)

/obj/item/gun/ballistic/automatic/pistol/stickman
	name = "flat gun"
	desc = "A 2 dimensional gun.. what?"
	can_suppress = FALSE
	icon_state = "flatgun"

/obj/item/gun/ballistic/automatic/pistol/stickman/pickup(mob/living/user)
	to_chat(user, "<span class='notice'>As you try to pick up [src], it slips out of your grip..</span>")
	if(prob(50))
		to_chat(user, "<span class='notice'>..and vanishes from your vision! Where the hell did it go?</span>")
		qdel(src)
		user.update_icons()
	else
		to_chat(user, "<span class='notice'>..and falls into view. Whew, that was a close one.</span>")
		user.dropItemToGround(src)

////////////Anti Tank Pistol////////////

/obj/item/gun/ballistic/automatic/pistol/antitank
	name = "Anti Tank Pistol"
	desc = "A massively impractical and silly monstrosity of a pistol that fires .50 calliber rounds. The recoil is likely to dislocate your wrist."
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
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
	pin = /obj/item/firing_pin/implant/pindicate
