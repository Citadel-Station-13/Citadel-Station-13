/mob/living/movement_delay(ignorewalk = 0)
	. = ..()
	if(resting)
		. += 6

/mob/living/proc/lay_down()
	set name = "Rest"
	set category = "IC"

	if(!resting)
		resting = TRUE
		to_chat(src, "<span class='notice'>You are now laying down.</span>")
		update_canmove()
	else
		resist_a_rest()

/mob/living/proc/resist_a_rest(ignoretimer = FALSE) //Lets mobs resist out of resting. Major QOL change with combat reworks.
	if(!resting || stat)
		return FALSE
	to_chat(src, "<span class='notice'>You are now getting up.</span>")
	if(ignoretimer)
		resting = FALSE
		update_canmove()
	else
		var/totaldelay = 3 //A little bit less than half of a second as a baseline for getting up from a rest
		var/health_deficiency = max(maxHealth - (health - staminaloss), 0)
		totaldelay += health_deficiency
		if(do_after(src, totaldelay, target = src))
			resting = FALSE
			update_canmove()
