
/*

Contents:
- Stealth Verbs

*/


/obj/item/clothing/suit/space/space_ninja/proc/toggle_stealth()
	if(!affecting)
		return
	if(stealth)
		cancel_stealth()
	else
		if(cell.charge <= 0)
			to_chat(affecting, "<span class='warning'>You don't have enough power to enable Stealth!</span>")
			return
		stealth = !stealth
		animate(affecting, alpha = 10,time = 15)
		affecting.visible_message("<span class='warning'>[affecting.name] vanishes into thin air!</span>", \
						"<span class='notice'>You are now mostly invisible to normal detection.</span>")
		RegisterSignal(affecting, list(COMSIG_MOB_ITEM_ATTACK, COMSIG_MOB_ATTACK_RANGED, COMSIG_MOB_ATTACK_HAND, COMSIG_MOB_THROW, COMSIG_PARENT_ATTACKBY), .proc/reduce_stealth)
		RegisterSignal(affecting, COMSIG_MOVABLE_BUMP, .proc/bumping_stealth)

/obj/item/clothing/suit/space/space_ninja/proc/reduce_stealth()
	affecting.alpha = min(affecting.alpha + 30, 80)

/obj/item/clothing/suit/space/space_ninja/proc/bumping_stealth(datum/source, atom/A)
	if(isliving(A))
		affecting.alpha = min(affecting.alpha + 15, 80)

/obj/item/clothing/suit/space/space_ninja/proc/cancel_stealth()
	if(!affecting || !stealth)
		return FALSE
	stealth = !stealth
	UnregisterSignal(affecting, list(COMSIG_MOB_ITEM_ATTACK, COMSIG_MOB_ATTACK_RANGED, COMSIG_MOB_ATTACK_HAND, COMSIG_MOB_THROW, COMSIG_PARENT_ATTACKBY, COMSIG_MOVABLE_BUMP))
	animate(affecting, alpha = 255, time = 15)
	affecting.visible_message("<span class='warning'>[affecting.name] appears from thin air!</span>", \
					"<span class='notice'>You are now visible.</span>")
	return TRUE

/obj/item/clothing/suit/space/space_ninja/proc/stealth()
	if(!s_busy)
		toggle_stealth()
	else
		to_chat(affecting, "<span class='danger'>Stealth does not appear to work!</span>")
