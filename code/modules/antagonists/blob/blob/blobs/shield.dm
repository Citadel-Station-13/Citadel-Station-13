/obj/structure/blob/shield
	name = "strong blob"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_shield"
	desc = "A solid wall of slightly twitching tendrils."
	var/damaged_desc = "A wall of twitching tendrils."
	max_integrity = 150
	brute_resist = 0.25
	explosion_block = 3
	point_return = 4
	atmosblock = TRUE
	armor = list("melee" = 25, "bullet" = 25, "laser" = 15, "energy" = 10, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 90, "acid" = 90)
	var/weakened

/obj/structure/blob/shield/scannerreport()
	if(atmosblock)
		return "Will prevent the spread of atmospheric changes."
	return "N/A"

/obj/structure/blob/shield/core
	point_return = 0

/obj/structure/blob/shield/update_icon()
	..()
	if(obj_integrity < max_integrity * 0.5)
		icon_state = "[initial(icon_state)]_damaged"
		name = "weakened [initial(name)]"
		desc = "[damaged_desc]"
		atmosblock = FALSE
		if(!weakened)
			armor = armor.setRating("melee" = 15, "bullet" = 15, "laser" = 5, "energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 90, "acid" = 90)
			weakened = TRUE
	else
		icon_state = initial(icon_state)
		name = initial(name)
		desc = initial(desc)
		atmosblock = TRUE
		if(weakened)
			armor = armor.setRating("melee" = 25, "bullet" = 25, "laser" = 15, "energy" = 10, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 90, "acid" = 90)
			weakened = FALSE
	air_update_turf(1)

/obj/structure/blob/shield/reflective
	name = "reflective blob"
	desc = "A solid wall of slightly twitching tendrils with a reflective glow."
	damaged_desc = "A wall of twitching tendrils with a reflective glow."
	icon_state = "blob_glow"
	flags_ricochet = RICOCHET_SHINY
	point_return = 8
	max_integrity = 100
	brute_resist = 1
	explosion_block = 2
