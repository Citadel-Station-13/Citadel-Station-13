/**
  * Overmap datums
  */
/datum/overmap
	/// Width
	var/width = 512
	/// Height
	var/height = 512

	/// Wraparound
	var/wraparound = TRUE

	/// All objects on this
	var/list/datum/overmap_object/objects
	/// Objects with non-static considered positions on this
	var/list/datum/overmap_object/dynamic_objects

	/// Head of our quadtree structure
	var/datum/overmap_quadtree/tree_head

	/// Current UUID
	var/current_uuid = 1

	/// Open UIs looking at us
	var/list/datum/tgui/open_uis

/datum/overmap/New(width = 512, height = 512)
	src.width = width
	src.height = height
	objects = list()
	dynamic_objects = list()
	open_uis = list()
	regenerate_tree()
	START_PROCESSING(SSovermaps, src)

/datum/overmap/Destroy()
	for(var/i in objects)
		var/datum/overmap_object/O = i
		remove_object(O)
	QDEL_NULL(tree_head)
	open_uis = null
	STOP_PROCESSING(SSovermaps, src)
	return ..()

/datum/overmap/proc/regenerate_tree()
	qdel(tree_head)
	tree_head = new(null, 0, 0, width, height)
	for(var/i in objects)
		var/datum/overmap_object/O = i
		tree_head.insert(O)

/datum/overmap/proc/insert_object(datum/overmap_object/O)
	ASSERT(!O.containing_overmap)
	objects += O
	if(!O.position_considered_static)
		dynamic_objects += O
	O.ui_id = current_uuid++
	push_ui_update_event(O)
	O.containing_overmap = src
	return tree_head.insert(O)

/datum/overmap/proc/remove_object(datum/overmap_object/O)
	objects -= O
	dynamic_objects -= O
	O.ui_id = null
	push_ui_deletion_event(O)
	tree_head.remove(O)

/**
  * Return mob-agnostic ui static data.
  */
/datum/overmap/proc/overmap_ui_static_data()
	. = list()
	.["width"] = width
	.["height"] = height
	var/list/datum/overmap_object/static_objects = objects - dynamic_objects
	var/datum/overmap_object/O
	for(var/i in static_objects)
		O = i
		.[O.UUID()] = O.ui_encode()

/**
  * Return mob-agnostic ui data.
  */
/datum/overmap/proc/overmap_ui_data()
	. = list()
	var/datum/overmap_object/O
	for(var/i in dynamic_objects)
		O = i
		.["[O.UUID()]"] = O.ui_encode()

/datum/overmap/process()
	update_uis()

/**
  * We do not want to be synced to tgui timing, we use our own timing.
  */
/datum/overmap/proc/update_uis()
	for(var/i in open_uis)
		var/datum/tgui/ui = i

