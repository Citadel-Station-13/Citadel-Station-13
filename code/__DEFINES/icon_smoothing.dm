/* smoothing_flags */
/// Smoothing system in where adjacencies are calculated and used to build an image by mounting each corner at runtime.
#define SMOOTH_CORNERS (1<<0)
/// Smoothing system in where adjacencies are calculated and used to select a pre-baked icon_state, encoded by bitmasking.
#define SMOOTH_BITMASK (1<<1)
/// Atom has diagonal corners, with underlays under them.
#define SMOOTH_DIAGONAL_CORNERS (1<<2)
/// Atom will smooth with the borders of the map.
#define SMOOTH_BORDER (1<<3)
/// Atom is currently queued to smooth.
#define SMOOTH_QUEUED (1<<4)
/// Smooths with objects, and will thus need to scan turfs for contents.
#define SMOOTH_OBJ (1<<5)

DEFINE_BITFIELD(smoothing_flags, list(
	"SMOOTH_CORNERS" = SMOOTH_CORNERS,
	"SMOOTH_BITMASK" = SMOOTH_BITMASK,
	"SMOOTH_DIAGONAL_CORNERS" = SMOOTH_DIAGONAL_CORNERS,
	"SMOOTH_BORDER" = SMOOTH_BORDER,
	"SMOOTH_QUEUED" = SMOOTH_QUEUED,
	"SMOOTH_OBJ" = SMOOTH_OBJ,
))

//Redefinitions of the diagonal directions so they can be stored in one var without conflicts
#define NORTH_JUNCTION NORTH //(1<<0)
#define SOUTH_JUNCTION SOUTH //(1<<1)
#define EAST_JUNCTION EAST  //(1<<2)
#define WEST_JUNCTION WEST  //(1<<3)
#define NORTHEAST_JUNCTION (1<<4)
#define SOUTHEAST_JUNCTION (1<<5)
#define SOUTHWEST_JUNCTION (1<<6)
#define NORTHWEST_JUNCTION (1<<7)

DEFINE_BITFIELD(smoothing_junction, list(
	"NORTH_JUNCTION" = NORTH_JUNCTION,
	"SOUTH_JUNCTION" = SOUTH_JUNCTION,
	"EAST_JUNCTION" = EAST_JUNCTION,
	"WEST_JUNCTION" = WEST_JUNCTION,
	"NORTHEAST_JUNCTION" = NORTHEAST_JUNCTION,
	"SOUTHEAST_JUNCTION" = SOUTHEAST_JUNCTION,
	"SOUTHWEST_JUNCTION" = SOUTHWEST_JUNCTION,
	"NORTHWEST_JUNCTION" = NORTHWEST_JUNCTION,
))

/*smoothing macros*/

#define QUEUE_SMOOTH(thing_to_queue) if(thing_to_queue.smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK)) {SSicon_smooth.add_to_queue(thing_to_queue)}

#define QUEUE_SMOOTH_NEIGHBORS(thing_to_queue) for(var/neighbor in orange(1, thing_to_queue)) {var/atom/atom_neighbor = neighbor; QUEUE_SMOOTH(atom_neighbor)}

#define IS_SMOOTH(atom)	(atom.smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK))

/**SMOOTHING GROUPS
 * Groups of things to smooth with.
 * * Contained in the `list/smoothing_groups` variable.
 * * Matched with the `list/can_smooth_with` variable to check whether smoothing is possible or not.
 */

#define S_TURF(num) ((24 * 0) + num) //Not any different from the number itself, but kept this way in case someone wants to expand it by adding stuff before it.
/* /turf only */
#define SMOOTH_GROUP_WALL_GOLD			S_TURF(1)
#define SMOOTH_GROUP_WALL_MATERIAL		S_TURF(2)
#define SMOOTH_GROUP_WALL_TITANIUM		S_TURF(3)
#define SMOOTH_GROUP_WALL_DIAMOND		S_TURF(4)
#define SMOOTH_GROUP_WALL_SILVER		S_TURF(5)
#define SMOOTH_GROUP_WALL_WOOD			S_TURF(6)
#define SMOOTH_GROUP_WALL_URANIUM		S_TURF(7)
#define SMOOTH_GROUP_WALL_STEEL			S_TURF(8)
#define SMOOTH_GROUP_WALL_PLASTEEL		S_TURF(9)
#define SMOOTH_GROUP_WALL_PLASMA		S_TURF(10)
#define SMOOTH_GROUP_ALLEYWAY			S_TURF(11)
#define SMOOTH_GROUP_WALL_BRICK			S_TURF(12)
#define SMOOTH_GROUP_WALL_BRICK_NORMAL	S_TURF(13)
#define SMOOTH_GROUP_ROAD				S_TURF(14)
#define SMOOTH_GROUP_FLOOR_LAVA			S_TURF(13)
#define SMOOTH_GROUP_WALL_ALIEN			S_TURF(16)
#define SMOOTH_GROUP_WALL_CLOCKWORK		S_TURF(17)
#define SMOOTH_GROUP_WALL_METALLIC		S_TURF(18)
#define SMOOTH_GROUP_WALL_BANANIUM		S_TURF(19)
#define SMOOTH_GROUP_WALL_SANDSTONE		S_TURF(20)
#define SMOOTH_GROUP_WALL_WOOD			S_TURF(21)
#define SMOOTH_GROUP_WALL_TITANIUM		S_TURF(22)
#define SMOOTH_GROUP_WALL_PLASTITANIUM	S_TURF(23)
#define SMOOTH_GROUP_CARPET_RED			S_TURF(24)
#define SMOOTH_GROUP_CARPET_BLUE		S_TURF(25)
#define SMOOTH_GROUP_CARPET_GREEN		S_TURF(26)
#define SMOOTH_GROUP_CARPET_ORANGE		S_TURF(27)
#define SMOOTH_GROUP_CARPET_PURPLE		S_TURF(28)
#define SMOOTH_GROUP_CARPET_CYAN		S_TURF(29)
#define SMOOTH_GROUP_CARPET_ROYALBLACK	S_TURF(30)
#define SMOOTH_GROUP_CARPET_ROYALBLUBE	S_TURF(31)
#define SMOOTH_GROUP_CARPET_BLACK		S_TURF(32)

#define MAX_S_TURF SMOOTH_GROUP_WALL_PLASTITANIUM //Always match this value with the one above it.

#define S_OBJ(num) (MAX_S_TURF + 1 + num)
/* /obj included */
#define SMOOTH_GROUP_XENO_WEEDS			S_OBJ(1)
#define SMOOTH_GROUP_SANDBAG			S_OBJ(2)

#define SMOOTH_GROUP_FALSEWALL			S_OBJ(4)
#define SMOOTH_GROUP_LATTICE			S_OBJ(5)
#define SMOOTH_GROUP_CATWALK			S_OBJ(6)
#define SMOOTH_GROUP_TABLE_NORMAL		S_OBJ(7)
#define SMOOTH_GROUP_WINDOW_NORMAL		S_OBJ(8)
#define SMOOTH_GROUP_TABLE_GLASS		S_OBJ(9)
#define SMOOTH_GROUP_TABLE_METAL		S_OBJ(10)
#define SMOOTH_GROUP_TABLE_ALIEN		S_OBJ(11)


#define SMOOTH_GROUP_SHUTTLE_HEATER		S_OBJ(14)
#define SMOOTH_GROUP_WINDOW_SHUTTLE		S_OBJ(15)
#define SMOOTH_GROUP_TABLE_PLASMAGLASS	S_OBJ(16)

#define MAX_S_OBJ SMOOTH_GROUP_TABLE_PLASMAGLASS //Always match this value with the one above it.

#define S_ABSTRACT(num) (MAX_S_OBJ + 1 + num)
/* These are for "categories". */

#define SMOOTH_GROUP_WALL					S_ABSTRACT(1)		// all walls should have this. all walls should not necessarily smooth to this.
#define SMOOTH_GROUP_FLOOR					S_ABSTRACT(2)
#define SMOOTH_GROUP_WINDOW					S_ABSTRACT(3)		// all fulltile windows should have this. all fulltile windows should not necessarily smooth to this.
#define SMOOTH_GROUP_TABLE					S_ABSTRACT(4)		// all tables should have this. all tables should not necessarily smooth to this.
#define SMOOTH_GROUP_CLOCKCULT				S_ABSTRACT(5)		// all clockcult objects should have this. all clockcult objects should not necessarily smooth to this.
#define SMOOTH_GROUP_SHUTTLE_EXTERIOR		S_ABSTRACT(6)
#define SMOOTH_GROUP_SURVIVAL_POD_EXTERIOR	S_ABSTRACT(7)
#define SMOOTH_GROUP_ABDUCTOR				S_ABSTRACT(8)
#define SMOOTH_GROUP_AIRLOCK				S_ABSTRACT(9)
#define SMOOTH_GROUP_XENO_STRUCTURAL		S_ABSTRACT(10)
#define SMOOTH_GROUP_CARPET					S_ABSTRACT(11)

#define MAX_S_ABSTRACT						SMOOTH_GROUP_XENO_STRUCTURAL // always match this value with the one above it.

#warn get all currenet groups in, update max's.
