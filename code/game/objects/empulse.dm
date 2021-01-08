/proc/empulse(turf/epicenter, power, log=0)
	if(!epicenter)
		return

	if(!isturf(epicenter))
		epicenter = get_turf(epicenter.loc)

	var/max_distance = max(round((power/7)^0.7), 1)

	if(log)
		message_admins("EMP with power [power], max distance [max_distance] in area [epicenter.loc.name] ")
	log_game("EMP with power [power], max distance [max_distance] in area [epicenter.loc.name] ")
	deadchat_broadcast("<span class='deadsay bold'>EMP with power ([power]), max distance ([max_distance]) in [epicenter.loc.name]</span>", turf_target = epicenter)

	if(power > 100)
		new /obj/effect/temp_visual/emp/pulse(epicenter)

	for(var/A in spiral_range(max_distance, epicenter))
		var/atom/T = A
		var/distance = get_dist(epicenter, T)
		var/severity = 100
		if(distance != 0) //please dont divide by 0
			severity = min(max((max_distance / distance^0.3) * (100/max_distance), 1),100) //if it goes below 1 or above 100 stuff gets bad
		T.emp_act(severity)
	return 1

/proc/empulse_using_range(turf/epicenter, range, log=0) //make an emp using range instead of power
	var/power_from_range = (7*(range^(1/0.7)))
	empulse(epicenter, power_from_range, log)
