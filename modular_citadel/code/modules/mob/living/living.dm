/mob/living
	var/sprinting = FALSE
	var/recoveringstam = FALSE
	var/incomingstammult = 1
	var/bufferedstam = 0
	var/stambuffer = 20
	var/stambufferregentime
	var/attemptingstandup = FALSE
	var/intentionalresting = FALSE
	var/attemptingcrawl = FALSE

	//Sprint buffer---
	var/sprint_buffer = 42					//Tiles
	var/sprint_buffer_max = 42
	var/sprint_buffer_regen_ds = 0.3		//Tiles per world.time decisecond
	var/sprint_buffer_regen_last = 0		//last world.time this was regen'd for math.
	var/sprint_stamina_cost = 0.70			//stamina loss per tile while insufficient sprint buffer.
	//---End

/mob/living/update_config_movespeed()
	. = ..()
	sprint_buffer_max = CONFIG_GET(number/movedelay/sprint_buffer_max)
	sprint_buffer_regen_ds = CONFIG_GET(number/movedelay/sprint_buffer_regen_per_ds)
	sprint_stamina_cost = CONFIG_GET(number/movedelay/sprint_stamina_cost)

/mob/living/movement_delay(ignorewalk = 0)
	. = ..()
	if(resting)
		. += 6

/atom
	var/pseudo_z_axis

/atom/proc/get_fake_z()
	return pseudo_z_axis

/obj/structure/table
	pseudo_z_axis = 8

/turf/open/get_fake_z()
	var/objschecked
	for(var/obj/structure/structurestocheck in contents)
		objschecked++
		if(structurestocheck.pseudo_z_axis)
			return structurestocheck.pseudo_z_axis
		if(objschecked >= 25)
			break
	return pseudo_z_axis

/mob/living/Move(atom/newloc, direct)
	. = ..()
	if(.)
		pseudo_z_axis = newloc.get_fake_z()
		pixel_z = pseudo_z_axis

/mob/living/proc/lay_down()
	set name = "Rest"
	set category = "IC"

	if(client && client.prefs && client.prefs.autostand)
		intentionalresting = !intentionalresting
		to_chat(src, "<span class='notice'>You are now attempting to [intentionalresting ? "[!resting ? "lay down and ": ""]stay down" : "[resting ? "get up and ": ""]stay up"].</span>")
		if(intentionalresting && !resting)
			resting = TRUE
			update_canmove()
		else
			resist_a_rest()
	else
		if(!resting)
			resting = TRUE
			to_chat(src, "<span class='notice'>You are now laying down.</span>")
			update_canmove()
		else
			resist_a_rest()

/mob/living/proc/resist_a_rest(automatic = FALSE, ignoretimer = FALSE) //Lets mobs resist out of resting. Major QOL change with combat reworks.
	if(!resting || stat || attemptingstandup)
		return FALSE
	if(ignoretimer)
		resting = FALSE
		update_canmove()
		return TRUE
	else
		var/totaldelay = 3 //A little bit less than half of a second as a baseline for getting up from a rest
		if(getStaminaLoss() >= STAMINA_SOFTCRIT)
			to_chat(src, "<span class='warning'>You're too exhausted to get up!")
			return FALSE
		attemptingstandup = TRUE
		var/health_deficiency = max((maxHealth - (health - getStaminaLoss()))*0.5, 0)
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
		var/usernotice = automatic ? "<span class='notice'>You are now getting up. (Auto)</span>" : "<span class='notice'>You are now getting up.</span>"
		visible_message("<span class='notice'>[standupwarning]</span>", usernotice, vision_distance = 5)
		if(do_after(src, totaldelay, target = src))
			resting = FALSE
			attemptingstandup = FALSE
			update_canmove()
			return TRUE
		else
			visible_message("<span class='notice'>[src] falls right back down.</span>", "<span class='notice'>You fall right back down.</span>")
			attemptingstandup = FALSE
			if(has_gravity())
				playsound(src, "bodyfall", 20, 1)
			return FALSE

/mob/living/carbon/update_stamina()
	var/total_health = getStaminaLoss()
	if(total_health)
		if(!recoveringstam && total_health >= STAMINA_CRIT && !stat)
			to_chat(src, "<span class='notice'>You're too exhausted to keep going...</span>")
			resting = TRUE
			if(combatmode)
				toggle_combat_mode(TRUE)
			recoveringstam = TRUE
			filters += CIT_FILTER_STAMINACRIT
			update_canmove()
	if(recoveringstam && total_health <= STAMINA_SOFTCRIT)
		to_chat(src, "<span class='notice'>You don't feel nearly as exhausted anymore.</span>")
		recoveringstam = FALSE
		filters -= CIT_FILTER_STAMINACRIT
		update_canmove()
	update_health_hud()

/mob/living/proc/update_hud_sprint_bar()
	if(hud_used && hud_used.sprint_buffer)
		hud_used.sprint_buffer.update_to_mob(src)
