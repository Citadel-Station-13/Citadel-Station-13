/obj/item/organ/genital/womb
	name 			= "womb"
	desc 			= "A female reproductive organ."
	icon			= 'code/citadel/icons/vagina.dmi'
	icon_state 		= "womb"
	zone 			= "groin"
	slot 			= "womb"
	w_class 		= 3
	fluid_id 		= "femcum"
	var/obj/item/organ/genital/vagina/linked_vag

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