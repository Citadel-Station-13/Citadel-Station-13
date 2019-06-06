/obj/item/projectile/bullet/dart
	name = "dart"
	icon_state = "cbbolt"
	damage = 6
	var/piercing = FALSE

/obj/item/projectile/bullet/dart/Initialize()
	. = ..()
	create_reagents(50)
	reagents.set_reacting(FALSE)

/obj/item/projectile/bullet/dart/on_hit(atom/target, blocked = FALSE, skip = FALSE)
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		if(blocked != 100) // not completely blocked
			if(M.can_inject(null, FALSE, def_zone, piercing)) // Pass the hit zone to see if it can inject by whether it hit the head or the body.
				..()
				if(skip == TRUE)
					return
				reagents.reaction(M, INJECT)
				reagents.trans_to(M, reagents.total_volume)
				return TRUE
			else
				blocked = 100
				target.visible_message("<span class='danger'>\The [src] was deflected!</span>", \
									   "<span class='userdanger'>You were protected against \the [src]!</span>")

	..(target, blocked)
	reagents.set_reacting(TRUE)
	reagents.handle_reactions()
	return TRUE

/obj/item/projectile/bullet/dart/metalfoam/Initialize()
	. = ..()
	reagents.add_reagent("aluminium", 15)
	reagents.add_reagent("foaming_agent", 5)
	reagents.add_reagent("facid", 5)

/obj/item/projectile/bullet/dart/syringe
	name = "syringe"
	icon_state = "syringeproj"

//I am in a mess of my own making
/obj/item/projectile/bullet/dart/syringe/dart
	name = "Smartdart"
	icon_state = "syringeproj"
	damage = 0

/obj/item/projectile/bullet/dart/syringe/dart/on_hit(atom/target, blocked = FALSE)
	message_admins("Dart landed!")
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		if(blocked != 100) // not completely blocked
			if(M.can_inject(null, FALSE, def_zone, piercing)) // Pass the hit zone to see if it can inject by whether it hit the head or the body.
				..(target, blocked, TRUE)
				message_admins("Checking reagents")
				for(var/datum/reagent/R in reagents.reagent_list) //OD prevention time!
					message_admins("Reagent: [R]")
					if(istype(R, /datum/reagent/medicine)) //Is this a medicine?
						message_admins("Is a medicine")
						if(M.reagents.has_reagent(R.id))
							message_admins("reagent found! with new")
							var/datum/reagent/medicine/Rm = locate(R) in M
							if(R.overdose_threshold == 0) //Is there a possible OD?
								M.reagents.add_reagent(R.id, R.volume)
							else
								var/transVol = CLAMP(R.volume, 0, (R.overdose_threshold - Rm.volume) -1) //Doesn't work
								message_admins("DEBUG: R.vol [R.volume], R.OD [R.overdose_threshold], Rm.vol: [Rm.volume], trans: [transVol]")
								message_admins("Merge: Adding [transVol], OD: [R.overdose_threshold], curvol [Rm.volume]")
								M.reagents.add_reagent(R.id, transVol)
						else
							if(!R.overdose_threshold == 0)
								var/transVol = CLAMP(R.volume, 0, R.overdose_threshold-1)
								M.reagents.add_reagent(R.id, transVol)
							else
								M.reagents.add_reagent(R.id, R.volume)



				target.visible_message("<span class='notice'>\The [src] beeps!</span>")
				to_chat("<span class='notice'><i>You feel a tiny prick, and turn around to see a smartdart embedded in your butt.</i></span>")
				return TRUE
			else
				blocked = 100
				target.visible_message("<span class='danger'>\The [src] was deflected!</span>", \
									   "<span class='userdanger'>You see a [src] bounce off you, booping sadly!</span>")

	target.visible_message("<span class='danger'>\The [src] fails to land on target!</span>")
	return TRUE
