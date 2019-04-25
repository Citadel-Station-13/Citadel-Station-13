/datum/surgery/advanced/bioware/laser_eye_surgery
	name = "Laser eye surgery"
	desc = "A surgical procedure whitch will help correct poor sight and midigate the negive affects of damaged eyes. Does NOT heal the eyes if damaged."
	steps = list(/datum/surgery_step/incise,
				/datum/surgery_step/retract_skin,
				/datum/surgery_step/clamp_bleeders,
				/datum/surgery_step/incise,
				/datum/surgery_step/incise,
				/datum/surgery_step/laser_eye_surgery,
				/datum/surgery_step/close)
	possible_locs = list(BODY_ZONE_HEAD)
	bioware_target = BIOWARE_EYES

/datum/surgery_step/laser_eye_surgery
	name = "laser eye surgery"
	implements = list(/obj/item/laser_pointer = 100, /obj/item/flashlight/pen = 100, /obj/item/stock_parts/micro_laser = 50, /obj/item/stock_parts/micro_laser/high = 75, /obj/item/stock_parts/micro_laser/ultra = 90, /obj/item/stock_parts/micro_laser/quadultra = 100)
	time = 125

/datum/surgery_step/laser_eye_surgery/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] starts shining a light into [target]'s eyes.", "<span class='notice'>You start correcting [target]'s eyes.</span>")

/datum/surgery_step/laser_eye_surgery/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] stops shining a light into [target]'s eyes after correcting [target]'s vison!", "<span class='notice'>You corrected [target]'s vison with a laser!</span>")
	new /datum/bioware/laser_eye_surgery(target)
	return TRUE

/datum/bioware/laser_eye_surgery
	name = "Laser eye surgery"
	desc = "Corrective eye surgery making the user no longer need glasses. Dose NOT heal the eyes if damaged."
	mod_type = BIOWARE_EYES

/datum/bioware/laser_eye_surgery/on_gain()
	..()
	owner.clear_fullscreen("nearsighted")
	owner.clear_fullscreen("eye_damage")

/datum/bioware/laser_eye_surgery/on_lose()
	..()
	return