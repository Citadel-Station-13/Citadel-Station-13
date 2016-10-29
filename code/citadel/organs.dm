//Here are the organs and their subsequent functions that Citadel uses.
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
	icon = 'icons/obj/penis.dmi'
	zone = "groin"
	slot = "penis"
	w_class = 3
	var/shape = "human"
	var/size = 3
	var/obj/item/organ/testicles/balls

/obj/item/organ/ovipositor
	name = "ovipositor"
	icon_state = "ovi_knotted_2"
	icon = 'icons/obj/penis.dmi'
	zone = "groin"
	slot = "penis"
	w_class = 3
	var/shape = "human"
	var/size = 3
	var/obj/item/organ/testicles/balls

/obj/item/organ/testicles
	name = "testicles"
	icon_state = "testicles"
	icon = 'icons/obj/penis.dmi'
	zone = "groin"
	slot = "testicles"
	w_class = 3
	var/internal = FALSE
	var/size = "normal"
	var/cum_mult = DEFAULT_CUM_MULT
	var/cum_rate = DEFAULT_CUM_RATE
	var/cum_id = "semen"

/obj/item/organ/vagina
	name = "vagina"
	icon_state = "vagina"
	zone = "groin"
	slot = "vagina"
	w_class = 3
	var/shape = "human"
	var/obj/item/organ/womb/connected_womb

/obj/item/organ/womb
	name = "womb"
	icon_state = "womb"
	zone = "groin"
	slot = "womb"
	w_class = 3
	var/cum_mult = DEFAULT_CUM_MULT
	var/cum_rate = DEFAULT_CUM_RATE
	var/cum_id = "femcum"
