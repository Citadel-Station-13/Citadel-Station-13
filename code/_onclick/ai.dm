/*
	AI ClickOn()

	Note currently ai restrained() returns 0 in all cases,
	therefore restrained code has been removed

	The AI can double click to move the camera (this was already true but is cleaner),
	or double click a mob to track them.

	Note that AI have no need for the adjacency proc, and so this proc is a lot cleaner.
*/
/mob/living/silicon/ai/DblClickOn(var/atom/A, params)
	if(control_disabled || incapacitated())
		return

	if(ismob(A))
		ai_actual_track(A)
	else
		A.move_camera_by_click()

/mob/living/silicon/ai/ClickOn(var/atom/A, params)
	if(!can_interact_with(A))
		return

	if(multicam_on)
		var/turf/T = get_turf(A)
		if(T)
			for(var/atom/movable/screen/movable/pic_in_pic/ai/P in T.vis_locs)
				if(P.ai == src)
					P.Click(params)
					break

	if(check_click_intercept(params,A))
		return

	if(control_disabled || incapacitated())
		return

	var/turf/pixel_turf = get_turf_pixel(A)
	if(isnull(pixel_turf))
		return
	if(!can_see(A))
		if(isturf(A)) //On unmodified clients clicking the static overlay clicks the turf underneath
			return //So there's no point messaging admins
		message_admins("[ADMIN_LOOKUPFLW(src)] might be running a modified client! (failed can_see on AI click of [A] (Turf Loc: [ADMIN_VERBOSEJMP(pixel_turf)]))")
		var/message = "[key_name(src)] might be running a modified client! (failed can_see on AI click of [A] (Turf Loc: [AREACOORD(pixel_turf)]))"
		log_admin(message)
		to_chat(src, "<span class='warning'>You're experiencing a bug. Reconnect immediately to fix it. Admins have been notified.</span>")
		if(REALTIMEOFDAY >= chnotify + 9000)
			chnotify = REALTIMEOFDAY
			send2tgs_adminless_only("NOCHEAT", message)
		return

	var/list/modifiers = params2list(params)
	if(modifiers["shift"] && modifiers["ctrl"])
		CtrlShiftClickOn(A)
		return
	if(modifiers["shift"])
		ShiftClickOn(A)
		return
	if(modifiers["alt"]) // alt and alt-gr (rightalt)
		AltClickOn(A)
		return
	if(modifiers["ctrl"])
		CtrlClickOn(A)
		return

	if(!CheckActionCooldown(immediate = TRUE))
		return

	if(aicamera.in_camera_mode)
		aicamera.camera_mode_off()
		INVOKE_ASYNC(aicamera, TYPE_PROC_REF(/obj/item/camera, captureimage), pixel_turf, usr)
		return
	if(waypoint_mode)
		waypoint_mode = FALSE
		INVOKE_ASYNC(src, PROC_REF(set_waypoint), A)
		return

	A.attack_ai(src)

/*
	AI has no need for the UnarmedAttack() and RangedAttack() procs,
	because the AI code is not generic;	attack_ai() is used instead.
	The below is only really for safety, or you can alter the way
	it functions and re-insert it above.
*/
/mob/living/silicon/ai/UnarmedAttack(atom/A, proximity, intent = a_intent, flags = NONE)
	A.attack_ai(src)

/mob/living/silicon/ai/RangedAttack(atom/A)
	A.attack_ai(src)

/atom/proc/attack_ai(mob/user)
	return

/*
	Since the AI handles shift, ctrl, and alt-click differently
	than anything else in the game, atoms have separate procs
	for AI shift, ctrl, and alt clicking.
*/

/mob/living/silicon/ai/CtrlShiftClickOn(var/atom/A)
	A.AICtrlShiftClick(src)
/mob/living/silicon/ai/ShiftClickOn(var/atom/A)
	A.AIShiftClick(src)
/mob/living/silicon/ai/CtrlClickOn(var/atom/A)
	A.AICtrlClick(src)
/mob/living/silicon/ai/AltClickOn(var/atom/A)
	A.AIAltClick(src)


/*
	The following criminally helpful code is just the previous code cleaned up;
	I have no idea why it was in atoms.dm instead of respective files.
*/
/* Questions: Instead of an Emag check on every function, can we not add to airlocks onclick if emag return? */

/* Atom Procs */
/atom/proc/AICtrlClick()
	return

/atom/proc/AIAltClick(mob/living/silicon/ai/user)
	return AltClick(user)

/atom/proc/AIShiftClick()
	return
/atom/proc/AICtrlShiftClick()
	return

/* Airlocks */
/obj/machinery/door/airlock/AICtrlClick() // Bolts doors
	if(obj_flags & EMAGGED)
		return

	toggle_bolt(usr)

/obj/machinery/door/airlock/AIAltClick() // Eletrifies doors.
	if(obj_flags & EMAGGED)
		return

	if(!secondsElectrified)
		shock_perm(usr)
	else
		shock_restore(usr)
	return TRUE

/obj/machinery/door/airlock/AIShiftClick()  // Opens and closes doors!
	if(obj_flags & EMAGGED)
		return

	user_toggle_open(usr)

/obj/machinery/door/airlock/AICtrlShiftClick()  // Sets/Unsets Emergency Access Override
	if(obj_flags & EMAGGED)
		return

	toggle_emergency(usr)

/* APC */
/obj/machinery/power/apc/AICtrlClick() // turns off/on APCs.
	if(can_use(usr, 1))
		toggle_breaker()
		add_fingerprint(usr)

/* AI Turrets */
/obj/machinery/turretid/AIAltClick() //toggles lethal on turrets
	if(ailock)
		return
	toggle_lethal()
	add_fingerprint(usr)

/obj/machinery/turretid/AICtrlClick() //turns off/on Turrets
	if(ailock)
		return
	toggle_on()
	add_fingerprint(usr)
	return TRUE

/* Holopads */
/obj/machinery/holopad/AIAltClick(mob/living/silicon/ai/user)
	hangup_all_calls()
	return TRUE

//
// Override TurfAdjacent for AltClicking
//

/mob/living/silicon/ai/TurfAdjacent(var/turf/T)
	return (GLOB.cameranet && GLOB.cameranet.checkTurfVis(T))
