GLOBAL_DATUM_INIT(musical_config, /datum/musical_config, new)

/datum/musical_config

	var/highest_transposition = 4
	var/lowest_transposition = -4

	var/longest_sustain_timer = 50
	var/gentlest_drop = 1.07
	var/steepest_drop = 10.0

	var/channels_per_instrument = 128
	var/max_events = 2400
	var/song_editor_lines_per_page = 20

	var/usage_info_channel_resolution = 1
	var/usage_info_event_resolution = 8

	var/list/nn2no = list(0,2,4,5,7,9,11) // Maps note num onto note offset
