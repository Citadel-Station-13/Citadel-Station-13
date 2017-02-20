/obj/item/organ/genital/testicles
	name = "testicles"
	desc = "A male reproductive organ."
	icon_state = "testicles"
	icon = 'code/citadel/icons/penis.dmi'
	zone = "groin"
	slot = "testicles"
	w_class = 3
	var/internal = FALSE
	size 				= BALLS_SIZE_DEF
	var/sack_size			= BALLS_SACK_SIZE_DEF
	fluid_id 				= "semen"
	producing			= TRUE
	var/obj/item/organ/genital/penis/linked_penis

/obj/item/organ/genital/testicles/New()
	..()
	create_reagents(fluid_max_volume)
	reagents.add_reagent(fluid_id, fluid_max_volume)

/obj/item/organ/genital/testicles/on_life()
	..()
	if(fluid_id)
		generate_cum()

/obj/item/organ/genital/testicles/proc/generate_cum()
	if(!owner && linked_penis)
		if(linked_penis.linked_balls == src)
			linked_penis.linked_balls = null
		linked_penis = null
		return FALSE
	if(!reagents)
		return FALSE
	if(!linked_penis)
		if(istype(owner.getorganslot("penis"), /obj/item/organ/genital/penis))
			owner.getorganslot("penis")
	reagents.maximum_volume = fluid_max_volume//update this before modifying values
	reagents.isolate_reagent(fluid_id)
	if(reagents.total_volume < fluid_max_volume)
		reagents.add_reagent(fluid_id, (fluid_mult * fluid_rate))//generate the cum
		owner.nutrition = (owner.nutrition - fluid_efficiency)//use some nutrition from the mob that's using it
	if(reagents.total_volume > reagents.maximum_volume)
		reagents.remove_reagent(fluid_id, (reagents.total_volume - reagents.maximum_volume))//if we went over the limit, fixit fixit fixit