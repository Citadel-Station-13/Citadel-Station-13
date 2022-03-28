// /turf/turf_construct_flags
/// Can make lattice on this with rods
#define TURF_CONSTRUCT_ROD_LATTICE			(1<<0)
/// Can make catwalk on this with rods from lattice
#define TURF_CONSTRUCT_ROD_CATWALK			(1<<1)
/// Can make plating on this with tile from lattice or catwalk
#define TURF_CONSTRUCT_TILE_PLATING			(1<<2)
/// Can make plating on this by just using tile
#define TURF_CONSTRUCT_TILE_PLATING_DIRECT	(1<<3)
/// Can make plating on this using a RCD
#define TURF_CONSTRUCT_RCD_PLATING			(1<<4)
/// Can interact with construction from below
#define TURF_CONSTRUCT_ALLOW_FROM_UNDER		(1<<5)
/// Can interact with deconstruction from below
#define TURF_DECONSTRUCT_ALLOW_FROM_UNDER	(1<<6)
/// Can tear this down with a rcd
#define TURF_DECONSTRUCT_RCD_TEARDOWN		(1<<7)
/// Can do the plating-catwalk-lattice constructions
#define TURF_CONSTRUCT_FLAGS_PLATING_OVER			(TURF_CONSTRUCT_ROD_LATTICE | TURF_CONSTRUCT_ROD_CATWALK | TURF_CONSTRUCT_TILE_PLATING | TURF_CONSTRUCT_ALLOW_FROM_UNDER)
/// can do all current construction actions
#define TURF_CONSTRUCT_FLAGS_SANDBOX				(TURF_CONSTRUCT_ROD_LATTICE | TURF_CONSTRUCT_ROD_CATWALK | TURF_CONSTRUCT_TILE_PLATING | TURF_CONSTRUCT_ALLOW_FROM_UNDER | TURF_CONSTRUCT_RCD_PLATING | DECONSTRUCT_RCD_TEARDOWN | TURF_DECONSTRUCT_ALLOW_FROM_UNDER)

// /turf/z_flags
/// Allow air passage through top
#define Z_AIR_UP			(1<<0)
/// Allow air passage through bottom
#define Z_AIR_DOWN			(1<<1)
/// Allow atom movement through top
#define Z_OPEN_UP			(1<<2)
/// Allow atom movement through bottom
#define Z_OPEN_DOWN			(1<<3)
/// Considered open - below turfs will get the openspace overlay if so
#define Z_CONSIDERED_OPEN	(1<<4)
