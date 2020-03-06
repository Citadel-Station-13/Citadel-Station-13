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
	if(!CHECK_MOBILITY(src, MOBILITY_STAND))
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

/mob/living/carbon/update_stamina()
	var/total_health = getStaminaLoss()
	if(total_health)
		if(!recoveringstam && total_health >= STAMINA_CRIT && !stat)
			to_chat(src, "<span class='notice'>You're too exhausted to keep going...</span>")
			set_resting(TRUE, FALSE, FALSE)
			if(combatmode)
				toggle_combat_mode(TRUE)
			recoveringstam = TRUE
			filters += CIT_FILTER_STAMINACRIT
			update_mobility()
	if(recoveringstam && total_health <= STAMINA_SOFTCRIT)
		to_chat(src, "<span class='notice'>You don't feel nearly as exhausted anymore.</span>")
		recoveringstam = FALSE
		filters -= CIT_FILTER_STAMINACRIT
		update_mobility()
	update_health_hud()

/mob/living/proc/update_hud_sprint_bar()
	if(hud_used && hud_used.sprint_buffer)
		hud_used.sprint_buffer.update_to_mob(src)
