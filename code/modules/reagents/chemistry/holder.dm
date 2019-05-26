im
/proc/build_chemical_reagent_list()
	//Chemical Reagents - Initialises all /datum/reagent into a list indexed by reagent id

	if(GLOB.chemical_reagents_list)
		return

	var/paths = subtypesof(/datum/reagent)
	GLOB.chemical_reagents_list = list()

	for(var/path in paths)
		var/datum/reagent/D = new path()
		GLOB.chemical_reagents_list[D.id] = D

/proc/build_chemical_reactions_list()
	//Chemical Reactions - Initialises all /datum/chemical_reaction into a list
	// It is filtered into multiple lists within a list.
	// For example:
	// chemical_reaction_list["plasma"] is a list of all reactions relating to plasma

	if(GLOB.chemical_reactions_list)
		return

	var/paths = subtypesof(/datum/chemical_reaction)
	GLOB.chemical_reactions_list = list()

	for(var/path in paths)

		var/datum/chemical_reaction/D = new path()
		var/list/reaction_ids = list()

		if(D.required_reagents && D.required_reagents.len)
			for(var/reaction in D.required_reagents)
				reaction_ids += reaction

		// Create filters based on each reagent id in the required reagents list
		for(var/id in reaction_ids)
			if(!GLOB.chemical_reactions_list[id])
				GLOB.chemical_reactions_list[id] = list()
			GLOB.chemical_reactions_list[id] += D
			break // Don't bother adding ourselves to other reagent ids, it is redundant

///////////////////////////////////////////////////////////////////////////////////

/datum/reagents
	var/list/datum/reagent/reagent_list = new/list()
	var/total_volume = 0
	var/maximum_volume = 100
	var/atom/my_atom = null
	var/chem_temp = 150
	var/pH = REAGENT_NORMAL_PH//This is definately 7, right?
	var/overallPurity = 1
	var/last_tick = 1
	var/addiction_tick = 1
	var/list/datum/reagent/addiction_list = new/list()
	var/reagents_holder_flags
	var/targetVol = 0
	var/reactedVol = 0
	var/fermiIsReacting = FALSE
	var/fermiReactID = null

/datum/reagents/New(maximum=100)
	maximum_volume = maximum

	//I dislike having these here but map-objects are initialised before world/New() is called. >_>
	if(!GLOB.chemical_reagents_list)
		build_chemical_reagent_list()
	if(!GLOB.chemical_reactions_list)
		build_chemical_reactions_list()

/datum/reagents/Destroy()
	. = ..()
	var/list/cached_reagents = reagent_list
	for(var/reagent in cached_reagents)
		var/datum/reagent/R = reagent
		qdel(R)
	cached_reagents.Cut()
	cached_reagents = null
	if(my_atom && my_atom.reagents == src)
		my_atom.reagents = null
	my_atom = null

// Used in attack logs for reagents in pills and such
/datum/reagents/proc/log_list()
	if(!length(reagent_list))
		return "no reagents"

	var/list/data = list()
	for(var/r in reagent_list) //no reagents will be left behind
		var/datum/reagent/R = r
		data += "[R.id] ([round(R.volume, 0.1)]u)"
		//Using IDs because SOME chemicals (I'm looking at you, chlorhydrate-beer) have the same names as other chemicals.
	return english_list(data)

/datum/reagents/proc/remove_any(amount = 1)
	var/list/cached_reagents = reagent_list
	var/total_transfered = 0
	var/current_list_element = 1

	current_list_element = rand(1, cached_reagents.len)

	while(total_transfered != amount)
		if(total_transfered >= amount)
			break
		if(total_volume <= 0 || !cached_reagents.len)
			break

		if(current_list_element > cached_reagents.len)
			current_list_element = 1

		var/datum/reagent/R = cached_reagents[current_list_element]
		remove_reagent(R.id, 1)

		current_list_element++
		total_transfered++
		update_total()

	handle_reactions()
	return total_transfered

/datum/reagents/proc/remove_all(amount = 1)
	var/list/cached_reagents = reagent_list
	if(total_volume > 0)
		var/part = amount / total_volume
		for(var/reagent in cached_reagents)
			var/datum/reagent/R = reagent
			remove_reagent(R.id, R.volume * part)

		update_total()
		handle_reactions()
		//pH = REAGENT_NORMAL_PH Maybe unnessicary?
		return amount

/datum/reagents/proc/get_master_reagent_name()
	var/list/cached_reagents = reagent_list
	var/name
	var/max_volume = 0
	for(var/reagent in cached_reagents)
		var/datum/reagent/R = reagent
		if(R.volume > max_volume)
			max_volume = R.volume
			name = R.name

	return name

/datum/reagents/proc/get_master_reagent_id()
	var/list/cached_reagents = reagent_list
	var/id
	var/max_volume = 0
	for(var/reagent in cached_reagents)
		var/datum/reagent/R = reagent
		if(R.volume > max_volume)
			max_volume = R.volume
			id = R.id

	return id

/datum/reagents/proc/get_master_reagent()
	var/list/cached_reagents = reagent_list
	var/datum/reagent/master
	var/max_volume = 0
	for(var/reagent in cached_reagents)
		var/datum/reagent/R = reagent
		if(R.volume > max_volume)
			max_volume = R.volume
			master = R

	return master

/datum/reagents/proc/trans_to(obj/target, amount=1, multiplier=1, preserve_data=1, no_react = 0)//if preserve_data=0, the reagents data will be lost. Usefull if you use data for some strange stuff and don't want it to be transferred.
	var/list/cached_reagents = reagent_list
	if(!target || !total_volume)
		return
	if(amount < 0)
		return

	var/datum/reagents/R
	if(istype(target, /datum/reagents))
		R = target
	else
		if(!target.reagents)
			return
		R = target.reagents
	amount = min(min(amount, src.total_volume), R.maximum_volume-R.total_volume)
	var/part = amount / src.total_volume
	var/trans_data = null
	for(var/reagent in cached_reagents)
		var/datum/reagent/T = reagent
		var/transfer_amount = T.volume * part
		if(preserve_data)
			trans_data = copy_data(T)

			//fermichem Added ph TODO: add T.purity
		R.add_reagent(T.id, transfer_amount * multiplier, trans_data, chem_temp, T.purity, pH, no_react = TRUE) //we only handle reaction after every reagent has been transfered.
		//R.add_reagent(T.id, transfer_amount * multiplier, trans_data, chem_temp, pH, T.purity, no_react = TRUE) //we only handle reaction after every reagent has been transfered.
		remove_reagent(T.id, transfer_amount)

	update_total()
	R.update_total()
	if(!no_react)
		R.handle_reactions()
		src.handle_reactions()
	return amount

/datum/reagents/proc/copy_to(obj/target, amount=1, multiplier=1, preserve_data=1)
	var/list/cached_reagents = reagent_list
	if(!target || !total_volume)
		return

	var/datum/reagents/R
	if(istype(target, /datum/reagents))
		R = target
	else
		if(!target.reagents)
			return
		R = target.reagents

	if(amount < 0)
		return
	amount = min(min(amount, total_volume), R.maximum_volume-R.total_volume)
	var/part = amount / total_volume
	var/trans_data = null
	for(var/reagent in cached_reagents)
		var/datum/reagent/T = reagent
		var/copy_amount = T.volume * part
		if(preserve_data)
			trans_data = T.data
		R.add_reagent(T.id, copy_amount * multiplier, trans_data)

	src.update_total()
	R.update_total()
	R.handle_reactions()
	src.handle_reactions()
	return amount

/datum/reagents/proc/trans_id_to(obj/target, reagent, amount=1, preserve_data=1)//Not sure why this proc didn't exist before. It does now! /N
	var/list/cached_reagents = reagent_list
	if (!target)
		return
	if (!target.reagents || src.total_volume<=0 || !src.get_reagent_amount(reagent))
		return
	if(amount < 0)
		return

	var/datum/reagents/R = target.reagents
	if(src.get_reagent_amount(reagent)<amount)
		amount = src.get_reagent_amount(reagent)
	amount = min(amount, R.maximum_volume-R.total_volume)
	var/trans_data = null
	for (var/CR in cached_reagents)
		var/datum/reagent/current_reagent = CR
		if(current_reagent.id == reagent)
			if(preserve_data)
				trans_data = current_reagent.data
			R.add_reagent(current_reagent.id, amount, trans_data, chem_temp, current_reagent.purity, pH, no_react = TRUE) //Fermichem edit TODO: add purity
			//R.add_reagent(current_reagent.id, amount, trans_data, src.chem_temp, pH, current_reagent.purity, no_react = TRUE) //Fermichem edit
			remove_reagent(current_reagent.id, amount, 1)
			break

	src.update_total()
	R.update_total()
	R.handle_reactions()
	return amount

/datum/reagents/proc/metabolize(mob/living/carbon/C, can_overdose = FALSE, liverless = FALSE)
	var/list/cached_reagents = reagent_list
	var/list/cached_addictions = addiction_list
	if(C)
		expose_temperature(C.bodytemperature, 0.25)
	var/need_mob_update = 0
	for(var/reagent in cached_reagents)
		var/datum/reagent/R = reagent
		if(QDELETED(R.holder))
			continue
		if(liverless && !R.self_consuming) //need to be metabolized
			continue
		if(!C)
			C = R.holder.my_atom
		if(C && R)
			if(C.reagent_check(R) != 1)
				if(can_overdose)
					if(R.overdose_threshold)
						if(R.volume >= R.overdose_threshold && !R.overdosed)
							R.overdosed = 1
							need_mob_update += R.overdose_start(C)
					if(R.addiction_threshold)
						if(R.volume >= R.addiction_threshold && !is_type_in_list(R, cached_addictions))
							var/datum/reagent/new_reagent = new R.type()
							cached_addictions.Add(new_reagent)
					if(R.overdosed)
						need_mob_update += R.overdose_process(C)
					if(is_type_in_list(R,cached_addictions))
						for(var/addiction in cached_addictions)
							var/datum/reagent/A = addiction
							if(istype(R, A))
								A.addiction_stage = -15 // you're satisfied for a good while.
				need_mob_update += R.on_mob_life(C)

	if(can_overdose)
		if(addiction_tick == 6)
			addiction_tick = 1
			for(var/addiction in cached_addictions)
				var/datum/reagent/R = addiction
				if(C && R)
					R.addiction_stage++
					if(1 <= R.addiction_stage && R.addiction_stage <= R.addiction_stage1_end)
						need_mob_update += R.addiction_act_stage1(C)
					else if(R.addiction_stage1_end <= R.addiction_stage && R.addiction_stage <= R.addiction_stage2_end)
						need_mob_update += R.addiction_act_stage2(C)
					else if(R.addiction_stage2_end <= R.addiction_stage && R.addiction_stage <= R.addiction_stage3_end)
						need_mob_update += R.addiction_act_stage3(C)
					else if(R.addiction_stage3_end <= R.addiction_stage && R.addiction_stage <= R.addiction_stage4_end)
						need_mob_update += R.addiction_act_stage4(C)
					else if(R.addiction_stage4_end <= R.addiction_stage)
						to_chat(C, "<span class='notice'>You feel like you've gotten over your need for [R.name].</span>")
						SEND_SIGNAL(C, COMSIG_CLEAR_MOOD_EVENT, "[R.id]_addiction")
						cached_addictions.Remove(R)
		addiction_tick++
	if(C && need_mob_update) //some of the metabolized reagents had effects on the mob that requires some updates.
		C.updatehealth()
		C.update_canmove()
		C.update_stamina()
	update_total()


/datum/reagents/proc/set_reacting(react = TRUE)
	if(react)
		reagents_holder_flags &= ~(REAGENT_NOREACT)
	else
		reagents_holder_flags |= REAGENT_NOREACT

/datum/reagents/proc/conditional_update_move(atom/A, Running = 0)
	var/list/cached_reagents = reagent_list
	for(var/reagent in cached_reagents)
		var/datum/reagent/R = reagent
		R.on_move (A, Running)
	update_total()

/datum/reagents/proc/conditional_update(atom/A)
	var/list/cached_reagents = reagent_list
	for(var/reagent in cached_reagents)
		var/datum/reagent/R = reagent
		R.on_update (A)
	update_total()

//beaker check proc,
/datum/reagents/proc/beaker_check(atom/A)
	if(istype(A, /obj/item/reagent_containers/glass/beaker/meta))
		return
	if((A.type == /obj/item/reagent_containers/glass/beaker/plastic))
		if(chem_temp > 444)//assuming polypropylene
			var/list/seen = viewers(5, get_turf(A))
			var/iconhtml = icon2html(A, seen)
			for(var/mob/M in seen)
				to_chat(M, "<span class='notice'>[iconhtml] \The [my_atom]'s melts from the temperature!</span>")
				playsound(get_turf(A), 'sound/FermiChem/heatmelt.ogg', 80, 1)

			qdel(A)
			return
	else if(istype(A, /obj/item/reagent_containers/glass) && ((pH < 0.5) || (pH > 13.5)))//maybe make it higher? Though..Hmm!
		var/list/seen = viewers(5, get_turf(A))
		var/iconhtml = icon2html(A, seen)
		for(var/mob/M in seen)
			to_chat(M, "<span class='notice'>[iconhtml] \The [my_atom]'s melts from the extreme pH!</span>")
			playsound(get_turf(A), 'sound/FermiChem/acidmelt.ogg', 80, 1)
		qdel(A)
	return



/datum/reagents/proc/handle_reactions()//HERE EDIT HERE THE MAIN REACTION FERMICHEMS ASSEMBLE! I hope rp is similar
	if(fermiIsReacting == TRUE)
		//reagents_holder_flags |= REAGENT_NOREACT unsure if this is needed
		return
	var/list/cached_reagents = reagent_list //a list of the reagents?
	var/list/cached_reactions = GLOB.chemical_reactions_list //a list of the whole reactions?
	var/datum/cached_my_atom = my_atom //It says my atom, but I didn't bring one with me!!
	if(reagents_holder_flags & REAGENT_NOREACT) //Not sure on reagents_holder_flags, but I think it checks to see if theres a reaction with current stuff.
		return //Yup, no reactions here. No siree.

	var/reaction_occurred = 0 // checks if reaction, binary variable
	var/continue_reacting = FALSE //Helps keep track what kind of reaction is occuring; standard or fermi.

	do //What does do do in byond? It sounds very redundant? is it a while loop?
		var/list/possible_reactions = list() //init list
		reaction_occurred = 0 // sets it back to 0?
		for(var/reagent in cached_reagents) //for reagent in beaker/holder
			var/datum/reagent/R = reagent //check to make sure that reagent is there for the reaction list
			for(var/reaction in cached_reactions[R.id]) // Was a big list but now it should be smaller since we filtered it with our reagent id
				if(!reaction)
					continue

				var/datum/chemical_reaction/C = reaction
				var/list/cached_required_reagents = C.required_reagents
				var/total_required_reagents = cached_required_reagents.len
				var/total_matching_reagents = 0
				var/list/cached_required_catalysts = C.required_catalysts
				var/total_required_catalysts = cached_required_catalysts.len
				var/total_matching_catalysts= 0
				var/matching_container = 0
				var/matching_other = 0
				var/required_temp = C.required_temp
				var/is_cold_recipe = C.is_cold_recipe
				var/meets_temp_requirement = 0
				var/has_special_react = C.special_react
				var/can_special_react = 0


				for(var/B in cached_required_reagents)
					if(!has_reagent(B, cached_required_reagents[B]))
						break
					total_matching_reagents++
				for(var/B in cached_required_catalysts)
					if(!has_reagent(B, cached_required_catalysts[B]))
						break
					total_matching_catalysts++
				if(cached_my_atom)
					if(!C.required_container)
						matching_container = 1

					else
						if(cached_my_atom.type == C.required_container)//if the suspected container is a container
							matching_container = 1
					if (isliving(cached_my_atom) && !C.mob_react) //Makes it so certain chemical reactions don't occur in mobs
						return
					if(!C.required_other)//Checks for other things required
						matching_other = 1//binary check passes

					else if(istype(cached_my_atom, /obj/item/slime_extract))//if the object is a slime_extract. This might be complicated as to not break them via fermichem
						var/obj/item/slime_extract/M = cached_my_atom

						if(M.Uses > 0) // added a limit to slime cores -- Muskets requested this
							matching_other = 1
				else
					if(!C.required_container)//I'm not sure why this is here twice, I think if it's not a beaker? Oh, cyro.
						matching_container = 1
					if(!C.required_other)
						matching_other = 1

				//FermiChem
				/*
				if (chem_temp > C.ExplodeTemp)//Check to see if reaction is too hot!
					if (C.FermiExplode == TRUE)
						//To be added!

				TODO: make plastic beakers melt at 447 kalvin, all others at ~850 and meta-material never break.
				*/

				if(required_temp == 0 || (is_cold_recipe && chem_temp <= required_temp) || (!is_cold_recipe && chem_temp >= required_temp))//Temperature check!!
					meets_temp_requirement = 1//binary pass

				if(!has_special_react || C.check_special_react(src))
					can_special_react = 1

				if(total_matching_reagents == total_required_reagents && total_matching_catalysts == total_required_catalysts && matching_container && matching_other && meets_temp_requirement && can_special_react)
					possible_reactions  += C

		if(possible_reactions.len)//does list exist?
			var/datum/chemical_reaction/selected_reaction = possible_reactions[1]
			//select the reaction with the most extreme temperature requirements
			for(var/V in possible_reactions)//why V, surely that would indicate volume? V is the reaction potential.
				var/datum/chemical_reaction/competitor = V //competitor? I think this is theres two of them. Troubling..!
				if(selected_reaction.is_cold_recipe) //if there are no recipe conflicts, everything in possible_reactions will have this same value for is_cold_reaction. warranty void if assumption not met.
					if(competitor.required_temp <= selected_reaction.required_temp)//only returns with lower if reaction "is cold" var.
						selected_reaction = competitor
				else
					if(competitor.required_temp >= selected_reaction.required_temp) //will return with the hotter reacting first.
						selected_reaction = competitor
			var/list/cached_required_reagents = selected_reaction.required_reagents//update reagents list
			var/list/cached_results = selected_reaction.results//resultant chemical list
			var/special_react_result = selected_reaction.check_special_react(src)
			var/list/multiplier = INFINITY //Wat

			//Splits reactions into two types; FermiChem is advanced reaction mechanics, Other is default reaction.
			//FermiChem relies on two additional properties; pH and impurity
			//Temperature plays into a larger role too.
			//BRANCH HERE
			//if(selected_reaction)
			var/datum/chemical_reaction/C = selected_reaction

			if (C.FermiChem == TRUE && !continue_reacting)
				message_admins("FermiChem Proc'd")
				for(var/B in cached_required_reagents)
					multiplier = min(multiplier, round((get_reagent_amount(B) / cached_required_reagents[B]), 0.01))
				for(var/P in selected_reaction.results)
					targetVol = cached_results[P]*multiplier

					//message_admins("FermiChem target volume: [targetVol]")

				if( (chem_temp <= C.ExplodeTemp) && (chem_temp >= C.OptimalTempMin))
					if( (pH >= (C.OptimalpHMin - C.ReactpHLim)) && (pH <= (C.OptimalpHMax + C.ReactpHLim)) )//To prevent pointless reactions
						//if (reactedVol < targetVol)
						if (fermiIsReacting == TRUE)
							return 0
						else
							//reactedVol = FermiReact(selected_reaction, chem_temp, pH, multiplier, reactedVol, targetVol, cached_required_reagents, cached_results)
							//selected_reaction.on_reaction(src, my_atom, multiplier)
							START_PROCESSING(SSprocessing, src)
							//message_admins("FermiChem processing started")
							selected_reaction.on_reaction(src, my_atom, multiplier)
							fermiIsReacting = TRUE
							fermiReactID = selected_reaction
							reaction_occurred = 1
				if (chem_temp > C.ExplodeTemp)
					var/datum/chemical_reaction/fermi/Ferm = selected_reaction
					Ferm.FermiExplode(src, my_atom, volume = total_volume, temp = chem_temp, pH = pH)
					return 0
				else
					return 0


				SSblackbox.record_feedback("tally", "Fermi_chemical_reaction", reactedVol, C.id)//log

		//Standard reaction mechanics:
			else

				for(var/B in cached_required_reagents) //
					multiplier = min(multiplier, round((get_reagent_amount(B) / cached_required_reagents[B]), 0.01))//a simple one over the other? (Is this for multiplying end product? Useful for toxinsludge buildup)

				for(var/B in cached_required_reagents)
					remove_reagent(B, (multiplier * cached_required_reagents[B]), safety = 1)//safety? removes reagents from beaker using remove function.

				for(var/P in selected_reaction.results)//Not sure how this works, what is selected_reaction.results?
					multiplier = max(multiplier, 1) //this shouldnt happen ...
					SSblackbox.record_feedback("tally", "chemical_reaction", cached_results[P]*multiplier, P)//log
					add_reagent(P, cached_results[P]*multiplier, null, chem_temp)//add reagent function!! I THINK I can do this:


				var/list/seen = viewers(4, get_turf(my_atom))//Sound and sight checkers
				var/iconhtml = icon2html(cached_my_atom, seen)
				if(cached_my_atom)
					if(!ismob(cached_my_atom)) // No bubbling mobs
						if(selected_reaction.mix_sound)
							playsound(get_turf(cached_my_atom), selected_reaction.mix_sound, 80, 1)

						for(var/mob/M in seen)
							to_chat(M, "<span class='notice'>[iconhtml] [selected_reaction.mix_message]</span>")

					if(istype(cached_my_atom, /obj/item/slime_extract))//if there's an extract and it's used up.
						var/obj/item/slime_extract/ME2 = my_atom
						ME2.Uses--
						if(ME2.Uses <= 0) // give the notification that the slime core is dead
							for(var/mob/M in seen)
								to_chat(M, "<span class='notice'>[iconhtml] \The [my_atom]'s power is consumed in the reaction.</span>")
								ME2.name = "used slime extract"
								ME2.desc = "This extract has been used up."

				selected_reaction.on_reaction(src, multiplier, special_react_result)
				reaction_occurred = 1
				continue_reacting = TRUE

	while(reaction_occurred)//while do nothing?
	update_total()//Don't know waht this does.
	return 0//end!

/datum/reagents/process()
	var/datum/chemical_reaction/fermi/C = fermiReactID

	var/list/cached_required_reagents = C.required_reagents//update reagents list
	var/list/cached_results = C.results//resultant chemical list
	var/multiplier = INFINITY
	//var/special_react_result = C.check_special_react(src) Only add if I add in the fermi-izer chem

	//message_admins("updating targetVol from [targetVol]")
	for(var/B in cached_required_reagents) //
		multiplier = min(multiplier, round((get_reagent_amount(B) / cached_required_reagents[B]), 0.01))
		message_admins("Multi:[multiplier],( reag ammount:[get_reagent_amount(B)] / req reag:[cached_required_reagents[B]]")
		//multiplier*=10
	if (multiplier == 0)
		STOP_PROCESSING(SSprocessing, src)
		fermiIsReacting = FALSE
		//message_admins("FermiChem STOPPED due to reactant removal! Reacted vol: [reactedVol] of [targetVol]")
		reactedVol = 0
		targetVol = 0
		handle_reactions()
		update_total()
		//var/datum/reagent/fermi/Ferm  = GLOB.chemical_reagents_list[C.id]
		C.FermiFinish(src, my_atom, multiplier)
		//C.on_reaction(src, multiplier, special_react_result)
		//Reaction sounds and words
		playsound(get_turf(my_atom), C.mix_sound, 80, 1)
		var/list/seen = viewers(5, get_turf(my_atom))//Sound and sight checkers
		var/iconhtml = icon2html(my_atom, seen)
		for(var/mob/M in seen)
			to_chat(M, "<span class='notice'>[iconhtml] [C.mix_message]</span>")
		return
	for(var/P in cached_results)
		targetVol = cached_results[P]*multiplier

	//message_admins("to [targetVol]")

	if (fermiIsReacting == FALSE)
		//message_admins("THIS SHOULD NEVER APPEAR!")
		CRASH("Fermi has refused to stop reacting even though we asked her nicely.")

	if (chem_temp > C.OptimalTempMin && fermiIsReacting == TRUE)//To prevent pointless reactions
		if (reactedVol < targetVol)
			reactedVol = FermiReact(fermiReactID, chem_temp, pH, reactedVol, targetVol, cached_required_reagents, cached_results, multiplier)
			//message_admins("FermiChem tick activated started, Reacted vol: [reactedVol] of [targetVol]")
		else
			STOP_PROCESSING(SSprocessing, src)
			fermiIsReacting = FALSE
			//message_admins("FermiChem STOPPED due to volume reached! Reacted vol: [reactedVol] of [targetVol]")
			reactedVol = 0
			targetVol = 0
			handle_reactions()
			update_total()
			//var/datum/reagent/fermi/Ferm  = GLOB.chemical_reagents_list[C.id]
			C.FermiFinish(src, my_atom, multiplier)
			//C.on_reaction(src, multiplier, special_react_result)
			//Reaction sounds and words
			playsound(get_turf(my_atom), C.mix_sound, 80, 1)
			var/list/seen = viewers(5, get_turf(my_atom))//Sound and sight checkers
			var/iconhtml = icon2html(my_atom, seen)
			for(var/mob/M in seen)
				to_chat(M, "<span class='notice'>[iconhtml] [C.mix_message]</span>")
			return
	else
		STOP_PROCESSING(SSprocessing, src)
		//message_admins("FermiChem STOPPED due to temperature! Reacted vol: [reactedVol] of [targetVol]")
		fermiIsReacting = FALSE
		reactedVol = 0
		targetVol = 0
		handle_reactions()
		update_total()
		//var/datum/reagent/fermi/Ferm  = GLOB.chemical_reagents_list[C.id]
		C.FermiFinish(src, my_atom, multiplier)
		//C.on_reaction(src, multiplier, special_react_result)
		//Reaction sounds and words
		playsound(get_turf(my_atom), C.mix_sound, 80, 1)
		var/list/seen = viewers(5, get_turf(my_atom))//Sound and sight checkers
		var/iconhtml = icon2html(my_atom, seen)
		for(var/mob/M in seen)
			to_chat(M, "<span class='notice'>[iconhtml] [C.mix_message]</span>")
		return

	//handle_reactions()

/datum/reagents/proc/FermiReact(selected_reaction, cached_temp, pH, reactedVol, targetVol, cached_required_reagents, cached_results, multiplier)
	var/datum/chemical_reaction/fermi/C = selected_reaction
	var/deltaT = 0
	var/deltapH = 0
	var/stepChemAmmount = 0
	//var/ammoReacted = 0
	//get purity from combined beaker reactant purities HERE.
	var/purity = 1
	//var/tempVol = totalVol

	message_admins("multiplier [multiplier], target vol:[targetVol], rate lim: [C.RateUpLim], reactedVol: [reactedVol]")
	//Begin Parse

	//WARNING("Purity precalc: [overallPurity]")
	//update_holder_purity(C)//updates holder's purity
	//WARNING("Purity postcalc: [overallPurity]")

	//Check extremes first
	if (cached_temp > C.ExplodeTemp)
		//go to explode proc
		//message_admins("temperature is over limit: [C.ExplodeTemp] Current temperature: [cached_temp]")
		C.FermiExplode(src, my_atom, (reactedVol+targetVol), cached_temp, pH)
		return

	if (pH > 14)
		pH = 14
		//message_admins("pH is lover limit, cur pH: [pH]")
	else if (pH < 0)
		pH = 0
		//Create chemical sludge eventually(for now just destroy the beaker I guess?)
		//TODO Strong acids eat glass, make it so you NEED plastic beakers for superacids(for some reactions)
		//message_admins("pH is lover limit, cur pH: [pH]")

	//For now, purity is handled elsewhere

	//Calculate DeltapH (Deviation of pH from optimal)
	//Lower range
	if (pH < C.OptimalpHMin)
		if (pH < (C.OptimalpHMin - C.ReactpHLim))
			deltapH = 0
			return//If outside pH range, no reaction
		else
			deltapH = (((pH - (C.OptimalpHMin - C.ReactpHLim))**C.CurveSharppH)/((C.ReactpHLim**C.CurveSharppH)))
	//Upper range
	else if (pH > C.OptimalpHMax)
		if (pH > (C.OptimalpHMax + C.ReactpHLim))
			deltapH = 0
			return //If outside pH range, no reaction
		else
			deltapH = (((- pH + (C.OptimalpHMax + C.ReactpHLim))**C.CurveSharppH)/(C.ReactpHLim**C.CurveSharppH))//Reverse - to + to prevent math operation failures.
	//Within mid range
	if (pH >= C.OptimalpHMin && pH <= C.OptimalpHMax)
		deltapH = 1
	//This should never proc:
	else
		//message_admins("Fermichem's pH broke!! Please let Fermis know!!")
		WARNING("[my_atom] attempted to determine FermiChem pH for '[C.id]' which broke for some reason! ([usr])")
	//TODO Add CatalystFact
	//message_admins("calculating pH factor(purity), pH: [pH], min: [C.OptimalpHMin]-[C.ReactpHLim], max: [C.OptimalpHMax]+[C.ReactpHLim], deltapH: [deltapH]")

	//Calculate DeltaT (Deviation of T from optimal)
	if (cached_temp < C.OptimalTempMax && cached_temp >= C.OptimalTempMin)
		deltaT = (((cached_temp - C.OptimalTempMin)**C.CurveSharpT)/((C.OptimalTempMax - C.OptimalTempMin)**C.CurveSharpT))
	else if (cached_temp >= C.OptimalTempMax)
		deltaT = 1
	else
		deltaT = 0
	//message_admins("calculating temperature factor, min: [C.OptimalTempMin], max: [C.OptimalTempMax], Exponential: [C.CurveSharpT], deltaT: [deltaT]")

	stepChemAmmount = CLAMP((deltaT * C.RateUpLim), 0, (targetVol - reactedVol))  //used to have multipler, now it doesn't
	if (stepChemAmmount > C.RateUpLim)
		stepChemAmmount = C.RateUpLim
	else if (stepChemAmmount <= 0.01)
		//message_admins("stepChem underflow [stepChemAmmount]")
		stepChemAmmount = 0.01

	if ((reactedVol + stepChemAmmount) > targetVol)
		stepChemAmmount = targetVol - reactedVol
		//message_admins("target volume reached. Reaction should stop after this loop. stepChemAmmount: [stepChemAmmount] + reactedVol: [reactedVol] = targetVol [targetVol]")

	//if (reactedVol > 0)
	//	purity = ((purity * reactedVol) + (deltapH * stepChemAmmount)) /((reactedVol+ stepChemAmmount)) //This should add the purity to the product
	//else
	purity = (deltapH)//set purity equal to pH offset

	//TODO: Check overall beaker purity with proc
	//Then adjust purity of result AND yeild ammount with said purity.
	stepChemAmmount *= reactant_purity(C)

	// End.
	/*
	for(var/B in cached_required_reagents) //
		tempVol = min(reactedVol, round(get_reagent_amount(B) / cached_required_reagents[B]))//a simple one over the other? (Is this for multiplying end product? Useful for toxinsludge buildup)
	*/
	//message_admins("cached_results: [cached_results], reactedVol: [reactedVol], stepChemAmmount [stepChemAmmount]")

	for(var/B in cached_required_reagents)
		//message_admins("cached_required_reagents(B): [cached_required_reagents[B]], reactedVol: [reactedVol], base stepChemAmmount [stepChemAmmount]")
		remove_reagent(B, (stepChemAmmount * cached_required_reagents[B]), safety = 1)//safety? removes reagents from beaker using remove function.

	for(var/P in cached_results)//Not sure how this works, what is selected_reaction.results?
		//reactedVol = max(reactedVol, 1) //this shouldnt happen ...
		SSblackbox.record_feedback("tally", "chemical_reaction", cached_results[P]*stepChemAmmount, P)//log
		add_reagent(P, cached_results[P]*(stepChemAmmount), null, cached_temp, purity)//add reagent function!! I THINK I can do this:
	//Above should reduce yeild based on holder purity.
	//Purity Check
		for(var/datum/reagent/R in my_atom.reagents.reagent_list)
			if(P == R.id)
				if (R.purity < C.PurityMin)//If purity is below the min, blow it up.
					C.FermiExplode(src, my_atom, (reactedVol+targetVol), cached_temp, pH)
					return

	C.FermiCreate(src)//proc that calls when step is done

	//Apply pH changes and thermal output of reaction to beaker
	chem_temp = round(cached_temp + (C.ThermicConstant * stepChemAmmount)) //Why won't you update!!!
	pH += (C.HIonRelease * stepChemAmmount)
	//keep track of the current reacted amount
	reactedVol = reactedVol + stepChemAmmount
	//return said amount to compare for next step.
	return (reactedVol)

/datum/reagents/proc/reactant_purity(var/datum/chemical_reaction/fermi/C, holder)
	var/list/cached_reagents = reagent_list
	var/i
	var/cachedPurity
	//var/fermiChem
	for(var/datum/reagent/R in my_atom.reagents.reagent_list)
		if (R in cached_reagents)
			cachedPurity += R.purity
			i++
	return cachedPurity/i

/datum/reagents/proc/isolate_reagent(reagent)
	var/list/cached_reagents = reagent_list
	for(var/_reagent in cached_reagents)
		var/datum/reagent/R = _reagent
		if(R.id != reagent)
			del_reagent(R.id)
			update_total()

/datum/reagents/proc/del_reagent(reagent)
	var/list/cached_reagents = reagent_list
	for(var/_reagent in cached_reagents)
		var/datum/reagent/R = _reagent
		if(R.id == reagent)
			if(my_atom && isliving(my_atom))
				var/mob/living/M = my_atom
				R.on_mob_delete(M)
			qdel(R)
			reagent_list -= R
			update_total()
			if(my_atom)
				my_atom.on_reagent_change(DEL_REAGENT)
	return 1

/datum/reagents/proc/update_total()
	var/list/cached_reagents = reagent_list
	total_volume = 0
	for(var/reagent in cached_reagents)
		var/datum/reagent/R = reagent
		if(R.volume < 0.1)
			del_reagent(R.id)
		else
			total_volume += R.volume

	return 0

/datum/reagents/proc/clear_reagents()
	var/list/cached_reagents = reagent_list
	for(var/reagent in cached_reagents)
		var/datum/reagent/R = reagent
		del_reagent(R.id)
	return 0

/datum/reagents/proc/reaction(atom/A, method = TOUCH, volume_modifier = 1, show_message = 1)
	var/react_type
	if(isliving(A))
		react_type = "LIVING"
		if(method == INGEST)
			var/mob/living/L = A
			L.taste(src)
	else if(isturf(A))
		react_type = "TURF"
	else if(isobj(A))
		react_type = "OBJ"
	else
		return
	var/list/cached_reagents = reagent_list
	for(var/reagent in cached_reagents)
		var/datum/reagent/R = reagent
		switch(react_type)
			if("LIVING")
				var/touch_protection = 0
				if(method == VAPOR)
					var/mob/living/L = A
					touch_protection = L.get_permeability_protection()
				R.reaction_mob(A, method, R.volume * volume_modifier, show_message, touch_protection)
			if("TURF")
				R.reaction_turf(A, R.volume * volume_modifier, show_message)
			if("OBJ")
				R.reaction_obj(A, R.volume * volume_modifier, show_message)

/datum/reagents/proc/holder_full()
	if(total_volume >= maximum_volume)
		return TRUE
	return FALSE

//Returns the average specific heat for all reagents currently in this holder.
/datum/reagents/proc/specific_heat()
	. = 0
	var/cached_amount = total_volume		//cache amount
	var/list/cached_reagents = reagent_list		//cache reagents
	for(var/I in cached_reagents)
		var/datum/reagent/R = I
		. += R.specific_heat * (R.volume / cached_amount)

/datum/reagents/proc/adjust_thermal_energy(J, min_temp = 2.7, max_temp = 1000)
	var/S = specific_heat()
	chem_temp = CLAMP(chem_temp + (J / (S * total_volume)), min_temp, max_temp)

/datum/reagents/proc/add_reagent(reagent, amount, list/data=null, reagtemp = 300, other_purity = 1, other_pH, no_react = 0)//EDIT HERE TOO ~FERMICHEM~
	//beaker_check(my_atom)

	if(!isnum(amount) || !amount)
		return FALSE

	if(amount <= 0)
		return FALSE

	var/datum/reagent/D = GLOB.chemical_reagents_list[reagent]
	if(!D)
		WARNING("[my_atom] attempted to add a reagent called '[reagent]' which doesn't exist. ([usr])")
		return FALSE

	if (D.id == "water") //Do like an otter, add acid to water.
		if (pH <= 2)
			var/datum/effect_system/smoke_spread/chem/s = new
			var/turf/T = get_turf(my_atom)
			var/datum/reagents/R = new/datum/reagents(3000)//I don't want to hold it back..!
			R.add_reagent("fermiAcid", amount)
			for (var/datum/reagent/reagentgas in reagent_list)
				R.add_reagent(reagentgas, amount/5)
				remove_reagent(reagentgas, amount/5)
			s.set_up(R, CLAMP(amount/10, 0, 2), T)
			s.start()
			return FALSE

	beaker_check(my_atom) //Beaker resilience test

	if(!pH)
		other_pH = D.pH

	update_total()
	var/cached_total = total_volume
	if(cached_total + amount > maximum_volume)
		amount = (maximum_volume - cached_total) //Doesnt fit in. Make it disappear. Shouldnt happen. Will happen.
		if(amount <= 0)
			return FALSE
	var/new_total = cached_total + amount
	var/cached_temp = chem_temp
	var/list/cached_reagents = reagent_list
	var/cached_pH = pH

	//Equalize temperature - Not using specific_heat() because the new chemical isn't in yet.
	var/specific_heat = 0
	var/thermal_energy = 0
	for(var/i in cached_reagents)
		var/datum/reagent/R = i
		specific_heat += R.specific_heat * (R.volume / new_total)
		thermal_energy += R.specific_heat * R.volume * cached_temp
	specific_heat += D.specific_heat * (amount / new_total)
	thermal_energy += D.specific_heat * amount * reagtemp
	chem_temp = thermal_energy / (specific_heat * new_total)
	////

	//pH = round(-log(10, ((cached_total * (10^(-cached_pH))) + (amount * (10^(-other_pH)))) / new_total), REAGENT_PH_ACCURACY) I think this is wrong? I'm getting negative numbers?
	pH = ((cached_pH * cached_total)+(D.pH * amount))/(cached_total + amount)//should be right
	//add the reagent to the existing if it exists

	for(var/A in cached_reagents)
		var/datum/reagent/R = A
		if (R.id == reagent)
			//WIP_TAG			//check my maths for purity calculations
			//Add amount and equalize purity
			R.volume += amount
			R.purity = ((R.purity * R.volume) + (other_purity * amount)) /((R.volume + amount)) //This should add the purity to the product


			update_total()
			if(my_atom)
				my_atom.on_reagent_change(ADD_REAGENT)
			//if(R.FermiChem == TRUE)
			//	R.on_mob_add(my_atom)
			R.on_merge(data, amount, my_atom, other_purity)
			if(istype(D, /datum/reagent/fermi))//Is this a fermichem?
				var/datum/reagent/fermi/Ferm = D //It's Fermi time!
				if(Ferm.OnMobMergeCheck == TRUE) //// Ooooooh fermifermifermi
					R.on_mob_add(my_atom, amount)
			if(!no_react)
				handle_reactions()

			return TRUE


	//otherwise make a new one
	var/datum/reagent/R = new D.type(data)
	cached_reagents += R
	R.holder = src
	R.volume = amount
	R.purity = other_purity
	R.loc = get_turf(my_atom)
	if(data)
		R.data = data
		R.on_new(data)
	if(R.addProc == TRUE)
		R.on_new(src)
	if(istype(D, /datum/reagent/fermi))//Is this a fermichem?
		var/datum/reagent/fermi/Ferm = D //It's Fermi time!
		Ferm.FermiNew(my_atom) //Seriously what is "data" ????

		//This is how I keep myself sane.


	update_total()
	if(my_atom)
		my_atom.on_reagent_change(ADD_REAGENT)
	if(!no_react)
		handle_reactions()
	if(isliving(my_atom))
		R.on_mob_add(my_atom, amount)
	return TRUE


/datum/reagents/proc/add_reagent_list(list/list_reagents, list/data=null) // Like add_reagent but you can enter a list. Format it like this: list("toxin" = 10, "beer" = 15)
	for(var/r_id in list_reagents)
		var/amt = list_reagents[r_id]
		add_reagent(r_id, amt, data)

/datum/reagents/proc/remove_reagent(reagent, amount, safety)//Added a safety check for the trans_id_to

	if(isnull(amount))
		amount = 0
		CRASH("null amount passed to reagent code")
		return FALSE

	if(!isnum(amount))
		return FALSE

	if(amount < 0)
		return FALSE

	var/list/cached_reagents = reagent_list

	for(var/A in cached_reagents)
		var/datum/reagent/R = A
		if (R.id == reagent)
			//clamp the removal amount to be between current reagent amount
			//and zero, to prevent removing more than the holder has stored
			if((total_volume - amount) == 0)//Because this can result in 0, I don't want it to crash.
				pH = 7
			else
				pH = ((pH * total_volume)-(R.pH * amount))/(total_volume - amount)
			amount = CLAMP(amount, 0, R.volume)
			R.volume -= amount
			update_total()
			if(!safety)//So it does not handle reactions when it need not to
				handle_reactions()
			if(my_atom)
				my_atom.on_reagent_change(REM_REAGENT)
			return TRUE

	return FALSE

/datum/reagents/proc/has_reagent(reagent, amount = -1)
	var/list/cached_reagents = reagent_list
	for(var/_reagent in cached_reagents)
		var/datum/reagent/R = _reagent
		if (R.id == reagent)
			if(!amount)
				return R
			else
				if(R.volume >= amount)
					return R
				else
					return 0

	return 0

/datum/reagents/proc/get_reagent_amount(reagent)
	var/list/cached_reagents = reagent_list
	for(var/_reagent in cached_reagents)
		var/datum/reagent/R = _reagent
		if (R.id == reagent)
			return R.volume

	return 0

/datum/reagents/proc/get_reagents()
	var/list/names = list()
	var/list/cached_reagents = reagent_list
	for(var/reagent in cached_reagents)
		var/datum/reagent/R = reagent
		names += R.name

	return jointext(names, ",")

/datum/reagents/proc/remove_all_type(reagent_type, amount, strict = 0, safety = 1) // Removes all reagent of X type. @strict set to 1 determines whether the childs of the type are included.
	if(!isnum(amount))
		return 1
	var/list/cached_reagents = reagent_list
	var/has_removed_reagent = 0

	for(var/reagent in cached_reagents)
		var/datum/reagent/R = reagent
		var/matches = 0
		// Switch between how we check the reagent type
		if(strict)
			if(R.type == reagent_type)
				matches = 1
		else
			if(istype(R, reagent_type))
				matches = 1
		// We found a match, proceed to remove the reagent.	Keep looping, we might find other reagents of the same type.
		if(matches)
			// Have our other proc handle removement
			has_removed_reagent = remove_reagent(R.id, amount, safety)

	return has_removed_reagent

//two helper functions to preserve data across reactions (needed for xenoarch)
/datum/reagents/proc/get_data(reagent_id)
	var/list/cached_reagents = reagent_list
	for(var/reagent in cached_reagents)
		var/datum/reagent/R = reagent
		if(R.id == reagent_id)
			return R.data

/datum/reagents/proc/set_data(reagent_id, new_data)
	var/list/cached_reagents = reagent_list
	for(var/reagent in cached_reagents)
		var/datum/reagent/R = reagent
		if(R.id == reagent_id)
			R.data = new_data

/datum/reagents/proc/copy_data(datum/reagent/current_reagent)
	if(!current_reagent || !current_reagent.data)
		return null
	if(!istype(current_reagent.data, /list))
		return current_reagent.data

	var/list/trans_data = current_reagent.data.Copy()

	// We do this so that introducing a virus to a blood sample
	// doesn't automagically infect all other blood samples from
	// the same donor.
	//
	// Technically we should probably copy all data lists, but
	// that could possibly eat up a lot of memory needlessly
	// if most data lists are read-only.
	if(trans_data["viruses"])
		var/list/v = trans_data["viruses"]
		trans_data["viruses"] = v.Copy()

	return trans_data

/datum/reagents/proc/get_reagent(type)
	var/list/cached_reagents = reagent_list
	. = locate(type) in cached_reagents

/datum/reagents/proc/generate_taste_message(minimum_percent=15)
	// the lower the minimum percent, the more sensitive the message is.
	var/list/out = list()
	var/list/tastes = list() //descriptor = strength
	if(minimum_percent <= 100)
		for(var/datum/reagent/R in reagent_list)
			if(!R.taste_mult)
				continue

			if(istype(R, /datum/reagent/consumable/nutriment))
				var/list/taste_data = R.data
				for(var/taste in taste_data)
					var/ratio = taste_data[taste]
					var/amount = ratio * R.taste_mult * R.volume
					if(taste in tastes)
						tastes[taste] += amount
					else
						tastes[taste] = amount
			else
				var/taste_desc = R.taste_description
				var/taste_amount = R.volume * R.taste_mult
				if(taste_desc in tastes)
					tastes[taste_desc] += taste_amount
				else
					tastes[taste_desc] = taste_amount
		//deal with percentages
		// TODO it would be great if we could sort these from strong to weak
		var/total_taste = counterlist_sum(tastes)
		if(total_taste > 0)
			for(var/taste_desc in tastes)
				var/percent = tastes[taste_desc]/total_taste * 100
				if(percent < minimum_percent)
					continue
				var/intensity_desc = "a hint of"
				if(percent > minimum_percent * 2 || percent == 100)
					intensity_desc = ""
				else if(percent > minimum_percent * 3)
					intensity_desc = "the strong flavor of"
				if(intensity_desc != "")
					out += "[intensity_desc] [taste_desc]"
				else
					out += "[taste_desc]"

	return english_list(out, "something indescribable")

/datum/reagents/proc/expose_temperature(var/temperature, var/coeff=0.02)
	var/temp_delta = (temperature - chem_temp) * coeff
	if(temp_delta > 0)
		chem_temp = min(chem_temp + max(temp_delta, 1), temperature)
	else
		chem_temp = max(chem_temp + min(temp_delta, -1), temperature)
	chem_temp = round(chem_temp)
	handle_reactions()

///////////////////////////////////////////////////////////////////////////////////


// Convenience proc to create a reagents holder for an atom
// Max vol is maximum volume of holder
/atom/proc/create_reagents(max_vol)
	if(reagents)
		qdel(reagents)
	reagents = new/datum/reagents(max_vol)
	reagents.my_atom = src

/proc/get_random_reagent_id()	// Returns a random reagent ID minus blacklisted reagents
	var/static/list/random_reagents = list()
	if(!random_reagents.len)
		for(var/thing  in subtypesof(/datum/reagent))
			var/datum/reagent/R = thing
			if(initial(R.can_synth))
				random_reagents += initial(R.id)
	var/picked_reagent = pick(random_reagents)
	return picked_reagent
