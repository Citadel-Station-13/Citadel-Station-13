/datum/config_entry/flag/allow_latejoin_antagonists	// If late-joining players can be traitor/changeling

/datum/config_entry/flag/use_antag_rep // see game_options.txt for details

/datum/config_entry/number/antag_rep_maximum
	config_entry_value = 200
	min_val = 0

/datum/config_entry/number/default_antag_tickets
	config_entry_value = 100
	min_val = 0

/datum/config_entry/number/max_tickets_per_roll
	config_entry_value = 100
	min_val = 0

/datum/config_entry/number/midround_antag_time_check	// How late (in minutes you want the midround antag system to stay on, setting this to 0 will disable the system)
	config_entry_value = 60
	min_val = 0

/datum/config_entry/number/midround_antag_life_check	// A ratio of how many people need to be alive in order for the round not to immediately end in midround antagonist
	config_entry_value = 0.7
	integer = FALSE
	min_val = 0
	max_val = 1

/datum/config_entry/number/traitor_scaling_coeff	//how much does the amount of players get divided by to determine traitors
	config_entry_value = 6
	min_val = 1

/datum/config_entry/number/brother_scaling_coeff	//how many players per brother team
	config_entry_value = 25
	min_val = 1

/datum/config_entry/number/changeling_scaling_coeff	//how much does the amount of players get divided by to determine changelings
	config_entry_value = 6
	min_val = 1

/datum/config_entry/number/security_scaling_coeff	//how much does the amount of players get divided by to determine open security officer positions
	config_entry_value = 8
	min_val = 1

/datum/config_entry/number/abductor_scaling_coeff	//how many players per abductor team
	config_entry_value = 15
	min_val = 1

/datum/config_entry/number/traitor_objectives_amount
	config_entry_value = 2
	min_val = 0

/datum/config_entry/number/brother_objectives_amount
	config_entry_value = 2
	min_val = 0

/datum/config_entry/flag/show_game_type_odds	//if set this allows players to see the odds of each roundtype on the get revision screen
