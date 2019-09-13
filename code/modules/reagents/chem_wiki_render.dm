//Generates a markdown txt file for use with the wiki

/client/proc/generate_wikichem_list()
	set name = "Generate Wikichems"
	set category = "Debug"
	set desc = "Generate a huge loglist of all the chems. Do not click unless you want lag."

	message_admins("Someone pressed the superlag button. (Generate Wikichems)")
	to_chat(usr, "Generating list")
	var/prefix = "|Name | Reagents | Reaction vars | Description | Chem properties | Impure chems|\n|---|---|---|---|----------|---|\n"

    ///datum/reagent/medicine, /datum/reagent/toxin, /datum/reagent/consumable, /datum/reagent/plantnutriment, /datum/reagent/uranium,
    ///datum/reagent/colorful_reagent, /datum/reagent/mutationtoxin, /datum/reagent/fermi

	//Probably not the most eligant of solutions.
	to_chat(usr, "Attempting reagent scan. Length of list [LAZYLEN(GLOB.chemical_reagents_list)]")
	var/datum/reagent/R
	var/tally = 0
	var/processCR = TRUE //Process reactions first
	for(var/i = 1, i <= 2, i+=1)
		var/medicine = ""
		var/toxin = ""
		var/consumable = ""
		var/plant = ""
		var/uranium = ""
		var/colours = ""
		var/muta = ""
		var/fermi = ""
		var/remainder = ""
		for(var/X in GLOB.chemical_reagents_list)
			R = GLOB.chemical_reagents_list[X]
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

			else
				remainder += generate_chemwiki_line(R, X, processCR)

			tally++
			if((tally%50)==0)
				to_chat(usr, "[tally] of [LAZYLEN(GLOB.chemical_reagents_list)] done.")

		processCR = FALSE

		to_chat(usr, "finished chems")
		log_sql("------------BEGINNING OF REAGENTS VAR DUMP:------------------\n----------------------------------------------------------------------------------\n\n\n# BASIC REAGENTS\n\n[prefix][remainder]\n\n# MEDICINE:\n\n[prefix][medicine]\n\n# TOXIN:\n\n[prefix][toxin]\n\n# CONSUMABLE\n\n[prefix][consumable]\n\n# FERMI\n\nThese chems lie on the cutting edge of chemical technology, and as such are not recommended for beginners!\n\n[prefix][fermi]\n\n# PLANTS\n\n[prefix][plant]\n\n# URANIUM\n\n[prefix][uranium]\n\n# COLOURS\n\n[prefix][colours]\n\n# RACE MUTATIONS\n\n[prefix][muta]\n")

	prefix = "|Name | Reagents | Reaction vars | Description ||\n|---|---|---|----------|\n"
	to_chat(usr, "starting reactions")
	for(var/reagent in GLOB.chemical_reactions_list)
		for(var/datum/chemical_reaction/CR in GLOB.chemical_reactions_list[reagent])
			generate_chemreactwiki_line(CR)

	to_chat(usr, "finished reactions")

/proc/generate_chemwiki_line(datum/reagent/R, X, processCR)
	//name | Reagent pH | reagents | reaction temp | explosion temp | pH range | Kinetics | description | OD level | Addiction level | Metabolism rate | impure chem | inverse chem

	var/datum/chemical_reaction/CR = get_chemical_reaction(R.id)
	if((!CR && processCR) || (CR && !processCR)) // Do reactions first.
		return ""


	//message_admins("[CR]")
	var/outstring = "|[R.name] !\[[R.color]\](https://placehold.it/15/[copytext(R.color, 2, 8)]/000000?text=+) pH:[R.pH] | "
	var/datum/reagent/R3
	if(CR)
		outstring += "<ul>"
		for(var/R2 in CR.required_reagents)
			R3 = GLOB.chemical_reagents_list[R2]//What a convoluted mess
			outstring += "<li>[R3.name]</li>"
		if(CR.required_catalysts)
			for(var/R2 in CR.required_reagents)
				R3 = GLOB.chemical_reagents_list[R2]
				outstring += "<li>[R3.name]</li>"
		outstring += "</ul> | "
	else
		outstring += "N/A | "


	//Temp, Explosions and pH
	if(CR)
		outstring += "[(CR.FermiChem?"Min react temp:[CR.OptimalTempMin]":"[(CR.required_temp?"Min_react_temp:[CR.required_temp]":"")]")] [(CR.FermiChem?"Explosion_temp:[CR.ExplodeTemp]":"")] [(CR.FermiChem?"pH_range:[max((CR.OptimalpHMin - CR.ReactpHLim), 0)] to [min((CR.OptimalpHMax + CR.ReactpHLim), 14)]":"")] "
	else
		outstring += ""

	//Kinetics
	if(CR)
		if(CR.FermiChem)
			switch(CR.ThermicConstant)
				if(-INFINITY to -9.9)
					outstring += "Extremely endothermic | "
				if(-9.9 to -4.9)
					outstring += "Very endothermic | "
				if(-4.9 to -0.1)
					outstring += "Endothermic | "
				if(-0.1 to 0.1)
					outstring += "Neutral | "
				if(0.1 to 4.9)
					outstring += "Exothermic | "
				if(4.9 to 9.9)
					outstring += "Very exothermic | "
				if(9.9 to INFINITY)
					outstring += "Extremely exothermic | "
		else
			outstring += " | "
	else
		outstring += " | "

	//Description, OD, Addict, Meta
	outstring += "[R.description] | Metabolism_rate:[R.metabolization_rate] [(R.overdose_threshold?"[Overdose:R.overdose_threshold]":"")] [(R.addiction_threshold?"[Addiction:R.addiction_threshold]":"No addiction")] "

	if(R.ImpureChem != "fermiTox" || !R.ImpureChem)
		R3 = GLOB.chemical_reagents_list[R.ImpureChem]
		outstring += "Impure chem:[R3.name]"

	if(R.InverseChem != "fermiTox" || !R.InverseChem)
		R3 = GLOB.chemical_reagents_list[R.InverseChem]
		outstring += "Inverse chem:[R3.name] "

	if(CR)
		if(CR.FermiChem)
			outstring += "Minimum purity:[CR.PurityMin] [(CR.FermiExplode?"Special explosion:Yes":"")]"


	outstring += "|\n"
	//message_admins("[outstring]")
	return outstring

//|Name | Reagents | Reaction vars | Description | Chem properties
/proc/generate_chemreactwiki_line(datum/chemical_reaction/CR)
	if(!LAZYLEN(CR.results)) //Handled prior
		return
	var/outstring = "|CR.name | <ul>"

	//reagents
	for(var/R2 in CR.required_reagents)
		R3 = GLOB.chemical_reagents_list[R2]
		outstring += "<li>[R3.name]</li>"
	if(CR.required_catalysts)
		for(var/R2 in CR.required_reagents)
			R3 = GLOB.chemical_reagents_list[R2]
			outstring += "<li>[R3.name]</li>"
	outstring += "</ul> | "

	outstring += "| fill in manually | "

	//Reaction vars
	if(CR.FermiChem)
		outstring += "[(CR.FermiChem?"Min react temp:[CR.OptimalTempMin]":"[(CR.required_temp?"Min_react_temp:[CR.required_temp]":"")]")] [(CR.FermiChem?"Explosion_temp:[CR.ExplodeTemp]":"")] [(CR.FermiChem?"pH_range:[max((CR.OptimalpHMin - CR.ReactpHLim), 0)] to [min((CR.OptimalpHMax + CR.ReactpHLim), 14)]":"")] Minimum purity:[CR.PurityMin] [(CR.FermiExplode?"Special explosion:Yes":"")]"
	if(CR.is_cold_recipe)
		outstring += "Cold: Yes"
	if(CR.required_container)
		outstring += "Required container:[CR.required_container]"
	if(CR.mob_react)
		outstring += "Can react in mob: Yes"
