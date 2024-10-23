/datum/element/ventcrawling
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH
	id_arg_index = 2
	var/tier

/datum/element/ventcrawling/Attach(datum/target, duration = 0, given_tier = VENTCRAWLER_NUDE)
	. = ..()

	var/mob/living/person = target
	if(!istype(person))
		return FALSE

	src.tier = given_tier

	RegisterSignal(target, COMSIG_HANDLE_VENTCRAWL, PROC_REF(handle_ventcrawl))
	RegisterSignal(target, COMSIG_CHECK_VENTCRAWL, PROC_REF(check_ventcrawl))
	to_chat(target, "<span class='notice'>You can ventcrawl! Use alt+click on vents to quickly travel about the station.</span>")

	if(duration!=0)
		addtimer(CALLBACK(src, PROC_REF(Detach), target), duration)

/datum/element/ventcrawling/Detach(datum/target)
	UnregisterSignal(target, list(COMSIG_HANDLE_VENTCRAWL, COMSIG_CHECK_VENTCRAWL))
	to_chat(target, "<span class='notice'>You can no longer ventcrawl.</span>")

	return ..()

/datum/element/ventcrawling/proc/handle_ventcrawl(datum/target,atom/A)
	var/mob/living/person = target
	if(!istype(person))
		return FALSE

	person.handle_ventcrawl(A,tier)

/datum/element/ventcrawling/proc/check_ventcrawl()
	return tier
