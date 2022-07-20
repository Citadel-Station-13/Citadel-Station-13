/**
 * Persists polly messages across rounds
 */
/datum/controller/subsystem/persistence/LoadGamePersistence()
	. = ..()
	LoadPolly()

/datum/controller/subsystem/persistence/proc/LoadPolly()
	for(var/mob/living/simple_animal/parrot/Polly/P in GLOB.alive_mob_list)
		twitterize(P.speech_buffer, "polytalk")
		break //Who's been duping the bird?!
