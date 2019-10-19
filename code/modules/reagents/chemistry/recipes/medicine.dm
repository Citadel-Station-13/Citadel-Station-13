
/datum/chemical_reaction/leporazine
	name = "Leporazine"
	id = "leporazine"
	results = list("leporazine" = 2)
	required_reagents = list("silicon" = 1, "copper" = 1)
	required_catalysts = list("plasma" = 5)

/datum/chemical_reaction/rezadone
	name = "Rezadone"
	id = "rezadone"
	results = list("rezadone" = 3)
	required_reagents = list("carpotoxin" = 1, "cryptobiolin" = 1, "copper" = 1)

/datum/chemical_reaction/spaceacillin
	name = "Spaceacillin"
	id = "spaceacillin"
	results = list("spaceacillin" = 2)
	required_reagents = list("cryptobiolin" = 1, "epinephrine" = 1)

/datum/chemical_reaction/inacusiate
	name = "inacusiate"
	id = "inacusiate"
	results = list("inacusiate" = 2)
	required_reagents = list("water" = 1, "carbon" = 1, "charcoal" = 1)

/datum/chemical_reaction/synaptizine
	name = "Synaptizine"
	id = "synaptizine"
	results = list("synaptizine" = 3)
	required_reagents = list("sugar" = 1, "lithium" = 1, "water" = 1)

/datum/chemical_reaction/charcoal
	name = "Charcoal"
	id = "charcoal"
	results = list("charcoal" = 2)
	required_reagents = list("ash" = 1, "sodiumchloride" = 1)
	mix_message = "The mixture yields a fine black powder."
	required_temp = 380

/datum/chemical_reaction/silver_sulfadiazine
	name = "Silver Sulfadiazine"
	id = "silver_sulfadiazine"
	results = list("silver_sulfadiazine" = 5)
	required_reagents = list("ammonia" = 1, "silver" = 1, "sulfur" = 1, "oxygen" = 1, "chlorine" = 1)

/datum/chemical_reaction/salglu_solution
	name = "Saline-Glucose Solution"
	id = "salglu_solution"
	results = list("salglu_solution" = 3)
	required_reagents = list("sodiumchloride" = 1, "water" = 1, "sugar" = 1)

/datum/chemical_reaction/mine_salve
	name = "Miner's Salve"
	id = "mine_salve"
	results = list("mine_salve" = 3)
	required_reagents = list("oil" = 1, "water" = 1, "iron" = 1)

/datum/chemical_reaction/mine_salve2
	name = "Miner's Salve"
	id = "mine_salve"
	results = list("mine_salve" = 15)
	required_reagents = list("plasma" = 5, "iron" = 5, "sugar" = 1) // A sheet of plasma, a twinkie and a sheet of metal makes four of these

/datum/chemical_reaction/synthflesh
	name = "Synthflesh"
	id = "synthflesh"
	results = list("synthflesh" = 3)
	required_reagents = list("blood" = 1, "carbon" = 1, "styptic_powder" = 1)

/datum/chemical_reaction/synthtissue
	name = "Synthtissue"
	id = "synthtissue"
	results = list("synthtissue" = 5)
	required_reagents = list("synthflesh" = 1)
	required_catalysts = list("nutriment" = 0.1)
	//FermiChem vars:
	OptimalTempMin 		= 305		// Lower area of bell curve for determining heat based rate reactions
	OptimalTempMax 		= 315 		// Upper end for above
	ExplodeTemp 		= 1050 		// Temperature at which reaction explodes
	OptimalpHMin 		= 8.5 		// Lowest value of pH determining pH a 1 value for pH based rate reactions (Plateu phase)
	OptimalpHMax 		= 9.5 		// Higest value for above
	ReactpHLim 			= 2 		// How far out pH wil react, giving impurity place (Exponential phase)
	CatalystFact 		= 0 		// How much the catalyst affects the reaction (0 = no catalyst)
	CurveSharpT 		= 1 		// How sharp the temperature exponential curve is (to the power of value)
	CurveSharppH 		= 2.5 		// How sharp the pH exponential curve is (to the power of value)
	ThermicConstant		= 0.01 		// Temperature change per 1u produced
	HIonRelease 		= 0.015 		// pH change per 1u reaction (inverse for some reason)
	RateUpLim 			= 0.05 		// Optimal/max rate possible if all conditions are perfect
	FermiChem 			= TRUE		// If the chemical uses the Fermichem reaction mechanics
	PurityMin 			= 0

/datum/chemical_reaction/synthtissue/FermiCreate(datum/reagents/holder, added_volume, added_purity)
	var/datum/reagent/synthtissue/St = holder.has_reagent("synthtissue")
	var/datum/reagent/N = holder.has_reagent("nutriment")
	if(!St)
		return
	if(holder.chem_temp > 320)
		var/temp_ratio = 1-(330 - holder.chem_temp)/10
		holder.remove_reagent(src.id, added_volume*temp_ratio)
	if(St.purity < 1)
		St.volume *= St.purity
		St.purity = 1
	var/amount = CLAMP(0.002, 0, N.volume)
	N.volume -= amount
	St.data["grown_volume"] = St.data["grown_volume"] + added_volume
	St.name = "[initial(St.name)] [round(St.data["grown_volume"], 0.1)]u colony"

/datum/chemical_reaction/styptic_powder
	name = "Styptic Powder"
	id = "styptic_powder"
	results = list("styptic_powder" = 4)
	required_reagents = list("aluminium" = 1, "hydrogen" = 1, "oxygen" = 1, "sacid" = 1)
	mix_message = "The solution yields an astringent powder."

/datum/chemical_reaction/calomel
	name = "Calomel"
	id = "calomel"
	results = list("calomel" = 2)
	required_reagents = list("mercury" = 1, "chlorine" = 1)
	required_temp = 374

/datum/chemical_reaction/potass_iodide
	name = "Potassium Iodide"
	id = "potass_iodide"
	results = list("potass_iodide" = 2)
	required_reagents = list("potassium" = 1, "iodine" = 1)

/datum/chemical_reaction/pen_acid
	name = "Pentetic Acid"
	id = "pen_acid"
	results = list("pen_acid" = 6)
	required_reagents = list("welding_fuel" = 1, "chlorine" = 1, "ammonia" = 1, "formaldehyde" = 1, "sodium" = 1, "cyanide" = 1)

/datum/chemical_reaction/pen_jelly
	name = "Pentetic Jelly"
	id = "pen_jelly"
	results = list("pen_jelly" = 2)
	required_reagents = list("pen_acid" = 1, "slimejelly" = 1)

/datum/chemical_reaction/sal_acid
	name = "Salicyclic Acid"
	id = "sal_acid"
	results = list("sal_acid" = 5)
	required_reagents = list("sodium" = 1, "phenol" = 1, "carbon" = 1, "oxygen" = 1, "sacid" = 1)

/datum/chemical_reaction/oxandrolone
	name = "Oxandrolone"
	id = "oxandrolone"
	results = list("oxandrolone" = 6)
	required_reagents = list("carbon" = 3, "phenol" = 1, "hydrogen" = 1, "oxygen" = 1)

/datum/chemical_reaction/salbutamol
	name = "Salbutamol"
	id = "salbutamol"
	results = list("salbutamol" = 5)
	required_reagents = list("sal_acid" = 1, "lithium" = 1, "aluminium" = 1, "bromine" = 1, "ammonia" = 1)

/datum/chemical_reaction/perfluorodecalin
	name = "Perfluorodecalin"
	id = "perfluorodecalin"
	results = list("perfluorodecalin" = 3)
	required_reagents = list("hydrogen" = 1, "fluorine" = 1, "oil" = 1)
	required_temp = 370
	mix_message = "The mixture rapidly turns into a dense pink liquid."

/datum/chemical_reaction/ephedrine
	name = "Ephedrine"
	id = "ephedrine"
	results = list("ephedrine" = 4)
	required_reagents = list("sugar" = 1, "oil" = 1, "hydrogen" = 1, "diethylamine" = 1)
	mix_message = "The solution fizzes and gives off toxic fumes."

/datum/chemical_reaction/diphenhydramine
	name = "Diphenhydramine"
	id = "diphenhydramine"
	results = list("diphenhydramine" = 4)
	required_reagents = list("oil" = 1, "carbon" = 1, "bromine" = 1, "diethylamine" = 1, "ethanol" = 1)
	mix_message = "The mixture dries into a pale blue powder."

/datum/chemical_reaction/oculine
	name = "Oculine"
	id = "oculine"
	results = list("oculine" = 3)
	required_reagents = list("charcoal" = 1, "carbon" = 1, "hydrogen" = 1)
	mix_message = "The mixture sputters loudly and becomes a pale pink color."

/datum/chemical_reaction/atropine
	name = "Atropine"
	id = "atropine"
	results = list("atropine" = 5)
	required_reagents = list("ethanol" = 1, "acetone" = 1, "diethylamine" = 1, "phenol" = 1, "sacid" = 1)

/datum/chemical_reaction/epinephrine
	name = "Epinephrine"
	id = "epinephrine"
	results = list("epinephrine" = 6)
	required_reagents = list("phenol" = 1, "acetone" = 1, "diethylamine" = 1, "oxygen" = 1, "chlorine" = 1, "hydrogen" = 1)

/datum/chemical_reaction/strange_reagent
	name = "Strange Reagent"
	id = "strange_reagent"
	results = list("strange_reagent" = 3)
	required_reagents = list("omnizine" = 1, "holywater" = 1, "mutagen" = 1)

/datum/chemical_reaction/mannitol
	name = "Mannitol"
	id = "mannitol"
	results = list("mannitol" = 3)
	required_reagents = list("sugar" = 1, "hydrogen" = 1, "water" = 1)
	mix_message = "The solution slightly bubbles, becoming thicker."

/datum/chemical_reaction/mutadone
	name = "Mutadone"
	id = "mutadone"
	results = list("mutadone" = 3)
	required_reagents = list("mutagen" = 1, "acetone" = 1, "bromine" = 1)

/datum/chemical_reaction/neurine
	name = "Neurine"
	id = "neurine"
	results = list("neurine" = 3)
	required_reagents = list("mannitol" = 1, "acetone" = 1, "oxygen" = 1)

/datum/chemical_reaction/antihol
	name = "antihol"
	id = "antihol"
	results = list("antihol" = 3)
	required_reagents = list("ethanol" = 1, "charcoal" = 1, "copper" = 1)

/datum/chemical_reaction/cryoxadone
	name = "Cryoxadone"
	id = "cryoxadone"
	results = list("cryoxadone" = 3)
	required_reagents = list("stable_plasma" = 1, "acetone" = 1, "mutagen" = 1)

/datum/chemical_reaction/pyroxadone
	name = "Pyroxadone"
	id = "pyroxadone"
	results = list("pyroxadone" = 2)
	required_reagents = list("cryoxadone" = 1, "slimejelly" = 1)

/datum/chemical_reaction/clonexadone
	name = "Clonexadone"
	id = "clonexadone"
	results = list("clonexadone" = 2)
	required_reagents = list("cryoxadone" = 1, "sodium" = 1)
	required_catalysts = list("plasma" = 5)

/datum/chemical_reaction/haloperidol
	name = "Haloperidol"
	id = "haloperidol"
	results = list("haloperidol" = 5)
	required_reagents = list("chlorine" = 1, "fluorine" = 1, "aluminium" = 1, "potass_iodide" = 1, "oil" = 1)

/datum/chemical_reaction/bicaridine
	name = "Bicaridine"
	id = "bicaridine"
	results = list("bicaridine" = 3)
	required_reagents = list("carbon" = 1, "oxygen" = 1, "sugar" = 1)

/datum/chemical_reaction/kelotane
	name = "Kelotane"
	id = "kelotane"
	results = list("kelotane" = 2)
	required_reagents = list("carbon" = 1, "silicon" = 1)

/datum/chemical_reaction/antitoxin
	name = "Antitoxin"
	id = "antitoxin"
	results = list("antitoxin" = 3)
	required_reagents = list("nitrogen" = 1, "silicon" = 1, "potassium" = 1)

/datum/chemical_reaction/tricordrazine
	name = "Tricordrazine"
	id = "tricordrazine"
	results = list("tricordrazine" = 3)
	required_reagents = list("bicaridine" = 1, "kelotane" = 1, "antitoxin" = 1)

/datum/chemical_reaction/regen_jelly
	name = "Regenerative Jelly"
	id = "regen_jelly"
	results = list("regen_jelly" = 2)
	required_reagents = list("tricordrazine" = 1, "slimejelly" = 1)

/datum/chemical_reaction/corazone
	name = "Corazone"
	id = "corazone"
	results = list("corazone" = 3)
	required_reagents = list("phenol" = 2, "lithium" = 1)

/datum/chemical_reaction/morphine
	name = "Morphine"
	id = "morphine"
	results = list("morphine" = 2)
	required_reagents = list("carbon" = 2, "hydrogen" = 2, "ethanol" = 1, "oxygen" = 1)
	required_temp = 480

/datum/chemical_reaction/modafinil
	name = "Modafinil"
	id = "modafinil"
	results = list("modafinil" = 5)
	required_reagents = list("diethylamine" = 1, "ammonia" = 1, "phenol" = 1, "acetone" = 1, "sacid" = 1)
	required_catalysts = list("bromine" = 1) // as close to the real world synthesis as possible

/datum/chemical_reaction/psicodine
	name = "Psicodine"
	id = "psicodine"
	results = list("psicodine" = 5)
	required_reagents = list( "mannitol" = 2, "water" = 2, "impedrezene" = 1)
