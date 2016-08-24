
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

/obj/item/organ/penis
	name = "penis"
	icon_state = "penis"
	zone = "groin"
	slot = "penis"
	w_class = 3
	var/shape = "human"
	var/size = "normal"
	var/testicles

/obj/item/organ/testicles
	name = "testicles"
	icon_state = "testicles"
	zone = "groin"
	slot = "testicles"
	w_class = 3
	var/size = "normal"

/obj/item/organ/vagina
	name = "vagina"
	icon_state = "vagina"
	zone = "groin"
	slot = "vagina"
	w_class = 3
	var/shape = "human"
	var/ovaries

/obj/item/organ/womb
	name = "womb"
	icon_state = "womb"
	zone = "groin"
	slot = "womb"
	w_class = 3

