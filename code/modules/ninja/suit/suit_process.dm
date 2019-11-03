/obj/item/clothing/suit/space/space_ninja/process()
	if(!affecting || !s_initialized)
		return PROCESS_KILL

	if(cell.charge > 0)
		if(s_coold)
			s_coold--//Checks for ability s_cooldown first.

		cell.charge -= s_cost//s_cost is the default energy cost each tick, usually 5.
		if(stealth && stealth_cooldown <= world.time)//If stealth is active.
			cell.charge -= s_acost
			affecting.alpha = max(affecting.alpha - 10, 15)

	else
		cell.charge = 0
		if(stealth)
			cancel_stealth()
