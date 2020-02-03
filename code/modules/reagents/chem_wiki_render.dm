//Generates a markdown txt file for use with the wiki

/proc/find_reagent(input)
	//prefer types!
	. = GLOB.chemical_reagents_list[text2path(input)]
	if(.)
		return
	. = GLOB.name2reagent[ckey(input)]



/client/proc/generate_wikichem_list()
	set name = "Generate Wikichems"
	set category = "Debug"
	set desc = "Generate a huge loglist of all the chems. Do not click unless you want lag."



	var/prefix = "|Name | Reagents | Reaction vars | Description | Chem properties |\n|---|---|---|-----------|---|\n"
	var/input_reagent = replacetext(lowertext(input("Input the name/type of a reagent to get it's description on it's own, or leave blank to parse every chem.", "Input") as text), " ", "") //95% of the time, the reagent type is a lowercase, no spaces / underscored version of the name
	if(input_reagent)
		var/input_reagent2 = find_reagent(input_reagent)
		if(!input_reagent2)
			to_chat(usr, "Unable to find reagent, stopping proc.")
		var/single_parse = generate_chemwiki_line(input_reagent2, input_reagent, FALSE)
		text2file(single_parse, "[GLOB.log_directory]/chem_parse.md")
		to_chat(usr, "[single_parse].")

		single_parse = generate_chemwiki_line(input_reagent2, input_reagent, FALSE)
		text2file(single_parse, "[GLOB.log_directory]/chem_parse.md")
		to_chat(usr, "[single_parse].")
		to_chat(usr, "Saved line to (wherever your root folder is, i.e. where the DME is)/[GLOB.log_directory]/chem_parse.md OR use the Get Current Logs verb under the Admin tab. (if you click Open, and it does nothing, that's because you've not set a .md default program! Try downloading it instead, and use that file to set a default program! Also have a cute day.)")
		//Do things here
		return
	to_chat(usr, "Generating big list")
	message_admins("Someone pressed the lag button. (Generate Wikichems)")
    ///datum/reagent/medicine, /datum/reagent/toxin, /datum/reagent/consumable, /datum/reagent/plantnutriment, /datum/reagent/uranium,
    ///datum/reagent/colorful_reagent, /datum/reagent/mutationtoxin, /datum/reagent/fermi, /datum/reagent/drug, /datum/reagent/impure

	//Probably not the most eligant of solutions.
	to_chat(usr, "Attempting reagent scan. Length of list [LAZYLEN(GLOB.chemical_reagents_list)*2]")
	var/datum/reagent/R
	var/tally = 0
	var/processCR = TRUE //Process reactions first
	var/medicine = ""
	var/toxin = ""
	var/consumable = ""
	var/plant = ""
	var/uranium = ""
	var/colours = ""
	var/muta = ""
	var/fermi = ""
	var/remainder = ""
	var/drug = ""
	var/basic = ""
	var/upgraded = ""
	var/drinks = ""
	var/alco = ""
	var/grinded = ""
	var/blob = ""
	var/impure = ""

	//Chem_dispencer
	var/obj/machinery/chem_dispenser/C
	var/list/dispensable_reagents = initial(C.dispensable_reagents)
	var/list/components = initial(C.upgrade_reagents) + initial(C.upgrade_reagents2) + initial(C.upgrade_reagents3)

	var/list/grind = list(
		/datum/reagent/bluespace,
		/datum/reagent/gold,
		/datum/reagent/toxin/plasma,
		/datum/reagent/uranium
	)

	//Bartender
	var/obj/machinery/chem_dispenser/drinks/D
	var/dispence_drinks = initial(D.dispensable_reagents)

	var/obj/machinery/chem_dispenser/drinks/beer/B
	var/dispence_alco = initial(B.dispensable_reagents)

	var/breakout = FALSE
	for(var/i = 1, i <= 2, i+=1)
		for(var/X in GLOB.chemical_reagents_list)
			R = GLOB.chemical_reagents_list[X]
			if(!R.description) //No description? It's not worth my time.
				continue

			for(var/Y in dispensable_reagents) //Why do you have to do this
				if(R.type == Y)
					basic += generate_chemwiki_line(R, X, processCR)
					breakout = TRUE
					continue

			for(var/Y in components)
				if(R.type == Y)
					upgraded += generate_chemwiki_line(R, X, processCR)
					breakout = TRUE
					continue

			for(var/Y in dispence_drinks)
				if(R.type == Y)
					drinks += generate_chemwiki_line(R, X, processCR)
					breakout = TRUE
					continue

			for(var/Y in dispence_alco)
				if(R.type == Y)
					alco += generate_chemwiki_line(R, X, processCR)
					breakout = TRUE
					continue

			for(var/Y in grind)
				if(R.type == Y)
					grinded += generate_chemwiki_line(R, X, processCR)
					breakout = TRUE
					continue

			if(breakout)
				breakout = FALSE
				continue

			if(istype(R, /datum/reagent/medicine))
				medicine += generate_chemwiki_line(R, X, processCR)

			else if(istype(R, /datum/reagent/toxin))
				toxin += generate_chemwiki_line(R, X, processCR)

			else if(istype(R, /datum/reagent/consumable))
				consumable += generate_chemwiki_line(R, X, processCR)

			else if(istype(R, /datum/reagent/plantnutriment))
				plant += generate_chemwiki_line(R, X, processCR)

			else if(istype(R, /datum/reagent/uranium))
				uranium += generate_chemwiki_line(R, X, processCR)

			else if(istype(R, /datum/reagent/colorful_reagent))
				colours += generate_chemwiki_line(R, X, processCR)

			else if(istype(R, /datum/reagent/mutationtoxin))
				muta += generate_chemwiki_line(R, X, processCR)

			else if(istype(R, /datum/reagent/fermi))
				fermi += generate_chemwiki_line(R, X, processCR)

			else if(istype(R, /datum/reagent/drug))
				drug += generate_chemwiki_line(R, X, processCR)

			else if(istype(R, /datum/reagent/blob))
				blob += generate_chemwiki_line(R, X, processCR)

			else if(istype(R, /datum/reagent/impure))
				impure += generate_chemwiki_line(R, X, processCR)

			else
				remainder += generate_chemwiki_line(R, X, processCR)

			tally++
			if((tally%50)==0)
				to_chat(usr, "[tally] of [LAZYLEN(GLOB.chemical_reagents_list)*2] done.")

		processCR = FALSE

	to_chat(usr, "finished chems")

	var/wholeString = ("\n# DISPENCEABLE REAGENTS\n\n[prefix][basic]\n\n# COMPONENT REAGENTS\n\n[prefix][upgraded]\n\n# GROUND REAGENTS\n\n[prefix][grinded]\n")
	wholeString += ("\n# MEDICINE:\n\n[prefix][medicine]\n\n# TOXIN:\n\n[prefix][toxin]\n\n# DRUGS\n\n[prefix][drug]\n\n# FERMI\n\nThese chems lie on the cutting edge of chemical technology, and as such are not recommended for beginners!\n\n[prefix][fermi]\n\n# IMPURE REAGENTS\n\n[prefix][impure]\n\n# GENERAL REAGENTS\n\n[prefix][remainder]\n\n# DISPENCEABLE SOFT DRINKS\n\n[prefix][drinks]\n\n# DISPENCEABLE HARD DRINKS\n\n[prefix][alco]\n\n# CONSUMABLE\n\n[prefix][consumable]\n\n# PLANTS\n\n[prefix][plant]\n\n# URANIUM\n\n[prefix][uranium]\n\n# COLOURS\n\n[prefix][colours]\n\n# RACE MUTATIONS\n\n[prefix][muta]\n\n\n# BLOB REAGENTS\n\n[prefix][blob]\n")

	prefix = "|Name | Reagents | Reaction vars | Description |\n|---|---|---|----------|\n"
	var/CRparse = ""
	to_chat(usr, "starting reactions")

	//generate the reactions that we missed from before
	for(var/reagent in GLOB.chemical_reactions_list)
		for(var/datum/chemical_reaction/CR in GLOB.chemical_reactions_list[reagent])
			CRparse += generate_chemreactwiki_line(CR)

	wholeString += ("\n# CHEMICAL REACTIONS\n\n[prefix][CRparse]\n")
	text2file(wholeString, "[GLOB.log_directory]/chem_parse.md")
	to_chat(usr, "finished reactions")
	to_chat(usr, "Saved file to (wherever your root folder is, i.e. where the DME is)/[GLOB.log_directory]/chem_parse.md OR use the Get Current Logs verb under the Admin tab. (if you click Open, and it does nothing, that's because you've not set a .md default program! Try downloading it instead, and use that file to set a default program! Also have a cute day.)")



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



//Generate the big list of reagent based reactions.
/proc/generate_chemwiki_line(datum/reagent/R, X, processCR)
	//name | Reagent pH | reagents | reaction temp | explosion temp | pH range | Kinetics | description | OD level | Addiction level | Metabolism rate | impure chem | inverse chem

	var/datum/chemical_reaction/CR = get_chemical_reaction(R.type)
	if((!CR && processCR) || (CR && !processCR)) // Do reactions first.
		return ""


	var/outstring = "|<a href=\"#[R.name]\"><h5 id=\"[R.name]\">!\[[R.color]\](https://placehold.it/15/[copytext_char(R.color, 2, 8)]/000000?text=+)[R.name]</h5></a> pH: [R.pH] | "
	var/datum/reagent/R3
	if(CR)
		outstring += "<ul>"
		for(var/R2 in CR.required_reagents)
			R3 = GLOB.chemical_reagents_list[R2]//What a convoluted mess
			outstring += "<li><a href=\"#[R3.name]\">[R3.name]</a>: [CR.required_reagents[R3.type]]u</li>"
		if(CR.required_catalysts)
			for(var/R2 in CR.required_catalysts)
				R3 = GLOB.chemical_reagents_list[R2]
				outstring += "<li>Catalyst: <a href=\"#[R3.name]\">[R3.name]</a>: [CR.required_catalysts[R3.type]]u</li>"
		outstring += "</ul> | "
	else
		outstring += "N/A | "


	//Temp, Explosions and pH
	if(CR)
		outstring += "<ul>[(CR.FermiChem?"<li>Min react temp: [CR.OptimalTempMin]K</li>":"[(CR.required_temp?"<li>Min react temp: [CR.required_temp]K</li>":"")]")] [(CR.FermiChem?"<li>Explosion_temp: [CR.ExplodeTemp]K</li>":"")] [(CR.FermiChem?"<li>pH range: [max((CR.OptimalpHMin - CR.ReactpHLim), 0)] to [min((CR.OptimalpHMax + CR.ReactpHLim), 14)]</li>":"")] "
		if(CR.FermiChem)
			outstring += "[(CR.PurityMin?"<li>Min explosive purity: [CR.PurityMin]</li>":"")] [(CR.FermiExplode?"<li>Special explosion: Yes</li>":"")]"
	else
		outstring += ""

	//Kinetics
	if(CR)
		if(CR.FermiChem)
			switch(CR.ThermicConstant)
				if(-INFINITY to -9.9)
					outstring += "<li>Extremely endothermic</li> "
				if(-9.9 to -4.9)
					outstring += "<li>Very endothermic</li> "
				if(-4.9 to -0.1)
					outstring += "<li>Endothermic</li> "
				if(-0.1 to 0.1)
					outstring += "<li>Neutral</li> "
				if(0.1 to 4.9)
					outstring += "<li>Exothermic</li> "
				if(4.9 to 9.9)
					outstring += "<li>Very exothermic</li> "
				if(9.9 to 19.9)
					outstring += "<li>Extremely exothermic</li> "
				if(19.9 to INFINITY )
					outstring += "<li>**Dangerously exothermic**</li> "
				//if("cheesey")
					//outstring += "<li>Dangerously Cheesey</li>"

		outstring += "</ul>| "
	else
		outstring += " | "

	//Description, OD, Addict, Meta
	outstring += "[R.description] | <ul><li>Metabolism rate: [R.metabolization_rate/2]u/s</li> [(R.overdose_threshold?"<li>Overdose: [R.overdose_threshold]u</li>":"")] [(R.addiction_threshold?"<li>Addiction: [R.addiction_threshold]u</li>":"")] "

	if(R.impure_chem && R.impure_chem != /datum/reagent/impure/fermiTox)
		R3 = GLOB.chemical_reagents_list[R.impure_chem]
		outstring += "<li>Impure chem:<a href=\"#[R3.name]\">[R3.name]</a></li>"

	if(R.inverse_chem && R.impure_chem != /datum/reagent/impure/fermiTox)
		R3 = GLOB.chemical_reagents_list[R.inverse_chem]
		outstring += "<li>Inverse chem:<a href=\"#[R3.name]\">[R3.name]</a></li> [(R3.inverse_chem_val?"<li>Inverse purity: [R3.inverse_chem_val]</li>":"")] "

	if(CR)
		if(CR.required_container)
			/*var/obj/item/I
			I = istype(I, CR.required_container) if you can work out how to get this to work, by all means.
			outstring += "<li>Required container: [I.name]</li>"*/
			outstring += "<li>Required container: [CR.required_container]</li>"

	outstring += "</ul>|\n"
	return outstring

//Generate the big list of reaction based reactions.
//|Name | Reagents | Reaction vars | Description | Chem properties
/proc/generate_chemreactwiki_line(datum/chemical_reaction/CR)
	if(CR.results.len) //Handled prior
		return
	var/outstring = "|[CR.name] | <ul>"

	//reagents
	var/datum/reagent/R3
	for(var/R2 in CR.required_reagents)
		R3 = GLOB.chemical_reagents_list[R2]
		outstring += "<li><a href=\"#[R3.name]\">[R3.name]</a>: [CR.required_reagents[R3.type]]u</li>"
	if(CR.required_catalysts)
		for(var/R2 in CR.required_catalysts)
			R3 = GLOB.chemical_reagents_list[R2]
			outstring += "<li>Catalyst: <a href=\"#[R3.name]\">[R3.name]</a>: [CR.required_catalysts[R3.type]]u</li>"
	outstring += "</ul> | <ul>"

	//Reaction vars
	if(CR.required_temp)
		outstring += "<li>Min react temp: [CR.required_temp]K</li>"
	if(CR.FermiChem)
		outstring += "[(CR.FermiChem?"<li>Min react temp: [CR.OptimalTempMin]K</li>":"[(CR.required_temp?"<li>Min react temp: [CR.required_temp]K</li>":"")]")] [(CR.FermiChem?"<li>Explosion temp: [CR.ExplodeTemp]K</li>":"")] [(CR.FermiChem?"<li>pH range: [max((CR.OptimalpHMin - CR.ReactpHLim), 0)] to [min((CR.OptimalpHMax + CR.ReactpHLim), 14)]</li>":"")] <li>Minimum purity: [CR.PurityMin] [(CR.FermiExplode?"<li>Special explosion: Yes</li>":"")]"
	if(CR.is_cold_recipe)
		outstring += "<li>Cold: Yes</li>"
	if(CR.required_container)
		outstring += "<li>Required container: [CR.required_container]</li>"
	if(CR.mob_react)
		outstring += "<li>Can react in mob: Yes</li>"

	//description
	outstring += "</ul>| fill in manually "

	outstring += "<ul>|\n"
	return outstring
