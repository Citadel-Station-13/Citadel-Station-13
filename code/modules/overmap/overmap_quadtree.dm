/// Quadtree automatically sections when there's more than this many objects in it
#define OVERMAP_QUADTREE_DIVIDE_THRESHOLD 4
/// Quadtree will not go deeper than this.
#define OVERMAP_QUADTREE_MAX_DEPTH 16
/**
  * Overmap quadtree datums for storing objects and efficient-ish collision detection
  */
/datum/overmap_quadtree
	/// Our parent, if it exists. If it doesn't, we're the head of the tree.
	var/datum/overmap_quadtree/parent

	var/datum/overmap_quadtree/topleft
	var/datum/overmap_quadtree/topright
	var/datum/overmap_quadtree/bottomleft
	var/datum/overmap_quadtree/bottomright

	/// If this is set, this means this node is storing objects instead of being divided into more nodes.
	var/list/datum/overmap_object/objects

	/// How deep we are
	var/depth

	// Variables for the space we govern
	var/minx
	var/miny
	var/maxx
	var/maxy

/datum/overmap_quadtree(datum/overmap_quadtree/parent, minx, miny, maxx, maxy)
	src.minx = minx
	src.miny = miny
	src.maxx = maxx
	src.maxy = maxy
	if(parent)
		depth = parent.depth + 1
		src.parent = parent
	else if(minx >= maxx || miny >= maxy)
			CRASH("Improper quadtree creation.")
	objects = list()
	topleft = null
	topright = null
	bottomleft = null
	bottomright = null

/datum/overmap_quadtree/proc/insert(datum/overmap_object/O)
	if(O.pos_x < minx || O.pos_x > maxx || O.pos_y < miny || O.pos_y > maxy)
		CRASH("Out of bounds insert")
	objects? directInsert(O) : treeInsert(O)

/datum/overmap_quadtree/proc/construct_tree()
	var/midx = maxx - minx
	var/midy = maxy - miny
	bottomleft = new /datum/overmap_quadtree(src, minx, miny, midx, midy)
	topleft = new /datum/overmap_quadtree(src, minx, midy, midx, maxy)
	bottomright = new /datum/overmap_quadtree(src, midx, miny, maxx, midy)
	topright = new /datum/overmap_quadtree(src, midx, midy, maxx, maxy)

/datum/overmap_quadtree/proc/treeInsert(datum/overmap_object/O)
	if(O.pos_x < (maxx - minx))
		if(O.pos_y < (maxy - miny))
			bottomleft.insert(O)
		else
			topleft.insert(O)
	else
		if(O.pos_y < (maxy - miny))
			bottomright.insert(O)
		else
			topright.insert(O)

/datum/overmap_quadtree/proc/directInsert(datum/overmap_object/O)
	if(length(objects) < OVERMAP_QUADTREE_DIVIDE_THRESHOLD)
		objects += O
		return
	var/list/O = objects
	objects = null
	construct_tree()
	for(var/i in O)
		insert(i)
