/obj/item/projectile/bullet/reusable/foam_dart
	name = "foam dart"
	desc = "I hope you're wearing eye protection."
	damage = 0 // It's a damn toy.
	damage_type = OXY
	nodamage = TRUE
	icon = 'icons/obj/guns/toy.dmi'
	icon_state = "foamdart_proj"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart
	range = 10
	var/modified = FALSE
	var/obj/item/pen/pen = null

/obj/item/projectile/bullet/reusable/foam_dart/handle_drop()
	if(dropped)
		return
	var/turf/T = get_turf(src)
	dropped = 1
	var/obj/item/ammo_casing/caseless/foam_dart/newcasing = new ammo_type(T)
	newcasing.modified = modified
	var/obj/item/projectile/bullet/reusable/foam_dart/newdart = newcasing.BB
	newdart.modified = modified
	newdart.damage = damage
	newdart.nodamage = nodamage
	newdart.damage_type = damage_type
	if(pen)
		newdart.pen = pen
		pen.forceMove(newdart)
		pen = null
	newdart.update_icon()


/obj/item/projectile/bullet/reusable/foam_dart/Destroy()
	pen = null
	return ..()

/obj/item/projectile/bullet/reusable/foam_dart/riot
	name = "riot foam dart"
	icon_state = "foamdart_riot_proj"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart/riot
	stamina = 25

/obj/item/projectile/bullet/reusable/foam_dart/mag
	name = "magfoam dart"
	icon_state = "magjectile-toy"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart/mag
	light_range = 2
	light_color = LIGHT_COLOR_YELLOW

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
