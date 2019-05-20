//TO TWEAK:

//Called for every reaction step
/datum/chemical_reaction/fermi/proc/FermiCreate(holder) //You can get holder by reagents.holder WHY DID I LEARN THIS NOW???
	return

//Called when reaction STOP_PROCESSING
/datum/chemical_reaction/fermi/proc/FermiFinish(datum/reagents/holder, multipler) //You can get holder by reagents.holder WHY DID I LEARN THIS NOW???
	return

//Called when temperature is above a certain threshold
//....Is this too much?
/datum/chemical_reaction/fermi/proc/FermiExplode(src, var/atom/my_atom, datum/reagents/holder, volume, temp, pH, Reaction, Exploding = FALSE) //You can get holder by reagents.holder WHY DID I LEARN THIS NOW???
	//var/Svol = volume
	if (Exploding == TRUE)
		return
	if(!pH)//Dunno how things got here without a pH.
		pH = 7
	var/ImpureTot = 0
	var/pHmod = 1
	var/turf/T = get_turf(my_atom)
	if(temp>600)//if hot, start a fire
		switch(temp)
			if (601 to 800)
				for(var/turf/turf in range(1,T))
					new /obj/effect/hotspot(turf)
					//volume /= 3
			if (801 to 1100)
				for(var/turf/turf in range(2,T))
					new /obj/effect/hotspot(turf)
					//volume /= 4
			if (1101 to INFINITY) //If you're crafty
				for(var/turf/turf in range(3,T))
					new /obj/effect/hotspot(turf)
					//volume /= 5

	//var/datum/effect_system/smoke_spread/chem/smoke_machine/s = new
	var/datum/reagents/R = new/datum/reagents(3000)//Hey, just in case.
	var/datum/effect_system/smoke_spread/chem/s = new()
	if(pH < 4)
		//s.set_up(/datum/reagent/fermi/fermiAcid, (volume/3), pH*10, T)
		R.add_reagent("fermiAcid", ((volume/3)/pH))
		pHmod = 2
	if (pH > 10)
		var/datum/effect_system/reagents_explosion/e = new()
		e.set_up(round((volume/30)*(pH-9)), T, 0, 0)
		e.start()
		pHmod = 1.5
	for (var/datum/reagent/reagent in my_atom.reagents.reagent_list)
		if (istype(reagent, /datum/reagent/fermi))
			var/datum/chemical_reaction/fermi/Ferm  = GLOB.chemical_reagents_list[reagent.id]
			Ferm.FermiExplode(src, my_atom, holder, volume, temp, pH, Exploding = TRUE)
			continue //Don't allow fermichems into the mix (fermi explosions are handled elsewhere and it's a huge pain)
		R.add_reagent(reagent, reagent.volume)
		if (reagent.purity < 0.6)
			ImpureTot = (ImpureTot + (1-reagent.purity)) / 2
	if(R.reagent_list)
		s.set_up(R, (volume/10)*pHmod, T)
		s.start()
	if(!ImpureTot == 0)
		ImpureTot *= volume
		empulse(T, volume/10, ImpureTot/10, 1)
	message_admins("Fermi explosion at [T], with a temperature of [temp], pH of [pH], Impurity tot of [ImpureTot], containing [my_atom.reagents.reagent_list]")
	my_atom.reagents.clear_reagents()
	return

/datum/chemical_reaction/fermi/eigenstate
	name = "Eigenstasium"
	id = "eigenstate"
	results = list("eigenstate" = 1)
	required_reagents = list("bluespace" = 1, "stable_plasma" = 1, "sugar" = 1)
	mix_message = "zaps brightly into existance, diffusing the energy from the localised gravity well as light"
	//FermiChem vars:
	OptimalTempMin = 350 // Lower area of bell curve for determining heat based rate reactions
	OptimalTempMax = 500 // Upper end for above
	ExplodeTemp = 550 //Temperature at which reaction explodes
	OptimalpHMin = 4 // Lowest value of pH determining pH a 1 value for pH based rate reactions (Plateu phase)
	OptimalpHMax = 9.5 // Higest value for above
	ReactpHLim = 2 // How far out pH wil react, giving impurity place (Exponential phase)
	CatalystFact = 0 // How much the catalyst affects the reaction (0 = no catalyst)
	CurveSharpT = 4 // How sharp the temperature exponential curve is (to the power of value)
	CurveSharppH = 2 // How sharp the pH exponential curve is (to the power of value)
	ThermicConstant = -2.5 //Temperature change per 1u produced
	HIonRelease = 0.01 //pH change per 1u reaction
	RateUpLim = 5 //Optimal/max rate possible if all conditions are perfect
	FermiChem = TRUE//If the chemical uses the Fermichem reaction mechanics
	FermiExplode = FALSE //If the chemical explodes in a special way


/datum/chemical_reaction/fermi/eigenstate/FermiCreate(datum/reagents/holder)
	var/location = get_turf(holder.my_atom)
	var/datum/reagent/fermi/eigenstate/E = locate(/datum/reagent/fermi/eigenstate) in holder.reagent_list
	E.location_created = location
	//add on_new() handling of vars

//serum
/datum/chemical_reaction/fermi/SDGF
	name = "Synthetic-derived growth factor"
	id = "SDGF"
	results = list("SDGF" = 3)
	required_reagents = list("plasma" = 1, "stable_plasma" = 1, "sugar" = 1)
	//required_reagents = list("stable_plasma" = 5, "slimejelly" = 5, "synthflesh" = 10, "blood" = 10)
	//FermiChem vars:
	OptimalTempMin 		= 350 		// Lower area of bell curve for determining heat based rate reactions
	OptimalTempMax 		= 500 		// Upper end for above
	ExplodeTemp 		= 550 		// Temperature at which reaction explodes
	OptimalpHMin 		= 4 		// Lowest value of pH determining pH a 1 value for pH based rate reactions (Plateu phase)
	OptimalpHMax 		= 9.5 		// Higest value for above
	ReactpHLim 			= 2 		// How far out pH wil react, giving impurity place (Exponential phase)
	CatalystFact 		= 0 		// How much the catalyst affects the reaction (0 = no catalyst)
	CurveSharpT 		= 4 		// How sharp the temperature exponential curve is (to the power of value)
	CurveSharppH 		= 2 		// How sharp the pH exponential curve is (to the power of value)
	ThermicConstant		= 20 		// Temperature change per 1u produced
	HIonRelease 		= 0.01 		// pH change per 1u reaction
	RateUpLim 			= 5 		// Optimal/max rate possible if all conditions are perfect
	FermiChem 			= TRUE		// If the chemical uses the Fermichem reaction mechanics
	FermiExplode 		= TRUE		// If the chemical explodes in a special way
	PurityMin 			= 0.25

/datum/chemical_reaction/fermi/SDGF/FermiExplode(src, datum/reagents/holder, volume, temp, pH, Reaction)//Spawns an angery teratoma!! Spooky..! be careful!! TODO: Add teratoma slime subspecies
	var/turf/T = get_turf(holder)
	var/mob/living/simple_animal/slime/S = new(T,"grey")//should work, in theory
	S.damage_coeff = list(BRUTE = 0.9 , BURN = 2, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)//I dunno how slimes work cause fire is burny
	S.name = "Living teratoma"
	S.real_name = "Living teratoma"//horrifying!!
	S.rabid = 1//Make them an angery boi, grr grr
	to_chat("<span class='warning'>The cells clump up into a horrifying tumour!</span>")
	holder.clear_reagents()

/datum/chemical_reaction/fermi/BElarger
	name = "Sucubus milk"
	id = "BElarger"
	results = list("BElarger" = 6)
	required_reagents = list("salglu_solution" = 1, "milk" = 5, "synthflesh" = 2, "silicon" = 2, "aphro" = 2)
	//FermiChem vars:
	OptimalTempMin 			= 200
	OptimalTempMax			= 800
	ExplodeTemp 			= 900
	OptimalpHMin 			= 5
	OptimalpHMax 			= 10
	ReactpHLim 				= 3
	CatalystFact 			= 0
	CurveSharpT 			= 2
	CurveSharppH 			= 2
	ThermicConstant 		= 1
	HIonRelease 			= 0.1
	RateUpLim 				= 10
	FermiChem				= TRUE
	FermiExplode 			= TRUE
	PurityMin 				= 0.1

/datum/chemical_reaction/fermi/BElarger/FermiExplode(src, datum/reagents/holder, volume, temp, pH, Reaction)
	//var/obj/item/organ/genital/breasts/B =
	new /obj/item/organ/genital/breasts(get_turf(holder))
	var/list/seen = viewers(5, get_turf(holder))
	for(var/mob/M in seen)
		to_chat(M, "<span class='warning'>The reaction suddenly condenses, creating a pair of breasts!</b></span>")//OwO
	holder.clear_reagents()
	..()

/datum/chemical_reaction/fermi/PElarger //Vars needed
	name = "Incubus draft"
	id = "PElarger"
	results = list("PElarger" = 3)
	required_reagents = list("plasma" = 1, "stable_plasma" = 1, "sugar" = 1)
	//required_reagents = list("stable_plasma" = 5, "slimejelly" = 5, "synthflesh" = 10, "blood" = 10)
	//FermiChem vars:
	OptimalTempMin 			= 200
	OptimalTempMax			= 800
	ExplodeTemp 			= 900
	OptimalpHMin 			= 5
	OptimalpHMax 			= 10
	ReactpHLim 				= 3
	CatalystFact 			= 0
	CurveSharpT 			= 2
	CurveSharppH 			= 2
	ThermicConstant 		= 1
	HIonRelease 			= 0.1
	RateUpLim 				= 10
	FermiChem				= TRUE
	FermiExplode 			= TRUE
	PurityMin 				= 0.1

/datum/chemical_reaction/fermi/PElarger/FermiExplode(src, datum/reagents/holder, volume, temp, pH, Reaction)
	//var/obj/item/organ/genital/penis/nP =
	new /obj/item/organ/genital/penis(get_turf(holder))
	var/list/seen = viewers(5, get_turf(holder))
	for(var/mob/M in seen)
		to_chat(M, "<span class='warning'>The reaction suddenly condenses, creating a penis!</b></span>")//OwO
	holder.clear_reagents()
	..()

/datum/chemical_reaction/fermi/astral //Vars needed
	name = "Astrogen"
	id = "astral"
	results = list("astral" = 3)
	required_reagents = list("eigenstasium" = 1, "plasma" = 1, "synaptizine" = 1, "aluminium" = 5)
	//required_reagents = list("stable_plasma" = 5, "slimejelly" = 5, "synthflesh" = 10, "blood" = 10)
	//FermiChem vars:
	OptimalTempMin 			= 200
	OptimalTempMax			= 800
	ExplodeTemp 			= 900
	OptimalpHMin 			= 5
	OptimalpHMax 			= 10
	ReactpHLim 				= 3
	CatalystFact 			= 0
	CurveSharpT 			= 2
	CurveSharppH 			= 2
	ThermicConstant 		= 1
	HIonRelease 			= 0.1
	RateUpLim 				= 10
	FermiChem				= TRUE
	FermiExplode 			= TRUE
	PurityMin 				= 0.25


/datum/chemical_reaction/fermi/enthrall //Vars needed
	name = "MKUltra"
	id = "enthrall"
	results = list("enthrall" = 3)
	required_reagents = list("iron" = 1, "iodine" = 1)
	//required_reagents = list("cocoa" = 1, "astral" = 1, "mindbreaker" = 1, "psicodine" = 1, "happiness" = 1)
	required_catalysts = list("blood" = 1)
	//required_reagents = list("stable_plasma" = 5, "slimejelly" = 5, "synthflesh" = 10, "blood" = 10)
	//FermiChem vars:
	OptimalTempMin 			= 780
	OptimalTempMax			= 800
	ExplodeTemp 			= 820
	OptimalpHMin 			= 1
	OptimalpHMax 			= 2
	ReactpHLim 				= 2
	//CatalystFact 			= 0
	CurveSharpT 			= 0.5
	CurveSharppH 			= 4
	ThermicConstant 		= 20
	HIonRelease 			= 0.1
	RateUpLim 				= 5
	FermiChem				= TRUE
	FermiExplode 			= TRUE
	PurityMin 				= 0.15



/datum/chemical_reaction/fermi/enthrall/FermiFinish(datum/reagents/holder, var/atom/my_atom)
	message_admins("On finish for enthral proc'd")
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in my_atom.reagents.reagent_list
	var/datum/reagent/fermi/enthrall/E = locate(/datum/reagent/fermi/enthrall) in my_atom.reagents.reagent_list
	if (B.data.["gender"] == "female")
		E.data.["creatorGender"] = "Mistress"
		E.creatorGender = "Mistress"
	else
		E.data.["creatorGender"] = "Master"
		E.creatorGender = "Master"
	E.data["creatorName"] = B.data.["real_name"]
	E.creatorName = B.data.["real_name"]
	E.data.["creatorID"] = B.data.["ckey"]
	E.creatorID = B.data.["ckey"]
	message_admins("name: [E.creatorName], ID: [E.creatorID], gender: [E.creatorGender]")

//Apprently works..?Negative
/*
/datum/chemical_reaction/fermi/enthrall/on_reaction(datum/reagents/holder)
	message_admins("On reaction for enthral proc'd")
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in holder.reagent_list
	var/datum/reagent/fermi/enthrall/E = locate(/datum/reagent/fermi/enthrall) in holder.reagent_list
	if (B.data.["gender"] == "female")
		E.data.["creatorGender"] = "Mistress"
	else
		E.data.["creatorGender"] = "Master"
	E.data["creatorName"] = B.data.["real_name"]
	E.data.["creatorID"] = B.data.["ckey"]
	message_admins("name: [E.creatorName], ID: [E.creatorID], gender: [E.creatorGender]")
	..()

	//var/enthrallID = B.get_blood_data()
*/

/datum/chemical_reaction/fermi/enthrall/FermiExplode(src, datum/reagents/holder, volume, temp, pH, Reaction)
	var/turf/T = get_turf(holder)
	var/datum/reagents/R = new/datum/reagents(1000)
	var/datum/effect_system/smoke_spread/chem/s = new()
	R.add_reagent("enthrallExplo", volume)
	s.set_up(R, volume, T)
	s.start()
	holder.clear_reagents()
	//..() //Please don't kill everyone too.

/datum/chemical_reaction/fermi/hatmium
	name = "Hat growth serum"
	id = "hatmium"
	results = list("hatmium" = 5)
	required_reagents = list("whiskey" = 1, "nutriment" = 3, "cooking_oil" = 2, "iron" = 1, "blackpepper" = 3)
	//mix_message = ""
	//FermiChem vars:
	OptimalTempMin 	= 500
	OptimalTempMax 	= 650
	ExplodeTemp 	= 750
	OptimalpHMin 	= 10
	OptimalpHMax 	= 14
	ReactpHLim 		= 1
	//CatalystFact 	= 0 //To do 1
	CurveSharpT 	= 4
	CurveSharppH 	= 0.5
	ThermicConstant = -2.5
	HIonRelease 	= 0.01
	RateUpLim 		= 5
	FermiChem 		= TRUE
	//FermiExplode 	= FALSE
	//PurityMin		= 0.15

/datum/chemical_reaction/fermi/hatmium/FermiExplode(src, datum/reagents/holder, volume, temp, pH, Reaction)
	var/obj/item/clothing/head/hattip/hat = new /obj/item/clothing/head/hattip(get_turf(holder.my_atom))
	hat.animate_atom_living()
	var/list/seen = viewers(5, get_turf(holder.my_atom))
	for(var/mob/M in seen)
		to_chat(M, "<span class='warning'>The makes an off sounding pop, as a hat suddenly climbs out of the beaker!</b></span>")
	holder.clear_reagents()
	..()

/datum/chemical_reaction/fermi/furranium //low temp and medium pH
	name = "Furranium"
	id = "furranium"
	results = list("furranium" = 5)
	required_reagents = list("aphro" = 1, "moonsugar" = 1, "silver" = 1, "salglu_solution" = 1)
	//mix_message = ""
	//FermiChem vars:
	OptimalTempMin 	= 350
	OptimalTempMax 	= 600
	ExplodeTemp 	= 700
	OptimalpHMin 	= 8
	OptimalpHMax 	= 10
	ReactpHLim 		= 1
	//CatalystFact 	= 0 //To do 1
	CurveSharpT 	= 2
	CurveSharppH 	= 0.5
	ThermicConstant = -2
	HIonRelease 	= -0.1
	RateUpLim 		= 10
	FermiChem 		= TRUE
	//FermiExplode 	= FALSE
	//PurityMin		= 0.15

//Nano-b-gone
/datum/chemical_reaction/fermi/naninte_b_gone
	name = "Naninte bain"
	id = "naninte_b_gone"
	results = list("naninte_b_gone" = 5)
	required_reagents = list("synthflesh" = 5, "uranium" = 1, "iron" = 1, "salglu_solution" = 3)
	mix_message = "the reaction gurgles, encapsulating the reagents in flesh."
	//FermiChem vars:
	OptimalTempMin 	= 450
	OptimalTempMax 	= 600
	ExplodeTemp 	= 700
	OptimalpHMin 	= 6
	OptimalpHMax 	= 8
	ReactpHLim 		= 1
	//CatalystFact 	= 0 //To do 1
	CurveSharpT 	= 4
	CurveSharppH 	= 2
	ThermicConstant = -2.5
	HIonRelease 	= 0.01
	RateUpLim 		= 5
	FermiChem 		= TRUE
	//FermiExplode 	= FALSE
	//PurityMin		= 0.15
