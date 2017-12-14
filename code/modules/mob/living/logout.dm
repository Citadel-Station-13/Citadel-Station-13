<<<<<<< HEAD
/mob/living/Logout()
	if(ranged_ability && client)
		ranged_ability.remove_mousepointer(client)
	..()
=======
/mob/living/Logout()
	update_z(null)
	if(ranged_ability && client)
		ranged_ability.remove_mousepointer(client)
	..()
>>>>>>> de51ac3... Player Z-tracking, again (#33216)
	if(!key && mind)	//key and mind have become separated.
		mind.active = 0	//This is to stop say, a mind.transfer_to call on a corpse causing a ghost to re-enter its body.