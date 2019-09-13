//Generates a markdown txt file for use with the wiki

/client/proc/generate_wikichem_list()
	set category = "debug"
	set name = "generate_wikichem_list"
	set desc = "generate a huge loglist of all the chems. Do not click unless you want lag."

    var/prefix = list("name | reagents | reaction temp | explosion temp | pH range | Kinetics | description | OD level | impure chem \n")
    var/medicine = list("")
    var/toxin = list("")
    var/consumable = list("")
    var/plant = list("")
    var/uranium = list("")
    var/colours = list("")
    var/muta = list("")
    var/fermi = list("")
    var/remainder = list("")

    ///datum/reagent/medicine, /datum/reagent/toxin, /datum/reagent/consumable, /datum/reagent/plantnutriment, /datum/reagent/uranium,
    ///datum/reagent/colorful_reagent, /datum/reagent/mutationtoxin, /datum/reagent/fermi

    for(var/datum/reagent/R in GLOB.chemical_reagents_list)
        if(istype(R, /datum/reagent/medicine))

        else if(istype(R, /datum/reagent/toxin))

        else if(istype(R, /datum/reagent/consumable))

        else if(istype(R, /datum/reagent/plantnutriment))

        else if(istype(R, /datum/reagent/uranium))

        else if(istype(R, /datum/reagent/colorful_reagent))

        else if(istype(R, /datum/reagent/mutationtoxin))

        else if(istype(R, /datum/reagent/fermi))

        else


    log_game("FERMICHEM: MKULTRA: Status applied on [owner] ckey: [owner.key] with a master of [master] ckey: [enthrallID].")

    //name | reagents | reaction temp | explosion temp | pH range | Kinetics | description | OD level | impure chem

/proc/generate_line(datum/reagent/R)
