/*		2077 WARCRIMES ARE NOW LEGAL
//
//	Includes:-
//		1) Tennis Launcher, lines 10 - 130
//		2) Frisbee Launcher, lines 134 - 251
//
//
*/

/obj/item/gun/ballistic/automatic/tennislauncher
	name = "tennis ball launcher"
	desc = "A pump-action tennis ball launcher. Put the ball in, pull the pump, and push. Simple torture to dogs, and fun for the shooter. Can hold two extra balls under the barrel for extended lengths of torture."
	icon = 'icons/obj/fluff_items.dmi'
	icon_state = "tennislauncher"
	item_state = "tennislauncher"
	w_class = WEIGHT_CLASS_BULKY
	force = 10
	can_suppress = FALSE
	mag_type = /obj/item/ammo_box/magazine/internal/tennislauncher
	fire_sound = 'sound/weapons/grenadelaunch.ogg'
	burst_size = 1
	fire_delay = 1
	select = 0
	actions_types = list()
	casing_ejector = FALSE

/obj/item/gun/ballistic/automatic/tennislauncher/update_icon()
	return

/obj/item/gun/ballistic/automatic/tennislauncher/attack_self()
	return

/obj/item/gun/ballistic/automatic/tennislauncher/attackby(obj/item/A, mob/user, params)
	var/num_loaded = magazine.attackby(A, user, params, 1)
	if(num_loaded)
		to_chat(user, "<span class='notice'>You load [num_loaded] ball\s into \the [src].</span>")
		update_icon()
		chamber_round()

/obj/item/ammo_box/magazine/internal/tennislauncher
	name = "tennis ball launcher internal magazine"
	ammo_type = list(/obj/item/ammo_casing/caseless/tennis, /obj/item/ammo_casing/caseless/tennis/red, /obj/item/ammo_casing/caseless/tennis/yellow, /obj/item/ammo_casing/caseless/tennis/green, /obj/item/ammo_casing/caseless/tennis/cyan, /obj/item/ammo_casing/caseless/tennis/blue, /obj/item/ammo_casing/caseless/tennis/purple, /obj/item/ammo_casing/caseless/tennis/rainbow, /obj/item/ammo_casing/caseless/tennis/rainbow/izzy, /obj/item/ammo_casing/caseless/tennis/death)
	caliber = "ball"
	max_ammo = 2

/obj/item/projectile/bullet/reusable/ball/classic
	name = "tennis ball"
	desc = "BALL!"
	icon = 'icons/obj/fluff_items.dmi'
	icon_state = "tennis_classic"
	damage = 0
	ammo_type = /obj/item/ammo_casing/caseless/tennis

/obj/item/projectile/bullet/reusable/ball/red
	name = "tennis ball"
	desc = "BALL!"
	icon = 'icons/obj/fluff_items.dmi'
	icon_state = "tennis_red"
	damage = 0
	ammo_type = /obj/item/ammo_casing/caseless/tennis/red

/obj/item/projectile/bullet/reusable/ball/yellow
	name = "tennis ball"
	desc = "BALL!"
	icon = 'icons/obj/fluff_items.dmi'
	icon_state = "tennis_yellow"
	damage = 0
	ammo_type = /obj/item/ammo_casing/caseless/tennis/yellow

/obj/item/projectile/bullet/reusable/ball/green
	name = "tennis ball"
	desc = "BALL!"
	icon = 'icons/obj/fluff_items.dmi'
	icon_state = "tennis_green"
	damage = 0
	ammo_type = /obj/item/ammo_casing/caseless/tennis/green

/obj/item/projectile/bullet/reusable/ball/cyan
	name = "tennis ball"
	desc = "BALL!"
	icon = 'icons/obj/fluff_items.dmi'
	icon_state = "tennis_cyan"
	damage = 0
	ammo_type = /obj/item/ammo_casing/caseless/tennis/cyan

/obj/item/projectile/bullet/reusable/ball/blue
	name = "tennis ball"
	desc = "BALL!"
	icon = 'icons/obj/fluff_items.dmi'
	icon_state = "tennis_blue"
	damage = 0
	ammo_type = /obj/item/ammo_casing/caseless/tennis/blue

/obj/item/projectile/bullet/reusable/ball/purple
	name = "tennis ball"
	desc = "BALL!"
	icon = 'icons/obj/fluff_items.dmi'
	icon_state = "tennis_purple"
	damage = 0
	ammo_type = /obj/item/ammo_casing/caseless/tennis/purple

/obj/item/projectile/bullet/reusable/ball/rainbow
	name = "tennis ball"
	desc = "BALL!"
	icon = 'icons/obj/fluff_items.dmi'
	icon_state = "tennis_rainbow"
	damage = 0
	ammo_type = /obj/item/ammo_casing/caseless/tennis/rainbow

/obj/item/projectile/bullet/reusable/ball/izzy
	name = "tennis ball"
	desc = "BALL!"
	icon = 'icons/obj/fluff_items.dmi'
	icon_state = "tennis_izzy"
	damage = 0
	ammo_type = /obj/item/ammo_casing/caseless/tennis/rainbow/izzy

/obj/item/projectile/bullet/reusable/ball/death
	name = "tennis ball"
	desc = "BOMB!"
	icon = 'icons/obj/fluff_items.dmi'
	icon_state = "tennis_death"
	damage = 200
	armour_penetration = 100
	dismemberment = 100
	ricochets_max = 0

/obj/item/projectile/bullet/reusable/ball/death/on_hit(atom/target, blocked = FALSE)
	..()
	explosion(target, -1, 1, 3, 1, 0, flame_range = 4)

//Frisbee Launcher

/obj/item/gun/ballistic/automatic/frisbeelauncher
	name = "frisbee launcher"
	desc = "Also known as the shredder, as of the origins of this thing were intially made to slice people in half, on the go. Now it's used to launch frisbees because your lazy ass can't throw one."
	icon = 'icons/obj/fluff_items.dmi'
	icon_state = "frisbeelauncher"
	item_state = "frisbeelauncher"
	w_class = WEIGHT_CLASS_BULKY
	force = 10
	can_suppress = FALSE
	mag_type = /obj/item/ammo_box/magazine/internal/frisbeelauncher
	fire_sound = 'sound/weapons/grenadelaunch.ogg'
	burst_size = 1
	fire_delay = 1
	select = 0
	actions_types = list()
	casing_ejector = FALSE

/obj/item/gun/ballistic/automatic/frisbeelauncher/update_icon()
	return

/obj/item/gun/ballistic/automatic/frisbeelauncher/attack_self()
	return

/obj/item/gun/ballistic/automatic/frisbeelauncher/attackby(obj/item/A, mob/user, params)
	var/num_loaded = magazine.attackby(A, user, params, 1)
	if(num_loaded)
		to_chat(user, "<span class='notice'>You load [num_loaded] frisbee\s into \the [src].</span>")
		update_icon()
		chamber_round()

/obj/item/ammo_box/magazine/internal/frisbeelauncher
	name = "frisbee launcher internal magazine"
	ammo_type = list(/obj/item/ammo_casing/caseless/frisbee, /obj/item/ammo_casing/caseless/frisbee/red, /obj/item/ammo_casing/caseless/frisbee/yellow, /obj/item/ammo_casing/caseless/frisbee/green, /obj/item/ammo_casing/caseless/frisbee/cyan, /obj/item/ammo_casing/caseless/frisbee/blue, /obj/item/ammo_casing/caseless/frisbee/purple, /obj/item/ammo_casing/caseless/frisbee/rainbow, /obj/item/ammo_casing/caseless/frisbee/white, /obj/item/ammo_casing/caseless/frisbee/death)
	caliber = "frisbee"
	max_ammo = 2

/obj/item/projectile/bullet/reusable/frisbee/classic
	name = "frisbee"
	desc = "Catch!"
	icon = 'icons/obj/fluff_items.dmi'
	icon_state = "frisbee_classic"
	damage = 0
	ammo_type = /obj/item/ammo_casing/caseless/frisbee

/obj/item/projectile/bullet/reusable/frisbee/red
	name = "frisbee"
	desc = "Catch!"
	icon = 'icons/obj/fluff_items.dmi'
	icon_state = "frisbee_red"
	damage = 0
	ammo_type = /obj/item/ammo_casing/caseless/frisbee/red

/obj/item/projectile/bullet/reusable/frisbee/yellow
	name = "frisbee"
	desc = "Catch!"
	icon = 'icons/obj/fluff_items.dmi'
	icon_state = "frisbee_yellow"
	damage = 0
	ammo_type = /obj/item/ammo_casing/caseless/frisbee/yellow

/obj/item/projectile/bullet/reusable/frisbee/green
	name = "frisbee"
	desc = "Catch!"
	icon = 'icons/obj/fluff_items.dmi'
	icon_state = "frisbee_green"
	damage = 0
	ammo_type = /obj/item/ammo_casing/caseless/frisbee/green

/obj/item/projectile/bullet/reusable/frisbee/cyan
	name = "frisbee"
	desc = "Catch!"
	icon = 'icons/obj/fluff_items.dmi'
	icon_state = "frisbee_cyan"
	damage = 0
	ammo_type = /obj/item/ammo_casing/caseless/frisbee/cyan

/obj/item/projectile/bullet/reusable/frisbee/blue
	name = "frisbee"
	desc = "Catch!"
	icon = 'icons/obj/fluff_items.dmi'
	icon_state = "frisbee_blue"
	damage = 0
	ammo_type = /obj/item/ammo_casing/caseless/frisbee/blue

/obj/item/projectile/bullet/reusable/frisbee/purple
	name = "frisbee"
	desc = "Catch!"
	icon = 'icons/obj/fluff_items.dmi'
	icon_state = "frisbee_purple"
	damage = 0
	ammo_type = /obj/item/ammo_casing/caseless/frisbee/purple

/obj/item/projectile/bullet/reusable/frisbee/white
	name = "frisbee"
	desc = "Catch!"
	icon = 'icons/obj/fluff_items.dmi'
	icon_state = "frisbee_white"
	damage = 0
	ammo_type = /obj/item/ammo_casing/caseless/frisbee/white

/obj/item/projectile/bullet/reusable/frisbee/rainbow
	name = "frisbee"
	desc = "Catch!"
	icon = 'icons/obj/fluff_items.dmi'
	icon_state = "frisbee_rainbow"
	damage = 0
	ammo_type = /obj/item/ammo_casing/caseless/frisbee/rainbow

/obj/item/projectile/bullet/reusable/frisbee/death
	name = "frisbee"
	desc = "Catch! WAIT NO DON'T CATCH!"
	icon = 'icons/obj/fluff_items.dmi'
	icon_state = "frisbee_death"
	ammo_type = /obj/item/ammo_casing/caseless/frisbee/death
	damage = 50
	armour_penetration = 100
	dismemberment = 200
	ricochets_max = 0