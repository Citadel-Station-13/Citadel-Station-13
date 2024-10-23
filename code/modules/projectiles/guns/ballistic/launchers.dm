//KEEP IN MIND: These are different from gun/grenadelauncher. These are designed to shoot premade rocket and grenade projectiles, not flashbangs or chemistry casings etc.
//Put handheld rocket launchers here if someone ever decides to make something so hilarious ~Paprika

/obj/item/gun/ballistic/revolver/grenadelauncher//this is only used for underbarrel grenade launchers at the moment, but admins can still spawn it if they feel like being assholes
	desc = "A break-operated grenade launcher."
	name = "grenade launcher"
	icon_state = "dshotgun-sawn"
	item_state = "gun"
	inaccuracy_modifier = 0.5
	mag_type = /obj/item/ammo_box/magazine/internal/grenadelauncher
	fire_sound = 'sound/weapons/grenadelaunch.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	pin = /obj/item/firing_pin/implant/pindicate

/obj/item/gun/ballistic/revolver/grenadelauncher/unrestricted
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/revolver/grenadelauncher/attackby(obj/item/A, mob/user, params)
	..()
	if(istype(A, /obj/item/ammo_box) || istype(A, /obj/item/ammo_casing))
		chamber_round()

/obj/item/gun/ballistic/revolver/grenadelauncher/cyborg
	desc = "A 6-shot grenade launcher."
	name = "multi grenade launcher"
	icon = 'icons/mecha/mecha_equipment.dmi'
	icon_state = "mecha_grenadelnchr"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/grenademulti
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/revolver/grenadelauncher/cyborg/attack_self()
	return

/obj/item/gun/ballistic/automatic/gyropistol
	name = "gyrojet pistol"
	desc = "A prototype pistol designed to fire self propelled rockets."
	icon_state = "gyropistol"
	fire_sound = 'sound/weapons/rocketlaunch.ogg'
	mag_type = /obj/item/ammo_box/magazine/m75
	burst_size = 1
	fire_delay = 0
	fire_select_modes = list(SELECT_SEMI_AUTOMATIC)
	casing_ejector = FALSE
	automatic_burst_overlay = FALSE

/obj/item/gun/ballistic/automatic/gyropistol/update_icon_state()
	icon_state = "[initial(icon_state)][magazine ? "loaded" : ""]"

/obj/item/gun/ballistic/automatic/speargun
	name = "kinetic speargun"
	desc = "A weapon favored by carp hunters. Fires specialized spears using kinetic energy."
	icon_state = "speargun"
	item_state = "speargun"
	w_class = WEIGHT_CLASS_BULKY
	force = 10
	can_suppress = FALSE
	automatic_burst_overlay = FALSE
	mag_type = /obj/item/ammo_box/magazine/internal/speargun
	fire_sound = 'sound/weapons/grenadelaunch.ogg'
	burst_size = 1
	fire_delay = 0
	select = 0
	actions_types = list()
	casing_ejector = FALSE

/obj/item/gun/ballistic/automatic/speargun/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_blocker)

/obj/item/gun/ballistic/automatic/speargun/attack_self()
	return

/obj/item/gun/ballistic/automatic/speargun/attackby(obj/item/A, mob/user, params)
	var/num_loaded = magazine.attackby(A, user, params, 1)
	if(num_loaded)
		to_chat(user, "<span class='notice'>You load [num_loaded] spear\s into \the [src].</span>")
		update_icon()
		chamber_round()

/obj/item/gun/ballistic/rocketlauncher
	name = "\improper PML-9"
	desc = "A reusable rocket propelled grenade launcher. The words \"NT this way\" and an arrow have been written near the barrel."
	icon_state = "rocketlauncher"
	item_state = "rocketlauncher"
	mag_type = /obj/item/ammo_box/magazine/internal/rocketlauncher
	fire_sound = 'sound/weapons/rocketlaunch.ogg'
	w_class = WEIGHT_CLASS_BULKY
	can_suppress = FALSE
	pin = /obj/item/firing_pin/implant/pindicate
	burst_size = 1
	fire_delay = 0
	inaccuracy_modifier = 0.25
	casing_ejector = FALSE
	weapon_weight = WEAPON_HEAVY
	magazine_wording = "rocket"

/obj/item/gun/ballistic/rocketlauncher/unrestricted
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/rocketlauncher/handle_atom_del(atom/A)
	if(A == chambered)
		chambered = null
		if(!QDELETED(magazine))
			QDEL_NULL(magazine)
	if(A == magazine)
		magazine = null
		if(!QDELETED(chambered))
			QDEL_NULL(chambered)
	update_icon()
	return ..()

/obj/item/gun/ballistic/rocketlauncher/can_shoot()
	return chambered?.BB

/obj/item/gun/ballistic/rocketlauncher/attack_self_tk(mob/user)
	return //too difficult to remove the rocket with TK

/obj/item/gun/ballistic/rocketlauncher/attack_self(mob/living/user)
	if(magazine)
		var/obj/item/ammo_casing/AC = chambered
		if(AC)
			if(!user.put_in_hands(AC))
				AC.bounce_away(FALSE, NONE)
			to_chat(user, "<span class='notice'>You remove \the [AC] from \the [src]!</span>")
			playsound(src, 'sound/weapons/gun_magazine_remove_full.ogg', 70, TRUE)
			chambered = null
		else
			to_chat(user, "<span class='notice'>There's no [magazine_wording] in [src].</span>")
	update_icon()

/obj/item/gun/ballistic/rocketlauncher/attackby(obj/item/A, mob/user, params)
	if(magazine && istype(A, /obj/item/ammo_casing))
		if(chambered)
			to_chat(user, "<span class='notice'>[src] already has a [magazine_wording] chambered.</span>")
			return
		if(magazine.attackby(A, user, silent = TRUE))
			to_chat(user, "<span class='notice'>You load a new [A] into \the [src].</span>")
			playsound(src, "gun_insert_full_magazine", 70, 1)
			chamber_round()
			update_icon()

/obj/item/gun/ballistic/rocketlauncher/update_icon_state()
	icon_state = "[initial(icon_state)]-[chambered ? "1" : "0"]"

/obj/item/gun/ballistic/rocketlauncher/suicide_act(mob/living/user)
	user.visible_message("<span class='warning'>[user] aims [src] at the ground! It looks like [user.p_theyre()] performing a sick rocket jump!</span>", \
		"<span class='userdanger'>You aim [src] at the ground to perform a bisnasty rocket jump...</span>")
	if(can_shoot())
		user.mob_transforming = TRUE
		playsound(src, 'sound/vehicles/rocketlaunch.ogg', 80, 1, 5)
		animate(user, pixel_z = 300, time = 30, easing = LINEAR_EASING)
		sleep(70)
		animate(user, pixel_z = 0, time = 5, easing = LINEAR_EASING)
		sleep(5)
		user.mob_transforming = FALSE
		process_fire(user, user, TRUE)
		if(!QDELETED(user)) //if they weren't gibbed by the explosion, take care of them for good.
			user.gib()
		return MANUAL_SUICIDE
	else
		sleep(5)
		shoot_with_empty_chamber(user)
		sleep(20)
		user.visible_message("<span class='warning'>[user] looks about the room realizing [user.p_theyre()] still there. [user.p_they(TRUE)] proceed to shove [src] down their throat and choke [user.p_them()]self with it!</span>", \
			"<span class='userdanger'>You look around after realizing you're still here, then proceed to choke yourself to death with [src]!</span>")
		sleep(20)
		return OXYLOSS
