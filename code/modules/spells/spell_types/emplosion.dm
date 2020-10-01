/obj/effect/proc_holder/spell/targeted/emplosion
	name = "Emplosion"
	desc = "This spell emplodes an area."
	charge_max	= 250
	cooldown_min = 50
	var/emp_range = 4 //same as a 50/50 reaction of uranium and iron

	action_icon_state = "emp"
	sound = 'sound/weapons/zapbang.ogg'

/obj/effect/proc_holder/spell/targeted/emplosion/cast(list/targets,mob/user = usr)
	playsound(get_turf(user), sound, 50,1)
	for(var/mob/living/target in targets)
		if(target.anti_magic_check())
			continue
		empulse_using_range(target.loc, emp_range)

	return
