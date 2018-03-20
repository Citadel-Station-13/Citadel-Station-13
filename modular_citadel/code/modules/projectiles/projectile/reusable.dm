/obj/item/projectile/bullet/reusable/foam_dart/tag
  name = "lastag foam dart"
  var/suit_types = list(/obj/item/clothing/suit/redtag, /obj/item/clothing/suit/bluetag)

/obj/item/projectile/bullet/reusable/foam_dart/tag/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit))
			if(M.wear_suit.type in suit_types)
				M.adjustStaminaLoss(24)

/obj/item/projectile/bullet/reusable/foam_dart/tag/red
	name = "lastag red foam dart"
	color = "#FF0000"
	suit_types = list(/obj/item/clothing/suit/bluetag)
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart/tag/red
/obj/item/projectile/bullet/reusable/foam_dart/tag/blue
	color = "#0000FF"
	name = "lastag blue foam dart"
	suit_types = list(/obj/item/clothing/suit/redtag)
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart/tag/blue

/obj/item/projectile/bullet/reusable/foam_dart/riot
	name = "riot foam dart"
	icon_state = "foamdart_riot_proj"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart/riot/use1
	stamina = 25

/obj/item/projectile/bullet/reusable/foam_dart/riot/use1
	name = "riot foam dart"
	icon_state = "foamdart_riot_proj"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart/riot/use2
	stamina = 20

/obj/item/projectile/bullet/reusable/foam_dart/riot/use2
	name = "riot foam dart"
	icon_state = "foamdart_riot_proj"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart/riot/use3
	stamina = 15

/obj/item/projectile/bullet/reusable/foam_dart/riot/use3
	name = "riot foam dart"
	icon_state = "foamdart_riot_proj"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart/riot/use4
	stamina = 10

/obj/item/projectile/bullet/reusable/foam_dart/riot/use4
	name = "riot foam dart"
	icon_state = "foamdart_riot_proj"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart
	stamina = 5
