
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

// The datum type bolted onto normal preferences datums for storing Vore stuff
//
/client
	var/datum/vore_preferences/prefs_vr

/datum/preferences
	var/datum/vore_preferences/prefs_vr

/hook/client_new/proc/add_prefs_vr(client/C)
	C.prefs_vr = new/datum/vore_preferences(C)
	if(C.prefs_vr)
		return 1

	return 0

/datum/vore_preferences
	//Actual preferences
	var/digestable = 1
	var/devourable = 1
	var/list/belly_prefs = list()

	//Mechanically required
	var/path
	var/slot
	var/client/client
	var/client_ckey

/datum/vore_preferences/New(client/C)
	if(istype(C))
		client = C
		client_ckey = C.ckey
		load_vore(C)

//
// Save/Load Vore Preferences
//
/datum/vore_preferences/proc/load_vore()
	if(!client || !client_ckey) return 0 //No client, how can we save?

	slot = client.prefs.default_slot

	path = client.prefs.path

	if(!path) return 0 //Path couldn't be set?
	if(!fexists(path)) //Never saved before
		save_vore() //Make the file first
		return 1

	var/savefile/S = new /savefile(path)
	if(!S) return 0 //Savefile object couldn't be created?

	S.cd = "/character[slot]"

	S["digestable"] >> digestable
	S["devourable"] >> devourable
	S["belly_prefs"] >> belly_prefs

	if(isnull(digestable))
		digestable = 1
	if(isnull(devourable))
		devourable = 1
	if(isnull(belly_prefs))
		belly_prefs = list()

	return 1

/datum/vore_preferences/proc/save_vore()
	if(!path)				return 0
	if(!slot)				return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/character[slot]"

	S["digestable"] << digestable
	S["devourable"] << devourable
	S["belly_prefs"] << belly_prefs

	return 1

//
//	Verb for saving vore preferences to save file
//
/mob/living/proc/save_vore_prefs()
	if(!(client || client.prefs_vr))
		return 0
	if(!copy_to_prefs_vr())
		return 0
	if(!client.prefs_vr.save_vore())
		return 0

	return 1

/mob/living/proc/apply_vore_prefs()
	if(!(client || client.prefs_vr))
		return 0
	if(!client.prefs_vr.load_vore())
		return 0
	if(!copy_from_prefs_vr())
		return 0

	return 1

/mob/living/proc/copy_to_prefs_vr()
	if(!client || !client.prefs_vr)
		src << "<span class='warning'>You attempted to save your vore prefs but somehow you're in this character without a client.prefs_vr variable. Tell a dev.</span>"
		return 0

	var/datum/vore_preferences/P = client.prefs_vr

	P.digestable = src.digestable
	P.devourable = src.devourable
	P.belly_prefs = src.vore_organs

	return 1

//
//	Proc for applying vore preferences, given bellies
//
/mob/living/proc/copy_from_prefs_vr()
	if(!client || !client.prefs_vr)
		src << "<span class='warning'>You attempted to apply your vore prefs but somehow you're in this character without a client.prefs_vr variable. Tell a dev.</span>"
		return 0

	var/datum/vore_preferences/P = client.prefs_vr

	src.digestable = P.digestable
	src.devourable = P.devourable
	src.vore_organs = list()

	for(var/I in P.belly_prefs)
		var/datum/belly/Bp = P.belly_prefs[I]
		src.vore_organs[Bp.name] = Bp.copy(src)

	return 1

//
//	Check if an object is capable of eating things, based on vore_organs
//
/proc/is_vore_predator(var/mob/living/O)
	if(istype(O,/mob/living))
		if(O.vore_organs.len > 0)
			return 1

	return 0

//
//	Belly searching for simplifying other procs
//
/proc/check_belly(atom/movable/A)
	if(ismob(A.loc))
		var/mob/living/M = A.loc
		for(var/I in M.vore_organs)
			var/datum/belly/B = M.vore_organs[I]
			if(A in B.internal_contents)
				return(B)

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
//	Verb for saving vore preferences to save file
/*
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

*/