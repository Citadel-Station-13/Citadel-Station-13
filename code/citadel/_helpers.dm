//THIS FILE CONTAINS CONSTANTS, PROCS, DEFINES, AND OTHER THINGS//
////////////////////////////////////////////////////////////////////

/mob/proc/setClickCooldown(var/timeout)
	next_move = max(world.time + timeout, next_move)

/proc/get_matrix_largest()
	var/matrix/mtrx=new()
	return mtrx.Scale(2)
/proc/get_matrix_large()
	var/matrix/mtrx=new()
	return mtrx.Scale(1.5)
/proc/get_matrix_norm()
	var/matrix/mtrx=new()
	return mtrx
/proc/get_matrix_small()
	var/matrix/mtrx=new()
	return mtrx.Scale(0.8)
/proc/get_matrix_smallest()
	var/matrix/mtrx=new()
	return mtrx.Scale(0.65)

proc/get_racelist(var/mob/user)//This proc returns a list of species that 'user' has available to them. It searches the list of ckeys attached to the 'whitelist' var for a species and also checks if they're an admin.
	for(var/spath in subtypesof(/datum/species))
		var/datum/species/S = new spath()
		var/list/wlist = S.whitelist
		if(S.whitelisted && (wlist.Find(user.ckey) || wlist.Find(user.key) || user.client.holder))  //If your ckey is on the species whitelist or you're an admin:
			whitelisted_species_list[S.id] = S.type 											//Add the species to their available species list.
		else if(!S.whitelisted && S.roundstart)														//Normal roundstart species will be handled here.
			whitelisted_species_list[S.id] = S.type

	return whitelisted_species_list

	//Mammal Species
var/global/list/mam_body_markings_list = list()
var/global/list/mam_ears_list = list()
var/global/list/mam_tails_list = list()
var/global/list/mam_tails_animated_list = list()

	//Exotic Species
var/global/list/exotic_tails_list = list()
var/global/list/exotic_tails_animated_list = list()
var/global/list/exotic_ears_list = list()
var/global/list/exotic_head_list = list()
var/global/list/exotic_back_list = list()

	//Xenomorph Species
var/global/list/xeno_head_list = list() //I forgot the ' = list()' part for the longest time and couldn't figure out what was wrong. *facepalm
var/global/list/xeno_tail_list = list()
var/global/list/xeno_dorsal_list = list()


//mentor stuff

var/list/mentors = list()

/client/proc/reload_mentors()
		set name = "Reload Mentors"
		set category = "Admin"
		if(!src.holder)	return
		message_admins("[key_name_admin(usr)] manually reloaded mentors")

/mob/living/carbon/human/verb/set_flavor()
	set name = "Set Flavor Text"
	set desc = "Sets an extended description of your character's features."
	set category = "IC"

	flavor_text =  copytext(sanitize(input(usr, "Please enter your new flavor text.", "Flavor text", null)  as text), 1)
