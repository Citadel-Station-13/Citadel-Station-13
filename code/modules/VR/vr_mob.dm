/mob/proc/build_virtual_character(mob/M)
	mind_initialize()
	if(!M)
		return FALSE
	name = M.name
	real_name = M.real_name
	mind.name = M.real_name
	return TRUE

/mob/living/carbon/build_virtual_character(mob/M)
	. = ..()
	if(!.)
		return
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		C.dna?.transfer_identity(src)

/mob/living/carbon/human/build_virtual_character(mob/M, datum/outfit/outfit)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/H
	if(ishuman(M))
		H = M
	socks = H ? H.socks : random_socks()
	socks_color = H ? H.socks_color : random_color()
	undershirt = H ? H.undershirt : random_undershirt(M.gender)
	shirt_color = H ? H.shirt_color : random_color()
	underwear = H ? H.underwear : random_underwear(M.gender)
	undie_color = H ? H.undie_color : random_color()
	give_genitals(TRUE)
	if(outfit)
		var/datum/outfit/O = new outfit()
		O.equip(src)

/datum/action/quit_vr
	name = "Quit Virtual Reality"
	icon_icon = 'icons/mob/actions/actions_vr.dmi'
	button_icon_state = "logout"

/datum/action/quit_vr/Trigger() //this merely a trigger for /datum/component/virtual_reality
	. = ..()
	if(.) //The component was not there to block the trigger.
		Remove(owner)
