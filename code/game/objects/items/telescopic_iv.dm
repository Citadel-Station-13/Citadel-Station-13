/obj/item/tele_iv
	name = "telescopic IV drip"
	desc = "An IV drip with an advanced infusion pump that can both drain blood into and inject liquids from attached containers. Blood packs are processed at an accelerated rate. This one is telescopic, and can be picked up and put down."
	icon = 'icons/obj/iv_drip.dmi'
	icon_state = "tele_iv"

/obj/item/tele_iv/attack_self(mob/user)
	deploy_iv(user, user.loc)

/obj/item/tele_iv/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(proximity && isopenturf(target) && user.CanReach(target))
		deploy_iv(user, target)

/obj/item/tele_iv/proc/deploy_iv(mob/user, atom/location)
	new /obj/machinery/iv_drip/telescopic(location)
	qdel(src)
