// the clamps are just sanity checks.
/// Efficiency scaling for stock part level to material usage. All code concerning lathing and production from raw material sheet should be using this.
#define STANDARD_PART_LEVEL_LATHE_COEFFICIENT(level)		clamp(1 - (level * 0.1), 0, 1)
/// Efficiency scaling for stock part level to ore factor. All code concerning lathing and production from raw ores to raw material sheets should be using this.
#define STANDARD_PART_LEVEL_ORE_COEFFICIENT(level)			clamp(1 + (level * 0.125), 1, 10)
