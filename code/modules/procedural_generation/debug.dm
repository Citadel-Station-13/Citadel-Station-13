/**
 * Admin verb for testing a generator
 */
/client/proc/debug_procedural_generation_run()
	set name = "Procedural Generation Test"
	set desc = "Do a test and show results of a procedural generator"
	set cateogry = "Debug"

	var/list/possible = list()
	for(var/path in subtypesof(/datum/procedural_generation))
		var/datum/procedural_generation/it = path
		possible[initial(it.name)] = path

	var/picked = tgui_input_list(mob, "Which procedural generator to run?", "Procedural Generation Test", possible)
	if(!ispath(possible[picked]))
		return

	var/datum/procedural_generation/instance = new possiible[picked]
	var/list/variables = tgui_input_varlist(usr, null, "Generation Variables", instance.Variables())

	instance.Initialize(variables)
	instance.run()
	instance.Render(mob)
