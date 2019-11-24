//Called when temperature is above a certain threshold, or if purity is too low.
/datum/chemical_reaction/proc/FermiExplode(datum/reagents/R0, var/atom/my_atom, volume, temp, pH, Exploding = FALSE)
	if (Exploding == TRUE)
		return

	switch(FermiExplode)
		if(FERMI_EXPLOSION_TYPE_MIXED)
			FermiExplodeMixed(R0, my_atom, volume, temp, pH, Exploding)
		if(FERMI_EXPLOSION_TYPE_SMOKE)
			FermiExplodeSmoke(R0, my_atom, volume, temp, pH, Exploding)
		if(FERMI_EXPLOSION_TYPE_INVERTSMOKE)
			FermiExplodeInvertSmoke(R0, my_atom, volume, temp, pH, Exploding)

//Produces an explosion based on the properties of the beaker
/datum/chemical_reaction/proc/FermiExplodeMixed(datum/reagents/R0, var/atom/my_atom, volume, temp, pH, Exploding = FALSE)
	if (Exploding == TRUE)
		return
	if(!pH)//Dunno how things got here without a pH, but just in case
		pH = 7
	var/ImpureTot = 0
	var/turf/T = get_turf(my_atom)

	if(temp>500)//if hot, start a fire
		switch(temp)
			if (500 to 750)
				for(var/turf/turf in range(1,T))
					new /obj/effect/hotspot(turf)
				volume*=1.1

			if (751 to 1100)
				for(var/turf/turf in range(2,T))
					new /obj/effect/hotspot(turf)
				volume*=1.2

			if (1101 to 1500) //If you're crafty
				for(var/turf/turf in range(3,T))
					new /obj/effect/hotspot(turf)
				volume*=1.3

			if (1501 to 2500) //requested
				for(var/turf/turf in range(4,T))
					new /obj/effect/hotspot(turf)
				volume*=1.4

			if (2501 to 5000)
				for(var/turf/turf in range(5,T))
					new /obj/effect/hotspot(turf)
				volume*=1.5

			if (5001 to INFINITY)
				for(var/turf/turf in range(6,T))
					new /obj/effect/hotspot(turf)
				volume*=1.6


	message_admins("Fermi explosion at [T], with a temperature of [temp], pH of [pH], Impurity tot of [ImpureTot].")
	log_game("Fermi explosion at [T], with a temperature of [temp], pH of [pH], Impurity tot of [ImpureTot].")
	var/datum/reagents/R = new/datum/reagents(3000)//Hey, just in case.
	var/datum/effect_system/smoke_spread/chem/s = new()
	R.my_atom = my_atom //Give the gas a fingerprint

	for (var/datum/reagent/reagent in R0.reagent_list) //make gas for reagents, has to be done this way, otherwise it never stops Exploding
		R.add_reagent(reagent.id, reagent.volume/3) //Seems fine? I think I fixed the infinite explosion bug.

		if (reagent.purity < 0.6)
			ImpureTot = (ImpureTot + (1-reagent.purity)) / 2

	if(pH < 4) //if acidic, make acid spray
		R.add_reagent("fermiAcid", (volume/3))
	if(R.reagent_list)
		s.set_up(R, (volume/5), my_atom)
		s.start()

	if (pH > 10) //if alkaline, small explosion.
		var/datum/effect_system/reagents_explosion/e = new()
		e.set_up(round((volume/28)*(pH-9)), T, 0, 0)
		e.start()

	if(!ImpureTot == 0) //If impure, v.small emp (0.6 or less)
		ImpureTot *= volume
		var/empVol = CLAMP (volume/10, 0, 15)
		empulse(T, empVol, ImpureTot/10, 1)

	my_atom.reagents.clear_reagents() //just in case
	return

//Spews out the inverse of the chems in the beaker of the products/reactants only
/datum/chemical_reaction/proc/FermiExplodeInvertSmoke(datum/reagents/R0, var/atom/my_atom, volume, temp, pH, Exploding = FALSE)
	var/datum/reagents/R = new/datum/reagents(3000)//Hey, just in case.
	var/datum/effect_system/smoke_spread/chem/s = new()
	R.my_atom = my_atom //Give the gas a fingerprint
	for (var/datum/reagent/reagent in R0.reagent_list) //make gas for reagents, has to be done this way, otherwise it never stops Exploding
		if(!(reagent.id in required_reagents) || !(reagent.id in results))
			continue
		if(reagent.inverse_chem)
			R.add_reagent(reagent.inverse_chem, reagent.volume)
			R0.remove_reagent(reagent.id, reagent.volume)
			continue
		R0.trans_id_to(R, reagent.id, reagent.volume)
	if(R.reagent_list)
		s.set_up(R, (volume/5), my_atom)
		s.start()

	return

//Spews out the contents of the beaker in a smokecloud
/datum/chemical_reaction/proc/FermiExplodeSmoke(datum/reagents/R0, var/atom/my_atom, volume, temp, pH, Exploding = FALSE)
	var/datum/reagents/R = new/datum/reagents(3000)//Hey, just in case.
	var/datum/effect_system/smoke_spread/chem/s = new()
	R.my_atom = my_atom //Give the gas a fingerprint
	for (var/datum/reagent/reagent in R0.reagent_list) //make gas for reagents, has to be done this way, otherwise it never stops Exploding
		if((reagent.id in required_reagents) || (reagent.id in results))
			R0.trans_id_to(R, reagent.id, reagent.volume)
	if(R.reagent_list)
		s.set_up(R, (volume/5), my_atom)
		s.start()
	return
