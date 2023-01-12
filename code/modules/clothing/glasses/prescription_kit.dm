// don't you love single purpose files? i do too.

/obj/item/prescription_kit
	name = "prescription lens kit"
	desc = "A disposable kit containing all the needed tools and parts to develop and apply a self-modifying prescription lens overlay device to any eyewear. \
	Insert eyewear, receive vision-correcting lenses."
	icon = 'icons/obj/device.dmi'
	icon_state = "modkit"

/obj/item/prescription_kit/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/clothing/glasses) && I.Adjacent(user))
		var/obj/item/clothing/glasses/target_glasses = I
		if(target_glasses.vision_correction)
			to_chat(user, span_notice("These are already fitted with prescription lenses or otherwise already correct vision!"))
			return
		playsound(src, 'sound/items/screwdriver.ogg', 50, 1)
		user.visible_message(span_notice("[user] fits \the [target_glasses] with a prescription overlay device."), span_notice("You fit \the [target_glasses] with a prescription overlay device."))
		target_glasses.prescribe()
		target_glasses.balloon_alert(user, "prescription fitted!")
		qdel(src)
	else
		return ..()
