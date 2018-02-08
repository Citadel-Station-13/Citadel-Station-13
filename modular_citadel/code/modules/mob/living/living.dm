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
	if(ignoretimer)
		resting = FALSE
		update_canmove()
	else
		var/totaldelay = 3 //A little bit less than half of a second as a baseline for getting up from a rest
		var/health_deficiency = max(maxHealth - (health - staminaloss), 0)
		if(!has_gravity())
			health_deficiency = health_deficiency*0.2
		totaldelay += health_deficiency
		var/standupwarning = "[src] and everyone around them should probably yell at the dev team"
		switch(health_deficiency)
			if(-INFINITY to 10)
				standupwarning = "[src] stands right up!"
			if(10 to 35)
				standupwarning = "[src] tries to stand up."
			if(35 to 60)
				standupwarning = "[src] slowly pushes [p_them()]self upright."
			if(60 to 80)
				standupwarning = "[src] weakly attempts to stand up."
			if(80 to INFINITY)
				standupwarning = "[src] struggles to stand up."
		visible_message("<span class='notice'>[standupwarning]</span>", "<span class='notice'>You are now getting up.</span>", vision_distance = 5)
		if(do_after(src, totaldelay, target = src))
			resting = FALSE
			update_canmove()
		else
			visible_message("<span class='notice'>[src] falls right back down.</span>", "<span class='notice'>You fall right back down.</span>")
			if(has_gravity())
				playsound(src, "bodyfall", 20, 1)
