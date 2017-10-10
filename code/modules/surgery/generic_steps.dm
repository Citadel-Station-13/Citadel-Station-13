//For fucks sakes stick generic steps in here and reference from it. Only Surgery Specific steps should go in the other surgery files.


//make incision
/datum/surgery_step/incise
	name = "make incision"
	implements = list(
	/obj/item/scalpel = 100,
	/obj/item/melee/transforming/energy/sword = 75,
	/obj/item/kitchen/knife = 65,
	/obj/item/shard = 45,
	/obj/item = 30 // 30% success with any sharp item.
	)
	time = 16

/datum/surgery_step/incise/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] begins to make an incision in [target]'s [parse_zone(target_zone)].",
		"<span class='notice'>You begin to make an incision in [target]'s [parse_zone(target_zone)]...</span>")

/datum/surgery_step/incise/tool_check(mob/user, obj/item/tool)
	if(implement_type == /obj/item && !tool.is_sharp())
		return FALSE

	return TRUE

//clamp bleeders
/datum/surgery_step/clamp_bleeders
	name = "clamp bleeders"
	implements = list(
	/obj/item/hemostat = 100,
	/obj/item/wirecutters = 60,
	/obj/item/stack/packageWrap = 35,
	/obj/item/stack/cable_coil = 15
	)
	time = 24

/datum/surgery_step/clamp_bleeders/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] begins to clamp bleeders in [target]'s [parse_zone(target_zone)].",
		"<span class='notice'>You begin to clamp bleeders in [target]'s [parse_zone(target_zone)]...</span>")

/datum/surgery_step/clamp_bleeders/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(locate(/datum/surgery_step/saw) in surgery.steps)
		target.heal_bodypart_damage(20,0)
	return ..()


//retract skin
/datum/surgery_step/retract_skin
	name = "retract skin"
	implements = list(
	/obj/item/retractor = 100,
	/obj/item/screwdriver = 45,
	/obj/item/wirecutters = 35
	)
	time = 24

/datum/surgery_step/retract_skin/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] begins to retract the skin in [target]'s [parse_zone(target_zone)].",
		"<span class='notice'>You begin to retract the skin in [target]'s [parse_zone(target_zone)]...</span>")



//close incision
/datum/surgery_step/close
	name = "mend incision"
	implements = list(
	/obj/item/cautery = 100,
	/obj/item/gun/energy/laser = 90,
	/obj/item/weldingtool = 70,
	/obj/item/lighter = 45,
	/obj/item/match = 20
	)
	time = 24

/datum/surgery_step/close/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] begins to mend the incision in [target]'s [parse_zone(target_zone)].",
		"<span class='notice'>You begin to mend the incision in [target]'s [parse_zone(target_zone)]...</span>")


/datum/surgery_step/close/tool_check(mob/user, obj/item/tool)
	if(istype(tool, /obj/item/cautery))
		return TRUE

	if(istype(tool, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = tool
		if(WT.isOn())
			return TRUE

	else if(istype(tool, /obj/item/lighter))
		var/obj/item/lighter/L = tool
		if(L.lit)
			return TRUE

	else if(istype(tool, /obj/item/match))
		var/obj/item/match/M = tool
		if(M.lit)
			return TRUE

	return FALSE

/datum/surgery_step/close/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(locate(/datum/surgery_step/saw) in surgery.steps)
		target.heal_bodypart_damage(45,0)
	return ..()



//saw bone
/datum/surgery_step/saw
	name = "saw bone"
	implements = list(
	/obj/item/circular_saw = 100,
	/obj/item/melee/transforming/energy/sword/cyborg/saw = 100,
	/obj/item/melee/arm_blade = 75,
	/obj/item/mounted_chainsaw = 65,
	/obj/item/twohanded/required/chainsaw = 50,
	/obj/item/twohanded/fireaxe = 50,
	/obj/item/hatchet = 35,
	/obj/item/kitchen/knife/butcher = 25
	)
	time = 54

/datum/surgery_step/saw/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] begins to saw through the bone in [target]'s [parse_zone(target_zone)].",
		"<span class='notice'>You begin to saw through the bone in [target]'s [parse_zone(target_zone)]...</span>")

/datum/surgery_step/saw/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	target.apply_damage(50, BRUTE, "[target_zone]")

	user.visible_message("[user] saws [target]'s [parse_zone(target_zone)] open!", "<span class='notice'>You saw [target]'s [parse_zone(target_zone)] open.</span>")
	return TRUE

//drill bone
/datum/surgery_step/drill
	name = "drill bone"
	implements = list(
	/obj/item/surgicaldrill = 100,
	/obj/item/pickaxe/drill = 60,
	/obj/item/mecha_parts/mecha_equipment/drill = 60,
	/obj/item/screwdriver = 20
	)
	time = 30

/datum/surgery_step/drill/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] begins to drill into the bone in [target]'s [parse_zone(target_zone)].",
		"<span class='notice'>You begin to drill into the bone in [target]'s [parse_zone(target_zone)]...</span>")

/datum/surgery_step/drill/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] drills into [target]'s [parse_zone(target_zone)]!",
		"<span class='notice'>You drill into [target]'s [parse_zone(target_zone)].</span>")
	return 1

//set bone
/datum/surgery_step/set_bone
	name = "set bone"

	time = 64
	implements = list(
	/obj/item/bonesetter = 100,
	/obj/item/wrench = 35
	)

/datum/surgery_step/set_bone/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(target_zone == "skull")
		user.visible_message("[user] begins to set [target]'s skull with [tool]...",
		"<span class='notice'>You begin to set [target]'s skull with [tool]...</span>")
	else
		user.visible_message("[user] begins to set the bones in [target]'s [target_zone] with [tool]...",
		"<span class='notice'>You begin setting the bones in [target]'s [target_zone] with [tool]...</span>")

/datum/surgery_step/set_bone/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] successfully sets the bones in [target]'s [target_zone]!",
	"<span class='notice'>You successfully set the bones in [target]'s [target_zone].</span>")

//prep bone
/datum/surgery_step/prep_bone
	name = "Prep bone with Gel."

	time = 64
	implements = list(
	/obj/item/bonegel = 100,
	/obj/item/paper = 35 //Paper until I port tape. Then tape will replace paper.
	)

/datum/surgery_step/set_bone/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(target_zone == "skull")
		user.visible_message("[user] begins to line [target]'s shattered skull with [tool]...",
		"<span class='notice'>You begin to line [target]'s shattered skull with [tool]...</span>")
	else
		user.visible_message("[user] begins to line the bones in [target]'s [target_zone] with [tool]...",
		"<span class='notice'>You begin lining the bones in [target]'s [target_zone] with [tool]...</span>")

/datum/surgery_step/set_bone/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] successfully lines the bones in [target]'s [target_zone]!",
	"<span class='notice'>You successfully line the bones in [target]'s [target_zone].</span>")

//mend bone
/datum/surgery_step/mend_bone
	name = "Mend bone with gel."

	time = 64
	implements = list(
	/obj/item/bonegel = 100,
	/obj/item/stack/rods = 35
	)

/datum/surgery_step/set_bone/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(target_zone == "skull")
		user.visible_message("[user] begins to reinforce [target]'s cracked skull with [tool]...",
		"<span class='notice'>You begin to reinforce [target]'s cracked skull with [tool]...</span>")
	else
		user.visible_message("[user] begins to reinforce the bones in [target]'s [target_zone] with [tool]...",
		"<span class='notice'>You begin reinforcing the bones in [target]'s [target_zone] with [tool]...</span>")

/datum/surgery_step/set_bone/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] successfully reinforces the bones in [target]'s [target_zone]!",
	"<span class='notice'>You successfully reinforce the bones in [target]'s [target_zone].</span>")
	surgery.operated_bodypart.fix_bone()
	return TRUE

//Atypical A: material saw
/datum/surgery_step/saw_material
	name = "Saw Material"
	implements = list(
	/obj/item/circular_saw = 100,
	/obj/item/melee/transforming/energy/sword/cyborg/saw = 100,
	/obj/item/melee/arm_blade = 75,
	/obj/item/mounted_chainsaw = 65,
	/obj/item/twohanded/required/chainsaw = 50,
	/obj/item/twohanded/fireaxe = 50,
	/obj/item/hatchet = 35,
	/obj/item/kitchen/knife/butcher = 25
	)
	time = 64

/datum/surgery_step/saw_material/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] begins to saw through the material in [target]'s [parse_zone(target_zone)].",
		"<span class='notice'>You begin sawing through the material [target]'s [parse_zone(target_zone)]...</span>")

/datum/surgery_step/saw_material/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] pull apart the material in [target]'s [target_zone]!",
	"<span class='notice'>You successfully pull apart the material in [target]'s [target_zone].</span>")

//Atypical A: material retract
/datum/surgery_step/retract_material
	name = "Retract Material"
	implements = list(
	/obj/item/retractor = 100,
	/obj/item/screwdriver = 45,
	/obj/item/wirecutters = 35
	)
	time = 54

/datum/surgery_step/retract_material/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] begins to pull apart the material in [target]'s [parse_zone(target_zone)].",
		"<span class='notice'>You begin to pull apart the material in [target]'s [parse_zone(target_zone)]...</span>")

/datum/surgery_step/retract_material/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] pull apart the material in [target]'s [target_zone]!",
	"<span class='notice'>You successfully pull apart the material in [target]'s [target_zone].</span>")


//Atypical A: Prep Material For Closing.
/datum/surgery_step/prep_material
	name = "Line material with gel."
	time = 64
	implements = list(
	/obj/item/bonegel = 100,
	/obj/item/paper = 35 //Paper until I port tape. Then tape will replace paper.
	)

/datum/surgery_step/prep_material/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(target_zone == "skull")
		user.visible_message("[user] begins to line [target]'s evicerated skull with [tool]...",
		"<span class='notice'>You begin to line [target]'s evicerated skull with [tool]...</span>")
	else
		user.visible_message("[user] begins to line the chipped material in [target]'s [target_zone] with [tool]...",
		"<span class='notice'>You begin lining the chipped material in [target]'s [target_zone] with [tool]...</span>")

/datum/surgery_step/prep_material/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] successfully lines the material in [target]'s [target_zone]!",
	"<span class='notice'>You successfully line the material in [target]'s [target_zone].</span>")

//Atypical A: Set Material For Closing.
/datum/surgery_step/set_material
	name = "set material"

	time = 64
	implements = list(
	/obj/item/bonesetter = 100,
	/obj/item/wrench = 35
	)

/datum/surgery_step/set_material/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(target_zone == "skull")
		user.visible_message("[user] begins to set the material in [target]'s skull with [tool]...",
		"<span class='notice'>You begin to set the material in [target]'s skull with [tool]...</span>")
	else
		user.visible_message("[user] begins to set the material in [target]'s [target_zone] with [tool]...",
		"<span class='notice'>You begin setting the material in [target]'s [target_zone] with [tool]...</span>")

/datum/surgery_step/set_material/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] successfully sets the material in [target]'s [target_zone]!",
	"<span class='notice'>You successfully set the material in [target]'s [target_zone].</span>")

//Atypical A: Reinforce Material For Closing.
/datum/surgery_step/reinforce_material
	name = "Reinforce material with gel."
	time = 64
	implements = list(
	/obj/item/bonegel = 100,
	/obj/item/stack/rods = 35
	)

/datum/surgery_step/reinforce_material/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(target_zone == "skull")
		user.visible_message("[user] begins to reinforce [target]'s skull with [tool]...",
		"<span class='notice'>You begin to reinforce [target]'s skull with [tool]...</span>")
	else
		user.visible_message("[user] begins to reinforce the material in [target]'s [target_zone] with [tool]...",
		"<span class='notice'>You begin reinforcing the material in [target]'s [target_zone] with [tool]...</span>")

/datum/surgery_step/reinforce_material/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] successfully reinforces the material in [target]'s [target_zone]!",
	"<span class='notice'>You successfully reinforce the material in [target]'s [target_zone].</span>")
