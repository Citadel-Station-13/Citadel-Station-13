/obj/item/organ/genital/womb
	name 			= "womb"
	desc 			= "A female reproductive organ."
	icon			= 'modular_citadel/icons/obj/genitals/vagina.dmi'
	icon_state 		= "womb"
	zone 			= "groin"
	slot 			= "womb"
	internal 		= TRUE
	fluid_id 		= "femcum"
	producing		= TRUE

/obj/item/organ/genital/womb/on_life()
	if(QDELETED(src))
		return
	if(reagents && producing)
		if(reagents.total_volume == 0) // Apparently, 0.015 gets rounded down to zero and no reagents are created if we don't start it with 0.1 in the tank.
			fluid_rate = 0.1
		else
			fluid_rate = CUM_RATE
		if(reagents.total_volume >= 5)
			fluid_mult = 0.5
		else
			fluid_mult = 1
		generate_femcum()

/obj/item/organ/genital/womb/proc/generate_femcum()
	reagents.maximum_volume = fluid_max_volume
	update_link()
	if(!linked_organ)
		return FALSE
	reagents.isolate_reagent(fluid_id)//remove old reagents if it changed and just clean up generally
	reagents.add_reagent(fluid_id, (fluid_mult * fluid_rate))//generate the cum

/obj/item/organ/genital/womb/update_link()
	if(owner)
		linked_organ = (owner.getorganslot("vagina"))
		if(linked_organ)
			linked_organ.linked_organ = src
	else
		if(linked_organ)
			linked_organ.linked_organ = null
		linked_organ = null

/obj/item/organ/genital/womb/Destroy()
	return ..()
