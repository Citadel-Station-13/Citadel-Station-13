PROCESSING_SUBSYSTEM_DEF(vectorcraft)
	name = "Vectorcraft Movement"
	priority = 40
	wait = 2
	stat_tag = "VC"
	flags = SS_NO_INIT|SS_TICKER|SS_KEEP_TIMING

	//var/flightsuit_processing = FLIGHTSUIT_PROCESSING_FULL


/* unsure if needed
/datum/controller/subsystem/processing/vectorcraft/Initialize()
	sync_flightsuit_processing()

/datum/controller/subsystem/processing/vectorcraft/vv_edit_var(var_name, var_value)
	..()
	switch(var_name)
		if("flightsuit_processing")
			sync_flightsuit_processing()

/datum/controller/subsystem/processing/vectorcraft/proc/sync_flightsuit_processing()
	for(var/obj/vehicle/sealed/vectorcraft/VC in processing)
		VC.sync_processing(src)
	if(flightsuit_processing == FLIGHTSUIT_PROCESSING_NONE)	//Don't even bother firing.
		can_fire = FALSE
	else
		can_fire = TRUE
*/
