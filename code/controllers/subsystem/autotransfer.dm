SUBSYSTEM_DEF(autotransfer)
	name = "Autotransfer Vote"
	flags = SS_KEEP_TIMING | SS_BACKGROUND
	wait = 1 MINUTES

	var/starttime
	var/targettime
	var/voteinterval
	var/maxvotes
	var/curvotes

/datum/controller/subsystem/autotransfer/Initialize(timeofday)
	starttime = world.time
	targettime = starttime + CONFIG_GET(number/vote_autotransfer_initial)
	voteinterval = CONFIG_GET(number/vote_autotransfer_interval)
	maxvotes = CONFIG_GET(number/vote_autotransfer_maximum)
	curvotes = 0
	return ..()

/datum/controller/subsystem/autotransfer/fire()
	if(maxvotes > curvotes)
		if(world.time > targettime)
			SSvote.initiate_vote("transfer",null) //TODO figure out how to not use null as the user
			targettime = targettime + voteinterval
			curvotes += 1
	else
		SSshuttle.autoEnd()
