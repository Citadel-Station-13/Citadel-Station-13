/obj/item/organ/genital/testicles
	name = "testicles"
	desc = "A male reproductive organ."
	icon_state = "testicles"
	icon = 'code/citadel/icons/penis.dmi'
	zone = "groin"
	slot = "testicles"
	w_class = 3
	var/internal = FALSE
	var/size 				= BALLS_SIZE_DEF
	var/sack_size			= BALLS_SACK_SIZE_DEF
	var/cum_mult 			= CUM_RATE_MULT
	var/cum_rate 			= CUM_RATE
	var/cum_efficiency		= CUM_EFFICIENCY
	var/cum_id 				= "semen"
	var/balls_volume		= BALLS_VOLUME_BASE
	var/producing			= TRUE
	var/obj/item/organ/genital/penis/linked_penis

/obj/item/organ/genital/testicles/New()
	..()
	create_reagents(balls_volume)

/obj/item/organ/genital/testicles/on_life()
	..()

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
	reagents.maximum_volume = balls_volume//update this before modifying values
	for(var/r in reagents.reagent_list)
		var/datum/reagent/R = r
		if(R.id != src.cum_id)
			src.reagents.del_reagent(R.id)//delete reagents in the balls which are not the correct type.
	if(reagents.total_volume < balls_volume)
		reagents.add_reagent(cum_id, (cum_mult * cum_rate))//generate the cum
		owner.nutrition = (owner.nutrition - cum_efficiency)//use some nutrition from the mob that's using it
	if(reagents.total_volume > reagents.maximum_volume)
		reagents.remove_reagent(cum_id, (reagents.total_volume - reagents.maximum_volume))//if we went over the limit, fixit fixit fixit