#define TURF_IS_MIMICKING(T) (isturf(T) && (T:zm_flags & ZM_MIMIC_BELOW))
#define CHECK_OO_EXISTENCE(OO) if (OO && !TURF_IS_MIMICKING(OO.loc)) { qdel(OO); }
#define UPDATE_OO_IF_PRESENT CHECK_OO_EXISTENCE(bound_overlay); if (bound_overlay) { update_above(); }

// Turf MZ flags.
#define ZM_MIMIC_BELOW     	(1<<0)	//! If this turf should mimic the turf on the Z below.
#define ZM_MIMIC_OVERWRITE 	(1<<1)	//! If this turf is Z-mimicking, overwrite the turf's appearance instead of using a movable. This is faster, but means the turf cannot have its own appearance (say, edges or a translucent sprite).
#define ZM_NO_OCCLUDE     	(1<<2)	//! Don't occlude below atoms if we're a non-mimic z-turf.

// Movable flags.
#define ZMM_IGNORE 1	//! Do not copy this movable.
#define ZMM_MANGLE_PLANES  2	//! Check this movable's overlays/underlays for explicit plane use and mangle for compatibility with Z-Mimic. If you're using emissive overlays, you probably should be using this flag. Expensive, only use if necessary.
