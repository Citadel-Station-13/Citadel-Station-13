/datum/chemical_reaction/space_drugs
	name = "Space Drugs"
	id = /datum/reagent/drug/space_drugs
	results = list(/datum/reagent/drug/space_drugs = 3)
	required_reagents = list(/datum/reagent/mercury = 1, /datum/reagent/consumable/sugar = 1, /datum/reagent/lithium = 1)

/datum/chemical_reaction/crank
	name = "Crank"
	id = /datum/reagent/drug/crank
	results = list(/datum/reagent/drug/crank = 5)
	required_reagents = list(/datum/reagent/medicine/diphenhydramine = 1, /datum/reagent/ammonia = 1, /datum/reagent/lithium = 1, /datum/reagent/toxin/acid = 1, /datum/reagent/fuel = 1)
	mix_message = "The mixture violently reacts, leaving behind a few crystalline shards."
	required_temp = 390


/datum/chemical_reaction/krokodil
	name = "Krokodil"
	id = /datum/reagent/drug/krokodil
	results = list(/datum/reagent/drug/krokodil = 6)
	required_reagents = list(/datum/reagent/medicine/diphenhydramine = 1, /datum/reagent/medicine/morphine = 1, /datum/reagent/space_cleaner = 1, /datum/reagent/potassium = 1, /datum/reagent/phosphorus = 1, /datum/reagent/fuel = 1)
	mix_message = "The mixture dries into a pale blue powder."
	required_temp = 380

/datum/chemical_reaction/methamphetamine
	name = "methamphetamine"
	id = /datum/reagent/drug/methamphetamine
	results = list(/datum/reagent/drug/methamphetamine = 4)
	required_reagents = list(/datum/reagent/medicine/ephedrine = 1, /datum/reagent/iodine = 1, /datum/reagent/phosphorus = 1, /datum/reagent/hydrogen = 1)
	required_temp = 372
	optimal_temp = 376//Wow this is tight
	overheat_temp = 380
	optimal_ph_min = 6.5
	optimal_ph_max = 7.5
	determin_ph_range = 5
	temp_exponent_factor = 1
	ph_exponent_factor = 1.4
	thermic_constant = 0.1 //exothermic nature is equal to impurty
	H_ion_release = -0.025
	rate_up_lim = 12.5
	purity_min = 0.5 //100u will natrually just dip under this w/ no buffer
	reaction_flags = REACTION_HEAT_ARBITARY //Heating up is arbitary because of submechanics of this reaction.

//The less pure it is, the faster it heats up. tg please don't hate me for making your meth even more dangerous
/datum/chemical_reaction/methamphetamine/reaction_step(datum/equilibrium/reaction, datum/reagents/holder, delta_t, delta_ph, step_reaction_vol)
	var/datum/reagent/meth = holder.get_reagent(/datum/reagent/drug/methamphetamine)
	if(!meth)//First step
		reaction.thermic_mod = (1-delta_ph)*5
		return
	reaction.thermic_mod = (1-meth.purity)*5

/datum/chemical_reaction/methamphetamine/overheated(datum/reagents/holder, datum/equilibrium/equilibrium)
	. = ..()
	temp_meth_explosion(holder, equilibrium.reacted_vol)

/datum/chemical_reaction/methamphetamine/overly_impure(datum/reagents/holder, datum/equilibrium/equilibrium)
	. = ..()
	temp_meth_explosion(holder, equilibrium.reacted_vol)

/datum/chemical_reaction/methamphetamine/reaction_finish(datum/reagents/holder, react_vol)
	var/datum/reagent/meth = holder.get_reagent(/datum/reagent/drug/methamphetamine)
	if(!meth)//Other procs before this can already blow us up
		return ..()
	if(meth.purity < purity_min)
		temp_meth_explosion(holder, react_vol)
		return
	return ..()

//Refactoring of explosions is coming later, this is till then so it still explodes
/datum/chemical_reaction/methamphetamine/proc/temp_meth_explosion(datum/reagents/holder, explode_vol)
	var/power = 5 + round(explode_vol/12, 1) //meth strengthdiv is 12
	if(power <= 0)
		return
	var/turf/T = get_turf(holder.my_atom)
	var/inside_msg
	if(ismob(holder.my_atom))
		var/mob/M = holder.my_atom
		inside_msg = " inside [ADMIN_LOOKUPFLW(M)]"
	var/lastkey = holder.my_atom.fingerprintslast
	var/touch_msg = "N/A"
	if(lastkey)
		var/mob/toucher = get_mob_by_key(lastkey)
		touch_msg = "[ADMIN_LOOKUPFLW(toucher)]"
	if(!istype(holder.my_atom, /obj/machinery/plumbing)) //excludes standard plumbing equipment from spamming admins with this shit
		message_admins("Reagent explosion reaction occurred at [ADMIN_VERBOSEJMP(T)][inside_msg]. Last Fingerprint: [touch_msg].")
	log_game("Reagent explosion reaction occurred at [AREACOORD(T)]. Last Fingerprint: [lastkey ? lastkey : "N/A"]." )
	var/datum/effect_system/reagents_explosion/e = new()
	e.set_up(power, T, 0, 0)
	e.start()
	holder.clear_reagents()

/datum/chemical_reaction/bath_salts
	name = "bath_salts"
	id = /datum/reagent/drug/bath_salts
	results = list(/datum/reagent/drug/bath_salts = 7)
	required_reagents = list(/datum/reagent/toxin/bad_food = 1, /datum/reagent/saltpetre = 1, /datum/reagent/consumable/nutriment = 1, /datum/reagent/space_cleaner = 1, /datum/reagent/consumable/enzyme = 1, /datum/reagent/consumable/tea = 1, /datum/reagent/mercury = 1)
	required_temp = 374

/datum/chemical_reaction/aranesp
	name = "aranesp"
	id = /datum/reagent/drug/aranesp
	results = list(/datum/reagent/drug/aranesp = 3)
	required_reagents = list(/datum/reagent/medicine/epinephrine = 1, /datum/reagent/medicine/atropine = 1, /datum/reagent/medicine/morphine = 1)

/datum/chemical_reaction/happiness
	name = "Happiness"
	id = /datum/reagent/drug/happiness
	results = list(/datum/reagent/drug/happiness = 4)
	required_reagents = list(/datum/reagent/nitrous_oxide = 2, /datum/reagent/medicine/epinephrine = 1, /datum/reagent/consumable/ethanol = 1)
	required_catalysts = list(/datum/reagent/toxin/plasma = 5)

/datum/chemical_reaction/skooma
	name = "skooma"
	id = /datum/reagent/drug/skooma
	results = list(/datum/reagent/drug/skooma = 2, /datum/reagent/consumable/ethanol/moonshine = 4, /datum/reagent/consumable/sugar = 4)
	required_temp = 280
	is_cold_recipe = TRUE
	required_reagents = list(/datum/reagent/moonsugar = 10, /datum/reagent/medicine/morphine = 5)

/datum/chemical_reaction/skoomarevert
	name = "skoomarevert"
	id = "skoomarevert"
	results = list(/datum/reagent/moonsugar = 1, /datum/reagent/medicine/morphine = 2.5)
	required_temp = 315 //a little above normal body temperature
	required_reagents = list(/datum/reagent/drug/skooma = 1)

/datum/chemical_reaction/aphro
	name = "crocin"
	id = /datum/reagent/drug/aphrodisiac
	results = list(/datum/reagent/drug/aphrodisiac = 6)
	required_reagents = list(/datum/reagent/carbon = 2, /datum/reagent/hydrogen = 2, /datum/reagent/oxygen = 2, /datum/reagent/water = 1)
	required_temp = 400
	mix_message = "The mixture boils off a pink vapor..."//The water boils off, leaving the crocin

/datum/chemical_reaction/aphroplus
	name = "hexacrocin"
	id = /datum/reagent/drug/aphrodisiacplus
	results = list(/datum/reagent/drug/aphrodisiacplus = 1)
	required_reagents = list(/datum/reagent/drug/aphrodisiac = 6, /datum/reagent/phenol = 1)
	required_temp = 400
	mix_message = "The mixture rapidly condenses and darkens in color..."

/datum/chemical_reaction/anaphro
	name = "camphor"
	id = /datum/reagent/drug/anaphrodisiac
	results = list(/datum/reagent/drug/anaphrodisiac = 6)
	required_reagents = list(/datum/reagent/carbon = 2, /datum/reagent/hydrogen = 2, /datum/reagent/oxygen = 2, /datum/reagent/sulfur = 1)
	required_temp = 400
	mix_message = "The mixture boils off a yellow, smelly vapor..."//Sulfur burns off, leaving the camphor

/datum/chemical_reaction/anaphroplus
	name = "hexacamphor"
	id = /datum/reagent/drug/anaphrodisiacplus
	results = list(/datum/reagent/drug/anaphrodisiacplus = 1)
	required_reagents = list(/datum/reagent/drug/anaphrodisiac = 6, /datum/reagent/acetone = 1)
	required_temp = 400
	mix_message = "The mixture thickens and heats up slighty..."
