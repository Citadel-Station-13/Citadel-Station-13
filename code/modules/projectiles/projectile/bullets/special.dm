// Honker

/obj/item/projectile/bullet/honker
	damage = 0
	knockdown = 60
	movement_type = FLYING | UNSTOPPABLE
	nodamage = TRUE
	candink = FALSE
	hitsound = 'sound/items/bikehorn.ogg'
	icon = 'icons/obj/hydroponics/harvest.dmi'
	icon_state = "banana"
	range = 200

/obj/item/projectile/bullet/honker/Initialize()
	. = ..()
	SpinAnimation()

// Mime

/obj/item/projectile/bullet/mime
	damage = 20

/obj/item/projectile/bullet/mime/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		M.silent = max(M.silent, 10)

//flechette

/obj/item/projectile/bullet/cflechetteap	//shreds armor
	name = "flechette (armor piercing)"
	damage = 8
	armour_penetration = 80

/obj/item/projectile/bullet/cflechettes		//shreds flesh and forces bleeding
	name = "flechette (serrated)"
	damage = 15
	dismemberment = 10
	armour_penetration = -80

/obj/item/projectile/bullet/cflechettes/on_hit(atom/target, blocked = FALSE)
	if((blocked != 100) && iscarbon(target))
		var/mob/living/carbon/C = target
		C.bleed(10)
	return ..()

/obj/item/projectile/bullet/cflechetteshredder
	name = "flechette (shredder)"
	damage = 5
	dismemberment = 40

//spinfusor

/obj/item/projectile/bullet/spinfusor
	name ="spinfusor disk"
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state= "spinner"
	damage = 30

/obj/item/projectile/bullet/spinfusor/on_hit(atom/target, blocked = FALSE) //explosion to emulate the spinfusor's AOE
	..()
	explosion(target, -1, -1, 2, 0, -1)
	return BULLET_ACT_HIT