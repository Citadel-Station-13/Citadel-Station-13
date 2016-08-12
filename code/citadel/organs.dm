
/obj/item/organ/stomach
	name = "stomach"
	icon_state = "stomach"
	zone = "chest"
	slot = "stomach"
	w_class = 3

/obj/item/organ/stomach/prepare_eat()
	var/obj/S = ..()
	S.reagents.add_reagent("sacid", 2)
	return S