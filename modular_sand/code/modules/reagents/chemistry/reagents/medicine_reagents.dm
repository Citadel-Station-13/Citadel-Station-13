/datum/reagent/medicine/mine_salve/on_mob_metabolize(mob/living/M) //modularisation for miners salve painkiller.
	..()
	if(iscarbon(M))
		ADD_TRAIT(M, TRAIT_PAINKILLER, PAINKILLER_MINERSSALVE)
