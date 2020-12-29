//Generates a wikitable txt file for use with the wiki

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



	var/prefix = {"{| class=\"wikitable sortable\" style=\"width:100%; text-align:left; border: 3px solid #FFDD66; cellspacing=0; cellpadding=2; background-color:white;\"
! scope=\"col\" style='width:150px; background-color:#FFDD66;'|Name
! scope=\"col\" class=\"unsortable\" style='width:150px; background-color:#FFDD66;'|Recipe
! scope=\"col\" class=\"unsortable\" style='width:200px; style='background-color:#FFDD66;'|Reaction vars
! scope=\"col\" class=\"unsortable\" style='background-color:#FFDD66;'|Description
! scope=\"col\" class=\"unsortable\" style='background-color:#FFDD66;'|Chemical properties
! scope=\"col\" style='background-color:#FFDD66;'|pH
|-
"}
	var/input_reagent = replacetext(lowertext(input("Input the name/type of a reagent to get it's description on it's own, or leave blank to parse every chem.", "Input") as text), " ", "") //95% of the time, the reagent type is a lowercase, no spaces / underscored version of the name
	if(input_reagent)
		var/input_reagent2 = find_reagent(input_reagent)
		if(!input_reagent2)
			to_chat(usr, "Unable to find reagent, stopping proc.")
		var/single_parse = generate_chemwiki_line(input_reagent2, input_reagent, FALSE)
		text2file(single_parse, "[GLOB.log_directory]/chem_parse.txt")
		to_chat(usr, "[single_parse].")

		single_parse = generate_chemwiki_line(input_reagent2, input_reagent, FALSE)
		text2file(single_parse, "[GLOB.log_directory]/chem_parse.txt")
		to_chat(usr, "[single_parse].")
		to_chat(usr, "Saved line to (wherever your root folder is, i.e. where the DME is)/[GLOB.log_directory]/chem_parse.txt OR use the Get Current Logs verb under the Admin tab. (if you click Open, and it does nothing, that's because you've not set a .txt default program! Try downloading it instead, and use that file to set a default program! Also have a cute day.)")
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

			for(var/datum/reagent/Y in dispensable_reagents) //Why do you have to do this
				if(R == Y)
					basic += generate_chemwiki_line(R, X, processCR)
					breakout = TRUE
					continue

			for(var/datum/reagent/Y in components)
				if(R == Y)
					upgraded += generate_chemwiki_line(R, X, processCR)
					breakout = TRUE
					continue

			for(var/datum/reagent/Y in dispence_drinks)
				if(R == Y)
					drinks += generate_chemwiki_line(R, X, processCR)
					breakout = TRUE
					continue

			for(var/datum/reagent/Y in dispence_alco)
				if(R == Y)
					alco += generate_chemwiki_line(R, X, processCR)
					breakout = TRUE
					continue

			for(var/datum/reagent/Y in grind)
				if(R == Y)
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

	var/wholeString = ("\n= DISPENCEABLE REAGENTS =\n\n[prefix][basic]|}\n\n= COMPONENT REAGENTS =\n\n[prefix][upgraded]|}\n\n= GROUND REAGENTS =\n\n[prefix][grinded]|}\n")
	wholeString += ("\n= MEDICINE: =\n\n[prefix][medicine]|}\n\n= TOXIN: =\n\n[prefix][toxin]|}\n\n= DRUGS =\n\n[prefix][drug]|}\n\n= FERMI =\n\nThese chems lie on the cutting edge of chemical technology, and as such are not recommended for beginners!\n\n[prefix][fermi]|}\n\n= IMPURE REAGENTS =\n\n[prefix][impure]|}\n\n= GENERAL REAGENTS =\n\n[prefix][remainder]|}\n\n= DISPENCEABLE SOFT DRINKS =\n\n[prefix][drinks]|}\n\n= DISPENCEABLE HARD DRINKS =\n\n[prefix][alco]|}\n\n= CONSUMABLE =\n\n[prefix][consumable]|}\n\n= PLANTS =\n\n[prefix][plant]|}\n\n= URANIUM =\n\n[prefix][uranium]|}\n\n= COLOURS =\n\n[prefix][colours]|}\n\n= RACE MUTATIONS =\n\n[prefix][muta]|}\n\n\n= BLOB REAGENTS =\n\n[prefix][blob]|}\n")

	prefix = {"{| class=\"wikitable sortable\" style=\"width:100%; text-align:left; border: 3px solid #FFDD66; cellspacing=0; cellpadding=2; background-color:white;\"
! scope=\"col\" style='width:150px; background-color:#FFDD66;'|Name
! scope=\"col\" class=\"unsortable\" style='width:150px; background-color:#FFDD66;'|Reagents
! scope=\"col\" class=\"unsortable\" style='background-color:#FFDD66;'|Reaction vars
! scope=\"col\" class=\"unsortable\" style='background-color:#FFDD66;'|Description
|-
"}
	var/CRparse = ""
	to_chat(usr, "starting reactions")

	//generate the reactions that we missed from before
	for(var/reagent in GLOB.chemical_reactions_list)
		for(var/datum/chemical_reaction/CR in GLOB.chemical_reactions_list[reagent])
			CRparse += generate_chemreactwiki_line(CR)

	wholeString += ("\n= CHEMICAL REACTIONS = \n\n[prefix][CRparse]|}\n")
	text2file(wholeString, "[GLOB.log_directory]/chem_parse.txt")
	to_chat(usr, "finished reactions")
	to_chat(usr, "Saved file to (wherever your root folder is, i.e. where the DME is)/[GLOB.log_directory]/chem_parse.txt OR use the Get Current Logs verb under the Admin tab. (if you click Open, and it does nothing, that's because you've not set a .txt default program! Try downloading it instead, and use that file to set a default program! Also have a cute day.)")



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



//Generate the big list of reagent based reactions.
/proc/generate_chemwiki_line(datum/reagent/R, X, processCR)
	//name | Reagent pH | reagents | reaction temp | explosion temp | pH range | Kinetics | description | OD level | Addiction level | Metabolism rate | impure chem | inverse chem

	var/datum/chemical_reaction/CR = get_chemical_reaction(R.type)
	if((!CR && processCR) || (CR && !processCR)) // Do reactions first.
		return ""

	//NAME
	//!style='background-color:#FFEE88;'|{{anchor|Synthetic-derived growth factor}}Synthetic-derived growth factor<span style="color:#A502E0;background-color:white">▮</span>
	var/outstring = "!style='background-color:#FFEE88;'|{{anchor|[R.name]}}[R.name]<span style=\"color:[R.color];background-color:white\">▮</span> \n|"
	var/datum/reagent/R3
	if(CR)
		//RECIPIE
		for(var/R2 in CR.required_reagents)
			R3 = GLOB.chemical_reagents_list[R2]//What a convoluted mess
			outstring += "[CR.required_reagents[R3.type]] parts \[\[#[R3.name]|[R3.name]\]\]<br>"

		if(CR.required_catalysts)
			for(var/R2 in CR.required_catalysts)
				R3 = GLOB.chemical_reagents_list[R2]
				outstring += "Catalyst: [CR.required_catalysts[R3.type]]u \[\[#[R3.name]|[R3.name]\]\]<br>"
		outstring += "\n|"
	else
		outstring += "N/A \n| "


	//REACTION VARS
	if(CR)
		outstring += "[(CR.FermiChem?"<br><b>Min react temp:</b> [CR.OptimalTempMin]K":"[(CR.required_temp?"<br><b>Min react temp:</b> [CR.required_temp]K":"")]")] [(CR.FermiChem?"<br><b>Explosion_temp:</b> [CR.ExplodeTemp]K":"")] [(CR.FermiChem?"<br><b>pH range:</b> [max((CR.OptimalpHMin - CR.ReactpHLim), 0)] to [min((CR.OptimalpHMax + CR.ReactpHLim), 14)]":"")] "
		if(CR.FermiChem)
			outstring += "[(CR.PurityMin?"<br><b>Min explosive purity:</b> [CR.PurityMin]":"")] [(CR.FermiExplode?"<br><b>Special explosion:</b> Yes":"")]"
	else
		outstring += ""

	//Kinetics
	if(CR)
		if(CR.FermiChem)
			switch(CR.ThermicConstant)
				if(-INFINITY to -9.9)
					outstring += "<br>Extremely endothermic "
				if(-9.9 to -4.9)
					outstring += "<br>Very endothermic "
				if(-4.9 to -0.1)
					outstring += "<br>Endothermic "
				if(-0.1 to 0.1)
					outstring += "<br>Neutral "
				if(0.1 to 4.9)
					outstring += "<br>Exothermic "
				if(4.9 to 9.9)
					outstring += "<br>Very exothermic "
				if(9.9 to 19.9)
					outstring += "<br>Extremely exothermic "
				if(19.9 to INFINITY )
					outstring += "<br><b>Dangerously exothermic</b> "
				//if("cheesey")
					//outstring += "<br>Dangerously Cheesey"

		outstring += "\n|"
	else
		outstring += "\n|"

	//Description, THEN chemical properties OD, Addict, Meta
	outstring += "[R.description] \n|Metabolism rate: [R.metabolization_rate/2]u/s [(R.overdose_threshold?"<br>Overdose: [R.overdose_threshold]u":"")] [(R.addiction_threshold?"<br>Addiction: [R.addiction_threshold]u":"")] "

	if(R.impure_chem && R.impure_chem != /datum/reagent/impure/fermiTox)
		R3 = GLOB.chemical_reagents_list[R.impure_chem]
		outstring += "<br>Impure: \[\[#[R3.name]|[R3.name]\]\]"

	if(R.inverse_chem && R.impure_chem != /datum/reagent/impure/fermiTox)
		R3 = GLOB.chemical_reagents_list[R.inverse_chem]
		outstring += "<br>Inverse: \[\[#[R3.name]|[R3.name]\]\] [(R3.inverse_chem_val?"<br>Inverse purity: [R3.inverse_chem_val]":"")] "

	if(CR)
		if(CR.required_container)
			/*var/obj/item/I
			I = istype(I, CR.required_container) if you can work out how to get this to work, by all means.
			outstring += "<br>Required container: [I.name]"*/
			outstring += "<br>Required container: [CR.required_container]"

	outstring += "\n|[R.pH]\n|-\n"
	outstring += ""
	return outstring

//Generate the big list of reaction based reactions.
//|Name | Reagents | Reaction vars | Description | Chem properties
/proc/generate_chemreactwiki_line(datum/chemical_reaction/CR)
	if(CR.results.len) //Handled prior
		return
	var/outstring = "!style='background-color:#FFEE88;'|[CR.name]\n|"

	//reagents
	var/datum/reagent/R3
	for(var/R2 in CR.required_reagents)
		R3 = GLOB.chemical_reagents_list[R2]
		outstring += "\[\[#[R3.name]|[R3.name]\]\]: [CR.required_reagents[R3.type]]u <br>"
	if(CR.required_catalysts)
		for(var/R2 in CR.required_catalysts)
			R3 = GLOB.chemical_reagents_list[R2]
			outstring += "Catalyst: \[\[#[R3.name]|[R3.name]\]\]: [CR.required_catalysts[R3.type]]u<br>"
	outstring += " \n|"

	//Reaction vars
	if(CR.required_temp)
		outstring += "<br>Min react temp: [CR.required_temp]K"
	if(CR.FermiChem)
		outstring += "[(CR.FermiChem?"<br>Min react temp: [CR.OptimalTempMin]K":"[(CR.required_temp?"<br>Min react temp: [CR.required_temp]K":"")]")] [(CR.FermiChem?"<br>Explosion temp: [CR.ExplodeTemp]K":"")] [(CR.FermiChem?"<br>pH range: [max((CR.OptimalpHMin - CR.ReactpHLim), 0)] to [min((CR.OptimalpHMax + CR.ReactpHLim), 14)]":"")] <br>Minimum purity: [CR.PurityMin] [(CR.FermiExplode?"<br>Special explosion: Yes":"")]"
	if(CR.is_cold_recipe)
		outstring += "<br>Cold: Yes"
	if(CR.required_container)
		outstring += "<br>Required container: [CR.required_container]"
	if(CR.mob_react)
		outstring += "<br>Can react in mob: Yes"

	//description
	outstring += "\n| fill in manually "

	outstring += "\n|-\n"
	return outstring
