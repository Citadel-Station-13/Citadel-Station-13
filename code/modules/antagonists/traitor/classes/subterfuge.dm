/datum/traitor_class/human/subterfuge
	name = "MI13 Operative"
	employer = "MI13"
	weight = 36
	chaos = -5

/datum/traitor_class/human/subterfuge/forge_single_objective(datum/antagonist/traitor/T)
	.=1
	var/assassin_prob = 30
	var/datum/game_mode/dynamic/mode
	if(istype(SSticker.mode,/datum/game_mode/dynamic))
		mode = SSticker.mode
		assassin_prob = max(0,mode.threat_level-40)
	if(prob(assassin_prob))
		if(prob(assassin_prob))
			var/datum/objective/assassinate/once/kill_objective = new
			kill_objective.owner = T.owner
			kill_objective.find_target()
			T.add_objective(kill_objective)
		else
			var/datum/objective/maroon/maroon_objective = new
			maroon_objective.owner = T.owner
			maroon_objective.find_target()
			T.add_objective(maroon_objective)
	else
		var/list/weights = list()
		weights["sabo"] = length(subtypesof(/datum/sabotage_objective))
		weights["steal"] = length(subtypesof(/datum/objective_item/steal))
		weights["download"] = !(locate(/datum/objective/download) in T.objectives || (T.owner.assigned_role in list("Research Director", "Scientist", "Roboticist")))
		switch(pickweight(weights))
			if("sabo")
				var/datum/objective/sabotage/sabotage_objective = new
				sabotage_objective.owner = T.owner
				sabotage_objective.find_target()
				T.add_objective(sabotage_objective)
			if("steal")
				var/datum/objective/steal/steal_objective = new
				steal_objective.owner = T.owner
				steal_objective.find_target()
				T.add_objective(steal_objective)
			if("download")
				var/datum/objective/download/download_objective = new
				download_objective.owner = T.owner
				download_objective.gen_amount_goal()
				T.add_objective(download_objective)
