/mob/living/silicon/robot
	speed = 0.2 
	var/hasShrunk = FALSE

/mob/living/silicon/robot/modules/roleplay
	lawupdate = FALSE
	scrambledcodes = TRUE // Roleplay borgs aren't real
	set_module = /obj/item/robot_module/roleplay

/mob/living/silicon/robot/modules/roleplay/Initialize()
	. = ..()
	cell = new /obj/item/stock_parts/cell/infinite(src, 30000)
	laws = new /datum/ai_laws/roleplay()
	//You aren't allowed to unlock, not sorry
	src.verbs -= /mob/living/silicon/robot/verb/unlock_own_cover
	//This part is because the camera stays in the list, so we'll just do a check
	if(!QDELETED(builtInCamera))
		QDEL_NULL(builtInCamera)

/mob/living/silicon/robot/modules/roleplay/binarycheck()
	return 0 //Roleplay borgs aren't truly borgs
