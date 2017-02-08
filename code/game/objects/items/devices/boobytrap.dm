/obj/item/device/boobytrap
	name = "booby trap"
	desc = null //Different examine for traitors
	item_state = "electronic"
	icon_state = "boobytrap"
	w_class = 1
	throw_range = 4
	throw_speed = 1
	flags = NOBLUDGEON
	force = 3
	attack_verb = list("trapped", "rused", "tricked")
	materials = list(MAT_METAL=50, MAT_GLASS=30)
	origin_tech = "syndicate=1;combat=3;engineering=3"

/obj/item/device/boobytrap/proc/blow()
	explosion(src.loc,0,0,2,4,flame_range = 4)
	qdel(src)

/obj/item/device/boobytrap/examine(mob/user)
	..()
	if(user.mind in ticker.mode.traitors) //No nuke ops because the device is excluded from nuclear
		user << "A small device used to rig lockers and boxes with an explosive surprise. \
		To use, simply attach it to a box or a locker."
	else
		user << "A suspicious array of delicate wires and parts."
