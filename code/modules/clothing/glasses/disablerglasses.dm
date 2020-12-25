/obj/item/clothing/glasses/hud/security/sunglasses/disablers
	name = "true stunglasses"
	desc = "Made for only the best of shitsec. Wear 'em like you're gonna robust all of those fuckers."
	var/beamtype = /obj/item/projectile/beam/disabler //change for adminbus

/obj/item/clothing/glasses/hud/security/sunglasses/disablers/ranged_attack(mob/living/carbon/human/user,atom/A, params)
	if(!user.CheckActionCooldown(CLICK_CD_RANGE))
		return
	user.last_action = world.time
	var/obj/item/projectile/beam/disabler/LE = new beamtype( loc )
	playsound(usr.loc, 'sound/weapons/taser2.ogg', 75, 1)
	LE.firer = src
	LE.def_zone = user.get_organ_target()
	LE.preparePixelProjectile(A, src, params)
	LE.fire()
	return TRUE
	//shamelessly copied
