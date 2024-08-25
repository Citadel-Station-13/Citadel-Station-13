/obj/machinery/computer/camera_advanced/abductor
	name = "Human Observation Console"
	var/team_number = 0
	networks = list("ss13", "abductor")
	var/datum/action/innate/teleport_in/tele_in_action = /datum/action/innate/teleport_in
	var/datum/action/innate/teleport_out/tele_out_action = /datum/action/innate/teleport_out
	var/datum/action/innate/teleport_self/tele_self_action = /datum/action/innate/teleport_self
	var/datum/action/innate/vest_mode_swap/vest_mode_action = /datum/action/innate/vest_mode_swap
	var/datum/action/innate/vest_disguise_swap/vest_disguise_action = /datum/action/innate/vest_disguise_swap
	var/datum/action/innate/set_droppoint/set_droppoint_action = /datum/action/innate/set_droppoint
	var/obj/machinery/abductor/console/console
	lock_override = TRUE

	icon = 'icons/obj/abductor.dmi'
	icon_state = "camera"
	icon_keyboard = null
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

/obj/machinery/computer/camera_advanced/abductor/CreateEye()
	..()
	eyeobj.visible_icon = TRUE
	eyeobj.icon = 'icons/mob/cameramob.dmi'
	eyeobj.icon_state = "generic_camera"

/obj/machinery/computer/camera_advanced/abductor/Initialize(mapload)
	. = ..()
	
	if(tele_in_action)
		actions += new tele_in_action(src)
	if(tele_out_action)
		actions += new tele_out_action(src)
	if(tele_self_action)
		actions += new tele_self_action(src)
	if(vest_mode_action)
		actions += new vest_mode_action(src)
	if(vest_disguise_action)
		actions += new vest_disguise_action(src)
	if(set_droppoint_action)
		actions += new set_droppoint_action(src)

/obj/machinery/computer/camera_advanced/abductor/proc/IsScientist(mob/living/carbon/human/H)
	return HAS_TRAIT(H, TRAIT_ABDUCTOR_SCIENTIST_TRAINING)

/datum/action/innate/teleport_in
	name = "Send To"
	icon_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	button_icon_state = "beam_down"

/datum/action/innate/teleport_in/Activate()
	if(QDELETED(owner) || !iscarbon(owner))
		return
	var/mob/camera/aiEye/remote/remote_eye = owner.remote_control
	var/obj/machinery/abductor/pad/P = target

	if(GLOB.cameranet.checkTurfVis(remote_eye.loc))
		P.PadToLoc(remote_eye.loc)

/datum/action/innate/teleport_out
	name = "Retrieve"
	icon_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	button_icon_state = "beam_up"

/datum/action/innate/teleport_out/Activate()
	if(QDELETED(owner) || !iscarbon(owner))
		return
	var/obj/machinery/abductor/console/console = target

	console.TeleporterRetrieve()

/datum/action/innate/teleport_self
	name = "Send Self"
	icon_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	button_icon_state = "beam_down"

/datum/action/innate/teleport_self/Activate()
	if(QDELETED(owner) || !iscarbon(owner))
		return
	var/mob/camera/aiEye/remote/remote_eye = owner.remote_control
	var/obj/machinery/abductor/pad/P = target

	if(GLOB.cameranet.checkTurfVis(remote_eye.loc))
		P.MobToLoc(remote_eye.loc, owner)

/datum/action/innate/vest_mode_swap
	name = "Switch Vest Mode"
	icon_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	button_icon_state = "vest_mode"

/datum/action/innate/vest_mode_swap/Activate()
	if(QDELETED(owner) || !iscarbon(owner))
		return
	var/obj/machinery/abductor/console/console = target
	console.FlipVest()


/datum/action/innate/vest_disguise_swap
	name = "Switch Vest Disguise"
	icon_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	button_icon_state = "vest_disguise"

/datum/action/innate/vest_disguise_swap/Activate()
	if(QDELETED(owner) || !iscarbon(owner))
		return
	var/obj/machinery/abductor/console/console = target
	console.SelectDisguise(remote=1)

/datum/action/innate/set_droppoint
	name = "Set Experiment Release Point"
	icon_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	button_icon_state = "set_drop"

/datum/action/innate/set_droppoint/Activate()
	if(QDELETED(owner) || !iscarbon(owner))
		return

	var/mob/camera/aiEye/remote/remote_eye = owner.remote_control

	var/obj/machinery/abductor/console/console = target
	console.SetDroppoint(remote_eye.loc,owner)
