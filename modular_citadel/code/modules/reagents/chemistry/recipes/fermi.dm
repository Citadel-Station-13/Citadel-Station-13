/datum/chemical_reaction/fermi
	mix_sound = 'sound/effects/bubbles.ogg'

//Called for every reaction step
/datum/chemical_reaction/proc/FermiCreate(datum/reagents/holder, added_volume, added_purity)
	return

//Called when reaction STOP_PROCESSING
/datum/chemical_reaction/proc/FermiFinish(datum/reagents/holder, var/atom/my_atom, reactVol)
	if(clear_conversion & REACTION_CLEAR_IMPURE | REACTION_CLEAR_INVERSE)
		for(var/id in results)
			var/datum/reagent/R = holder.has_reagent("[id]")
			if(!R) //If we exploded
				continue
			if(R.purity == 1)
				continue

			var/temp_purity = R.purity
			var/cached_volume = reactVol
			if(clear_conversion & REACTION_CLEAR_INVERSE && R.inverse_chem)
				if(R.inverse_chem_val > R.purity)
					if(GLOB.Debug2)
						message_admins("Inverting [cached_volume] [R.id] [R.purity] into [R.inverse_chem]")
					holder.remove_reagent(R.id, cached_volume, TRUE)
					holder.add_reagent(R.inverse_chem, cached_volume, FALSE, added_purity = 1)
					var/datum/reagent/R2 = holder.has_reagent("[R.inverse_chem]")
					if(clear_conversion & REACTION_CLEAR_RETAIN)
						R2.cached_purity = 1-R.purity
						R2.purity = R2.cached_purity
					return

			if(clear_conversion & REACTION_CLEAR_IMPURE && R.impure_chem)
				var/impureVol = cached_volume * (1 - R.purity)
				if(GLOB.Debug2)
					message_admins("Impure [cached_volume] of [R.id] at [R.purity] into [impureVol] of [R.impure_chem] with [clear_conversion & REACTION_CLEAR_RETAIN ? "Clear conversion" : "Purification"] mechanics")
				holder.remove_reagent(id, (impureVol), TRUE)
				holder.add_reagent(R.impure_chem, impureVol, FALSE, added_purity = 1)
				var/datum/reagent/R2 = holder.has_reagent("[R.impure_chem]")
				if(clear_conversion & REACTION_CLEAR_RETAIN)
					R2.cached_purity = 1-temp_purity
					R2.purity = R2.cached_purity
					R.chemical_flags |= REAGENT_DONOTSPLIT //Splitting is done here
				R.cached_purity = R.purity
				R.purity = 1

	return

/datum/chemical_reaction/fermi/eigenstate
	name = "Eigenstasium"
	id = "eigenstate"
	results = list("eigenstate" = 1)
	required_reagents = list("bluespace" = 1, "stable_plasma" = 1, "sugar" = 1)
	mix_message = "the reaction zaps suddenly!"
	//FermiChem vars:
	OptimalTempMin 		= 350 // Lower area of bell curve for determining heat based rate reactions
	OptimalTempMax		= 600 // Upper end for above
	ExplodeTemp			= 650 //Temperature at which reaction explodes
	OptimalpHMin		= 7 // Lowest value of pH determining pH a 1 value for pH based rate reactions (Plateu phase)
	OptimalpHMax		= 9 // Higest value for above
	ReactpHLim			= 5 // How far out pH wil react, giving impurity place (Exponential phase)
	CatalystFact		= 0 // How much the catalyst affects the reaction (0 = no catalyst)
	CurveSharpT 		= 1.5 // How sharp the temperature exponential curve is (to the power of value)
	CurveSharppH 		= 3 // How sharp the pH exponential curve is (to the power of value)
	ThermicConstant		= 10 //Temperature change per 1u produced
	HIonRelease 		= -0.02 //pH change per 1u reaction
	RateUpLim 			= 3 //Optimal/max rate possible if all conditions are perfect
	FermiChem 			= TRUE//If the chemical uses the Fermichem reaction mechanics
	PurityMin			= 0.4 //The minimum purity something has to be above, otherwise it explodes.

/datum/chemical_reaction/fermi/eigenstate/FermiFinish(datum/reagents/holder, var/atom/my_atom)//Strange how this doesn't work but the other does.
	var/datum/reagent/fermi/eigenstate/E = locate(/datum/reagent/fermi/eigenstate) in my_atom.reagents.reagent_list
	if(!E)
		return
	var/turf/open/location = get_turf(my_atom)
	if(location)
		E.location_created = location
		E.data["location_created"] = location


//serum
/datum/chemical_reaction/fermi/SDGF
	name = "Synthetic-derived growth factor"
	id = "SDGF"
	results = list("SDGF" = 3)
	required_reagents = list("stable_plasma" = 1.5, "clonexadone" = 1.5, "uranium" = 1.5, "synthflesh" = 1.5)
	mix_message = "the reaction gives off a blorble!"
	required_temp = 1
	//FermiChem vars:
	OptimalTempMin 		= 600 		// Lower area of bell curve for determining heat based rate reactions
	OptimalTempMax 		= 630 		// Upper end for above
	ExplodeTemp 		= 635 		// Temperature at which reaction explodes
	OptimalpHMin 		= 3 		// Lowest value of pH determining pH a 1 value for pH based rate reactions (Plateu phase)
	OptimalpHMax 		= 3.5 		// Higest value for above
	ReactpHLim 			= 2 		// How far out pH wil react, giving impurity place (Exponential phase)
	CatalystFact 		= 0 		// How much the catalyst affects the reaction (0 = no catalyst)
	CurveSharpT 		= 4 		// How sharp the temperature exponential curve is (to the power of value)
	CurveSharppH 		= 4 		// How sharp the pH exponential curve is (to the power of value)
	ThermicConstant		= -10 		// Temperature change per 1u produced
	HIonRelease 		= 0.02 		// pH change per 1u reaction (inverse for some reason)
	RateUpLim 			= 1 		// Optimal/max rate possible if all conditions are perfect
	FermiChem 			= TRUE		// If the chemical uses the Fermichem reaction mechanics
	PurityMin 			= 0.2

/datum/chemical_reaction/fermi/SDGF/FermiExplode(datum/reagents, var/atom/my_atom, volume, temp, pH)//Spawns an angery teratoma!
	var/turf/T = get_turf(my_atom)
	var/amount_to_spawn = round((volume/100), 1)
	if(amount_to_spawn <= 0)
		amount_to_spawn = 1
	for(var/i in 1 to amount_to_spawn)
		var/mob/living/simple_animal/slime/S = new(T,"green")
		S.damage_coeff = list(BRUTE = 0.9 , BURN = 2, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)
		S.name = "Living teratoma"
		S.real_name = "Living teratoma"
		S.rabid = 1//Make them an angery boi
		S.color = "#810010"
	my_atom.reagents.clear_reagents()
	var/list/seen = viewers(8, get_turf(my_atom))
	for(var/mob/M in seen)
		to_chat(M, "<span class='warning'>The cells clump up into a horrifying tumour!</span>")

/datum/chemical_reaction/fermi/breast_enlarger
	name = "Sucubus milk"
	id = "breast_enlarger"
	results = list("breast_enlarger" = 8)
	required_reagents = list("salglu_solution" = 1, "milk" = 1, "synthflesh" = 2, "silicon" = 3, "aphro" = 3)
	mix_message = "the reaction gives off a mist of milk."
	//FermiChem vars:
	OptimalTempMin 			= 200
	OptimalTempMax			= 800
	ExplodeTemp 			= 900
	OptimalpHMin 			= 6
	OptimalpHMax 			= 10
	ReactpHLim 				= 3
	CatalystFact 			= 0
	CurveSharpT 			= 2
	CurveSharppH 			= 1
	ThermicConstant 		= 1
	HIonRelease 			= -0.1
	RateUpLim 				= 5
	FermiChem				= TRUE
	PurityMin 				= 0.1

/datum/chemical_reaction/fermi/breast_enlarger/FermiFinish(datum/reagents/holder, var/atom/my_atom)
	var/datum/reagent/fermi/breast_enlarger/BE = locate(/datum/reagent/fermi/breast_enlarger) in my_atom.reagents.reagent_list
	var/cached_volume = BE.volume
	if(BE.purity < 0.35)
		holder.remove_reagent(src.id, cached_volume)
		holder.add_reagent("BEsmaller", cached_volume)


/datum/chemical_reaction/fermi/breast_enlarger/FermiExplode(datum/reagents, var/atom/my_atom, volume, temp, pH)
	var/obj/item/organ/genital/breasts/B = new /obj/item/organ/genital/breasts(get_turf(my_atom))
	var/list/seen = viewers(8, get_turf(my_atom))
	for(var/mob/M in seen)
		to_chat(M, "<span class='warning'>The reaction suddenly condenses, creating a pair of breasts!</b></span>")
	var/datum/reagent/fermi/breast_enlarger/BE = locate(/datum/reagent/fermi/breast_enlarger) in my_atom.reagents.reagent_list
	B.size = ((BE.volume * BE.purity) / 10) //half as effective.
	my_atom.reagents.clear_reagents()

/datum/chemical_reaction/fermi/penis_enlarger
	name = "Incubus draft"
	id = "penis_enlarger"
	results = list("penis_enlarger" = 8)
	required_reagents = list("blood" = 5, "synthflesh" = 2, "carbon" = 2, "aphro" = 2, "salglu_solution" = 1)
	mix_message = "the reaction gives off a spicy mist."
	//FermiChem vars:
	OptimalTempMin 			= 200
	OptimalTempMax			= 800
	ExplodeTemp 			= 900
	OptimalpHMin 			= 2
	OptimalpHMax 			= 6
	ReactpHLim 				= 3
	CatalystFact 			= 0
	CurveSharpT 			= 2
	CurveSharppH 			= 1
	ThermicConstant 		= 1
	HIonRelease 			= 0.1
	RateUpLim 				= 5
	FermiChem				= TRUE
	PurityMin 				= 0.1

/datum/chemical_reaction/fermi/penis_enlarger/FermiExplode(datum/reagents, var/atom/my_atom, volume, temp, pH)
	var/obj/item/organ/genital/penis/P = new /obj/item/organ/genital/penis(get_turf(my_atom))
	var/list/seen = viewers(8, get_turf(my_atom))
	for(var/mob/M in seen)
		to_chat(M, "<span class='warning'>The reaction suddenly condenses, creating a penis!</b></span>")
	var/datum/reagent/fermi/penis_enlarger/PE = locate(/datum/reagent/fermi/penis_enlarger) in my_atom.reagents.reagent_list
	P.length = ((PE.volume * PE.purity) / 10)//half as effective.
	my_atom.reagents.clear_reagents()

/datum/chemical_reaction/fermi/penis_enlarger/FermiFinish(datum/reagents/holder, var/atom/my_atom)
	var/datum/reagent/fermi/penis_enlarger/PE = locate(/datum/reagent/fermi/penis_enlarger) in my_atom.reagents.reagent_list
	var/cached_volume = PE.volume
	if(PE.purity < 0.35)
		holder.remove_reagent(src.id, cached_volume)
		holder.add_reagent("PEsmaller", cached_volume)

/datum/chemical_reaction/fermi/astral
	name = "Astrogen"
	id = "astral"
	results = list("astral" = 5)
	required_reagents = list("eigenstate" = 1, "plasma" = 3, "synaptizine" = 1, "aluminium" = 5)
	//FermiChem vars:
	OptimalTempMin 			= 700
	OptimalTempMax			= 800
	ExplodeTemp 			= 1150
	OptimalpHMin 			= 10
	OptimalpHMax 			= 13
	ReactpHLim 				= 2
	CatalystFact 			= 0
	CurveSharpT 			= 1
	CurveSharppH 			= 1
	ThermicConstant 		= 25
	HIonRelease 			= 0.02
	RateUpLim 				= 15
	FermiChem				= TRUE
	PurityMin 				= 0.25


/datum/chemical_reaction/fermi/enthrall //check this
	name = "MKUltra"
	id = "enthrall"
	results = list("enthrall" = 5)
	required_reagents = list("cocoa" = 1, "bluespace" = 1, "mindbreaker" = 1, "psicodine" = 1, "happiness" = 1)
	required_catalysts = list("blood" = 1)
	mix_message = "the reaction gives off a burgundy plume of smoke!"
	//FermiChem vars:
	OptimalTempMin 			= 780
	OptimalTempMax			= 820
	ExplodeTemp 			= 840
	OptimalpHMin 			= 12
	OptimalpHMax 			= 13
	ReactpHLim 				= 2
	//CatalystFact 			= 0
	CurveSharpT 			= 0.5
	CurveSharppH 			= 4
	ThermicConstant 		= 15
	HIonRelease 			= 0.1
	RateUpLim 				= 1
	FermiChem				= TRUE
	PurityMin 				= 0.2

/datum/chemical_reaction/fermi/enthrall/FermiFinish(datum/reagents/holder, var/atom/my_atom)
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in my_atom.reagents.reagent_list
	var/datum/reagent/fermi/enthrall/E = locate(/datum/reagent/fermi/enthrall) in my_atom.reagents.reagent_list
	if(!B)
		return
	if(!B.data)
		var/list/seen = viewers(5, get_turf(my_atom))
		for(var/mob/M in seen)
			to_chat(M, "<span class='warning'>The reaction splutters and fails to react properly.</span>") //Just in case
			E.purity = 0
	if (B.data["gender"] == "female")
		E.data["creatorGender"] = "Mistress"
		E.creatorGender = "Mistress"
	else
		E.data["creatorGender"] = "Master"
		E.creatorGender = "Master"
	E.data["creatorName"] = B.data["real_name"]
	E.creatorName = B.data["real_name"]
	E.data["creatorID"] = B.data["ckey"]
	E.creatorID = B.data["ckey"]

//So slimes can play too.
/datum/chemical_reaction/fermi/enthrall/slime
	required_catalysts = list("jellyblood" = 1)

/datum/chemical_reaction/fermi/enthrall/slime/FermiFinish(datum/reagents/holder, var/atom/my_atom)
	var/datum/reagent/blood/jellyblood/B = locate(/datum/reagent/blood/jellyblood) in my_atom.reagents.reagent_list//The one line change.
	var/datum/reagent/fermi/enthrall/E = locate(/datum/reagent/fermi/enthrall) in my_atom.reagents.reagent_list
	if(!B.data)
		var/list/seen = viewers(5, get_turf(my_atom))
		for(var/mob/M in seen)
			to_chat(M, "<span class='warning'>The reaction splutters and fails to react.</span>") //Just in case
			E.purity = 0
	if (B.data["gender"] == "female")
		E.data["creatorGender"] = "Mistress"
		E.creatorGender = "Mistress"
	else
		E.data["creatorGender"] = "Master"
		E.creatorGender = "Master"
	E.data["creatorName"] = B.data["real_name"]
	E.creatorName = B.data["real_name"]
	E.data["creatorID"] = B.data["ckey"]
	E.creatorID = B.data["ckey"]

/datum/chemical_reaction/fermi/enthrall/FermiExplode(datum/reagents, var/atom/my_atom, volume, temp, pH)
	var/turf/T = get_turf(my_atom)
	var/datum/reagents/R = new/datum/reagents(1000)
	var/datum/effect_system/smoke_spread/chem/s = new()
	R.add_reagent("enthrallExplo", volume)
	s.set_up(R, volume/2, T)
	s.start()
	my_atom.reagents.clear_reagents()

/datum/chemical_reaction/fermi/hatmium // done
	name = "Hat growth serum"
	id = "hatmium"
	results = list("hatmium" = 5)
	required_reagents = list("ethanol" = 1, "nutriment" = 3, "cooking_oil" = 2, "iron" = 1, "gold" = 3)
	//mix_message = ""
	//FermiChem vars:
	OptimalTempMin 	= 500
	OptimalTempMax 	= 700
	ExplodeTemp 	= 750
	OptimalpHMin 	= 2
	OptimalpHMax 	= 5
	ReactpHLim 		= 3
	//CatalystFact 	= 0 //To do 1
	CurveSharpT 	= 8
	CurveSharppH 	= 0.5
	ThermicConstant = -2
	HIonRelease 	= -0.1
	RateUpLim 		= 2
	FermiChem 		= TRUE
	PurityMin		= 0.5

/datum/chemical_reaction/fermi/hatmium/FermiExplode(src, var/atom/my_atom, volume, temp, pH)
	var/amount_to_spawn = round((volume/100), 1)
	if(amount_to_spawn <= 0)
		amount_to_spawn = 1
	for(var/i in 1 to amount_to_spawn)
		var/obj/item/clothing/head/hattip/hat = new /obj/item/clothing/head/hattip(get_turf(my_atom))
		hat.animate_atom_living()
	var/list/seen = viewers(8, get_turf(my_atom))
	for(var/mob/M in seen)
		to_chat(M, "<span class='warning'>The [my_atom] makes an off sounding pop, as a hat suddenly climbs out of it!</b></span>")
	my_atom.reagents.clear_reagents()

/datum/chemical_reaction/fermi/furranium
	name = "Furranium"
	id = "furranium"
	results = list("furranium" = 5)
	required_reagents = list("aphro" = 1, "moonsugar" = 1, "silver" = 2, "salglu_solution" = 1)
	mix_message = "You think you can hear a howl come from the beaker."
	//FermiChem vars:
	OptimalTempMin 	= 350
	OptimalTempMax 	= 600
	ExplodeTemp 	= 700
	OptimalpHMin 	= 8
	OptimalpHMax 	= 10
	ReactpHLim 		= 2
	//CatalystFact 	= 0 //To do 1
	CurveSharpT 	= 2
	CurveSharppH 	= 0.5
	ThermicConstant = -10
	HIonRelease 	= -0.1
	RateUpLim 		= 2
	FermiChem 		= TRUE
	PurityMin		= 0.3

/datum/chemical_reaction/fermi/furranium/organic
	required_reagents = list("aphro" = 1, "catnip" = 1, "silver" = 2, "salglu_solution" = 1)

//FOR INSTANT REACTIONS - DO NOT MULTIPLY LIMIT BY 10.
//There's a weird rounding error or something ugh.

//Nano-b-gone
/datum/chemical_reaction/fermi/nanite_b_gone//done test
	name = "Naninte bain"
	id = "nanite_b_gone"
	results = list("nanite_b_gone" = 4)
	required_reagents = list("synthflesh" = 1, "uranium" = 1, "iron" = 1, "salglu_solution" = 1)
	mix_message = "the reaction gurgles, encapsulating the reagents in flesh before the emp can be set off."
	required_temp = 450//To force fermireactions before EMP.
	//FermiChem vars:
	OptimalTempMin 	= 500
	OptimalTempMax 	= 600
	ExplodeTemp 	= 700
	OptimalpHMin 	= 6
	OptimalpHMax 	= 6.25
	ReactpHLim 		= 3
	//CatalystFact 	= 0 //To do 1
	CurveSharpT 	= 0
	CurveSharppH 	= 1
	ThermicConstant = 5
	HIonRelease 	= 0.01
	RateUpLim 		= 1
	FermiChem 		= TRUE

/datum/chemical_reaction/fermi/acidic_buffer//done test
	name = "Acetic acid buffer"
	id = "acidic_buffer"
	results = list("acidic_buffer" = 10) //acetic acid
	required_reagents = list("salglu_solution" = 1, "ethanol" = 3, "oxygen" = 3, "water" = 3)
	//FermiChem vars:
	OptimalTempMin 	= 250
	OptimalTempMax 	= 500
	ExplodeTemp 	= 9999 //check to see overflow doesn't happen!
	OptimalpHMin 	= 0
	OptimalpHMax 	= 14
	ReactpHLim 		= 0
	//CatalystFact 	= 0 //To do 1
	CurveSharpT 	= 4
	CurveSharppH 	= 0
	ThermicConstant = 0
	HIonRelease 	= -0.01
	RateUpLim 		= 20
	FermiChem 		= TRUE


/datum/chemical_reaction/fermi/acidic_buffer/FermiFinish(datum/reagents/holder, var/atom/my_atom) //might need this
	if(!locate(/datum/reagent/fermi/acidic_buffer) in my_atom.reagents.reagent_list)
		return
	var/datum/reagent/fermi/acidic_buffer/Fa = locate(/datum/reagent/fermi/acidic_buffer) in my_atom.reagents.reagent_list
	Fa.data = 0.1//setting it to 0 means byond thinks it's not there.

/datum/chemical_reaction/fermi/basic_buffer//done test
	name = "Ethyl Ethanoate buffer"
	id = "basic_buffer"
	results = list("basic_buffer" = 5)
	required_reagents = list("lye" = 1, "ethanol" = 2, "water" = 2)
	required_catalysts = list("sacid" = 1) //vagely acetic
	//FermiChem vars:
	OptimalTempMin 	= 250
	OptimalTempMax 	= 500
	ExplodeTemp 	= 9999 //check to see overflow doesn't happen!
	OptimalpHMin 	= 0
	OptimalpHMax 	= 14
	ReactpHLim 		= 0
	//CatalystFact 	= 0 //To do 1
	CurveSharpT 	= 4
	CurveSharppH 	= 0
	ThermicConstant = 0
	HIonRelease 	= 0.01
	RateUpLim 		= 15
	FermiChem 		= TRUE


/datum/chemical_reaction/fermi/basic_buffer/FermiFinish(datum/reagents/holder, var/atom/my_atom) //might need this
	if(!locate(/datum/reagent/fermi/basic_buffer) in my_atom.reagents.reagent_list)
		return
	var/datum/reagent/fermi/basic_buffer/Fb = locate(/datum/reagent/fermi/basic_buffer) in my_atom.reagents.reagent_list
	Fb.data = 14

//secretcatchemcode, shh!! Of couse I hide it amongst cats. Though, I moved it with your requests.
//I'm not trying to be sneaky, I'm trying to keep it a secret!
//I don't know how to do hidden chems like Aurora
//ChemReactionVars:
/datum/chemical_reaction/fermi/secretcatchem //DONE
	name = "secretcatchem"
	id = "secretcatchem"
	results = list("secretcatchem" = 5)
	required_reagents = list("stable_plasma" = 1, "sugar" = 1, "cream" = 1, "clonexadone" = 1)//Yes this will make a kitty if you don't lucky guess. It'll eat all your reagents too.
	required_catalysts = list("SDGF" = 1)
	required_temp = 500
	mix_message = "the reaction gives off a meow!"
	mix_sound = "modular_citadel/sound/voice/merowr.ogg"
	//FermiChem vars:
	OptimalTempMin 		= 650
	OptimalpHMin 		= 0
	ReactpHLim 			= 2
	CurveSharpT 		= 0
	CurveSharppH 		= 0
	ThermicConstant		= 0
	HIonRelease 		= 0
	RateUpLim 			= 0.1
	FermiChem 			= TRUE
	PurityMin 			= 0.2

/datum/chemical_reaction/fermi/secretcatchem/New()
	//rand doesn't seem to work with n^-e
	OptimalTempMin 		+= rand(-100, 100)
	OptimalTempMax 		= (OptimalTempMin+rand(20, 200))
	ExplodeTemp 		= (OptimalTempMax+rand(20, 200))
	OptimalpHMin 		+= rand(1, 10)
	OptimalpHMax 		= (OptimalpHMin + rand(1, 5))
	ReactpHLim 			+= rand(-1.5, 2.5)
	CurveSharpT 		+= (rand(1, 500)/100)
	CurveSharppH 		+= (rand(1, 500)/100)
	ThermicConstant		+= rand(-20, 20)
	HIonRelease 		+= (rand(-25, 25)/100)
	RateUpLim 			+= (rand(1, 1000)/100)
	PurityMin 			+= (rand(-1, 1)/10)
	var/additions = list("aluminium", "silver", "gold", "plasma", "silicon", "uranium", "milk")
	required_reagents[pick(additions)] = rand(1, 5)//weird

/datum/chemical_reaction/fermi/secretcatchem/FermiFinish(datum/reagents/holder, var/atom/my_atom)
	SSblackbox.record_feedback("tally", "catgirlium")//log

/datum/chemical_reaction/fermi/secretcatchem/FermiExplode(datum/reagents, var/atom/my_atom, volume, temp, pH)
	var/mob/living/simple_animal/pet/cat/custom_cat/catto = new(get_turf(my_atom))
	var/list/seen = viewers(8, get_turf(my_atom))
	for(var/mob/M in seen)
		to_chat(M, "<span class='warning'>The reaction suddenly gives out a meow, condensing into a chemcat!</b></span>")//meow!
	playsound(get_turf(my_atom), 'modular_citadel/sound/voice/merowr.ogg', 50, 1, -1)
	catto.name = "Chemcat"
	catto.desc = "A cute chem cat, created by a lot of compicated and confusing chemistry!"
	catto.color = "#770000"
	my_atom.reagents.remove_all(5)

/datum/chemical_reaction/fermi/yamerol
	name = "Yamerol"
	id = "yamerol"
	results = list("yamerol" = 3)
	required_reagents = list("perfluorodecalin" = 1, "salbutamol" = 1, "water" = 1)
	//FermiChem vars:
	OptimalTempMin 	= 300
	OptimalTempMax 	= 500
	ExplodeTemp 	= 800
	OptimalpHMin 	= 6.8
	OptimalpHMax 	= 7.2
	ReactpHLim 		= 4
	//CatalystFact 	= 0 //To do 1
	CurveSharpT 	= 5
	CurveSharppH 	= 0.5
	ThermicConstant = -15
	HIonRelease 	= 0.1
	RateUpLim 		= 2
	FermiChem 		= TRUE

/datum/chemical_reaction/antacidpregen
	name = "Antacid pregenitor"
	id = "antacidpregen"
	results = list("antacidpregen" = 6)
	required_reagents = list("lye" = 3, "carbon" = 1, "oxygen" = 1, "hydrogen" = 1)
	//FermiChem vars:
	OptimalTempMin 	= 250
	OptimalTempMax 	= 500
	ExplodeTemp 	= 2000
	OptimalpHMin 	= 6.8
	OptimalpHMax 	= 7.2
	ReactpHLim 		= 8
	//CatalystFact 	= 0 //To do 1
	CurveSharpT 	= 0.5
	CurveSharppH 	= 2
	ThermicConstant = 0
	HIonRelease 	= -0.1
	RateUpLim 		= 2
	PurityMin 		= 0
	FermiChem 		= TRUE
	FermiExplode	= FERMI_EXPLOSION_TYPE_SMOKE

/datum/chemical_reaction/antacidpregen/FermiCreate(datum/reagents/R, added_volume, added_purity)
	.=..()
	if(!R)
		return
	if(R.pH > 14 || R.pH < 0)
		return
	if(R.pH > 7)
		R.pH += 0.5
	else
		R.pH -= 0.5
	R.pH = CLAMP(R.pH, 0, 14)

/datum/chemical_reaction/antacidpregen/FermiFinish(datum/reagents/holder, var/atom/my_atom, added_volume)
	var/datum/reagent/medicine/antacidpregen/A = holder.has_reagent("antacidpregen")
	if(!A)
		return
	if(holder.pH < 7)
		holder.remove_reagent(id, added_volume)
		holder.add_reagent("antbase", added_volume, added_purity = 1-A.purity)
		var/datum/reagent/medicine/antacidpregen/antbase/B = holder.has_reagent("antbase")
		B.cached_purity = 1-A.purity

	else
		holder.remove_reagent(id, added_volume)
		holder.add_reagent("antacid", added_volume, added_purity = 1-A.purity)
		var/datum/reagent/medicine/antacidpregen/antacid/A2 = holder.has_reagent("antacid")
		A2.cached_purity = 1-A.purity

/datum/chemical_reaction/antacidpregen/FermiExplode(datum/reagents/R0, var/atom/my_atom, volume, temp, pH, Exploding = FALSE)
	.=..()
	R0.clear_reagents()

/datum/chemical_reaction/cryosenium
	name = "Cryosenium"
	id = "cryosenium"
	results = list("cryosenium" = 2.5)
	required_reagents = list("cryoxadone" = 1, "ice" = 1, "cryostylane" = 1) //consider sterilizine if needed.
	//FermiChem vars:
	OptimalTempMin 	= 1
	OptimalTempMax 	= 300
	ExplodeTemp 	= 500
	OptimalpHMin 	= 4
	OptimalpHMax 	= 10
	ReactpHLim 		= 4
	//CatalystFact 	= 0 //To do 1
	CurveSharpT 	= 0.5
	CurveSharppH 	= 0.5
	ThermicConstant = -3
	HIonRelease 	= 0
	RateUpLim 		= 5
	FermiChem 		= TRUE
	FermiExplode	= TRUE
	PurityMin 		= 0.1

//purity != temp (above 50)
/datum/chemical_reaction/cryosenium/FermiCreate(datum/reagents/R, added_volume, added_purity)
	if(!R)
		return
	if(R.chem_temp < 20)
		FermiExplode(R, R.my_atom, R.total_volume, R.chem_temp, R.pH)
		return
	var/datum/reagent/medicine/cryosenium/C = R.has_reagent("cryosenium")
	var/step_purity = ((R.chem_temp-50)/250)
	C.purity = CLAMP(((C.purity * C.volume) + (step_purity * added_volume)) /((C.volume + added_volume)), 0, 1)
	..()

/datum/chemical_reaction/cryosenium/FermiExplode(datum/reagents/R, var/atom/my_atom, volume, temp, pH)
	playsound(my_atom, 'sound/magic/ethereal_exit.ogg', 50, 1)
	my_atom.visible_message("The reaction frosts over, releasing it's chilly contents!")
	var/_radius = max((volume/100), 1)
	if(temp < 100)
		_radius *= 2

	for(var/I in circlerangeturfs(center=my_atom, radius=_radius))
		if(!(istype(I, /turf/open)))
			continue
		var/turf/open/T2 = I
		T2.MakeSlippery(TURF_WET_PERMAFROST, min_wet_time = 2*_radius, wet_time_to_add = 5)
		var/datum/gas_mixture/turf/G = T2.air
		G.temperature = temp

	for(var/P in required_reagents)
		R.remove_reagent(P, 15)
	..()
