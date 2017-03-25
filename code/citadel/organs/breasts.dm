/obj/item/organ/genital/breasts
	name 					= "breasts"
	desc 					= "Female milk producing organs."
	icon_state 				= "breasts"
	icon 					= 'code/citadel/icons/breasts.dmi'
	zone 					= "chest"
	slot 					= "breasts"
	w_class 				= 3
	size 					= "e"
	fluid_id				= "milk"
	var/cup_size			= BREASTS_SIZE_DEF
	var/amount				= 2
	producing				= TRUE

/obj/item/organ/genital/breasts/Initialize()
	..()
	reagents.add_reagent(fluid_id, fluid_max_volume)
	update()

/obj/item/organ/genital/breasts/on_life()
	if(!reagents || !owner)
		return
	reagents.maximum_volume = fluid_max_volume
	if(fluid_id && producing)
		generate_milk()

/obj/item/organ/genital/breasts/proc/generate_milk()
	if(!owner)
		return FALSE
	if(owner.stat == DEAD)
		return FALSE
	reagents.isolate_reagent(fluid_id)
	reagents.add_reagent(fluid_id, (fluid_mult * fluid_rate))
