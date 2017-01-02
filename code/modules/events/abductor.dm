/datum/round_event_control/abductor
	name = "Abductors"
	typepath = /datum/round_event/ghost_role/abductor
	weight = 5
	max_occurrences = 1

	min_players = 5
	earliest_start = 18000 // 30 min

	gamemode_blacklist = list("nuclear","wizard","revolution","abduction")

/datum/round_event/ghost_role/abductor
	minimum_required = 2
	role_name = "abductor team"

/datum/round_event/ghost_role/abductor/spawn_role()
	var/list/mob/dead/observer/candidates = get_candidates("abductor", null, ROLE_ABDUCTOR)

	if(candidates.len < 2)
		return NOT_ENOUGH_PLAYERS
	//Oh god why we can't have static functions
	// I feel your pain, bro
	var/number = ticker.mode.abductor_teams + 1

	var/datum/game_mode/abduction/temp
	if(ticker.mode.config_tag == "abduction")
		temp = ticker.mode
	else
		temp = new

	var/agent_mind = popleft(candidates)
	var/scientist_mind = popleft(candidates)

	var/mob/living/carbon/human/agent = makeBody(agent_mind)
	var/mob/living/carbon/human/scientist = makeBody(scientist_mind)

	agent_mind = agent.mind
	scientist_mind = scientist.mind

	temp.scientists.len = number
	temp.agents.len = number
	temp.abductors.len = 2*number
	temp.team_objectives.len = number
	temp.team_names.len = number
	temp.scientists[number] = scientist_mind
	temp.agents[number] = agent_mind
	temp.abductors |= list(agent_mind,scientist_mind)
	temp.make_abductor_team(number,preset_scientist=scientist_mind,preset_agent=agent_mind)
	temp.post_setup_team(number)

	ticker.mode.abductor_teams++

	if(ticker.mode.config_tag != "abduction")
		ticker.mode.abductors |= temp.abductors

	spawned_mobs += list(agent, scientist)
	return SUCCESSFUL_SPAWN
