//This file is for clock rites, mainly used by the Sigil of Rites in clock_sigils.dm
//The rites themselves are in this file to prevent bloating the other file too much, aswell as for easier access

//The base clockwork rite. This should never be visible
/datum/clockwork_rite
	var/name = "Some random clockwork rite that you should not be able to see" //The name of the rite
	var/list/required_ingredients = list() //What does this rite require?
	var/power_cost = 0 //How much power does this rite cost.. or does it even add power?
	var/requires_human = FALSE	//Does the rite require a ../carbon/human on the rune?
	var/must_be_servant = TRUE //If the above is true, does the human need to be a servant?
	var/target_can_be_invoker = TRUE //Does this rite work if the invoker is also the target?
	var/cast_time = 0 //How long does the rite take to cast?
	var/limit = -1 //How often can this rite be used per round? Set this to -1 for unlimited, 0 for disallowed, anything above 0 for a limit
	var/times_used = 0 //How often has the rite already been used this shift?
	var/rite_cast_sound = 'sound/items/bikehorn.ogg' //The sound played when successfully casting the rite. If it honks, the one adding the rite forgot to set one (or was just lazy).

/datum/clockwork_rite/proc/try_cast(var/obj/effect/clockwork/sigil/rite/R, var/mob/living/invoker) //Performs a ton of checks to see if the invoker can cast the rite
	if(!istype(R))
		return FALSE
	if(!R || !R.loc)
		return FALSE
	var/turf/T = R.loc
	if(!T) //Uh oh something is fucky
		return FALSE

	if(limit != -1 && times_used >= limit) //Is the limit on casts exceeded?
		to_chat(invoker, "<span_class='brass'>There are no more uses left for this rite!</span>")
		return FALSE

	var/mob/living/carbon/human/H //This is only used if requires_human is TRUE
	if(requires_human) //In case this requires a target
		for(var/mob/living/carbon/human/possible_H in T)
			if((!must_be_servant || is_servant_of_ratvar(possible_H)) && (target_can_be_invoker || invoker != possible_H))
				H = possible_H
				break
		if(!H)
			to_chat(invoker, "<span class='brass'>There is no target for the rite on the sigil!</span>")
			return FALSE

	if(required_ingredients.len) //In case this requires materials
		var/is_missing_materials = FALSE
		for(var/obj/item/I in required_ingredients)
			var/obj/item/Material = locate(I) in T
			if(!Material)
				is_missing_materials = TRUE
				break
		if(!is_missing_materials)
			var/still_required_string = ""
			for(var/i = 1 to required_ingredients.len)
				var/obj/O = required_ingredients[i]
				if(i != 1)
					still_required_string += ", "
				still_required_string += initial(O.name)
			to_chat(invoker, "<span class='brass'>There are still materials missing for this rite. You require [still_required_string].</span>")
			return FALSE

	if(power_cost) //If this costs power
		if(!get_clockwork_power(power_cost))
			to_chat(invoker, "<span class='brass'>There is not enough power for this rite!</span>")
			return FALSE
	R.performing_rite = TRUE
	if(!do_after(invoker, cast_time, target = R))
		to_chat(invoker, "span class='warning'>Your rite is disrupted.</span>")
		R.performing_rite = FALSE
		return FALSE
	. = cast(invoker, T, H)
	if(!.)
		to_chat(invoker, "<span class='warning'> You fail casting [name]</span>")
		post_cast(FALSE)
	else
		to_chat(invoker, "<span class='warning'>You successfully cast [name]</span>")
		post_cast(TRUE)
	R.performing_rite = FALSE
	return

/datum/clockwork_rite/proc/cast(/mob/living/invoker, var/turf/T, var/mob/living/carbon/human/target) //Casts the rite and uses up ingredients. Doublechecks some things to prevent bypassing some restrictions via funky timing or badminnery.
	if(requires_human && !target)
		return FALSE
	if(power_cost && !get_clockwork_power(power_cost))
		return FALSE
	adjust_clockwork_power(-power_cost)
	if(limit != -1 && times_used >= limit)
		return FALSE
	if(required_ingredients.len)
		var/is_missing_materials = FALSE
		for(var/obj/item/I in required_ingredients)
			var/obj/item/Material = locate(I) in T
			if(!Material)
				is_missing_materials = TRUE
				break
			else
				qdel(Material)
		if(!is_missing_materials)
			return FALSE
	playsound(T, rite_cast_sound, 50, 2)
	return TRUE

/datum/clockwork_rite/proc/post_cast(var/cast_succeeded)
	if(cast_succeeded)
		times_used++
	return TRUE
