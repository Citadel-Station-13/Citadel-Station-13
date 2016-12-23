
/*
VVVVVVVV           VVVVVVVV     OOOOOOOOO     RRRRRRRRRRRRRRRRR   EEEEEEEEEEEEEEEEEEEEEE
V::::::V           V::::::V   OO:::::::::OO   R::::::::::::::::R  E::::::::::::::::::::E
V::::::V           V::::::V OO:::::::::::::OO R::::::RRRRRR:::::R E::::::::::::::::::::E
V::::::V           V::::::VO:::::::OOO:::::::ORR:::::R     R:::::REE::::::EEEEEEEEE::::E
 V:::::V           V:::::V O::::::O   O::::::O  R::::R     R:::::R  E:::::E       EEEEEE
  V:::::V         V:::::V  O:::::O     O:::::O  R::::R     R:::::R  E:::::E
   V:::::V       V:::::V   O:::::O     O:::::O  R::::RRRRRR:::::R   E::::::EEEEEEEEEE
    V:::::V     V:::::V    O:::::O     O:::::O  R:::::::::::::RR    E:::::::::::::::E
     V:::::V   V:::::V     O:::::O     O:::::O  R::::RRRRRR:::::R   E:::::::::::::::E
      V:::::V V:::::V      O:::::O     O:::::O  R::::R     R:::::R  E::::::EEEEEEEEEE
       V:::::V:::::V       O:::::O     O:::::O  R::::R     R:::::R  E:::::E
        V:::::::::V        O::::::O   O::::::O  R::::R     R:::::R  E:::::E       EEEEEE
         V:::::::V         O:::::::OOO:::::::ORR:::::R     R:::::REE::::::EEEEEEEE:::::E
          V:::::V           OO:::::::::::::OO R::::::R     R:::::RE::::::::::::::::::::E
           V:::V              OO:::::::::OO   R::::::R     R:::::RE::::::::::::::::::::E
            VVV                 OOOOOOOOO     RRRRRRRR     RRRRRRREEEEEEEEEEEEEEEEEEEEEE

-Aro <3 */

//	Check if an object is capable of eating things, based on vore_organs
//
/proc/is_vore_predator(var/mob/living/O)
	if(istype(O,/mob/living))
		if(O.vore_organs.len > 0)
			return 1

	return 0

//
//	Verb for toggling which orifice you eat people with!
//
/mob/living/proc/belly_select()
	set name = "Choose Belly"
	set category = "Vore"

	vore_selected = input("Choose Belly") in vore_organs
	src << "<span class='notice'>[vore_selected] selected.</span>"

//
//	Belly searching for simplifying other procs
//
/proc/check_belly(atom/movable/A)
	if(istype(get_turf(A),/mob/living))
		var/mob/living/M = get_turf(A)
		for(var/I in M.vore_organs)
			var/datum/belly/B = M.vore_organs[I]
			if(A in B.internal_contents)
				return(B)

	return 0

//
//	Verb for saving vore preferences to save file
//
/mob/living/proc/save_vore_prefs()
	set name = "Save Vore Prefs"
	set category = "Vore"

	var/result = 0

	if(client.prefs)
		result = client.prefs.save_vore_preferences()
	else
		src << "<span class='warning'>You attempted to save your vore prefs but somehow you're in this character without a client.prefs variable. Tell a dev.</span>"
		log_admin("[src] tried to save vore prefs but lacks a client.prefs var.")

	return result

//
//	Proc for applying vore preferences, given bellies
//
/mob/living/proc/apply_vore_prefs(var/list/bellies)
	if(!bellies || bellies.len == 0)
		log_admin("Tried to apply bellies to [src] and failed.")
