/datum/chemical_reaction/fermi/cruderefine
	name = "Crude oil refining"
	id = "crudefine"
	results = list("asphalt" = 0.3, "fueloil" = 0.3, "diesel" = 0.2, "kerosene" = 0.1, "naptha" = 0.05, "butane" = 0.05)
	required_reagents = list("crudeoil" = 5, "water" = "1" )
	mix_message = "the mixture splits into fractions."
	required_temp = 1
	required_container = /datum/component/plumbing/reaction_chamber
	//FermiChem vars:
	OptimalTempMin 		= 900 		// Lower area of bell curve for determining heat based rate reactions
	OptimalTempMax 		= 2300 		// Upper end for above
	ExplodeTemp 		= 2800 		// Temperature at which reaction explodes
	OptimalpHMin 		= 5.5 		// Lowest value of pH determining pH a 1 value for pH based rate reactions (Plateu phase)
	OptimalpHMax 		= 7 		// Higest value for above
	ReactpHLim 			= 0.1 		// How far out pH wil react, giving impurity place (Exponential phase)
	CatalystFact 		= 0 		// How much the catalyst affects the reaction (0 = no catalyst)
	CurveSharpT 		= 8 		// How sharp the temperature exponential curve is (to the power of value)
	CurveSharppH 		= 9 		// How sharp the pH exponential curve is (to the power of value)
	ThermicConstant		= 10 		// Temperature change per 1u produced
	HIonRelease 		= -0.02 		// pH change per 1u reaction (inverse for some reason)
	RateUpLim 			= 1 		// Optimal/max rate possible if all conditions are perfect
	FermiChem 			= TRUE		// If the chemical uses the Fermichem reaction mechanics
	PurityMin 			= 0.2

/datum/chemical_reaction/fermi/shalerefine
	name = "Shale oil refining"
	id = "shalefine"
	results = list("asphalt" = 0.35, "fueloil" = 0.35, "diesel" = 0.2, "kerosene" = 0.05, "naptha" = 0.05)
	required_reagents = list("shaleoil" = 5, "water" = "1" )
	mix_message = "the mixture splits into fractions."
	required_temp = 1
	required_container = /datum/component/plumbing/reaction_chamber
	//FermiChem vars:
	OptimalTempMin 		= 950 		// Lower area of bell curve for determining heat based rate reactions
	OptimalTempMax 		= 2700 		// Upper end for above
	ExplodeTemp 		= 3000 		// Temperature at which reaction explodes
	OptimalpHMin 		= 5.5 		// Lowest value of pH determining pH a 1 value for pH based rate reactions (Plateu phase)
	OptimalpHMax 		= 7 		// Higest value for above
	ReactpHLim 			= 0.1 		// How far out pH wil react, giving impurity place (Exponential phase)
	CatalystFact 		= 0 		// How much the catalyst affects the reaction (0 = no catalyst)
	CurveSharpT 		= 8 		// How sharp the temperature exponential curve is (to the power of value)
	CurveSharppH 		= 9 		// How sharp the pH exponential curve is (to the power of value)
	ThermicConstant		= 10 		// Temperature change per 1u produced
	HIonRelease 		= -0.02 		// pH change per 1u reaction
	RateUpLim 			= 1 		// Optimal/max rate possible if all conditions are perfect
	FermiChem 			= TRUE		// If the chemical uses the Fermichem reaction mechanics
	PurityMin 			= 0.2

/datum/chemical_reaction/fermi/sandrefine
	name = "Tar sand oil refining"
	id = "sandfine"
	results = list("asphalt" = 0.3, "fueloil" = 0.4, "diesel" = 0.3)
	required_reagents = list("lightsandoil" = 5, "water" = "1" )
	mix_message = "the mixture splits into fractions."
	required_temp = 1
	required_container = /datum/component/plumbing/reaction_chamber
	//FermiChem vars:
	OptimalTempMin 		= 1100 		// Lower area of bell curve for determining heat based rate reactions
	OptimalTempMax 		= 3200 		// Upper end for above
	ExplodeTemp 		= 3700 		// Temperature at which reaction explodes
	OptimalpHMin 		= 5.5 		// Lowest value of pH determining pH a 1 value for pH based rate reactions (Plateu phase)
	OptimalpHMax 		= 7 		// Higest value for above
	ReactpHLim 			= 0.1 		// How far out pH wil react, giving impurity place (Exponential phase)
	CatalystFact 		= 0 		// How much the catalyst affects the reaction (0 = no catalyst)
	CurveSharpT 		= 8 		// How sharp the temperature exponential curve is (to the power of value)
	CurveSharppH 		= 9 		// How sharp the pH exponential curve is (to the power of value)
	ThermicConstant		= 10 		// Temperature change per 1u produced
	HIonRelease 		= -0.02 		// pH change per 1u reaction
	RateUpLim 			= 1 		// Optimal/max rate possible if all conditions are perfect
	FermiChem 			= TRUE		// If the chemical uses the Fermichem reaction mechanics
	PurityMin 			= 0.2