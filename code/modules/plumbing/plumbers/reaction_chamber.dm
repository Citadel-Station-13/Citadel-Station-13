///a reaction chamber for plumbing. pretty much everything can react, but this one keeps the reagents seperated and only reacts under your given terms
/obj/machinery/plumbing/reaction_chamber
	name = "reaction chamber"
	desc = "Keeps chemicals seperated until given conditions are met."
	icon_state = "reaction_chamber"

	buffer = 200
	reagent_flags = TRANSPARENT | NO_REACT
	/**list of set reagents that the reaction_chamber allows in, and must all be present before mixing is enabled.
	* example: list(/datum/reagent/water = 20, /datum/reagent/fuel/oil = 50)
	*/
	var/list/required_reagents = list()
	///our reagent goal has been reached, so now we lock our inputs and start emptying
	var/emptying = FALSE

/obj/machinery/plumbing/reaction_chamber/Initialize(mapload, bolt)
	. = ..()
	AddComponent(/datum/component/plumbing/reaction_chamber, bolt)

/obj/machinery/plumbing/reaction_chamber/on_reagent_change()
	if(reagents.total_volume == 0 && emptying) //we were emptying, but now we aren't
		emptying = FALSE
		reagent_flags |= NO_REACT

/obj/machinery/plumbing/reaction_chamber/power_change()
	. = ..()
	if(use_power != NO_POWER_USE)
		icon_state = initial(icon_state) + "_on"
	else
		icon_state = initial(icon_state)

/obj/machinery/plumbing/reaction_chamber/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "reaction_chamber", name, 500, 300, master_ui, state)
		ui.open()

/obj/machinery/plumbing/reaction_chamber/ui_data(mob/user)
	var/list/data = list()
	var/list/text_reagents = list()
	for(var/A in required_reagents) //make a list where the key is text, because that looks alot better in the ui than a typepath
		var/datum/reagent/R = GLOB.chemical_reagents_list[A]
		text_reagents[initial(R.name)] = required_reagents[A] //Name : Vol

	data["reagents"] = text_reagents
	data["emptying"] = emptying
	return data

/obj/machinery/plumbing/reaction_chamber/ui_act(action, params)
	if(..())
		return
	. = TRUE
	switch(action)
		if("remove")
			var/LL = required_reagents.len
			LL =-1
			if(LL > 1)
				required_reagents.Cut(LL,0)
			else if(LL == 0)
				required_reagents.Cut(1,0)
			else
				return
		if("add")
			var/input_reagent = replacetext(lowertext(input("Enter the name of the reagent", "Input") as text), " ", "") //95% of the time, the reagent id is a lowercase/no spaces version of the nam
			input_reagent = find_reagent(input_reagent)
			if(!input_reagent || !GLOB.chemical_reagents_list[input_reagent])
				say("Cannot find reagent in NanoTrasen database!")
				return
			if(input_reagent && !required_reagents.Find(input_reagent))
				var/input_amount = CLAMP(round(input("Enter amount", "Input") as num|null), 0.01, 100)
				if(input_amount)
					required_reagents[input_reagent] = input_amount
