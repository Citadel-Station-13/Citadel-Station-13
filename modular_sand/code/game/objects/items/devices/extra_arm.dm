/obj/item/extra_arm
	name = "extra arm installer"
	desc = "Distantly related to the technology of the Man-Machine Interface, this state-of-the-art syndicate device adapts your nervous and circulatory system to the presence of an extra limb..."
	icon = 'modular_sand/icons/obj/device.dmi'
	icon_state = "extra_arm"
	var/used = FALSE

/obj/item/extra_arm/attack_self(mob/living/carbon/M)
	if(!used)
		var/limbs = M.held_items.len
		M.change_number_of_hands(limbs+1)
		used = TRUE
		icon_state = "extra_arm_none"
		M.visible_message("<span class='notice'>[M] presses a button on [src], and you hear a disgusting noise.</span>", "<span class='notice'>You feel a sharp sting as [src] plunges into your body.</span>")
		to_chat(M, "<span class='notice'>You feel more dexterous.</span>")
		playsound(get_turf(M), 'sound/misc/splort.ogg', 50, 1)
		desc += "Looks like it's been used up."
