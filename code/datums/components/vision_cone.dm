#define FOV_90_DEGREES	90
#define FOV_180_DEGREES	180
#define FOV_270_DEGREES	270


GLOBAL_LIST_INIT(available_fov_planes, generate_fov_planes_list())

/proc/generate_fov_planes_list()
	. = list()
	for(var/a in FIELD_OF_VISION_PLANE_START to FIELD_OF_VISION_PLANE_END)
		. += a

/datum/component/vision_cone
	///a 480x480 screen object that more or less indicates which portions of the screen your vision can't reach.
	var/atom/movable/fov_holder/fov
	var/current_fov_size = list(15, 15)
	var/angle = 0
	var/rot_scale = 1 //used in shadow cone rotation.
	var/shadow_angle = 90

/datum/component/vision_cone/Initialize(fov_type = FOV_90_DEGREES, _angle = 0)
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE
	var/mob/M = parent
	angle = _angle
	shadow_angle = fov_type
	if(M.client)
		generate_fov_holder(M, _angle)
	RegisterSignal(M, COMSIG_MOB_CLIENT_LOGIN, .proc/on_mob_login)
	RegisterSignal(M, COMSIG_MOB_CLIENT_LOGOUT, .proc/on_mob_logout)
	RegisterSignal(M, COMSIG_MOB_CLIENT_CHANGE_VIEW, .proc/on_change_view)

/datum/component/vision_cone/Destroy()
	if(fov)
		delete_fov_holder(parent)
	return ..()

/datum/component/vision_cone/proc/generate_fov_holder(mob/M, _angle = 0)
	var/plane_to_use = popleft(GLOB.available_fov_planes)
	for(var/A in GLOB.mob_huds)
		var/datum/hud/H = A
		var/obj/screen/plane_master/field_of_vision/F = new /obj/screen/plane_master/field_of_vision(null, plane_to_use)
		H.plane_masters["[plane_to_use]"] = F
		if(H.mymob.client)
			H.mymob.client.screen += F
	var/obj/screen/plane_master/field_of_vision/F = M.hud_used.plane_masters["[plane_to_use]"]
	F.render_target = "[FOV_RENDER_TARGET][F.plane]"
	F.alpha = 255
	fov = new(get_turf(M))
	fov.icon_state = "[shadow_angle]"
	fov.dir = M.dir
	fov.plane = plane_to_use
	if(_angle)
		rotate_shadow_cone(_angle, FALSE)
	if(M.client.view != "[current_fov_size[1]]x[current_fov_size[2]]")
		resize_fov(current_fov_size, M.client.view)
	RegisterSignal(M, COMSIG_ATOM_DIR_CHANGE, .proc/on_dir_change)
	RegisterSignal(M, COMSIG_MOVABLE_MOVED, .proc/on_mob_moved)
	RegisterSignal(SSdcs, COMSIG_GLOB_VAR_EDIT, .proc/on_new_hud)

/datum/component/vision_cone/proc/delete_fov_holder(mob/M)
	UnregisterSignal(M, list(COMSIG_ATOM_DIR_CHANGE, COMSIG_MOVABLE_MOVED))
	UnregisterSignal(SSdcs, COMSIG_GLOB_VAR_EDIT)
	var/plane_to_unuse = fov.plane
	QDEL_NULL(fov)
	for(var/A in GLOB.mob_huds)
		var/datum/hud/H = A
		var/obj/screen/plane_master/field_of_vision/F = H.plane_masters["[plane_to_unuse]"]
		H.plane_masters -= ["plane_to_unuse"]
		if(H.mymob.client)
			H.mymob.client.screen -= F
		qdel(F)
	GLOB.available_fov_planes += plane_to_unuse

/datum/component/vision_cone/proc/on_new_hud(datum/source, datum/hud/new_hud)
	var/obj/screen/plane_master/field_of_vision/F = new /obj/screen/plane_master/field_of_vision(null, fov.plane)
	new_hud.plane_masters["[fov.plane]"] = F

/datum/component/vision_cone/proc/on_mob_login(mob/source, client/client)
	generate_fov_holder(source)

/datum/component/vision_cone/proc/on_mob_logout(mob/source, client/client)
	delete_fov_holder(source)

/datum/component/vision_cone/proc/on_mob_moved(mob/source, atom/oldloc, dir, forced)
	fov.forceMove(get_turf(source), harderforce = TRUE)

/datum/component/vision_cone/proc/on_dir_change(mob/source, old_dir, new_dir)
	fov.dir = new_dir

/datum/component/vision_cone/proc/rotate_shadow_cone(new_angle)
	var/simple_degrees = SIMPLIFY_DEGREES(new_angle - angle)
	var/to_scale = cos(simple_degrees) * sin(simple_degrees)
	if(to_scale)
		var/old_rot_scale = rot_scale
		rot_scale = 1 + to_scale
		fov.transform.Scale(rot_scale/old_rot_scale)
	fov.transform.Turn(fov.transform, simple_degrees)

/datum/component/vision_cone/proc/on_change_view(mob/source, client, list/old_view, list/view)
	resize_fov(old_view, view)

/datum/component/vision_cone/proc/resize_fov(list/old_view, list/view)
	current_fov_size = view
	var/old_size = max(old_view[1], old_view[2])
	var/new_size = max(view[1], view[2])
	if(old_size == new_size) //longest edges are still of the same length.
		stack_trace("aaaaaaa")
		return
	fov.transform.Scale((new_size/old_size)**2)

/atom/movable/fov_holder //required for mouse opacity.
	name = "field of vision holder"
	icon = 'icons/misc/field_of_vision.dmi'
	icon_state = "90"
	color = "#AAAAAA"
	pixel_x = -224
	pixel_y = -224
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE

/atom/movable/fov_holder/ex_act(severity)
	return FALSE

/atom/movable/fov_holder/singularity_act()
	return

/atom/movable/fov_holder/singularity_pull()
	return

/atom/movable/fov_holder/blob_act()
	return

/atom/movable/fov_holder/onTransitZ()
	return

//Prevents people from moving these after creation, because they shouldn't be.
/atom/movable/fov_holder/forceMove(atom/destination, no_tp=FALSE, harderforce = FALSE)
	if(harderforce)
		return ..()

/mob
	var/datum/component/vision_cone/FoV
	var/del_fov = FALSE


/mob/verb/fov_test()
	set name = "FoV Test Toggle"
	set category = "IC"

	if(!FoV)
		FoV = AddComponent(/datum/component/vision_cone)
	else if(!del_fov)
		FoV.fov.filters = null
		FoV.fov.render_target = null
		del_fov = TRUE
		spawn(50)
			QDEL_NULL(FoV)
			del_fov = FALSE

/mob/verb/fov_icon()
	set name = "FoV Test Icon"
	set category = "IC"

	if(!FoV)
		return
	switch(FoV.fov.icon_state)
		if("90")
			FoV.fov.icon_state = "[FOV_180_DEGREES]"
		if("180")
			FoV.fov.icon_state = "[FOV_270_DEGREES]"
		if("270")
			FoV.fov.icon_state = "[FOV_90_DEGREES]b"
		if("90b")
			FoV.fov.icon_state = "[FOV_180_DEGREES]b"
		if("180b")
			FoV.fov.icon_state = "[FOV_270_DEGREES]b"
		if("270b")
			FoV.fov.icon_state = "[FOV_90_DEGREES]"
