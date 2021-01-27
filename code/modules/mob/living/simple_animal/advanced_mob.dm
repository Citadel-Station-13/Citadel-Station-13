// an advanced simple_animal allowing for finegrained edits
/mob/living/simple_animal/hostile/advanced
	// loot is broken down into the following format:
	// it is a list where each element corresponds to a single dropped item, which is represented as a list
	// the first item in the sublist is the path of the item to be dropped
	// the second item in the sublist is a list corresponding of variable names matching to variable values
	// example to drop a sword called 'cool sword' with 24 force: list(list(/obj/item/sword, list("name" = "cool sword", "force" = 24)))
	var/list/advanced_loot

	//set this if you want loot to be put in a container
	var/loot_container

	// phases occur at hp thresholds and apply a set of var changes to the mob
	// current phase is updated when hp is reduced
	var/current_phase = "default"

	// phase format is each item in the phases list is a phase id linking to a list one element being the hp threshold, the second being a list connecting var names to values
	// the final third value is optional and is a line the mob says upon reaching the threshold
	// hp threshold is % of hp, i.e. the value 10 means 10% hp threshold, going below 10% would activate the phase
	// example to make a phase where its name changes at below 50% hp: list("angry" = list(50, list("name" = "angry advanced enemy")), "I AM ANGRY")
	var/list/phases

// attempts to drop advanced loot, depending on if there is any
/mob/living/simple_animal/hostile/advanced/drop_loot()
	var/container
	if(loot_container)
		container = new loot_container(get_turf(src))
	if(length(advanced_loot))
		for(var/loot_item in advanced_loot)
			var/path_name = loot_item[1]
			var/loot_object = new path_name(container ? container : get_turf(src))
			if(length(loot_item) == 2) //it has variables to set
				var/loot_vars = loot_item[2]
				var/datum/datum_loot = loot_object
				for(var/loot_var in loot_vars)
					if(datum_loot.vars[loot_var])
						datum_loot.vars[loot_var] = loot_vars[loot_var]

// check if the phase needs to be changed, and if it does, change it
// it does this by looking for the lowest phase hp threshold that is above the mob's current hp, i.e. if it's at 50% hp it will look for the lowest phase above or equal to 50% hp
/mob/living/simple_animal/hostile/advanced/proc/phase_check()
	if(length(phases))
		var/percentage = (health / maxHealth) * 100
		var/closest_phase
		for(var/phase_id in phases)
			var/list/phase = phases[phase_id]
			if(length(phase) >= 2 && phase[1] >= percentage)
				if(!closest_phase || (phase[1] < phases[closest_phase][1]))
					closest_phase = phase_id
		if(closest_phase && closest_phase != current_phase)
			change_phase(closest_phase)

// change the phase to a given one, this is not a safe proc, it should only ever be called by phase_check
/mob/living/simple_animal/hostile/advanced/proc/change_phase(var/phase)
	current_phase = phase
	var/list/corresponding_phase_list = phases[phase]
	var/datum/datum_self = src
	var/phase_vars = corresponding_phase_list[2]
	if(phase_vars[2])
		for(var/phase_var in phase_vars)
			if(datum_self.vars[phase_var])
				datum_self.vars[phase_var] = phase_vars[phase_var]

/mob/living/simple_animal/hostile/advanced/updatehealth()
	. = ..()
	phase_check()