//Jacq test
/mob/living/jacq
	name = "Jacqueline"
	real_name = "Jacqueline"
	icon = 'icons/obj/halloween_items.dmi'
	icon_state = "jacqueline"
	maxHealth = INFINITY
	health = INFINITY
	speak_emote = list("croons")
	emote_hear = list("spooks","giggles")
	density = FALSE
    var/destinations = list("Bar", "Brig", "Bridge", "Chapel", "Chemistry", "Cyrogenics", "Engineering", )
    var/tricked = list() //Those who have been tricked

/mob/living/jacq/proc/poof()
    var/area/A = GLOB.sortedAreas["[pick(destinations)]"]
    if(A && istype(A))
        if(M.forceMove(safepick(get_area_turfs(A))))


/mob/living/jacq/proc/chit_chat()
    

/mob/living/jacq/proc/trick()
    var/
//var/area/A = input(usr, "Pick an area.", "Pick an area") in GLOB.sortedAreas|null
