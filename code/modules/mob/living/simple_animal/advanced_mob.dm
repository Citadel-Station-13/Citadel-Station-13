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

// attempts to drop advanced loot, depending on if there is any
/mob/living/simple_animal/advanced/drop_loot()
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

