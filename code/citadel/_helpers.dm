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
	return mtrx.Scale(0.7)
/proc/get_matrix_smallest()
	var/matrix/mtrx=new()
	return mtrx.Scale(0.5)

proc/get_racelist(var/mob/user)
	for(var/spath in subtypesof(/datum/species))
		var/datum/species/S = new spath()
		var/list/wlist = S.whitelist
			whitelisted_species_list[S.id] = S.type
	return whitelisted_species_list
