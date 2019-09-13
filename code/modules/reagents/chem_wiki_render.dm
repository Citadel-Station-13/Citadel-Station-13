//Generates a markdown txt file for use with the wiki

/client/proc/generate_wikichem_list()
	set category = "debug"
	set name = "generate_wikichem_list"
	set desc = "generate a huge loglist of all the chems. Do not click unless you want lag."

    var/prefix = list("**Name** | **Reagent pH** | **Reagents** | **Reaction temp** | **Explosion temp** | **pH range** | **Kinetics** | **Description** | **OD level** | **Addiction level** | **Metabolism rate** |**Impure chem** \n---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|")
    var/medicine
    var/toxin
    var/consumable
    var/plant
    var/uranium
    var/colours
    var/muta
    var/fermi
    var/remainder

    ///datum/reagent/medicine, /datum/reagent/toxin, /datum/reagent/consumable, /datum/reagent/plantnutriment, /datum/reagent/uranium,
    ///datum/reagent/colorful_reagent, /datum/reagent/mutationtoxin, /datum/reagent/fermi

	//Probably not the most eligant of solutions.
    for(var/datum/reagent/R in GLOB.chemical_reagents_list)
        if(istype(R, /datum/reagent/medicine))
			medicine += generate_chemwiki_line(R)

        else if(istype(R, /datum/reagent/toxin))
			toxin += generate_chemwiki_line(R)

        else if(istype(R, /datum/reagent/consumable))
			consumable += generate_chemwiki_line(R)

        else if(istype(R, /datum/reagent/plantnutriment))
			plant += generate_chemwiki_line(R)

        else if(istype(R, /datum/reagent/uranium))
			uranium += generate_chemwiki_line(R)

        else if(istype(R, /datum/reagent/colorful_reagent))
			colours += generate_chemwiki_line(R)

        else if(istype(R, /datum/reagent/mutationtoxin))
			muta += generate_chemwiki_line(R)

        else if(istype(R, /datum/reagent/fermi))
			fermi += generate_chemwiki_line(R)

        else
			remainer += generate_chemwiki_line(R)


	log_sql("------------BEGINNING OF REAGENTS VAR DUMP:------------------\n
	----------------------------------------------------------------------------------\n\n\n
	#BASIC REAGENTS\n[prefix][remainder]\n
	#MEDICINE:\n[prefix][medicine]\n#TOXIN:\n[prefix][toxin]\n#CONSUMABLE\n[prefix][consumable]\n
	#FERMI\nThese chems lie on the cutting edge of chemical technology, and as such are not recommended for beginners!\n[prefix][fermi]\n
	#PLANTS\n[prefix][plant]\n#URANIUM\n[prefix][uranium]\n#COLOURS\n[prefix][colours]\n
	#RACE MUTATIONS\n[prefix][muta]\n")



/proc/generate_chemwiki_line(datum/reagent/R)
	//name | Reagent pH | reagents | reaction temp | explosion temp | pH range | Kinetics | description | OD level | Addiction level | Metabolism rate | impure chem | inverse chem
	var/datum/chemical_reaction/CR = GLOB.chemical_reactions_list[R.id]
	if(!CR)
		CR = FALSE
	var/outstring = "[R.name] | [R.ph] | <ul>"
	for(var/R2 in R.required_reagents)
		var/R3 GLOB.chemical_reagents_list[R2]//What a convoluted mess
		outstring += "<li>[R3.name]</li>"

	//Temp, Explosions and pH
	outstring += "</ul> | [(CR.FermiChem?"[CR.OptimalTempMin]":"[(CR.required_temp?"[CR.required_temp]":"N/A")]")] | [(CR.FermiChem?"[CR.ExplodeTemp]":"N/A")] | [(CR.FermiChem?"[max((CR.OptimalpHMin - CR.ReactpHLim), 0)] - [min((CR.OptimalpHMax + CR.ReactpHLim), 14)]":"N/A")] | "

	//Kinetics
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
		outstring += "N/A | "

	//Description, OD, Addict, Meta
	outstring += "[R.description] | [(R.overdose_threshold?"[R.overdose_threshold]":"N/A")] | [(R.addiction_threshold?"[R.addiction_threshold]":"N/A")] | [R.metabolization_rate * REAGENTS_METABOLISM] | "

	if(R.ImpureChem != "fermiTox" || !R.ImpureChem)
		outstring += "[R.ImpureChem] |"
	else
		outstring += "N/A |"

	if(R.InverseChem != "fermiTox" || !R.InverseChem)
		outstring += "[R.InverseChem] |"
	else
		outstring += "N/A |"

	return outstring
