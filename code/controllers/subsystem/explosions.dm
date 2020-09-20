SUBSYSTEM_DEF(explosions)
	name = "Explosions"
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
	var/ran = 0
	while(length(currentrun) && !MC_TICK_CHECK)
		ran = 0
		for(var/i in currentrun)
			E = i
			if(E.tick())
				currentrun -= E
			ran++
		if(!ran)
			break
