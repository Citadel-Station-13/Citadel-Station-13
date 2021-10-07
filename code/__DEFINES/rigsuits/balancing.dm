/**
 * Rigsuit balancing paradigm:
 *
 * Slots/sizes act as complexity per piece.
 * Weight is an additional balancer for very powerful gear and storage.
 * Armor, thermal plating, pressure plating are all "RIG_ZONE_ALL" pieces, meaning they cost slots/size on every piece.
 *
 * SIZES:
 * Offensive/defensive capabilities should be balanced via sizes. Heavy armor in addition to any weight penalties have a large size.
 * Weapons will also require larger than average size.
 * Utility modules shouldn't require much size at all - the goal is to make rigs not require backpacks, after all.
 *
 * SLOTS:
 * "Master of all trades" rigsuits are kneecapped by slots.
 * Powerful, primary departmental modules like RCDs, kinetic glaives, chemical injector-synthesizers, and anything as powerful as that should
 * cost enough slots to not allow more than 2-3 per RIG.
 * Smaller time jack of all trade toolsets like the toolset-implant equivalent/power tools, etc, will require a medium amount of slots
 * Misc items like a weak prybar for getting around depowered airlocks will require minimal slots
 *
 * **STORAGE**, once implemented, will require large amounts of slots and weight, as it is the equivalent to allowing one to bypass this system entirely while wearing a RIG by carrying their own gear.
 */

// Slots
/// Default slots available per piece
#define DEFAULT_SLOTS_AVAILABLE			20

// Sizes
/// Default max size per piece
#define DEFAULT_SIZE_AVAILABLE			10

// Weight

// Weight amounts on modules/armor/exception
/// No weight.
#define RIGSUIT_WEIGHT_NONE			0
/// Low weight items
#define RIGSUIT_WEIGHT_LOW			10
/// Medium weight items
#define RIGSUIT_WEIGHT_MEDIUM		30
/// High weight items
#define RIGSUIT_WEIGHT_HIGH			50
/// Extremely bulky items
#define RIGSUIT_WEIGHT_EXTREME		70

// Weight thresholds
/// Threshold at which the user is slowed down
#define RIGSUIT_WEIGHT_SLOWDOWN_THRESHOLD	50
/// Divisor for slowdown per weight post threshold
#define RIGSUIT_WEIGHT_SLOWDOWN_DIVISOR		50
