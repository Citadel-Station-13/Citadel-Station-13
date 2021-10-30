/mob/living
	var/list/alternate_screams

/mob/living/carbon/proc/reindex_screams()
	clear_screams()
	for(var/obj/item/I as anything in inventory?.AllItems(FALSE))
		add_screams(I.alternate_screams)

//Note that the following two are for /mob/living, while the above two are for /carbon and /human
/mob/living/proc/add_screams(var/list/screams)
	LAZYINITLIST(alternate_screams)
	if(!screams || screams.len == 0)
		return
	for(var/S in screams)
		LAZYADD(alternate_screams, S)

/mob/living/proc/clear_screams()
	LAZYINITLIST(alternate_screams)
	LAZYCLEARLIST(alternate_screams)
