#define FOV_90_DEGREES	90
#define FOV_180_DEGREES	180
#define FOV_270_DEGREES	270

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
	RegisterSignal(M, COMSIG_MOB_CLIENT_CHANGE_VIEW, .proc/on_change_view)
	RegisterSignal(M, COMSIG_ATOM_DIR_CHANGE, .proc/on_dir_change)
	RegisterSignal(M, COMSIG_MOVABLE_MOVED, .proc/on_mob_moved)
	RegisterSignal(M, COMSIG_MOB_GET_VISIBLE_MESSAGE, .proc/on_visible_message)
	RegisterSignal(M, COMSIG_MOB_EXAMINATE, .proc/on_examinate)
	RegisterSignal(M, COMSIG_MOB_VISIBLE_ATOMS, .proc/on_visible_atoms)

/datum/component/vision_cone/UnregisterFromParent()
	. = ..()
	var/mob/M = parent
	if(!QDELETED(fov))
		if(M.client)
			M.client.images -= owner_mask
			M.client.images -= shadow_mask
			M.client.images -= visual_shadow
		QDEL_NULL(fov)
	UnregisterSignal(M, list(COMSIG_MOB_CLIENT_LOGIN, COMSIG_MOB_CLIENT_CHANGE_VIEW,
							COMSIG_ATOM_DIR_CHANGE, COMSIG_MOVABLE_MOVED,
							COMSIG_MOB_GET_VISIBLE_MESSAGE, COMSIG_MOB_EXAMINATE, COMSIG_MOB_VISIBLE_ATOMS))

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
		owner_mask.pixel_x -= initial(M.pixel_x) //usually the case of critters with icons larger than 32x32
		owner_mask.pixel_y -= initial(M.pixel_y) //Idem.
		if(!M.render_target)
			M.render_target = ref(M)
		owner_mask.render_source = M.render_target
		if(_angle)
			rotate_shadow_cone(_angle)
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

/datum/component/vision_cone/proc/on_mob_moved(mob/source, atom/oldloc, dir, forced)
	fov?.forceMove(get_turf(source), harderforce = TRUE)

/datum/component/vision_cone/proc/on_dir_change(mob/source, old_dir, new_dir)
	if(fov)
		fov.dir = new_dir

/datum/component/vision_cone/proc/on_change_view(mob/source, client, list/old_view, list/view)
	resize_fov(old_view, view)

//Byond doc is not entirely correct on the integrated arctan() proc.
//When both x and y are negative, the output is also negative, cycling clockwise instead of counter-clockwise.
//That's also why I have to use the SIMPLIFY_DEGREES macro.
#define FOV_ANGLE_CHECK(mob, target, value) \
	var/turf/T1 = get_turf(target);\
	var/turf/T2 = get_turf(mob);\
	var/_x = (T1.x - T2.x);\
	var/_y = (T1.y - T2.y);\
	if(!_x && !_y){\
		return;\
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
		};\
	}\
	var/_min = SIMPLIFY_DEGREES(_degree - _half);\
	var/_max = SIMPLIFY_DEGREES(_degree + _half);\
	if((_min > _max) ? !ISINRANGE(SIMPLIFY_DEGREES(arctan(_x, _y)), _max, _min) : ISINRANGE(SIMPLIFY_DEGREES(arctan(_x, _y)), _min, _max)){\
		return value;\
	}

/datum/component/vision_cone/proc/on_examinate(mob/source, atom/target)
	FOV_ANGLE_CHECK(source, target, COMPONENT_DENY_EXAMINATE|COMPONENT_EXAMINATE_BLIND)

/datum/component/vision_cone/proc/on_visible_message(mob/source, atom/target, message, range, list/ignored_mobs)
	FOV_ANGLE_CHECK(source, target, COMPONENT_NO_VISIBLE_MESSAGE)

/datum/component/vision_cone/proc/on_visible_atoms(mob/source, list/atoms)
	for(var/k in atoms)
		var/atom/A = k
		var/turf/T1 = get_turf(A)
		var/turf/T2 = get_turf(source)
		var/_x = (T1.x - T2.x)
		var/_y = (T1.y - T2.y)
		if(!_x && !_y)
			continue
		var/dir = (source.dir & (EAST|WEST)) || source.dir
		var/degree = -angle
		var/half = shadow_angle/2
		switch(dir)
			if(EAST)
				degree += 180
			if(NORTH)
				degree += 270
			if(SOUTH)
				degree += 90
		var/min = SIMPLIFY_DEGREES(degree - half);\
		var/max = SIMPLIFY_DEGREES(degree + half);\
		var/arctan = SIMPLIFY_DEGREES(arctan(_x, _y))
		if((min > max) ? !ISINRANGE(arctan, max, min) : ISINRANGE(arctan, min, max))
			atoms -= A

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
