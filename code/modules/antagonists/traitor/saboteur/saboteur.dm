/datum/antagonist/traitor/midround/saboteur
	name = "Syndicate Saboteur"
	should_equip = FALSE
	special_role = "saboteur"

/datum/antagonist/traitor/midround/saboteur/greet()
	to_chat(owner.current, "<span class='userdanger'>You are the [special_role].</span>")
	to_chat(owner.current, "<B><font size=5 color=red>Unlike other syndicate agents, your job is simply to make the lives of the crewmembers harder. Kill only when absolutely necessary.</font></B>")
	owner.announce_objectives()

/datum/antagonist/traitor/midround/saboteur/forge_traitor_objectives()
	var/datum/objective/sabotage/sabotage_objective = new
	sabotage_objective.owner = owner
	sabotage_objective.find_target()
	add_objective(sabotage_objective)
	var/datum/objective/escape/escape_objective = new
	escape_objective.owner = owner
	add_objective(escape_objective)
