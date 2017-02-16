/obj/item/organ/genital/breasts
	name = "breasts"
	desc = "Female milk producing organs."
	icon_state = "breasts"
	icon = 'code/citadel/icons/breasts.dmi'
	zone = "chest"
	slot = "breasts"
	w_class = 3
	var/internal = FALSE
	var/size 				= BREASTS_SIZE_DEF
	var/milk_mult 			= MILK_RATE_MULT
	var/milk_rate 			= MILK_RATE
	var/milk_efficiency		= MILK_EFFICIENCY
	var/milk_id 			= "milk"
	var/milk_volume			= (BREASTS_SIZE_C * BREASTS_VOLUME_BASE)
	var/producing			= TRUE
