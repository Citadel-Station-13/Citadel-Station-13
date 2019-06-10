/mob/proc/build_virtual_character(mob/M)
	mind_initialize()
	if(!M)
		return FALSE
	name = M.name
	real_name = M.real_name
	return TRUE

/mob/living/carbon/build_virtual_character(mob/M)
	. = ..()
	if(!.)
		return
	if(!iscarbon(M))
		return FALSE
	var/mob/living/carbon/C = M
	C.dna?.transfer_identity(src)

/mob/living/carbon/human/build_virtual_character(mob/M, datum/outfit/outfit)
	. = ..()
	if(!.)
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		socks = H.socks
		undershirt = H.undershirt
		underwear = H.underwear
		give_genitals(TRUE)
	if(outfit)
		var/datum/outfit/O = new outfit()
		O.equip(src)
	name = M.name
	real_name = M.real_name

/datum/action/quit_vr
	name = "Quit Virtual Reality"
	icon_icon = 'icons/mob/actions/actions_vr.dmi'
	button_icon_state = "logout"

/datum/action/quit_vr/Trigger() //this merely a trigger for /datum/component/virtual_reality
	. = ..()
	if(!.)
		Remove(owner)
