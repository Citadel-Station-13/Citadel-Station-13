/**
 * Persists poly messages across rounds
 */
/datum/controller/subsystem/persistence/LoadGamePersistence()
	. = ..()
	LoadPoly()

/datum/controller/subsystem/persistence/proc/LoadPoly()
	for(var/mob/living/simple_animal/parrot/Poly/P in GLOB.alive_mob_list)
		twitterize(P.speech_buffer, "polytalk")
		break //Who's been duping the bird?!
