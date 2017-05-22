/obj/item/organ/genital/womb
	name 			= "womb"
	desc 			= "A female reproductive organ."
	icon			= 'code/citadel/icons/vagina.dmi'
	icon_state 		= "womb"
	zone 			= "groin"
	slot 			= "womb"
	w_class 		= 3
	var/internal 	= FALSE
	fluid_id 		= "femcum"
	producing		= TRUE
	var/obj/item/organ/genital/vagina/linked_vag
	
/obj/item/organ/genital/womb/Initialize()
	. = ..()
	reagents.add_reagent(fluid_id, fluid_max_volume)

/obj/item/organ/genital/womb/on_life()
	if(QDELETED(src))
		return
	if(reagents && producing)
		generate_femcum()

/obj/item/organ/genital/womb/proc/generate_femcum()
	reagents.maximum_volume = fluid_max_volume
	update_link()
	if(!linked_vag)
		return FALSE
	reagents.isolate_reagent(fluid_id)//remove old reagents if it changed and just clean up generally
	reagents.add_reagent(fluid_id, (fluid_mult * fluid_rate))//generate the cum

/obj/item/organ/genital/womb/update_link()
	if(owner)
		linked_vag = (owner.getorganslot("vagina"))
		if(linked_vag)
			linked_vag.linked_womb = src
	else
		if(linked_vag)
			linked_vag.linked_womb = null
		linked_vag = null

/obj/item/organ/genital/womb/remove_ref()
	if(linked_vag)
		linked_vag.linked_womb = null
		linked_vag = null

/obj/item/organ/genital/womb/Destroy()
	return ..()
