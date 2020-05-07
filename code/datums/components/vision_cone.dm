#define CENTERED_RENDER_SOURCE(img, atom, FoV) \
	atom.render_target = atom.render_target || ref(atom);\
	img.render_source = atom.render_target;\
	var/_cached_sizes = FoV.width_n_height_offsets[atom.icon];\
	if(atom.icon){\
		if(!_cached_sizes){\
			var/icon/_I = icon(atom.icon);\
			var/list/L = list();\
			L += (_I.Width() - world.icon_size)/2;\
			L += (_I.Height() - world.icon_size)/2;\
			_cached_sizes = FoV.width_n_height_offsets[atom.icon] = L\
		}\
		img.pixel_x = _cached_sizes[1];\
		img.pixel_y = _cached_sizes[2]\
	}

#define REGISTER_NESTED_LOCS(source, list, comsig, proc) \
	for(var/k in get_nested_locs(source)){\
		var/atom/_A = k;\
		RegisterSignal(_A, comsig, proc);\
		list += _A\
	}

#define UNREGISTER_NESTED_LOCS(list, comsig, index) \
	for(var/k in index to length(list)){\
		var/atom/_A = list[k];\
		UnregisterSignal(_A, comsig);\
		list -= _A\
	}

/datum/component/vision_cone
	can_transfer = TRUE
	var/atom/movable/fov_holder/fov
	var/current_fov_size = list(15, 15)
	var/angle = 0
	var/rot_scale = 1 //used in the shadow cone transform Turn() calculations.
	var/shadow_angle = FOV_90_DEGREES
	var/image/shadow_mask //what masks the environment from our sight.
	var/image/visual_shadow //the visual, found on the WALL_PLANE plane.
	var/image/owner_mask //This will mask the shadow cone mask, so it won't mask the user.
	var/list/nested_locs = list() //To ensure the above mask assumes the right shape when inside a locker, mech, vehicle etcetera.
	var/static/list/width_n_height_offsets = list() //because render sources are automatically centered unlike most mapped visuals.

/datum/component/vision_cone/Initialize(fov_type = FOV_90_DEGREES, _angle = 0)
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE
	angle = _angle
	shadow_angle = fov_type

/datum/component/vision_cone/RegisterWithParent()
	. = ..()
	var/mob/M = parent
	if(M.client)
		generate_fov_holder(M, angle)
	RegisterSignal(M, COMSIG_MOB_CLIENT_LOGIN, .proc/on_mob_login)
	RegisterSignal(M, COMSIG_MOB_CLIENT_LOGOUT, .proc/on_mob_logout)
	RegisterSignal(M, COMSIG_MOB_GET_VISIBLE_MESSAGE, .proc/on_visible_message)
	RegisterSignal(M, COMSIG_MOB_EXAMINATE, .proc/on_examinate)
	RegisterSignal(M, COMSIG_MOB_VISIBLE_ATOMS, .proc/on_visible_atoms)
	RegisterSignal(M, COMSIG_MOB_CLIENT_CHANGE_VIEW, .proc/on_change_view)
	RegisterSignal(M, COMSIG_MOB_RESET_PERSPECTIVE, .proc/on_reset_perspective)
	RegisterSignal(M, COMSIG_MOB_IS_VIEWER, .proc/is_viewer)

/datum/component/vision_cone/UnregisterFromParent()
	. = ..()
	var/mob/M = parent
	if(!QDELETED(fov))
		if(M.client)
			UnregisterSignal(M, list(COMSIG_ATOM_DIR_CHANGE, COMSIG_MOVABLE_MOVED, COMSIG_MOB_DEATH, COMSIG_LIVING_REVIVE))
			M.client.images -= owner_mask
			M.client.images -= shadow_mask
			M.client.images -= visual_shadow
		QDEL_NULL(fov)
		QDEL_NULL(owner_mask)
	if(length(nested_locs))
		UNREGISTER_NESTED_LOCS(nested_locs, COMSIG_MOVABLE_MOVED, 1)
	UnregisterSignal(M, list(COMSIG_MOB_CLIENT_LOGIN, COMSIG_MOB_CLIENT_LOGOUT,
							COMSIG_MOB_GET_VISIBLE_MESSAGE, COMSIG_MOB_EXAMINATE,
							COMSIG_MOB_VISIBLE_ATOMS, COMSIG_MOB_RESET_PERSPECTIVE,
							COMSIG_MOB_CLIENT_CHANGE_VIEW, COMSIG_MOB_IS_VIEWER))

/datum/component/vision_cone/proc/generate_fov_holder(mob/M, _angle = 0)
	if(QDELETED(fov))
		fov = new(get_turf(M))
		fov.icon_state = "[shadow_angle]"
		fov.dir = M.dir
		shadow_mask = image('icons/misc/field_of_vision.dmi', fov, "[shadow_angle]", FIELD_OF_VISION_LAYER)
		shadow_mask.override = TRUE
		shadow_mask.plane = FIELD_OF_VISION_PLANE
		visual_shadow = image('icons/misc/field_of_vision.dmi', fov, "[shadow_angle]_v", FIELD_OF_VISION_LAYER)
		visual_shadow.plane = WALL_PLANE
		owner_mask = new(loc = M)
		owner_mask.appearance_flags = RESET_TRANSFORM
		owner_mask.plane = FIELD_OF_VISION_BLOCKER_PLANE
		if(_angle)
			rotate_shadow_cone(_angle)
	fov.alpha = M.stat == DEAD ? 0 : 255
	RegisterSignal(M, COMSIG_MOB_DEATH, .proc/hide_fov)
	RegisterSignal(M, COMSIG_LIVING_REVIVE, .proc/show_fov)
	RegisterSignal(M, COMSIG_ATOM_DIR_CHANGE, .proc/on_dir_change)
	RegisterSignal(M, COMSIG_MOVABLE_MOVED, .proc/on_mob_moved)
	var/atom/A = M
	if(!isturf(M.loc))
		REGISTER_NESTED_LOCS(M, nested_locs, COMSIG_MOVABLE_MOVED, .proc/on_loc_moved)
		A = nested_locs[nested_locs.len]
	CENTERED_RENDER_SOURCE(owner_mask, A, src)
	M.client.images += shadow_mask
	M.client.images += visual_shadow
	M.client.images += owner_mask
	if(M.client.view != "[current_fov_size[1]]x[current_fov_size[2]]")
		resize_fov(current_fov_size, getviewsize(M.client.view))

/datum/component/vision_cone/proc/rotate_shadow_cone(new_angle)
	var/simple_degrees = SIMPLIFY_DEGREES(new_angle - angle)
	var/to_scale = cos(simple_degrees) * sin(simple_degrees)
	if(to_scale)
		var/old_rot_scale = rot_scale
		rot_scale = 1 + to_scale
		if(old_rot_scale != rot_scale)
			visual_shadow.transform = shadow_mask.transform = shadow_mask.transform.Scale(rot_scale/old_rot_scale)
	visual_shadow.transform = shadow_mask.transform = shadow_mask.transform.Turn(fov.transform, simple_degrees)

/datum/component/vision_cone/proc/resize_fov(list/old_view, list/view)
	current_fov_size = view
	var/old_size = max(old_view[1], old_view[2])
	var/new_size = max(view[1], view[2])
	if(old_size == new_size) //longest edges are still of the same length.
		return
	visual_shadow.transform = shadow_mask.transform = shadow_mask.transform.Scale(new_size/old_size)

/datum/component/vision_cone/proc/on_mob_login(mob/source, client/client)
	generate_fov_holder(source, angle)

/datum/component/vision_cone/proc/on_mob_logout(mob/source, client/client)
	UnregisterSignal(source, list(COMSIG_ATOM_DIR_CHANGE, COMSIG_MOVABLE_MOVED, COMSIG_MOB_DEATH, COMSIG_LIVING_REVIVE))
	if(length(nested_locs))
		UNREGISTER_NESTED_LOCS(nested_locs, COMSIG_MOVABLE_MOVED, 1)

/datum/component/vision_cone/proc/on_dir_change(mob/source, old_dir, new_dir)
	fov.dir = new_dir

/// This only affects the screen visuals, not the functionality.
/datum/component/vision_cone/proc/hide_fov(mob/source)
	fov.alpha = 0

/// Same as above.
/datum/component/vision_cone/proc/show_fov(mob/source)
	fov.alpha = 255

/// Idem.
/datum/component/vision_cone/proc/on_reset_perspective(mob/source, atom/target)
	if(source.client.eye == source || source.client.eye == source.loc)
		fov.alpha = 255
	else
		fov.alpha = 0

/datum/component/vision_cone/proc/on_change_view(mob/source, client, list/old_view, list/view)
	resize_fov(old_view, view)

/datum/component/vision_cone/proc/on_mob_moved(mob/source, atom/oldloc, dir, forced)
	fov.forceMove(get_turf(source), harderforce = TRUE)
	if(!isturf(source.loc)) //Recalculate all nested locations.
		UNREGISTER_NESTED_LOCS( nested_locs, COMSIG_MOVABLE_MOVED, 1)
		REGISTER_NESTED_LOCS(source, nested_locs, COMSIG_MOVABLE_MOVED, .proc/on_loc_moved)
		var/atom/A = nested_locs[nested_locs.len]
		CENTERED_RENDER_SOURCE(owner_mask, A, src)
	else if(length(nested_locs))
		UNREGISTER_NESTED_LOCS(nested_locs, COMSIG_MOVABLE_MOVED, 1)
		CENTERED_RENDER_SOURCE(owner_mask, source, src)

/datum/component/vision_cone/proc/on_loc_moved(atom/source, atom/oldloc, dir, forced)
	if(isturf(source.loc) && isturf(oldloc)) //This is the case of the topmost movable loc moving around the world, skip.
		return
	if(nested_locs[nested_locs.len] != source)
		UNREGISTER_NESTED_LOCS(nested_locs, COMSIG_MOVABLE_MOVED, nested_locs.Find(source) + 1)
	REGISTER_NESTED_LOCS(source, nested_locs, COMSIG_MOVABLE_MOVED, .proc/on_loc_moved)
	var/atom/A = nested_locs[nested_locs.len]
	CENTERED_RENDER_SOURCE(owner_mask, A, src)

#undef CENTERED_RENDER_SOURCE
#undef REGISTER_NESTED_LOCS
#undef UNREGISTER_NESTED_LOCS

//Byond doc is not entirely correct on the integrated arctan() proc.
//When both x and y are negative, the output is also negative, cycling clockwise instead of counter-clockwise.
//That's also why I have to use the SIMPLIFY_DEGREES macro.
#define FOV_ANGLE_CHECK(mob, target, zero_x_y_statement, success_statement) \
	var/turf/T1 = get_turf(target);\
	var/turf/T2 = get_turf(mob);\
	var/_x = (T1.x - T2.x);\
	var/_y = (T1.y - T2.y);\
	if(!_x && !_y){\
		zero_x_y_statement;\
	}\
	var/dir = (mob.dir & (EAST|WEST)) || mob.dir;\
	var/_degree = -angle;\
	var/_half = shadow_angle/2;\
	switch(dir){\
		if(EAST){\
			_degree += 180;\
		}\
		if(NORTH){\
			_degree += 270;\
		}\
		if(SOUTH){\
			_degree += 90;\
		}\
	}\
	var/_min = SIMPLIFY_DEGREES(_degree - _half);\
	var/_max = SIMPLIFY_DEGREES(_degree + _half);\
	if((_min > _max) ? !ISINRANGE(SIMPLIFY_DEGREES(arctan(_x, _y)), _max, _min) : ISINRANGE(SIMPLIFY_DEGREES(arctan(_x, _y)), _min, _max)){\
		success_statement;\
	}

/datum/component/vision_cone/proc/on_examinate(mob/source, atom/target)
	if(fov.alpha)
		FOV_ANGLE_CHECK(source, target, return, return COMPONENT_DENY_EXAMINATE|COMPONENT_EXAMINATE_BLIND)

/datum/component/vision_cone/proc/on_visible_message(mob/source, atom/target, message, range, list/ignored_mobs)
	if(fov.alpha)
		FOV_ANGLE_CHECK(source, target, return, return COMPONENT_NO_VISIBLE_MESSAGE)

/datum/component/vision_cone/proc/on_visible_atoms(mob/source, list/atoms)
	for(var/k in atoms)
		var/atom/A = k
		FOV_ANGLE_CHECK(source, A, continue, atoms -= A)

/datum/component/vision_cone/proc/is_viewer(mob/source, atom/center, depth, list/viewers_list)
	FOV_ANGLE_CHECK(source, center, return, viewers_list -= source)

#undef FOV_ANGLE_CHECK

/atom/movable/fov_holder //required for mouse opacity.
	name = "field of vision holder"
	pixel_x = -224 //the image is about 480x480 px, ergo 15 tiles (480/32) big, we gotta center it.
	pixel_y = -224
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = FIELD_OF_VISION_PLANE
	anchored = TRUE

/atom/movable/fov_holder/ConveyorMove()
	return

/atom/movable/fov_holder/has_gravity(turf/T)
	return FALSE

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
