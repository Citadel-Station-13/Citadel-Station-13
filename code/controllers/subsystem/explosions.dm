SUBSYSTEM_DEF(explosions)
	wait = 1
	flags = SS_TICKER
	priority = FIRE_PRIORITY_EXPLOSIONS
	var/static/list/datum/explosion2/wave_explosions = list()
	var/static/list/datum/explosion2/active_wave_explosions = list()
	var/static/list/datum/explosion2/currentrun = list()

/datum/controller/subsystem/explosions/fire(resumed)
	if(!resumed)
		currentrun = active_wave_explosions.Copy()
	var/datum/explosion2/E
	while(length(currentrun) && !MC_TICK_CHECK)
		for(var/i in currentrun)
			E = i
			E.tick()
