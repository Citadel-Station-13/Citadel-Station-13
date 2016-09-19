
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

//
// Overrides/additions to stock defines go here, as well as hooks. Sort them by
// the object they are overriding. So all /mob/living together, etc.
//
/datum/configuration
	var/items_survive_digestion = 1		//For configuring if the important_items survive digestion

//
// The datum type bolted onto normal preferences datums for storing Virgo stuff
//
/client
	var/datum/vore_preferences/prefs_vr = null

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
	if(istype(A.loc,/mob/living))
		var/mob/living/M = A.loc
		for(var/I in M.vore_organs)
			var/datum/belly/B = M.vore_organs[I]
			if(A in B.internal_contents)
				return(B)

	return 0

//
// Save/Load Vore Preferences
//

/datum/vore_preferences/proc/load_path(ckey,filename="preferences_vr.sav")
	if(!ckey)
		return
	path = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename]"

/datum/vore_preferences/proc/load_vore()
	if(!path)
		return 0
	if(!fexists(path))
		return 0
	var/savefile/S = new /savefile(path)
	if(!S)
		return 0
	S.cd = "/"

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
	if(!path)
		return 0
	var/savefile/S = new /savefile(path)
	if(!S)
		return 0
	S.cd = "/"

	S["digestable"] << digestable
	S["devourable"] << devourable
	S["belly_prefs"] << belly_prefs

	return 1


//
//	Verb for saving vore preferences to save file
//
/mob/living/proc/save_vore_prefs()
	set name = "Save Vore Prefs"
	set category = "Vore"

	var/result = 0

	if(client.prefs_vr)
		result = client.prefs_vr.save_vore()
	else
		src << "<span class='warning'>You attempted to save your vore prefs but somehow you're in this character without a client.prefs_vr variable. Tell a dev.</span>"

	return result

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

	P.devourable = src.devourable
	P.digestable = src.digestable
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

	src.devourable = P.devourable
	src.digestable = P.digestable
	src.vore_organs = list()

	for(var/I in P.belly_prefs)
		var/datum/belly/Bp = P.belly_prefs[I]
		src.vore_organs[Bp.name] = Bp.copy(src)

	return 1