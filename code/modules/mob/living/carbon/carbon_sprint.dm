/// Sprint buffer ///
/mob/living/carbon/doSprintLossTiles(tiles)
	doSprintBufferRegen(FALSE)		//first regen.
	if(sprint_buffer)
		var/use = min(tiles, sprint_buffer)
		sprint_buffer -= use
		tiles -= use
	update_hud_sprint_bar()
	if(!tiles)		//we had enough, we're done!
		return
	adjustStaminaLoss(tiles * sprint_stamina_cost)		//use stamina to cover deficit.

/mob/living/carbon/proc/doSprintBufferRegen(updating = TRUE)
	var/diff = world.time - sprint_buffer_regen_last
	sprint_buffer_regen_last = world.time
	sprint_buffer = min(sprint_buffer_max, sprint_buffer + sprint_buffer_regen_ds * diff)
	if(updating)
		update_hud_sprint_bar()
