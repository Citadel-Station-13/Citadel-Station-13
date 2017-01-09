//THIS FILE CONTAINS CONSTANTS, PROCS, DEFINES, AND OTHER THINGS//
////////////////////////////////////////////////////////////////////

var/const/SIZEPLAY_TINY=1
var/const/SIZEPLAY_MICRO=2
var/const/SIZEPLAY_NORMAL=3
var/const/SIZEPLAY_MACRO=4
var/const/SIZEPLAY_HUGE=5

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
// omited for quick error resolution while porting -Pooj
proc/get_racelist(var/mob/user)//This proc returns a list of species that 'user' has available to them. It searches the list of ckeys attached to the 'whitelist' var for a species and also checks if they're an admin.
	for(var/spath in subtypesof(/datum/species))
		var/datum/species/S = new spath()
		var/list/wlist = S.whitelist
		if(S.whitelisted && (wlist.Find(user.ckey) || wlist.Find(user.key) || user.client.holder))  //If your ckey is on the species whitelist or you're an admin:
			whitelisted_species_list[S.id] = S.type 											//Add the species to their available species list.
		else if(!S.whitelisted && S.roundstart)														//Normal roundstart species will be handled here.
			whitelisted_species_list[S.id] = S.type
	return whitelisted_species_list